<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output indent="yes"  method="html"/>

  <!-- Вивід списку населених пунктів (асинхронна загрузка) -->
  <xsl:template match="root">

    <select class="textboxfield2" name="Settlement">

      <xsl:choose>
        <xsl:when test="count(settlements/settlement) > 0">
          <xsl:for-each select="settlements/settlement">

            <option>
              <xsl:attribute name="value">
                <xsl:value-of select="code"/>
              </xsl:attribute>
              <xsl:value-of select="name"/>
            </option>

          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <option value="">
            <xsl:text>-</xsl:text>
          </option>
        </xsl:otherwise>
      </xsl:choose>

    </select>

  </xsl:template>

</xsl:stylesheet>