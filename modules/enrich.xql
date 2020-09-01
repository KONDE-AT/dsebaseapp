xquery version "3.1";

(:~
 : This module provides a couple of helper functions used in the post-install.xql
 : @author peter.andorfer@oeaw.ac.at
:)

module namespace enrich="http://www.digital-archiv.at/ns/enrich";

import module namespace app="http://www.digital-archiv.at/ns/templates" at "../modules/app.xql";
import module namespace config="http://www.digital-archiv.at/ns/config" at "../modules/config.xqm";
import module namespace http = 'http://expath.org/ns/http-client';

declare namespace functx = "http://www.functx.com";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace acdh="https://vocabs.acdh.oeaw.ac.at/schema#";
declare namespace rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#";
declare namespace util = "http://exist-db.org/xquery/util";

(:~
 : registers a handle-pid for the passed in URL
 :
 : @param $resolver The HANDLE-API-Endpoint, e.g. http://pid.gwdg.de/handles/21.11115/
 : @param $user The HANDLE user name, e.g. 'user34.12345-76'
 : @param $pw The HANDLE pw, e.g. 'verysecret'
 : @param $url The URL to register a handle-PID for
 : @return The handle PID
:)

declare function enrich:fetch_handle($resolver as xs:string, $user as xs:string, $pw as xs:string, $url as xs:string) as xs:string? {
  let $auth := "Basic "||util:string-to-binary($user||":"||$pw)
  let $data := '[{"type":"URL","parsed_data":"' || $url||'"}]'
  let $response := (
  http:send-request(
      <http:request method="POST" href="{$resolver}">
      <http:header name="Authorization" value="{$auth}"/>
      <http:header name="Content-Type" value="application/json"/>
      <http:header name="Accept" value="application/xhtml+xml"/>
      <http:body media-type='string' method='text'>{$data}</http:body>
      </http:request>, $resolver
    )
  )
  let $head := $response[1]
  let $handle := if (data($head/@status) = "201") then substring-after($head//*[@name="location"]/data(@value), 'handles/')
    else ""
  return
    $handle
};


(:~
 : creates RDF Metadata describing the applications basic collection structure
 :
 : @param $archeURL The Top-Collection URL, e.g. https://id.acdh.oeaw.ac.at/grundbuecher/{top-col-name}
 : @param $colName The name of the data-collection to process, e.g. 'editions'
 : @return An ARCHE RDF describing the collections
:)

declare function enrich:add_base_and_xmlid($archeURL as xs:string, $colName as xs:string) {
      let $collection := $app:data||'/'||$colName
      let $all := collection($collection)//tei:TEI
      let $base_url := $archeURL||$colName

    for $x in $all
        let $collectionName := util:collection-name($x)
        let $currentDocName := util:document-name($x)
        let $neighbors := app:doc-context($collectionName, $currentDocName)
        let $xml_id := util:document-name($x)
        let $base := update insert attribute xml:base {$base_url} into $x
        let $currentID := update insert attribute xml:id {$currentDocName} into $x
        let $prev := if($neighbors[1])
        then
            update insert attribute prev {string-join(($base_url, $neighbors[1]), '/')} into $x
        else
            ()
    let $next := if($neighbors[3])
        then
            update insert attribute next {string-join(($base_url, $neighbors[3]), '/')}into $x
        else
            ()
        return
          <result base="{$base_url}">
            <collectionName>{$collectionName}</collectionName>
            <currentDocName>{$currentDocName}</currentDocName>
            <xml_id>{$xml_id}</xml_id>
          </result>

};
