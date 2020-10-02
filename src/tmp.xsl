<?xml version="1.0" encoding="ISO-8859-1" ?>

<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:php="http://php.net/xsl" 
    xsl:extension-element-prefixes="php" 
    exclude-result-prefixes="php"
    >
    

	<xsl:template name='data-field'>
		<xsl:param name='iDataTypes'/>
		<xsl:param name='F'/>
		<xsl:param name='ZName'/>
		<xsl:param name='FormZMode'/>
		<xsl:param name='ZMode'/>
		<xsl:param name='FID'/>
		<xsl:param name='datatype'/>
		<xsl:param name='name'/>
		<xsl:param name='value'/>
		<xsl:param name='source'/>
		<xsl:param name='isMultiple'/>
		<xsl:param name='validation' />
		<xsl:param name='remote' />

		<xsl:variable name='display' select='php:functionString("zobject_access::check_field", string($ZName), string($FID), string($ZMode))'/>
        <xsl:variable name='HType'>
            <xsl:choose>
                <xsl:when test='string($iDataTypes/*/typedef[@name=$datatype]/@html-type) != ""'><xsl:value-of select='string($iDataTypes/*/typedef[@name=$datatype]/@html-type)' /></xsl:when>
                <xsl:when test='string($datatype) != ""'><xsl:value-of select='string($datatype)' /></xsl:when>
                <xsl:otherwise>text</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

		<xsl:variable name='nValue'><xsl:value-of select='php:function("zobject_format::FormatDataField", string($value), string($datatype))'/></xsl:variable>

        <xsl:if test='php:function("zobject::DEBUG_TRANSFORM_DATA_FIELD")'>
            <table class='DEBUG'>
                <tr><td colspan='2' class='title'>DATAINPUT.XSL - data-field</td></tr>
                <tr><th>Var</th><th>Val</th></tr>
                <tr><td>ZName</td><td><xsl:value-of select='$ZName'/></td></tr>
                <tr><td>ZMode</td><td><xsl:value-of select='$ZMode'/></td></tr>
                <tr><td>FID</td><td><xsl:value-of select='$FID'/></td></tr>
                <tr><td>datatype</td><td><xsl:value-of select='$datatype'/></td></tr>
                <tr><td>ZM:Form/Field</td><td><xsl:value-of select='$FormZMode'/>..<xsl:value-of select='$ZMode'/></td></tr>
                <tr><td>HType</td><td><xsl:value-of select='$HType'/></td></tr>
                <tr><td>name</td><td><xsl:value-of select='$name'/></td></tr>
                <tr><td>value</td><td><xsl:copy-of select='$value'/></td></tr>
                <tr><td>source</td><td><xsl:value-of select='$source'/></td></tr>
                <tr><td>isMultiple</td><td><xsl:value-of select='$isMultiple'/></td></tr>
                <tr><td>nValue</td><td><xsl:value-of disable-output-escaping='yes' select='$nValue'/></td></tr>
                <tr><td>validation</td><td><xsl:value-of select='$validation'/></td></tr>
                <tr><td>remote</td><td><xsl:value-of select='$remote'/></td></tr>
            </table>
        </xsl:if>
		
		<xsl:choose>
			<xsl:when test='$isMultiple'>
				<xsl:variable name='vlist' select='php:function("DisplayMultiValue_List", $nValue)'/>
				<xsl:choose>
					<xsl:when test='$display="hidden"'>
						<xsl:for-each select='$vlist/*/item'>
							<input>
								<xsl:attribute name="type">hidden</xsl:attribute>
								<xsl:attribute name="name"><xsl:value-of select="concat($name,'___',@n)" /></xsl:attribute>
								<xsl:attribute name="value"><xsl:value-of select="$nValue" /></xsl:attribute>
							</input>
						</xsl:for-each>
					</xsl:when>
					<xsl:when test='$display="edit" or $display="list-create"'>
						<ul>
							<xsl:for-each select='$vlist/*/item'>
								<li>
									<xsl:call-template name='data-input'>
										<xsl:with-param name='iDataTypes' select='$iDataTypes'/>
										<xsl:with-param name='F'          select='$F'/>
										<xsl:with-param name='name'       select='concat($name,"___",@n)' />
										<xsl:with-param name='datatype'   select='$datatype' />
										<xsl:with-param name='value'      select='.' />
										<xsl:with-param name='source'     select='$source' />
										<xsl:with-param name='isMultiple' select='false()' />
										<xsl:with-param name='validation' select='$validation' />
										<xsl:with-param name='remote' select='$remote' />
									</xsl:call-template>
								</li>
							</xsl:for-each>
							<xsl:variable name='AddID' select='concat($name, "___ADD")'/>
							<li style="display:none">
								<xsl:attribute name="id"><xsl:value-of select='$AddID'/></xsl:attribute>
								<xsl:call-template name='data-input'>
									<xsl:with-param name='iDataTypes' select='$iDataTypes'/>
									<xsl:with-param name='F'          select='$F'/>
									<xsl:with-param name='name'       select='concat($name,"___",string(number($vlist/list/@count)+1))' />
									<xsl:with-param name='datatype'   select='$datatype' />
									<xsl:with-param name='value'      select='.' />
									<xsl:with-param name='source'     select='$source' />
									<xsl:with-param name='isMultiple' select='false()' />
									<xsl:with-param name='validation' select='$validation' />
									<xsl:with-param name='remote' select='$remote' />
								</xsl:call-template>
							</li>
							
							<xsl:variable name='AddLinkID' select='concat($name, "___ADDLINK")'/>
							<li style="display:ok">
								<xsl:attribute name="id"><xsl:value-of select='$AddLinkID'/></xsl:attribute>
								<span style='color:blue;cursor:pointer;font: bold 12 arial;'><xsl:attribute name='onclick'><xsl:value-of select='php:functionString("MultiAddLink",$AddID,$AddLinkID)'/></xsl:attribute>Add</span>
							</li>
						</ul>
					</xsl:when>
					<xsl:otherwise>
						<ul>
							<xsl:for-each select='$vlist/*/item'>
								<li><xsl:copy-of select='.'/></li>
							</xsl:for-each>
						</ul>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test='$display="hidden"'>
				<input>
					<xsl:attribute name="type">hidden</xsl:attribute>
					<xsl:attribute name="name"><xsl:value-of select="$name" /></xsl:attribute>
					<xsl:attribute name="value"><xsl:value-of select="$nValue" /></xsl:attribute>
				</input>
			</xsl:when>
			<xsl:when test='$display="edit" or $display="create" or $display="list-create"'>
				<xsl:call-template name='data-input'>
					<xsl:with-param name='iDataTypes' select='$iDataTypes'/>
					<xsl:with-param name='F'          select='$F'/>
					<xsl:with-param name='name'       select='$name' />
					<xsl:with-param name='datatype'   select='$datatype' />
					<xsl:with-param name='value'      select='$nValue' />
					<xsl:with-param name='source'     select='$source' />
					<xsl:with-param name='isMultiple' select='$isMultiple' />
					<xsl:with-param name='validation' select='$validation' />
					<xsl:with-param name='remote' select='$remote' />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test='$FormZMode="edit" or $FormZMode="create"'>
					<input type='hidden'>
						<xsl:attribute name='name'><xsl:value-of select='$name'/></xsl:attribute>
						<xsl:attribute name='value'><xsl:value-of select='$nValue'/></xsl:attribute>
					</input>
				</xsl:if>
				<xsl:variable name='match'>
					<xsl:if test='$HType="combobox"'>0</xsl:if>
					<xsl:if test='$HType!="combobox"'>1</xsl:if>
				</xsl:variable>
				<xsl:variable name='dispval'>
					<xsl:choose>
						<xsl:when test='$HType="combobox" or $HType="listbox"'>
							<xsl:value-of select='php:functionString("SelectOptionListDisplayText", $source, $nValue, $match)' />
						</xsl:when>
						<xsl:otherwise><xsl:copy-of select='$nValue' /></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name='pval' select='php:functionString("zobject_format::PrettyValue", $dispval)'/>
				<xsl:choose>
					<xsl:when test='0!=string-length($iDataTypes/*/*/typedef[@name=$datatype]/@output-html)'>
						<xsl:copy-of disable-output-escaping='no' select='php:function("xml_file::toDocEl", $dispval)' />
					</xsl:when>
					<xsl:when test='0!=string-length($iDataTypes/*/*/typedef[@name=$datatype]/@output-escape)'>
						[<xsl:value-of disable-output-escaping='yes' select='$pval' />]
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of disable-output-escaping='no' select='$pval' />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>


	<xsl:template name='data-input'>
		<xsl:param name='iDataTypes'/>
		<xsl:param name='F'         />
		<xsl:param name='name'      />
		<xsl:param name='datatype'  />
		<xsl:param name='value'     />
		<xsl:param name='source'    />
		<xsl:param name='isMultiple'/>
		<xsl:param name='validation'/>
		<xsl:param name='remote'/>
		
