<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
	version="1.0"
	xmlns:envgen="http://soapenvelopegenerator.eduardocastro.info/"
	xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:wsdl="http://schemas.xmlsoap.org/wsdl/"
	xmlns:soap="http://schemas.xmlsoap.org/wsdl/soap/"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema">
	<xsl:output method="text" indent="yes"/>
	<xsl:template match="/">
{  
   "swagger":"2.0",
   "info":{  
      "version":"1.0.0",
      "title":"<xsl:value-of select="/wsdl:definitions/wsdl:service/@name"/>",
      "license":{  
         "name":"MIT"
      }
   },
   "host":"petstore.swagger.io",
   "basePath":"/<xsl:value-of select="/wsdl:definitions/wsdl:service/@name"/>",
   "schemes":[  
      "http"
   ],
   "consumes":[  
      "application/xml"
   ],
   "produces":[  
      "application/xml"
   ],
			<xsl:apply-templates select="//wsdl:binding[soap:binding]"/>
		"definitions":{ <xsl:apply-templates select="/wsdl:definitions/wsdl:types"/>}
}
	</xsl:template>

	<xsl:template match="wsdl:binding">
		<xsl:variable name="bindingName" select="@name" />
		<xsl:variable name="endpointUrl" select="/wsdl:definitions/wsdl:service/wsdl:port[substring-after(@binding, ':') = $bindingName]/soap:address/@location" />
	
			<xsl:variable name="portTypeName" select="substring-after(@type, ':')" />
			<xsl:apply-templates select="../wsdl:portType[@name=$portTypeName]">
				<xsl:with-param name="binding" select="." />
			</xsl:apply-templates>
		
	</xsl:template>

	<xsl:template match="wsdl:portType">
		<xsl:param name="binding" />
"paths":{
		<xsl:apply-templates select="wsdl:operation">
			<xsl:with-param name="binding" select="$binding" />
		</xsl:apply-templates>
 },
	</xsl:template>

	<xsl:template match="wsdl:operation[parent::wsdl:portType]">
		<xsl:param name="binding" />
		<xsl:variable name="operationName" select="@name" />
		<xsl:variable name="soapAction" select="$binding/wsdl:operation[@name=$operationName]/soap:operation/@soapAction" />
		<xsl:variable name="operationDocumentation" select="//wsdl:operation[@name=$operationName]/wsdl:documentation" />
		<xsl:variable name="inputMessageName" select="substring-after(wsdl:input/@message, ':')" />
            
                <xsl:text>"/</xsl:text><xsl:value-of select="@name"/><xsl:text>":{</xsl:text>
              "post":{
                       "summary": "<xsl:value-of select="$operationDocumentation"/>",
        "operationId": "<xsl:value-of select="$operationName"/>",
        "tags": [
          "pets"
        ],
        "parameters": [
          {
            "name": "payload",
            "in": "body",
            "schema":{
            "$ref":"#/definitions/<xsl:apply-templates select="../../wsdl:message[@name=$inputMessageName]"/>"
}
          }
        ]
           
               }
               }
<xsl:choose>
    <xsl:when test="position() != last()">,</xsl:when>
  </xsl:choose>
	</xsl:template>

	<xsl:template match="wsdl:message">
		<xsl:apply-templates select="wsdl:part"/>
	</xsl:template>

	<xsl:template match="wsdl:part">
		<xsl:variable name="referencedElementPrefix" select="substring-before(@element, ':')" />
		<xsl:variable name="referencedElementName" select="substring-after(@element, ':')" />
		<xsl:variable name="referencedElementNamespace" select="ancestor::*/namespace::*[name()=$referencedElementPrefix][1]" />
		<xsl:variable name="referencedElementSchema" select="/wsdl:definitions/wsdl:types/xsd:schema[@targetNamespace=$referencedElementNamespace]" />
		<xsl:variable name="referencedElementNode" select="$referencedElementSchema/xsd:element[@name=$referencedElementName]" />
		<xsl:value-of select="$referencedElementName"/>
	</xsl:template>

	<xsl:template match="xsd:element[@ref]">
		<xsl:variable name="referencedElementPrefix" select="substring-before(@ref, ':')" />
		<xsl:variable name="referencedElementName" select="substring-after(@ref, ':')" />
		<xsl:variable name="referencedElementNamespace" select="ancestor::xsd:schema/namespace::*[name()=$referencedElementPrefix]" />
		<xsl:variable name="referencedElementSchema" select="/wsdl:definitions/wsdl:types/xsd:schema[@targetNamespace=$referencedElementNamespace]" />
		<xsl:variable name="referencedElementNode" select="$referencedElementSchema/xsd:element[@name=$referencedElementName]" />
		<xsl:apply-templates select="$referencedElementNode" />
	</xsl:template>
        <xsl:template match="wsdl:types">
                           <xsl:for-each select="./xsd:schema">
                          <xsl:for-each select="./xsd:element">

                <xsl:apply-templates select="."/>
                <xsl:choose>
    <xsl:when test="position() != last()">,</xsl:when>
  </xsl:choose>

