import Currency_Conversion.country_module;
import ballerina/io;

configurable string api_key = ?;

public function main() {
    check country_module:getCountries();
    io:println("Hello, World!");
}