<xsl:if test='php:function("zobject::DEBUG_TRANSFORM_DATA_INPUT")'>
	<table class='DEBUG'>
		<tr><td colspan='2' class='title'>DATAINPUT.XSL - data-input</td></tr>
		<tr><th>Variable</th><th>Value</th></tr>
		<tr><td>name</td><td><xsl:value-of select='$name' /></td></tr>
		<tr><td>datatype</td><td><xsl:value-of select='$datatype' /></td></tr>
		<tr><td>value</td><td><xsl:value-of select='$value' /></td></tr>
		<tr><td>source</td><td><xsl:value-of select='$source' /></td></tr>
		<tr><td>isMultiple</td><td><xsl:value-of select='$isMultiple' /></td></tr>
		<tr><td>validation</td><td><xsl:value-of select='$validation' /></td></tr>
		<tr><td>remote</td><td><xsl:value-of select='$remote' /></td></tr>
	</table>
</xsl:if>
		<xsl:variable name='DTDef' select='$iDataTypes/*/typedef[@name=$datatype]'/>
        <xsl:variable name='HType'>
            <xsl:choose>
                <xsl:when test='string($DTDef/@html-type)!=""'><xsl:value-of select='string($DTDef/@html-type)' /></xsl:when>
                <xsl:when test='string($datatype)!=""'><xsl:value-of select='string($datatype)' /></xsl:when>
                <xsl:otherwise>text</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
		<xsl:choose>
			<xsl:when test='$HType="select" or $HType="multi-select"'>
				<select>
					<xsl:attribute name='name'><xsl:value-of select='$name'/><xsl:if test='$HType="multi-select"'>[]</xsl:if></xsl:attribute>
					<xsl:attribute name='id'><xsl:value-of select='$name'/></xsl:attribute>
					<xsl:attribute name='class'><xsl:value-of select='$validation'/></xsl:attribute>
					<xsl:if test='string-length($remote)!=0'><xsl:attribute name='remote'><xsl:value-of select='$remote'/></xsl:attribute></xsl:if>
					<xsl:if test='number($DTDef/@size)>0'><xsl:attribute name='size'><xsl:value-of select='$DTDef/@size'/></xsl:attribute></xsl:if>
					<xsl:if test='$HType="multi-select"'><xsl:attribute name='multiple'>1</xsl:attribute></xsl:if>
					<xsl:for-each select='$F/@*'>
						<xsl:choose>
							<xsl:when test='name()="datatype"'></xsl:when>
							<xsl:otherwise><xsl:copy-of select='.' /></xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
					<xsl:if test='string-length($source)!=0'>
						<xsl:variable name='ol' select='php:function("SelectOptionList", string($source))'/>
					    <xsl:for-each select='$ol/*/option'>
							<option>
								<xsl:if test='string-length(@label)>0'><xsl:attribute name='label'><xsl:value-of select='@label'/></xsl:attribute></xsl:if>
								<xsl:if test='string-length(@value)>0'><xsl:attribute name='value'><xsl:value-of select='@value'/></xsl:attribute></xsl:if>
								<xsl:if test='$value=text() or contains($value,text())'><xsl:attribute name='selected'><xsl:value-of select='1'/></xsl:attribute></xsl:if>
								<xsl:copy-of select='text()' />
							</option>
						</xsl:for-each>
					</xsl:if>
					
					<xsl:if test='string-length($source)=0'>
					<xsl:for-each select='$DTDef/option'>
						<option>
							<xsl:if test='string-length(@label)>0'><xsl:attribute name='label'><xsl:value-of select='@label'/></xsl:attribute></xsl:if>
							<xsl:if test='string-length(@value)>0'><xsl:attribute name='value'><xsl:value-of select='@value'/></xsl:attribute></xsl:if>
							<xsl:if test='$value=text() or contains($value,text())'><xsl:attribute name='selected'><xsl:value-of select='1'/></xsl:attribute></xsl:if>
							<xsl:copy-of select='text()' />
						</option>
					</xsl:for-each>
					</xsl:if>
				</select>
			</xsl:when>
			<xsl:when test='$HType="combobox"'>
				<xsl:variable name='CBTxtID' select='concat($name,"TXT")'/>
				<xsl:variable name='CBTxtNM' select='concat($name,"TXT")'/>
				<xsl:variable name='CBHidID' select='concat($name,"HID")'/>
				<xsl:variable name='CBDivID' select='concat($name,"DIV")'/>
				<xsl:variable name='CBSelID' select='concat($name,"SEL")'/>
				<xsl:variable name='SQ' select='php:functionString("SingleQuoteChar")'/>
				<xsl:variable name='size'>
                    <xsl:choose>
                        <xsl:when test='string(@size)!=""'><xsl:value-of select='string(@size)' /></xsl:when>
                        <xsl:when test='string($DEFS/*/zobjectdef[@name=$ZName]/fielddefs/fielddef[@id=$name]/@size)!=""'><xsl:value-of select='string($DEFS/*/zobjectdef[@name=$ZName]/fielddefs/fielddef[@id=$name]/@size)' /></xsl:when>
                        <xsl:when test='string($DTDef/@size)!=""'><xsl:value-of select='string($DTDef/@size)' /></xsl:when>
                        <xsl:otherwise>20</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
				<xsl:variable name='dispval' select='php:functionString("SelectOptionListDisplayText", $source, $value)'/>

				<input type='text' class='combo-text {$validation}'>
					<xsl:attribute name='name'><xsl:value-of select='$CBTxtNM'/></xsl:attribute>
					<xsl:attribute name='id'><xsl:value-of select='$CBTxtID'/></xsl:attribute>
					<xsl:if test='string-length($remote)!=0'><xsl:attribute name='remote'><xsl:value-of select='$remote'/></xsl:attribute></xsl:if>
					<xsl:if test='number($size)>0'><xsl:attribute name='size'><xsl:value-of select='$size'/></xsl:attribute></xsl:if>
					<xsl:attribute name='value'><xsl:value-of select='$dispval' /></xsl:attribute>
					<xsl:attribute name='onChange'><xsl:value-of select='concat("javascript:document.getElementById(",$SQ,$CBHidID,$SQ,").value=this.value;")'/></xsl:attribute>
				</input>
				<input type='hidden'>
					<xsl:attribute name='name'><xsl:value-of select='$name'/></xsl:attribute>
					<xsl:attribute name='id'><xsl:value-of select='$CBHidID'/></xsl:attribute>
					<xsl:attribute name='value'><xsl:value-of select='$value' /></xsl:attribute>
				</input>
				<input type="button" class='combo-button {$validation}' hidefocus="1" value="&#9660;">
					<xsl:attribute name='onclick'><xsl:value-of select='concat("javascript:menuActivate(",$SQ,$CBTxtID,$SQ,",",$SQ,$CBDivID,$SQ,",",$SQ,$CBSelID,$SQ,");")'/></xsl:attribute>
				</input>
				
				<div id="combodiv" class='combo-div {$validation}' style='display:none;'>
					<xsl:attribute name="id"><xsl:value-of select='$CBDivID'/></xsl:attribute>
					<xsl:attribute name='onmouseover'><xsl:value-of select='concat("javascript:oOverMenu=",$SQ,$CBDivID,$SQ,";")'/></xsl:attribute>
					<xsl:attribute name='onmouseout'><xsl:value-of select='"javascript:oOverMenu=false;"'/></xsl:attribute>
					<select id="combosel" class="combo-select" size="8">
						<xsl:attribute name="id"><xsl:value-of select='$CBSelID'/></xsl:attribute>
						<xsl:attribute name='onclick'><xsl:value-of select="concat('javaScript:textSet(',$SQ,$name,$SQ,',this);')"/></xsl:attribute>
						<xsl:attribute name='onkeypress'><xsl:value-of select="concat('javaScript:comboKey(',$SQ,$name,$SQ,',this);')"/></xsl:attribute>
						<xsl:for-each select='$F/@*'>
							<xsl:choose>
								<xsl:when test='name()="datatype"'></xsl:when>
								<xsl:otherwise><xsl:copy-of select='.' /></xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>

						<xsl:if test='string-length($source)!=0'>
							<xsl:variable name='ol' select='php:function("SelectOptionList", string($source))'/>
						    <xsl:for-each select='$ol/*/option'>
								<option class="comboopt">
									<xsl:if test='string-length(@label)>0'><xsl:attribute name='label'><xsl:value-of select='@label'/></xsl:attribute></xsl:if>
									<xsl:if test='string-length(@value)>0'><xsl:attribute name='value'><xsl:value-of select='@value'/></xsl:attribute></xsl:if>
									<xsl:if test='$value=text() or contains($value,text())'><xsl:attribute name='selected'><xsl:value-of select='1'/></xsl:attribute></xsl:if>
									<xsl:copy-of select='text()' />
								</option>
							</xsl:for-each>
						</xsl:if>
						
					</select>
				</div>
			</xsl:when>
			<xsl:when test='$HType="checklist"'>
				<xsl:variable name='SQ' select='php:functionString("SingleQuoteChar")'/>
				<xsl:variable name='B_' select='concat($SQ,"[",$SQ)'/>
				<xsl:variable name='_B' select='concat($SQ,"]",$SQ)'/>
                <xsl:variable name='pHg'>
                    <xsl:choose>
                        <xsl:when test='string-length(@size)!=0'><xsl:value-of select='string(@size)' /></xsl:when>
                        <xsl:otherwise>5</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
				<xsl:variable name='Hg' select='number($pHg) * 20'/>
                <xsl:variable name='Wd'>
                    <xsl:choose>
                        <xsl:when test='string-length(@width)!=0'><xsl:value-of select='string(@width)' /></xsl:when>
                        <xsl:otherwise>250</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
				<xsl:variable name='id' select='php:functionString("zobject::new_jsid")'/>
				<xsl:variable name='script' select='concat("r=",$B_,"+this.value+",$_B,";f=document.getElementById(",$SQ,$id,$SQ,");f.value=(!this.checked?f.value.replace(r,",$SQ,$SQ,"):f.value+r);")'/>
				
				<xsl:variable name='Wdg' select='concat($Wd,"px")'/>
				<xsl:variable name='Hgg' select='concat($Hg,"px")'/>
				
				<input type='hidden'>
					<xsl:attribute name="id"><xsl:value-of select='$id'/></xsl:attribute>
					<xsl:attribute name="name"><xsl:value-of select='$name'/></xsl:attribute>
					<xsl:attribute name="value"><xsl:value-of select='$value'/></xsl:attribute>
					<xsl:attribute name="class"><xsl:value-of select='$validation'/></xsl:attribute>
					<xsl:if test='string-length($remote)!=0'><xsl:attribute name='remote'><xsl:value-of select='$remote'/></xsl:attribute></xsl:if>
				</input>

				<div id="checklistdiv" class="checklist-div {$validation}" style="height:{$Hgg};width:{$Wdg};">
					<xsl:if test='string-length($source)!=0'>
						<xsl:variable name='ol' select='php:function("SelectOptionList", string($source))'/>
						<xsl:for-each select='$ol/*/option'>
							<xsl:variable name='oid' select='php:functionString("NewJSID")'/>
							<xsl:variable name='match' select='concat("[",text(),"]")'/>
							<input type='checkbox' class='checklist-checkbox {$validation}'>
								<xsl:attribute name="id"><xsl:value-of select='$oid'/></xsl:attribute>
								<xsl:attribute name="name"><xsl:value-of select='$oid'/></xsl:attribute>
								<xsl:attribute name="value"><xsl:value-of select='text()'/></xsl:attribute>
								<xsl:attribute name="onclick"><xsl:value-of select='$script'/></xsl:attribute>
								<xsl:if test='$value=$match or contains($value,$match)'><xsl:attribute name='checked'><xsl:value-of select='1'/></xsl:attribute></xsl:if>
								<xsl:for-each select='$F/@*'>
									<xsl:choose>
										<xsl:when test='name()="datatype"'></xsl:when>
										<xsl:otherwise><xsl:copy-of select='.' /></xsl:otherwise>
									</xsl:choose>
								</xsl:for-each>
							</input>
							<label>
								<xsl:attribute name='for'><xsl:value-of select='$oid'/></xsl:attribute>
								<xsl:copy-of select='text()' />
							</label>
							<br/>
						</xsl:for-each>
					</xsl:if>
				</div>
			</xsl:when>
			<xsl:when test='$HType="wysiwyg"'>
				<xsl:copy-of select='php:function("WYSIWYG",$name,$value)'/>
			</xsl:when>
			<xsl:when test='$HType="richtext" or $HType="rtf"'>
				<xsl:copy-of select='php:function("RTF",$name,$value)'/>
			</xsl:when>
			<xsl:when test='$HType="stringlist"'>
				<xsl:variable name='ol' select='php:function("SelectOptionList", string($source))'/>
				<xsl:for-each select='$ol/*/item'>
					<input>
						<xsl:attribute name="class"><xsl:value-of select='$validation'/></xsl:attribute>
						<xsl:if test='string-length($remote)!=0'><xsl:attribute name='remote'><xsl:value-of select='$remote'/></xsl:attribute></xsl:if>
						<xsl:if test='string-length(@label)>0'><xsl:attribute name='label'><xsl:value-of select='@label'/></xsl:attribute></xsl:if>
						<xsl:if test='string-length(@value)>0'><xsl:attribute name='value'><xsl:value-of select='@value'/></xsl:attribute></xsl:if>
						<xsl:if test='$value=text() or contains($value,text())'><xsl:attribute name='selected'><xsl:value-of select='1'/></xsl:attribute></xsl:if>
						<xsl:copy-of select='text()' />
					</input><br/>
				</xsl:for-each>
				<a href=''/>
			</xsl:when>
			<xsl:when test='$HType="yesno" or $HType="checkbox"'>
				<input>
					<xsl:attribute name="class"><xsl:value-of select='$validation'/></xsl:attribute>
					<xsl:attribute name='type'>checkbox</xsl:attribute>
					<xsl:attribute name='name'><xsl:value-of select='$name'/></xsl:attribute>
					<xsl:attribute name='id'><xsl:value-of select='$name'/></xsl:attribute>
					<xsl:attribute name='value'>Yes</xsl:attribute>
					<xsl:if test='string-length($remote)!=0'><xsl:attribute name='remote'><xsl:value-of select='$remote'/></xsl:attribute></xsl:if>
					<xsl:if test='string($value)!="" and string($value)!="No" and string($value)!="0"'>
						<xsl:attribute name='checked' select='1'/>
					</xsl:if>
					<xsl:for-each select='$F/@*'>
						<xsl:choose>
							<xsl:when test='name()="datatype"'></xsl:when>
							<xsl:otherwise><xsl:copy-of select='.' /></xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</input>
			</xsl:when>
			<xsl:when test='$HType="hidden"'>
				<input>
					<xsl:attribute name='type'>hidden</xsl:attribute>
					<xsl:attribute name='name'><xsl:value-of select='$name'/></xsl:attribute>
					<xsl:attribute name='id'><xsl:value-of select='$name'/></xsl:attribute>
					<xsl:attribute name='value'><xsl:value-of select='$value'/></xsl:attribute>
					<xsl:for-each select='$F/@*'>
						<xsl:choose>
							<xsl:when test='name()="datatype"'></xsl:when>
							<xsl:otherwise><xsl:copy-of select='.' /></xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</input>
			</xsl:when>
			<xsl:when test='$HType="password"'>
				<input>
					<xsl:attribute name="class"><xsl:value-of select='$validation'/></xsl:attribute>
					<xsl:attribute name='type'>password</xsl:attribute>
					<xsl:attribute name='name'><xsl:value-of select='$name' /></xsl:attribute>
					<xsl:attribute name='id'><xsl:value-of select='$name' /></xsl:attribute>
					<xsl:attribute name='value'><xsl:value-of select='$value' /></xsl:attribute>
					<xsl:if test='string-length($remote)!=0'><xsl:attribute name='remote'><xsl:value-of select='$remote'/></xsl:attribute></xsl:if>
					<xsl:if test='number($DTDef/@size) > 0'>
						<xsl:attribute name='size'><xsl:value-of select='$DTDef/@size'/></xsl:attribute>
					</xsl:if>
					<xsl:if test='number($DTDef/@maxlength) > 0'>
						<xsl:attribute name='maxlength'><xsl:value-of select='$DTDef/@maxlength'/></xsl:attribute>
					</xsl:if>
					<xsl:attribute name='size'><xsl:value-of select='$DTDef/@size'/></xsl:attribute>
					<xsl:for-each select='$F/@*'>
						<xsl:choose>
							<xsl:when test='name()="datatype"'></xsl:when>
							<xsl:otherwise><xsl:copy-of select='.' /></xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</input>
			</xsl:when>
			<xsl:when test='$HType="textarea"'>
				<textarea>
					<xsl:attribute name="class"><xsl:value-of select='$validation'/></xsl:attribute>
					<xsl:attribute name='name'><xsl:value-of select='$name' /></xsl:attribute>
					<xsl:attribute name='id'><xsl:value-of select='$name' /></xsl:attribute>
					<xsl:attribute name='rows'><xsl:value-of select='$DTDef/@rows' /></xsl:attribute>
					<xsl:attribute name='cols'><xsl:value-of select='$DTDef/@cols' /></xsl:attribute>
					<xsl:if test='string-length($remote)!=0'><xsl:attribute name='remote'><xsl:value-of select='$remote'/></xsl:attribute></xsl:if>
					<xsl:for-each select='$F/@*'>
						<xsl:choose>
							<xsl:when test='name()="datatype"'></xsl:when>
							<xsl:otherwise><xsl:copy-of select='.' /></xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
					<xsl:value-of select='php:functionString("PrepareTextAreaContent", string($value))'/> 
				</textarea>
			</xsl:when>
			<xsl:when test='$HType="user"'>
				<!--  Ideas? -->
				<xsl:message terminate='yes'>html-type "user" not supported at this time</xsl:message>
			</xsl:when>
			<xsl:otherwise>
                <xsl:variable name='size'>
                    <xsl:choose>
                        <xsl:when test='string(@size)!=""'><xsl:value-of select='string(@size)' /></xsl:when>
                        <xsl:when test='string($DEFS/*/zobjectdef[@name=$ZName]/fielddefs/fielddef[@id=$name]/@size)!=""'><xsl:value-of select='string($DEFS/*/zobjectdef[@name=$ZName]/fielddefs/fielddef[@id=$name]/@size)' /></xsl:when>
                        <xsl:when test='string($DTDef/@size)!=""'><xsl:value-of select='string($DTDef/@size)' /></xsl:when>
                        <xsl:otherwise>20</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
				<input>
					<xsl:attribute name="class"><xsl:value-of select='$validation'/></xsl:attribute>
					<xsl:attribute name='type'>text</xsl:attribute>
					<xsl:attribute name='name'><xsl:value-of select='$name' /></xsl:attribute>
					<xsl:attribute name='id'><xsl:value-of select='$name' /></xsl:attribute>
					<xsl:attribute name='value'><xsl:value-of select='$value' /></xsl:attribute>
					<xsl:attribute name='size'><xsl:value-of select='$size'/></xsl:attribute>
					<xsl:if test='string-length($remote)!=0'><xsl:attribute name='remote'><xsl:value-of select='$remote'/></xsl:attribute></xsl:if>
					<xsl:if test='number($DTDef/@maxlength) > 0'>
						<xsl:attribute name='maxlength'><xsl:value-of select='$DTDef/@maxlength'/></xsl:attribute>
					</xsl:if>

					<xsl:for-each select='$F/@*'>
						<xsl:choose>
							<xsl:when test='name()="datatype"'></xsl:when>
							<xsl:otherwise><xsl:copy-of select='.' /></xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</input>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


    <xsl:variable name='DEFS' select='php:function("zobject::source_document","MODULES")'/>
    <xsl:variable name='HandledElements' select='php:functionString("zobject::handled_elements")'/>

    <xsl:variable name='ZName' select='php:functionString("zobject::transform_var", "name")' />
    <xsl:variable name='requested-object-mode' select='php:functionString("zobject::transform_var", "mode")' />
    <xsl:variable name='login-key' select='php:functionString("zobject::transform_var", "login-key")' />
    <xsl:variable name='OID' select='php:functionString("zobject::transform_var", "uid")' />
    <xsl:variable name='ZPage' select='php:functionString("zobject::transform_var", "page")' />
    <xsl:variable name='ZPageCount' select='php:functionString("zobject::transform_var", "page-count")' />
    <xsl:variable name='ZCount' select='php:functionString("zobject::transform_var", "count")' />
    <xsl:variable name='ZArgs' select='php:functionString("zobject::transform_var", "args")' />
    <xsl:variable name='ZArgs64' select='php:functionString("zobject::transform_var", "args64")' />
    <xsl:variable name='ZPrefix' select='c' />

    <xsl:variable name='jsid' select='php:functionString("zobject::transform_var", "jsid")' />
    <xsl:variable name='zrefresh' select='php:functionString("zobject::refresh_link")' />

    <xsl:variable name='ZDef' select='$DEFS//modules/module/zobjectdef[@name=$ZName]' />
    <xsl:variable name='ZSrc' select='$ZDef/@source' />
    <xsl:variable name='TDef' select='$DEFS//modules/module/ztabledef[@name=$ZSrc]' />
    <xsl:variable name='obj' select='//.' />

    <xsl:variable name='mode' select='php:functionString("zobject_access::check", string($ZName), string($requested-object-mode))' />

    <xsl:template match='/'>
        <div>
            <xsl:attribute name='id'><xsl:value-of select='$jsid'/></xsl:attribute>
            <xsl:attribute name='zrefresh'><xsl:value-of select='$zrefresh'/></xsl:attribute>

            <xsl:variable name='benchstart' select='php:functionString("zobject_bench::time", "transform")'/>
            <xsl:variable name='named_template' select='php:functionString("zobject::get", "named_template")'/>
            <xsl:variable name='specific_template' select='$ZDef/render[@type=$mode]/@src'/>
            <xsl:variable name='alt_template'>
                <xsl:choose>
                    <xsl:when test='($mode="edit" or $mode="create") and string-length($ZDef/render[@type="display"]/@src)!=0'>
                        <xsl:value-of select='$ZDef/render[@type="display"]/@src'/>
                    </xsl:when>
                    <xsl:when test='($mode="list-edit" or $mode="list-create") and string-length($ZDef/render[@type="list"]/@src)!=0'>
                        <xsl:value-of select='$ZDef/render[@type="list"]/@src'/>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name='general_template' select='$ZDef/render[not(@type)]/@src'/>

            <xsl:variable name='docTemplateFile'>
                <xsl:choose>
                    <xsl:when test='string($named_template) != ""'><xsl:value-of select='string($named_template)' /></xsl:when>
                    <xsl:when test='string($specific_template) != ""'><xsl:value-of select='string($specific_template)' /></xsl:when>
                    <xsl:when test='string($alt_template) != ""'><xsl:value-of select='string($alt_template)' /></xsl:when>
                    <xsl:otherwise><xsl:value-of select='string($general_template)' /></xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name='docTemplate' select='php:function("zobject::get_template", string($docTemplateFile), string($ZName), string($mode))' />

            <xsl:if test='php:function("zobject::DEBUG_TRANSFORM")'>
                <table class='DEBUG'>
                    <tr><td class='title' colspan='2'>TRANSFORM.XSL (<xsl:value-of select='count($docTemplate)' />)</td></tr>
                    <tr><th>Var</th><th>Val</th></tr>
                    <tr><td>ZName</td><td><xsl:value-of select='$ZName'/></td></tr>
                    <tr><td>verify</td><td><xsl:value-of select='$ZDef/@name'/></td></tr>
                    <tr><td>requested-object-mode</td><td><xsl:value-of select='$requested-object-mode'/></td></tr>
                    <tr><td>mode</td><td><xsl:value-of select='$mode'/></td></tr>
                    <tr><td>ZSrc</td><td><xsl:value-of select='$ZSrc'/></td></tr>

                    <tr><td colspan='2' style='background-color: black;'>_</td></tr>
                    <tr><td>uid</td><td><xsl:value-of select='$OID'/></td></tr>
                    <tr><td>jsid</td><td><xsl:value-of select='$jsid'/></td></tr>
                    <tr><td>zr</td><td><xsl:value-of select='$zrefresh'/></td></tr>
                    <tr><td>zpage</td><td><xsl:value-of select='$ZPage'/></td></tr>
                    <tr><td>zpagecount</td><td><xsl:value-of select='$ZPageCount'/></td></tr>

                    <tr><td colspan='2' style='background-color: black;'>_</td></tr>
                    <tr><td>zname</td><td><xsl:value-of select='$ZName'/></td></tr>
                    <tr><td>prefix</td><td><xsl:value-of select='$ZPrefix'/></td></tr>
                    <tr><td>args</td><td><xsl:value-of select='$ZArgs'/></td></tr>

                    <tr><td colspan='2' style='background-color: black;'>_</td></tr>
                    <tr><td>named_template</td><td><xsl:value-of select='$named_template'/></td></tr>
                    <tr><td>specific_template</td><td><xsl:value-of select='$specific_template'/></td></tr>
                    <tr><td>alt_template</td><td><xsl:value-of select='$alt_template'/></td></tr>
                    <tr><td>general_template</td><td><xsl:value-of select='$general_template'/></td></tr>
                    <tr><td>docTemplateFile</td><td><xsl:value-of select='$docTemplateFile'/></td></tr>
                </table>
            </xsl:if>

            <xsl:variable name='resetRecNo' select='php:functionString("zobject::recno", "1")'/>
            <xsl:apply-templates select="$docTemplate/*" />
            <xsl:if test='php:function("zobject::BENCHMARK_TRANSFORM")'>
                <xsl:value-of select='php:functionString("zobject_bench::report", $benchstart, "ZObject Transform")'/>
            </xsl:if>
        </div>
    </xsl:template>

    <xsl:template match='@*'>
        <xsl:choose>
            <xsl:when test='name()="admin"'></xsl:when>
            <xsl:otherwise>
                <xsl:variable name='aname' select='name()'/>
                <xsl:variable name='atext'>
                    <xsl:value-of select='.'/>
                </xsl:variable>
                <xsl:variable name='avalue' select='php:functionString("zobject::template_escape_tokens", string($atext))' />
                <xsl:attribute name='{$aname}'>
                    <xsl:value-of select='$avalue'/>
                </xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="node()">
        <xsl:variable name='N' select='name()' />
        <xsl:variable name='Ck' select='concat(",",name(),",")' />
        <xsl:variable name='HasNodeHandler' select='string-length($N)!=0 and contains($HandledElements, $Ck)' />
        <xsl:choose>
            <xsl:when test='name()="text"'><xsl:call-template name='text'/></xsl:when>
            <xsl:when test='name()="require"'><xsl:call-template name='require'/></xsl:when>
            <xsl:when test='name()="value"'><xsl:call-template name='value'/></xsl:when>
            <xsl:when test='name()="editor"'><xsl:call-template name='editor'/></xsl:when>

            <xsl:when test='$HasNodeHandler'>
                <xsl:variable name='element' select='php:function("xml_serve::handle_element", $N, current())' />
                <xsl:copy select='$element'><xsl:apply-templates select="@*|node()"/></xsl:copy>
            </xsl:when>

            <xsl:when test='name()="startform"'><xsl:call-template name='startform'/></xsl:when>
            <xsl:when test='name()="endform"'><xsl:call-template name='endform'/></xsl:when>
            <xsl:when test='name()="formcontrols"'><xsl:call-template name='formcontrols'/></xsl:when>
            <xsl:when test='name()="caption"'><xsl:call-template name='caption'/></xsl:when>
            <xsl:when test='name()="field"'><xsl:call-template name='field'/></xsl:when>
            <xsl:when test='name()="fieldhelp"'><xsl:call-template name='fieldhelp'/></xsl:when>
            <xsl:when test='name()="fielddesc"'><xsl:call-template name='fielddesc'/></xsl:when>

            <xsl:when test='name()="row"'><xsl:call-template name='row'/></xsl:when>
            <xsl:when test='name()="formcommands"'><xsl:call-template name='formcontrols'/></xsl:when>
            <xsl:when test='name()="addlink"'><xsl:call-template name='addlink'/></xsl:when>
            <xsl:when test='name()="dellink"'><xsl:call-template name='dellink'/></xsl:when>
            <xsl:when test='name()="displaylink"'><xsl:call-template name='displaylink'/></xsl:when>
            <xsl:when test='name()="editlink"'><xsl:call-template name='editlink'/></xsl:when>
            <xsl:when test='name()="savelink"'><xsl:call-template name='savelink'/></xsl:when>
            <xsl:when test='name()="cancellink"'><xsl:call-template name='cancellink'/></xsl:when>

            <xsl:when test='name()="positionlink"'><xsl:call-template name='positionlink'/></xsl:when>
            <xsl:when test='name()="uppositionlink"'><xsl:call-template name='uppositionlink'/></xsl:when>
            <xsl:when test='name()="dnpositionlink"'><xsl:call-template name='dnpositionlink'/></xsl:when>

            <xsl:when test='name()="refreshlink"'><xsl:call-template name='refreshlink'/></xsl:when>

            <xsl:otherwise>
                <xsl:copy><xsl:apply-templates select="@*|node()"/></xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name='require'>
        <xsl:variable name='test' select='@test' />
        <xsl:variable name='rn' select='php:functionString("zobject::recno")'/>
        <xsl:variable name='result' select='php:functionString("zobject_require_test::test", string($OID), string($test), string($rn))'/>
        <xsl:if test='$result!="0"'>
            <xsl:apply-templates select="node()"/>
        </xsl:if>
    </xsl:template>

    <xsl:template name='text'>
        <!--	<xsl:value-of select='.'/> -->
    </xsl:template>

    <xsl:template name='value'>
        <xsl:variable name='rn' select='php:functionString("zobject::recno")'/>
        <xsl:if test='@select!=""'>
            <xsl:value-of disable-output-escaping='yes' select='php:functionString("valueSelect", string($OID), string(@select), string($rn))'/>
        </xsl:if>
    </xsl:template>

    <xsl:template name='startform'>
        <xsl:variable name='formid' select='php:functionString("zobject::form_id")'/>
        <xsl:variable name='action' select='php:functionString("zobject::form_action", $ZName, $formid, $ZArgs)'/>
        <xsl:variable name='ZS64' select='php:functionString("zobject::get", "source64")'/>
        <xsl:variable name='ZA64' select='$ZArgs64'/>
        <xsl:variable name='AJAX' select='php:functionString("zobject::ajax")'/>
        <xsl:variable name='FSC' select='php:functionString("zobject_source_check::nonce", $formid)'/>
        <xsl:variable name='Origin' select='php:functionString("zobject::origin")'/>

        <xsl:if test='$mode="edit" or $mode="create"'>
            <xsl:text disable-output-escaping="yes">&lt;form method="POST" action="</xsl:text>
            <xsl:value-of select='$action'/>
            <xsl:text disable-output-escaping="yes">"</xsl:text>
            <xsl:if test='string-length($formid) != 0'>
                <xsl:text disable-output-escaping="yes"> id="</xsl:text>
                <xsl:value-of select='$formid'/>
                <xsl:text disable-output-escaping="yes">"</xsl:text>
                <xsl:text disable-output-escaping="yes"> name="</xsl:text>
                <xsl:value-of select='$formid'/>
                <xsl:text disable-output-escaping="yes">"</xsl:text>
            </xsl:if>
            <xsl:text disable-output-escaping="yes">&gt;</xsl:text>

            <xsl:if test='string-length($AJAX)!=0'>
                <input type='hidden' name='_AJAX' value='1'/>
            </xsl:if>

            <input type='hidden' name='_Save' value='1'/>
            <input type='hidden' name='_ZO' value='{$Origin}'/>
            <input type='hidden' name='_ZN' value='{$ZName}'/>
            <input type='hidden' name='_ZM' value='{$mode}'/>
            <input type='hidden' name='_ZA' value='{$ZA64}'/>
            <xsl:if test='string-length($FSC)!=0'>
                <input type='hidden' name='_FSC' value='{$FSC}'/>
            </xsl:if>
        </xsl:if>

    </xsl:template>

    <xsl:template name='endform'>
        <xsl:variable name='formid' select='php:functionString("zobject::form_id")'/>
        <xsl:if test='$mode="edit" or $mode="create"'>
            <xsl:text disable-output-escaping="yes">&lt;/form&gt;</xsl:text>
            <script>jQuery(document).ready(function(){jQuery("#<xsl:value-of select='$formid'/>").validate();});</script>
        </xsl:if>
    </xsl:template>

    <xsl:template name='formcontrols'>
        <xsl:variable name='AJAX' select='php:functionString("zobject::ajax")'/>
        <xsl:variable name='formid' select='php:functionString("zobject::form_id")'/>
        <xsl:if test='string-length($AJAX)=0 and ($mode="edit" or $mode="create")'>
            <xsl:variable name='value'>
                <xsl:choose>
                    <xsl:when test='string-length(@value)!=0'><xsl:value-of select='string(@value)'/></xsl:when>
                    <xsl:when test='string-length(@text)!=0'><xsl:value-of select='string(@text)'/></xsl:when>
                    <xsl:otherwise>Submit</xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name='ty' select='substring(@type, 1, 1)'/>
            <xsl:if test='$ty="s" or $ty=""'>
                <input type='submit'>
                    <xsl:attribute name='value'><xsl:value-of select='$value'/></xsl:attribute>
                    <xsl:attribute name='class'><xsl:value-of select='@class'/></xsl:attribute>
                </input>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template name='field'>
        <xsl:variable name='F' select='.' />
        <xsl:variable name='rn' select='php:functionString("zobject::recno")'/>
        <xsl:variable name='fid' select='@id' />
        <xsl:variable name='fDef' select='$ZDef/fielddefs/fielddef[@id=$fid]' />
        <xsl:variable name='ztfDef' select='$TDef/fielddefs/fielddef[@id=$fid]' />
        <xsl:variable name='ixf' select='$ZDef/@index'/>

        <xsl:variable name='multiple' select='$fDef/@multiple'/>

        <xsl:variable name='default'>
            <xsl:choose>
                <xsl:when test='0!=string-length(@default)'><xsl:value-of select='php:functionString("php_hook::call", @default)'/></xsl:when>
                <xsl:when test='0!=string-length($fDef/@default)'><xsl:value-of select='php:functionString("php_hook::call", $fDef/@default)'/></xsl:when>
                <xsl:when test='0!=string-length($ztfDef/@default)'><xsl:value-of select='php:functionString("php_hook::call", $ztfDef/@default)'/></xsl:when>
                <xsl:otherwise></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name='bfvalue'>
            <xsl:choose>
                <xsl:when test='string-length($obj/row[number($rn)]/field[@id=$fid])!=0'><xsl:value-of select='$obj/row[number($rn)]/field[@id=$fid]'/></xsl:when>
                <xsl:otherwise><xsl:value-of select='$default'/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name='bfvalueFormat'>
            <xsl:choose>
                <xsl:when test='0!=string-length(@format)'><xsl:value-of select='@format'/></xsl:when>
                <xsl:when test='0!=string-length($fDef/@format)'><xsl:value-of select='$fDef/@format'/></xsl:when>
                <xsl:otherwise><xsl:value-of select='$ztfDef/@format'/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name='Fbfvalue'>
            <xsl:choose>
                <xsl:when test='string-length($bfvalueFormat)!=0'><xsl:value-of select='php:functionString("php_hook::call", $bfvalueFormat, $bfvalue)'/></xsl:when>
                <xsl:otherwise><xsl:value-of select='$bfvalue'/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name='datatype'>
            <xsl:choose>
                <xsl:when test='string-length(@datatype)!=0'><xsl:value-of select='string(@datatype)'/></xsl:when>
                <xsl:when test='string-length($fDef/@datatype)!=0'><xsl:value-of select='string($fDef/@datatype)'/></xsl:when>
                <xsl:otherwise><xsl:value-of select='string($ztfDef/@datatype)'/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name='fmode1'>
            <xsl:choose>
                <xsl:when test='string-length(@display)!=0'><xsl:value-of select='string(@display)'/></xsl:when>
                <xsl:otherwise><xsl:value-of select='string($mode)'/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name='fmode'>
            <xsl:choose>
                <xsl:when test='$fmode1="create" and $ixf=$fid and $bfvalue!=""'>display</xsl:when>
                <xsl:otherwise><xsl:value-of select='$fmode1'/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name='sc1' select='$DEFS/*/typedef[@name=$datatype]/@source' />
        <xsl:variable name='sc2' select='$fDef/@source' />
        <xsl:variable name='sc3' select='@source'/>
        <xsl:variable name='tsource'>
            <xsl:choose>
                <xsl:when test='0!=string-length($sc3)'><xsl:value-of select='$sc3' /></xsl:when>
                <xsl:when test='0!=string-length($sc2)'><xsl:value-of select='$sc2' /></xsl:when>
                <xsl:otherwise><xsl:value-of select='$sc1' /></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name='source' select='php:functionString("zobject::TransformSourceScripts", string($tsource))'/>
        <xsl:variable name='bvalidation'>
            <xsl:choose>
                <xsl:when test='string-length(@validation)!=0'><xsl:value-of select='string(@validation)'/></xsl:when>
                <xsl:when test='string-length($fDef/@validation)!=0'><xsl:value-of select='string($fDef/@validation)'/></xsl:when>
                <xsl:when test='string-length($ztfDef/@validation)!=0'><xsl:value-of select='string($ztfDef/@validation)'/></xsl:when>
                <xsl:otherwise><xsl:value-of select='string($DEFS/*/typedef[@name=$datatype]/@validation)'/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name='rvalidation'>
            <xsl:choose>
                <xsl:when test='string-length(@required)!=0'><xsl:value-of select='string(@required)'/></xsl:when>
                <xsl:when test='string-length($fDef/@required)!=0'><xsl:value-of select='string($fDef/@required)'/></xsl:when>
                <xsl:otherwise><xsl:value-of select='string($ztfDef/@required)'/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name='validation' select='php:functionString("zobject_validation::validation_string", string($bvalidation), string($rvalidation))'/>
        <xsl:variable name='remote' select='php:functionString("zobject_validation::remote_url", $fid)'/>

        <xsl:if test='php:function("zobject::DEBUG_TRANSFORM_FIELD")'>
            <table class='DEBUG'>
                <tr><td class='title' colspan='2'>TRANSFORM.XSL - field</td></tr>
                <tr><th>Var</th><th>Val</th></tr>
                <tr><td>rn</td><td><xsl:value-of select='$rn'/></td></tr>
                <tr><td>fid</td><td><xsl:value-of select='$fid'/></td></tr>
                <tr><td>ixf</td><td><xsl:value-of select='$ixf'/></td></tr>
                <tr><td>default</td><td><xsl:value-of select='$default'/></td></tr>
                <tr><td>bfvalue</td><td><xsl:value-of disable-output-escaping='yes' select='$bfvalue'/></td></tr>
                <tr><td>bfvalueFormat</td><td><xsl:value-of disable-output-escaping='yes' select='$bfvalueFormat'/></td></tr>
                <tr><td>Fbfvalue</td><td><xsl:value-of disable-output-escaping='yes' select='$Fbfvalue'/></td></tr>
                <tr><td>source</td><td><xsl:value-of select='$source'/></td></tr>
                <tr><td>datatype</td><td><xsl:value-of select='$datatype'/></td></tr>
                <tr><td>formzmode</td><td><xsl:value-of select='$mode'/></td></tr>
                <tr><td>fmode</td><td><xsl:value-of select='$fmode'/></td></tr>
                <tr><td>multiple</td><td><xsl:value-of select='$multiple'/></td></tr>
                <tr><td>ZPrefix</td><td><xsl:value-of select='$ZPrefix'/></td></tr>
                <tr><td>ZArgs</td><td><xsl:value-of select='$ZArgs'/></td></tr>
                <tr><td>validation</td><td><xsl:value-of select='$validation'/></td></tr>
                <tr><td>remote</td><td><xsl:value-of select='$remote'/></td></tr>
            </table>
        </xsl:if>
        <xsl:choose>
            <xsl:when test='substring($datatype,1,1)=":"'>
                <xsl:variable name='newZName' select='substring($datatype,2)'/>
                <xsl:variable name='addix' select='$ZDef/@index' />
                <xsl:variable name='addkey' select='substring($ZDef/xmlfile/@key,2)' />
                <xsl:variable name='addval'>
                    <xsl:choose>
                        <xsl:when test='$ZDef/xmlfile/@index="position()"'>
                            <xsl:value-of select='$rn'/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select='$obj/row[position()=number($rn)]/field[@id=$addix]'/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
