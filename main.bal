import ballerina/http;

type Country record {
    json name;
    json currencies;
};

service http:Service on new http:Listener(8080) {
    resource function get countries() returns Country[]|error {
        http:Client restCountires = check new ("https://restcountries.com");
        Country[] search = check restCountires->get("/v3.1/all");

        Country[] result = from Country country in search
            select {name: check country.name.common, currencies: country.currencies};

        return result;
    }
}
