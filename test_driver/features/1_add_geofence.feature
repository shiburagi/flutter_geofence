Feature: Add Geofence
  The app should be able add new geofence
  Scenario: Create new geofence
    Given I pause for 5 seconds
    When I tap the "geofence list" button
    And I tap the "add geofence" button
    And I tap the "using current GPS" button
    And I fill the "radius" field with "100.0"	
    And I fill the "WiFi name" field with "Test Wifi Name"	
    And I fill the "BSSID" field with "13:45:14:32:55:99"	
    And I tap the "submit" button
    And I pause for 3 seconds
    And I click back button
    Then I expect the "13:45:14:32:55:99" to be "Test Wifi Name"
