<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:sparql="http://www.w3.org/2005/sparql-results#" xmlns:my="http://test.org/" exclude-result-prefixes="tei" version="2.0">
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes"/>
    <xsl:variable name="title">
        <xsl:value-of select="normalize-space(string-join(//tei:titleStmt[1]/tei:title//text(), ' '))"/>
    </xsl:variable>
    <xsl:variable name="path2source">hansi4ever</xsl:variable>
    <xsl:variable name="projectName">Digitale Edition Wiener Grundbücher</xsl:variable>
    <xsl:variable name="prev">
        <xsl:value-of select="//data(tei:TEI/@prev)"/>
    </xsl:variable>
    <xsl:variable name="next">
        <xsl:value-of select="//data(tei:TEI/@next)"/>
    </xsl:variable>
    <xsl:variable name="current-id">
        <xsl:value-of select="//data(tei:TEI/@xml:id)"/>
    </xsl:variable>
    <xsl:variable name="current-base">
        <xsl:value-of select="//data(tei:TEI/@xml:base)"/>
    </xsl:variable>
    <xsl:variable name="current">
        <xsl:choose>
            <xsl:when test="ends-with($current-base, '/')">
                <xsl:value-of select="string-join(($current-base, $current-id), '')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="string-join(($current-base, $current-id), '/')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="signatur">
        <xsl:value-of select=".//tei:institution/text()"/>, <xsl:value-of select=".//tei:repository[1]/text()"/>, <xsl:value-of select=".//tei:msIdentifier/tei:idno[1]/text()"/>
    </xsl:variable>
    <xsl:variable name="IIIFBase">https://iiif.acdh.oeaw.ac.at/grundbuecher/</xsl:variable>
    <xsl:variable name="InfoJson">
        <xsl:value-of select="concat($IIIFBase, substring-before(data(.//tei:graphic[1]/@url), '.'), '/info.json')"/>
    </xsl:variable>
    <xsl:variable name="IIIFViewer">
        <xsl:value-of select="substring-before($InfoJson, 'info.json')"/>
    </xsl:variable>
    <xsl:template match="/">
        <html lang="en-US">
            <head>
                <meta charset="UTF-8"/>
                <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
                <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
                <meta name="mobile-web-app-capable" content="yes"/>
                <meta name="apple-mobile-web-app-capable" content="yes"/>
                <meta name="apple-mobile-web-app-title" content="Fundament WP - Example HTML Page"/>
                <link rel="profile" href="http://gmpg.org/xfn/11"/>
                <title>
                    <xsl:value-of select="$title"/>
                </title>
                <link rel="stylesheet" id="fundament-styles" href="https://shared.acdh.oeaw.ac.at/fundament/dist/fundament/css/fundament.min.css" type="text/css"/>
                <link rel="stylesheet" id="fundament-styles" href="https://shared.acdh.oeaw.ac.at/maechtekongresse/resources/css/style.css" type="text/css"/>
                <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.3.1/css/all.css" integrity="sha384-mzrmE5qonljUremFsqc01SB46JvROS7bZs3IO2EmfFsd15uHvIt+Y8vEf7N7fWAU" crossorigin="anonymous"/>
                <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"/>
            </head>
            <body role="document" class="home contained fixed-nav" id="body">
                <div class="hfeed site" id="page">
                    <!-- ******************* The Navbar Area ******************* -->
                    <div class="wrapper-fluid wrapper-navbar sticky-navbar" id="wrapper-navbar" itemscope="" itemtype="http://schema.org/WebSite">
                        <a class="skip-link screen-reader-text sr-only" href="#content">Skip to content</a>
                        <nav class="navbar navbar-expand-lg navbar-light">
                            <div class="container-fluid">
                                <!-- Your site title as branding in the menu -->
                                <a href="index.html" class="navbar-brand custom-logo-link" rel="home" itemprop="url">
                                    <img src="https://shared.acdh.oeaw.ac.at/schnitzler-tagebuch/project-logo.svg" class="img-fluid" alt="Mächtekongresse 1818–1822. Digitale Edition" itemprop="logo"/>
                                </a>
                                <!-- end custom logo -->
                                <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNavDropdown" aria-controls="navbarNavDropdown" aria-expanded="false" aria-label="Toggle navigation">
                                    <span class="navbar-toggler-icon"/>
                                </button>
                                <div class="collapse navbar-collapse justify-content-end" id="navbarNavDropdown">
                                    <!-- Your menu goes here -->
                                    <ul id="main-menu" class="navbar-nav">
                                        <li class="nav-item">
                                            <a class="nav-link" href="https://id.acdh.oeaw.ac.at/maechtekongresse/meta/about.xml?format=customTEI2HTML">Zur Edition</a>
                                        </li>
                                        <li class="nav-item">
                                            <a class="nav-link" href="#" data-toggle="modal" data-target="#tocModal">Alle Einträge</a>
                                        </li>
                                        <li class="nav-item">
                                            <a class="nav-link" href="https://id.acdh.oeaw.ac.at/maechtekongresse/indices/listperson.xml?format=customTEI2HTML">Personen</a>
                                        </li>
                                        <li class="nav-item">
                                            <a class="nav-link" href="https://id.acdh.oeaw.ac.at/maechtekongresse/indices/listplace.xml?format=customTEI2HTML">Orte</a>
                                        </li>
                                    </ul>
                                    <div class="form-inline my-2 my-lg-0 navbar-search-form">
                                        <input class="form-control navbar-search" id="query" type="text" placeholder="Search" value="" autocomplete="off"/>
                                        <button class="navbar-search-icon" id="send" data-toggle="modal" data-target="#myModal">
                                            <i data-feather="search"/>
                                        </button>
                                    </div>
                                </div>
                                <!-- .collapse navbar-collapse -->

                            </div>
                            <!-- .container -->

                        </nav>
                        <!-- .site-navigation -->

                    </div>
                    <!-- .wrapper-navbar end -->
                    <div class="wrapper" id="index-wrapper">
                        <div class="container" id="content" tabindex="-1">
                            <div class="card">
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
                                                </a> |
                                                <xsl:choose>
                                                    <xsl:when test="//tei:revisionDesc[@status='done']">
                                                        <span class="green-dot" title="Dokument überprüft und annotiert"/>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <span class="orange-dot" title="Dokument wurde noch nicht überprüft und annotiert"/>
                                                    </xsl:otherwise>
                                                </xsl:choose>
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
                                    <div class="row">
                                        <div class="col-md-5">
                                            <xsl:apply-templates select="//tei:text"/>
                                        </div>
                                        <div class="col-md-7" style="text-align: center;">
                                            <div style="width: 100%; height: 100%" id="osd_viewer"/>
                                            <a target="_blank">
                                                <xsl:attribute name="href">
                                                    <xsl:value-of select="$IIIFViewer"/>
                                                </xsl:attribute>
                                                open image in new window
                                            </a>
                                        </div>
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
                                                    <xsl:value-of select="$signatur"/>, hg. v. <xsl:value-of select=".//tei:publisher"/>, In: <xsl:value-of select="$projectName"/>
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
                        </div>
                        <!-- Container end -->

                    </div>
                    <!-- Wrapper end -->
                    <div class="wrapper fundament-default-footer" id="wrapper-footer-full">
                        <div class="container-fluid" id="footer-full-content" tabindex="-1">
                            <div class="footer-separator">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-message-circle">
                                    <path d="M21 11.5a8.38 8.38 0 0 1-.9 3.8 8.5 8.5 0 0 1-7.6 4.7 8.38 8.38 0 0 1-3.8-.9L3 21l1.9-5.7a8.38 8.38 0 0 1-.9-3.8 8.5 8.5 0 0 1 4.7-7.6 8.38 8.38 0 0 1 3.8-.9h.5a8.48 8.48 0 0 1 8 8v.5z"/>
                                </svg> CONTACT
                            </div>
                            <div class="row">
                                <div class="footer-widget col-lg-1 col-md-2 col-sm-2 col-xs-6 col-3">
                                    <div class="textwidget custom-html-widget">
                                        <a href="/">
                                            <img src="https://fundament.acdh.oeaw.ac.at/common-assets/images/acdh_logo.svg" class="image" alt="ACDH Logo" style="max-width: 100%; height: auto;" title="ACDH Logo"/>
                                        </a>
                                    </div>
                                </div>
                                <!-- .footer-widget -->
                                <div class="footer-widget col-lg-4 col-md-4 col-sm-6 col-9">
                                    <div class="textwidget custom-html-widget">
                                        <p>
                                            ACDH-ÖAW

                                            <br/>
                                            Austrian Centre for Digital Humanities
                                            <br/>
                                            Austrian Academy of Sciences
                                        </p>
                                        <p>
                                            Sonnenfelsgasse 19,

                                            <br/>
                                            1010 Vienna
                                        </p>
                                        <p>
                                            T: +43 1 51581-2200

                                            <br/>
                                            E:
                                            <a href="mailto:acdh@oeaw.ac.at">acdh@oeaw.ac.at</a>
                                        </p>
                                    </div>
                                </div>
                                <!-- .footer-widget -->
                                <div class="footer-widget col-lg-3 col-md-4 col-sm-4 ml-auto">
                                    <div class="textwidget custom-html-widget">
                                        <h6>HELPDESK</h6>
                                        <p>ACDH runs a helpdesk offering advice for questions related to various digital humanities topics.</p>
                                        <p>
                                            <a class="helpdesk-button" href="mailto:acdh-helpdesk@oeaw.ac.at">ASK US!</a>
                                        </p>
                                    </div>
                                </div>
                                <!-- .footer-widget -->

                            </div>
                        </div>
                    </div>
                    <!-- #wrapper-footer-full -->
                    <div class="footer-imprint-bar" id="wrapper-footer-secondary" style="text-align:center; padding:0.4rem 0; font-size: 0.9rem;">
                        <a href="https://www.oeaw.ac.at/die-oeaw/impressum/">Impressum/Imprint</a>
                    </div>
                </div>
                <!-- TEI-HEADER-MODAL -->
                <div class="modal fade bd-example-modal-lg" id="exampleModalLong" tabindex="-1" role="dialog" aria-labelledby="exampleModalLongTitle" aria-hidden="true">
                    <div class="modal-dialog  modal-lg" role="document">
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
                                        <xsl:if test="//tei:abstract">
                                            <xsl:choose>
                                                <xsl:when test="count(//tei:abstract) &gt; 1">
                                                    <xsl:for-each select="//tei:abstract">
                                                        <xsl:variable name="x">
                                                            <xsl:number level="any" count="tei:abstract"/>
                                                        </xsl:variable>
                                                        <tr>
                                                            <th>
                                                                <abbr title="//tei:abstract">Regest

                                                                    <xsl:text> Nr. </xsl:text>
                                                                    <xsl:value-of select="$x"/>
                                                                </abbr>
                                                            </th>
                                                            <td>
                                                                <em>
                                                                    <xsl:apply-templates select="//tei:abstract[position()=$x]"/>
                                                                </em>
                                                            </td>
                                                        </tr>
                                                    </xsl:for-each>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <tr>
                                                        <th>
                                                            <abbr title="//tei:abstract">Regest</abbr>
                                                        </th>
                                                        <td>
                                                            <em>
                                                                <xsl:apply-templates select="//tei:abstract"/>
                                                            </em>
                                                        </td>
                                                    </tr>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:if>
                                        <xsl:if test="//tei:particDesc/tei:listPerson/tei:person">
                                            <tr>
                                                <th>
                                                    <abbr title="//tei:particDesc/tei:listPerson/tei:person">Anwesende</abbr>
                                                </th>
                                                <td>
                                                    <xsl:for-each select="//tei:particDesc/tei:listPerson/tei:person">
                                                        <xsl:apply-templates/>
                                                        <xsl:if test="position() != last()">
                                                            <xsl:text> · </xsl:text>
                                                        </xsl:if>
                                                    </xsl:for-each>
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
                                    </tbody>
                                </table>
                                <xsl:for-each select="//tei:sourceDesc/tei:msDesc">
                                    <!-- Split -->
                                    <xsl:variable name="msDivId" select="@xml:id"/>
                                    <xsl:variable name="divlink" select="concat('#',$msDivId)"/>
                                    <div class="well">
                                        <div class="panel-body">
                                            <xsl:attribute name="id">m
                                                <xsl:value-of select="$msDivId"/>
                                            </xsl:attribute>
                                            <table class="table table-striped">
                                                <tbody>
                                                    <xsl:if test=".//tei:msContents">
                                                        <tr style="background-color:#ccc;font-weight:bold;">
                                                            <th>
                                                                <abbr title="//tei:msContents">Bezeichnung</abbr>
                                                            </th>
                                                            <td>
                                                                <a>
                                                                    <xsl:attribute name="href">
                                                                        <xsl:value-of select="$divlink"/>
                                                                    </xsl:attribute>
                                                                    <xsl:value-of select="normalize-space(string-join(.//tei:msContents//tei:title/descendant-or-self::*[not(name()='expan')]/text(), ''))"/>
                                                                </a>
                                                            </td>
                                                        </tr>
                                                    </xsl:if>
                                                    <xsl:if test="./@type">
                                                        <tr>
                                                            <th>
                                                                <abbr title="//tei:msDesc/@type">Dokumentenart</abbr>
                                                            </th>
                                                            <td>
                                                                <xsl:value-of select="./@type"/>
                                                            </td>
                                                        </tr>
                                                    </xsl:if>
                                                    <tr>
                                                        <th>
                                                            <abbr title="//tei:history/tei:origin">Ort/Datum</abbr>
                                                        </th>
                                                        <td>
                                                            <xsl:value-of select=".//tei:history/tei:origin/tei:placeName"/>
                                                            <xsl:if test="not(.//tei:history/tei:origin/tei:placeName)">
                                                                <xsl:text>o.O.</xsl:text>
                                                            </xsl:if>
                                                            <xsl:text>, </xsl:text>
                                                            <xsl:value-of select="format-date(xs:date(.//tei:history/tei:origin/tei:date[1]/@when), '[D]. [M02]. [Y0001]')"/>
                                                            <xsl:if test="not(.//tei:history/tei:origin/tei:date/@when)">
                                                                <xsl:text>o.D.</xsl:text>
                                                            </xsl:if>
                                                        </td>
                                                    </tr>
                                                    <xsl:if test=".//tei:msIdentifier">
                                                        <tr>
                                                            <th>
                                                                <abbr title="//tei:msIdentifier">Signatur</abbr>
                                                            </th>
                                                            <td>
                                                                <xsl:for-each select=".//tei:msIdentifier/child::*">
                                                                    <xsl:choose>
                                                                        <xsl:when test="tei:idno">
                                                                            <xsl:for-each select="./tei:idno">
                                                                                <xsl:value-of select="."/>
                                                                                <xsl:if test="position() != last()">, </xsl:if>
                                                                            </xsl:for-each>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                            <abbr>
                                                                                <xsl:attribute name="title">
                                                                                    <xsl:value-of select="name()"/>
                                                                                </xsl:attribute>
                                                                                <xsl:value-of select="."/>
                                                                            </abbr>
                                                                        </xsl:otherwise>
                                                                    </xsl:choose>
                                                                    <xsl:if test="position() != last()">, </xsl:if>
                                                                </xsl:for-each>
                                                                <!--<xsl:apply-templates select="//tei:msIdentifier"/>-->

                                                            </td>
                                                        </tr>
                                                    </xsl:if>
                                                    <xsl:if test=".//tei:physDesc">
                                                        <tr>
                                                            <th>
                                                                <abbr title="//tei:physDesc">Stückbeschreibung
                                                                </abbr>
                                                            </th>
                                                            <td>
                                                                <xsl:apply-templates select=".//tei:physDesc"/>
                                                            </td>
                                                        </tr>
                                                    </xsl:if>
                                                    <xsl:if test="..//tei:listWit[@corresp=$divlink]/tei:witness">
                                                        <xsl:for-each select="root()//tei:listWit[@corresp=$divlink]/tei:witness/@corresp">
                                                            <xsl:variable name="witId" select="substring-after(., '#')"/>
                                                            <tr>
                                                                <th>
                                                                    <abbr>
                                                                        <xsl:attribute name="title">//tei:listWit
                                                                            <xsl:value-of select="$witId"/>
                                                                        </xsl:attribute>
                                                                        Vgl. gedruckte Quelle
                                                                    </abbr>
                                                                </th>
                                                                <td>
                                                                    <xsl:for-each select="../tei:bibl">
                                                                        <a>
                                                                            <xsl:attribute name="href">../pages/bibl.html#myTable=f
                                                                                <xsl:value-of select="$witId"/>
                                                                            </xsl:attribute>
                                                                            <xsl:value-of select="."/>
                                                                        </a>
                                                                    </xsl:for-each>
                                                                </td>
                                                                <!--                                                    <td><xsl:for-each select="root()//tei:listWit/tei:witness[@xml:id=$witId]"><a><xsl:attribute name="href">../pages/bibl.html#myTable=f<xsl:value-of select="$witId"/>
                                                                </xsl:attribute><xsl:apply-templates select="root()//tei:listWit/tei:witness[@xml:id=$witId]/tei:bibl"/>
                                                            </a><xsl:text> S. </xsl:text><xsl:value-of select="normalize-space(substring-after(root()//tei:listWit[@corresp=$divlink]/tei:witness[@corresp=concat('#', $witId)], 'S.'))"/>
                                                        </xsl:for-each>
                                                    </td>-->

                                                </tr>
                                            </xsl:for-each>
                                        </xsl:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </xsl:for-each>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Schließen</button>
                </div>
            </div>
        </div>
    </div>
    <!-- FETCH-MENTIONS-MODAL -->

    <xsl:apply-templates select="//tei:back//tei:place"/>
    <xsl:apply-templates select="//tei:back//tei:person"/>
    <xsl:apply-templates select="//tei:back//tei:org"/>
    <!-- #page we need this extra closing tag here -->
                <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"/>
                <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js"/>
                <script src="https://cdnjs.cloudflare.com/ajax/libs/openseadragon/2.4.1/openseadragon.min.js"/>
                <script type="text/javascript">
                    var source = "<xsl:value-of select="$InfoJson"/>";
                    var viewer = OpenSeadragon({
                    id: "osd_viewer",
                    tileSources: [
                    source
                    ],
                    prefixUrl:"https://cdnjs.cloudflare.com/ajax/libs/openseadragon/2.4.1/images/",
                    });
                </script>
                <script type="text/javascript">
                    $(window).on('load', function(){
                    $('#myModal').modal('show');
                    });
                </script>
