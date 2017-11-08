<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <!-- created 2017-07-12 editor:DK = Dario Kampkaspar, dario.kampkaspar@oeaw.ac.at -->
    
    <xsl:output method="html" indent="yes"/>
    <xsl:param name="entiyID" as="xs:string"/>
    <xsl:param name="render" select="false()" as="xs:boolean"/>
    <xsl:variable name="tei-root">http://www.tei-c.org/release/doc/tei-p5-doc/en/html/ref-</xsl:variable>
    
    <xsl:template match="/">
        <html>
            <head>
                <xsl:if test="$render">
                    <link rel="stylesheet" href="style.css"/>
                </xsl:if>
                <style>p.capitalize {
                        text-transform: capitalize;
                    }</style>
            </head>
            <body>
                <div class="modal" id="myModal" role="dialog">
                <div class="modal-dialog"><!-- Modal content-->
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal">
                                <span class="fa fa-times"/>
                            </button>
                            <h4 class="modal-title" style="font-variant: small-caps">
                                <small>node id:</small> <xsl:value-of select="$entiyID"/>
                            </h4>
                        </div>
                        <div class="modal-body">
                            <xsl:choose>
                                <xsl:when test="//*[contains(@xml:id, $entiyID) or contains(@id, $entiyID)]">
                                    <xsl:apply-templates select="//*[contains(@xml:id, $entiyID) or contains(@id, $entiyID)]" mode="start"/>
                                </xsl:when>
                                <xsl:otherwise>Looks like there exists no index entry for ID<strong>
                                        <xsl:value-of select="concat(' ', $entiyID)"/>
                                    </strong> 
                                </xsl:otherwise>
                            </xsl:choose>
                        </div>
                    </div>
                </div>
                </div>
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="*" mode="start">
        <a>
            <xsl:attribute name="href">
                <xsl:value-of select="concat($tei-root, local-name())"/>
            </xsl:attribute>
            <xsl:value-of select="local-name()"/>
        </a>
        <ul>
            <xsl:apply-templates select="node()|@*"/>
        </ul>
    </xsl:template>
    
    <xsl:template match="node()[node() or @*]">
        <li>
            <a>
                <xsl:attribute name="href">
                    <xsl:value-of select="concat($tei-root, local-name())"/>
                </xsl:attribute>
                <xsl:value-of select="local-name()"/>
            </a>
            <ul>
                <xsl:apply-templates select="node()|@*"/>
            </ul>
        </li>
    </xsl:template>
    
    <xsl:template match="text()[normalize-space()='']"/>
    
    <xsl:template match="node()[not(node() or @*) and string-length(normalize-space()) &gt; 0]">
        <li>
            <xsl:choose>
                <xsl:when test="self::text()">
                    <!--<small>text()</small>-->
                    <xsl:value-of select="."/>
                </xsl:when>
                <xsl:otherwise>
                    <small>
                        <xsl:value-of select="name()"/>
                    </small>
                </xsl:otherwise>
            </xsl:choose>
        </li>
    </xsl:template>
    
    <xsl:template match="@*">
        <li>
            <small>@<xsl:value-of select="name()"/>
            </small>: <xsl:value-of select="."/>
        </li>
    </xsl:template>
</xsl:stylesheet>