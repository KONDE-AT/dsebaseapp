xquery version "3.1";

import module namespace app="http://www.digital-archiv.at/ns/templates" at "../modules/app.xql";
declare namespace expath="http://expath.org/ns/pkg";
declare namespace repo="http://exist-db.org/xquery/repo";

let $collection := request:get-parameter('collection', 'binaries')

let $sources := xs:anyURI(string-join(($app:data, $collection), '/'))
let $binary-data := compression:zip($sources, false())
let $content-type := 'application/octet-stream'
let $binary-name := $collection||'.zip'
return response:stream-binary($binary-data, $content-type, $binary-name)
