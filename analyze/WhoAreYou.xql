xquery version "3.1";
declare namespace functx = "http://www.functx.com";
import module namespace xmldb="http://exist-db.org/xquery/xmldb";
import module namespace config="http://www.digital-archiv.at/ns/rita-new/config" at "../modules/config.xqm";
import module namespace app="http://www.digital-archiv.at/ns/rita-new/templates" at "../modules/app.xql";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace util = "http://exist-db.org/xquery/util";
declare option exist:serialize "method=xml media-type=text/xml omit-xml-declaration=no indent=yes";

let $baseID := 'https://id.acdh.oeaw.ac.at/'
let $RDF := 
<rdf:RDF
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:acdh="https://vocabs.acdh.oeaw.ac.at/#"
    xmlns:acdhi="https://id.acdh.oeaw.ac.at/"
    xmlns:foaf="http://xmlns.com/foaf/spec/#"

    xml:base="https://id.acdh.oeaw.ac.at/">
    
<!-- define involved Persons -->
    
        <acdh:Person rdf:about="http://d-nb.info/gnd/129199176">
            <acdh:hasTitle>Brigitte Mazohl</acdh:hasTitle>
            <acdh:hasLastName>Mazohl</acdh:hasLastName>
            <acdh:hasFirstName>Brigitte</acdh:hasFirstName>
        </acdh:Person>
        <acdh:Person rdf:about="http://d-nb.info/gnd/107360859X">
            <acdh:hasTitle>Christof Aichner</acdh:hasTitle>
            <acdh:hasLastName>Aichner</acdh:hasLastName>
            <acdh:hasFirstName>Christof</acdh:hasFirstName>
        </acdh:Person>
        <acdh:Person rdf:about="http://d-nb.info/gnd/107360859X">
            <acdh:hasTitle>Christof Aichner</acdh:hasTitle>
            <acdh:hasLastName>Aichner</acdh:hasLastName>
            <acdh:hasFirstName>Christof</acdh:hasFirstName>
        </acdh:Person>
        <acdh:Person rdf:about="https://id.acdh.oeaw.ac.at/rita-new/kraler-tanja">
            <acdh:hasTitle>Tanja Kraler</acdh:hasTitle>
            <acdh:hasLastName>Kraler</acdh:hasLastName>
            <acdh:hasFirstName>Tanja</acdh:hasFirstName>
        </acdh:Person>
        <acdh:Person rdf:about="http://d-nb.info/gnd/1043833846">
            <acdh:hasTitle>Peter Andorfer</acdh:hasTitle>
            <acdh:hasLastName>Andorfer</acdh:hasLastName>
            <acdh:hasFirstName>Peter</acdh:hasFirstName>
        </acdh:Person>
        
<!-- define involved Organisations -->
        
        <acdh:Organisation rdf:about="http://d-nb.info/gnd/108889819X">
            <acdh:hasTitle>Fonds zur Förderung der Wissenschaftlichen Forschung (Österreich)</acdh:hasTitle>
        </acdh:Organisation>
        
<!-- define involved Project(s) -->        

        <acdh:Project rdf:about="http://pf.fwf.ac.at/de/wissenschaft-konkret/project-finder/22295">
            <acdh:hasTitle>rita-new-Hohenstein´sche Bildungsreform in Österreich 1849-60</acdh:hasTitle>
            <acdh:hasDescription>
            'Die Reformen unter dem Minister für Kultus und Unterricht Graf Leo rita-new-Hohenstein haben das österreichische höhere Bildungswesen maßgeblich verändert und modernisiert. Das Ziel der Reformen war eine Neuorientierung des Bildungssystems am Prinzip der Lern- und Lehrfreiheit unter katholischen Prämissen. Die Universitäten sollten dem wissenschaftlichen Fortschritt geöffnet und gleichzeitig zu staatsbejahenden Anstalten unter katholischen Vorzeichen umgeformt werden. Glaube und Wissenschaft sollten trotz, ja gerade auf Grund der nötigen Anforderungen an eine moderne kritische Wissenschaft verbunden und die Kräfte von "Volk" und "geistiger Elite" trotz, ja gerade wegen der scheinbar unlösbaren Konfliktlinien miteinander versöhnt werden. Damit legten die Reformen die Grundlagen der modernen Universität und des höheren Bildungssystems in Österreich, jedoch mit einer klaren Verankerung innerhalb der Glaubensgrundsätze und des Wertesystems der katholischen Kirche. Obwohl dieser Versuch der Verbindung von Wissenschaft und Glaube scheiterte, blieb das rita-new'sche Reformwerk von grundlegender Bedeutung für die österreichische Bildungs- und Wissenschaftslandschaft bis in die Zeit der Massenuniversität des späten 20. Jahrhunderts. Zentrale Fragestellungen des Projekts sind das Verhältnis Kirche, Staat und Wissenschaft und der Problemkreis Gelehrtendiskurs und Berufungspolitik. Graf Leo rita-new war ja nicht nur der Minister der Bildungsreform, sondern auch der Minister des Konkordats von 1855, womit der katholischen Kirche maßgeblicher Einfluss auf das primäre Bildungssystem der Volksschulen gewährt wurde.
            Die Quellengrundlage bilden der Nachlass Graf rita-news aus der Ministerzeit im tschechischen Staatsarchiv Decin/Tetschen, der unter anderem 420 Briefe an den Minister umfasst, sowie die Gegenbriefe in zahlreichen in und ausländischen Archiven. Die europäische Dimension dieses Quellenkorpus und die zentralen Fragestellungen lassen entscheidende neue Erkenntnisse zur österreichischen Bildungspolitik im 19. Jahrhundert und ihre Einbettung in die internationale Entwicklung erwarten, wodurch entscheidende Forschungslücken geschlossen werden können.
