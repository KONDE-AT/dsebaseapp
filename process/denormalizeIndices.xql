xquery version "3.1";
declare namespace functx = "http://www.functx.com";
import module namespace xmldb="http://exist-db.org/xquery/xmldb";
import module namespace app="http://www.digital-archiv.at/ns/dsebaseapp/templates" at "../modules/app.xql";
import module namespace config="http://www.digital-archiv.at/ns/dsebaseapp/config" at "../modules/config.xqm";
declare namespace tei = "http://www.tei-c.org/ns/1.0";

(: 'denormalizes' indeces by fetching index entries
 : and writing them in tei:back element:)

(:BE AWARE! Already exisitng back elements will be deleted :)

for $x in collection($app:editions)//tei:TEI
    let $removeBack := update delete $x//tei:back
    let $persons := distinct-values(data($x//tei:rs[@type="person" and not(@ref="#person_")]/@ref))
    let $listperson :=
    <listPerson xmlns="http://www.tei-c.org/ns/1.0">
        {
        for $y in $persons
        return
        collection($app:indices)//id(substring-after($y, '#'))
        }
    </listPerson>
    
    let $places := distinct-values(data($x//tei:rs[@type="place"]/@ref))
    let $listplace :=
    <listPlace xmlns="http://www.tei-c.org/ns/1.0">
        {
        for $y in $places
        return
        collection($app:indices)//id(substring-after($y, '#'))
        }
    </listPlace>
    
    let $back := 
    <back xmlns="http://www.tei-c.org/ns/1.0">
        {$listperson}
        {$listplace}
    </back>
    
    let $update := update insert $back into $x/tei:text
    
    return "done"