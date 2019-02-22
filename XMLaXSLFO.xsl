<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
      xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
      xmlns:fo="http://www.w3.org/1999/XSL/Format">
  <xsl:output method="xml" indent="yes"/>

  <!-- Esta template es la que contruirá todo el PDF-->
  <xsl:template match="/">
    <!-- El elemento raiz obligatorio para documentos XSL-FO-->
    <fo:root font-family="Helvetica" font-size="14pt">

      <!-- Declaración de páginas del doc y predeclaración de las zonas que utilizaremos en ellas.
           Básicamente crearemos dos páginas. Una con tan solo la portada y otra que iremos "repitiendo" 
           con los contenidos -->
      <fo:layout-master-set>
            
            <!-- Declaramos la página "portada" y su única zona-->
            <fo:simple-page-master master-name="portada" page-height="29.7cm" page-width="21.0cm">

              <fo:region-body region-name="xsl-region-body" />

            </fo:simple-page-master>

            <!-- Declaramos la página "A4" (la que iremos repitiendo) y sus zonas-->
            <fo:simple-page-master master-name="A4" page-height="29.7cm" page-width="21.0cm">

              <fo:region-body region-name="xsl-region-body" margin="2cm"/>
              <fo:region-before region-name="xsl-region-before" extent="1.25cm"/>
              <fo:region-after region-name="xsl-region-after" extent="1.25cm"/>

            </fo:simple-page-master>
            
          </fo:layout-master-set>
      
      <!-- Aquí creamos la raiz del Bookmark para el documento PDF. -->  
      <fo:bookmark-tree>
            <fo:bookmark internal-destination="INDICE" starting-state="show">
              <fo:bookmark-title>Indice de contenidos</fo:bookmark-title>
            <xsl:apply-templates select="*[@titulo]"/>
            </fo:bookmark>
          </fo:bookmark-tree>

      <!--============================================-->
      <!-- Aquí crearemos los contenidos propiamente. -->
      <!--============================================-->
      
      <!-- Contenido de la portada-->
      <fo:page-sequence master-reference="portada" force-page-count="no-force">
        <!-- Aquí el no-force sirve para la portada no se tenga en cuenta al numerar las páginas-->
        <fo:flow flow-name="xsl-region-body">
          <!-- La imagen de fondo de la portada (parece que se le da muchos atributos innecesarios pero nop...)-->
          <fo:block-container
                  absolute-position="absolute"
                  width="21cm"
                  height="29.7cm"
                  top="0cm"
                  left="0cm"
                  padding="0cm"
                  margin="0cm"
                  font-size="0cm"
                  line-height="0cm">            
            <fo:block>
              <fo:external-graphic
                content-height="29.7cm"
                absolute-position="absolute"
                top="0cm" left="0cm"
                padding="0cm"
                margin-left="0cm"
                font-size="0cm"
                line-height="0cm"
                z-index="-1"
                src="img/cover.tif"/>
            </fo:block>
          </fo:block-container>
          <!-- Los títulos de la portada-->
          <fo:block
                 margin-top="26cm"
                 text-align="center"
                 space-before="3.5mm">
            <fo:block
                font-size="21pt"
                color="white"
                font-weight="bold">
              Learning XML: Aprendiendo múltiples formatos
            </fo:block>
            <fo:block
                font-size="14pt"
                color="darkgrey">
              Contenidos del portal web para aprender XML en múltiples formatos
            </fo:block>
            <fo:block
                font-size="10pt"
                color="grey">
              Consultor: Ramirez J. | Grupo: Tr3s | Componentes: Gil I, Cervantes J, Iglesias R
            </fo:block>
          </fo:block>

        </fo:flow>
      </fo:page-sequence>

      <!-- Contenido de de la página que iremos repitiendo-->
      <fo:page-sequence master-reference="A4" initial-page-number="1">

        <!-- Aquí los contenidos de la cabecera -->
        <fo:static-content flow-name="xsl-region-before">
          <!-- OJO! parece que este lleno de atributos que no pintan nada pero no es así... -->
          <!-- Aquí metemos la imagen de fondo-->
          <fo:block-container
              absolute-position="absolute"
              width="21cm"
              height="29.7cm"
              top="0cm"
              left="0cm"
              padding="0cm"
              margin="0cm"
              font-size="0cm"
              line-height="0cm">
            <fo:block>
              <fo:external-graphic
                content-height="29.7cm"
                absolute-position="absolute"
                top="0cm" left="0cm"
                padding="0cm"
                margin-left="0cm"
                font-size="0cm"
                line-height="0cm"
                z-index="-1"
                src="img/background.tif"/>
            </fo:block>
          </fo:block-container>
          <!-- Aquí metemos la pestañita con la imagen XML para la cabecera-->
          <fo:block
              absolute-position="absolute"
              top="0cm"
              left="0cm"
              padding="0cm"
              margin-left="2cm"
              font-size="0cm"
              line-height="0cm" >
            <fo:external-graphic
              absolute-position="absolute"
              left="0cm"
              padding="0cm"
              margin="0cm"
              content-width="4cm"
              height="1mm"
              src="img\header.tiff" />
          </fo:block>
        </fo:static-content>

        <!-- Aquí los contenidos del pie de página -->
        <fo:static-content flow-name="xsl-region-after">
          <fo:block
              border-top-style="solid"
              margin-left="2cm"
              margin-right="2cm" >
            <fo:block
                color="grey"
                text-align="center"
                space-before="3.5mm"
                font-size="8pt">
              Learning XML: Aprender XML en múltiples formatos |
              Página <fo:page-number/> de <fo:page-number-citation ref-id="UltimoBloque"/><!-- Esto permitirá saber el número de la última página-->
            </fo:block>
          </fo:block>
        </fo:static-content>

        <!-- Aquí los contenidos del cuerpo principal-->
        <fo:flow flow-name="xsl-region-body">
          <!-- Título del índice:-->
          <fo:block
                 id="INDICE"
                 font-size="18pt"
                 color="blue"
                 border-bottom-style="solid"
                 space-before="5mm"
                 space-after="5mm">
            INDICE
          </fo:block>
          
          <!-- Construimos el índice utilizando todos los nodos que tengan un atributo título-->
          <xsl:for-each select="//*[@titulo]">

            <fo:block text-align-last="justify" margin-right="2em">
            <xsl:choose>

              <xsl:when test ="count(ancestor::*)=0">
                <fo:block text-align-last="left" space-before="3em" space-after="2em">
                  <!-- Para cada nodo un nuevo elemento que hará de hypervinculo interno,
                  tiene que tener una pinta final tipo: 
                  "<fo:basic-link internal-destination="NombreIdDestino">El nombre que muestra en el índice</fo:basic-link> -->
                  <xsl:element name="fo:basic-link">
                    <xsl:attribute name="internal-destination">
                      <xsl:value-of select="generate-id(.)"/>
                    </xsl:attribute>

                    <fo:inline font-weight="bold"><xsl:value-of select="@titulo"/></fo:inline>
                    
                    

                  </xsl:element>
                </fo:block>
              </xsl:when>

              <xsl:when test ="count(ancestor::*)=1">
                <fo:block text-align-last="justify" font-size="12pt" margin-left="2em" space-before="1em">
                   <xsl:element name="fo:basic-link">
                    <xsl:attribute name="internal-destination">
                      <xsl:value-of select="generate-id(.)"/>
                    </xsl:attribute>

                    <fo:inline font-weight="bold"><xsl:value-of select="@titulo"/></fo:inline>
                    <fo:leader leader-pattern="dots"></fo:leader>
                    <fo:page-number-citation ref-id="{generate-id(.)}"/>

                  </xsl:element>
                </fo:block>
              </xsl:when>

              <xsl:when test ="count(ancestor::*)=2">
                <fo:block text-align-last="justify" font-size="11pt" margin-left="4em" space-before="0.8em">
                  <xsl:element name="fo:basic-link">
                    <xsl:attribute name="internal-destination">
                      <xsl:value-of select="generate-id(.)"/>
                    </xsl:attribute>

                    <xsl:value-of select="@titulo"/>
                    <fo:leader leader-pattern="dots"></fo:leader>
                    <fo:page-number-citation ref-id="{generate-id(.)}"/>

                  </xsl:element>
                </fo:block>
              </xsl:when>

              <xsl:when test ="count(ancestor::*)=3">
                <fo:block text-align-last="justify" font-size="11pt" margin-left="6em" space-before="0.6em">
                 <xsl:element name="fo:basic-link">
                    <xsl:attribute name="internal-destination">
                      <xsl:value-of select="generate-id(.)"/>
                    </xsl:attribute>

                    <fo:inline font-style="italic"><xsl:value-of select="@titulo"/></fo:inline>
                    <fo:leader leader-pattern="dots"></fo:leader>
                    <fo:page-number-citation ref-id="{generate-id(.)}"/>

                  </xsl:element>
                </fo:block>
              </xsl:when>

              <xsl:otherwise>
                <fo:block text-align-last="justify" font-size="11pt" margin-left="8em" space-before="0.6em">
                <xsl:element name="fo:basic-link">
                    <xsl:attribute name="internal-destination">
                      <xsl:value-of select="generate-id(.)"/>
                    </xsl:attribute>

                    <xsl:value-of select="@titulo"/>
                    <fo:leader leader-pattern="dots"></fo:leader>
                    <fo:page-number-citation ref-id="{generate-id(.)}"/>

                  </xsl:element>
                </fo:block>
              </xsl:otherwise>

            </xsl:choose>
            </fo:block>
          </xsl:for-each>
          <!-- Metemos un salto de página-->
          <fo:block
                    break-after="column">           
          </fo:block>

          <!-- Metemos los contenidos:-->
          <xsl:for-each select="//*[@titulo]">
          <!-- Vamos a distinguir por tipo de contenido al meterlo en el PDF (questiones de formato)-->
            <!-- Aquí vamos a crear título y darles formato dependiendo del nivel al que esten en el arbol XML-->          
            <xsl:choose>
              
              <xsl:when test ="count(ancestor::*)=0">
                <fo:block
                     id="{generate-id(.)}"
                     font-size="18pt"
                     font-weight="bold"
                     padding-top="8pt"
                     padding-bottom="8pt"
                     text-align="center"
                     color="white"
                     background-color = "black">
                  <xsl:value-of select="@titulo"/>
                </fo:block>
              </xsl:when>
              
              <xsl:when test ="count(ancestor::*)=1">
                <fo:block
                     id="{generate-id(.)}"
                     font-size="16pt"
                     font-weight="bold"
                     padding-top="8pt"
                     padding-bottom="8pt"
                     text-align="center"
                     color="white"
                     background-color = "gray">
                  <xsl:value-of select="@titulo"/>
                </fo:block>
              </xsl:when>

              <xsl:when test ="count(ancestor::*)=2">
                <fo:block
                     id="{generate-id(.)}"
                     font-size="14pt"
                     font-weight="bold"
                     padding-top="8pt"
                     padding-bottom="8pt"
                     text-align="center"
                     color="white"
                     background-color = "darkgray">
                  <xsl:value-of select="@titulo"/>
                </fo:block>
              </xsl:when>
              
              <xsl:when test ="count(ancestor::*)=3">
                <fo:block
                     id="{generate-id(.)}"
                     font-size="14pt"
                     font-weight="bold"
                     padding-top="8pt"
                     padding-bottom="8pt"
                     text-align="center"
                     color="white"
                     background-color = "silver">
                  <xsl:value-of select="@titulo"/>
                </fo:block>
              </xsl:when>

              <xsl:otherwise>
                <fo:block
                     id="{generate-id(.)}"
                     font-size="14pt"
                     font-weight="bold"
                     padding-top="8pt"
                     padding-bottom="8pt"
                     text-align="center"
                     color="white"
                     background-color = "lightgrey">
                  <xsl:value-of select="@titulo"/>
                </fo:block>
              </xsl:otherwise>
              
            </xsl:choose>                 
            
            <!-- Aquí ya metemos el contenido finalmente! (Y conservando "saltos"!!)-->
           

                        <xsl:for-each select="//*[@titulo]/video">
                          <fo:block
                          line-height="18pt"
                          space-after.optimum="15pt"
                          color="black"
                          break-after="column">
                                <xsl:call-template name="ConservarSaltosTexto"/>
                                
                                <xsl:if test="video">
                                  <fo:block margin-top="1cm" height="250" text-align="center">
                                    <xsl:element name="fo:basic-link">
                                      <xsl:attribute name="color">blue</xsl:attribute>
                                      <xsl:attribute name="external-destination">
                                        url('<xsl:value-of select="video"/>')
                                      </xsl:attribute>
                                      <xsl:attribute name="text-altitude">75px</xsl:attribute>

                                      <fo:external-graphic content-height="scale-to-fit" width="300" src="img\video-cover.tif"/>

                                      <fo:block height="3cm" font-style="italic" text-align="center" font-size="6pt" >
                                        <fo:inline color="grey">Grupo Tr3s | Link: </fo:inline>
                                        <xsl:element name="fo:basic-link">
                                          <xsl:attribute name="color">blue</xsl:attribute>
                                          <xsl:attribute name="text-decoration">underline</xsl:attribute>
                                          <xsl:attribute name="external-destination">
                                            url('<xsl:value-of select="video"/>')
                                          </xsl:attribute>
                                          <xsl:attribute name="text-altitude">75px</xsl:attribute>
                                          <xsl:value-of select="video"/>
                                        </xsl:element>
                                      </fo:block>
                                      
                                    </xsl:element>
                                  </fo:block>
                                
                               </xsl:if>                       
                      
                        </fo:block>
              </xsl:for-each>
            


            
          </xsl:for-each>

          <!-- Esto solo es para sacar el número de la última página, para poder hacer un pie rollo "Pag. n de m" y saber cuanto vale "m"-->
          <fo:block id="UltimoBloque"> </fo:block>
        </fo:flow>

      </fo:page-sequence>

    </fo:root>

  </xsl:template>