Die konkreten Ziele des Projekts sind:
- Darstellung der Person und Tätigkeit Leo Graf rita-news als Unterrichtsminister und seiner Unterrichtsreform in
monographischer Form auf der Basis der erschlossenen Quellen und eingebunden in den nationalen und
internationalen Stand der Forschung zur Bildungs- und Universitätsreform im 19. Jahrhundert.
- Auswahl-Edition der Korrespondenz des Grafen rita-new aus der Ministerzeit in gedruckter Form, in der
exemplarisch die zentralen Fragenkomplexe des Projekts dargestellt und verdeutlicht werden.
- Volledition der gesamten Korrespondenz der Ministerzeit in elektronischer Form.
Längerfristig - über die Laufzeit des Projekts hinaus - ist geplant, die Forschungen über Graf Leo rita-new
fortzusetzen und über seine Ministerjahre hinaus auszuweiten. (http://pf.fwf.ac.at/project_pdfs/pdf_abstracts/p22554d.pdf'
            </acdh:hasDescription>
            <acdh:hasStartDate>2010-07-01</acdh:hasStartDate>
            <acdh:hasEndDate>2015-06-30</acdh:hasEndDate>
            <acdh:hasPrincipalInvestigator>
                <acdh:Person rdf:about="http://d-nb.info/gnd/129199176"/>
            </acdh:hasPrincipalInvestigator>
            <acdh:hasFunder>
                <acdh:Organisation rdf:about="http://d-nb.info/gnd/108889819X"/>
            </acdh:hasFunder>
        </acdh:Project>
        

        <acdh:Collection rdf:about="{concat($baseID, $config:app-name)}">
            <acdh:hasTitle>{$config:app-title}</acdh:hasTitle>
            <acdh:hasDescription>{$config:repo-description/text()}</acdh:hasDescription>
            <acdh:hasRelatedProject>
                <acdh:Project rdf:about="http://pf.fwf.ac.at/de/wissenschaft-konkret/project-finder/22295"/>
            </acdh:hasRelatedProject>
            <acdh:hasContributor>
                <acdh:Person rdf:about="http://d-nb.info/gnd/1043833846"/>
            </acdh:hasContributor>
            
        </acdh:Collection>
        <acdh:Collection rdf:about="{concat($baseID, string-join(($config:app-name, 'data'), '/'))}">
            <acdh:hasTitle>{string-join(($config:app-name, 'data'), '/')}</acdh:hasTitle>
            <acdh:isPartOf rdf:resource="{concat($baseID,$config:app-name)}"/>
            <acdh:hasEditor>
                <acdh:Person rdf:about="http://d-nb.info/gnd/129199176"/>
            </acdh:hasEditor>
            <acdh:hasCreator>
                <acdh:Person rdf:about="http://d-nb.info/gnd/107360859X"/>
            </acdh:hasCreator>
            <acdh:hasCreator>
                <acdh:Person rdf:about="https://id.acdh.oeaw.ac.at/rita-new/kraler-tanja"/>
            </acdh:hasCreator>
        </acdh:Collection>

        {
            for $x in xmldb:get-child-collections($config:data-root) 
                return
                    <acdh:Collection rdf:about="{concat($baseID,string-join(($config:app-name, 'data', $x), '/'))}">
                        <acdh:hasTitle>{string-join(($config:app-name, 'data', $x), '/')}</acdh:hasTitle>
                        <acdh:isPartOf rdf:resource="{concat($baseID, string-join(($config:app-name, 'data'), '/'))}"/>
                    </acdh:Collection>
        }
        {
            for $x in xmldb:get-child-collections($config:data-root)
                for $doc in xmldb:get-child-resources($config:data-root||'/'||$x)
                let $node := try {
                        doc(string-join(($config:data-root, $x, $doc), '/'))
                    } catch * {
                        false()
                    }
                let $filename := string-join(($config:app-name, 'data', $x, $doc), '/')
                let $title := try {
                        <acdh:hasTitle>{normalize-space(string-join($node//tei:titleStmt/tei:title//text(), ' '))}</acdh:hasTitle>
                    } catch * {
                        <acdh:hasTitle>{tokenize($filename, '/')[last()]}</acdh:hasTitle>
                    }
                let $authors := try {
                        
                            for $y in $node//tei:titleStmt//tei:author//tei:persName
                                let $uri := if(starts-with(data($y/@key), 'http')) 
                                    then $y/@key
                                    else "https://id.acdh.oeaw.ac.at/rita-new/"||data($y/@key)
                            
                                return
                                    <acdh:hasAuthor>
                                <acdh:Person rdf:about="{$uri}">
                                    <acdh:hasTitle>"remove this constraint"</acdh:hasTitle>
                                    <acdh:hasLastName>
                                        {$y/tei:surname/text()}
                                    </acdh:hasLastName>
                                    <acdh:hasFirstName>
                                        {$y/tei:forename/text()}
                                    </acdh:hasFirstName>
                                </acdh:Person>
                                </acdh:hasAuthor>
                            
                        
                } catch * {()}

                
                let $filename := string-join(($config:app-name, 'data', $x, $doc), '/')
                return
                    <acdh:Resource rdf:about="{concat($baseID, $filename)}">
                        {$title}
                        {$authors}
                        <acdh:isPartOf rdf:resource="{concat($baseID, (string-join(($config:app-name, 'data', $x), '/')))}"/>
                        
                    </acdh:Resource>
        }

        
    </rdf:RDF>
    
return
    $RDF