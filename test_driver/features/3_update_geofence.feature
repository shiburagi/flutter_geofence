Feature: Update Geofence
  The app should be able edit current geofence
  Scenario: Change geofence configuration
    Given I pause for 5 seconds
    When I tap the "geofence list" button
    And I tap the "13:45:14:32:55:99 edit" button
    And I tap the "using current GPS" button
    And I fill the "latitude" field with "10.0"	
    And I fill the "radius" field with "0.0"	
    And I fill the "WiFi name" field with "Test Wifi Name Edit"	
    And I fill the "BSSID" field with "13:45:14:32:55:98"	
    And I tap the "submit" button
    And I pause for 3 seconds
    Then I expect the "13:45:14:32:55:98" to be "Test Wifi Name Edit"
