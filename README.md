# wso2am-soap-to-rest-converter
## XSLT Script to convert SOAP services into REST/XML 

These scripts generates Swagger definition and mediation extension from WSDL to convert SOAP service into REST/XML.The conversion strategy is to map each SOAP operation as REST resource.

Eg: Let's say the SOAP service is http://www.webservicex.com/globalweather.asmx?WSDL

It has two operations.
     1.GetWeather
     2.GetCitiesByCountry

These operations should be mapped to following resources and accept input without SOAP envelope and body

1.POST /globalweather/GetWeather 

Input :   <urn:GetWeather xmlns:urn="urn:http://www.webserviceX.NET">
                    <urn:CityName xmlns:urn="urn:http://www.webserviceX.NET">string</urn:CityName>
                    <urn:CountryName xmlns:urn="urn:http://www.webserviceX.NET">string</urn:CountryName>
             </urn:GetWeather>

Output: Response without SOAP envelope

2.POST /globalweather/GetCitiesByCountry

input :   <urn:GetCitiesByCountry xmlns:urn="urn:http://www.webserviceX.NET">
                <urn:CountryName xmlns:urn="urn:http://www.webserviceX.NET">string</urn:CountryName>
             </urn:GetCitiesByCountry>

Output: Response without SOAP envelope

XSLT scripts will generate a swagger definition and a mediation extension from WSDL.From the generated swagger file and mediation extension user will be able to expose existing SOAP APIs into REST APIs.
