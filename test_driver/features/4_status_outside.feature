Feature: Check status inside
  The app should be able check nearest geofence
  Scenario: Status Outside
    Given I pause for 5 seconds
    Then I expect the "status" to be "Outside"
