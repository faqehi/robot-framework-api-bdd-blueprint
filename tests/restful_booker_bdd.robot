*** Settings ***
Documentation     BDD Test Suite for Restful-Booker API Gateway.
...               Adheres strictly to the Gherkin syntax structure.
Resource          base_keywords.resource
Test Tags        API    RestfulBooker

Suite Setup       Initialize API Testing Matrix

*** Test Cases ***
Scenario: Verify Admin Token Generation with Valid System Credentials
    [Documentation]    P0 | Critical path validation for session token extraction.
    [Tags]             Smoke    Auth    P0
    Given system user has valid administrative credentials "${ENV_ADMIN_USER}" and "${ENV_ADMIN_PASS}"
    When user requests an authorization token via the API gateway
    Then the gateway should respond with an HTTP status code 200
    And the response payload must contain a valid alpha-numeric session token string

Scenario: Verify Creation of a New Booking Reservation and Schema Validation
    [Documentation]    P0 | Essential write path ensuring structural schema contract compliance.
    [Tags]             Smoke    Booking    Write    P0
    Given a dynamic hotel booking reservation payload is constructed
    When user requests to create a new booking reservation entry
    Then the gateway should respond with an HTTP status code 200
    And the account details should match the structural data contract model "booking_creation_schema.json"

Scenario: Verify Full Updates are Rejected without an Authentication Header
    [Documentation]    P0 | Security regression check protecting state mutation endpoints.
    [Tags]             Regression    Security    P0
    Given an established booking reservation entry target id exists
    And no authorization details or headers are supplied to the client session
    When user issues a complete PUT request with an updated booking payload
    Then the gateway should respond with an HTTP status code 403
    And the network response message must return string "Forbidden"