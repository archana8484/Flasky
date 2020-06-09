*** Settings ***
Resource                                    Resource/RegisterAndLogin.robot
Suite Setup                                 Display Landing Page
Suite Teardown                              Tear Down Context

*** Variables ***
${TEST_USERS_JSON}                          TestData/Users.json
${VIEW_USERS_JSON}                          TestData/UserTable.json
${LOGIN_BUTTON}                             //input[@value='Log In']

*** Test Cases ***
Set Up Test Users
    ${userData} =                           Load Test Data From Json File  ${TEST_USERS_JSON}
    Set Suite Variable                      ${testUsers}  ${userData}
    ${viewData} =                           Load Test Data From Json File  ${VIEW_USERS_JSON}
    Set Suite Variable                      ${usersinfo}  ${viewData}

Register As New User
    ${user1} =                              Get From Dictionary  ${testUsers}  User1
    Click Link                              Register
    Fill User Information                   ${user1.PersonalInfo}
    Submit
    Log in Page Should Appear

Login To The Application
    ${user1} =                              Get From Dictionary  ${testUsers}  User1
    Click Link                              Log In
    Enter User Name And Password To Login   ${user1.PersonalInfo}
    Click Element                           ${LOGIN_BUTTON}
    Page Should Contain	                    User Information
    @{user_results} =                       Get From Dictionary  ${usersinfo}  User1View
    Verify Displayed User Information       ${user_results}

Logout Of The Application
    Logout

Register With Existing User Credentials
    ${user1} =                              Get From Dictionary  ${testUsers}  User1
    Click Link                              Register
    Fill User Information                   ${user1.PersonalInfo}
    Submit
    Page Should Contain                     User ${user1.PersonalInfo.Username} is already registered.

Login Using Incorrect Credentials
    ${user1} =                              Get From Dictionary  ${testUsers}  User1
    Click Link                              Log In
    Enter User Name And Password To Login   ${user1.IncorrectLogin}
    Click Element                           ${LOGIN_BUTTON}
    Page Should Contain                     You provided incorrect login details