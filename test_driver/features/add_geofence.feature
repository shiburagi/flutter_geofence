Feature: Add Geofence
  The app should be able add new geofence
  Scenario: Create new geofence
    Given I pause for 5 seconds
    When I tap the "geofence list" button
    And I tap the "add geofence" button
    And I tap the "using current GPS" button
    Then I fill the "radius" field with "100.0"	
    And I fill the "WiFi name" field with "Test Wifi Name"	
    And I fill the "BSSID" field with "13:45:14:32:55:99"	
    Then I tap the "submit" button
    And I pause for 3 seconds
    Then I click back button
    And I expect "Test Wifi Name" exists in the list
