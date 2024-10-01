import ballerina/http;

public type Country record {|
    json iso_code;
    json country_name;
|};

public final table<Country> country_list = table [];

public function getCountries() returns error|table<Country> {
    http:Client resourceClient = check new ("https://restcountries.com");
    http:Response resourceResponse = check resourceClient -> get("/v3.1/all");

    json responseData = check resourceResponse.getJsonPayload();

    if responseData is json[] {
        foreach json country in responseData {
            json jsonCountry = country.toJson();
            json isoCode = check jsonCountry.cca2;
            json name = check jsonCountry.name.common;

            Country thisCountry = {
                iso_code: isoCode,
                country_name: name
            };
            country_list.add(thisCountry);
        }

        return country_list;
    } else {
        return error("Could not get countries");
    }
}