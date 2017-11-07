<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="tei" version="2.0">
    <!-- <xsl:strip-space elements="*"/>-->
    <xsl:param name="document"/>
    <xsl:param name="app-name"/>
    <xsl:param name="collection-name"/>
    <xsl:param name="path2source"/>
    <xsl:param name="ref"/>
    <xsl:param name="searchkey"/>
    <xsl:variable name="hashedSearchkey">
        <xsl:value-of select="concat('#',$searchkey)"/>
    </xsl:variable>
    <!--
##################################
### Seitenlayout und -struktur ###
##################################
-->
    <xsl:template match="/">
        <div class="page-header">
            <h2 align="center">
                <xsl:for-each select="//tei:fileDesc/tei:titleStmt/tei:title">
                    <xsl:apply-templates/>
                    <br/>
                </xsl:for-each>
            </h2>
        </div>
        <div class="regest">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">
                        <h2 align="center">Info</h2>
                    </h3>
                </div>
                <div class="panel-body">
                    <table class="table table-striped">
                        <tbody>
                            <tr>
                                <th>
                                    <abbr title="tei:titleStmt/tei:title">Dokument</abbr>
                                </th>
                                <td>
                                    <xsl:for-each select="//tei:fileDesc/tei:titleStmt/tei:title">
                                        <xsl:apply-templates/>
                                        <br/>
                                    </xsl:for-each>
                                </td>
                            </tr>
                            <xsl:if test="//tei:msIdentifier">
                                <tr>
                                    <th>
                                        <abbr title="//tei:msIdentifie">Signatur</abbr>
                                    </th>
                                    <td>
                                        <xsl:for-each select="//tei:msIdentifier/child::*">
                                            <abbr>
                                                <xsl:attribute name="title">
                                                  <xsl:value-of select="name()"/>
                                                </xsl:attribute>
                                                <xsl:value-of select="."/>
                                            </abbr>
                                            <br/>
                                        </xsl:for-each>
                                        <!--<xsl:apply-templates select="//tei:msIdentifier"/>-->
                                    </td>
                                </tr>
                            </xsl:if>
                            <xsl:if test="//tei:msContents">
                                <tr>
                                    <th>
                                        <abbr title="//tei:msContents">Regest</abbr>
                                    </th>
                                    <td>
                                        <xsl:apply-templates select="//tei:msContents"/>
                                    </td>
                                </tr>
                            </xsl:if>
                            <tr>
                                <th>Schlagwörter</th>
                                <td>
                                    <ul>
                                        <xsl:for-each select="//tei:term">
                                            <li>
                                                <a>
                                                  <xsl:attribute name="href">
                                                  <xsl:value-of select="concat('hits.html?searchkey=', .)"/>
                                                  </xsl:attribute>
                                                  <xsl:attribute name="title">
                                                  <xsl:value-of select="concat('Andere Dokumente mit dem Schlagwort: ', .)"/>
                                                  </xsl:attribute>
                                                  <xsl:value-of select="."/>
                                                </a>
                                            </li>
                                        </xsl:for-each>
                                    </ul>
                                </td>
                            </tr>
                            <xsl:if test="//tei:supportDesc/tei:extent">
                                <tr>
                                    <th>
                                        <abbr title="//tei:supportDesc/tei:extent">Extent</abbr>
                                    </th>
                                    <td>
                                        <xsl:apply-templates select="//tei:supportDesc/tei:extent"/>
                                    </td>
                                </tr>
                            </xsl:if>
                            <tr>
                                <th>Transkription und Kodierung</th>
                                <td>Dieses Dokument wurde von<a href="https://www.uibk.ac.at/geschichte-ethnologie/mitarbeiterinnen/projekt/aichner-christof/">Christof Aichner</a>und <a href="http://dsebaseapp-korrespondenz.uibk.ac.at/?page_id=38">Tanja Kraler</a>transkribiert und nach XML/TEI kodiert.
                                </td>
                            </tr>
                            <xsl:if test="//tei:titleStmt/tei:respStmt">
                                <tr>
                                    <th>
                                        <abbr title="//tei:titleStmt/tei:respStmt">responsible</abbr>
                                    </th>
                                    <td>
                                        <xsl:for-each select="//tei:titleStmt/tei:respStmt">
                                            <p>
                                                <xsl:apply-templates/>
                                            </p>
                                        </xsl:for-each>
                                    </td>
                                </tr>
                            </xsl:if>
                            <tr>
                                <th>
                                    <abbr title="//tei:availability//tei:p[1]">License</abbr>
                                </th>
                                <td align="center">
                                    <a href="https://creativecommons.org/licenses/by-sa/4.0/" class="navlink" target="_blank">
                                        <img src="../resources/img/by-sa.png" alt="eXist-db" width="10%"/>
                                    </a>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <div class="panel-footer">
                        <p style="text-align:center;">
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="$path2source"/>
                                </xsl:attribute>XML-TEI </a>
                        </p>
                    </div>
                </div>
            </div>
        </div>
        <div class="panel panel-default">
            <div class="panel-heading">
                <h3 class="panel-title">
                    <h2 align="center">Transkription </h2>
                </h3>
            </div>
            <div class="panel-body">
                <xsl:element name="ul">
                    <xsl:for-each select="//tei:body//tei:head">
                        <xsl:element name="li">
                            <xsl:element name="a">
                                <xsl:attribute name="href">
                                    <xsl:text>#text_</xsl:text>
                                    <xsl:value-of select="."/>
                                </xsl:attribute>
                                <xsl:attribute name="id">
                                    <xsl:text>nav_</xsl:text>
                                    <xsl:value-of select="."/>
                                </xsl:attribute>
                                <xsl:value-of select="."/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:element>
                <h3>
                    <xsl:apply-templates select="//tei:div[@type = 'titelblatt']"/>
                </h3>
                <p>
                    <xsl:choose>
                        <xsl:when test="//tei:div[@type = 'text']">
                            <xsl:apply-templates select="//tei:div[@type = 'text']"/>
                        </xsl:when>
                        <xsl:when test="//tei:div[@type = 'transcript']">
                            <xsl:apply-templates select="//tei:div[@type = 'transcript']"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select="//tei:body"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </p>
            </div>
            <div class="panel-footer">
                <p style="text-align:center;">
                    <xsl:for-each select="tei:TEI/tei:text/tei:body//tei:note">
                        <div class="footnotes">
                            <xsl:element name="a">
                                <xsl:attribute name="name">
                                    <xsl:text>fn</xsl:text>
                                    <xsl:number level="any" format="1" count="tei:note"/>
                                </xsl:attribute>
                                <a>
                                    <xsl:attribute name="href">
                                        <xsl:text>#fna_</xsl:text>
                                        <xsl:number level="any" format="1" count="tei:note"/>
                                    </xsl:attribute>
                                    <span style="font-size:7pt;vertical-align:super;">
                                        <xsl:number level="any" format="1" count="tei:note"/>
                                    </span>
                                </a>
                            </xsl:element>
                            <xsl:apply-templates/>
                        </div>
                    </xsl:for-each>
                </p>
            </div>
            <script type="text/javascript">// creates a link to the xml version of the current docuemnt available via eXist-db's REST-API var params={}; window.location.search .replace(/[?&amp;]+([^=&amp;]+)=([^&amp;]*)/gi, function(str,key,value) { params[key] = value; } ); var path = window.location.origin+window.location.pathname; var replaced = path.replace("exist/apps/", "exist/rest/db/apps/"); current_html = window.location.pathname.substring(window.location.pathname.lastIndexOf("/") + 1) var source_dokument = replaced.replace("pages/"+current_html, "data/editions/"+params['document']); // console.log(source_dokument) $( "#link_to_source" ).attr('href',source_dokument); $( "#link_to_source" ).text(source_dokument);  </script>
        </div>
    </xsl:template>
    <!--
    #####################
    ###  Formatierung ###
    #####################
