xquery version "3.0";
declare namespace functx = "http://www.functx.com";
import module namespace xmldb="http://exist-db.org/xquery/xmldb";
import module namespace app="http://www.digital-archiv.at/ns/rita-new/templates" at "../modules/app.xql";
import module namespace config="http://www.digital-archiv.at/ns/rita-new/config" at "../modules/config.xqm";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare option exist:serialize "method=xml media-type=text/xml omit-xml-declaration=no indent=yes";

(: script to generate a cmfi file from a collection of documents using the correspdesc module
 : you can pass in via url-param @baseURL :)

let $baseURL := request:get-parameter("baseURL", "https://rita-new-korrespondenz.acdh.oeaw.ac.at")

(: create the CMFI document:)
let $CMFI := 
<TEI xmlns="http://www.tei-c.org/ns/1.0">
    <teiHeader>
        <fileDesc>
            <titleStmt>
                <title>Correspondence Metadata Interchange Format for: {$config:app-title}</title>
                {for $x in $config:app-authors return 
                    <editor>{$x/text()}</editor>
                }
            </titleStmt>
            <publicationStmt>
                <publisher>
                    <ref target="{$baseURL}">{$config:app-title}</ref>
                </publisher>
                <idno type="url">{$baseURL}</idno>
                <date when="{current-date()}"/>
                <availability>
                    <licence target="https://creativecommons.org/licenses/by-sa/4.0/">CC-BY 4.0</licence>
                </availability>
            </publicationStmt>
            <sourceDesc>
                <bibl type="online">
                    {$config:app-title} <ref target="{$baseURL}">{$baseURL}</ref>
                </bibl>
            </sourceDesc>
        </fileDesc>
        <profileDesc>

{
for $corrspDesc in collection($app:editions)//tei:correspDesc
let $ref := app:getDocName($corrspDesc)
return
    <correspDesc ref="{string-join(($baseURL, $ref), '/')}">{for $x in $corrspDesc//tei:correspAction return $x}</correspDesc>
}
        </profileDesc>
    </teiHeader>
    <text>
        <body>
            <p>some text</p>
        </body>
    </text>
</TEI>

(: create a 'temp' collection:)
let $temp := xmldb:create-collection($config:app-root, 'temp')
(: store CMFI into temp-collection:)
let $stored := xmldb:store($temp, 'cmfi-temp.xml', $CMFI)

(: change ref ids:)
let $changed := 

for $person in doc($stored)//tei:correspAction/tei:persName
let $oldID := substring-after(data($person/@ref), '#')
let $newID := doc($app:personIndex)//tei:person[@xml:id=$oldID]//tei:idno/text()
let $test := if (starts-with($newID, 'http')) then update replace $person/@ref with $newID else ()
return doc($stored) 

(: store updated cmfi file in data/indices:)
let $newCMFI := xmldb:store($config:app-root||'/data/indices', 'cmfi.xml', doc($stored))

(: delte temp-collection and content :)
let $cleanup := xmldb:remove($temp)

return $changed
