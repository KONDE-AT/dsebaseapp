xquery version "3.1";
import module namespace app="http://www.digital-archiv.at/ns/dsebaseapp/templates" at "../modules/app.xql";
import module namespace util="http://exist-db.org/xquery/util";

declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace exist = "http://exist.sourceforge.net/NS/exist";
declare namespace request="http://exist-db.org/xquery/request";

declare option exist:serialize "method=xml media-type=text/xml indent=yes";

let $listperson := doc($app:personIndex)//tei:listPerson
let $forename := request:get-parameter('forename', '')
let $surname := request:get-parameter('surname', '')
let $idno := if (request:get-parameter('idno', ''))
    then
        <tei:idno type="URL">{request:get-parameter('idno', '')}</tei:idno>
    else
        ()
let $id := string-join(($forename, $surname), '')
let $id := concat('person_', util:hash($id, 'md5'))
let $rolename := request:get-parameter('rolename', '')
let $rolenames := if ($rolename)
    then
        for $x in tokenize($rolename, '\|')
            return
                <tei:roleName type="alt">{$x}</tei:roleName>
    else
        ()
let $altname := request:get-parameter('altname', '')
let $altnames := if ($altname)
    then
        for $x in tokenize($altname, '\|')
            return
                <tei:persName type="alt">{$x}</tei:persName>
    else
        ()
let $entity :=
    <tei:person xml:id="{$id}">
        <tei:persName>
            <tei:surname>{request:get-parameter('surname', '')}</tei:surname>
            <tei:forename>{request:get-parameter('forename', '')}</tei:forename>
            {$rolenames}
        </tei:persName>
        {$altnames}
        {$idno}
    </tei:person>
let $update := if($listperson//tei:person[@xml:id=$id])
    then
        true()
    else
        update insert $entity into $listperson
let $status := if ($update)
    then
        <status>
            <message>looks like such an entity already exists</message>
        </status>
    else
        <status>
            <message>follwoing node created</message>
            {$entity}
        </status>
return
    $status