</body>
</html>
</xsl:template>
<!-- reference strings   -->
<xsl:template match="tei:rs[./@ref]">
    <xsl:variable name="rs-modal">
        <xsl:value-of select="data(./@ref)"/>
    </xsl:variable>
    <strong data-toggle="modal" data-target="{$rs-modal}">
        <xsl:apply-templates/>
    </strong>
</xsl:template>
<xsl:template match="tei:person[./@xml:id]">
    <xsl:variable name="modal-id">
        <xsl:value-of select="data(@xml:id)"/>
    </xsl:variable>
    <div class="modal fade bd-example-modal-lg" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true" id="{$modal-id}">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <!-- Modal Header -->
                <div class="modal-header">
                    <h4 class="modal-title">
                        <xsl:value-of select="string-join(./tei:persName[1]//text(), ' ')"/>
                    </h4>
                </div>
                <!-- Modal body -->
                <div class="modal-body">
                    <table class="table table-boardered table-hover">
                        <xsl:for-each select=".//tei:persName">
                            <tr>
                                <th>
                                        Name
                                    </th>
                                <td>
                                    <xsl:choose>
                                        <xsl:when test="./tei:forename and ./tei:surname">
                                            <xsl:value-of select="concat(./tei:forename, ' ', ./tei:surname)"/>
                                        </xsl:when>
                                        <xsl:when test="./tei:forename or ./tei:surname">
                                            <xsl:value-of select="./tei:forename"/>
                                            <xsl:value-of select="./tei:surname"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                                keine Angaben zu Namen vorhanden
                                            </xsl:otherwise>
                                    </xsl:choose>
                                </td>
                            </tr>
                        </xsl:for-each>
                        <xsl:choose>
                            <xsl:when test="count(.//tei:persName) gt 1">
                                <xsl:for-each select="subsequence(.//tei:persName, 2)">
                                    <tr>
                                        <th>
                                                Alternative Namen
                                            </th>
                                        <td>
                                            <li>
                                                <xsl:value-of select="normalize-space(string-join(.//text(), ' '))"/>
                                                <xsl:if test="./@subtype">
                                                        (
                                                    <xsl:value-of select="./@subtype"/>)
                                                </xsl:if>
                                            </li>
                                        </td>
                                    </tr>
                                </xsl:for-each>
                            </xsl:when>
                        </xsl:choose>
                        <xsl:choose>
                            <xsl:when test="./tei:occupation/text()">
                                <tr>
                                    <th>
                                            Beruf(e)
                                        </th>
                                    <td>
                                        <xsl:for-each select=".//tei:occupation">
                                            <li>
                                                <xsl:value-of select="./text()"/>
                                            </li>
                                        </xsl:for-each>
                                    </td>
                                </tr>
                            </xsl:when>
                        </xsl:choose>
                        <xsl:choose>
                            <xsl:when test="./tei:birth">
                                <tr>
                                    <th>
                                            geboren am
                                        </th>
                                    <td>
                                        <xsl:value-of select=".//tei:birth/tei:date/text()"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                            geboren in
                                        </th>
                                    <td>
                                        <xsl:value-of select=".//tei:birth/tei:placeName/text()"/>
                                    </td>
                                </tr>
                            </xsl:when>
                        </xsl:choose>
                        <xsl:choose>
                            <xsl:when test="./tei:death">
                                <tr>
                                    <th>
                                            gestorben am
                                        </th>
                                    <td>
                                        <xsl:value-of select=".//tei:death/tei:date/text()"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                            gestorben in
                                        </th>
                                    <td>
                                        <xsl:value-of select=".//tei:death/tei:placeName/text()"/>
                                    </td>
                                </tr>
                            </xsl:when>
                        </xsl:choose>
                        <xsl:choose>
                            <xsl:when test="./tei:idno[@type='GND']">
                                <tr>
                                    <th>
                                            GND-ID
                                        </th>
                                    <td>
                                        <a>
                                            <xsl:attribute name="href">
                                                <xsl:value-of select=".//tei:idno[@type='GND']/text()"/>
                                            </xsl:attribute>
                                            <xsl:value-of select=".//tei:idno[@type='GND']/text()"/>
                                        </a>
                                    </td>
                                </tr>
                            </xsl:when>
                        </xsl:choose>
                        <xsl:choose>
                            <xsl:when test="./@xml:id">
                                <tr>
                                    <th>
                                            Interne-ID
                                        </th>
                                    <td>
                                        <button class="btn btn-primary btn-action" data-key="{data(./@xml:id)}" data-person="{normalize-space(string-join(./tei:persName[1], ''))}" id="{concat(data(./@xml:id), '__fetch')}">erwähnt in</button>
                                    </td>
                                </tr>
                            </xsl:when>
                        </xsl:choose>
                    </table>
                </div>
                <!-- Modal footer -->
                <div class="modal-footer">
                    <button type="button" class="btn btn-danger" data-dismiss="modal">Schließen</button>
                </div>
            </div>
        </div>
    </div>
