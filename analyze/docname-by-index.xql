xquery version "3.1";
import module namespace app="http://www.digital-archiv.at/ns/dsebaseapp/templates" at "../modules/app.xql";
declare option exist:serialize "method=json media-type=text/javascript";

let $query := request:get-parameter('index', '1')
let $directory := request:get-parameter('directory', 'editions')
let $index := xs:int($query)
let $collection := string-join(($app:data,$directory), '/')
let $all := sort(xmldb:get-child-resources($collection))
let $result := "show.html?document="||$all[$index]||"&amp;directory="||$directory
    return $result