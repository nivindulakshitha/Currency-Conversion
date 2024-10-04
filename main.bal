import Currency_Conversion.currency_convertion_module as ccm;

import ballerina/http;

type Country record {
    json name;
    json cca;
    json currencies?;
    json flags?;
};

type Iso_name record {|
    string name;
|};

configurable string api_key = "PLACE YOUR API KEY HERE";

final isolated string[] currencies = [];
isolated Country[] countryList = [];
isolated map<string> iso_name_list = {};

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

    isolated resource function get isonames() returns json|error {
        lock {
            return iso_name_list.clone();
        }
    }

    isolated resource function get isoname(string iso) returns string?|error {
        lock {
            if (iso_name_list.hasKey(iso)) {
                return iso_name_list[iso];
            } else {
                return error("No currency found for the given ISO code");
            }
        }
        
    }

    isolated resource function get isocode(string name) returns string?|error {
        lock {
            foreach string iso in iso_name_list.keys() {
                if (iso_name_list[iso] == name.toLowerAscii()) {
                    return iso;
                }
            }
            return error("No currency found for the given name");
        }
    }

    isolated resource function get convert(string origin, string target, float amount) returns json|error {
        json data = {
        "from_amount": amount,
        "from_currency": origin,
        "to_currency": target
    };

    json returnData = check ccm:calculate(api_key, data);
        return returnData;
    }
}

public function main() returns error? {
    http:Client restCountires = check new ("https://restcountries.com");
    json[] search = check restCountires->get("/v3.1/all");

    foreach var item in search {
        if item is map<anydata> {
            json countryName = check item["name"]?.common ?: "Unknown Name";
            json countryCurrencies = item.hasKey("currencies") ? item["currencies"] : {};
            json cca3 = item.hasKey("cca3") ? item["cca3"] : "";
            json flags = item.hasKey("flags") ? item["flags"] : {};

            Country newCountry = {
                name: countryName,
                cca: cca3,
                currencies: countryCurrencies,
                flags: flags
            };
            lock {
                countryList.push(newCountry.clone());
            }

            if countryCurrencies is map<anydata> {
                foreach var currency_iso in countryCurrencies.keys() {
                    string currency_name = check countryCurrencies[currency_iso].name;
                    lock {
                        iso_name_list[currency_iso] = currency_name.toLowerAscii();
                    }

                    lock {
                        currencies.push(currency_iso);
                    }
                }
            }
        }
    }
}
