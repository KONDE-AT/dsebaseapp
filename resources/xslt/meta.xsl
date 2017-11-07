<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="tei" version="2.0"><!-- <xsl:strip-space elements="*"/>-->
    <xsl:param name="ref"/><!--
##################################
### Seitenlayout und -struktur ###
##################################
-->
    <xsl:template match="/">
        <div class="page-header" align="center">
            <h2>
                <xsl:for-each select="//tei:fileDesc/tei:titleStmt/tei:title">
                    <xsl:apply-templates/>
                    <!--<xsl:value-of select="."/>-->
                    <br/>
                </xsl:for-each>
            </h2>
            <h4>by<br/>
                <xsl:for-each select="//tei:titleStmt//tei:author//tei:persName">
                    <xsl:apply-templates select="."/>
                    <br/>
                </xsl:for-each>
            </h4>
        </div>
        <div>
                <xsl:apply-templates select="//tei:text"/>
            
            <div class="panel-footer">
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
                                <xsl:choose>
                                    <xsl:when test=".//tei:ptr">
                                        <xsl:for-each select=".//tei:ptr">
                                            <xsl:variable name="selctedID">
                                                <xsl:value-of select="substring-after(data(./@target),'#')"/>
                                            </xsl:variable>
                                            <xsl:variable name="selectedBook">
                                                <xsl:value-of select="ancestor::tei:TEI//tei:biblStruct[@xml:id=$selctedID]"/>
                                            </xsl:variable>
                                            <xsl:choose>
                                                <xsl:when test="ancestor::tei:TEI//tei:biblStruct[@xml:id=$selctedID]//tei:persName">
                                                    <xsl:value-of select=" string-join(ancestor::tei:TEI//tei:biblStruct[@xml:id=$selctedID]//tei:surname, '/')"/>,
                                                <xsl:value-of select="ancestor::tei:TEI//tei:biblStruct[@xml:id=$selctedID]//tei:date[1]"/>
                                                    <xsl:apply-templates/>
                                                    <xsl:if test="position() &lt; last()">; </xsl:if>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select=" string-join(ancestor::tei:TEI//tei:biblStruct[@xml:id=$selctedID]//tei:author, '/')"/>,
                                                    <xsl:value-of select="ancestor::tei:TEI//tei:biblStruct[@xml:id=$selctedID]//tei:date[1]"/>
                                                    <xsl:apply-templates/>
                                                    <xsl:if test="position() &lt; last()">; </xsl:if>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="."/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </div>
                        </xsl:for-each>
                    </p>
                    <p style="text-align:center;">
                        <a id="link_to_source"/>
                    </p>
                </div>
            </div>
        </div>
        <script type="text/javascript">
            // creates a link to the xml version of the current docuemnt available via eXist-db's REST-API
            var params={};
            window.location.search
            .replace(/[?&amp;]+([^=&amp;;]+)=([^&amp;;]*)/gi, function(str,key,value) {
            params[key] = value;
            }
            );
            var collection;
            if (params['directory'] === "undefined"  || params['directory'] === "") {
            collection = 'editions';
            } else {
            collection = params['directory']
            }
            var path = window.location.origin+window.location.pathname;
            var replaced = path.replace("exist/apps/", "exist/rest/db/apps/");
            current_html = window.location.pathname.substring(window.location.pathname.lastIndexOf("/") + 1)
            var source_dokument = replaced.replace("pages/"+current_html, "data/"+collection+"/"+params['document']);
            // console.log(source_dokument)
            $( "#link_to_source" ).attr('href',source_dokument);
            $( "#link_to_source" ).text(source_dokument);
        </script>
    </xsl:template><!--
    #####################
    ###  Formatierung ###
    #####################
-->
    <xsl:template match="tei:gi">
        <code>
            <xsl:apply-templates/>
        </code>
    </xsl:template>
    <xsl:template match="tei:list">
        <ul>
            <xsl:apply-templates/>
        </ul>
    </xsl:template>
    <xsl:template match="tei:item">
        <li>
            <xsl:apply-templates/>
        </li>
    </xsl:template>
    <xsl:template match="tei:ref">
        <a>
            <xsl:attribute name="href">
                <xsl:value-of select="@target"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </a>
    </xsl:template>
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
    </xsl:template><!--
    #####################
    ###  entity-index-linking ###
    #####################
