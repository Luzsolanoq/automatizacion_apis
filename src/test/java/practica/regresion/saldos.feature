@ignore
Feature: Saldos

  Scenario: Registro de saldos iniciales

  # Asignar saldo Emisor
  * def saldolnicial = 0
  * def monto = 1500

  Given url walletService
  And path '/wallet/v1/deposit'
  And header Authorization = 'Bearer ' + tokenEmisor
  And request
  """
      {
      "amount":#(monto)
      }
  """
  When method post
  Then status 200

  * match response.newBalance == saldolnicial + monto
  * def saldoEmisor = response.newBalance

  # Asignar saldo Receptor
  * def saldolnicial = 0
  * def monto = 1000

  Given url walletService
  And path '/wallet/v1/deposit'
  And header Authorization = 'Bearer ' + tokenReceptor
  And request
  """
      {
      "amount":#(monto)
      }
  """
  When method post
  Then status 200

  * match response.newBalance == saldolnicial + monto
  * def saldoReceptor = response.newBalance

  * def resultados =
    """
    {
      saldoEmisor: '#(saldoEmisor)',
      saldoReceptor: '#(saldoReceptor)'
    }
    """

    * print 'SALDOS GENERADOS:', resultados
