import Currency_Conversion.currency_convertion_module as ccm;

import ballerina/http;
import ballerina/io;

type Country record {
    json name;
    json cca;
    json currencies?;
};

final isolated string[] currencies = [];
isolated Country[] countryList = [];

service http:Service on new http:Listener(8080) {
    isolated resource function get countries() returns Country[]|error {
        lock {
            if (countryList.length() == 0) {
                return error("No countries found");
            } else {
                return countryList.clone();
            }
        }
    }

    isolated resource function get currencies() returns string[]|error {
        lock {
            if (currencies.length() == 0) {
                return error("No currencies found");
            } else {
                return currencies.clone();
            }
        }
    }
}

public function main() returns error? {
    json data = {
        "from_amount": 5000,
        "from_currency": "GBP",
        "to_currency": "AUD"
    };

    json returnData = check ccm:calculate(data);
    io:println("HW", returnData);

    http:Client restCountires = check new ("https://restcountries.com");
    json[] search = check restCountires->get("/v3.1/all");

    foreach var item in search {
        if item is map<anydata> {
            json countryName = check item["name"]?.common ?: "Unknown Name";
            json countryCurrencies = item.hasKey("currencies") ? item["currencies"] : {};
            json cca3 = item.hasKey("cca3") ? item["cca3"] : "";

            Country newCountry = {
                name: countryName,
                cca: cca3,
                currencies: countryCurrencies
            };
            lock {
                countryList.push(newCountry.clone());
            }

            if countryCurrencies is map<anydata> {
                foreach var currency in countryCurrencies.keys() {
                    lock {
                        currencies.push(currency);
                    }
                }
            }
        }
    }
}
