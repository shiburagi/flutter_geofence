Feature: Check status inside
  The app should be able check nearest geofence
  Scenario: Status Inside
    Given I pause for 5 seconds
    Then I expect the "status" to be "Inside"
