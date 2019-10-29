xquery version "3.1";
import module namespace app="http://www.digital-archiv.at/ns/templates" at "../modules/app.xql";
declare option exist:serialize "method=xml media-type=text/xml omit-xml-declaration=no indent=yes";

let $id := request:get-parameter('id', 'person_13089')
let $node := collection($app:data)//id($id)

return $node