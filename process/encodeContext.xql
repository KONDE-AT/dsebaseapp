xquery version "3.1";
declare namespace functx = "http://www.functx.com";
import module namespace xmldb="http://exist-db.org/xquery/xmldb";
import module namespace app="http://www.digital-archiv.at/ns/templates" at "../modules/app.xql";
import module namespace config="http://www.digital-archiv.at/ns/config" at "../modules/config.xqm";
declare namespace tei = "http://www.tei-c.org/ns/1.0";

(: This script adds @prev and @next attributes to tei:TEI nodes.
 : The values for theses attributes are fetched from the current tei:TEI node 
 : in it's collection
:)

let $archeURL := "https://id.acdh.oeaw.ac.at/"
let $projectURL := 'dsebaseapp/'
let $dataURL := 'dsebaseapp/'
let $idURL := $archeURL||$projectURL||$dataURL


let $all := collection($app:editions)//tei:TEI
let $all := subsequence($all, 1, 5)
for $x in $all
    let $collectionName := util:collection-name($x)
    let $currentDocName := util:document-name($x)
    let $neighbors := app:doc-context($collectionName, $currentDocName)
    let $base := update insert attribute xml:base {$idURL} into $x
    let $currentID := update insert attribute xml:id {$currentDocName} into $x
    let $prev := if($neighbors[1])
        then
            update insert attribute prev {$idURL||$neighbors[1]} into $x 
        else
            ()
    let $next := if($neighbors[3])
        then
            update insert attribute next {$idURL||$neighbors[3]} into $x 
        else
            ()
    return
        <group for="{$currentDocName}">
            <prev>{$neighbors[1]}</prev>
            <next>{$neighbors[3]}</next>
        </group>