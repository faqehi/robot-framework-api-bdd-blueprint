*** Settings ***
Documentation     Global Environmental Initialization Router.
...               Responsible for mapping targeted runtime configurations, 
...               registering native Python client classes, and priming auth hooks.

Library           ../src/api/config/environments.py
Library           ../src/api/clients/BookingClient.py    ${BASE_URL}
Library           ../src/utils/DataGenerator.py

*** Variables ***
${ENV}                 test
${ACTIVE_BOOKING_ID}   ${EMPTY}
${GLOBAL_AUTH_TOKEN}   ${EMPTY}
${BASE_URL}            https://restful-booker.herokuapp.com
${TIMEOUT}             5
${DEBUG_MODE}          ${True}
# Pre-declared to avoid IDE linting warnings before runtime injection
${ENV_ADMIN_USER}      ${EMPTY}
${ENV_ADMIN_PASS}      ${EMPTY}

*** Keywords ***
Initialize API Testing Matrix
    [Documentation]    Orchestrates global variables and logs an admin auth session 
    ...                automatically before the test execution suites step in.
    Load Environment Configuration
    Authenticate Admin Session Context

Load Environment Configuration
    [Documentation]    Dynamically sets up environmental variables at the suite level.
    ${config}=    Get Env Config    ${ENV}
    
    # Map infrastructure constants dynamically from the target matrix dictionary
    Set Global Variable    ${BASE_URL}        ${config['base_url']}
    Set Global Variable    ${TIMEOUT}         ${config['api_timeout']}
    Set Global Variable    ${DEBUG_MODE}      ${config['debug_mode']}
    Set Global Variable    ${ENV_ADMIN_USER}   ${config['admin_user']}
    Set Global Variable    ${ENV_ADMIN_PASS}   ${config['admin_pass']}   
    Log To Console    \n🚀 Target Environment Hook: [${ENV.upper()}] Routing to: ${BASE_URL}

Authenticate Admin Session Context
    [Documentation]    Hits POST /auth once globally utilizing runtime configuration parameters.
    ${auth_payload}=     Create Dictionary    username=${ENV_ADMIN_USER}    password=${ENV_ADMIN_PASS}  
    ${response}=         Create Authentication Token    ${auth_payload}    
    Should Be Equal As Integers    ${response.status_code}    200    
    ...    msg=Fatal: Global authentication setup script failed with code ${response.status_code}  
    ${json}=             Set Variable    ${response.json()}
    ${token}=            Set Variable    ${json['token']}   
    Set Global Variable  ${GLOBAL_AUTH_TOKEN}    ${token}
    Inject Session Authentication Token    ${token}
    Log To Console    🔑 Global Security Token Authorized & Injected Successfully.