</xsl:template>
<xsl:template match="tei:place[./@xml:id]">
    <xsl:variable name="modal-id">
        <xsl:value-of select="data(@xml:id)"/>
    </xsl:variable>
    <div class="modal fade bd-example-modal-lg" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true" id="{$modal-id}">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <!-- Modal Header -->
                <div class="modal-header">
                    <h4 class="modal-title">
                        <xsl:value-of select="./tei:placeName[1]/text()"/>
                    </h4>
                </div>
                <!-- Modal body -->
                <div class="modal-body">
                    <table class="table table-boardered table-hover">
                        <tr>
                            <th>Name</th>
                            <td>
                                <xsl:value-of select="./tei:placeName[1]"/>
                            </td>
                        </tr>
                        <xsl:if test="count(.//tei:placeName) &gt; 1">
                            <xsl:for-each select=".//tei:placeName[position()&gt;1]">
                                <tr>
                                    <th>Alternative Namen</th>
                                    <td>
                                        <xsl:value-of select="."/>
                                    </td>
                                </tr>
                            </xsl:for-each>
                        </xsl:if>
                        <xsl:choose>
                            <xsl:when test=".//tei:geo">
                                <tr>
                                    <th>
                                            Koordinaten
                                        </th>
                                    <td>
                                        <xsl:value-of select=".//tei:geo/text()"/>
                                    </td>
                                </tr>
                            </xsl:when>
                        </xsl:choose>
                        <xsl:choose>
                            <xsl:when test=".//tei:idno[@type='geonames']">
                                <tr>
                                    <th>
                                            GND-ID
                                        </th>
                                    <td>
                                        <a>
                                            <xsl:attribute name="href">
                                                <xsl:value-of select=".//tei:idno[@type='geonames']/text()"/>
                                            </xsl:attribute>
                                            <xsl:value-of select=".//tei:idno[@type='geonames']/text()"/>
                                        </a>
                                    </td>
                                </tr>
                            </xsl:when>
                        </xsl:choose>
                        <xsl:if test="./@xml:id">
                            <tr>
                                <th>Interne-ID:</th>
                                <td>
                                    <xsl:value-of select="./@xml:id"/>
                                </td>
                            </tr>
                        </xsl:if>
                    </table>
                </div>
                <!-- Modal footer -->
                <div class="modal-footer">
                    <button type="button" class="btn btn-danger" data-dismiss="modal">Schließen</button>
                </div>
            </div>
        </div>
    </div>
