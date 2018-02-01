xquery version "3.1";

import module namespace nlp="http://www.digital-archiv.at/ns/dsebaseapp/nlp" at "../modules/nlp.xqm";
declare option exist:serialize "method=json media-type=text/javascript";


let $input := doc("/db/apps/dsebaseapp/nlp/temp/bezirkskommissariate-an-stadthauptmannschaft-1851-03-a3-xxi-d109.xml")
(:let $posTaggd := nlp:pos-tagging($input):)
(:    return $posTaggd:)

let $words := nlp:fetch-text($input)
    return $words