<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes"/>
	
	<xsl:key name="ids" use="@id" match="*"/>
	
	<xsl:template match="/brainstorm">
		<html>
			<head>
				<title><xsl:value-of select="@title"/></title>
				<style type="text/css">
					body{
						font-family: arial, sans-serif;
						font-size:12px;
					}
					
					p{
						font-family: verdana, sans-serif;
					}
					
					div.toc{
						border: 1px solid #888888;
						padding:3px;
						background-color:#eeeeee;
						margin:3px;
					}
					
					div.subtree{
						margin-left:5px;
						border-left: 1px solid #888888;
						padding-left:15px;
					}
					
					div.problem{
						border: 1px solid #888888;
						padding:3px;
						margin:2px;
					}
					
					span.problemSign{
						color:#880000;
					}
					
					span.solutionSign{
						color:#008800;
					}
					
					span.unresolved{
						font-weight:bold;
						background-color:yellow;
						font-size:18px;
					}
					
					span.good{
						background-color:#008800;
						color:#88ffff;
						font-weight:bold;
						padding:2px;
					}
					
					span.bad{
						background-color:#880000;
						color:#ff88ff;
						font-weight:bold;
						padding:2px;
					}
					
					div.solution{
						border: 1px solid #888888;
						padding:3px;
						margin:2px;
					}
					div.advantage{
						background-color:#ccffcc;
						margin:3px;
					}
					div.disadvantage{
						background-color:#ffcccc;
						margin:3px;
					}
					
					.rejected{
						filter: alpha(opacity=30); /* IE */
						opacity: 0.30; /* Safari, Opera and Mozilla */
					}
					
					a:link{
						color:#0000ff;
						text-decoration:none;
					}
					a:visited{
						color:#0000ff;
						text-decoration:none;
					}
					a:hover{
						color:#0000ff;
						text-decoration:underline;
					}
					
					div.toc a:link{
						color:#000044;
						text-decoration:none;
					}
					div.toc a:visited{
						color:#000044;
						text-decoration:none;
					}
					div.toc a:hover{
						color:#0000aa;
						text-decoration:underline;
					}
				</style>
			</head>
			<body>
				<h1><xsl:value-of select="@title"/></h1>
				<xsl:call-template name="toc"/>
				<xsl:apply-templates/>
			</body>
		</html>
	</xsl:template>
	
	<xsl:template name="toc">
		<div class="toc">
			<xsl:apply-templates mode="toc"/>
		</div>
	</xsl:template>
	
	<xsl:template match="problem|solution" mode="toc">
		<p>
			<xsl:if test="@rate and @rate&lt;0">
				<xsl:attribute name="class">rejected</xsl:attribute>
			</xsl:if>
			<span>
				<xsl:attribute name="class"><xsl:value-of select="name()"/>Sign</xsl:attribute>
				<xsl:number count="problem|solution" level="multiple"/>
			</span>&#160;
			<xsl:if test="name()='problem' and not(.//solution)"><span title="Unresolved problem" class="unresolved">&#160;!&#160;</span>&#160;</xsl:if>
			<a>
				<xsl:attribute name="href">#
					<xsl:choose>
						<xsl:when test="@id"><xsl:value-of select="@id"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="generate-id()"/></xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:value-of select="@title"/>
			</a>
			<xsl:if test="@rate">&#160;
				<span>
					<xsl:attribute name="class">
						<xsl:choose>
							<xsl:when test="@rate&gt;0">good</xsl:when>
							<xsl:otherwise>bad</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:value-of select="@rate"/>
				</span>
			</xsl:if>
		</p>
		<div>
			<xsl:attribute name="class">
				subtree
				<xsl:if test="@rate and @rate&lt;0">
					rejected
				</xsl:if>
			</xsl:attribute>
			<xsl:apply-templates mode="toc"/>
		</div>
	</xsl:template>
	
	<xsl:template match="*" mode="toc"/>
	
	<xsl:template match="problem">
		<div class="problem">
			<xsl:variable name="level" select="count(ancestor::*)+1"/>
			<a>
				<xsl:attribute name="name">
					<xsl:choose>
						<xsl:when test="@id"><xsl:value-of select="@id"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="generate-id()"/></xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</a>
			<xsl:element name="h{$level}">
				<xsl:number count="problem|solution" level="multiple" grouping-separator="."/>&#160;<span style="color:#880000;">Задача:</span>&#160;<xsl:value-of select="@title"/>
			</xsl:element>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	
	<xsl:template match="solution">
		<div class="solution">
			<xsl:attribute name="class">
				solution
				<xsl:if test="@rate and @rate&lt;0">
					rejected
				</xsl:if>
			</xsl:attribute>
			<xsl:variable name="level" select="count(ancestor::*)+1"/>
			<a>
				<xsl:attribute name="name">
					<xsl:choose>
						<xsl:when test="@id"><xsl:value-of select="@id"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="generate-id()"/></xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</a>
			<xsl:element name="h{$level}"> 
				<xsl:number count="problem|solution" level="multiple" grouping-separator="."/>&#160;<span style="color:#008800;">Решение:</span>&#160;<xsl:value-of select="@title"/>
				<!--span>
				<xsl:value-of select="@rate"/></span-->
				<xsl:if test="@rate">&#160;
					<span>
						<xsl:attribute name="class">
							<xsl:choose>
								<xsl:when test="@rate&gt;0">good</xsl:when>
								<xsl:otherwise>bad</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<xsl:value-of select="@rate"/>
					</span>
				</xsl:if>
			</xsl:element>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	
	<xsl:template match="description">
		<div class="description">
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	
	<xsl:template match="p"><p><xsl:apply-templates/></p></xsl:template>
	<xsl:template match="list"><ul><xsl:apply-templates/></ul></xsl:template>
	<xsl:template match="li"><li><xsl:apply-templates/></li></xsl:template>
	
	<xsl:template match="ref">
		<a href="#{key('ids', @id)/@id}">
		 	&quot;<xsl:value-of select="key('ids', @id)/@title"/>&quot;
		</a>
	</xsl:template>
	
	<xsl:template match="advantage">
		<div class="advantage"><xsl:apply-templates/></div>
	</xsl:template>
	
	<xsl:template match="disadvantage">
		<div class="disadvantage"><xsl:apply-templates/></div>
	</xsl:template>
</xsl:stylesheet>
