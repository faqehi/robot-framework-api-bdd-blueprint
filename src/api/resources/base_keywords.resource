*** Settings ***
Documentation     Central test framework orchestration resource layer.
...               Acts as a global fixture, routing environment configurations,
...               registering custom API clients, and exposing assertion keywords.

Resource          env_setup.resource
Library           JSONLibrary
Library           Collections
Library           OperatingSystem

*** Variables ***
${ENV}                 test
${ACTIVE_BOOKING_ID}   ${EMPTY}
${GLOBAL_AUTH_TOKEN}   ${EMPTY}
${BASE_URL}            https://restful-booker.herokuapp.com
${TIMEOUT}             5
${DEBUG_MODE}          ${True}
${LOGIN_PAYLOAD}       ${EMPTY}
${API_RESPONSE}        ${EMPTY}
${BOOKING_PAYLOAD}     ${EMPTY}


*** Keywords ***
Verify API Status Code Should Be
    [Documentation]    Validates that the HTTP response code matches the expected integer value.
    [Arguments]    ${response}    ${expected_status}
    Should Be Equal As Integers    ${response.status_code}    ${expected_status}
    ...    msg=Expected status code ${expected_status} but got ${response.status_code}. Response: ${response.text}

Verify Response Message
    [Documentation]    Helper assertion targeting response dictionaries containing standard confirmation keys.
    [Arguments]    ${response}    ${key}    ${expected_message}
    ${json_body}=    Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${json_body}    ${key}
    ...    msg=Key '${key}' was not found in the response body. Body: ${json_body}
    Should Be Equal As Strings    ${json_body['${key}']}    ${expected_message}
    ...    msg=Expected '${expected_message}' for key '${key}' but got '${json_body['${key}']}'

Verify Response Data Contract Schema
    [Documentation]    Ensures structural data integrity by validating the response payload
    ...                against a pre-defined JSON Schema model contract.
    [Arguments]    ${response}    ${schema_filename}
    ${schema_path}=    Set Variable    ${EXECDIR}/src/api/models/${schema_filename}
    
    File Should Exist    ${schema_path}
    ...    msg=The specified JSON schema model definition file could not be located at: ${schema_path}
    
    ${schema_string}=    Get File    ${schema_path}
    ${response_json}=    Set Variable    ${response.json()}
    Validate Json By Schema File    ${response_json}    ${schema_path}

Log Debug Information
    [Documentation]    Utility keyword to write execution details safely to logs based on environment flags.
    [Arguments]    ${message}
    IF    ${DEBUG_MODE} == ${True}
        Log To Console    \n[DEBUG]: ${message}
        Log    [DEBUG]: ${message}    level=DEBUG
    END

System user has valid administrative credentials "${user}" and "${pass}"
    [Documentation]    Arranges credentials payload for explicit auth submission.
    ${payload}=    Create Dictionary    username=${user}    password=${pass}
    Set Global Variable    ${LOGIN_PAYLOAD}    ${payload}


User requests an authorization token via the API gateway
    [Documentation]    Fires a POST /auth request using the compiled credentials payload.
    ${response}=    Create Authentication Token    ${LOGIN_PAYLOAD}
    Set Global Variable    ${API_RESPONSE}    ${response}

The response payload must contain a valid alpha-numeric session token string
    [Documentation]    Verifies token presence in a successful authentication lifecycle response.
    ${json}=    Set Variable    ${API_RESPONSE.json()}
    Dictionary Should Contain Key    ${json}    token
    Should Not Be Empty    ${json['token']}

The gateway should respond with an HTTP status code ${expected_status}
    [Documentation]    Dynamic status code mapping for BDD verification steps.
    Verify API Status Code Should Be    ${API_RESPONSE}    ${expected_status}

A dynamic hotel booking reservation payload is constructed
    [Documentation]    Generates isolated, random creation test data fixture via Faker.
    ${payload}=    Generate Dynamic Booking Payload
    Set Global Variable    ${BOOKING_PAYLOAD}    ${payload}

User requests to create a new booking reservation entry
    [Documentation]    Executes a clean POST /booking registration flow.
    ${response}=    Create New Booking Record    ${BOOKING_PAYLOAD}
    Set Global Variable    ${API_RESPONSE}    ${response}
    
    IF    ${response.status_code} == 200
        ${json}=    Set Variable    ${response.json()}
        Set Global Variable    ${ACTIVE_BOOKING_ID}    ${json['bookingid']}
    END

The account details should match the structural data contract model "${schema_file}"
    [Documentation]    Delegates structural data validation to the JSON schema validation engine.
    Verify Response Data Contract Schema    ${API_RESPONSE}    ${schema_file}
    
An established booking reservation entry target id exists
    [Documentation]    Ensures we have an active entity ID to target for mutations.
    IF    '${ACTIVE_BOOKING_ID}' == '${EMPTY}'
        A dynamic hotel booking reservation payload is constructed
        User requests to create a new booking reservation entry
    END
    Log Debug Information    Targeting active mutation ID reference: ${ACTIVE_BOOKING_ID}

No authorization details or headers are supplied to the client session
    [Documentation]    Explicitly strips the cookie header to test a negative 403 authorization route.
    Clear Session Authentication Token

User issues a complete PUT request with an updated booking payload
    [Documentation]    Executes a complete PUT override against the active target booking asset.
    ${updated_payload}=    Generate Dynamic Booking Payload
    ${response}=    Execute Full Booking Mutation    ${ACTIVE_BOOKING_ID}    ${updated_payload}
    Set Global Variable    ${API_RESPONSE}    ${response}

The network response message must return string "${expected_text}"
    [Documentation]    Asserts raw body error responses (e.g., "Forbidden").
    Should Be Equal As Strings    ${API_RESPONSE.text}    ${expected_text}