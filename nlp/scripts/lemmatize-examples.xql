xquery version "3.1";

import module namespace nlp="http://www.digital-archiv.at/ns/dsebaseapp/nlp" at "../modules/nlp.xqm";


let $input := doc("/db/apps/dsebaseapp/nlp/temp/rollet.xml")
let $posTaggd := nlp:pos-tagging($input)
    return $posTaggd

(:let $words := nlp:fetch-text($input):)
(:    return $words:)