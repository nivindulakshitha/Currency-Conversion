import ballerina/http;
import ballerina/io;

public function getCountries() returns error? {
    http:Client resourceClient = check new ("https://restcountries.com");
    http:Response resourceResponse = check resourceClient -> get("/v3.1/all");

    json responseData = check resourceResponse.getJsonPayload();

    if responseData is json[] {
    foreach json country in responseData {
            json jsonCountry = country.toJson();
            json|error isoCode = jsonCountry.cca2;
            json|error name = jsonCountry.name.common;

            io:println(isoCode, name);
        }
    }
}