xquery version "3.1";
import module namespace app="http://www.digital-archiv.at/ns/templates" at "../modules/app.xql";
declare option exist:serialize "method=xml media-type=text/xml omit-xml-declaration=no indent=yes";

let $doc-name := request:get-parameter('doc-name', 'entry__1879-11-18.xml')
let $collection := request:get-parameter('collection', 'editions')
let $doc-uri :=
    if ($doc-name)
        then 
            string-join(($app:data, $collection, $doc-name), '/')
        else
            false()
let $result := if($doc-name) then doc($doc-uri) else ()
return $result