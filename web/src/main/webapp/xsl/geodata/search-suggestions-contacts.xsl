<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method='html' encoding='UTF-8' indent='yes'/>

  <xsl:include href="../utils.xsl"/>
  
  <xsl:variable name="siteURL"
    select="concat(/root/gui/env/server/protocol,'://',/root/gui/env/server/host,':',/root/gui/env/server/port, /root/gui/locService)"/>

  <!--
      Response format:

      {"data": [
         {"label" : "label1", "value" : "value1"},
         {"label" : "label2", "value" : "value2"},
         {"label" : "label3", "value" : "value3"}
        ]
      }
  -->
  <xsl:template match="/">
    {"data":
    [
    <xsl:choose>
      <xsl:when test="ends-with(/root/request/field, 'NoRole')">
        <xsl:call-template name="itemsWithoutRole" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="itemsWithRole" />
      </xsl:otherwise>

    </xsl:choose>
    ]}

  </xsl:template>
  
  
  <xsl:template name="itemsWithRole">
    <xsl:variable name="query" select="/root/request/q" />
    <xsl:variable name="roleCodelist" select="/root/gui/schemas/iso19139/codelists/codelist[@name='gmd:CI_RoleCode']" />

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
            {"value": "<xsl:value-of select="$value" />", "label": "<xsl:value-of select="$value2" /> <xsl:if test="string($role)">(<xsl:value-of select="$role" />)</xsl:if>"}
          </xsl:when>
          <xsl:otherwise>
            {"value": "<xsl:value-of select="$value" />", "label": "<xsl:value-of select="$value2" />"}
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>

      <xsl:if test="position()!=last() and string($value2)"
          >,</xsl:if>
    </xsl:for-each>
  </xsl:template>


  <xsl:template name="itemsWithoutRole">
    <xsl:for-each select="/root/items/item">
      <xsl:sort select="@term" />

      <xsl:variable name="value">
        <xsl:call-template name="replaceString">
          <xsl:with-param name="expr"        select="@term"/>
          <xsl:with-param name="pattern"     select="'&quot;'"/>
          <xsl:with-param name="replacement" select="'\&quot;'"/>
        </xsl:call-template>
        <xsl:if test="/root/request/withFrequency"> (<xsl:value-of select="@freq"/>)</xsl:if>
      </xsl:variable>

      {"value": "<xsl:value-of select="$value" />", "label": "<xsl:value-of select="$value" />"}
      <xsl:if test="position()!=last()"
          >,</xsl:if>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>