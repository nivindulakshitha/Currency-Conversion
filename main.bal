import ballerina/http;
import ballerina/io;

type Countries record {
    json[] countries;
};

public function main() returns error? {
    http:Client restCountires = check new ("https://restcountries.com");
    json[] countries = check restCountires -> get("/v3.1/all");
    
    Countries countryData = {countries: countries};
    io:println(countryData.countries[0].name.common);
    return null;
}