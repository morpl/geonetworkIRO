<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method='html' encoding='UTF-8' indent='yes'/>

  <xsl:include href="../utils.xsl"/>
  
  <xsl:variable name="siteURL"
    select="concat(/root/gui/env/server/protocol,'://',/root/gui/env/server/host,':',/root/gui/env/server/port, /root/gui/locService)"/>
  
  <xsl:template match="/">
    <!--<ul>
      <xsl:for-each select="/root/items/item">
        <xsl:variable name="value">
          <xsl:call-template name="replaceString">
            <xsl:with-param name="expr"        select="@term"/>
            <xsl:with-param name="pattern"     select="'&quot;'"/>
            <xsl:with-param name="replacement" select="'\&quot;'"/>
          </xsl:call-template>
          <xsl:if test="/root/request/withFrequency"> (<xsl:value-of select="@freq"/>)</xsl:if>
        </xsl:variable>

        <li>
          <xsl:choose>
            <xsl:when test="contains($value, '|')"><xsl:value-of select="tokenize($value, '\|')[2]" /></xsl:when>
            <xsl:otherwise><xsl:value-of select="$value"/></xsl:otherwise>
          </xsl:choose>
        </li>
      </xsl:for-each>
    </ul>-->

    <xsl:variable name="query" select="/root/request/q" />
    <xsl:variable name="roleCodelist" select="/root/gui/schemas/iso19139/codelists/codelist[@name='gmd:CI_RoleCode']" />

    <option value=""></option>
    <xsl:for-each select="/root/items/item">
      <xsl:sort select="tokenize(@term, '\|')[2]" />

      <xsl:variable name="value">
        <xsl:call-template name="replaceString">
          <xsl:with-param name="expr"        select="@term"/>
          <xsl:with-param name="pattern"     select="'&quot;'"/>
          <xsl:with-param name="replacement" select="'\&quot;'"/>
        </xsl:call-template>
        <xsl:if test="/root/request/withFrequency"> (<xsl:value-of select="@freq"/>)</xsl:if>
      </xsl:variable>

      <xsl:variable name="value1" select="tokenize($value, '\|')[1]" />
      <xsl:variable name="value2" select="tokenize($value, '\|')[2]" />

      <xsl:if test="string($value2)">
        <xsl:choose>
          <xsl:when test="starts-with($query, '|')">
            <xsl:variable name="role" select="$roleCodelist/entry[code = $value1]/label" />
            <option value="{$value}"><xsl:value-of select="$value2" /> <xsl:if test="string($role)">(<xsl:value-of select="$role" />)</xsl:if></option>
          </xsl:when>
          <xsl:otherwise>
            <option value="{$value}"><xsl:value-of select="$value2" /></option>
          </xsl:otherwise>
        </xsl:choose>

      </xsl:if>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>