xquery version "3.0";
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace output="http://www.w3.org/2010/xslt-xquery-serialization";
import module namespace functx = "http://www.functx.com";
import module namespace util="http://exist-db.org/xquery/util";
import module namespace xmldb="http://exist-db.org/xquery/xmldb";
import module namespace config="http://www.digital-archiv.at/ns/dsebaseapp/config" at "../modules/config.xqm";
import module namespace app="http://www.digital-archiv.at/ns/dsebaseapp/templates" at "../modules/app.xql";

let $params := 
        <output:serialization-parameters>
          <output:omit-xml-declaration value="yes"/>
          <output:encoding value="utf-8"/>
        </output:serialization-parameters>

let $from := ('Á¼', 'Á¤', 'Á¶', 'ÁŸ', 'Áœ')
let $to :=   ('ü', 'ä', 'ö', 'ß', 'Ü')
let $string := util:serialize(doc("hansi.xml"), $params)
let $new := functx:replace-multi($string, $from, $to)
return util:parse($new)

