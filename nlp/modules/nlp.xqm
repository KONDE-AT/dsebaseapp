xquery version "3.1";

(:~
 : This module contains functions needed for tokenization and lemmatization of TEI files.
 :  Be aware that this module does NOT provide any nlp-functionality by itself but it eases the interaction
 : between NLP-Web-Services and TEI-Docs stored in eXist-db
:)
 
module namespace nlp="http://www.digital-archiv.at/ns/dsebaseapp/nlp";

import module namespace functx = "http://www.functx.com";
import module namespace httpclient ="http://exist-db.org/xquery/httpclient";
import module namespace util = "http://exist-db.org/xquery/util";
import module namespace xmldb = "http://exist-db.org/xquery/xmldb";


declare namespace output="http://www.w3.org/2010/xslt-xquery-serialization";
declare namespace tei="http://www.tei-c.org/ns/1.0";

declare variable $nlp:tokenizerEnpoint := xs:anyURI("http://openconvert.clarin.inl.nl/openconvert/text");
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
 : @see http://openconvert.clarin.inl.nl/openconvert/web/help.html
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
    let $request := httpclient:post($nlp:tokenizerEnpoint, $content, true(), $request-headers)
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
        let $name := util:document-name($x)
        let $docUri := $collection||$name
        let $input := doc($docUri)
        let $tokenized := nlp:tokenize-and-save($input)
            return $tokenized
};