<!--===============================================================================-->
<!--====================================TEMPLATES==================================-->
<!--===============================================================================--> 
 
 
<!-- Con esta template creamos los contenidos del Bookmark para el PDF -->
  <xsl:template name="CrearBookmark" match="*[@titulo]">
    
      <fo:bookmark internal-destination="{generate-id(.)}"
          starting-state="show">
        <fo:bookmark-title>
          <xsl:value-of select="@titulo" />
        </fo:bookmark-title>
        <xsl:apply-templates select="*[@titulo]"/>
      </fo:bookmark>
    
  </xsl:template>


<!-- Con esta template conservaremos los saltos de linea que tengan los nodos "texto" del XML -->
  <xsl:template name="ConservarSaltosTexto">

      <xsl:param name="paragrafo" select="texto"/>

      <!-- Si no hay más texto acabamos -->
      <xsl:if test="string-length(normalize-space($paragrafo)) > 0">
        <xsl:choose>
          <!-- Si el texto contiene una nueva linea -->
          <xsl:when test="contains($paragrafo, '&#10;')">
            <!-- Separa el texto en una nueva línea y &#10 para saber donde acaba. -->
            <xsl:variable name="linea" select="substring-before($paragrafo, '&#10;')"/>
            <xsl:variable name="acaba" select="substring-after($paragrafo, '&#10;')"/>

            <!-- Da salida a la línea como un tag <fo:block padding-top="3mm" /> -->
            <xsl:value-of select="normalize-space($linea)"/>
            <xsl:text>&#10;</xsl:text>
            <fo:block padding-top="3mm" />
            <xsl:text>&#10;</xsl:text>

            <!-- Vuelve a empezar para las líneas faltantes -->
            <xsl:call-template name="ConservarSaltosTexto">
              <xsl:with-param name="paragrafo" select="$acaba"/>
            </xsl:call-template>
          </xsl:when>
          <!-- Cuando no quedan más líneas, mete el texto que pueda quedar -->
          <xsl:otherwise>
            <xsl:value-of select="normalize-space($paragrafo)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
    
  </xsl:template>

</xsl:stylesheet>