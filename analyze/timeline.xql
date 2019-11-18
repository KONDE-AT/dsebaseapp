xquery version "3.1";
declare namespace functx = "http://www.functx.com";
import module namespace xmldb="http://exist-db.org/xquery/xmldb";
import module namespace config="http://www.digital-archiv.at/ns/config" at "../modules/config.xqm";
import module namespace app="http://www.digital-archiv.at/ns/templates" at "../modules/app.xql";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare option exist:serialize "method=json media-type=text/javascript";

let $notBefores := collection($app:editions)//tei:TEI//*[@notBefore castable as xs:date]
let $whens := collection($app:editions)//tei:TEI//*[@when castable as xs:date]
let $dates := ($notBefores, $whens)

let $data := <data>{
    for $x at $pos in $dates
    let $before := $x/preceding::text()[1]
    let $after := $x/following::text()[1]
    let $match := $x/text()
    let $backlink := app:hrefToDoc($x)
    let $date := if(data($x/@notBefore)) then data($x/@notBefore) else data($x/@when)
    let $year := year-from-date(xs:date($date))
    let $month := month-from-date(xs:date($date))
    let $day := day-from-date(xs:date($date))
    return 
        <item>
            <event_id>{$pos}</event_id>
            <before>{$before}</before>
            <match>{$match}</match>
            <after>{$after}</after>
            <backlink>{$backlink}</backlink>
            <start>{$date}</start>
            <date>({$year},{$month},{$day})</date>
        </item>
}</data>

return $data