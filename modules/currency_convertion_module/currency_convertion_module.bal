import ballerina/http;

public isolated function calculate(string api_key, json conversion_properties) returns error|json {
    final float from_amount = check conversion_properties.from_amount;
    final string from_currency = check conversion_properties.from_currency;
    final string to_currency = check conversion_properties.to_currency;

    http:Client client_instance = check new ("https://api.api-ninjas.com");
    http:Request request = new;

    if (api_key != "PLACE YOUR API KEY HERE") {
        request.setHeader("X-Api-Key", api_key);
    } else {
        return error("Missing API key");
    }

    map<string|string[]> queryParams = {
        "X-Api-Key": api_key
    };

    string path = "/v1/convertcurrency?have=" + from_currency + "&want=" + to_currency + "&amount="+ from_amount.toString();

    json|http:ClientError response = check client_instance->get(path, queryParams, json);

    return response;
}
