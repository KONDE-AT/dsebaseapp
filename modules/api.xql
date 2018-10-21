xquery version "3.1";

module namespace api="http://www.digital-archiv.at/ns/dsebaseapp/api";
declare namespace rest = "http://exquery.org/ns/restxq";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
import module namespace functx = "http://www.functx.com";
import module namespace app="http://www.digital-archiv.at/ns/dsebaseapp/templates" at "app.xql";
import module namespace config="http://www.digital-archiv.at/ns/dsebaseapp/config" at "config.xqm";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare namespace http = "http://expath.org/ns/http-client";


declare %private function api:utils-list-collection-content($collection as xs:string, $pageNumber as xs:integer, $pageSize as xs:integer){
    if ($pageNumber castable as xs:integer and $pageSize castable as xs:integer) then
        let $pageNumber := xs:integer($pageNumber)
        let $pageSize := xs:integer($pageSize)
        let $self := rest:uri()
        let $base := functx:substring-before-last($self,'/')
        let $sequence := collection($config:app-root||'/data/'||$collection)//tei:TEI
        let $result := api:utils-paginator($self, $pageNumber, $pageSize, $sequence)
        let $content := 
            for $x in $result?sequence
                let $id := app:getDocName($x)
                let $title := normalize-space(string-join($x//tei:title[1]//text(), ' '))
                let $self := string-join(($result?endpoint, $id), '/')
                return
                    <data>
                        <type>TEI-Document</type>
                        <id>{$id}</id>
                        <attributes>
                            <title>{$title}</title>
                        </attributes>
                        <links>
                            <self>
                                {$self}
                            </self>
                        </links>
                    </data>
        return
            <result>
                {$result?meta}
                {$content}
            </result>
    else
        let $result := <error>Page size and page number params need to be of type integer</error>
        return 
            $result
};


(:~
 : A utility function to create a 'paginator-map'
 :
 : @param $endpoint The URL calling this function
 : @param $pageNumber The number of the current page
 : @param $pageSize Number of items per page
 : @param $sequence Any kind of sequence to be paginated
 : @return A map object with keys: "meta" containing pagination info, 
 : "sequence" containing the subsequence of the passed in sequence,
 : and the other passed in params
:)

declare function api:utils-paginator(
        $endpoint as xs:string,
        $pageNumber as xs:integer,
        $pageSize as xs:integer,
        $sequence as item()*
    ){
        let $all := count($sequence)
        let $collection := subsequence($sequence, $pageNumber, $pageSize)
        let $base := functx:substring-before-last($endpoint,'/')
        let $first := $endpoint||'?page[number]='||1
        let $prev := if ($pageNumber gt 1) then $pageNumber - 1 else $pageNumber
        let $prev := $endpoint||'?page[number]='||$prev
        let $last := ceiling($all div $pageSize)
        let $next:= if ($pageNumber lt $last) then $pageNumber + 1 else $pageNumber
        let $next := $endpoint||'?page[number]='||$next
        let $last := $endpoint||'?page[number]='||$last
        let $result := 
                <result>
                    <meta>
                        <hits>{$all}</hits>
                    </meta>
                    <links>
                        <self>{$endpoint}</self>
                        <first>{$first}</first>
                        <prev>{$prev}</prev>
                        <next>{$next}</next>
                        <last>{$last}</last>
                    </links>
                </result>
        return
            map{
                "meta": $result,
                "sequence": $collection,
                "base": $base,
                "endpoint": $endpoint,
                "pageNumber": $pageNumber,
                "pageSize": $pageSize
            }
};

declare variable $api:JSON := 
<rest:response>
    <http:response>
        <http:header name="Access-Control-Allow-Origin" value="*"/>
        <http:header name="X-Frame-Options" value="SAMEORIGIN"/>
        <http:header name="Content-Language" value="en"/>
        <http:header name="Content-Type" value="application/json; charset=utf-8"/>
    </http:response>
    <output:serialization-parameters>
        <output:method value='json'/>
        <output:media-type value='application/json'/>
    </output:serialization-parameters>
 </rest:response>;

declare variable $api:XML := 
<rest:response>
    <http:response>
        <http:header name="Access-Control-Allow-Origin" value="*"/>
        <http:header name="X-Frame-Options" value="SAMEORIGIN"/>
        <http:header name="Content-Language" value="en"/>
        <http:header name="Content-Type" value="application/xml; charset=utf-8"/>
    </http:response>
    <output:serialization-parameters>
        <output:method value='xml'/>
        <output:media-type value='application/xml'/>
    </output:serialization-parameters>
 </rest:response>;



(:~
 : API-Endpoint to list all child collections of the app's data collection
 :
 : @return A JSON-API list
:)

declare 
    %rest:GET
    %rest:path("/dsebaseapp/api/collections")
    %rest:query-param("page[number]", "{$pageNumber}", 1)
    %rest:query-param("page[size]", "{$pageSize}", 20)
    %rest:query-param("format", "{$format}", 'json')
function api:api-list-collections($format as xs:string*, $pageNumber as xs:integer*, $pageSize as xs:integer*) {
    let $sequence := sort(xmldb:get-child-collections($app:data))
    let $self := rest:uri()
    let $paginator := api:utils-paginator($self, $pageNumber, $pageSize, $sequence)
    let $content :=
        for $x in $paginator?sequence
            let $id := $x
            let $title := $x
            let $self := string-join(($paginator?endpoint, $id), '/')
            return
                <data>
                    <type>Collection</type>
                    <id>{$id}</id>
                    <attributes>
                        <title>{$title}</title>
                    </attributes>
                    <links>
                        <self>
                            {$self}
                        </self>
                    </links>
                </data>
    let $result := 
        <result>
            {$paginator?meta}
            {$content}
        </result>
    let $serialization := switch($format)
        case('xml') return $api:XML
        default return $api:JSON
            return 
                ($serialization, $result)
};


(:~
 : API-Endpoint to list all documents stored in the passed in collection
 :
 : @param $collection The name of the collection which documents should be listed
 : @return A JSON-API list
:)
declare 
    %rest:GET
    %rest:path("/dsebaseapp/api/collections/{$collection}")
    %rest:query-param("page[number]", "{$pageNumber}", 1)
    %rest:query-param("page[size]", "{$pageSize}", 20)
    %rest:query-param("format", "{$format}", 'json')
function api:api-list-documents($collection as xs:string, $format as xs:string*, $pageNumber as xs:integer*, $pageSize as xs:integer*) {
    let $result:= api:utils-list-collection-content($collection, $pageNumber, $pageSize)
    let $serialization := switch($format)
        case('xml') return $api:XML
        default return $api:JSON
            return 
                ($serialization, $result)
 };
 
  
 (:~
 : API-Endpoint to list all entities located in the app's indices collections.
 :
 : @return A JSON-API list of all entities
:)

declare
    %rest:GET
    %rest:path("/dsebaseapp/api/entities")
    %rest:query-param("page[number]", "{$pageNumber}", 1)
    %rest:query-param("page[size]", "{$pageSize}", 20)
    %rest:query-param("format", "{$format}", 'json')
function api:api-list-entities($pageNumber as xs:integer*, $pageSize as xs:integer*, $format as xs:string*){
    let $serialization := switch($format)
        case('xml') return $api:XML
        default return $api:JSON
    let $pageNumber := xs:integer($pageNumber)
    let $pageSize := xs:integer($pageSize)
    let $self := rest:uri()
    let $base := functx:substring-before-last($self,'/')
    let $sequence := collection($app:indices)//tei:*[@xml:id]/tei:*[@xml:id]
    let $paginator := api:utils-paginator($self, $pageNumber, $pageSize, $sequence)
    let $content := 
    for $x in $paginator?sequence
        let $id := data($x/@xml:id)
        let $title := normalize-space(string-join($x/*[1]//text(), ' '))
        let $self := string-join(($paginator?endpoint, $id), '/')
        return
            <data>
                <type>{name($x)}</type>
                <id>{$id}</id>
                <attributes>
                    <title>{$title}</title>
                </attributes>
                <links>
                    <self>
                        {$self}
                    </self>
                </links>
            </data>
    let $result := 
        <result>
            {$paginator?meta}
            {$content}
        </result>
    return
        ($serialization, $result)
};


(:~
 : API-Endpoint to display an XML/TEI document
 : 
 : @param $id The name of the document which should be showed
 : @return The xml-node identified by the passed in xml:id
~:)

declare 
    %rest:GET
    %rest:path("/dsebaseapp/api/collections/{$collection}/{$id}")
function api:api-show-doc($collection as xs:string, $id as xs:string) {
    let $result := doc($config:app-root||'/data/'||$collection||'/'||$id)
    return 
       ($api:XML, $result)
};


(:~
 : API-Endpoint for an entity
 :
 : @param $id The xml:id of an xml-node located in the app's indices directory
 : @return The xml-node with the matching xml:id
:)

declare
    %rest:GET
    %rest:path("/dsebaseapp/api/entities/{$id}")
function api:api-show-entity($id as xs:string){
    let $entity := collection($app:indices)//id($id)
    return
    ($api:XML, $entity)
};


(:~
 : API-Endpoint to list all entity-types (i.d. all TEI documents stored in the app's indices directory 
 :
 : @return A JSON-API list of all entity-types
:)

declare
    %rest:GET
    %rest:path("/dsebaseapp/api/entity-types")
    %rest:query-param("page[number]", "{$pageNumber}", 1)
    %rest:query-param("page[size]", "{$pageSize}", 20)
    %rest:query-param("format", "{$format}", 'json')
function api:api-list-entity-types($pageNumber as xs:integer*, $pageSize as xs:integer*, $format as xs:string*){
    let $serialization := switch($format)
        case('xml') return $api:XML
        default return $api:JSON
    let $pageNumber := xs:integer($pageNumber)
    let $pageSize := xs:integer($pageSize)
    let $self := rest:uri()
    let $base := functx:substring-before-last($self,'/')
    let $sequence := collection($app:indices)//tei:TEI
    let $paginator := api:utils-paginator($self, $pageNumber, $pageSize, $sequence)
    let $content := 
            for $x in $paginator?sequence
                let $id := app:getDocName($x)
                let $title := replace(substring-after($id, 'list'), '.xml', '')||'s'
                let $self := string-join(($paginator?endpoint, $id), '/')
                return
                    <data>
                        <type>Entity Type</type>
                        <id>{$id}</id>
                        <attributes>
                            <title>{$title}</title>
                        </attributes>
                        <links>
                            <self>
                                {$self}
                            </self>
                        </links>
                    </data>
    let $result := 
        <result>
            {$paginator?meta}
            {$content}
        </result>
    return 
        ($serialization, $result)
};

(:~
 : API-Endpoint to display an XML/TEI document stored in the app's indices directory
 : 
 : @param $id The name of the document which should be showed
 : @return The xml-node identified by the passed in xml:id
~:)

declare 
    %rest:GET
    %rest:path("/dsebaseapp/api/entity-types/{$id}")
function api:api-show-ent-type-doc($id as xs:string) {
    let $result := doc($app:indices||'/'||$id)
    return 
       ($api:XML, $result)
};

