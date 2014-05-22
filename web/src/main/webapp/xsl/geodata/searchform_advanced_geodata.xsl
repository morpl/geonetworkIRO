<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:geonet="http://www.fao.org/geonetwork"
	xmlns:java="java:org.fao.geonet.util.XslUtil"
	exclude-result-prefixes="xsl geonet java">

	<xsl:template name="advanced_geodata_search_panel">
		<xsl:variable name="formName" select="'advanced_geodata_search_form'"/>

		<form name="{$formName}" id="{$formName}">
		 <div style="border-bottom: 1px solid;">
			<xsl:comment>ADVANCED SEARCH</xsl:comment>	
			
			<xsl:comment>ADV SEARCH: WHAT?</xsl:comment>
			<xsl:call-template name="adv_what_geodata" />

     <xsl:comment>ADV SEARCH: CONTACT?</xsl:comment>
     <xsl:call-template name="adv_contact_geodata" />

      <!--<xsl:comment>ADV SEARCH: WHERE?</xsl:comment>
			<xsl:call-template name="adv_where_geodata">
				<xsl:with-param name="remote" select="$remote"/>
			</xsl:call-template>-->
		
			<xsl:comment>ADV SEARCH: WHEN?</xsl:comment>
      <xsl:call-template name="adv_when_geodata" />

			<!--<xsl:comment>ADV SEARCH: INSPIRE</xsl:comment>
			<xsl:if test="/root/gui/env/inspire/enable = 'true' and /root/gui/env/inspire/enableSearchPanel = 'true' and not($remote)">
				<xsl:call-template name="adv_inspire"></xsl:call-template>
			</xsl:if>-->

			<!-- Search button -->
			<div>		
				<table class="advsearchfields" width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td style="background: url({/root/gui/url}/images/arrow-bg.gif) repeat-x;" height="29px" width="50%">
						</td>
						<td style="padding:0px; margin:0px;" width="36px">
							<img width="36px" style="padding:0px; margin:0px;"  src="{/root/gui/url}/images/arrow-right.gif" alt="" />
						</td>
						<td style="padding:0px; margin:0px;" width="13px">
							<img width="13px" style="padding:0px; margin:0px;"  src="{/root/gui/url}/images/search-left.gif" alt="" />
						</td>
								<td align="center" style="background: url({/root/gui/url}/images/search-bg.gif) repeat-x; width: auto; white-space: nowrap; padding-bottom: 8px; vertical-align: bottom; cursor:hand;  cursor:pointer;" onclick="runAdvancedGeoDataSearch();" >
									<font color="#FFFFFF"><strong><xsl:value-of select="/root/gui/strings/search"/></strong></font>
								</td>
						<td style="padding:0px; margin:0px;" width="12px">
							<img width="12px" style="padding:0px; margin:0px;"  src="{/root/gui/url}/images/search-right.gif" alt="" />
						</td>
					</tr>
				</table>		
			</div>
			
			<!-- Links to Reset fields, Advanced Search and Options panel --> 
			<div style="padding-left:10px;padding-top:5px;" align="right">
        <a onClick="resetAdvancedGeoDataSearch();" style="cursor:pointer; padding-right:10px; padding-left:10px;"><xsl:value-of select="/root/gui/strings/reset"/></a>
			</div>

      <div style="padding-left:10px;padding-top:5px;" align="right">
        <a onclick="showFields('restrictions.img','restrictions.table')" style="cursor:pointer;cursor:hand;padding-right:10px;">
          <img id="restrictions.img" src="{/root/gui/url}/images/plus.gif" alt="" />
          <xsl:text> </xsl:text>
          <xsl:value-of select="/root/gui/strings/restrictTo"/>
        </a>

        <a onclick="showFields('advoptions.img','advoptions.table')" style="cursor:pointer;cursor:hand;padding-right:10px;">
          <img id="advoptions.img" src="{/root/gui/url}/images/plus.gif" alt="" />
          <xsl:text> </xsl:text>
          <xsl:value-of select="/root/gui/strings/options"/>
        </a>
      </div>

			
			<!-- Options panel in advanced search -->
			<div id="advoptions.table" style="display:none; margin-top:5px; margin-bottom:5px">

                <xsl:if test="/root/gui/env/requestedLanguage/ignored = 'false'">
                <!-- language - - - - - - - - - - - - - - - - - - - - -->
                <div class="row" >
                    <span class="labelField">Language</span>
                    <select class="content" name="requestedLanguage" id="requestedLanguage" style="width: 150px"
                            onchange="$('requestedLanguage_simple').value = this.options[this.selectedIndex].value">
                        <option value="">
                            <xsl:value-of select="/root/gui/strings/anyLanguage"/>
                        </option>

                        <xsl:for-each select="/root/gui/isolanguages/record">
                            <xsl:sort select="label/child::*[name() = $lang]" order="ascending"/>
                            <option>
                                <xsl:if test="code = $lang">
                                    <xsl:attribute name="selected">selected</xsl:attribute>
                                </xsl:if>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="code"/>
                                </xsl:attribute>
                                <xsl:value-of select="label/child::*[name() = $lang]"/>
                            </option>
                        </xsl:for-each>
                    </select>
                </div>
                </xsl:if>
			
				<!-- sort by - - - - - - - - - - - - - - - - - - - - -->		
				<div class="row">
					<span class="labelField"><xsl:value-of select="/root/gui/strings/sortBy"/></span>
				  <select id="sortBy" name="sortBy" size="1" class="content" 
						 onChange="if (this.options[this.selectedIndex].value=='title') $('sortOrder').value = 'reverse'; else $('sortOrder').value = ''">
						<xsl:for-each select="/root/gui/strings/sortByType">
							<option value="{@id}">
								<xsl:if test="@id = /root/gui/searchDefaults/sortBy">
									<xsl:attribute name="selected">selected</xsl:attribute>
								</xsl:if>
								<xsl:value-of select="."/>
							</option>
						</xsl:for-each>
					</select>
					<input type="hidden" name="sortOrder" id="sortOrder"/>
				</div>
				
				<!-- hits per page - - - - - - - - - - - - - - - - - - -->
				<div class="row">
					<span class="labelField"><xsl:value-of select="/root/gui/strings/hitsPerPage"/></span>
					<select class="content" id="hitsPerPage" name="hitsPerPage" onchange="$('hitsPerPage_simple').value = this.options[this.selectedIndex].value">
						<xsl:for-each select="/root/gui/strings/hitsPerPageChoice">
						  <xsl:sort select="@value" data-type="number"/>
						  <option>
								<xsl:if
									test="string(@value)=string(/root/gui/searchDefaults/hitsPerPage)">
									<xsl:attribute name="selected">selected</xsl:attribute>
								</xsl:if>
								<xsl:attribute name="value">
									<xsl:value-of select="@value"/>
								</xsl:attribute>
								<xsl:value-of select="."/>
							</option>
						</xsl:for-each>
					</select>
				</div>
				
				<!-- output - - - - - - - - - - - - - - - - - - - - - - -->
				<div class="row">
					<span class="labelField"><xsl:value-of select="/root/gui/strings/output"/></span>

					<select id="output" name="output" size="1" class="content" onchange="$('output_simple').value = this.options[this.selectedIndex].value">
						<xsl:for-each select="/root/gui/strings/outputType">
							<option value="{@id}">
								<xsl:if test="@id = /root/gui/searchDefaults/output">
									<xsl:attribute name="selected">selected</xsl:attribute>
								</xsl:if>
								<xsl:value-of select="."/>
							</option>
						</xsl:for-each>
					</select>
				</div>
			</div>
			
			<!-- Restrictions -->
			<div id="restrictions.table" style="display:none; margin-top:5px; margin-bottom:5px">
				<!-- Source -->
				<div class="row">
					<span class="labelField"><xsl:value-of select="/root/gui/strings/porCatInfoTab"/></span>
					
					<select class="content" name="siteId" id="siteId">
						<option value="">
							<xsl:if test="/root/gui/searchDefaults/siteId=''">
								<xsl:attribute name="selected"/>
							</xsl:if>
							<xsl:value-of select="/root/gui/strings/any"/>
						</option>
						<xsl:for-each select="/root/gui/sources/record">
							<!--
								<xsl:sort order="ascending" select="name"/>
							-->
							<xsl:variable name="source" select="siteid/text()"/>
							<xsl:variable name="sourceName" select="name/text()"/>
							<option value="{$source}">
								<xsl:if test="$source=/root/gui/searchDefaults/siteId">
									<xsl:attribute name="selected"/>
								</xsl:if>
								<xsl:value-of select="$sourceName"/>
							</option>
						</xsl:for-each>
					</select>
				</div>
				
				<!-- Group -->	
				<xsl:if	test="string(/root/gui/session/userId)!=''">
					<div class="row">
						<span class="labelField"><xsl:value-of select="/root/gui/strings/group"/></span>
						
						<select class="content" name="group" id="group">
							<option value="">
								<xsl:if test="/root/gui/searchDefaults/group=''">
									<xsl:attribute name="selected"/>
								</xsl:if>
								<xsl:value-of select="/root/gui/strings/any"/>
							</option>
							<xsl:for-each select="/root/gui/groups/record">
								<xsl:sort order="ascending" select="name"/>
								<option value="{id}">
									<!-- after a search, many groups are defined in 
									searchDefaults (FIXME ?) and the last group in group list
									was selected by default even if none was
									used in last search. Only set selected one when only one is define in searchDefaults. -->
									<xsl:if test="id=/root/gui/searchDefaults/group and count(/root/gui/searchDefaults/group)=1">
										<xsl:attribute name="selected"/>
									</xsl:if>
									<xsl:value-of select="name"/>
								</option>
							</xsl:for-each>
						</select>
					</div>
				</xsl:if>
					
				<!-- Template -->
				<xsl:if test="string(/root/gui/session/userId)!='' and java:isAccessibleService('metadata.edit')">
					<div class="row">
						<span class="labelField"><xsl:value-of select="/root/gui/strings/kind"/></span>
						
						<select class="content" id="template" name="template" size="1">
							<option value="n">
								<xsl:if test="/root/gui/searchDefaults/template='n'">
									<xsl:attribute name="selected">true</xsl:attribute>
								</xsl:if>
								<xsl:value-of select="/root/gui/strings/metadata"/>
							</option>
							<option value="y">
								<xsl:if test="/root/gui/searchDefaults/template='y'">
									<xsl:attribute name="selected">true</xsl:attribute>
								</xsl:if>
								<xsl:value-of select="/root/gui/strings/template"/>
							</option>
							<!-- <option value="s">
								<xsl:if test="/root/gui/searchDefaults/template='s'">
									<xsl:attribute name="selected">true</xsl:attribute>
								</xsl:if>
								<xsl:value-of select="/root/gui/strings/subtemplate"/>
							</option> -->
						</select>
					</div>
				</xsl:if>
					
				<!-- Category -->
				<xsl:if test="/root/gui/config/category/admin">
					<div class="row">
						<span class="labelField"><xsl:value-of select="/root/gui/strings/category"/></span>
						
						<select class="content" name="category" id="category">
							<option value="">
								<xsl:if test="/root/gui/searchDefaults/category=''">
									<xsl:attribute name="selected"/>
								</xsl:if>
								<xsl:value-of select="/root/gui/strings/any"/>
							</option>
							
							<xsl:for-each select="/root/gui/categories/record">
								<xsl:sort select="label/child::*[name() = $mylang]" order="ascending"/>
								
								<option value="{name}">
									<xsl:if test="name = /root/gui/searchDefaults/category">
										<xsl:attribute name="selected"/>
									</xsl:if>
									<xsl:value-of select="label/child::*[name() = $mylang]"/>
								</option>
							</xsl:for-each>
						</select>
					</div>					
				</xsl:if>				

				<!-- Status -->
				<div class="row">
					<span class="labelField"><xsl:value-of select="/root/gui/strings/status"/></span>
						
					<select class="content" name="_status" id="_status">
						<option value="">
							<xsl:if test="/root/gui/searchDefaults/_status=''">
								<xsl:attribute name="selected"/>
							</xsl:if>
							<xsl:value-of select="/root/gui/strings/any"/>
						</option>
						
						<xsl:for-each select="/root/gui/status/statusvalues/status">
							<xsl:sort select="label/child::*[name() = $mylang]" order="ascending"/>
							
							<option value="{@id}">
								<xsl:if test="@id = /root/gui/searchDefaults/_status">
									<xsl:attribute name="selected"/>
								</xsl:if>
								<xsl:value-of select="label/child::*[name() = $mylang]"/>
							</option>
						</xsl:for-each>
					</select>
				</div>					

			</div>
			
	 </div>
	</form>					
