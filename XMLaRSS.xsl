<?xml version="1.0" encoding="utf-8" ?>
<!--Declaramos versión y codificación -->
  <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- Declaramos que la salida seguirá siendo un doc XML y con indent conservaremos los saltos de linea-->
    <xsl:output method="xml" indent="yes"/>
    <!--Traemos lo que nos permitirá aplicar template rules -->
    <xsl:template match="/contenido">
      <!--Declaramos el documento de salido como un RSS v.2.0-->
      <rss version="2.0">
        <channel>
          <title>
            <xsl:value-of select="FeedRSS/@tituloCanal"/>
          </title>
          <link>
            <xsl:value-of select="FeedRSS/@web"/>
          </link>
          <description>
            <xsl:value-of select="FeedRSS/@descripcion"/>
          </description>          
          <language>
            <xsl:value-of select="FeedRSS/@idioma"/>
          </language>
          <copyright>
            <xsl:value-of select="FeedRSS/@copyright"/>
          </copyright>
          <lastBuildDate>
            <xsl:value-of select="FeedRSS/@fecha"/>
          </lastBuildDate>

          
          <xsl:apply-templates select="/contenido/FeedRSS"/>
          
        </channel>        
      </rss>      
    </xsl:template>
    
    <!-- Esta template recogerá todos los elementos -->
    
    <xsl:template match="item">
      
        <item>
            <title>
              <xsl:apply-templates select="title"/>
            </title>
            <link>
              <xsl:apply-templates select="link"/>
            </link>
            <description>
              <xsl:apply-templates select="description"/>
            </description>
            <pubDate>
              <xsl:apply-templates select="pubDate"/>
            </pubDate>
          <xsl:element name="guid">
            <xsl:attribute name="isPermalink">false</xsl:attribute>
            <xsl:value-of select="generate-id(title)"/>
            <!-- Generamos un identificador único para la noticia-->
          </xsl:element>           
            <author>
              <xsl:apply-templates select="author"/>
            </author>
      
            <xsl:for-each select="category">
                <category>
                  <xsl:apply-templates select="node()"/> <!-- Vamos metiendo todos los nodos "category" que encuentre-->
                </category>
        
            </xsl:for-each>
        </item>
    </xsl:template>  
    
  </xsl:stylesheet>