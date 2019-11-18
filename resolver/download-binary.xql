xquery version "3.1";

import module namespace app="http://www.digital-archiv.at/ns/templates" at "../modules/app.xql";
declare namespace expath="http://expath.org/ns/pkg";
declare namespace repo="http://exist-db.org/xquery/repo";

let $binary-name := request:get-parameter('binary-name', 'acdh_logo.png')
let $collection := request:get-parameter('collection', 'binaries')

let $binary-resource := string-join(($app:data, $collection, $binary-name), '/')
let $binary-data := util:binary-doc($binary-resource)
let $content-type := 'application/octet-stream'
return response:stream-binary($binary-data, $content-type, $binary-name)