</xsl:template>

	<!-- ============================================================ 
		WHAT
	======================================= ===================== -->
	
<xsl:template name="adv_what_geodata">
	<h1 style="margin-bottom:5px"><xsl:value-of select="/root/gui/strings/what"/></h1>

  <div class="row">  <!-- div row-->
    <table style="border-color:#2a628f;border-style:solid;margin:5px;margin-left:10px">
      <tr>
        <td>
          <input type="checkbox" id="metadataType_dataset" class="content" value="dataset" onclick="metadataType_updateUI(this);" /><label for="metadataType_dataset">Metadata for data set</label>
        </td>
        <td>
          <input type="checkbox" id="metadataType_service" class="content"  value="service" onclick="metadataType_updateUI(this);" /><label for="metadataType_service">Metadata for data services</label>
        </td>
      </tr>
      <tr>
        <td>
          <input type="checkbox" id="metadataType_all" class="content" value="" onclick="metadataType_updateUI(this);" /><label for="metadataType_all">All metadata</label>
        </td>
        <td>
          <input type="checkbox" id="metadataType_iro" class="content" value="iro" onclick="metadataType_updateUI(this);" /><label for="metadataType_iro">Metadata for international reporting obligations</label>
        </td>
      </tr>
    </table>

    <input type="hidden" id="geodata_type" name="geodata_type" value="" />

  </div>

  <div class="row">  <!-- div row-->
    &#160;
  </div>

  <!-- Any Of The Words -->
	<div class="row">  <!-- div row-->
		<span class="labelField"><xsl:value-of select="/root/gui/strings/anyWith"/></span>
		<input name="or" id="orGeodata" class="content" size="31" value=""/>
	  <a href="#" onclick="toggleMoreFields('Geodata')" style="margin-left:2px"><img id="i_morefieldsGeodata" width="9px" height="9px" src="{/root/gui/url}/images/plus.gif" title="{/root/gui/strings/showMoreSearchFields}" alt="{/root/gui/strings/showMoreSearchFields}"/></a>
	</div>
	
	<!-- Exact Phrase -->
    <div class="row" id="phrase_search_rowGeodata" style="display:none">  <!-- div row-->
		<span class="labelField"><xsl:value-of select="/root/gui/strings/anyWithExactPhrase"/></span>
		<input name="phrase" id="phraseGeodata" class="content" size="31" value=""/>
	</div>
	
	<!-- All Text -->
    <div class="row" id="all_search_rowGeodata" style="display:none">  <!-- div row-->
		<span class="labelField"><xsl:value-of select="/root/gui/strings/anyWithAllWords"/></span>
		<input name="all" id="allGeodata" class="content" size="31" value=""/>
	</div>
	
	<!-- Without Words -->
	<div class="row" id="without_search_rowGeodata" style="display:none">  <!-- div row-->
		<span class="labelField"><xsl:value-of select="/root/gui/strings/anyWithoutWords"/></span>
		<input name="without" id="withoutGeodata" class="content" size="31" value=""/>
	</div>
	
	<!-- Title -->	
	<div class="row">  <!-- div row-->
		<span class="labelField"><xsl:value-of select="/root/gui/strings/rtitle"/></span>
		<span title="{/root/gui/strings/searchhelp/rtitle}">
			<input name="title" id="titleGeodata" class="content"  size="31" value="{/root/gui/searchDefaults/title}"/>
		</span>
			<div id="titleList" class="keywordList">
				<!-- the titleList for autocompletion will show here -->
			</div>
	</div>
	
	<!-- Abstract -->	
	<div class="row">  <!-- div row-->
		<span class="labelField"><xsl:value-of select="/root/gui/strings/abstract"/></span>
		<span title="{/root/gui/strings/searchhelp/abstract}">
			<input name="abstract" id="abstractGeodata" class="content"  size="31" value="{/root/gui/searchDefaults/abstract}"/>
		</span>
	</div>

	<!-- Keywords -->	
	<div class="row">  <!-- div row-->
		<span class="labelField"><xsl:value-of select="/root/gui/strings/keywords"/></span>
		<span title="{/root/gui/strings/searchhelp/keywords}">
      <input id="themekey" name="themekey" onClick="popSelector(this,'keywordSelectorFrame','keywordSelector','portal.search.keywords?mode=selector&amp;keyword','themekey');" class="content" size="31" value="{/root/gui/searchDefaults/themekey}"/>
		</span>

		<xsl:if test="/root/gui/config/search/keyword-selection-panel">
			<a style="cursor:pointer;" onclick="javascript:showSearchKeywordSelectionPanel();">
				<img src="{/root/gui/url}/images/find.png" alt="{/root/gui/strings/searchhelp/thesaurus}" title="{/root/gui/strings/searchhelp/thesaurus}"/>
			</a>
		</xsl:if>
		
		<div id="keywordSelectorFrame" class="keywordSelectorFrame" style="display:none;z-index:1000;">
			<div id="keywordSelector" class="keywordSelector"/>
		</div>
		
		<div id="keywordList" class="keywordList"/>
	</div>
