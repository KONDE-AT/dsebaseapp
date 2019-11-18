xquery version "3.0";
declare namespace functx = "http://www.functx.com";
import module namespace xmldb="http://exist-db.org/xquery/xmldb";
import module namespace config="http://www.digital-archiv.at/ns/config" at "../modules/config.xqm";
import module namespace app="http://www.digital-archiv.at/ns/templates" at "../modules/app.xql";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace gefx = "http://gexf.net/data/hello-world.gexf";
declare namespace util = "http://exist-db.org/xquery/util";
declare option exist:serialize "method=xml media-type=text/xml omit-xml-declaration=no indent=yes";

(:transforms a CMFI document into a GEXF document, random CMFI could be passed in via @CMFI param:)

let $CMFI:= request:get-parameter("CMFI", "")
let $fallback := if ($CMFI eq "") then $config:app-root||'/data/indices/cmfi.xml' else $CMFI
let $source := doc($fallback)
let $result := 
        <gexf xmlns="http://www.gexf.net/1.2draft" version="1.2">
            <meta lastmodifieddate="{current-date()}">
                <creator>dsebaseapp-net.xql</creator>
                <description>A network of persons mentioned in the dsebaseapp-Korpus</description>
            </meta>
            <graph mode="static" defaultedgetype="directed">
                <nodes>
                {

                    for $corresp in $source//tei:correspDesc[./tei:correspAction[@type='sent'] and ./tei:correspAction[@type='received']]
                        for $person in $corresp//tei:persName[1]
                            let $key := data($person/@ref)
                            group by $key
                            return
                                <node id="{$key}" label="{$person[1]/text()}"/>
         
                }
                </nodes>
                <edges>
                {
                    for $corresp in $source//tei:correspDesc[./tei:correspAction[@type='sent'] and ./tei:correspAction[@type='received']]
                        let $sender := $corresp/tei:correspAction[@type='sent']//tei:persName[1]
                        let $reciver := $corresp/tei:correspAction[@type='received']//tei:persName[1]
                        let $id := data($corresp/@ref)
                            return
                                <edge id="{$id}" source="{data($sender/@ref)}" target="{data($reciver/@ref)}" />
                }
        
                    
                </edges>
            </graph>
        </gexf>

return $result
