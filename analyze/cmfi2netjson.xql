xquery version "3.0";
declare namespace functx = "http://www.functx.com";
import module namespace xmldb="http://exist-db.org/xquery/xmldb";
import module namespace config="http://www.digital-archiv.at/ns/dsebaseapp/config" at "../modules/config.xqm";
import module namespace app="http://www.digital-archiv.at/ns/dsebaseapp/templates" at "../modules/app.xql";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace gefx = "http://gexf.net/data/hello-world.gexf";
declare namespace util = "http://exist-db.org/xquery/util";
declare option exist:serialize "method=json media-type=text/javascript";

(:transforms a CMFI document into a JSON which can be processed by visjs into a network graph:)

let $CMFI:= request:get-parameter("CMFI", "")
let $fallback := if ($CMFI eq "") then $config:app-root||'/data/indices/cmfi.xml' else $CMFI
let $source := doc($fallback)
let $result := 
        <result>

                {

                    for $corresp in $source//tei:correspDesc[./tei:correspAction[@type='sent'] and ./tei:correspAction[@type='received']]
                        for $person in $corresp//tei:persName[1]
                            let $key := data($person/@ref)
                            group by $key
                            return
                                <nodes>
                                    <id>{$key}</id>
                                    <title>{$person[1]/text()}</title>
                                    <color>green</color>
                                </nodes>
         
                }

                {
                    for $corresp in $source//tei:correspDesc[./tei:correspAction[@type='sent'] and ./tei:correspAction[@type='received']]
                        let $sender := $corresp/tei:correspAction[@type='sent']//tei:persName[1]
                        let $reciver := $corresp/tei:correspAction[@type='received']//tei:persName[1]
                        let $id := data($corresp/@ref)
                            return
                                <edges>
                                    <from>{data($sender/@ref)}</from>
                                    <to>{data($reciver/@ref)}</to>
                                </edges>
                }

        </result>

return $result
