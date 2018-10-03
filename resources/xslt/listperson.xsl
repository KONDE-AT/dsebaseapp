<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="tei" version="2.0">
    <xsl:import href="shared/base_index.xsl"/>
    <xsl:param name="entiyID"/>
    <xsl:variable name="entity" as="node()">
        <xsl:choose>
            <xsl:when test="//tei:person[@xml:id=$entiyID][1]">
                <xsl:value-of select="//tei:person[@xml:id=$entiyID][1]"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="false()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:template match="/">       
        <div class="modal" tabindex="-1" role="dialog" id="myModal">
            <div class="modal-dialog">
                <div class="modal-content">
                    <xsl:choose>
                        <xsl:when test="$entity">
                            <div class="modal-header">
                                <xsl:variable name="entity" select="//tei:person[@xml:id=$entiyID]"/>
                                <h3 class="modal-title">
                                    <xsl:choose>
                                        <xsl:when test="//$entity//tei:surname[1]/text()">
                                            <xsl:value-of select="$entity//tei:surname[1]/text()"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="$entity//tei:persName[1]"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <br/>
                                    <small>
                                        <a>
                                            <xsl:attribute name="href">
                                                <xsl:value-of select="concat('hits.html?searchkey=', $entiyID)"/>
                                            </xsl:attribute>
                                            <xsl:attribute name="target">_blank</xsl:attribute>
                                            mentioned in
                                        </a>
                                    </small>
                                </h3>
                                
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                    <span aria-hidden="true">x</span>
                                </button>
                            </div>
                            <div class="modal-body">
                                <table class="table table-boardered table-hover">
                                    <xsl:variable name="entity" select="//tei:person[@xml:id=$entiyID]"/>
                                    <xsl:for-each select="$entity//tei:persName">
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
                                                        hallo
                                                    </xsl:otherwise>
                                                </xsl:choose>                                                
                                            </td>
                                        </tr>
                                        <xsl:choose>
                                            <xsl:when test="$entity//tei:roleName">
                                                <tr>
                                                    <th>
                                                        role name(s)
                                                    </th>
                                                    <td>
                                                        <xsl:for-each select="$entity//tei:roleName">
                                                            <xsl:value-of select="."/>
                                                            <br/>
                                                        </xsl:for-each>
                                                    </td>
                                                </tr>
                                            </xsl:when>
                                        </xsl:choose>
                                        <xsl:choose>
                                            <xsl:when test="$entity//tei:birth and $entity//tei:death">
                                                <tr>
                                                    <th>
                                                        birth and death
                                                    </th>
                                                    <td>
                                                        <xsl:value-of select="$entity//tei:birth"/>
                                                        <br/>
                                                        <xsl:value-of select="$entity//tei:death"/>
                                                    </td>
                                                </tr>
                                            </xsl:when>
                                            <xsl:when test="$entity//tei:birth">
                                                <tr>
                                                    <th>
                                                        birth
                                                    </th>
                                                    <td>
                                                        <xsl:value-of select="$entity//tei:birth"/>
                                                    </td>
                                                </tr>
                                            </xsl:when>
                                            <xsl:when test="$entity//tei:death">
                                                <tr>
                                                    <th>
                                                        death
                                                    </th>
                                                    <td>
                                                        <xsl:value-of select="$entity//tei:death"/>
                                                    </td>
                                                </tr>
                                            </xsl:when>
                                        </xsl:choose>
                                    </xsl:for-each>
                                    <xsl:if test="$entity/tei:idno[@type='URL']">
                                        <tr>
                                            <th>URL:</th>
                                            <td>
                                                <a>
                                                    <xsl:attribute name="href">
                                                        <xsl:value-of select="$entity/tei:idno[@type='URL']/text()"/>
                                                    </xsl:attribute>
                                                    <xsl:value-of select="$entity/tei:idno[@type='URL']/text()"/>
                                                </a>
                                            </td>
                                        </tr>
                                    </xsl:if>
                                </table>
                                <div>
                                    <h4 data-toggle="collapse" data-target="#more"> more (tei structure)</h4>
                                    <div id="more" class="collapse">
                                        <xsl:choose>
                                            <xsl:when test="//*[@xml:id=$entiyID or @id=$entiyID]">
                                                <xsl:apply-templates select="//*[@xml:id=$entiyID or @id=$entiyID]" mode="start"/>
                                            </xsl:when>
                                            <xsl:otherwise>Looks like there exists no index entry for ID<strong>
                                                <xsl:value-of select="concat(' ', $entiyID)"/>
                                            </strong> 
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </div>
                                </div>
                            </div>
                        </xsl:when>
                        <xsl:otherwise>
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal">
                                    <span class="fa fa-times"/>
                                </button>
                                <h3 class="modal-title">
                                    Looks like there doesn't exist an index entry <strong>
                                        <xsl:value-of select="$entiyID"/>
                                    </strong> for the entity you were looking for  
                                </h3>
                                
                            </div>
                        </xsl:otherwise>
                    </xsl:choose>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>
        <script type="text/javascript">
            $(window).load(function(){
            $('#myModal').modal('show');
            });
        </script>
    </xsl:template>
</xsl:stylesheet>