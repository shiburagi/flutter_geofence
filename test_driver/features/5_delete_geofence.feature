Feature: Delete Geofence
  The app should be able remove geofence
  Scenario: Change geofence configuration
    Given I pause for 5 seconds
    When I tap the "geofence list" button
    Then I tap the "13:45:14:32:55:98 delete" button
