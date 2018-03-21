xquery version "3.1";
import module namespace config="http://www.digital-archiv.at/ns/dsebaseapp/config" at "../modules/config.xqm";
import module namespace app="http://www.digital-archiv.at/ns/dsebaseapp/templates" at "../modules/app.xql";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare option exist:serialize "method=json media-type=text/javascript";

(:transforms a CMFI document into a JSON which can be processed by visjs into a network graph:)

let $result := 
    <result>{
        
        for $doc at $pos in collection($app:editions)//tei:TEI
            let $title := $doc//tei:titleStmt/tei:title[@type='sub']/text()
            return
                <nodes>
                    <id>{$pos}</id>
                    <title>{$title}</title>
                    <color>red</color>
                </nodes>
    }
    {
        
        for $doc at $pos in collection($app:editions)//tei:TEI
            let $title := $doc//tei:titleStmt/tei:title[@type='sub']
            let $docID := $pos
            for $person in $doc//tei:body//tei:rs[@type="person"]
                let $key := data($person/@ref)
                group by $key
                    return
                        <nodes>
                            <id>{$key}</id>
                            <title>{$person[1]/text()}</title>
                            <color>blue</color>
                        </nodes>
    }
    {
        for $doc at $pos in collection($app:editions)//tei:TEI
            for $person in $doc//tei:body//tei:rs[@type="person"]
            let $key := data($person/@ref)
                return
                    <edges>
                        <from>{$pos}</from>
                        <to>{$key}</to>
                    </edges>
     }
     
     {
        
        for $doc at $pos in collection($app:editions)//tei:TEI
            let $title := $doc//tei:titleStmt/tei:title[@type='sub']
            let $docID := $pos
            for $person in $doc//tei:body//tei:rs[@type="org"]
                let $key := data($person/@ref)
                group by $key
                    return
                        <nodes>
                            <id>{$key}</id>
                            <title>{$person[1]/text()}</title>
                            <color>green</color>
                        </nodes>
    }
    {
        for $doc at $pos in collection($app:editions)//tei:TEI
            for $person in $doc//tei:body//tei:rs[@type="org"]
            let $key := data($person/@ref)
                return
                    <edges>
                        <from>{$pos}</from>
                        <to>{$key}</to>
                    </edges>
     }
     {
        
        for $doc at $pos in collection($app:editions)//tei:TEI
            let $title := $doc//tei:titleStmt/tei:title[@type='sub']
            let $docID := $pos
            for $person in $doc//tei:body//tei:rs[@type="work"]
                let $key := data($person/@ref)
                group by $key
                    return
                        <nodes>
                            <id>{$key}</id>
                            <title>{$person[1]/text()}</title>
                            <color>grey</color>
                        </nodes>
    }
    {
        for $doc at $pos in collection($app:editions)//tei:TEI
            for $person in $doc//tei:body//tei:rs[@type="work"]
            let $key := data($person/@ref)
                return
                    <edges>
                        <from>{$pos}</from>
                        <to>{$key}</to>
                    </edges>
     }
    </result>
return
    $result
