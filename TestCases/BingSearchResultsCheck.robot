*** Settings ***
Documentation     Bing search results number check using SeleniumLibrary.
Library           SeleniumLibrary

*** Variables ***
${home}      http://www.bing.com
${browser}        Chrome
${interval}     1

*** Test Cases ***
Valid Login
    [Setup]    open browser to home page
    search keyword    Michaels
    number of results should be    10
    sleep    10
    [Teardown]   close browser

*** Keywords ***
Open Browser To Home Page
    open browser    ${home}    ${browser}
    title should be    微软 Bing 搜索 - 国内版

Search Keyword
    [Arguments]    ${keyword}
    wait until page contains element    sb_form_q
    sleep    ${interval}
    input text    sb_form_q    ${keyword}
    sleep    ${interval}
    click element    sb_form_go

Number Of Results Should Be
    [Arguments]    ${num}
    wait until page contains element    b_results
    @{eles}    get webelements    css:li.b_algo
    length should be    ${eles}    ${num}