</xsl:template>
<xsl:template match="tei:head">
    <xsl:variable name="handId" select="substring-after(./@hand, '#')"/>
    <xsl:element name="div">
        <xsl:attribute name="style">margin-bottom:1.8em;</xsl:attribute>
        <xsl:if test="@xml:id[starts-with(.,'org') or starts-with(.,'ue')]">
            <a>
                <xsl:attribute name="name">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
                <xsl:text> </xsl:text>
            </a>
        </xsl:if>
        <xsl:if test="$handId">
            <xsl:attribute name="title">Hand:
                <xsl:value-of select="root()//tei:handNote[@xml:id=$handId]"/>
            </xsl:attribute>
        </xsl:if>
        <a>
            <xsl:attribute name="name">
                <xsl:text>hd</xsl:text>
                <xsl:number level="any"/>
            </xsl:attribute>
            <xsl:text> </xsl:text>
        </a>
        <xsl:choose>
            <xsl:when test="./@type='sub'">
                <h4>
                    <xsl:apply-templates/>
                </h4>
            </xsl:when>
            <xsl:otherwise>
                <h3>
                    <div>
                        <xsl:apply-templates/>
                    </div>
                </h3>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:element>
</xsl:template>
<xsl:template match="tei:opener">
    <xsl:element name="div">
        <xsl:variable name="handId" select="substring-after(./@hand, '#')"/>
        <xsl:attribute name="class">opener</xsl:attribute>
        <xsl:if test="$handId">
            <xsl:attribute name="title">Hand:
                <xsl:value-of select="root()//tei:handNote[@xml:id=$handId]"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:apply-templates/>
    </xsl:element>
