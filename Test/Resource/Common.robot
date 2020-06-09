*** Settings ***
Library                                      SeleniumLibrary
Library                                      Collections
Library                                      OperatingSystem

*** Keywords ***
Input When Ready
    [Arguments]                              ${selector}  ${text}
    Wait Until Element Is Visible            ${selector}
    Input Text                               ${selector}  ${text}

Load Test Data From Json File
    [Arguments]                              ${json}
    ${data} =                                Get File    ${json}
    ${dictionary} =                          Evaluate    json.loads('''${data}''')  json
    ${robotDictionary} =                     Convert Python Dictionary    ${dictionary}
    [Return]                                 ${robotDictionary}

Convert Python Dictionary
    [Arguments]                              ${python_dict}
    [Documentation]                          Converts Python dictionary to Robot dictionary.

    @{keys} =                                Get Dictionary Keys  ${python_dict}
    ${robot_dict} =                          Create Dictionary

    FOR  ${key}  IN  @{keys}
        ${type} =                            Get Variable Type  ${python_dict['${key}']}
        ${converted_dict} =                  Run Keyword If  '${type}' == 'dict'  Convert Python Dictionary  ${python_dict['${key}']}
         ...                                 ELSE IF         '${type}' == 'list'  Convert Dictionaries Inside List  ${python_dict['${key}']}
         ...                                 ELSE             Set To Dictionary  ${robot_dict}  ${key}=${python_dict['${key}']}
        Run Keyword If  '${type}' == 'dict'  Set To Dictionary  ${robot_dict}  ${key}=${converted_dict}
        Run Keyword If  '${type}' == 'list'  Set To Dictionary  ${robot_dict}  ${key}=${converted_dict}
    END

    [Return]                                 ${robot_dict}

Convert Dictionaries Inside List
    [Arguments]                              ${list}
    ${converted_list} =                      Create List

    FOR  ${item}  IN  @{list}
       ${item_type} =                        Get Variable Type    ${item}
       ${converted_item} =                   Run Keyword If  '${item_type}' == 'dict'  Convert Python Dictionary    ${item}
        ...                                  ELSE IF         '${item_type}' == 'list'  Convert Dictionaries Inside List  ${item}
        ...                                  ELSE             Append To List    ${converted_list}  ${item}
       Run Keyword If  '${item_type}' == 'dict'    Append To List  ${converted_list}  ${converted_item}
       Run Keyword If  '${item_type}' == 'list'    Append To List  ${converted_list}  ${converted_item}
    END
    [Return]                                 ${converted_list}

Get Variable Type
    [Arguments]                              ${variable}
    ${passed} =                              Run Keyword And Return Status   Evaluate  type(${variable}).__name__
    ${type} =                                Run Keyword If  ${passed}       Evaluate  type(${variable}).__name__
    ...                                      ELSE   Return From Keyword  string
    [Return]                                 ${type}

Check Table Row Values
    [Arguments]                              ${table}  ${row}  ${cell}  ${values}
    ${i} =                                   Set Variable  ${cell}
    FOR  ${value}  IN  @{values}
        ${actual} =                          Get Table Cell  ${table}  ${row}  ${i}
        Should Be Equal                      ${actual}  ${value}
        ${i} =                               Evaluate  ${i} + 1
    END