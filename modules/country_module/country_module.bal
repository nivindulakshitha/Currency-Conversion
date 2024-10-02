import ballerina/http;

public type Country record {
    readonly string iso_code;
    string country_name;
};

public final table<Country> key(iso_code) country_list = table [];

public function getCountries() returns table<Country>?|error {
    http:Client resourceClient = check new ("https://restcountries.com");
    http:Response resourceResponse = check resourceClient -> get("/v3.1/all");

    json responseData = check resourceResponse.getJsonPayload();

    if responseData is json[] {
        foreach json country in responseData {
            json jsonCountry = country.toJson();
            string isoCode = check jsonCountry.cca2;
            string name = check jsonCountry.name.common;

            Country thisCountry = {
                iso_code: <string & readonly>isoCode,
                country_name: name
            };
            country_list.add(thisCountry);
        }

        return country_list;
    } else {
        return null;
    }
}