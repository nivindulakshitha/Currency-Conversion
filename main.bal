import ballerina/http;

type Country record {
    json name;
    json currencies;
};

type Countries record {|
    Country[] searchData;
|};

// Global variable to store country data
Countries? abc = null;

service /contries on new http:Listener(8080) {
    resource function get contries() returns Country[]|error {
        // Use 'if let' to safely access 'abc'
        if let Countries nonNullData = abc {
                // Correctly construct a Country type object in the 'select' clause
                Country []             result = from Country country in nonNullData.searchData
                select {
                    name: country.name,
                    currencies: country.currencies
                };
            return result;
        } else {
            return error("Country data not available yet.");
        }
    }
}

public function main() returns error? {
    http:Client restCountries = check new ("https://restcountries.com");

    // Get the country data from the API
    json[] searchData = check restCountries->get("/v3.1/all");

    // Assign the retrieved data to 'abc'
    abc = {searchData: <Country[]>searchData};
}
