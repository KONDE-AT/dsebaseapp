xquery version "3.0";
declare namespace functx = "http://www.functx.com";
import module namespace xmldb="http://exist-db.org/xquery/xmldb";
import module namespace app="http://www.digital-archiv.at/ns/dsebaseproject/templates" at "../modules/app.xql";
import module namespace config="http://www.digital-archiv.at/ns/dsebaseproject/config" at "../modules/config.xqm";
declare namespace tei = "http://www.tei-c.org/ns/1.0";

(:script to add tei:idno elements containing normdata-ID-URLs:)

for $x in doc($app:personIndex)//tei:person
let $gnd := $x/tei:note/tei:p[3]/text()
let $idno := if($gnd != 'no gnd provided') then <tei:idno type="URL">{$gnd}</tei:idno> else ()
let $insert := if($gnd != 'no gnd provided') then update insert $idno into $x else ()
return
    $x