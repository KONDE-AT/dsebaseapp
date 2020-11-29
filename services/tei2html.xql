xquery version "3.1";
declare namespace functx = "http://www.functx.com";
import module namespace config="http://www.digital-archiv.at/ns/config" at "../modules/config.xqm";
declare namespace tei = "http://www.tei-c.org/ns/1.0";

declare option exist:serialize "method=xhtml media-type=text/html omit-xml-declaration=yes indent=yes";
(: e.g. http://127.0.0.1:8080/exist/apps/teiminator/analyze/visPlace.xql?notBefore=1910-10-10&notAfter=1910-12-01:)
declare option exist:timeout "15000";

let $fallbackXSL := './static/tei2html.xsl'
let $fallbackTEI := './static/fallback-tei.xml'

let $tei := request:get-parameter("tei", $fallbackTEI)
let $xsl := request:get-parameter("xsl", $fallbackXSL)
let $params :=
		<parameters>
		   {for $p in request:get-parameter-names()
		    let $val := request:get-parameter($p,())
		    return
		       <param name="{$p}"  value="{$val}"/>
		   }
		</parameters>
return
	try {
		let $teiFile := doc($tei)
		let $xslFile := doc($xsl)


		return
		    transform:transform($teiFile, $xslFile, $params)
	}
	catch * {
	    <div>
    		<p>Sorry, some error occurred while transforming:</p>
    		<ul>
    		    <li>{$err:code}: {$err:description}</li><li>{$err:line-number}:{$err:column-number}</li><li>a: {$err:additional}</li>
    		</ul>
    		<p>What to do now</p>
    		<ul>
    		    <li>Please check that you xml and xsl are well formed and valid</li>
    		    <li>Please check, if the URLs you entered resolve against the expected documents</li>
    		    <li>If you are sure you didn't make any mistake, <a href="https://github.com/acdh-oeaw/teiminator/issues">please report a bug-issue</a>, with the URL of this current page</li>
    		</ul>
		</div>
		}
