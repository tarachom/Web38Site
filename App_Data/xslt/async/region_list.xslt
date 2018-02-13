<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output indent="yes"  method="html"/>

  <!-- Вивід списку регіонів (асинхронна загрузка) -->
  <xsl:template match="root">

    <select class="textboxfield2" name="Region" id="RegionItem">
      <xsl:attribute name="onchange">
        <xsl:text>RegionAsync('settlements_list', 'settlements_list', this.options[this.selectedIndex].value);</xsl:text>
      </xsl:attribute>

      <option value="">
        <xsl:text>-</xsl:text>
      </option>

      <xsl:for-each select="regions/region">

        <option>
          <xsl:attribute name="value">
            <xsl:value-of select="code"/>
          </xsl:attribute>
          <xsl:value-of select="name"/>
        </option>

      </xsl:for-each>

    </select>

  </xsl:template>

</xsl:stylesheet>