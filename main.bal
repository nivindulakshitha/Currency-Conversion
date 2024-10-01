import Currency_Conversion.country_module;
import ballerina/io;

configurable string api_key = ?;

public function main() returns error? {
    table<country_module:Country> countries = check country_module:getCountries();
    foreach country_module:Country country in countries {
        io:println("Country: " + country.country_name.toString() + ", ISO Code: " + country.iso_code.toString());
    }
    io:println("Hello, World!");
}
