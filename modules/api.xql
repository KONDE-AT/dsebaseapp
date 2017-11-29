xquery version "3.0";

module namespace api="http://www.digital-archiv.at/ns/rita-new/api";
declare namespace rest = "http://exquery.org/ns/restxq";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
import module namespace functx = "http://www.functx.com";
import module namespace app="http://www.digital-archiv.at/ns/rita-new/templates" at "app.xql";
import module namespace config="http://www.digital-archiv.at/ns/rita-new/config" at "config.xqm";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare namespace http = "http://expath.org/ns/http-client";

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


(:~ lists content of collection ~:)
declare 
    %rest:GET
    %rest:path("/rita-new/{$collection}/{$format}")
    %rest:query-param("page[number]", "{$pageNumber}", 1)
    %rest:query-param("page[size]", "{$pageSize}", 20)
function api:list-documents($collection, $format, $pageNumber, $pageSize) {
let $result:= api:list-collection-content($collection, $pageNumber, $pageSize)

let $serialization := switch($format)
    case('xml') return $api:XML
    default return $api:JSON
        return 
            ($serialization, $result)
};

(:~ lists content of collection according to datatables API ~:)
declare 
    %rest:GET
    %rest:path("/rita-new/dt/{$collection}/{$format}")
    %rest:query-param("start", "{$start}", 0)
    %rest:query-param("lenght", "{$lenght}", 10)
function api:list-documents($collection, $format, $start, $lenght, $draw) {
let $result:= api:dt-list-collection-content($collection, $start, $lenght, $draw)

let $serialization := switch($format)
    case('xml') return $api:XML
    default return $api:JSON
        return 
            ($serialization, $result)
};

declare 
    %rest:GET
    %rest:path("/rita-new/{$collection}/{$id}/{$format}")
function api:show-document-api($collection, $id, $format) {
    let $result := api:show-document($collection, $id)
    let $serialization := switch($format)
    case('xml') return $api:XML
    default return $api:JSON
    return 
       ($serialization, $result)
};

declare %private function api:dt-list-collection-content($collection as xs:string, $start, $lenght, $draw){
        let $draw := xs:integer($draw)
        let $start := xs:integer($start)+1
        let $lenght := xs:integer($lenght)
        let $docs := collection($config:app-root||'/data/'||$collection)//tei:TEI
        let $all := count($docs)
        let $docs := subsequence($docs, $start, $start+$lenght)
       
        let $result := 
            <result>
                <draw>{$draw}</draw>
                <recordsTotal>{$all}</recordsTotal>
                <recordsFiltered>{$all}</recordsFiltered>
                <meta>
                    <hits>{$all}</hits>
                </meta>
               
                {for $doc in $docs
                
                let $id := app:getDocName($doc)
                    return
                        <data>
                            <type>TEI-Document</type>
                            <id>{$id}</id>
                            <attributes>
                                <title>{normalize-space(string-join($doc//tei:title[1]//text(), ' '))}</title>
                            </attributes>
                        </data>
                 }
            </result>
            return 
                $result
};

declare %private function api:list-collection-content($collection as xs:string, $pageNumber, $pageSize){
    if ($pageNumber castable as xs:integer and $pageSize castable as xs:integer) then
        let $pageNumber := xs:integer($pageNumber)
        let $pageSize := xs:integer($pageSize)
        let $self := rest:uri()
        let $base := functx:substring-before-last($self,'/')
        let $docs := collection($config:app-root||'/data/'||$collection)//tei:TEI
        let $all := count($docs)
        let $docs := subsequence($docs, ($pageNumber - 1)*$pageSize, $pageSize)
        let $first := $self||'?page[number]='||1
        let $prev := if ($pageNumber gt 1) then $pageNumber - 1 else $pageNumber
        let $prev := $self||'?page[number]='||$prev
        let $last := ceiling($all div $pageSize)
        let $next:= if ($pageNumber lt $last) then $pageNumber + 1 else $pageNumber
        let $next := $self||'?page[number]='||$next
        let $last := $self||'?page[number]='||$last
       
        let $result := 
            <result>
                <meta>
                    <hits>{$all}</hits>
                </meta>
                <links>
                    <self>{$self}</self>
                    <first>{$first}</first>
                    <prev>{$prev}</prev>
                    <next>{$next}</next>
                    <last>{$last}</last>
                </links>
               
                {for $doc in $docs
                
                let $path := functx:substring-before-last(document-uri(root($doc)),'/')
                let $id := app:getDocName($doc)
                let $path2me := string-join(($base, $id, 'xml'), '/')
                    return
                        <data>
                            <type>TEI-Document</type>
                            <id>{$id}</id>
                            <attributes>
                                <title>{normalize-space(string-join($doc//tei:title[1]//text(), ' '))}</title>
                                <created>{xmldb:created($path, $id)}</created>
                                <modified>{xmldb:last-modified($path, $id)}</modified>
                            </attributes>
                            <links>
                                <self>{$path2me}</self>
                            </links>
                        </data>
                 }
            </result>
            return 
                $result
    else
        let $result := <error>Page size and page number params need to be of type integer</error>
        return 
            $result
};

declare %private function api:show-document($collection as xs:string, $id as xs:string){
    let $doc := doc($config:app-root||'/data/'||$collection||'/'||$id)
    return 
        $doc
};