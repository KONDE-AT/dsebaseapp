xquery version "3.1";

(:~
 : This module contains functions needed for tokenization and lemmatization of TEI files.
 :  Be aware that this module does NOT provide any nlp-functionality by itself but it eases the interaction
 : between NLP-Web-Services and TEI-Docs stored in eXist-db
 : @author Peter Andorfer
:)

module namespace nlp="http://www.digital-archiv.at/ns/nlp";

import module namespace functx = "http://www.functx.com";
import module namespace httpclient ="http://exist-db.org/xquery/httpclient";
import module namespace util = "http://exist-db.org/xquery/util";
import module namespace xmldb = "http://exist-db.org/xquery/xmldb";


declare namespace output="http://www.w3.org/2010/xslt-xquery-serialization";
declare namespace tei="http://www.tei-c.org/ns/1.0";

declare variable $nlp:customTokenizer :="https://xtx.acdh.oeaw.ac.at/exist/restxq/xtx/tokenize";

declare variable $nlp:lemmatizerEndpoint :=
xs:anyURI("https://spacyapp.acdh.oeaw.ac.at/query/lemma/?token=");

declare variable $nlp:posTaggerEndpoint :=
xs:anyURI("https://spacyapp.acdh.oeaw.ac.at/query/jsonparser-api/");

declare variable $nlp:serialiserParams :=
        <output:serialization-parameters>
          <output:omit-xml-declaration value="yes"/>
          <output:expand-xincludes value="no"/>
          <output:method value="xml"/>
          <output:encoding value="utf-8"/>
        </output:serialization-parameters>;

declare function nlp:custom-tokenizer($input as node(), $profile as xs:string) as item(){
  let $endpoint := xs:anyURI(string-join(($nlp:customTokenizer, $profile), '/'))
  let $request-headers :=
      <headers>
          <header name="Content-Type" value="application/xml"/>
          <header name="Accept" value="application/xml"/>
      </headers>
  let $request := httpclient:post(
          $endpoint, $input, true(), $request-headers
      )
  let $tei := $request
    return
      $tei
};

(:~
 : Sends a TEI-Document to the tokenizer web-service and stores the result
 : in 'db/apps/{app-name}/nlp/temp/{doc-name}'
 : @see https://xtx.acdh.oeaw.ac.at/
 :
 : @param $input An xml docuemnt which validates against the TEI-schema
 : @param $profile The identifier of the tokenization profile which should be used
 : @return The location of the stored tokenized document
:)

declare function nlp:custom-tokenize-and-save($input as node(), $profile as xs:string) as xs:string{
    let $collection-uri := '/db/apps/dsebaseapp/nlp/temp/'
    let $resource-name := util:document-name($input)
    let $tokenized := nlp:custom-tokenizer($input, $profile)
    where $tokenized//httpclient:body/*
    let $stored := xmldb:store($collection-uri, $resource-name, $tokenized//httpclient:body/*)
    return
        $stored
};

(:~
 : Bulk tonenizes all TEI-Documents found in the passed in collection
 :
 : @param $collection The URI of a collection to process
 : @param $profile The identifier of the tokenization profile which should be used
 : @return An XML-Node containing the paths to the stored tokenized files <result><item>{path/to/item}</item></result>
:)

declare function nlp:custom-bulk-tokenize($collection as xs:string, $profile as xs:string) as item(){
    let $result :=
    <result>{
        for $x in collection($collection)//tei:TEI
            let $wait := util:wait(1000)
            let $name := util:document-name($x)
            let $docUri := $collection||$name
            let $input := doc($docUri)
            let $tokenized := nlp:custom-tokenize-and-save($input, $profile)
                return
                    <item>{$tokenized}</item>
    }</result>
    return
        $result
};

(:~
 : Fetches all tei:w-tags and tei:pc
 :
 : @param $node A tokenized (tei:w-tags and tei:pc-tags) TEI document
 : @return An XML-node containing all w-tags and pc-tags and their zero-based index
:)

declare function nlp:fetch-text($input as node()){
    let $result :=
    <result>
        {
    for $word at $pos in $input//*[local-name() eq 'w' or local-name() eq 'pc']
        let $token := functx:trim(string-join($word//text(), ''))
        let $index := $pos - 1
        let $ws := if($word/following-sibling::tei:seg[1]) then true() else false()
        return
            <tokenArray>
                <value>{xs:string($token)}</value>
                <runningNr>{$index}</runningNr>
                <tokenId>{data($word/@xml:id)}</tokenId>
                <whitespace>{$ws}</whitespace>
            </tokenArray>
    }
        <language>german</language>
    </result>
    return
        $result
};

(:~
 : Fetches POS-Information from a web service and adds this information
 : as type-, lemma- and ana-attributes to the tei:w element
 :
 : @param $input A TEI document with tei:w tags ready for pos-tagging
 : @param $input a string denoting the language of the text (currently only 'de' works
 : @return The with POS-tags enriched tei:w element
:)


declare function nlp:pos-tagging-post($input as node(), $language as xs:string){
    let $request-headers :=
        <headers>
            <header name="Accept" value="application/json+acdhlang"/>
            <header name="Content-Type" value="application/json+acdhlang"/>
        </headers>
    let $words := nlp:fetch-text($input)
    let $parameters := 
        <output:serialization-parameters>
              <output:expand-xincludes value="no"/>
              <output:method value="json"/>
              <output:media-type value="text/javascript"/>
              <output:encoding value="utf-8"/>
            </output:serialization-parameters>
    let $payload := util:serialize($words, $parameters)
    let $request := httpclient:post(
          $nlp:posTaggerEndpoint, $payload, true(), $request-headers
      )
    let $json := try {
                util:base64-decode($request//httpclient:body/text())
            } catch * {
                false()
            }
    let $parsed := parse-json($json)('result')
    for $y in $parsed?*
        for $x in $y?('tokens')?*
            let $tokenId := $x('tokenId')
            let $type := $x('type')
            let $pos := $x('pos')
            let $lemma := $x('lemma')
            let $origNode := $input//tei:w[@xml:id=$tokenId]
            let $new := update insert attribute type {$type} into $origNode
            let $newer := update insert attribute lemma {$lemma} into $origNode
            let $newest := update insert attribute ana {$pos} into $origNode
            return 
                $origNode
};

(:~
 : Fetches POS-Information from a web service and adds this information
 : as type-, lemma- and ana-attributes to the tei:w element. This function 
 : sends for each w-tag a request, takes quite a lot of time. Use the function above
 :
 : @param $input A TEI document with tei:w tags ready for pos-tagging
 : @param $input a string denoting the language of the text (currently only 'de' works
 : @return The with POS-tags enriched tei:w element
:)

declare function nlp:pos-tagging($input as node()){
    let $request-headers :=
            <headers>
                <header name="Accept" value="application/json"/>
            </headers>

    for $word in $input//tei:w
        let $token := functx:trim(string-join($word//text(), ''))
        let $url := xs:anyURI($nlp:lemmatizerEndpoint||escape-uri(
            $token, true())
        )
        let $request := httpclient:get($url, true(), $request-headers)
        let $json :=   try {
                util:base64-decode($request//httpclient:body/text())
            } catch * {
                false()
            }
        where $json
        let $parsed := parse-json($json)
        let $tag := $parsed?tag
        let $lemma := $parsed?lemma
        let $pos := $parsed?pos
        let $new := update insert attribute type {$tag} into $word
        let $newer := update insert attribute lemma {$lemma} into $word
        let $newest := update insert attribute ana {$pos} into $word
        return
            $word
};