</xsl:template>

<!-- CONTACT -->
<xsl:template name="adv_contact_geodata">
  <div id="contact_container">
    <h1 style="margin-top:5px;margin-bottom:5px">
      <a href="#" onclick="toggleSearchSection('contact')" style="margin-right:2px">
        <img id="i_contact" width="9px" height="9px" src="{/root/gui/url}/images/plus.gif" alt=""/>
      </a>
      <xsl:value-of select="/root/gui/strings//contact"/>Contact
    </h1>

    <div id="contactsearchfields" style="display:none">
      <div class="row">  <!-- div row-->
        <table style="border-color:#2a628f;border-style:solid;">
          <tr>
            <td>
              <input type="radio" name="resposible" id="resposible_person" class="content" value="" checked="checked"/><label for="resposible_person">Responsible (person)</label>
            </td>
            <td>
              <input type="radio" name="resposible" id="resposible_department" class="content" value="" /><label for="resposible_department">Responsible (department)</label>
            </td>
          </tr>

        </table>
      </div>

      <!-- Role -->
      <div class="row">  <!-- div row-->
        <label for="contact-role"><xsl:value-of select="/root/gui/strings/role"/>Role</label>
        <br />
        <select id="contact-role" title="Select the contact role" onchange="updateContactsGeodata()" style="width:250px">
          <option value="" selected="selected"></option>
          <xsl:for-each select="/root/gui/schemas/iso19139/codelists/codelist[@name='gmd:CI_RoleCode']/entry">
          <xsl:sort select="label" />
          <option value="{code}">
            <xsl:value-of select="label" /></option>
        </xsl:for-each>
        </select>
      </div>

      <!-- Name -->
      <div class="row">  <!-- div row-->
        <label for="organisationRole"><xsl:value-of select="/root/gui/strings/role"/>Name</label>
        <br />
        <!--<input type="text" id="organisation" size="31" class="content" value="" />
        <div id="contactList" class="autocomplete"></div>-->
        <select id="organisation" title="Select the organisation" style="width:250px"></select>

        <input type="hidden" name="organisationRole" id="organisationRole" value="" />
      </div>

    </div>
  </div>
