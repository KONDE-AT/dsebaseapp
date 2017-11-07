<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="tei" version="2.0">
    <xsl:param name="entiyID"/>
    <xsl:template match="/"><!--        http://digital-archiv.at:8081/exist/apps/aratea-online/pages/show.html?document=listWork.xml&directory=indices&stylesheet=listWork.xsl&work=hansi--><!-- Modal -->
        <div class="modal" id="myModal" role="dialog">
            <div class="modal-dialog"><!-- Modal content-->
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">
                            <span class="fa fa-times"/>
                        </button>
                        <h4 class="modal-title">
                            <xsl:value-of select="//tei:person[@xml:id=$entiyID]//tei:forename"/>&#160; 
                            <xsl:value-of select="//tei:person[@xml:id=$entiyID]//tei:surname"/>
                        </h4>
                    </div>
                    <div class="modal-body">
                        <table class="table table-boardered table-hover">
                            <tr>
                                <th>Lebensdaten</th>
                                <td>
                                    <xsl:value-of select="//tei:person[@xml:id=$entiyID]//tei:p[1]"/>
                                </td>
                            </tr>
                            <tr>
                                <th>Biographisches</th>
                                <td>
                                    <xsl:value-of select="//tei:person[@xml:id=$entiyID]//tei:p[2]"/>
                                </td>
                            </tr>
                            <tr>
                                <th>GND</th>
                                <td>
                                    <xsl:choose>
                                        <xsl:when test="starts-with(.//tei:person[@xml:id=$entiyID]//tei:p[3], 'http')">
                                            <a>
                                                <xsl:attribute name="href">
                                                    <xsl:value-of select=".//tei:person[@xml:id=$entiyID]//tei:p[3]"/>
                                                </xsl:attribute>
                                                <xsl:attribute name="target">_blank</xsl:attribute>
                                                <xsl:value-of select=".//tei:person[@xml:id=$entiyID]//tei:p[3]"/>
                                            </a>
                                        </xsl:when>
                                        <xsl:otherwise>kein passender GND-Eintrag</xsl:otherwise>
                                    </xsl:choose>
                                </td>
                            </tr>
                            <tr>
                                <th>sonstiges</th>
                                <td>
                                    <xsl:value-of select="//tei:person[@xml:id=$entiyID]//tei:p[4]"/>
                                </td>
                            </tr>
                        </table>
                    </div>
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