</xsl:template>
<xsl:template match="tei:dateline">
    <xsl:element name="p">
        <xsl:attribute name="class">ed</xsl:attribute>
        <xsl:attribute name="style">text-align:right;</xsl:attribute>
        <xsl:apply-templates/>
    </xsl:element>
</xsl:template>
<!-- additions -->
<xsl:template match="tei:add">
    <xsl:element name="ins">
        <xsl:attribute name="class">
            <xsl:text>ergaenzt</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="title">
            <xsl:choose>
                <xsl:when test="@place='margin'">
                    <xsl:text>zeitgenössische Ergänzung am Rand </xsl:text>(
                    <xsl:value-of select="./@place"/>)
                </xsl:when>
                <xsl:when test="@place='above'">
                    <xsl:text>zeitgenössische Ergänzung oberhalb </xsl:text>(
                    <xsl:value-of select="./@place"/>)
                </xsl:when>
                <xsl:when test="@place='below'">
                    <xsl:text>zeitgenössische Ergänzung unterhalb </xsl:text>(
                    <xsl:value-of select="./@place"/>)
                </xsl:when>
                <xsl:when test="@place='inline'">
                    <xsl:text>zeitgenössische Ergänzung in der gleichen Zeile </xsl:text>(
                    <xsl:value-of select="./@place"/>)
                </xsl:when>
                <xsl:when test="@place='top'">
                    <xsl:text>zeitgenössische Ergänzung am oberen Blattrand </xsl:text>(
                    <xsl:value-of select="./@place"/>)
                </xsl:when>
                <xsl:when test="@place='bottom'">
                    <xsl:text>zeitgenössische Ergänzung am unteren Blattrand </xsl:text>(
                    <xsl:value-of select="./@place"/>)
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>zeitgenössische Ergänzung </xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="@hand">
                <xsl:variable name="handId" select="substring-after(@hand, '#')"/>
                <xsl:text>durch </xsl:text>
                <xsl:value-of select="root()//tei:handNote[@xml:id=$handId]"/>
                <xsl:text> (</xsl:text>
                <xsl:value-of select="./@hand"/>
                <xsl:text>)</xsl:text>
            </xsl:if>
        </xsl:attribute>
        <xsl:text/>
        <xsl:apply-templates/>
        <xsl:text/>
    </xsl:element>
</xsl:template>
<!-- app/rdg tooltip testing -->
<xsl:template match="tei:app">
    <xsl:variable name="handId" select="substring-after(tei:rdg/tei:add/@hand, '#')"/>
    <xsl:element name="span">
        <xsl:attribute name="class">shortRdg</xsl:attribute>
        <xsl:attribute name="href">#</xsl:attribute>
        <xsl:attribute name="data-toggle">tooltip</xsl:attribute>
        <xsl:attribute name="data-placement">top</xsl:attribute>
        <xsl:attribute name="title">
            <xsl:choose>
                <xsl:when test="./tei:rdg/tei:subst">
                    <xsl:text>Ersetzung </xsl:text>
                    <xsl:value-of select="tei:rdg/root()//tei:handNote[@xml:id=$handId][1]"/>
                    <xsl:text>: ~</xsl:text>
                    <xsl:value-of select="normalize-space(string-join(./tei:rdg/tei:subst/tei:del/descendant-or-self::*[not(name()='note')]/text(), ' '))"/>
                    <xsl:text>~
</xsl:text>
                    <xsl:value-of select="normalize-space(string-join(./tei:rdg/tei:subst/tei:add/descendant-or-self::*[not(name()='note')]/text(), ' '))"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="string-join(tei:rdg/concat(root()//tei:handNote[@xml:id=$handId], ': ', normalize-space(.)),' -- ')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="data-original-title">
            <xsl:choose>
                <xsl:when test="./tei:rdg/tei:subst">
                    <xsl:text>Ersetzung </xsl:text>
                    <xsl:value-of select="tei:rdg/root()//tei:handNote[@xml:id=$handId][1]"/>
                    <xsl:text>: ~</xsl:text>
                    <xsl:value-of select="normalize-space(string-join(./tei:rdg/tei:subst/tei:del/descendant-or-self::*[not(name()='note')]/text(), ' '))"/>
                    <xsl:text>~
</xsl:text>
                    <xsl:value-of select="normalize-space(string-join(./tei:rdg/tei:subst/tei:add/descendant-or-self::*[not(name()='note')]/text(), ' '))"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="string-join(tei:rdg/concat(root()//tei:handNote[@xml:id=$handId], ': ', normalize-space(.)),' -- ')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        <xsl:apply-templates select="./tei:lem"/>
    </xsl:element>
    <xsl:element name="a">
        <xsl:attribute name="name">
            <xsl:text>fna_</xsl:text>
            <xsl:number level="any" format="i" count="tei:app"/>
        </xsl:attribute>
        <xsl:attribute name="href">
            <xsl:text>#fn</xsl:text>
            <xsl:number level="any" format="i" count="tei:app"/>
        </xsl:attribute>
        <xsl:attribute name="title">
            <xsl:choose>
                <xsl:when test="./tei:rdg/tei:subst">
                    <xsl:text>Ersetzung </xsl:text>
                    <xsl:value-of select="tei:rdg/root()//tei:handNote[@xml:id=$handId][1]"/>
                    <xsl:text>: ~</xsl:text>
                    <xsl:value-of select="normalize-space(string-join(./tei:rdg/tei:subst/tei:del/descendant-or-self::*[not(name()='note')]/text(), ' '))"/>
                    <xsl:text>~
</xsl:text>
                    <xsl:value-of select="normalize-space(string-join(./tei:rdg/tei:subst/tei:add/descendant-or-self::*[not(name()='note')]/text(), ' '))"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="string-join(tei:rdg/concat(root()//tei:handNote[@xml:id=$handId], ': ', normalize-space(.)),' -- ')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        <sup class="shortRdg">
            <xsl:text>[Variante </xsl:text>
            <xsl:number level="any" format="i" count="tei:app"/>
            <xsl:text>]</xsl:text>
        </sup>
    </xsl:element>
    <xsl:element name="span">
        <xsl:attribute name="class">fullRdg</xsl:attribute>
        <xsl:attribute name="style">display:none</xsl:attribute>
        <xsl:value-of select="concat(tokenize(./tei:lem,' ')[1], ' … ', tokenize(./tei:lem,' ')[last()]), string-join(tei:rdg/concat(tei:add/@hand, '] ', normalize-space(.)),' ')"/>
    </xsl:element>