</xsl:template>

	<!-- ============================================================ 
		WHEN
	============================================================= -->

<xsl:template name="adv_when_geodata">
  <div id="whengeodata_container">
    <h1 style="margin-top:5px;margin-bottom:5px">
      <a href="#" onclick="toggleSearchSection('whengeodata')" style="margin-right:2px">
        <img id="i_whengeodata" width="9px" height="9px" src="{/root/gui/url}/images/plus.gif" alt=""/>
      </a>
      <xsl:value-of select="/root/gui/strings//when"/>
    </h1>

    <div id="whengeodatasearchfields" style="display:none">
      <div class="row">
        <input onclick="setDatesGeodata(0);" value="" name="radfrom" id="radfrom0_geodata" type="radio">
            <xsl:if test="string(/root/gui/searchDefaults/dateFrom)='' and string(/root/gui/searchDefaults/dateTo)=''
                and string(/root/gui/searchDefaults/extFrom)='' and string(/root/gui/searchDefaults/extTo)=''">
              <xsl:attribute name="checked">CHECKED</xsl:attribute>
            </xsl:if>
            <label for="radfrom0"><xsl:value-of select="/root/gui/strings/anytime"/></label>
        </input>
      </div>

      <!-- Metadata change date -->
      <div class="row">
        <input value="" name="radfrom" id="radfrom1_geodata" type="radio" disabled="disabled">
            <xsl:if test="string(/root/gui/searchDefaults/dateFrom)!='' and string(/root/gui/searchDefaults/dateTo)!=''">
              <xsl:attribute name="checked">CHECKED</xsl:attribute>
            </xsl:if>
            <label for="radfrom1"><xsl:value-of select="/root/gui/strings/changeDate"/></label>
        </input>
      </div>

          <!-- Change format to %Y-%m-%dT%H:%M:00 in order to have DateTime field instead of DateField -->
        <table>
            <tr>
                <td><xsl:value-of select="/root/gui/strings/from"/></td>
                <td>
                  <div class="cal" id="dateFromGeodata" onclick="updateDateFilterPanels('radfrom1_geodata')"></div>
                  <input type="hidden" id="dateFromGeodata_format" value="%Y-%m-%d"/>
                  <input type="hidden" id="dateFromGeodata_cal" value=""/>
                </td>
            </tr>
            <tr>
                <td><xsl:value-of select="/root/gui/strings/to"/></td>
                <td>
                <div class="cal" id="dateToGeodata" onclick="updateDateFilterPanels('radfrom1_geodata')"></div>
                  <input type="hidden" id="dateToGeodata_format" value="%Y-%m-%d"/>
                  <input type="hidden" id="dateToGeodata_cal" value=""/>
                </td>
            </tr>
        </table>

      <!-- Metadata dates -->
      <div class="row">
        <input value="" name="radfrom" id="radfrommd1_geodata" type="radio" disabled="disabled">
          <xsl:if test="string(/root/gui/searchDefaults/dateFrom)!='' and string(/root/gui/searchDefaults/dateTo)!=''">
            <xsl:attribute name="checked">CHECKED</xsl:attribute>
          </xsl:if>
          <label for="radfrommd1_geodata"><xsl:value-of select="/root/gui/strings/changeDate111"/>Metadata date</label>
        </input>
      </div>

      <!-- Change format to %Y-%m-%dT%H:%M:00 in order to have DateTime field instead of DateField -->
      <table>
        <tr>
          <td><xsl:value-of select="/root/gui/strings/from1"/>Type</td>
          <td>
            <select id="dateType" title="Select the date type" onclick="updateDateFilterPanels('radfrommd1_geodata')">
              <xsl:for-each select="/root/gui/schemas/iso19139/codelists/codelist[@name='gmd:CI_DateTypeCode']/entry">
                <xsl:sort select="label" />
                <option value="{code}">
                  <xsl:value-of select="label" /></option>
              </xsl:for-each>
            </select>
          </td>
        </tr>
        <tr>
          <td><xsl:value-of select="/root/gui/strings/from"/></td>
          <td>
            <div class="cal" id="dateMdFromGeodata" onclick="updateDateFilterPanels('radfrommd1_geodata')"></div>
            <input type="hidden" id="dateMdFromGeodata_format" value="%Y-%m-%d"/>
            <input type="hidden" id="dateMdFromGeodata_cal" value=""/>
          </td>
        </tr>
        <tr>
          <td><xsl:value-of select="/root/gui/strings/to"/></td>
          <td>
            <div class="cal" id="dateMdToGeodata" onclick="updateDateFilterPanels('radfrommd1_geodata')"></div>
            <input type="hidden" id="dateMdToGeodata_format" value="%Y-%m-%d"/>
            <input type="hidden" id="dateMdToGeodata_cal" value=""/>
          </td>
        </tr>
      </table>

      <!-- IRO deadline -->
      <div class="row">
        <input value="" name="radfrom" id="radfromiro1_geodata" type="radio" disabled="disabled">
          <xsl:if test="string(/root/gui/searchDefaults/extFrom)!='' and string(/root/gui/searchDefaults/extTo)!=''">
            <xsl:attribute name="checked" />
          </xsl:if>
          <label for="radfromiro1_geodata"><xsl:value-of select="/root/gui/strings/datasetIssued111"/>IRO deadline</label>
        </input>
      </div>

      <!-- Change format to %Y-%m-%dT%H:%M:00 in order to have DateTime field instead of DateField -->
      <table>
        <tr>
          <td><xsl:value-of select="/root/gui/strings/from"/></td>
          <td>
            <div class="cal" id="iroDateFrom" onclick="updateDateFilterPanels('radfromiro1_geodata')"></div>
            <input type="hidden" id="iroDateFrom_format" value="%Y-%m-%d"/>
            <input type="hidden" id="iroDateFrom_cal" value=""/>
          </td>
        </tr>
        <tr>
          <td><xsl:value-of select="/root/gui/strings/to"/></td>
          <td>
            <div class="cal" id="iroDateTo" onclick="updateDateFilterPanels('radfromiro1_geodata')"></div>
            <input type="hidden" id="iroDateTo_format" value="%Y-%m-%d"/>
            <input type="hidden" id="iroDateTo_cal" value=""/>
          </td>
        </tr>
      </table>

      <!-- Temporal extent -->
      <div class="row">
        <input value="" name="radfrom" id="radfromext1_geodata" type="radio" disabled="disabled">
            <xsl:if test="string(/root/gui/searchDefaults/extFrom)!='' and string(/root/gui/searchDefaults/extTo)!=''">
              <xsl:attribute name="checked" />
            </xsl:if>
            <label for="radfromext1_geodata"><xsl:value-of select="/root/gui/strings/datasetIssued"/></label>
        </input>
      </div>

       <!-- Change format to %Y-%m-%dT%H:%M:00 in order to have DateTime field instead of DateField -->
            <table>
                <tr>
                    <td><xsl:value-of select="/root/gui/strings/from"/></td>
                    <td>
                      <div class="cal" id="extFromGeodata" onclick="updateDateFilterPanels('radfromext1_geodata')"></div>
                  <input type="hidden" id="extFromGeodata_format" value="%Y-%m-%d"/>
                  <input type="hidden" id="extFromGeodata_cal" value=""/>
                    </td>
                </tr>
                <tr>
                    <td><xsl:value-of select="/root/gui/strings/to"/></td>
                    <td>
                  <div class="cal" id="extToGeodata" onclick="updateDateFilterPanels('radfromext1_geodata')"></div>
                  <input type="hidden" id="extToGeodata_format" value="%Y-%m-%d"/>
                  <input type="hidden" id="extToGeodata_cal" value=""/>
                    </td>
                </tr>
            </table>


    </div>

  </div>
	<!-- restrict to - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	
	<!-- now make sure we open expanded if any restrictions are selected -->
	<xsl:if test="/root/gui/searchDefaults/siteId!='' or
				  /root/gui/searchDefaults/groups/group!='' or
				  /root/gui/searchDefaults/ownergroups='on' or
	              /root/gui/searchDefaults/owner='on' or
	              /root/gui/searchDefaults/notgroups='on' or
 				  ( /root/gui/searchDefaults/template!='' and /root/gui/searchDefaults/template!='n' ) or
				  /root/gui/searchDefaults/category!=''">
		<script type="text/javascript">
			showFields('restrictions.img','restrictions.table');
		</script>
	</xsl:if>

	<!-- options - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	
	<!-- now make sure we open expanded if any options are selected -->
	<xsl:if test="/root/gui/searchDefaults/sortBy!='relevance' or
				  /root/gui/searchDefaults/hitsPerPage!='10' or
				  /root/gui/searchDefaults/output!='full'">
		<script type="text/javascript">
			showFields('advoptions.img','advoptions.fieldset');
		</script>
	</xsl:if>
</xsl:template>

</xsl:stylesheet>
