<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet 	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
						xmlns:geonet="http://www.fao.org/geonetwork" 
						xmlns:exslt= "http://exslt.org/common"
						xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
						exclude-result-prefixes="#all">
	<!-- 
		CSV search results export.
		
		Default formatting will be column header + all tags.
		Sort order is schema based due to formatting which 
		could be different according to schema.
		
		In order to override default formatting, create a template
		with mode="csv" in the metadata-schema.xsl matching the root
		element in order to create a one level tree structure :

		Example to export only title from ISO19139 records.		
		<pre>
				<xsl:template match="gmd:MD_Metadata" mode="csv">
					<xsl:param name="internalSep"/>
					
					<metadata>
						<xsl:copy-of select="geonet:info"/>
						
						<xsl:copy-of select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title"/>
						...
					</metadata>
				</xsl:template>
					
		</pre>
		
		The internal separator is used to join multiple objects in one
		columns (eg. keywords will be keyword1###keyword2... and could be explode 
		if needed in a spreadsheet).
	 -->
	<xsl:output method="text" version="1.0" encoding="utf-8" indent="no"/>	
	
	<xsl:strip-space elements="*"/>


	<xsl:include href="../utils.xsl"/>
	<xsl:include href="../metadata.xsl"/>
  <xsl:include href="csv-search-common.xsl"/>


	<!-- Main template -->
	<xsl:template name="content" match="/">
		<!-- Sort results first as csv output could be different from one schema to another. 
		Create the sorted set based on the search response. Use the brief mode or the csv mode if 
		available.
		-->
		<xsl:variable name="sortedResults">
			<xsl:for-each select="/root/csw:GetRecordsResponse/csw:SearchResults/*|
						/root/response/*[name(.)!='summary']">
				<xsl:sort select="geonet:info/schema" order="descending"/>
				
				<!-- Try to apply csv mode template to current metadata record -->
				<xsl:variable name="mdcsv">
					<xsl:apply-templates mode="csv" select=".">
						<xsl:with-param name="internalSep" select="$internalSep"/>
					</xsl:apply-templates>
				</xsl:variable>
				<!-- If not define just use the brief format -->
				<xsl:variable name="md">
					<xsl:choose>
						<xsl:when test=". != $mdcsv">
							<xsl:copy-of select="$mdcsv"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates mode="brief" select="."/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				
				<xsl:copy-of select="exslt:node-set($md)/*[1]"/>
			</xsl:for-each>
		</xsl:variable>

    <xsl:variable name="columnTranslations" select="/root/gui/strings/csvExportColumns" />

		<xsl:variable name="columns">
			<xsl:for-each-group select="$sortedResults/*" group-by="geonet:info/schema">
				<xsl:variable name="schemaName" select="current-grouping-key()" />
        <!--<xsl:message>schemaName: <xsl:value-of select="$schemaName" /></xsl:message>-->
        <schema name="{current-grouping-key()}">
				<xsl:for-each-group select="current-group()/*[name(.)!='geonet:info']"  group-by="name(.)">
          <xsl:variable name="columnKey" select="name(.)" />
          <!--<xsl:message>columnKey: <xsl:value-of select="$columnKey" /></xsl:message>-->
            <xsl:choose>
              <xsl:when test="string($columnTranslations/*[name() = $schemaName]/*[name() = $columnKey])">
                <column name="{name(.)}">"<xsl:value-of select="$columnTranslations/*[name() = $schemaName]/*[name() = $columnKey]"/>"</column>
              </xsl:when>
              <xsl:otherwise>
                <column name="{name(.)}">"<xsl:value-of select="name(.)"/>"</column>
              </xsl:otherwise>
            </xsl:choose>

				</xsl:for-each-group>
				</schema>
			</xsl:for-each-group>
		</xsl:variable>

		<!-- Display results
				* header first (once)
				* content then.
		-->
		<xsl:for-each select="$sortedResults/*">
			<xsl:variable name="currentSchema" select="geonet:info/schema"/>
      <xsl:choose>
        <xsl:when test="position()!=1 and $currentSchema=preceding-sibling::node()/geonet:info/schema"/>
				<xsl:otherwise>
					<!-- CSV header, schema and id first, then from schema column list -->
					<!--<xsl:text>"schema"</xsl:text>-->
					<!--<xsl:value-of select="$sep"/>-->

					<xsl:value-of select="string-join($columns/schema[@name=$currentSchema]/column,
														$sep)"></xsl:value-of>

          <xsl:value-of select="$sep"/>
          <xsl:value-of select="concat('&quot;', $columnTranslations/uuid, '&quot;')" />
          <xsl:value-of select="$sep"/>
          <xsl:value-of select="concat('&quot;', $columnTranslations/link, '&quot;')" />



					<xsl:call-template name="newLine"/>
        </xsl:otherwise>
      </xsl:choose>

<xsl:call-template name="csvLine">
  <xsl:with-param name="columns" select="$columns/schema[@name=$currentSchema]/column"/>
  <xsl:with-param name="metadata" select="."/>
</xsl:call-template>
</xsl:for-each>

</xsl:template>

</xsl:stylesheet>
