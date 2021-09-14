# Robot Framework Guide #

This guide is about how to build a test project with Robot Framework, Based on Robot Framework version 4.1.0
## Develop Environment Setting ##

1. install Pycharm

2. install plugins

   1. Open Pycharm  
   2. File -> Settings -> PlugIns -> Search 'Robot Framework'  
   3. Install the following Plugins:  

   - Hyper Robot Framework Support
   - Run Robot framework file
   - Run Robot Framework TestCase

   ![pycharm_plugin.png](pycharm_plugin.png)

   [^]: Don't install Robot Framework Support, it will conflict with Hyper Robot Framework Support

3. install robot framework

```shell
pip install robotframework
```



## Project Structure

```
RepositoryName
├─Libs
├─DynamicData
|	├─Foo.py
|	├─Bar.py
|	└─...
├─StaticData
|	├─dev
|	|	├─Foo.robot
|	|	├─Bar.robot
|	|	└─...
|	├─tst
|	|	├─Foo.robot
|	|	├─Bar.robot
|	|	└─...
|	└─...
├─TestCases
|	├─Suite1
|	|	├─01.Foo.robot
|	|	├─02.Bar.robot
|	|	└─...
|	├─Suite2
|	|	├─01.Foo.robot
|	|	├─02.Bar.robot
|	|	└─...
|	├─__init__.robot
|	├─01.Foo.robot
|	├─02.Bar.robot
|	└─...
├─config.robot
└─requirements.txt
```

Folder *DynamicData* contains python files which generate test data, e.g. payloads of http request.

Folder *StaticData* contains test data, e.g. account, SKU, etc.

Folder *Libs* contains custom python libraries. 

Folder *TestCases* contains robot file of test cases.

*\__init__.robot* is an initialization file, it holds settings section, including *Library*, *Default Tags*, *Documentation*, *Metadata*, *Suite Setup*, *Suite Teardown*. 

[^]:  Initialization file can import variables from resource file, but can not pass it to test case files.



## Writing Test Cases

### Test Suite

Test suite could be a single test file or a folder contains test files.

### Test Case Files

There're mainly 4 sections in a robot file, they are *Settings, Variables, Testcases, Keywords*.

*Variables* section contains some private test data.

*Testcases* section contains test cases,  a test case file must have the Testcases section.

*Keywords* section contains keywords, which is similar as python funcition.



#### Settings in the Test Case section

##### Documentation

Used for specifying a test suite documentation

##### Metadata

Test files can also have other metadata than the documentation. This will be shown in test reports and logs.

```
Metadata    Author        Gene Xu
Metadata    Since         09/13/2021
Metadata    Version       1.0
Metadata    Executed At   %{TEST_ENV}
```

##### Library

Used for importing a python library or python module.

##### Resource

Used for importing a robot resource file which contains keywords.

##### Variable

Used for importing variables from a python module.

##### Suite Setup, Suite Teardown

Suite level Setup/Teardown, execute only once while running any number of test cases in this test file.

##### Test Setup, Test Teardown

Test level Setup/Teardown, execute once for running every selected test case in this test file.

##### Forced Tags, Default Tags

The forced and default values for test case level tags.

##### Test Template

See Suite Level Template section below.

### Test Case

#### Settings in the Test Case section

Test cases can also have their own settings. Setting names are always in the second column, where keywords normally are, and their values are in the subsequent columns. Setting names have square brackets around them to distinguish them from keywords. 

- *[Documentation]* - To describe test scenario and input data type.

- *[Tags]* -  To filter test cases, e.g. smoke,  block, mik, checkout .

- *[Setup]*, *[Teardown]* - test level setup and teardown

- *[Template]* - The test itself will contain only data to use as arguments to that keyword.

- *[Timeout]* - Used for setting a test case timeout. 

  ```
  *** Test Cases ***
  Test With Settings
      [Documentation]    Checkout MIK products with payment of credit card.
      [Tags]    smoke    mik    checkout
      [Template]    checkout possitive
      Log    channel mik checkout success!
  ```



### Suite Level Template

Test level template will make the test case fail if there's any failure, and number of loop is not counted by report. Sometimes, suite level template would be a better choice for test report platform, such as ReportPortal.

```
*** Settings ***
Test Template    login with invalid credentials should fail

*** Variables ***
${valid_password}    123
${valid_user}        unregistered@hotmail.com

*** Test Cases ***
Invalid User Name                 invalid          ${valid_password}
Invalid Password                  ${valid_user}    invalid
Invalid User Name and Password    invalid          invalid
Empty User Name                   ${EMPTY}         ${valid_password}
Empty Password                    ${valid_user}    ${EMPTY}
Empty User Name and Password      ${EMPTY}         ${EMPTY}

*** Keywords ***
login with invalid credentials should fail
    [Arguments]   ${username}    ${password}
    log   ${username}:${password}
```



## Naming Suggestion

- Using only alphabetic characters from a to z, numbers, underscore and space is recommended.
- The name of test case files and folders should start with numbers, in order to be executed in sequence.
- The name of test cases, keywords and variables are supposed to be meaningful.
- Test cases names should  be capital words and be separated by a single space.
- Tags should be lower letters, numbers and underscore.
- Keywords should be lower letters and be separated by a single spaces.
- Variables which are not defined in the robot file should be with name of upper letters. Such as variables from resource file and environment variables.



## Execution

#### Environment Variables

TEST_ENV  should be set to `dev` or `tst` 

#### Execute in Terminal

- ##### Execute all test cases under a folder

  `python -m robot TestCases` or `robot TestCases` 

- ##### Execute a single test file

  `python -m robot TestCases\01.Foo.robot`

- ##### Execute single test case

  `python -m robot -t "Specific Case Name" TestCases\01.Foo.robot`

#### Pycharm addons

- ##### Execute a single test file

  Right click on a file, or any line in a test case file except in Testcase section. Then press hotkey ctrl+shift+F10 or choose *Run '\*.robot'* on menu.

- ##### Execute single test case

  Right click on the case name of a test case, Then press hotkey ctrl+shift+F10 or choose *Run '.robot'* on menu. Then press hotkey ctrl+shift+F10 or choose *Run 'Case Name'* on menu.

![pycharm_context_menu.png](pycharm_context_menu.png)



## The dos and don'ts

- Libraries and resource file dependency  is supposed to be in single way. Diamond and mutual dependency is not allowed.
- Always use initialization file or suite setup when most test cases are related to third party service.
- Use robot.apis.logger in python keywords to show logs in test logs file.
- Don't use global variables to pass test data between test cases, use suite variables instead.



## Related Libraries

#### API Test

[RequestsLibrary Document](https://marketsquare.github.io/robotframework-requests/doc/RequestsLibrary.html)

#### Web-GUI Test

[SeleniumLibrary Document](https://robotframework.org/SeleniumLibrary/SeleniumLibrary.html)

#### App-GUI Test

[AppiumLibrary Document](http://serhatbolsu.github.io/robotframework-appiumlibrary/AppiumLibrary.html)  



## Reference

[Robot Framework documentation](https://robotframework.org/robotframework/)
