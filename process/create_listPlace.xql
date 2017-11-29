xquery version "3.0";
declare namespace functx = "http://www.functx.com";
import module namespace xmldb="http://exist-db.org/xquery/xmldb";
import module namespace config="http://www.digital-archiv.at/ns/dsebaseapp/config" at "../modules/config.xqm";
declare namespace tei = "http://www.tei-c.org/ns/1.0";

declare function functx:capitalize-first
  ( $arg as xs:string? )  as xs:string? {

   concat(upper-case(substring($arg,1,1)),
             substring($arg,2))
 } ;

declare function local:slugify_refs( $arg as xs:string)  as xs:string {
   let $arg := lower-case(replace($arg, '[\[\]\(\)#/\?]', ""))
   let $arg := replace($arg, "[\]_\s*“„,;\.:]", "-")
   let $arg := replace($arg, "['`´]", "-")
   let $arg := replace($arg, "--*", "-")
   return $arg
 } ;
let $listPlace := 

<listPlace>{
    for $place in collection(concat($config:app-root, '/data/editions'))//tei:placeName | //tei:region | //tei:country 
    let $type := name($place)
    let $string := string-join($place//text(), ' ')
    let $key := if (exists($place/@key)) then data($place/@key) else $string
    let $xmlID := 'place_'||util:hash($key, 'md5')
    let $ref := '#'||$xmlID
(:    let $addedRef := update insert attribute ref {$ref} into $place:)
    group by $xmlID
    where $string != ''
    return 
        <place xml:id="{$xmlID}" type="{$type[1]}">
            <placeName type="pref">{normalize-space($key[1])}</placeName>
            {for $x in distinct-values($place/text()[1]) return <placeName type="alt">{normalize-space($x)}</placeName> }
        </place>
}</listPlace>

return $listPlace