<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:output encoding="utf-8" method="xml" version="1.0" indent ="no"/>
	<xsl:template match="flexLibProperties/includeClasses">
		<xsl:element name="componentPackage">
			<xsl:apply-templates select="classEntry"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="classEntry">
		<xsl:element name="component">
			<xsl:attribute name="class">
				<xsl:value-of select="@path"/>
			</xsl:attribute>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>
