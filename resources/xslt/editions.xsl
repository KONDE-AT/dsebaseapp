<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="tei" version="2.0"><!-- <xsl:strip-space elements="*"/>-->
    <xsl:import href="shared/base.xsl"/>
    <xsl:param name="document"/>
    <xsl:param name="app-name"/>
    <xsl:param name="collection-name"/>
    <xsl:param name="path2source"/>
    <xsl:param name="ref"/>
    <xsl:param name="prev"/>
    <xsl:param name="next"/>
    <xsl:param name="currentIx"/>
    <xsl:param name="amount"/>
    <xsl:param name="progress"/>
    <xsl:param name="projectName"/>
    <xsl:param name="authors"/>


    <xsl:variable name="signatur">
        <xsl:value-of select=".//tei:institution/text()"/>, <xsl:value-of select=".//tei:repository[1]/text()"/>, <xsl:value-of select=".//tei:msIdentifier/tei:idno[1]/text()"/>
    </xsl:variable>
 <!--
##################################
### Seitenlayout und -struktur ###
##################################
-->
    <xsl:template match="/">
        <div class="card" id="main_content">
            <div class="card card-header">
                <div class="row">
                    <div class="col-md-2">
                        <xsl:if test="$prev">
                            <h1>
                                <a>
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="$prev"/>
                                    </xsl:attribute>
                                    <i class="fas fa-chevron-left" title="prev"/>
                                </a>
                            </h1>
                        </xsl:if>
                    </div>
                    <div class="col-md-8">
                        <h2 align="center">
                            <xsl:for-each select="//tei:fileDesc/tei:titleStmt/tei:title">
                                <xsl:apply-templates/>
                                <br/>
                            </xsl:for-each>
                            <a>
                                <i class="fas fa-info" title="show more info about the document" data-toggle="modal" data-target="#exampleModalLong"/>
                            </a>
                            |
                            <a href="{$path2source}">
                                <i class="fas fa-download" title="show TEI source"/>
                            </a>
                        </h2>
                        <h2 style="text-align:center;">
                            <input type="range" min="1" max="{$amount}" value="{$currentIx}" data-rangeslider="" style="width:100%;"/>
                            <a id="output" class="btn btn-main btn-outline-primary btn-sm" href="show.html?document=entry__1879-03-03.xml&amp;directory=editions" role="button">go to </a>
                        </h2>

                    </div>
                    <div class="col-md-2" style="text-align:right">
                        <xsl:if test="$next">
                            <h1>
                                <a>
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="$next"/>
                                    </xsl:attribute>
                                    <i class="fas fa-chevron-right" title="next"/>
                                </a>
                            </h1>
                        </xsl:if>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <div>
                    <xsl:apply-templates select="//tei:text"/>
                </div>
                <div class="card-footer">
                    <p style="text-align:center;">
                        <xsl:for-each select="tei:TEI/tei:text/tei:body//tei:note">
                            <div class="footnotes">
                                <xsl:element name="a">
                                    <xsl:attribute name="name">
                                        <xsl:text>fn</xsl:text>
                                        <xsl:number level="any" format="1" count="tei:note[./tei:p]"/>
                                    </xsl:attribute>
                                    <a>
                                        <xsl:attribute name="href">
                                            <xsl:text>#fna_</xsl:text>
                                            <xsl:number level="any" format="1" count="tei:note"/>
                                        </xsl:attribute>
                                        <sup>
                                            <xsl:number level="any" format="1" count="tei:note[./tei:p]"/>
                                        </sup>
                                    </a>
                                </xsl:element>
                                <xsl:apply-templates/>
                            </div>
                        </xsl:for-each>
                    </p>
                    <p>
                        <hr/>
                        <h3>Zitierhinweis</h3>
                        <blockquote class="blockquote">
                            <cite title="Source Title">
                                <xsl:value-of select="$signatur"/>, hg. v. <xsl:value-of select="$authors"/>, In: <xsl:value-of select="$projectName"/>
                            </cite>
                        </blockquote>
                    </p>
                </div>
            </div>
            <div class="modal fade" id="exampleModalLong" tabindex="-1" role="dialog" aria-labelledby="exampleModalLongTitle" aria-hidden="true">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="exampleModalLongTitle">
                                <xsl:for-each select="//tei:fileDesc/tei:titleStmt/tei:title">
                                    <xsl:apply-templates/>
                                    <br/>
                                </xsl:for-each>
                            </h5>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">x</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <table class="table table-striped">
                                <tbody>
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
                                                </xsl:for-each><!--<xsl:apply-templates select="//tei:msIdentifier"/>-->
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
                                        <th>Verantwortlich</th>
                                        <td>
                                            <xsl:for-each select="//tei:author">
                                                <xsl:apply-templates/>
                                            </xsl:for-each>
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
                                        <xsl:choose>
                                            <xsl:when test="//tei:licence[@target]">
                                                <td align="center">
                                                    <a class="navlink" target="_blank">
                                                        <xsl:attribute name="href">
                                                            <xsl:value-of select="//tei:licence[1]/data(@target)"/>
                                                        </xsl:attribute>
                                                        <xsl:value-of select="//tei:licence[1]/data(@target)"/>
                                                    </a>
                                                </td>
                                            </xsl:when>
                                            <xsl:when test="//tei:licence">
                                                <td>
                                                    <xsl:apply-templates select="//tei:licence"/>
                                                </td>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <td>no license provided</td>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </tr>
                                </tbody>
                            </table>

                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>


    </xsl:template>
</xsl:stylesheet>
