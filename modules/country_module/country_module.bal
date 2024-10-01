import ballerina/http;
import ballerina/io;

public function getCountries() returns error? {
    // Create an HTTP client to call the REST Countries API
    http:Client client = check new ("https://restcountries.com");

    // Send a GET request to retrieve all countries data
    http:Response response = check client->get("/v3.1/all");

    // Get the JSON payload from the response
    json jsonResponse = check response.getJsonPayload();

    // Loop through the JSON array to extract country information
    foreach var country in jsonResponse {
        string isoCode = country.cca2.toString();
        string name = country.name.common.toString();
        // Print the iso_code and name in the desired format
        io:println({iso_code: isoCode, name: name});
    }
};