</xsl:for-each>
                 </xsl:for-each>
      
        </xsl:template>

	<xsl:template match="xsd:element">
	<!--	<xsl:choose>
			<xsl:when test="@minOccurs=0">
				<xsl:comment>Optional</xsl:comment>
			</xsl:when>
			<xsl:when test="@maxOccurs > 1 or @maxOccurs='unbounded'">
				<xsl:comment>
					<xsl:value-of select="@minOccurs"/>
					<xsl:choose>
						<xsl:when test="@maxOccurs='unbounded'">
							<xsl:text> or more repetitions</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text> or max of </xsl:text>
							<xsl:value-of select="@maxOccurs"/>
							<xsl:text> repetitions</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:comment>
			</xsl:when>
		</xsl:choose> -->
               "<xsl:value-of select="@name"/>":{
                "title":"<xsl:value-of select="@name"/>",
                
			<xsl:choose>
				<!-- Element type is described outside -->
				<xsl:when test="@type">
					<xsl:variable name="referencedTypePrefix" select="substring-before(@type, ':')" />
					<xsl:variable name="referencedTypeName" select="substring-after(@type, ':')" />
					<xsl:variable name="referencedTypeNamespace" select="ancestor::xsd:schema/namespace::*[name()=$referencedTypePrefix]" />
					<xsl:choose>
						<xsl:when test="$referencedTypePrefix=''">
						"type":"<xsl:value-of select="@type"/>"
						</xsl:when>
						<xsl:when test="$referencedTypeNamespace='http://www.w3.org/2001/XMLSchema'">
						"type":"<xsl:value-of select="$referencedTypeName"/>"
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="referencedTypeSchema" select="/wsdl:definitions/wsdl:types/xsd:schema[@targetNamespace=$referencedTypeNamespace]" />
							<xsl:variable name="referencedTypeNode" select="$referencedTypeSchema/*[(self::xsd:complexType or self::xsd:simpleType) and @name=$referencedTypeName]" />
							"type":"object",
                                                        "properties":{<xsl:apply-templates select="$referencedTypeNode"/>}
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<!-- Element type is inside element itself (sequence, complextype) -->
				<xsl:otherwise>
				      "type":"object",
                                      "properties":{<xsl:apply-templates select="*"/>}
				</xsl:otherwise>
			</xsl:choose>
        ,
        "xml": {
        "name": "<xsl:value-of select="@name"/>",
	"namespace":"<xsl:value-of select="ancestor::xsd:schema/@targetNamespace"/>",
	"prefix":"urn"
      }
	}
	</xsl:template>

	<xsl:template match="xsd:sequence">
                <xsl:for-each select="./xsd:element">
		<xsl:apply-templates select="."/>
                <xsl:choose>
    <xsl:when test="position() != last()">,</xsl:when>
  </xsl:choose>
                 </xsl:for-each>
	</xsl:template>

	<xsl:template match="xsd:complexType">
		<xsl:apply-templates select="*"/>
	</xsl:template>

	<xsl:template match="xsd:simpleType[not(xsd:restriction)]">
		<xsl:apply-templates select="*"/>
		<xsl:text>?</xsl:text>
	</xsl:template>

	<xsl:template match="xsd:simpleType">
		<xsl:apply-templates select="*"/>
	</xsl:template>

	<xsl:template match="xsd:restriction">
		<xsl:for-each select="*[self::xsd:enumeration or self::xsd:pattern]">
			<xsl:if test="position() > 1">
				<xsl:text> or </xsl:text>
			</xsl:if>
			<xsl:value-of select="@value"/>
		</xsl:for-each>
	</xsl:template>

	<!-- Ignore other nodes -->
	<xsl:template match="*" />
</xsl:stylesheet>
