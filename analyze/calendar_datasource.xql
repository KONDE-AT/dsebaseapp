xquery version "3.1";
declare namespace functx = "http://www.functx.com";
import module namespace app="http://www.digital-archiv.at/ns/dsebaseapp/templates" at "../modules/app.xql";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare option exist:serialize "method=json media-type=text/javascript";

let $notBefores := collection($app:editions)//tei:TEI//*[@notBefore castable as xs:date]
let $whens := collection($app:editions)//tei:TEI//*[@when castable as xs:date]
let $dates := ($notBefores, $whens)


for $x in collection($app:editions)//tei:TEI[.//*[@when castable as xs:date]]
    let $startDate : = data($x//*[@when castable as xs:date][1]/@when)
    let $name := normalize-space(string-join($x//tei:title[1]//text(), ' '))
    let $id := app:hrefToDoc($x)
    return
        map {
                "name": $name,
                "startDate": $startDate,
                "id": $id
        }

(::)
(:let $data := <data>{:)
(:    for $x at $pos in $dates:)
(:    let $before := $x/preceding::text()[1]:)
(:    let $after := $x/following::text()[1]:)
(:    let $match := $x/text():)
(:    let $backlink := app:hrefToDoc($x):)
(:    let $date := if(data($x/@notBefore)) then data($x/@notBefore) else data($x/@when):)
(:    let $year := year-from-date(xs:date($date)):)
(:    let $month := month-from-date(xs:date($date)):)
(:    let $day := day-from-date(xs:date($date)):)
(:    return:)
(:        <item>:)
(:            <event_id>{$pos}</event_id>:)
(:            <before>{$before}</before>:)
(:            <match>{$match}</match>:)
(:            <after>{$after}</after>:)
(:            <backlink>{$backlink}</backlink>:)
(:            <start>{$date}</start>:)
(:            <date>({$year},{$month},{$day})</date>:)
(:        </item>:)
(:}</data>:)
(::)
(:return $data:)
