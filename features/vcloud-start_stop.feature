Feature: 'vcloud-start_stop' is a command-line tool 
  In order to use 'vcloud-start_stop' from the CLI
  I want it to act as a typical CLI tool
  So it meets expectations

  Scenario: CLI just runs
    When I get help for "vcloud-start_stop"
    Then the exit status should be 0
    And the banner should be present
    And the banner should document that this app takes options
    And the following options should be documented:
      |--version|
      |--user|
      |--password|
      |--org|
      |--vdc|
      |--power_vdc|
      |--vapps|
    And the app should exit if you choose power_vdc and vapp
    And the app should exit if you don't sp
