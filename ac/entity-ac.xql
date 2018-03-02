xquery version "3.0";
import module namespace app="http://www.digital-archiv.at/ns/dsebaseapp/templates" at "../modules/app.xql";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare option exist:serialize "method=json media-type=text/javascript";

let $type := request:get-parameter('entity', 'person')
let $query := request:get-parameter('query', '')

let $return := 
    if($type eq 'person') then
        <list>
            <item>
                <name>{false()}</name>
                <id>{false()}</id>
                <description>{false()}</description>
                <more>{false()}</more>
                <type>{$type}</type>
            </item>{
        let $entities := if ($query) 
            then 
                doc($app:personIndex)//tei:person[contains(string-join(.//tei:persName//text()), $query)]
            else 
                doc($app:personIndex)//tei:person
        for $x in $entities
        let $name := normalize-space(string-join($x/tei:persName//text(), ' '))
        let $description := normalize-space(string-join($x//text(), ' '))
        let $more := normalize-space($x//tei:idno[1 and @type="URL"]/text())
        where contains($name, $query)
            return 
                <item>
                    <name>{$name}</name>
                    <id>{data($x/@xml:id)}</id>
                    <description>{$description}</description>
                    <more>{$more}</more>
                </item>
        }</list>
    else if($type eq 'place') then
        <list>{
        let $entities := doc($app:placeIndex)//tei:place
        
        for $x in $entities
            return 
                <item>
                    <name>{normalize-space(string-join($x/tei:placeName//text(), ' '))}</name>
                    <id>{data($x/@xml:id)}</id>
                </item>
        }</list>
    else if($type eq 'org') then
        <list>{
        let $entities := doc($app:orgIndex)//tei:org
        for $x in $entities
            return 
                <item>
                    <name>{normalize-space(string-join($x/tei:orgName//text(), ' '))}</name>
                    <id>{data($x/@xml:id)}</id>
                </item>
        }</list>
    else if($type eq 'work') then
        <list>{
        let $entities := doc($app:workIndex)//tei:bibl
        for $x in $entities
            return 
                <item>
                    <name>{normalize-space(string-join($x/tei:title//text(), ' '))}</name>
                    <id>{data($x/@xml:id)}</id>
                </item>
        }</list>
    else ()

return $return
