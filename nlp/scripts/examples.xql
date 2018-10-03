xquery version "3.1";
import module namespace functx = "http://www.functx.com";
import module namespace 
nlp="http://www.digital-archiv.at/ns/dsebaseapp/nlp" at "../modules/nlp.xqm";
import module namespace util = "http://exist-db.org/xquery/util";
import module namespace httpclient ="http://exist-db.org/xquery/httpclient";
declare namespace tei="http://www.tei-c.org/ns/1.0";

let $collection := '/db/apps/dsebaseapp/data/editions/'
let $input := doc('/db/apps/dsebaseapp/data/editions/rollet.xml')
let $profile := 'default'
let $language := 'de'

(: example for nlp:nlp:custom-tokenizer :)
 return nlp:custom-tokenizer($input, 'default')

(: example for nlp:custom-bulk-tokenize :)
(: make sure you created a collection "nlp/temp" :)
(: return nlp:custom-bulk-tokenize($collection, $profile):)
 
 (: example for nlp:pos-tagging don't use this function, use the next one :)
(: let $tokInput := doc('/db/apps/dsebaseapp/nlp/temp/rollet.xml'):)
(: let $pos := nlp:pos-tagging($tokInput):)
(: return $pos:)
 
  (: example for nlp:pos-tagging-post don't use this function, use the next one :)
(: let $tokInput := doc('/db/apps/dsebaseapp/nlp/temp/bezirkskommissariate-an-stadthauptmannschaft-1851-03-a3-xxi-d109.xml'):)
(: let $pos := nlp:pos-tagging-post($tokInput, $language):)
(: return $pos:)