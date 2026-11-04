@ignore
Feature: Registro

  Background:
    * def generarCelular = function() { return '9' + Math.floor(10000000 + Math.random() * 90000000) }

  Scenario: Registro de usuarios

    # 01
    * def celularEmisor = generarCelular()
    * def celularReceptor = generarCelular()
    * def pin = '123456'

    # Registrar Emisor
    Given url authService
    And path '/auth/v1/register'
    And request
    """
    {
      "phone": "#(celularEmisor)",
      "fullName": "Emisor1515",
      "email": "emisor1515@test.com",
      "pin": "#(pin)"

    }
    """
    When method post
    Then status 201

    * def Emisorregistro = response

    # Registrar Receptor
    Given url authService
    And path '/auth/v1/register'
    And request
    """
    {
      "phone": "#(celularReceptor)",
      "fullName": "Receptor2020",
      "email": "receptor2020@test.com",
      "pin": "#(pin)"
    }
    """
    When method post
    Then status 201
    * def Receptorregistro = response


    * def resultado =
      """
      {
        idEmisor: '#(Emisorregistro.user.id)',
        idReceptor: '#(Receptorregistro.user.id)',
        celularEmisor: '#(Emisorregistro.user.phone)',
        celularReceptor: '#(Receptorregistro.user.phone)',
        pin: '#(pin)'
      }
    """
