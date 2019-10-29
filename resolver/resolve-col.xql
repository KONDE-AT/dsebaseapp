xquery version "3.1";
import module namespace app="http://www.digital-archiv.at/ns/templates" at "../modules/app.xql";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare option exist:serialize "method=xml media-type=text/xml omit-xml-declaration=no indent=yes";

let $collection := request:get-parameter('collection', 'editions')
let $docs := collection($app:data||'/'||$collection)//tei:TEI
let $amount := count($docs)
let $result :=
<result>
    <amount>{$amount}</amount>
    {
        for $x in $docs
            let $title := normalize-space(string-join($x//tei:titleStmt/tei:title//text(), ''))
            return
                <doc>
                    <title>{$title}</title>
                    <link>{app:hrefToDoc($x, $collection)}</link>
                    <id>{app:getDocName($x)}</id>
                    <collection>{app:getColName($x)}</collection>
                </doc>
    }
</result>
return $result