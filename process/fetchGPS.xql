xquery version "3.1";
declare namespace functx = "http://www.functx.com";
import module namespace httpclient="http://exist-db.org/xquery/httpclient";
import module namespace xmldb="http://exist-db.org/xquery/xmldb";
import module namespace util="http://exist-db.org/xquery/util";
import module namespace config="http://www.digital-archiv.at/ns/rita-new/config" at "../modules/config.xqm";
import module namespace app="http://www.digital-archiv.at/ns/rita-new/templates" at "../modules/app.xql";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace wgs84_pos = "http://www.w3.org/2003/01/geo/wgs84_pos#";
declare option exist:serialize "method=json media-type=text/javascript";

for $entity in doc($app:placeIndex)//tei:place
    let $id := data($entity/tei:placeName/@ref)
    let $geon := if(starts-with($id, 'http://www.geonames.org'))
        then $id||'/about.rdf'
        else false()
    let $gnd := if(starts-with($id, 'http://d-nb.info/gnd/'))
        then $id
        else false()
    let $data := doc($geon)
    let $lat := $data//wgs84_pos:lat/text()
    let $lng := $data//wgs84_pos:long/text()
    let $loc := 
        <tei:location>
            <tei:geo>{concat($lat,' ',$lng)}</tei:geo>
        </tei:location>
    where $data
    return
        update insert $loc into $entity


