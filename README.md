# Currency-Conversion

Currency-Conversion is a Ballerina-based application that converts amounts between different currencies using an API. The app provides a REST API to retrieve country and currency information, as well as to perform currency conversions.

## Features

- List all available countries and their associated currencies.
- Retrieve currency details by ISO code or country name.
- Convert amounts between two different currencies.
- Data is fetched from a REST countries API, and conversions are done using an external currency conversion API.

## Prerequisites

Before running the project, ensure you have the following:

- [Ballerina](https://ballerina.io/downloads/) installed on your machine.
- An API key from [API Ninjas](https://api-ninjas.com/), which provides currency conversion services.

## Getting Started

### Clone the Repository

```bash
git clone https://github.com/your-username/Currency-Conversion.git
cd Currency-Conversion
```

### Running the Application

Once the API key is configured, run the following command to start the application:

```bash
bal run
```

The application will start a server on `http://localhost:8080`.

## API Endpoints

### List All Countries

- **Endpoint**: `/countries`
- **Method**: `GET`
- **Description**: Returns a list of all countries along with their currencies and flags.
- **Response**:
  ```json
  [
    {
      "name": "Country Name",
      "cca": "ISO Code",
      "currencies": {
        "USD": { "name": "US Dollar" }
      },
      "flags": "URL to flag image"
    }
  ]
  ```

### List All Currencies

- **Endpoint**: `/currencies`
- **Method**: `GET`
- **Description**: Returns a list of all available currency codes.
- **Response**:
  ```bash
  ["USD", "EUR", "JPY", ...]
  ```

### Get Currency by ISO Code

- **Endpoint**: `/isoname?iso={iso}`
- **Method**: `GET`
- **Description**: Returns the name and ISO code of the specified currency.
- **Response**:
  ```json
  {
    "name": "US Dollar",
    "iso": "USD"
  }
  ```

### Get Currency by Name

- **Endpoint**: `/isocode?name{name}`
- **Method**: `GET`
- **Description**: Returns the ISO code and name of the currency for a given country.
- **Response**:
  ```json
  {
    "name": "US Dollar",
    "iso": "USD"
  }
  ```

### Convert Currency

- **Endpoint**: `/convert?origin={origin}?target={target}?amount={amount}`
- **Method**: `GET`
- **Description**: Converts a given amount from the origin currency to the target currency.
- **Response**:
  ```json
  {
    "from_amount": 100,
    "from_currency": "USD",
    "to_currency": "EUR",
    "converted_amount": 90
  }
  ```

## Folder Structure
```
Currency-Conversion
├── Ballerina.toml
├── main.bal
├── currency_convertion_module.bal
└── README.md
```
- **main.bal**: The main entry point of the application, which handles the server and data initialization.
- **currency_convertion_module.bal**: The module responsible for making API calls to convert currencies.

## How it Works

The Currency-Conversion application utilizes Ballerina's HTTP client to interact with external APIs. When a request is made to the service, the application fetches country and currency information from the [REST Countries API](https://restcountries.com/) and performs currency conversion using the [API Ninjas](https://api-ninjas.com/) service. The application handles concurrency using isolated resources and locks to manage data access safely.

## Dependencies

The following dependencies are required for this project:

- Ballerina version 1.0 or higher
- `ballerina/http` package for HTTP client functionalities

You can add dependencies using the Ballerina command:
```bash
bal add http
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