</xsl:template>
<xsl:template match="tei:rdg">
    <xsl:if test="preceding-sibling::tei:rdg or following-sibling::tei:rdg">
        <xsl:text>Variante </xsl:text>
        <xsl:number/>
        <xsl:text>: </xsl:text>
    </xsl:if>
    <xsl:apply-templates/>
    <xsl:if test="position() != last()">
        <br/>
    </xsl:if>
</xsl:template>
<xsl:template match="tei:lem">
    <xsl:apply-templates/>
</xsl:template>
<!-- damage supplied -->
<xsl:template match="tei:damage">
    <xsl:element name="span">
        <xsl:attribute name="title">
            <xsl:choose>
                <xsl:when test="./@agent='paper_damage'">Papier beschädigt</xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@agent"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        <xsl:if test="not(following::tei:supplied or descendant::tei:supplied)">
            <xsl:text> […]</xsl:text>
        </xsl:if>
        <xsl:apply-templates/>
    </xsl:element>
</xsl:template>
<xsl:template match="tei:supplied">
    <xsl:element name="span">
        <xsl:attribute name="title">editorische Ergänzung

            <xsl:if test="parent::tei:damage">
                <xsl:text> (</xsl:text>
                <xsl:choose>
                    <xsl:when test="../@agent='paper_damage'">Papier beschädigt</xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="../@agent"/>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:text>)</xsl:text>
            </xsl:if>
        </xsl:attribute>
        <xsl:text>&lt;</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&gt;</xsl:text>
    </xsl:element>
</xsl:template>
<!-- choice -->
<xsl:template match="tei:sic">
    <xsl:apply-templates/>
    <xsl:element name="span">
        <xsl:attribute name="title">Fehler/Unstimmigkeit im Originaldokument, KS</xsl:attribute>
        <xsl:text> [sic]</xsl:text>
    </xsl:element>
</xsl:template>
<xsl:template match="tei:choice">
    <xsl:choose>
        <xsl:when test="tei:sic and tei:corr">
            <span class="corr alternate choice4">
                <xsl:attribute name="title">Korrektur der Hrsg. aus: „
                    <xsl:value-of select="tei:sic[1]"/>“
                </xsl:attribute>
                <xsl:if test="@xml:id">
                    <xsl:attribute name="id" select="@xml:id"/>
                </xsl:if>
                <xsl:apply-templates select="tei:corr[1]"/>
                <span class="hidden altcontent">
                    <xsl:if test="@xml:id">
                        <xsl:attribute name="id" select="@xml:id"/>
                    </xsl:if>
                    <xsl:apply-templates select="tei:sic[1]"/>
                </span>
            </span>
        </xsl:when>
        <xsl:when test="tei:seg">
            <xsl:text>[</xsl:text>
            <xsl:for-each select="./tei:seg">
                <xsl:apply-templates/>
                <xsl:if test="position() != last()">
                    <xsl:text> / </xsl:text>
                </xsl:if>
            </xsl:for-each>
            <xsl:text>]</xsl:text>
        </xsl:when>
        <xsl:when test="tei:abbr and tei:expan">
            <xsl:choose>
                <xsl:when test="ancestor::tei:title">
                    <abbr>
                        <xsl:attribute name="title">
                            <xsl:value-of select="tei:expan"/>
                        </xsl:attribute>
                        <xsl:apply-templates select="tei:abbr[1]"/>
                    </abbr>
                </xsl:when>
                <xsl:otherwise>
                    <abbr>
                        <xsl:if test="@xml:id">
                            <xsl:attribute name="id" select="@xml:id"/>
                        </xsl:if>
                        <xsl:attribute name="title">
                            <xsl:value-of select="tei:expan"/>
                        </xsl:attribute>
                        <xsl:apply-templates select="tei:abbr[1]"/>
                        <span class="hidden altcontent ">
                            <xsl:if test="@xml:id">
                                <xsl:attribute name="id" select="@xml:id"/>
                            </xsl:if>
                            <xsl:apply-templates select="tei:expan[1]"/>
                        </span>
                    </abbr>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:when>
        <xsl:when test="tei:orig and tei:reg">
            <span class="alternate choice6" title="alternate">
                <xsl:if test="@xml:id">
                    <xsl:attribute name="id" select="@xml:id"/>
                </xsl:if>
                <xsl:apply-templates select="tei:reg[1]"/>
                <span class="hidden altcontent ">
                    <xsl:if test="@xml:id">
                        <xsl:attribute name="id" select="@xml:id"/>
                    </xsl:if>
                    <xsl:apply-templates select="tei:orig[1]"/>
                </span>
            </span>
        </xsl:when>
    </xsl:choose>
</xsl:template>
<!--<xsl:template match="tei:addSpan"><xsl:variable name="cId"><xsl:value-of select="generate-id(.)"/>
        </xsl:variable><xsl:variable name="hand"/><ins><xsl:element name="a"><xsl:attribute name="class">addSpan</xsl:attribute><xsl:attribute name="name">A<xsl:value-of select="$cId"/>
                </xsl:attribute><xsl:attribute name="href">#N<xsl:value-of select="$cId"/>
                </xsl:attribute><xsl:number level="any"/>
            </xsl:element>
        </ins>
    </xsl:template><xsl:template match="tei:anchor"><xsl:variable name="cId"><xsl:value-of select="generate-id(.)"/>
        </xsl:variable><ins><xsl:element name="a"><xsl:attribute name="class">anchor</xsl:attribute><xsl:attribute name="name">A<xsl:value-of select="$cId"/>
                </xsl:attribute><xsl:attribute name="href">#N<xsl:value-of select="$cId"/>
                </xsl:attribute><xsl:number level="any"/>
            </xsl:element>
        </ins>
    </xsl:template>-->
<!-- Bücher -->
<xsl:template match="tei:bibl">
    <xsl:element name="span">
        <xsl:apply-templates/>
    </xsl:element>
