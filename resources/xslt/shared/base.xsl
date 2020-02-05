<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:foo="just some local crap" xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="tei" version="2.0">
    <xsl:template match="tei:date[@*]">
       <!-- <abbr>
            <xsl:attribute name="title">
                <xsl:value-of select="data(./@*)"/>
            </xsl:attribute>-->
            <xsl:apply-templates/>
        <!--</abbr>-->
    </xsl:template>
    <xsl:template match="tei:term">
        <span>
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="tei:hi">
        <xsl:choose>
            <xsl:when test="@rend = 'subscript'">
                <span class="subscript">
                    <xsl:apply-templates/>
                </span>
            </xsl:when>
            <xsl:when test="@rend = 'superscript'">
                <span class="superscript">
                    <xsl:apply-templates/>
                </span>
            </xsl:when>
            <xsl:when test="@rend = 'italics'">
               <span class="italics">
                    <xsl:apply-templates/>
                </span>
            </xsl:when>
              <xsl:when test="@rend = 'underline'"> 
              <xsl:choose>
              <xsl:when test="@n='1'">
              <span class="underline">
                    <xsl:apply-templates/>
                </span>
                </xsl:when>
                              <xsl:when test="@n='2'">
              <span class="doubleUnderline">
                    <xsl:apply-templates/>
                </span>
                </xsl:when>
                <xsl:otherwise>
                 <span class="tripleUnderline">
                    <xsl:apply-templates/>
                </span>
                </xsl:otherwise>
                </xsl:choose>
                </xsl:when>
                <xsl:when test="@rend = 'pre-print'">
               <span class="pre-print">
                    <xsl:apply-templates/>
                </span>
            </xsl:when>
            <xsl:when test="@rend = 'bold'">
               <strong>
                    <xsl:apply-templates/>
                </strong>
            </xsl:when>
            <xsl:when test="@rend = 'stamp'">
               <span class="stamp">
                    <xsl:apply-templates/>
                </span>
            </xsl:when>
            <xsl:when test="@rend = 'small_caps'">
               <span class="small_caps">
                    <xsl:apply-templates/>
                </span>
            </xsl:when>
             <xsl:when test="@rend = 'spaced_out'">
               <span class="spaced_out">
                    <xsl:apply-templates/>
                </span>
            </xsl:when>
            <xsl:when test="@rend= 'latintype'">
                <span class="latintype">
                    <xsl:apply-templates/>
                </span>
            </xsl:when>
            <xsl:when test="@rend= 'antiqua'">
                <span class="antiqua">
                    <xsl:apply-templates/>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span>
                    <xsl:attribute name="class">
                        <xsl:value-of select="@rend"/>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </span>
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
            <sup>
                <xsl:number level="any" format="1" count="tei:note[./tei:p]"/>
            </sup>
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
                    <xsl:attribute name="href"> show.html?ref=<xsl:value-of select="tokenize(./@target, '/')[4]"/>
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
        <xsl:apply-templates/>  </xsl:template>
    <xsl:template match="tei:respStmt/tei:name">
        <xsl:for-each select=".">
            <li>
                <xsl:apply-templates/>
            </li>
        </xsl:for-each>
    </xsl:template>
    <!-- reference strings   -->
    <xsl:template match="tei:title[@ref]">
        
            <xsl:element name="a">
                <xsl:attribute name="class">reference</xsl:attribute>
                <xsl:attribute name="data-type">listtitle.xml</xsl:attribute>
                <xsl:attribute name="data-key">
                    <xsl:value-of select="substring-after(data(@ref), '#')"/>
                    <xsl:value-of select="@key"/>
                </xsl:attribute>
                <xsl:value-of select="."/>
            </xsl:element>
        
    </xsl:template>
    <xsl:template match="tei:origPlace[@ref]">
        
            <xsl:element name="a">
                <xsl:attribute name="class">reference</xsl:attribute>
                <xsl:attribute name="data-type">listplace.xml</xsl:attribute>
                <xsl:attribute name="data-key">
                    <xsl:value-of select="substring-after(data(@ref), '#')"/>
                    <xsl:value-of select="@key"/>
                </xsl:attribute>
                <xsl:value-of select="."/>
            </xsl:element>
        
    </xsl:template>
    
    <xsl:template match="tei:author[@ref]">
        
            <xsl:element name="a">
                <xsl:attribute name="class">reference</xsl:attribute>
                <xsl:attribute name="data-type">listperson.xml</xsl:attribute>
                <xsl:attribute name="data-key">
                    <xsl:value-of select="substring-after(data(@ref), '#')"/>
                    <xsl:value-of select="@key"/>
                </xsl:attribute>
                <xsl:value-of select="."/>
            </xsl:element>
        
    </xsl:template>
    
    <!--<xsl:template match="tei:rs[@ref or @key]">
        
            <xsl:element name="a">
                <xsl:attribute name="class">reference</xsl:attribute>
                <xsl:attribute name="data-type">
                    <xsl:value-of select="concat('list', data(@type), '.xml')"/>
                </xsl:attribute>
                <xsl:attribute name="data-key">
                    <xsl:value-of select="substring-after(data(@ref), '#')"/>
                    <xsl:value-of select="@key"/>
                </xsl:attribute>
                <xsl:apply-templates/>
            </xsl:element>
        
    </xsl:template>-->
    <xsl:template match="tei:rs[(@ref or @key) and not(descendant::tei:rs) and not(ancestor::tei:rs)]">
        
        <xsl:element name="a">
            <xsl:attribute name="class">reference</xsl:attribute>
            <xsl:attribute name="data-type">
                <xsl:value-of select="concat('list', data(@type), '.xml')"/>
            </xsl:attribute>
            <xsl:if test="count(tokenize(data(@ref),'\s+')) = 1">
                <xsl:attribute name="data-key">
                    <xsl:value-of select="substring-after(data(@ref), '#')"/>
                    <xsl:value-of select="@key"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="count(tokenize(data(@ref),'\s+')) gt 1">
                <xsl:attribute name="data-keys">
                    <xsl:value-of select="data(@ref)"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </xsl:element>
        
    </xsl:template>
    
    <xsl:template match="tei:rs[(@ref or @key) and descendant::tei:rs and not(ancestor::tei:rs)]">
        <xsl:variable name="unteres-element">
            <xsl:for-each select="descendant::tei:rs">
                <xsl:variable name="type" select="@type"/>
                <xsl:for-each select="tokenize(@ref,' ')">
                <xsl:value-of select="$type"/>
                    <xsl:text>:</xsl:text>
                    <xsl:value-of select="substring-after(.,'#')"/>
                    <xsl:if test="not(position()=last())">
                        <xsl:text> </xsl:text>
                    </xsl:if>
            </xsl:for-each>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="current">
                <xsl:variable name="type" select="@type"/>
                <xsl:for-each select="tokenize(@ref,' ')">
                    <xsl:value-of select="$type"/>
                    <xsl:text>:</xsl:text>
                    <xsl:value-of select="substring-after(.,'#')"/>
                    <xsl:if test="not(position()=last())">
                        <xsl:text> </xsl:text>
                    </xsl:if>
                </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="data-keys" select="concat($current,' ',$unteres-element)"/>
        <xsl:element name="a">
            <xsl:attribute name="class">reference</xsl:attribute>
            <xsl:choose>
                <xsl:when test="count(tokenize($data-keys,'\s+')) = 1">
                    <xsl:attribute name="data-key">
                        <xsl:value-of select="substring-after(data(@ref), '#')"/>
                        <xsl:value-of select="@key"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="data-keys">
                        <xsl:value-of select="$data-keys"/>
                    </xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates/>
        </xsl:element>
        
    </xsl:template>
    
    <xsl:template match="tei:rs[(@ref or @key) and ancestor::tei:rs]">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="tei:persName[@key]">
        
            <xsl:element name="a">
                <xsl:attribute name="class">reference</xsl:attribute>
                <xsl:attribute name="data-type">listperson.xml</xsl:attribute>
                <xsl:attribute name="data-key">
                    <xsl:value-of select="@key"/>
                </xsl:attribute>
                <xsl:value-of select="."/>
            </xsl:element>
        
    </xsl:template>
    <xsl:template match="tei:placeName[@key]">
        
            <xsl:element name="a">
                <xsl:attribute name="class">reference</xsl:attribute>
                <xsl:attribute name="data-type">listplace.xml</xsl:attribute>
                <xsl:attribute name="data-key">
                    <xsl:value-of select="@key"/>
                </xsl:attribute>
                <xsl:value-of select="."/>
            </xsl:element>
        
    </xsl:template>
    <xsl:template match="tei:region[@key] | tei:country[@key]">
        
            <xsl:element name="a">
                <xsl:attribute name="class">reference</xsl:attribute>
                <xsl:attribute name="data-type">listplace.xml</xsl:attribute>
                <xsl:attribute name="data-key">
                    <xsl:value-of select="@key"/>
                </xsl:attribute>
                <xsl:value-of select="."/>
            </xsl:element>
        
    </xsl:template>
    <!-- additions -->
 
    <!-- Bücher -->
    <xsl:template match="tei:bibl">
            <xsl:apply-templates/>
    </xsl:template>
 
    <!-- Tabellen -->
    <xsl:template match="tei:table">
        <xsl:element name="table">
            <xsl:if test="@xml:id">
                <xsl:attribute name="id">
                    <xsl:value-of select="data(@xml:id)"/>
                </xsl:attribute>
            </xsl:if>
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
        <xsl:if test="@xml:id[starts-with(., 'org') or starts-with(., 'ue')]">
            <a>
                <xsl:attribute name="name">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
                <xsl:text> </xsl:text>
            </a>
        </xsl:if>
        <a>
            <xsl:attribute name="name">
                <xsl:text>hd</xsl:text>
                <xsl:number level="any"/>
            </xsl:attribute>
            <xsl:text> </xsl:text>
        </a>
        <h3>
            <div>
                <xsl:apply-templates/>
            </div>
        </h3>
    </xsl:template>
    <!--  Quotes / Zitate -->
    <xsl:template match="tei:q">
        <xsl:element name="i">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:quote">
        <xsl:apply-templates/>
    </xsl:template>
    <!-- Zeilenumbürche   -->
    <xsl:template match="tei:lb">
        <br/>
    </xsl:template>
    <!-- Durchstreichungen -->
    <xsl:template match="tei:origDate[@notBefore and @notAfter]">
        <xsl:variable name="dates">
            <xsl:value-of select="./@*" separator="-"/>
        </xsl:variable>
        <abbr title="{$dates}">
            <xsl:value-of select="."/>
        </abbr>
    </xsl:template>
    <xsl:template match="tei:extent">
        <xsl:apply-templates select="./tei:measure"/>
        <xsl:apply-templates select="./tei:dimensions"/>
    </xsl:template>
    <xsl:template match="tei:measure">
        <xsl:variable name="x">
            <xsl:value-of select="./@type"/>
        </xsl:variable>
        <xsl:variable name="y">
            <xsl:value-of select="./@quantity"/>
        </xsl:variable>
        <abbr title="type: {$x}, quantity: {$y}">Measure</abbr>: <xsl:value-of select="./text()"/>
        <br/>
    </xsl:template>
    <xsl:template match="tei:dimensions">
        <xsl:variable name="x">
            <xsl:value-of select="./@type"/>
        </xsl:variable>
        <xsl:variable name="y">
            <xsl:value-of select="./@unit"/>
        </xsl:variable>
        <abbr title="type: {$x}">Dimensions:</abbr> h: <xsl:value-of select="./tei:height/text()"/>
        <xsl:value-of select="$y"/>, w: <xsl:value-of select="./tei:width/text()"/>
        <xsl:value-of select="$y"/>
        <br/>
    </xsl:template>
    <xsl:template match="tei:layoutDesc">
        <xsl:for-each select="tei:layout">
            <div>
                <xsl:value-of select="./@columns"/> Column(s) à <xsl:value-of select="./@ruledLines | ./@writtenLines"/> ruled/written lines:
                <xsl:apply-templates/>
            </div>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="tei:locus">
        <xsl:variable name="folio-from-id">
            <xsl:value-of select="./@from"/>
        </xsl:variable>
        <xsl:variable name="folio-to-id">
            <xsl:value-of select="./@to"/>
        </xsl:variable>
        <xsl:variable name="url-from-facs">
            <xsl:value-of select="./ancestor::tei:TEI//tei:graphic[@n = $folio-from-id]/@url"/>
        </xsl:variable>
        <xsl:variable name="url-to-facs">
            <xsl:value-of select="./ancestor::tei:TEI//tei:graphic[@n = $folio-to-id]/@url"/>
        </xsl:variable>
        <a href="{$url-from-facs}">
            <xsl:value-of select="$folio-from-id"/>
        </a>-<a href="{$url-to-facs}">
            <xsl:value-of select="./@to"/>
        </a>
    </xsl:template>
    <xsl:template match="tei:handDesc">
        <xsl:for-each select="./tei:handNote">
            <div>
                <xsl:apply-templates/>
            </div>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="tei:title">
        <strong>
            <xsl:apply-templates/>
        </strong>
    </xsl:template>
    
    <xsl:template match="tei:title[ancestor::tei:fileDesc[1]/tei:titleStmt[1] and @level='a']">
        <div id="titleForNavigation">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:scriptDesc">
        <xsl:for-each select="./tei:scriptNote">
            <div> Type: <xsl:value-of select="./@script"/>
                <xsl:apply-templates/>
            </div>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="tei:bindingDesc">
        <xsl:for-each select="./tei:binding">
            <div> Date: <xsl:value-of select="./@notBefore"/>-<xsl:value-of select="./@notAfter"/>
                <xsl:apply-templates/>
            </div>
        </xsl:for-each>
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
    <xsl:template match="tei:listBibl">
        <xsl:for-each select=".//tei:bibl">
            <li>
                <xsl:apply-templates/>
            </li>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="tei:ptr">
        <xsl:variable name="x">
            <xsl:value-of select="./@target"/>
        </xsl:variable>
        <a href="{$x}" class="fas fa-link"/>
    </xsl:template>
    <xsl:template match="tei:msPart">
        <xsl:variable name="x">
            <xsl:number count="." level="any"/>
        </xsl:variable>
        <div class="card-header" id="mspart_{$x}">
            <div class="card-header">
                <h4 align="center">
                    <xsl:value-of select="./tei:msIdentifier"/>
                    <xsl:value-of select="./tei:head"/>
                </h4>
            </div>
            <div class="card-body">
                <xsl:apply-templates select=".//tei:msContents"/>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="tei:msContents">
        <xsl:for-each select=".//tei:msItem">
            <xsl:apply-templates select="."/>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="tei:msItem">
        <xsl:variable name="x">
            <xsl:number level="any" count="tei:msItem"/>
        </xsl:variable>
        <h5 id="msitem_{$x}"> Manuscript Item Nr: <xsl:value-of select="$x"/>
        </h5>
        <table class="table table-condensed table-bordered">
            <thead>
                <tr>
                    <th width="20%">Key</th>
                    <th>Value</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <th>locus</th>
                    <td>
                        <xsl:apply-templates select="./tei:locus"/>
                    </td>
                </tr>
                <xsl:if test="./tei:note">
                    <tr>
                        <th>notes</th>
                        <td>
                            <xsl:apply-templates select="./tei:note"/>
                        </td>
                    </tr>
                </xsl:if>
                <xsl:if test="./tei:author">
                    <tr>
                        <th>author</th>
                        <td>
                            <xsl:apply-templates select="./tei:author"/>
                        </td>
                    </tr>
                </xsl:if>
                <xsl:if test="./tei:title">
                    <tr>
                        <th>title</th>
                        <td>
                            <xsl:apply-templates select="./tei:title"/>
                        </td>
                    </tr>
                </xsl:if>
                <xsl:if test="./tei:incipit">
                    <tr>
                        <th>incipit</th>
                        <td>
                            <xsl:apply-templates select="./tei:incipit"/>
                        </td>
                    </tr>
                </xsl:if>
                <xsl:if test="./tei:explicit">
                    <tr>
                        <th>explicit</th>
                        <td>
                            <xsl:apply-templates select="./tei:explicit"/>
                        </td>
                    </tr>
                </xsl:if>
                <xsl:if test="./tei:finalRubric">
                    <tr>
                        <th>finalRubric</th>
                        <td>
                            <xsl:apply-templates select="./tei:finalRubric"/>
                        </td>
                    </tr>
                </xsl:if>
                <xsl:if test="./tei:bibl">
                    <tr>
                        <th>Bibliography</th>
                        <td>
                            <xsl:apply-templates select="./tei:bibl"/>
                        </td>
                    </tr>
                </xsl:if>
            </tbody>
        </table>
    </xsl:template>
    <xsl:template match="tei:gi">
        <code>
            <xsl:apply-templates/>
        </code>
    </xsl:template>
        
        <xsl:template match="tei:c[@rendition='#kaufmannsund']">
        &amp;
        </xsl:template>
        <xsl:template match="tei:c[@rendition = '#geschwungene-klammer-auf']">
       {
        </xsl:template>
        <xsl:template match="tei:c[@rendition = '#geschwungene-klammer-zu']">
       }
        </xsl:template>
       <xsl:template match="tei:c[@rendition = '#gemination-m']">
         <span class="gemination">mm</span>
        </xsl:template>
    <xsl:template match="tei:c[@rendition = '#gemination-n']">
        <span class="gemination">nn</span>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#prozent']">
        %
    </xsl:template>
    <xsl:function name="foo:dots">
        <xsl:param name="anzahl"/>
        .
        <xsl:if test="$anzahl &gt; 1">
            <xsl:value-of select="foo:dots($anzahl - 1)"/>
        </xsl:if>
    </xsl:function>
    <xsl:template match="tei:c[@rendition = '#dots']">
        <xsl:value-of select="foo:dots(@n)"/>
    </xsl:template>
    <xsl:function name="foo:gaps">
        <xsl:param name="anzahl"/>
        <xsl:text>×</xsl:text>
        <xsl:if test="$anzahl &gt; 1">
            <xsl:value-of select="foo:gaps($anzahl - 1)"/>
        </xsl:if>
    </xsl:function>
    <xsl:template match="tei:gap[@unit = 'chars' and @reason = 'illegible']">
        <span class="illegible">
        <xsl:value-of select="foo:gaps(@quantity)"/>
        </span>
    </xsl:template>
    <xsl:template match="tei:gap[@unit = 'lines' and @reason = 'illegible']">
        <div class="illegible">
        <xsl:text> [</xsl:text>
        <xsl:value-of select="@quantity"/>
        <xsl:text> Zeilen unleserlich] </xsl:text>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:gap[@reason = 'outOfScope']">
        <div class="outOfScope">[…]</div>
    </xsl:template>
    
    <xsl:template match="tei:p[child::tei:space[@dim] and not(child::*[2]) and empty(text())]">
        <br/>
    </xsl:template>
    <xsl:template match="tei:p[parent::tei:quote]">
        <xsl:apply-templates/>
        <xsl:if test="not(position()=last())">
            <xsl:text> / </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:function name="foo:verticalSpace">
        <xsl:param name="anzahl"/>
        <br/>
        <xsl:if test="$anzahl &gt; 1">
            <xsl:value-of select="foo:verticalSpace($anzahl - 1)"/>
        </xsl:if>
    </xsl:function>
    <xsl:template match="tei:space[@dim = 'vertical']">
      
        <xsl:element name="div">
            <xsl:attribute name="style">
                <xsl:value-of select="concat('padding-bottom:', @quantity,'em;')"/>
            </xsl:attribute>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:space[@unit = 'chars' and @quantity=1]">
        <xsl:text> </xsl:text>
    </xsl:template>
    <xsl:template match="tei:space[@unit = 'chars' and not(@quantity=1)]">
        <xsl:variable name="weite" select="0.5 * @quantity"/>
       <xsl:element name="span">
           <xsl:attribute name="style">
               <xsl:value-of select="concat('display:inline-block; width: ', $weite,'em; ')"/>
           </xsl:attribute>
       </xsl:element>
    </xsl:template>
    <xsl:template match="tei:opener">
        <div class="opener">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:add[@place and not(parent::tei:subst)]">
        <span class="steuerzeichen">↓</span>
        <span class="add">
        <xsl:apply-templates/>
        </span>
        <span class="steuerzeichen">↓</span>
    </xsl:template>
    <!-- Streichung -->
    <xsl:template match="tei:del[not(parent::tei:subst)]">
        <span class="del">
        <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:del[parent::tei:subst]">
        <xsl:apply-templates/>
    </xsl:template>
    <!-- Substi -->
    <xsl:template match="tei:subst">
        <span class="steuerzeichen">↑</span>
        <span class="superscript">
        <xsl:apply-templates select="tei:del"/>
        </span>
        <span class="subst-add">
        <xsl:apply-templates select="tei:add"/>
        </span>
        <span class="steuerzeichen">↓</span>
    </xsl:template>
    <!-- Wechsel der Schreiber <handShift -->
    <xsl:template match="tei:handShift[not(@scribe)]">
        <xsl:choose>
            <xsl:when test="@medium = 'typewriter'">
                <xsl:text>[ms.:] </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>[hs.:] </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:handShift[@scribe]">
        <xsl:variable name="scribe">
        <xsl:value-of select="@scribe"/>
        </xsl:variable>
        <xsl:text>[hs. </xsl:text>
        <xsl:value-of select="foo:vorname-vor-nachname(//tei:correspDesc//tei:persName[@ref  = $scribe])"/>
        <xsl:text>:] </xsl:text>
    </xsl:template>
    
    <xsl:function name="foo:vorname-vor-nachname">
        <xsl:param name="autorname"/>
        <xsl:choose>
            <xsl:when test="contains($autorname, ', ')">
                <xsl:value-of select="substring-after($autorname, ', ')"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="substring-before($autorname, ', ')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$autorname"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:template match="tei:salute[parent::tei:opener]">
        <div class="salute editionText">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:signed">
        <div class="signed editionText">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:p[ancestor::tei:body and not(ancestor::tei:note) and not(ancestor::tei:footNote) and not(ancestor::tei:caption) and not(parent::tei:bibl) and not(parent::tei:quote)]|tei:dateline|tei:closer">
        <xsl:choose>
            <xsl:when test="@rend='right'">
                <p align="right" class="editionText">
                    <xsl:apply-templates/>
                </p>
            </xsl:when>
            <xsl:when test="@rend='left'">
                <p align="left" class="editionText">
                    <xsl:apply-templates/>
                </p>
            </xsl:when>
            <xsl:when test="@rend='center'">
                <p align="center" class="editionText">
                    <xsl:apply-templates/>
                </p>
            </xsl:when>
            <xsl:when test="@rend='inline'">
                <p class="inline editionText">
                    <xsl:apply-templates/>
                </p>
            </xsl:when>
            <xsl:when test="child::tei:seg">
                <div class="wrapper editionText">
                    <span class="editionText">
                        <xsl:apply-templates select="tei:seg[@rend='left']"/>
                    </span>
                    <span class="editionText">
                        <xsl:apply-templates select="tei:seg[@rend='right']"/>
                    </span>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <p class="editionText">
                    <xsl:apply-templates/>
                </p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:p[not(parent::tei:quote) and (ancestor::tei:note or ancestor::tei:footNote or ancestor::tei:caption or parent::tei:bibl)]">
        <xsl:choose>
            <xsl:when test="@rend='right'">
                <p align="right">
                    <xsl:apply-templates/>
                </p>
            </xsl:when>
            <xsl:when test="@rend='left'">
                <p align="left">
                    <xsl:apply-templates/>
                </p>
            </xsl:when>
            <xsl:when test="@rend='center'">
                <p align="center">
                    <xsl:apply-templates/>
                </p>
            </xsl:when>
            <xsl:when test="@rend='inline'">
                <p style="inline">
                    <xsl:apply-templates/>
                </p>
            </xsl:when>
            <xsl:otherwise>
                <p>
                    <xsl:apply-templates/>
                </p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:div[not(@type='address')]">
        <div class="div">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:div[@type='address']">
                <div class="wrapper">
                    <xsl:apply-templates/>
                </div>
        <hr align="center" width="50%"/>
        <br/>
    </xsl:template>
    
    <xsl:template match="tei:address">
        <div class="column">
             <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:addrLine">
        <p class="addrLine">
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="tei:damage">
        <span class="damage">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    
   <xsl:template match="tei:pb">
       <span class="steuerzeichenUnten">|</span>
   </xsl:template>
    
    <xsl:template match="tei:unclear">
        <span class="unsicher">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:lg[@type='poem']">
        <div class="poem editionText">
        <ul>
            <xsl:apply-templates/>
        </ul>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:l">
            <li>
                <xsl:apply-templates/>
            </li>
    </xsl:template>
    
</xsl:stylesheet>