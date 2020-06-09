*** Settings ***
Resource                                Common.robot

*** Variables ***
${MAIN_URL}                             http://0.0.0.0:8080/
${USER_NAME_SELECTOR}                   id=username
${PASSWORD_SELECTOR}                    id=password
${FIRST_NAME_SELECTOR}                  id=firstname
${FAMILY_NAME_SELECTOR}                 id=lastname
${PHONE_SELECTOR}                       id=phone
${SUBMIT_SELECTOR}                      //input[@value='Register']
${USERINFO_TABLE}                       xpath=//*[@id="content"]

*** Keywords ***
Display Landing Page
    Open Browser                        ${MAIN_URL}  chrome
    Page Should Contain Link	        Demo app

Tear Down Context
    Close All Browsers

Fill User Information
    [Arguments]                         ${userinfo}
    Input User Data                     ${userinfo.Username}  ${userinfo.Password}  ${userinfo.FirstName}  ${userinfo.FamilyName}  ${userinfo.PhoneNo}

Input User Data
     [Arguments]                        ${uname}  ${pass}  ${first}  ${last}  ${phone}
     Input When Ready                   ${USER_NAME_SELECTOR}  ${uname}
     Input When Ready                   ${PASSWORD_SELECTOR}  ${pass}
     Input When Ready                   ${FIRST_NAME_SELECTOR}  ${first}
     Input When Ready                   ${FAMILY_NAME_SELECTOR}  ${last}
     Input When Ready                   ${PHONE_SELECTOR}  ${phone}

Submit
    Click Element                       ${SUBMIT_SELECTOR}

Log in Page Should Appear
    Wait Until Page Contains            Log In

Enter User Name And Password To Login
    [Arguments]                         ${credentials}
    Input When Ready                    ${USER_NAME_SELECTOR}  ${credentials.Username}
    Input When Ready                    ${PASSWORD_SELECTOR}  ${credentials.Password}

Verify Displayed User Information
    [Arguments]                         ${userresult}
    Wait Until Element Is Visible       ${USERINFO_TABLE}
    FOR    ${row}  IN  @{userresult}
        Check Table Row Values          ${USERINFO_TABLE}  ${row.Row}  ${row.Cell}  ${row.Values}
    END

Logout
   Click Link                            Log Out