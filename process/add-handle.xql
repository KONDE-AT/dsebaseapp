xquery version "3.1";

declare namespace tei = "http://www.tei-c.org/ns/1.0";

import module namespace xmldb="http://exist-db.org/xquery/xmldb";
import module namespace config="http://www.digital-archiv.at/ns/config" at "../modules/config.xqm";
import module namespace app="http://www.digital-archiv.at/ns/templates" at "../modules/app.xql";
import module namespace enrich = "http://www.digital-archiv.at/ns/enrich" at "../modules/enrich.xql";

(: a script to create handle pids and write them as <tei:idno> elements into the according TEI-Files,
 : based upon https://github.com/acdh-oeaw/cr-xq-mets/blob/master/src/modules/resource/handle.xqm
 : call with params user=YOURUSERNAME pw=YOURPASSWORD:)
let $archeBaseUrl := "https://id.acdh.oeaw.ac.at/grundbuecher"
let $versionNo := ""
let $root := if ($versionNo != "")
    then
        string-join(($archeBaseUrl, $versionNo), '/')
    else
        $archeBaseUrl
let $resolver := "http://pid.gwdg.de/handles/21.11115/"
let $user := request:get-parameter('user', 'e.g. user34.12345-76')
let $pw := request:get-parameter('pw', 'verysecret')

for $x in xmldb:get-child-collections($config:data-root)
    for $doc in subsequence(xmldb:get-child-resources($config:data-root||'/'||$x), 1, 10)
        let $filename := string-join(($root, $x, $doc), '/')
        let $url := $filename
        let $node := try {
                        doc(string-join(($config:data-root, $x, $doc), '/'))//tei:publicationStmt
                    } catch * {
                        false()
                    }

          return
            if ($node)
                then
                    let $handle_result := enrich:fetch_handle($resolver, $user, $pw, $url)
                    let $idno := <tei:idno type="URI">{$handle_result}</tei:idno>
                    let $updated := if ($handle_result != "") then update insert $idno into $node else ""
                        return ($url, $handle_result)
            else
                $url