</xsl:template>
<!-- Seitenzahlen -->
<xsl:template match="tei:pb">
    <xsl:choose>
        <xsl:when test="ancestor::tei:table">
            <xsl:variable name="colno" select="count(ancestor::tei:table/tei:row[1]/tei:cell)"/>
            <xsl:element name="tr">
                <xsl:element name="td">
                    <xsl:attribute name="style">text-align:right;font-size:12px;</xsl:attribute>
                    <xsl:attribute name="colspan">
                        <xsl:value-of select="$colno"/>
                    </xsl:attribute>
                    <xsl:text>[Bl. </xsl:text>
                    <xsl:value-of select="@n"/>
                    <xsl:text>]</xsl:text>
                </xsl:element>
            </xsl:element>
        </xsl:when>
        <xsl:otherwise>
            <xsl:element name="span">
                <xsl:attribute name="class">
                    <xsl:text>hr</xsl:text>
                </xsl:attribute>
                <xsl:text>[Bl. </xsl:text>
                <xsl:value-of select="@n"/>
                <xsl:text>]</xsl:text>
            </xsl:element>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>
<!-- Tabellen -->
<xsl:template match="tei:table">
    <xsl:element name="table">
        <xsl:attribute name="class">
            <xsl:choose>
                <xsl:when test="@rend='rules' and not(parent::tei:signed)">
                    <xsl:text>table table-bordered table-condensed table-hover</xsl:text>
                </xsl:when>
                <xsl:when test="parent::tei:signed">
                    <xsl:text>table table-borderless</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>table table-striped table-condensed table-hover</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
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
        <xsl:if test="./@rendition='#u'">
            <xsl:attribute name="style">border-bottom: 1px solid black</xsl:attribute>
            <xsl:attribute name="class">underline</xsl:attribute>
        </xsl:if>
        <xsl:if test="contains(descendant::*/@rend,'#r')">
            <xsl:attribute name="style">text-align:right</xsl:attribute>
        </xsl:if>
        <xsl:if test="./@cols">
            <xsl:attribute name="colspan">
                <xsl:value-of select="./@cols"/>
            </xsl:attribute>
            <xsl:if test="number(@cols) gt 2">
                <xsl:attribute name="style">text-align:center</xsl:attribute>
            </xsl:if>
        </xsl:if>
        <xsl:if test="./@rows">
            <xsl:attribute name="rowspan">
                <xsl:value-of select="./@rows"/>
            </xsl:attribute>
            <xsl:attribute name="style">vertical-align:middle</xsl:attribute>
        </xsl:if>
        <xsl:if test="not(string(number(.))='NaN') or .='-'">
            <xsl:attribute name="style">text-align:right</xsl:attribute>
        </xsl:if>
        <xsl:apply-templates/>
    </xsl:element>
</xsl:template>
<!-- Überschriften -->
<xsl:template match="tei:title">
    <xsl:if test="@xml:id[starts-with(.,'org') or starts-with(.,'ue')]">
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
    <xsl:choose>
        <xsl:when test="@type='sub' or 'desc'">
            <h4>
                <xsl:apply-templates/>
            </h4>
        </xsl:when>
        <xsl:otherwise>
            <h5>
                <div>
                    <xsl:apply-templates/>
                </div>
            </h5>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>
<!--  Quotes / Zitate -->
<xsl:template match="tei:q">
    <xsl:text>„</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>“</xsl:text>
</xsl:template>
<!-- Zeilenumbrüche -->
<xsl:template match="tei:lb">
    <xsl:choose>
        <xsl:when test="ancestor::tei:note">
            <!-- fixing line length in @title tooltips -->
            <xsl:text>

</xsl:text>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text> </xsl:text>
            <br/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>
<!-- Absätze -->
<xsl:template match="tei:p">
    <xsl:element name="p">
        <xsl:if test="ancestor::tei:text">
            <xsl:attribute name="class">ed</xsl:attribute>
        </xsl:if>
        <xsl:if test="./@rendition='#r'">
            <xsl:attribute name="style">
                <xsl:text>text-align:right; margin-right:3rem;</xsl:text>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="./@rendition='#et'">
            <xsl:attribute name="style">
                <xsl:text>margin-left:2rem; text-indent:0rem</xsl:text>
            </xsl:attribute>
        </xsl:if>
        <xsl:apply-templates/>
    </xsl:element>
</xsl:template>
<xsl:template match="tei:metamark">
    <!-- Metamarks -->
    <xsl:apply-templates/>
    <xsl:if test="position() != last() and parent::tei:div and not(following-sibling::tei:metamark)">
        <br/>
    </xsl:if>
    <xsl:if test="position() != last() and parent::tei:div and following-sibling::tei:metamark">
        <span style="margin-left:8rem;"/>
    </xsl:if>
    <xsl:if test="position()"/>
</xsl:template>
<!-- Substitutions -->
<xsl:template match="tei:subst">
    <xsl:apply-templates/>
</xsl:template>
<!-- Durchstreichungen -->
<xsl:template match="tei:del">
    <xsl:element name="del">
        <xsl:if test="@rendition[not(contains(.,' '))]">
            <xsl:variable name="style" select="substring-after(@rendition, '#')"/>
            <xsl:attribute name="style">
                <xsl:value-of select="root()//tei:rendition[@xml:id=current()/$style]"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:apply-templates/>
        <xsl:text> </xsl:text>
    </xsl:element>
</xsl:template>
<xsl:function name="my:fetch-delSpan" as="element(tei:delSpan)?">
    <xsl:param name="n" as="node()"/>
    <!-- del will be the most recent delSpan milestone -->
    <xsl:variable name="del" select="$n/preceding::tei:delSpan[1]"/>
    <!-- $del/id(@spanTo) will be its end anchor -->
    <!-- return $del if its end anchor appears after the argument node -->
    <xsl:sequence select="$del[id(@spanTo) &gt;&gt; $n]"/>
</xsl:function>
<xsl:template match="text()[exists(my:fetch-delSpan(.))]">
    <del>
        <xsl:next-match/>
    </del>
</xsl:template>
<xsl:template match="tei:country">
    <span>
        <!--            <xsl:attribute name="style">color:purple</xsl:attribute>-->
        <xsl:attribute name="title">//country</xsl:attribute>
        <xsl:apply-templates/>
    </span>
</xsl:template>
<xsl:template match="tei:label">
    <xsl:variable name="handId" select="substring-after(./@hand, '#')"/>
    <xsl:element name="p">
        <xsl:attribute name="class">ed</xsl:attribute>
        <xsl:attribute name="style">margin-left:-1em</xsl:attribute>
        <xsl:attribute name="title">Marginalie

            <xsl:if test="$handId">
                    Hand:
                <xsl:value-of select="normalize-space(root()//tei:handNote[@xml:id=$handId])"/>
            </xsl:if>
        </xsl:attribute>
        <xsl:apply-templates/>
    </xsl:element>
