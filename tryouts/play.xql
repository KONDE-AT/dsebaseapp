xquery version "3.0";
declare namespace functx = "http://www.functx.com";
import module namespace xmldb="http://exist-db.org/xquery/xmldb";
import module namespace config="http://www.digital-archiv.at/ns/dsebaseproject/config" at "../modules/config.xqm";
import module namespace app="http://www.digital-archiv.at/ns/dsebaseproject/templates" at "../modules/app.xql";
declare namespace tei = "http://www.tei-c.org/ns/1.0";


for $x in collection($app:editions)//tei:TEI//*[@ref="#agassiz-louis"]
return count($x)
