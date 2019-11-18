xquery version "3.1";
import module namespace config="http://www.digital-archiv.at/ns/config" at "../modules/config.xqm";

declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace wgs84_pos="http://www.w3.org/2003/01/geo/wgs84_pos#";
(: Wien Geschichte Wiki :)
declare namespace property="http://www.geschichtewiki.wien.gv.at/Special:URIResolver/Property-3A";
(: SPARQL :)
declare namespace sparql="http://www.w3.org/2005/sparql-results#";

(: Functions :)

declare function local:getCoordsFromGeonamesRDF($GN as xs:string) {
    (:~
 : Get coordinates from Geonames RDF for a GeonamesID. Returns coordinates as string lat lon separated by whitespace
 : 
 : @param $GN GeonamesID as string
 :)

    
    (: "http://sws.geonames.org/7530819/about.rdf" :)
    let $rdfURL := "http://sws.geonames.org/" || $GN || "/about.rdf"
    let $RDF := doc($rdfURL)
    (: <wgs84_pos:lat>50.00545</wgs84_pos:lat> <wgs84_pos:long>21.98848</wgs84_pos:long> :)
    let $lat := $RDF//wgs84_pos:lat/text()
    let $long := $RDF//wgs84_pos:long/text()
    return
        $lat || " " || $long
};

declare function local:getCoordsFromWienwiki($URL as xs:string) {
    (:~
    : Get coordinates from Wien Geschichte Wiki for a Street in Vienna. Returns coordinates as string lat long separated by whitespace.
    :
    : @param $URL URL of WienWiki Page
    :)
    
    let $wienwikiID := substring-after($URL,'https://www.wien.gv.at/wiki/index.php?title=')
    (: https://www.wien.gv.at/wiki/index.php?title=Gersthofer_Stra%C3%9Fe :)
    (: https://www.geschichtewiki.wien.gv.at/Spezial:RDF_exportieren/Gersthofer_Stra%C3%9Fe :)
    let $RDF := doc("https://www.geschichtewiki.wien.gv.at/Spezial:RDF_exportieren/" || $wienwikiID)
    
    let $coords := replace($RDF//property:Koordinaten-23aux/text(),',',' ')
    return $coords
};


declare function local:getCordsfromWikidata($Q as xs:string) {
    (:~
    : Get Coordinates based on wikidata by SPARQL Query
    : @param $Q Wikidata-QNummer
    :)
    
    let $query-url := "https://query.wikidata.org/sparql?query="
    let $query := "SELECT ?coords WHERE { " || "wd:" || $Q || " wdt:P625 ?coords . }"
    let $encoded-query := $query-url || encode-for-uri($query)

    let $request := 
        <hc:request href="{$encoded-query}" method="GET">
            <hc:header name="Connection" value="close"/>    
        </hc:request>
    let $data := hc:send-request($request)
    
    let $coordsString := $data//sparql:results/sparql:result/sparql:binding[@name='coords']/sparql:literal/text()
    let $lat := substring-before(tokenize($coordsString, ' ')[2],')')
    let $long := substring-after(tokenize($coordsString, ' ')[1],'Point(')
    return $lat || ' ' || $long
};

(:  
let $targetXML := request:get-parameter('id','none')
:)
(: Set here xml:id of file to process :)
let $targetXML := "hbas_places"
return
    if ($targetXML != 'none') then
        let $data := collection($config:data-root)/id($targetXML)//tei:listPlace/tei:place
        
        for $entity in $data
            (:Test, was da is:)
            return
            if ($entity/tei:idno[@subtype='GEONAMES'])
            (:place has geonames identifier:)
                then
                    let $GN := substring-after($entity/tei:idno[@subtype='GEONAMES'][1]/text(),'http://www.geonames.org/')
                    let $coords := local:getCoordsFromGeonamesRDF($GN)
                    let $geo := 
                    <geo xmlns="http://www.tei-c.org/ns/1.0">{$coords}</geo>
                    return 
                        update insert $geo into $entity/tei:location
                    (: Wikidata :)
                else if ($entity/tei:idno[@subtype='WIKIDATA']) then 
                    let $Q := substring-after($entity/tei:idno[@subtype='WIKIDATA'][1]/text(),'https://www.wikidata.org/wiki/')
                    let $coords := local:getCoordsFromGeonamesRDF($Q)
                    let $geo := 
                    <geo xmlns="http://www.tei-c.org/ns/1.0">{$coords}</geo>
                    return 
                        update insert $geo into $entity/tei:location
                    (:Wien Wiki:)
                else if ($entity/tei:idno[@subtype='WIENWIKI']) then
                    let $URL := $entity/tei:idno[@subtype='WIENWIKI'][1]/text()
                    let $coords := local:getCoordsFromWienwiki($URL)
                    let $geo := 
                    <geo xmlns="http://www.tei-c.org/ns/1.0">{$coords}</geo>
                    return 
                        update insert $geo into $entity/tei:location
                else ()

        
        
    else "Parameter $id is not set!"



(: TESTS :)
(: <idno type="URL" subtype="GEONAMES">http://www.geonames.org/7530819</idno> :)

(:  testing Geonames
    let $testdata := "7530819"
    return local:getCoordsFromGeonamesRDF($testdata) 
:)

(: testing Wienwiki  return local:getCoordsFromWienwiki("https://www.wien.gv.at/wiki/index.php?title=Florianigasse") :)

(: testing: wikidata coords :)
(: let $Q := "Q2240079"  :)
(:  return local:getCordsfromWikidata($Q) :)






