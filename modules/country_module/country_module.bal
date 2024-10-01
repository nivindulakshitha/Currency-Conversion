import ballerina/http;
import ballerina/io;

public function getCountries() returns error? {
    http:Client resourceClient = check new ("https://restcountries.com");
    http:Response resourceResponse = check resourceClient -> get("/v3.1/all");

    json responseData = check resourceResponse.getJsonPayload();

    if responseData is json[] {
        io:println("Countries:");
    }
}