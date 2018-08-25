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
            
            <div class="card-footer">
                <div class="card-footer">
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
    
</xsl:stylesheet>