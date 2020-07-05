Feature: Delete Geofence
  The app should be able remove geofence
  Scenario: Change geofence configuration
    Given I pause for 5 seconds
    When I tap the "geofence list" button
    And I tap the "13:45:14:32:55:98 delete" button
    And I tap the "confirm" button
    Then I expect the "13:45:14:32:55:98" not exist
