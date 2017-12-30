xquery version "3.1";
import module namespace functx = "http://www.functx.com";
import module namespace 
nlp="http://www.digital-archiv.at/ns/dsebaseapp/nlp" at "../modules/nlp.xqm";
import module namespace util = "http://exist-db.org/xquery/util";
declare namespace tei="http://www.tei-c.org/ns/1.0";

(:let $collection := '/db/apps/dsebaseapp/data/editions/':)
let $input := doc('/db/apps/dsebaseapp/data/editions/rollet.xml')

(: example for nlp:bulk-tokenize :)
(: return nlp:bulk-tokenize($collection):)

(: example for nlp:tokenize:)
(:let $tokenized := nlp:tokenize($input):)
(:return $tokenized:)

(: example for nlp:clean-encoding:)
(:let $clean := nlp:clean-encoding($tokenized):)
(:return $clean:)

(: example for nlp:tokenize-and-save :)
let $tokenized := nlp:tokenize-and-save($input)
return $tokenized