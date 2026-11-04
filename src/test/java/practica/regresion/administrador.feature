Feature: administrador

  Scenario: Valide la transacción de la operación
     #Logim
    Given url adminService
    And path '/admin/v1/login'
    And request
    """
    {
      "username": "admin",
      "password": "superpassword"
    }
    """
    When method post
    Then status 200

    * def tokenAdmin = response.token

    # 02 transacciones globales
    Given url adminService
    And path '/admin/v1/transactions'
    And header x-channel = 'ADMIN'
    And header Authorization = 'Bearer ' + tokenAdmin
    When method get
    Then status 200

    * print response