-->
    <xsl:template match="tei:rs[@key]">
        <strong style="color:green" class="linkedEntity">
            <xsl:attribute name="data-key">
                <xsl:value-of select="substring-after(current()/@key, ':')"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </strong>
    </xsl:template>
    <xsl:template match="tei:abstract">
        <xsl:apply-templates/>
    </xsl:template><!-- resp -->
    <xsl:template match="tei:respStmt/tei:resp">
        <xsl:apply-templates/>&#160;
    </xsl:template>
    <xsl:template match="tei:respStmt/tei:name">
        <xsl:for-each select=".">
            <li>
                <xsl:apply-templates/>
            </li>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="tei:msItem">
        <xsl:for-each select=".">
            <p>
                <ul>
                    <xsl:for-each select="./*">
                        <li>
                            <strong>
                                <xsl:value-of select="name(.)"/>
                            </strong>: <xsl:apply-templates select="."/>
                        </li>
                    </xsl:for-each>
                </ul>
            </p>
        </xsl:for-each>
    </xsl:template><!-- additions -->
    <xsl:template match="tei:add">
        <xsl:element name="span">
            <xsl:attribute name="style">
                <xsl:text>color:blue;</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="title">
                <xsl:choose>
                    <xsl:when test="@place='margin'">
                        <xsl:text>zeitgenössische Ergänzung am Rand</xsl:text>(<xsl:value-of select="./@place"/>).
                    </xsl:when>
                    <xsl:when test="@place='above'">
                        <xsl:text>zeitgenössische Ergänzung oberhalb</xsl:text>(<xsl:value-of select="./@place"/>)
                    </xsl:when>
                    <xsl:when test="@place='below'">
                        <xsl:text>zeitgenössische Ergänzung unterhalb</xsl:text>(<xsl:value-of select="./@place"/>)
                    </xsl:when>
                    <xsl:when test="@place='inline'">
                        <xsl:text>zeitgenössische Ergänzung in der gleichen Zeile</xsl:text>(<xsl:value-of select="./@place"/>)
                    </xsl:when>
                    <xsl:when test="@place='top'">
                        <xsl:text>zeitgenössische Ergänzung am oberen Blattrand</xsl:text>(<xsl:value-of select="./@place"/>)
                    </xsl:when>
                    <xsl:when test="@place='bottom'">
                        <xsl:text>zeitgenössische Ergänzung am unteren Blattrand</xsl:text>(<xsl:value-of select="./@place"/>)
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>zeitgenössische Ergänzung am unteren Blattrand</xsl:text>(<xsl:value-of select="./@place"/>)
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:text/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:persName">
        <xsl:choose>
            <xsl:when test="@ref">
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="@ref"/>
                    </xsl:attribute>
                    <xsl:value-of select="concat(./tei:forename, ' ', ./tei:surname)"/>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat(./tei:forename, ' ', ./tei:surname)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template><!-- Bücher -->
    <xsl:template match="tei:bibl">
        <li>
            <xsl:apply-templates/>
        </li>
    </xsl:template>
    <xsl:template match="tei:biblStruct">
        <xsl:choose>
            <xsl:when test="./tei:analytic">
                <li>
                    <xsl:if test=".//tei:author/tei:persName">
                        <xsl:for-each select=".//tei:author">
                            <span style="font-variant:small-caps">
                                <xsl:value-of select=".//tei:surname"/>
                            </span>, <xsl:value-of select=".//tei:forename"/>
                            <xsl:if test="position() &lt; last()">/</xsl:if>
                        </xsl:for-each>
                        <text>:</text>
                    </xsl:if>
                    <i>
                        <xsl:value-of select="./tei:analytic/tei:title"/>
                    </i>
                    <text>in:</text>
                    <i>
                        <xsl:value-of select=".//tei:monogr/tei:title"/>
                    </i>
                    <xsl:if test=".//tei:monogr/tei:editor">
                        <text>ed. by:</text>
                        <xsl:for-each select=".//tei:monogr/tei:editor">
                            <span style="font-variant:small-caps">
                                <xsl:value-of select=".//tei:surname"/>
                            </span>,<xsl:value-of select=".//tei:forename"/>
                            <xsl:if test="position() &lt; last()">/</xsl:if>
                        </xsl:for-each>
                    </xsl:if>
                    <text>,</text>
                    <xsl:value-of select="string-join(.//tei:monogr//tei:imprint/*/text(), ', ')"/>.
                    <xsl:if test=".//tei:ref">
                        <xsl:apply-templates select=".//tei:ref"/>
                    </xsl:if>
                </li>
            </xsl:when>
            <xsl:otherwise>
                <li>
                    <xsl:for-each select=".//tei:author">
                        <span style="font-variant:small-caps">
                            <xsl:value-of select=".//tei:surname"/>
                        </span>, <xsl:value-of select=".//tei:forename"/>
                        <xsl:if test="position() &lt; last()">/</xsl:if>
                    </xsl:for-each>
                    <xsl:for-each select=".//tei:editor">
                        <span style="font-variant:small-caps">
                            <xsl:value-of select=".//tei:surname"/>
                        </span>, <xsl:value-of select=".//tei:forename"/>
                        <xsl:if test="position() &lt; last()">/</xsl:if>
                    </xsl:for-each>
                    <text>:</text>
                    <i>
                        <xsl:value-of select=".//tei:title"/>
                    </i>
                    <text>,</text>
                    <xsl:value-of select="string-join(.//tei:monogr//tei:imprint/*/text(), ', ')"/>.
                    <xsl:if test=".//tei:ref">
                        <xsl:apply-templates select=".//tei:ref"/>
                    </xsl:if>
                </li>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:monogr">
        <xsl:for-each select="child::node()">
            <xsl:apply-templates/>&#160;</xsl:for-each>
    </xsl:template>
    <xsl:template match="tei:title">
        <i>
            <xsl:apply-templates/>
        </i>
    </xsl:template><!-- Seitenzahlen -->
    <xsl:template match="tei:pb">
        <xsl:element name="div">
            <xsl:attribute name="style">
                <xsl:text>text-align:right;</xsl:text>
            </xsl:attribute>
            <a target="_blank">
                <xsl:attribute name="href">
                    <xsl:value-of select="replace(@facs,'../../imgs', '../facs')"/>
                </xsl:attribute>
                <xsl:value-of select="concat('[Bl. ', @n, ']')"/>
            </a>
        </xsl:element>
        <xsl:element name="hr"/>
    </xsl:template><!-- Tabellen -->
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
    </xsl:template><!-- Überschriften -->
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
    </xsl:template><!--  Quotes / Zitate -->
    <xsl:template match="tei:q">
        "<xsl:apply-templates/>"
    </xsl:template><!-- Zeilenumbürche   -->
    <xsl:template match="tei:lb">
        <br/>
    </xsl:template><!-- Absätze    -->
    <xsl:template match="tei:p">
        <xsl:element name="p">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template><!-- Durchstreichungen -->
    <xsl:template match="tei:del">
        <xsl:element name="strike">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>