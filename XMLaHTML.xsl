<?xml version="1.0" encoding="UTF-8" ?>
<!--Declaramos versión y codificación -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!--Traemos lo que nos permitirá aplicar template rules -->
  <xsl:template match="*">
    <!--Trabajaremos con todos los nodos del XML -->

    <html>
      <head>
        <link rel="stylesheet" type="text/css" href="archivo.css" />
        <!-- Añadimos el estilo en CSS (guardado en otro archivo .css y desde aquí lo llamamos) -->

        <a style="display:scroll;position:fixed;bottom:5px;right:20px;" href="#" title="">
          <img width="70" src="img/flecha.png" />
        </a>
        <!-- Añadimos la flecha que consigue que nos persiga siempre a la derecha y nos permite subir al principio de la página al pulsarla -->

        <title>
          <xsl:value-of select="@titulo"/>
          <!--Cogemos el primer título, que es el título de proyecto, para la pestaña del navegador -->
        </title>

      </head>
      <body>

        <p>
          <img id="cabecera" src="img/cabecera.jpg" />
        </p>
        <!-- Añadimos la imagen de cabecera -->

        <span id="indice">
          <!--Un contenedor span contedrá el indice. Le damos id para modificar su estilo en el CSS -->
          <ul>

            <xsl:for-each select="/contenido//*[@titulo]">
              <!--Seleccionamos todos los nodos que tengan un atributo que se llame "titulo=" y para cada uno haremos lo que sigue -->

              <li class="TituloIndiceNivel{count(ancestor::*)}">
                <!--Creamos un contenedor tipo li y le damos un atributo "class=". El valor de class será "TituloIndiceNivelX", donde x será un entero que indica el nivel dentro del arbol XML gracias a la expresión {count(ancestor::*)}. Todo esto nos sirve para maquetar el indice por subapartados y tal-->

                <xsl:element name="a">
                  <!--Creamos un nuevo elemento, el contenedor HTML "a", esto nos servirá para añadir a cada elemento del indice un hypervinculo a los contenidos de su apartado-->

                  <xsl:attribute name="href">
                    <!--Le damos un atributo al contenedor HTML "a": "href="-->

                    <xsl:text>#</xsl:text>
                    <!--Precedemos todo valor del atributo "href=" con "#" (para que sea funcional tiene que quedar tipo href="#IDContenedorDestino"-->
                    <xsl:value-of select="@titulo"/>
                    <!--Concadenamos "#" con el titulo del nodo (lo hará para cada nodo que estamos dentro del "for-each")"-->

                  </xsl:attribute>
                  <!--Ya tenemos el hypervinculo funcionando ahora el nombre que mostrará "a"-->

                  <xsl:value-of select="@titulo"/>
                  <!--El nombre a mostrar por "a", simplemente el título-->


                </xsl:element>



                <!-- Cerramos "a"-->

              </li>

            </xsl:for-each>

          </ul>
        </span>
        <!-- Cerramos "span", osea el índice-->

        <span id="contenido">
          <xsl:for-each select="//*[@titulo]">
            <!-- Otro "for-each" pero ahora buscamos presentar los contenidos. Igual que al construir el índice seleccionamos todos los nodos que tengan un atributo que se llame "titulo=" y para cada uno haremos lo que sigue -->

            <xsl:element name="div">
              <!-- Creamos un contenedor "div" para cada bloque de contenido-->

              <xsl:attribute name="id">
                <xsl:value-of select="@titulo"/>
              </xsl:attribute>
              <!-- La "ID" del contendero "div" será el título. (esto simplemente es para poder llegar desde el índice que hemos construido antes-->

              <xsl:choose>
                <!-- Aquí se complica... El problema es que hay apartados del índice que no tienen texto, sino que sólo contienen sus subapartados!-->

                <xsl:when test="texto">
                  <!-- Si el apartado que estamos tratando tiene texto entonces hagamos lo que sigue-->

                  <p class="TituloContenidoNivel{count(ancestor::*)}">
                    <xsl:value-of select="@titulo"/>
                  </p>
                  <!-- Creamos un contenedro "p", que al igual que con el índice queremos tenga un nombre de "class" que nos permita maquetar por niveles y además dentro de "p" metémos el valor del título-->

                  <p class="contenidosTexto">
                    <xsl:call-template name="ConservarSaltosTexto"/>
                    <!-- Aquí ya metemos el contenido finalmente!-->
                  </p>

                  <xsl:if test="video">
                    <!-- Aún hay más! Y los apartados que tienen videos? Para saber cuando hay videos usaremos la template rule "if". Con ella podemos averiguar si el XML tiene un nodo llamado "video". Sí lo tiene entonces: -->

                    <xsl:element name="iframe">
                      <!-- Creamos un nuevo elemento "iframe", con todos los atributos que nos da youtube cuando queremos icrustar un video-->
                      <xsl:attribute name="class">video</xsl:attribute>
                      <xsl:attribute name="width">440</xsl:attribute>
                      <xsl:attribute name="height">260</xsl:attribute>
                      <xsl:attribute name="src">
                        <xsl:value-of select="video"/>
                      </xsl:attribute>
                      <!-- Aquí es donde cogeremos el hypervínculo que contiene video-->
                      <xsl:attribute name="frameborder">0</xsl:attribute>
                      <xsl:attribute name="allow">accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture;</xsl:attribute>
                      <xsl:attribute name="allowfullscreen">allowfullscreen</xsl:attribute>
                      <xsl:comment/>
                      <!-- Esto de hecho no haría falta... pero ojo! que sin la etiqueta vacia se rompe el HTML!-->
                    </xsl:element>

                  </xsl:if>

                  <p class="VolverAlIndice">
                    <a href="#top">Volver al índice</a>
                  </p>
                  <!-- Dentro de cada apartado, que tenga contenido, metemos un hypervinculo de cortesia para volver al índice-->

                </xsl:when>
                <!-- Se acabaron las template rules para el caso de que haya contenido (el nodo "texto")-->
                <xsl:otherwise>
                  <!-- Se acabaron las template rules para el caso de que haya contenido (el nodo "texto")-->

                  <p class="TituloContenidoNivel{count(ancestor::*)}">
                    <xsl:value-of select="@titulo"/>
                  </p>
                  <!-- Acabamos con la segunda y última opción del "choose". Si no hay contenido crear un contenedor "p", que al igual que con el índice, queremos tenga un nombre de "class" que nos permita maquetar por niveles y además dentro de "p" metémos el valor del título-->

                </xsl:otherwise>
                <!-- Vamos cerrando todo...-->

              </xsl:choose>

            </xsl:element>

          </xsl:for-each>
        </span>

      </body>
    </html>

  </xsl:template>

  <xsl:template name="ConservarSaltosTexto">
    <!-- Con esta template conservaremos los saltos de linea que tengan los nodo texto del XML -->

    <xsl:param name="paragrafo" select="texto"/>

    <!-- Si no hay más texto acabamos -->
    <xsl:if test="string-length(normalize-space($paragrafo)) > 0">
      <xsl:choose>
        <!-- Si el texto contiene una nueva linea -->
        <xsl:when test="contains($paragrafo, '&#10;')">
          <!-- Separa el texto en una nueva línea y &#10 para saber donde acaba. -->
          <xsl:variable name="linea" select="substring-before($paragrafo, '&#10;')"/>
          <xsl:variable name="acaba" select="substring-after($paragrafo, '&#10;')"/>

          <!-- Da salida a la línea como un tag <br/> -->
          <xsl:value-of select="normalize-space($linea)"/>
          <xsl:element name="br"/>
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