<!--
		<xsl:variable name='addargs1' select='php:functionString("add_querystring_var", $ZArgs, "_SUBZ", "1")'/>
        <xsl:variable name='addargs' select='php:functionString("add_querystring_var", $addargs1, $addkey, $addval)'/>
-->
                <xsl:variable name='newargs' select='php:functionString("zobject::TransferObjectKeys", $ZName, $ZArgs)'/>
                <xsl:variable name='newmode'>
                    <xsl:choose>
                        <xsl:when test='$mode="edit" and $fDef/@mode="list"'>list-edit</xsl:when>
                        <xsl:when test='string-length($fDef/@mode)!=0'>
                            <xsl:value-of select='$fDef/@mode'/>
                        </xsl:when>
                        <xsl:when test='string-length(@mode)!=0'>
                            <xsl:value-of select='@mode'/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select='"list"'/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:if test='php:function("zobject::DEBUG_TRANSFORM_FIELD")'>
                    <table class='DEBUG'>
                        <tr><td class='title' colspan='2'>TRANSFORM.XSL - field, type=ZObject</td></tr>
                        <tr><th>Var</th><th>Val</th></tr>
                        <tr><td>newZName</td><td><xsl:value-of select='$newZName'/></td></tr>
                        <tr><td>addix</td><td><xsl:value-of select='$addix'/></td></tr>
                        <tr><td>addkey</td><td><xsl:value-of select='$addkey'/></td></tr>
                        <tr><td>addval</td><td><xsl:value-of select='$addval'/></td></tr>
                        <tr><td>addargs</td><td><xsl:value-of select='$addargs'/></td></tr>
                        <tr><td>newargs</td><td><xsl:value-of select='$newargs'/></td></tr>
                        <tr><td>$mode</td><td><xsl:value-of select='$mode'/></td></tr>
                        <tr><td>@mode</td><td><xsl:value-of select='$fDef/@mode'/></td></tr>
                        <tr><td>newmode</td><td><xsl:value-of select='$newmode'/></td></tr>
                    </table>
                </xsl:if>
                <xsl:copy-of select='php:function("renderZObject",substring($datatype,2),$newmode, string($newargs))' />
            </xsl:when>
            <xsl:when test='$fDef/@id=""'>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name='data-field'>
                    <xsl:with-param name='iDataTypes' select='$DEFS' />
                    <xsl:with-param name='F' select='$F' />
                    <xsl:with-param name='ZName' select='$ZName' />
                    <xsl:with-param name='FormZMode' select='$mode' />
                    <xsl:with-param name='ZMode' select='$fmode' />
                    <xsl:with-param name='FID' select='$fid' />
                    <xsl:with-param name='datatype' select='$datatype' />
                    <xsl:with-param name='name' select='concat($ZPrefix, $fid)' />
                    <xsl:with-param name='value' select='$Fbfvalue' />
                    <xsl:with-param name='source' select='$source' />
                    <xsl:with-param name='isMultiple' select='$multiple' />
                    <xsl:with-param name='validation' select='$validation' />
                    <xsl:with-param name='remote' select='$remote' />
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name='caption'>
        <xsl:variable name='fid' select='@id' />
        <xsl:variable name='dCap' select='$fid' />
        <xsl:variable name='specificZN' select='@zname' />
        <xsl:variable name='specificCap'>
            <xsl:if test='string-length($specificZN)!=0'><xsl:value-of select='$ZDef/fielddefs/fielddef[@id=$fid]/@caption'/></xsl:if>
        </xsl:variable>
        <xsl:variable name='tCap' select='$TDef/fielddefs/fielddef[@id=$fid]/@caption' />
        <xsl:variable name='bCap'>
            <xsl:choose>
                <xsl:when test='string-length($specificCap)!=0'><xsl:value-of select= '$specificCap'/></xsl:when>
                <xsl:when test='string-length($tCap)!=0'><xsl:value-of select= '$tCap'/></xsl:when>
                <xsl:otherwise><xsl:value-of select='$dCap' /></xsl:otherwise>
            </xsl:choose>
         </xsl:variable>

        <label>
            <xsl:attribute name='for'>
                <xsl:value-of select='$fid'/>
            </xsl:attribute>
            <xsl:choose>
                <xsl:when test='substring($mode, 1, 4)="list"'>
                    <xsl:value-of disable-output-escaping='yes' select='php:functionString("zobject_format::PrettyHeader", string($bCap))'/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of disable-output-escaping='yes' select='php:functionString("zobject_format::PrettyCaption", string($bCap))'/>
                </xsl:otherwise>
            </xsl:choose>
        </label>
    </xsl:template>

    <xsl:template name='fieldhelp'>
        <xsl:variable name='fid' select='@id' />
        <xsl:variable name='bCap' select='$TDef/fielddefs/fielddef[@id=$fid]/@help' />
        <div class='capex'>
            <xsl:copy-of select='php:functionString("zobject_format::PrettyCaptionHelp", string($bCap))' />
        </div>
    </xsl:template>

    <xsl:template name='fielddesc'>
        <xsl:variable name='fid' select='@id' />
        <xsl:variable name='bCap' select='$TDef/fielddefs/fielddef[@id=$fid]/@description' />
        <xsl:copy-of select='php:functionString("zobject_format::PrettyCaptionHelp", string($bCap))' />
    </xsl:template>

    <xsl:template name='row'>
        <xsl:variable name='row' select='.' />
        <xsl:variable name='rangeFrom' select='($ZPage - 1) * $ZPageCount + 1'/>
        <xsl:variable name='rangeTo' select='$ZPage * $ZPageCount'/>
        <xsl:if test='php:function("zobject::DEBUG_TRANSFORM_ROW")'>
            <table class='DEBUG'>
                <tr><td class='title' colspan='2'>TRANSFORM.XSL - ROW DEBUG</td></tr>
                <tr><th>Var</th><th>Val</th></tr>
                <tr><td>rangeFrom</td><td><xsl:value-of select='$rangeFrom'/></td></tr>
                <tr><td>rangeTo</td><td><xsl:value-of select='$rangeTo'/></td></tr>
            </table>
        </xsl:if>
        <xsl:for-each select='$obj/row'>
            <xsl:if test='position() &gt;= $rangeFrom and position() &lt;= $rangeTo'>
                <xsl:variable name='rowstart' select='php:functionString("zobject_bench::time", "rowstart")'/>
                <xsl:variable name='setRecNo' select='php:functionString("zobject::recno", string(position()))'/>
                <xsl:for-each select='$row/*'>
                    <xsl:apply-templates select='.' />
                </xsl:for-each>
                <xsl:if test='php:function("zobject::BENCHMARK_ROWS")'>
                    <xsl:value-of select='php:functionString("zobject_bench::report", "rowstart", "Rows")'/>
                </xsl:if>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match='tr'>
        <xsl:variable name='C' select='@class'/>
        <xsl:variable name='R' select='php:functionString("zobject::recno")'/>
        <xsl:variable name='alt_ext'>
            <xsl:if test='(number($R) mod 2) = 0'>-alt</xsl:if>
        </xsl:variable>
        <xsl:variable name='rowid' select='php:functionString("zobject::new_jsid")' />
        <xsl:variable name='zrefresh' select='php:functionString("zobject::refresh_link", true)' />
        <tr>
            <!-- <xsl:attribute name='id'><xsl:value-of select='$rowid' /></xsl:attribute> -->
            <xsl:attribute name='zrefresh'><xsl:value-of select='$zrefresh' /></xsl:attribute>
            <xsl:for-each select='@*'>
                <xsl:choose>
                    <xsl:when test='substring($C, 1, 1)="#" and name()="class"'>
                        <xsl:attribute name='class'>
                            <xsl:copy-of select='concat(substring($C, 2), $alt_ext)'/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:copy-of select='.'/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
            <xsl:for-each select='node()'>
                <xsl:apply-templates select='.' />
            </xsl:for-each>
        </tr>
    </xsl:template>

    <xsl:template match='li'>
        <xsl:variable name='C' select='@class'/>
        <xsl:variable name='R' select='php:functionString("zobject::recno")'/>
        <xsl:variable name='alt_ext'>
            <xsl:if test='(number($R) mod 2) = 0'>-alt</xsl:if>
        </xsl:variable>
        <li>
            <xsl:for-each select='@*'>
                <xsl:choose>
                    <xsl:when test='substring($C, 1, 1)="#" and name()="class"'>
                        <xsl:attribute name='class'>
                            <xsl:copy-of select='concat(substring($C, 2), $alt_ext)'/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:copy-of select='.'/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
            <xsl:for-each select='node()'>
                <xsl:apply-templates select='.' />
            </xsl:for-each>
        </li>
    </xsl:template>

    <xsl:template name='addlink'>
        <xsl:variable name='ntext'>
            <xsl:choose>
                <xsl:when test='string-length(@text)!=0'><xsl:value-of select='string(@text)' /></xsl:when>
                <xsl:otherwise>Add</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:copy-of select='php:function("zobject::item_link", string(@field), "create", string($ntext), string(@ajax), string(@class), string(@template))'/>
    </xsl:template>

    <xsl:template name='displaylink'>
        <xsl:variable name='ntext'>
            <xsl:choose>
                <xsl:when test='string-length(@text)!=0'><xsl:value-of select='string(@text)' /></xsl:when>
                <xsl:otherwise>@</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:copy-of select='php:function("zobject::item_link", string(@field), "display", string($ntext), string(@ajax), string(@class), string(@template))' disable-output-escaping='yes'/>
    </xsl:template>

    <xsl:template name='editlink'>
        <xsl:variable name='ntext'>
            <xsl:choose>
                <xsl:when test='string-length(@text)!=0'><xsl:value-of select='string(@text)' /></xsl:when>
                <xsl:otherwise>#</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:copy-of select='php:function("zobject::item_link", string(@field), "edit", string($ntext), string(@ajax), string(@class), string(@template))' disable-output-escaping='yes'/>
    </xsl:template>

    <xsl:template name='dellink'>
        <xsl:variable name='ntext'>
            <xsl:choose>
                <xsl:when test='string-length(@text)!=0'><xsl:value-of select='string(@text)' /></xsl:when>
                <xsl:otherwise>X</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:copy-of select='php:function("zobject::item_link", string(@field), "delete", string($ntext), string(@ajax), string(@class))'/>
    </xsl:template>

    <xsl:template name='savelink'>
        <xsl:variable name='ntext'>
            <xsl:choose>
                <xsl:when test='string-length(@text)!=0'><xsl:value-of select='string(@text)' /></xsl:when>
                <xsl:otherwise>Submit</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:copy-of select='php:function("zobject::item_link", string(@field), "save", string($ntext), string(@ajax), string(@class))'/>
    </xsl:template>

    <xsl:template name='cancellink'>
        <xsl:variable name='ntext'>
            <xsl:choose>
                <xsl:when test='string-length(@text)!=0'><xsl:value-of select='string(@text)' /></xsl:when>
                <xsl:otherwise>Cancel</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:copy-of select='php:function("zobject::item_link", string(@field), "cancel", string($ntext), string(@ajax), string(@class))'/>
    </xsl:template>

    <xsl:template name='positionlink'>
        <xsl:variable name='najax' select='@ajax' />
        <xsl:copy-of select='php:function("zobject::item_link", string(@field), "position", "", string(@ajax), string(@class))'/>
    </xsl:template>

    <xsl:template name='uppositionlink'>
        <xsl:variable name='ntext'>
            <xsl:choose>
                <xsl:when test='string-length(@text)!=0'><xsl:value-of select='string(@text)' /></xsl:when>
                <xsl:otherwise>-</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:copy-of select='php:function("zobject::item_link", string(@field), "upposition", string($ntext), string(@ajax), string(@class))'/>
    </xsl:template>

    <xsl:template name='dnpositionlink'>
        <xsl:variable name='ntext'>
            <xsl:choose>
                <xsl:when test='string-length(@text)!=0'><xsl:value-of select='string(@text)' /></xsl:when>
                <xsl:otherwise>+</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:copy-of select='php:function("zobject::item_link", string(@field), "dnposition", string($ntext), string(@ajax), string(@class))'/>
    </xsl:template>

    <xsl:template name='refreshlink'>
        <xsl:variable name='ntext'>
            <xsl:choose>
                <xsl:when test='string-length(@text)!=0'><xsl:value-of select='string(@text)' /></xsl:when>
                <xsl:otherwise>~</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:copy-of select='php:function("zobject::item_link", string(@field), "refresh", string($ntext), string(@ajax), string(@class))'/>
    </xsl:template>


    <xsl:template name='form-commands'>
        <div id='form-commands'>
            <xsl:variable name='cmds' select='php:function("GetObjectCommands", $ZName)'/>
            <xsl:for-each select='$cmds/*'>
                <xsl:apply-templates/>
            </xsl:for-each>
        </div>
    </xsl:template>
</xsl:stylesheet>
