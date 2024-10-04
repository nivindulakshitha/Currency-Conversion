import ballerina/http;
import ballerina/io;

configurable string api_key = "PLACE YOUR API KEY HERE";

public function calculate(json conversion_properties) returns error|json {
    final float from_amount = check conversion_properties.from_amount;
    final string from_currency = check conversion_properties.from_currency;
    final string to_currency = check conversion_properties.to_currency;

    http:Client client_instance = check new ("https://api.api-ninjas.com");
    http:Request request = new ();

    if (api_key != "PLACE YOUR API KEY HERE") {
        request.setHeader("X-Api-Key", api_key);
    } else {
        return error("Missing API key");
    }

    string response_path = "/v1/convertcurrency?have=" + from_currency + "&want=" + to_currency + "&amount=" + from_amount.toString();
    http:Response response = check client_instance->get(response_path, request);

    json response_body = check response.getJsonPayload();

    return response_body;
}