</xsl:template>
<xsl:template match="tei:g">
    <xsl:variable name="glyphId" select="@ref"/>
    <xsl:element name="img">
        <xsl:attribute name="src">
            <xsl:value-of select="root()//tei:charDecl/tei:glyph[$glyphId]/tei:graphic/@url"/>
        </xsl:attribute>
        <xsl:attribute name="title">
            <xsl:value-of select="root()//tei:charDecl/tei:glyph[$glyphId]/tei:desc"/>
        </xsl:attribute>
        <xsl:attribute name="style">width:4em;margin-left:3em;</xsl:attribute>
    </xsl:element>
    <xsl:apply-templates/>
</xsl:template>
<xsl:template match="tei:note[@type='editorial']">
    <xsl:element name="a">
        <xsl:attribute name="name">
            <xsl:text>fna_</xsl:text>
            <xsl:number level="any" format="1" count="tei:note[@type='editorial']"/>
        </xsl:attribute>
        <xsl:attribute name="href">
            <xsl:text>#fn</xsl:text>
            <xsl:number level="any" format="1" count="tei:note[@type='editorial']"/>
        </xsl:attribute>
        <xsl:attribute name="title">
            <xsl:value-of select="normalize-space(string-join(./descendant-or-self::*[not(name()='expan')]/text(), ''))"/>
        </xsl:attribute>
        <sup>
            <xsl:number level="any" format="1" count="tei:note[@type='editorial']"/>
        </sup>
    </xsl:element>
</xsl:template>
<xsl:template match="tei:note[@type='author']">
    <xsl:element name="a">
        <xsl:attribute name="name">
            <xsl:text>fna_</xsl:text>
            <xsl:number level="any" format="a" count="tei:note[@type='author']"/>
        </xsl:attribute>
        <xsl:attribute name="href">
            <xsl:text>#fn</xsl:text>
            <xsl:number level="any" format="a" count="tei:note[@type='author']"/>
        </xsl:attribute>
        <xsl:attribute name="title">
            <xsl:value-of select="normalize-space(string-join(./descendant-or-self::*[not(name()='expan')]/text(), ''))"/>
        </xsl:attribute>
        <sup>
            <xsl:number level="any" format="a" count="tei:note[@type='author']"/>
        </sup>
    </xsl:element>
</xsl:template>
<xsl:template match="tei:div">
    <xsl:variable name="msId" select="substring-after(@decls, '#')"/>
    <xsl:variable name="handId" select="substring-after(@hand, '#')"/>
    <xsl:choose>
        <xsl:when test="@decls">
            <xsl:element name="div">
                <xsl:attribute name="class">well</xsl:attribute>
                <xsl:attribute name="id">
                    <xsl:value-of select="$msId"/>
                </xsl:attribute>
                <xsl:if test="root()//tei:handNote[@xml:id=$handId]">
                    <xsl:element name="p">
                        <xsl:attribute name="title">//tei:handNote</xsl:attribute>
                        <em>
                            <xsl:text>Hand: </xsl:text>
                            <xsl:value-of select="root()//tei:handNote[@xml:id=$handId]"/>
                        </em>
                    </xsl:element>
                </xsl:if>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:when>
        <xsl:when test="@type='regest'">
            <div>
                <xsl:attribute name="class">
                    <text>regest</text>
                </xsl:attribute>
                <xsl:apply-templates/>
            </div>
        </xsl:when>
        <!-- transcript -->
        <xsl:when test="@type='transcript'">
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
<xsl:template match="tei:glyph">
    <xsl:variable name="glyphId" select="@ref"/>
    <xsl:element name="img">
        <xsl:attribute name="src">
            <xsl:value-of select="root()//tei:charDecl/tei:glyph[$glyphId]/tei:graphic/@url"/>
        </xsl:attribute>
        <xsl:attribute name="title">
            <xsl:value-of select="root()//tei:charDecl/tei:glyph[$glyphId]/tei:desc"/>
        </xsl:attribute>
        <xsl:attribute name="style">width:4em;margin-left:3em;</xsl:attribute>
    </xsl:element>
    <xsl:apply-templates/>
</xsl:template>
<xsl:template match="tei:unclear">
    <xsl:element name="span">
        <xsl:attribute name="title">unsichere Lesung</xsl:attribute>
        <xsl:apply-templates/>
        <xsl:text> [?] </xsl:text>
    </xsl:element>
</xsl:template>
<xsl:template match="tei:gap">
    <xsl:element name="span">
        <xsl:choose>
            <xsl:when test="@ana">
                <xsl:attribute name="title">
                    <xsl:value-of select="@ana"/>
                </xsl:attribute>
                <xsl:text> </xsl:text>
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="title">Textlücke

                    <xsl:if test="@extent">
                        <xsl:text> (</xsl:text>
                        <xsl:value-of select="@extent"/>
                        <xsl:if test="@reason">
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="@reason"/>
                        </xsl:if>
                        <xsl:text>)</xsl:text>
                    </xsl:if>
                </xsl:attribute>
                <xsl:attribute name="style">font-size:x-small;vertical-align:super;</xsl:attribute>
                <xsl:text> [Lücke</xsl:text>
                <xsl:apply-templates/>
                <xsl:text>] </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:element>
</xsl:template>
<xsl:template match="//tei:notesStmt/tei:note">
    <xsl:element name="p">
        <xsl:apply-templates/>
    </xsl:element>
</xsl:template>
<xsl:template match="//tei:seg">
    <xsl:apply-templates/>
</xsl:template>
<xsl:template match="tei:signed">
    <xsl:variable name="handId" select="substring-after(@hand, '#')"/>
    <xsl:variable name="msId" select="substring-after(parent::tei:div/@decls, '#')"/>
    <xsl:variable name="divtype" select="root()//tei:msDesc[@xml:id=$msId]/@type"/>
    <xsl:choose>
        <xsl:when test="not(contains($divtype,'riginal'))">
            <p class="signed" style="font-size:small">[Unterschriften nicht originalschriftlich:
                <xsl:value-of select="$divtype"/>]
            </p>
        </xsl:when>
    </xsl:choose>
    <xsl:choose>
        <xsl:when test="./tei:list">
            <xsl:for-each select="./tei:list/tei:item">
                <xsl:element name="p">
                    <xsl:attribute name="class">
                        <xsl:text>signed</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="title">
                        <xsl:text>Hand von </xsl:text>
                        <xsl:value-of select="root()//tei:handNote[@xml:id=$handId]"/>
                        <xsl:text> (</xsl:text>
                        <xsl:value-of select="./@hand"/>
                        <xsl:text>)</xsl:text>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
            <xsl:for-each select=".">
                <xsl:element name="p">
                    <xsl:attribute name="class">
                        <xsl:text>signed</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="title">
                        <xsl:text>Hand von </xsl:text>
                        <xsl:value-of select="root()//tei:handNote[@xml:id=$handId]"/>
                        <xsl:text> (</xsl:text>
                        <xsl:value-of select="./@hand"/>
                        <xsl:text>)</xsl:text>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:for-each>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>
</xsl:stylesheet>