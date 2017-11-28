<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs tei" version="2.0">
    <xsl:variable name="sender">
        <xsl:for-each select=".//tei:rs[contains(./@role, 'sender')]">
            <persName>
                <xsl:attribute name="ref">
                    <xsl:value-of select="./@ref"/>
                </xsl:attribute>
                <xsl:value-of select="normalize-space(./text()[1])"/>
            </persName>
        </xsl:for-each>
        
    </xsl:variable>
    
    <xsl:variable name="sender-place">
        <xsl:choose>
            <xsl:when test="exists(.//tei:titleStmt/tei:title/tei:rs[@type='place'][last()]/@ref[1])">
                <settlement>
                    <xsl:attribute name="ref">
                        <xsl:value-of select=".//tei:titleStmt/tei:title/tei:rs[@type='place'][last()]/@ref[1]"/>
                    </xsl:attribute>
                    <xsl:value-of select="normalize-space(.//tei:titleStmt/tei:title/tei:rs[@type='place'][last()]/text())"/>
                </settlement>
            </xsl:when>
        </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="sender-date">
        <xsl:choose>
            <xsl:when test=".//tei:titleStmt/tei:title/tei:date/@when castable as xs:date">
                <date>
                    <xsl:attribute name="when">
                        <xsl:value-of select=".//tei:titleStmt/tei:title/tei:date/@when"/>
                    </xsl:attribute>
                    <xsl:value-of select="string-join(.//tei:titleStmt/tei:title/tei:date//text(), ' ')"/>
                </date>
            </xsl:when>
            <xsl:otherwise>
                <date>
                    <xsl:value-of select="string-join(.//tei:titleStmt/tei:title/tei:date//text(), ' ')"/>
                </date>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="receiver">
        <xsl:choose>
            <xsl:when test="exists(.//tei:rs[contains(./@role, 'recipient')])">
                <xsl:for-each select=".//tei:rs[contains(./@role, 'recipient')]">
                    <persName>
                        <xsl:attribute name="ref">
                            <xsl:value-of select="./@ref"/>
                        </xsl:attribute>
                        <xsl:value-of select="normalize-space(./text()[1])"/>
                    </persName>
                </xsl:for-each>
            </xsl:when>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="exists(.//tei:rs[contains(./@role, 'sender')]) and not(exists(.//tei:rs[contains(./@role, 'recipient')])) and count(.//tei:titleStmt/tei:title//tei:rs[@type='person']) gt 1">
                <persName>
                    <xsl:attribute name="ref">
                        <xsl:value-of select=".//tei:titleStmt/tei:title/tei:rs[@type='person'][last()]/@ref"/>
                    </xsl:attribute>
                    <xsl:value-of select="normalize-space(.//tei:titleStmt/tei:title/tei:rs[@type='person'][last()]/text()[1])"/>
                </persName>
            </xsl:when>
        </xsl:choose>
        
        
        
    </xsl:variable>
    
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:fileDesc">
        <xsl:copy-of select="."/>
        <xsl:choose>
            <xsl:when test="exists(.//tei:rs[contains(./@role, 'sender')]/@ref) and count($receiver//*) gt 0">
                <profileDesc>
                    <correspDesc>
                        <correspAction type="sent">
                            <xsl:copy-of select="$sender"/>
                            <xsl:copy-of select="$sender-place"/>
                            <xsl:copy-of select="$sender-date"/>
                        </correspAction>
                        <correspAction type="received">
                            <xsl:copy-of select="$receiver"/>
                        </correspAction>
                    </correspDesc>
                </profileDesc>
            </xsl:when>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="exists(.//tei:rs[contains(./@role, 'sender')]/@ref) and count($receiver//*) eq 0">
                <profileDesc>
                    <correspDesc>
                        <correspAction type="sent">
                            <xsl:copy-of select="$sender"/>
                            <xsl:copy-of select="$sender-place"/>
                            <xsl:copy-of select="$sender-date"/>
                        </correspAction>
                    </correspDesc>
                </profileDesc>
            </xsl:when>
        </xsl:choose>    
    </xsl:template>
    
   
</xsl:stylesheet>