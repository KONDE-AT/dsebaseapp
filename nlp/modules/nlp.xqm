xquery version "3.1";

(:~
 : This module contains functions needed for tokenization and lemmatization of TEI files.
 :  Be aware that this module does NOT provide any nlp-functionality by itself but it eases the interaction
 : between NLP-Web-Services and TEI-Docs stored in eXist-db
 : @author Peter Andorfer 
:)
 
module namespace nlp="http://www.digital-archiv.at/ns/dsebaseapp/nlp";

import module namespace functx = "http://www.functx.com";
import module namespace httpclient ="http://exist-db.org/xquery/httpclient";
import module namespace util = "http://exist-db.org/xquery/util";
import module namespace xmldb = "http://exist-db.org/xquery/xmldb";


declare namespace output="http://www.w3.org/2010/xslt-xquery-serialization";
declare namespace tei="http://www.tei-c.org/ns/1.0";

declare variable $nlp:tokenizerEnpoint := 
xs:anyURI("http://openconvert.clarin.inl.nl/openconvert/text");

declare variable $nlp:lemmatizerEndpoint := 
xs:anyURI("http://127.0.0.1:8000/query/lemma?token=");

declare variable $nlp:serialiserParams := 
        <output:serialization-parameters>
          <output:omit-xml-declaration value="yes"/>
          <output:expand-xincludes value="no"/>
          <output:method value="xml"/>
          <output:encoding value="utf-8"/>
        </output:serialization-parameters>;

declare variable $nlp:codepoints := doc('codepoints.xml');

(:~
 : Sends a TEI-Document to the tokenizer web-service
 : http://openconvert.clarin.inl.nl/openconvert/web/help.html
 :
 : @param $input An xml docuemnt which validates against the TEI-schema 
 : @return The tokenized (tei:w-tags) xml document
:)

declare function nlp:tokenize($input as node()){
    let $file := util:serialize($input, $nlp:serialiserParams)
    let $content := "input="||$file||"&amp;format=tei&amp;to=tei&amp;tagger=tokenizer&amp;output=raw"
    let $request-headers :=
        <headers>
            <header name="Content-Type" value="application/x-www-form-urlencoded"/>
        </headers>
    let $request := httpclient:post(
            $nlp:tokenizerEnpoint, $content, true(), $request-headers
        )
    let $tei := $request
    return 
        $tei
};

(:~
 : Searches and replaces false encoded special characters (e.g. 'Á¼' -> 'ü')
 :
 : @param $tei An xml docuemnt which validates against the TEI-schema 
 : @return The the cleaned document
:)

declare function nlp:clean-encoding($input as node()){
    let $from := ('Ã¼', 'Á¤', 'Á¶', 'ÁŸ', 'Áœ','â', 'Á')
    let $to :=   ('ü', 'ä', 'ö', 'ß', 'Ü', '–', 'ß')
    let $string := util:serialize($input, $nlp:serialiserParams)
    let $new := functx:replace-multi($string, $from, $to)
    let $fromCp := $nlp:codepoints//tei:cell[@n="2"]/text()
    let $toCP := $nlp:codepoints//tei:cell[@n="1"]/text()
    let $newer := functx:replace-multi($new, $fromCp, $toCP)
    return 
        util:parse($newer)
};


(:~
 : Sends a TEI-Document to the tokenizer web-service and stores the result
 : in 'db/apps/{app-name}/nlp/temp/{doc-name}'
 : @see http://openconvert.clarin.inl.nl/openconvert/web/help.html
 :
 : @param $input An xml docuemnt which validates against the TEI-schema 
 : @return The location of the stored tokenized document
:)

declare function nlp:tokenize-and-save($input as node()){
    let $collection-uri := '/db/apps/dsebaseapp/nlp/temp/'
    let $resource-name := util:document-name($input)
    let $tokenized := nlp:tokenize($input)
    where $tokenized//httpclient:body/*
    let $cleaned := nlp:clean-encoding($tokenized//httpclient:body/*)
    let $stored := xmldb:store($collection-uri, $resource-name, $cleaned)
    return 
        $stored
};


(:~
 : Bulk tonenizes all TEI-Documents found in the passed in collection
 :
 : @param $collection The URI of a collection to process 
 : @return The path of the stored documentst
:)

declare function nlp:bulk-tokenize($collection as xs:string){
    for $x in collection($collection)//tei:TEI
        let $wait := util:wait(5000)
        let $name := util:document-name($x)
        let $docUri := $collection||$name
        let $input := doc($docUri)
        let $tokenized := nlp:tokenize-and-save($input)
            return $tokenized
};

(:~
 : Fetches POS-Information from a web service and adds this information
 : as type-, lemma- and ana-attributes to the tei:w element
 :
 : @param $input A TEI document with tei:w tags ready for pos-tagging 
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

