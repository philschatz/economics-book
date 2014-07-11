<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:x="http://www.w3.org/1999/xhtml"
  >

<xsl:output omit-xml-declaration="yes"/>

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="x:*">
  <xsl:element name="{local-name()}">
    <xsl:apply-templates select="@*|node()"/>
  </xsl:element>
</xsl:template>


<!-- <xsl:template match="x:title">
    <xsl:text>- - -
</xsl:text>
  <xsl:text>title: "</xsl:text>
  <xsl:value-of select="text()"/>
  <xsl:text>"
layout: page
- - -

</xsl:text>
</xsl:template>
 -->

<xsl:template match="x:html|x:body">
  <xsl:apply-templates select="node()"/>
</xsl:template>


<xsl:template match="x:td//x:div">
  <span>
    <xsl:apply-templates select="@*|node()"/>
  </span>
</xsl:template>

</xsl:stylesheet>
