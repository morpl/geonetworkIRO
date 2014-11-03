<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet 	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                 xmlns:geonet="http://www.fao.org/geonetwork"
                 xmlns:exslt= "http://exslt.org/common"
                 xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
                 exclude-result-prefixes="#all">

  <xsl:variable name="server" select="concat(//server/protocol, '://', //server/host,':', //server/port)" />
  <xsl:variable name="urlPath" select="/root/gui/url" />

  <!-- Field separator:
    To use tab instead of semicolon, use "&#009;".
    Default is comma.
  -->
  <xsl:variable name="sep" select="','"/>

  <!-- Intra field separator -->
  <xsl:variable name="internalSep" select="'###'"/>

  <!-- A template to add a new line \n with no extra space. -->
<xsl:template name="newLine">
<xsl:text>
</xsl:text>
</xsl:template>

  <!-- Dump line -->
  <xsl:template name="csvLine">
    <xsl:param name="columns"/>
    <xsl:param name="metadata"/>

    <!--<xsl:value-of select="concat('&quot;', $metadata/geonet:info/schema, '&quot;', $sep,
                  '&quot;', $metadata/geonet:info/uuid, '&quot;', $sep,
                  '&quot;', $metadata/geonet:info/id, '&quot;', $sep)"/>-->



    <xsl:for-each select="$columns">
      <xsl:variable name="currentColumn" select="@name"/>
      <xsl:text>"</xsl:text>
      <xsl:choose>
        <xsl:when test="@name='geoBox'">
          <xsl:value-of select="replace(replace(string-join($metadata/*[name(.)=$currentColumn]/*, $internalSep), '\n|\r\n', ''), '&quot;', '\\&quot;')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="replace(replace(string-join($metadata/*[name(.)=$currentColumn], $internalSep), '\n|\r\n', ''), '&quot;', '\\&quot;')"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>"</xsl:text><xsl:value-of select="$sep"/>
    </xsl:for-each>

    <xsl:value-of select="concat('&quot;', $metadata/geonet:info/uuid, '&quot;', $sep,
									concat('=HYPERLINK(', '&quot;', $server, $urlPath, '?uuid=', geonet:info/uuid, '&quot;'))"/>

    <xsl:call-template name="newLine"/>
  </xsl:template>
</xsl:stylesheet>