@ignore
Feature: Login

  Scenario: Login
    #Logim
    Given url authService
    And path '/auth/v1/login'
    And request
    """
    {
      "phone": "#(phone)",
      "pin": "#(pin)"
    }
    """
    When method post
    Then status 200
    * def token = response.token