-->
    <xsl:template match="tei:term">
        <span/>
    </xsl:template>
    <xsl:template match="tei:hi">
        <xsl:choose>
            <xsl:when test="@rend = 'ul'">
                <u>
                    <xsl:apply-templates/>
                </u>
            </xsl:when>
            <xsl:when test="@rend = 'italic'">
                <i>
                    <xsl:apply-templates/>
                </i>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!--    footnotes -->
    <xsl:template match="tei:note">
        <xsl:element name="a">
            <xsl:attribute name="name">
                <xsl:text>fna_</xsl:text>
                <xsl:number level="any" format="1" count="tei:note"/>
            </xsl:attribute>
            <xsl:attribute name="href">
                <xsl:text>#fn</xsl:text>
                <xsl:number level="any" format="1" count="tei:note"/>
            </xsl:attribute>
            <xsl:attribute name="title">
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:attribute>
            <span style="font-size:7pt;vertical-align:super;">
                <xsl:number level="any" format="1" count="tei:note"/>
            </span>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:div">
        <xsl:choose>
            <xsl:when test="@type = 'regest'">
                <div>
                    <xsl:attribute name="class">
                        <text>regest</text>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </div>
            </xsl:when>
            <!-- transcript -->
            <xsl:when test="@type = 'transcript'">
                <div>
                    <xsl:attribute name="class">
                        <text>transcript</text>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </div>
            </xsl:when>
            <!-- Anlagen/Beilagen  -->
            <xsl:when test="@xml:id">
                <xsl:element name="div">
                    <xsl:attribute name="id">
                        <xsl:value-of select="@xml:id"/>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- Verweise auf andere Dokumente   -->
    <xsl:template match="tei:ref">
        <xsl:choose>
            <xsl:when test="@target[ends-with(., '.xml')]">
                <xsl:element name="a">
                    <xsl:attribute name="href">show.html?document=<xsl:value-of select="tokenize(./@target, '/')[4]"/>
                    </xsl:attribute>
                    <xsl:value-of select="."/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="a">
                    <xsl:attribute name="href">
                        <xsl:value-of select="@target"/>
                    </xsl:attribute>
                    <xsl:value-of select="."/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- resp -->
    <xsl:template match="tei:respStmt/tei:resp">
        <xsl:apply-templates/>&#160; </xsl:template>
    <xsl:template match="tei:respStmt/tei:name">
        <xsl:for-each select=".">
            <li>
                <xsl:apply-templates/>
            </li>
        </xsl:for-each>
    </xsl:template>
    <!-- reference strings   -->
    <xsl:template match="tei:rs[@ref or @key]">
        <xsl:choose>
            <xsl:when test="@ref=$hashedSearchkey">
                <span class="data-hr">
                    <strong>
                        <xsl:element name="a">
                            <xsl:attribute name="class">reference</xsl:attribute>
                            <xsl:attribute name="data-type">
                                <xsl:value-of select="concat('list', data(@type), '.xml')"/>
                            </xsl:attribute>
                            <xsl:attribute name="data-key">
                                <xsl:value-of select="substring-after(data(@ref), '#')"/>
                                <xsl:value-of select="@key"/>
                            </xsl:attribute>
                            <xsl:value-of select="."/>
                        </xsl:element>
                    </strong>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <strong>
                    <xsl:element name="a">
                        <xsl:attribute name="class">reference</xsl:attribute>
                        <xsl:attribute name="data-type">
                            <xsl:value-of select="concat('list', data(@type), '.xml')"/>
                        </xsl:attribute>
                        <xsl:attribute name="data-key">
                            <xsl:value-of select="substring-after(data(@ref), '#')"/>
                            <xsl:value-of select="@key"/>
                        </xsl:attribute>
                        <xsl:value-of select="."/>
                    </xsl:element>
                </strong>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:persName[@key]">
        <strong>
            <xsl:element name="a">
                <xsl:attribute name="class">reference</xsl:attribute>
                <xsl:attribute name="data-type">listperson.xml</xsl:attribute>
                <xsl:attribute name="data-key">
                    <xsl:value-of select="@key"/>
                </xsl:attribute>
                <xsl:value-of select="."/>
            </xsl:element>
        </strong>
    </xsl:template>
    <xsl:template match="tei:placeName[@key]">
        <strong>
            <xsl:element name="a">
                <xsl:attribute name="class">reference</xsl:attribute>
                <xsl:attribute name="data-type">listplace.xml</xsl:attribute>
                <xsl:attribute name="data-key">
                    <xsl:value-of select="@key"/>
                </xsl:attribute>
                <xsl:value-of select="."/>
            </xsl:element>
        </strong>
    </xsl:template>
    <xsl:template match="tei:region[@key] | tei:country[@key]">
        <strong>
            <xsl:element name="a">
                <xsl:attribute name="class">reference</xsl:attribute>
                <xsl:attribute name="data-type">listplace.xml</xsl:attribute>
                <xsl:attribute name="data-key">
                    <xsl:value-of select="@key"/>
                </xsl:attribute>
                <xsl:value-of select="."/>
            </xsl:element>
        </strong>
    </xsl:template>
    <!-- additions -->
    <xsl:template match="tei:add">
        <xsl:element name="span">
            <xsl:attribute name="style">
                <xsl:text>color:blue;</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="title">
                <xsl:choose>
                    <xsl:when test="@place = 'margin'">
                        <xsl:text>zeitgenössische Ergänzung am Rand</xsl:text>(<xsl:value-of select="./@place"/>). </xsl:when>
                    <xsl:when test="@place = 'above'">
                        <xsl:text>zeitgenössische Ergänzung oberhalb</xsl:text>(<xsl:value-of select="./@place"/>) </xsl:when>
                    <xsl:when test="@place = 'below'">
                        <xsl:text>zeitgenössische Ergänzung unterhalb</xsl:text>(<xsl:value-of select="./@place"/>) </xsl:when>
                    <xsl:when test="@place = 'inline'">
                        <xsl:text>zeitgenössische Ergänzung in der gleichen Zeile</xsl:text>(<xsl:value-of select="./@place"/>) </xsl:when>
                    <xsl:when test="@place = 'top'">
                        <xsl:text>zeitgenössische Ergänzung am oberen Blattrand</xsl:text>(<xsl:value-of select="./@place"/>) </xsl:when>
                    <xsl:when test="@place = 'bottom'">
                        <xsl:text>zeitgenössische Ergänzung am unteren Blattrand</xsl:text>(<xsl:value-of select="./@place"/>) </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>zeitgenössische Ergänzung am unteren Blattrand</xsl:text>(<xsl:value-of select="./@place"/>) </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:text/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <!-- Bücher -->
    <xsl:template match="tei:bibl">
        <xsl:element name="strong">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <!-- Seitenzahlen -->
    <xsl:template match="tei:pb">
        <xsl:element name="div">
            <xsl:attribute name="style">
                <xsl:text>text-align:right;</xsl:text>
            </xsl:attribute>
            <xsl:text>[Bl.</xsl:text>
            <xsl:value-of select="@n"/>
            <xsl:text>]</xsl:text>
        </xsl:element>
        <xsl:element name="hr"/>
    </xsl:template>
    <!-- Tabellen -->
    <xsl:template match="tei:table">
        <xsl:element name="table">
            <xsl:attribute name="class">
                <xsl:text>table table-bordered table-striped table-condensed table-hover</xsl:text>
            </xsl:attribute>
            <xsl:element name="tbody">
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:row">
        <xsl:element name="tr">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:cell">
        <xsl:element name="td">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <!-- Überschriften -->
    <xsl:template match="tei:head">
        <xsl:element name="h3">
            <xsl:element name="a">
                <xsl:attribute name="id">
                    <xsl:text>text_</xsl:text>
                    <xsl:value-of select="."/>
                </xsl:attribute>
                <xsl:attribute name="href">
                    <xsl:text>#nav_</xsl:text>
                    <xsl:value-of select="."/>
                </xsl:attribute>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <!--  Quotes / Zitate -->
    <xsl:template match="tei:q">
        <xsl:element name="i">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <!-- Zeilenumbürche   -->
    <xsl:template match="tei:lb">
        <br/>
    </xsl:template>
    <!-- Absätze    -->
    <xsl:template match="tei:p">
        <xsl:element name="p">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <!-- Durchstreichungen -->
    <xsl:template match="tei:del">
        <xsl:element name="strike">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    
</xsl:stylesheet>