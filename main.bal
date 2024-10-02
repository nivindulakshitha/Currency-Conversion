import Currency_Conversion.country_module;
import ballerina/io;
import ballerina/http;

configurable string api_key = ?;

table<country_module:Country>?|error countries = null;

public function main() returns error? {
    countries = check country_module:getCountries();
    
    if (countries is error) {
        countries = null;
    } else {
        io:println("Data is ready to be provided!");
    }
}

service on new http:Listener(8080) {
    resource function get countries(string iso_code) returns table<country_module:Country>|error? {
        if (countries is null) {
            return error("Data is not ready yet!");
        } else {
            return countries;
        }
    }
}