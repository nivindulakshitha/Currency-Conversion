import Currency_Conversion.country_module;
import ballerina/io;
import ballerina/http;

configurable string api_key = ?;

// Table to hold country data (either null or a table of Country records)
table<country_module:Country>? countries = null;

public function main() returns error? {
    // Call getCountries and assign the result to the `countries` table
    table<country_module:Country>?|error result = country_module:getCountries();

    if result is error {
        io:println("Error occurred while fetching countries: ", result);
        countries = null; // Set countries to null if an error occurred
    } else {
        countries = result; // Set countries table if no error
        io:println("Data is ready to be provided!");
    }
}

// HTTP Service to provide country data
service on new http:Listener(8080) {
    resource function get countries(string? iso_code) returns country_module:Country|table<country_module:Country>? {
        // Check if `countries` is a valid table
        if countries is table<country_module:Country> {
            if iso_code is string {
                // Return the country that matches the given iso_code
                return countries[iso_code];
            } else {
                // Return the entire table if no iso_code is provided
                return countries;
            }
        } else {
            // If countries data is not ready (null or error), return null
            return null;
        }
    }
}