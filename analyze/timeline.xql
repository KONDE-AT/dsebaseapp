xquery version "3.0";
declare namespace functx = "http://www.functx.com";
import module namespace xmldb="http://exist-db.org/xquery/xmldb";
import module namespace config="http://www.digital-archiv.at/ns/dsebaseapp/config" at "../modules/config.xqm";
import module namespace app="http://www.digital-archiv.at/ns/dsebaseapp/templates" at "../modules/app.xql";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare option exist:serialize "method=json media-type=text/javascript";

let $data := <data>{
    for $x at $pos in collection($app:editions)//tei:correspDesc[(.//@when[1] castable as xs:date)]
    let $sender := string-join($x//tei:correspAction[@type='sent']/tei:persName/text(), ' ')
    let $backlink := app:hrefToDoc($x)
    let $receiver := string-join($x//tei:correspAction[@type='received']/tei:persName/text(), ' ')
    let $content := if ($receiver) 
        then $sender||' wrote to '||$receiver
        else $sender
    let $date := data($x//@when[1])
    let $year := year-from-date(xs:date($date))
    let $month := month-from-date(xs:date($date))
    let $day := day-from-date(xs:date($date))
    return 
        <item>
            <event_id>{$pos}</event_id>
            <sender>{$sender}</sender>
            {if ($receiver) then <receiver>{$receiver}</receiver> else ()}
            <content>{$content}</content>
            <backlink>{$backlink}</backlink>
            <start>{data($x//@when[1])}</start>
            <date>({$year},{$month},{$day})</date>
        </item>
}</data>

return $data