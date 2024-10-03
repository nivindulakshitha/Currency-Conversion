import ballerina/http;

type Country record {
    json name;
    json currencies?;
};

service http:Service on new http:Listener(8080) {
    resource function get countries() returns Country[]|error {
        http:Client restCountires = check new ("https://restcountries.com");
        json[] search = check restCountires->get("/v3.1/all");

        Country[] countryList = [];

        foreach var item in search {
            if item is map<anydata> {
                json countryName = check item["name"]?.common ?: "Unknown Name";
                json countryCurrencies = item.hasKey("currencies") ? item["currencies"] : {};

                Country newCountry = {
                    name: countryName,
                    currencies: countryCurrencies
                };

                countryList.push(newCountry);

            }
        }

        return countryList;
    }
}
