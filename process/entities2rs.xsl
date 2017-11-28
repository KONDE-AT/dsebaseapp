<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs tei" version="2.0">
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:persName">
        <rs>
            <xsl:attribute name="type">person</xsl:attribute>
            <xsl:attribute name="ref">
                <xsl:value-of select="data(./@key)"/>
            </xsl:attribute>
            <xsl:apply-templates select="@*|node()"/>
        </rs>
    </xsl:template>
    
    <xsl:template match="tei:placeName">
        <rs>
            <xsl:attribute name="type">place</xsl:attribute>
            <xsl:attribute name="subtype">place</xsl:attribute>
            <xsl:apply-templates select="@*|node()"/>
        </rs>
    </xsl:template>
    <xsl:template match="tei:country">
        <rs>
            <xsl:attribute name="type">place</xsl:attribute>
            <xsl:attribute name="subtype">country</xsl:attribute>
            <xsl:apply-templates select="@*|node()"/>
        </rs>
    </xsl:template>
    <xsl:template match="tei:region">
        <rs>
            <xsl:attribute name="type">place</xsl:attribute>
            <xsl:attribute name="subtype">region</xsl:attribute>
            <xsl:apply-templates select="@*|node()"/>
        </rs>
    </xsl:template>
    
    <xsl:template match="tei:revisionDesc">
        <revisionDesc>
            <list>
                <item>approved by Mazohl</item>
            </list>
        </revisionDesc>
    </xsl:template>
    
</xsl:stylesheet>