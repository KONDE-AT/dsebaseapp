xquery version "3.1";
declare namespace functx = "http://www.functx.com";
import module namespace httpclient="http://exist-db.org/xquery/httpclient";
import module namespace xmldb="http://exist-db.org/xquery/xmldb";
import module namespace util="http://exist-db.org/xquery/util";
import module namespace config="http://www.digital-archiv.at/ns/dsebaseapp/config" at "../modules/config.xqm";
import module namespace app="http://www.digital-archiv.at/ns/dsebaseapp/templates" at "../modules/app.xql";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare option exist:serialize "method=json media-type=text/javascript";


(:~ little script to fetch gnd-ids from lobid endpoint, by peter.andorfer@oeaw.ac.at with big support from dario.kampkaspar@oeaw.ac.at:)

let $base_url := "https://lobid.org/gnd/search?filter=preferredNameEntityForThePerson.surname:"
let $query_type_forename := xmldb:encode-uri(" AND type:Person AND preferredNameEntityForThePerson.forename:")
let $query_birthdate := xmldb:encode-uri(" AND dateOfBirth:")
let $headers := <headers><header name="Accept" value="application/json"/></headers>

let $usable := doc($app:personIndex)//tei:person[.//tei:forename and not(.//tei:idno[@type="GND"])]
let $sample := subsequence($usable, 1, 50)
for $x in $usable
    let $id := data($x/@xml:id)
    let $surname := xmldb:encode-uri(normalize-space(string-join($x//tei:surname[1]/text(), ' ')))
    let $forename_orig := xmldb:encode-uri(translate(tokenize(normalize-space(string-join($x//tei:forename[1]/text(), ' ')), ' ')[1], '\?,', ''))
    
(:    let $birth_orig := data($x//tei:birth/@when-iso):)
(:    let $birth_date := if(contains($birth_orig, '?')):)
(:        then:)
(:            xmldb:encode-uri(substring($birth_orig, 1, 4)||'*'):)
(:        else:)
(:            xmldb:encode-uri($birth_orig):)
    let $url := $base_url||$surname||$query_type_forename||$forename_orig
    

    let $request := httpclient:get(($url), true(), $headers)
    let $json := try{
            parse-json(util:base64-decode($request//httpclient:body))
        } catch * {
            <none/>
        }

    let $candidates := try{
        for $x in $json?member?*
            return $x?id
        } catch *{
            'empty'
        }
    return if ($candidates != 'empty')
        then
            for $y in $candidates return update insert <idno xmlns="http://www.tei-c.org/ns/1.0" type="GND">{$y}</idno> into $x
        else
            ()
    
    
