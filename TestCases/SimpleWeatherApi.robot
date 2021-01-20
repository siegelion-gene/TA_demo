*** Settings ***
Library               RequestsLibrary

*** Variables ***
${host}     http://apis.juhe.cn
&{path}     query=/simpleWeather/query
${api_key}     7a4d2d68cc13c5d3fbfc6edd69dff9e1

*** Test Cases ***
SimpleWeather
    [Template]     Query
    深圳    reason=查询成功!
    火星    reason=查询成功!
    旧金山    reason=暂不支持该城市    error_code=207301


*** Keywords ***
Query
    [Arguments]    ${city}    &{asserts}
    ${params}    create dictionary    city=${city}    key=${api_key}
    create session    host    ${host}
    ${resp}    get on session   host    ${path.query}    params=${params}
    Status Should Be    200    ${resp}
    ${data}    set variable    ${resp.json()}

    FOR    ${k}    ${v}    IN    &{asserts}
        should be equal as strings      ${data}[${k}]    ${v}
    END





