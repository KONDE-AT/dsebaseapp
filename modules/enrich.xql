xquery version "3.1";

(:~
 : This module provides a couple of helper functions used in the post-install.xql
 : @author peter.andorfer@oeaw.ac.at
:)

module namespace enrich="http://www.digital-archiv.at/ns/enrich";

import module namespace app="http://www.digital-archiv.at/ns/templates" at "../modules/app.xql";
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

(:~
 : adds mentions as tei:events to index entry

 : @param $colName The name of the data-collection to process, e.g. 'editions'
 : @param $ent_type The name of the entity, e.g. 'place', 'org' or 'person'
:)

declare function enrich:mentions($colName as xs:string, $ent_type as xs:string) {
  let $collection := $app:data||'/'||$colName
  for $x at $count in collection($app:indices)//tei:*[name()=$ent_type]
    let $events := $x//tei:event
    let $event_list := $x//tei:listEvent
    let $remove_events := for $e in $event_list let $removed := update delete $e return <removed>{$e}</removed>

    let $ref := '#'||$x/@xml:id
    let $lm := 'processing entity nr: '||$count||' with id: '||$ref
    let $l := util:log('info', $lm)
    let $event_list_node := 
    <tei:listEvent>{
    for $doc in collection($collection)//tei:TEI[.//tei:rs[@ref=$ref]]
        let $doc_title := normalize-space(string-join($doc//tei:titleStmt/tei:title//text()[not(./parent::tei:note)], ''))
        let $handle := $doc//tei:idno[@type='handle']/text()
        return
            <tei:event type="mentioned">
                <tei:desc>erwähnt in <tei:title ref="{$handle}">{$doc_title}</tei:title></tei:desc>
            </tei:event>
    }
    </tei:listEvent>
        let $event_count := count($event_list_node//tei:event)
        let $continue := if ($event_count gt 0) then true() else false()
        let $update := 
                if ($continue) then 
                    update insert $event_list_node into $x
                else
                    ()
        return
            <result updated="{$ref}">
                <event_count>{$event_count}</event_count>
            </result>
};

(:~
 : deletes index-entries without xml:id

 : @param $colName The name of the data-collection to process, e.g. 'editions'
 : @param $ent_type The name of the entity, e.g. 'place', 'org' or 'person'
:)

declare function enrich:delete_entities_without_xmlid($ent_type as xs:string) {
  for $x at $count in collection($app:indices)//tei:*[name()=$ent_type and not(@xml:id)]
    let $msg := substring(normalize-space(string-join($x//text(), ' ')), 1, 25)
    let $l := util:log('info', $msg)

    return
      update delete $x
};

(:~
 : deletes remove tei:list* elements in tei:back"

 : @param $colName The name of the data-collection to process, e.g. 'editions'
:)

declare function enrich:delete_lists_in_back($colName) {
  let $collection := $app:data||'/'||$colName
  for $x at $count in collection($collection)//tei:back//*[starts-with(name(), 'list')]
    return
      update delete $x
};
