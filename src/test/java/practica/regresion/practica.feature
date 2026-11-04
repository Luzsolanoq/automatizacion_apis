Feature: Regresion
  Background:
    * def usuarios = callonce read('classpath:practica/regresion/registro.feature')
    * def cEmisor = usuarios.resultado.celularEmisor
    * def cReceptor = usuarios.resultado.celularReceptor
    * def pin = usuarios.resultado.pin

    # Login Emisor
    * def loginEmisor = call read('classpath:practica/regresion/login.feature') {phone:'#(cEmisor)',pin:'#(pin)'}
    * def tokenEmisor = loginEmisor.token

    # Login Receptor
    * def loginReceptor = call read('classpath:practica/regresion/login.feature') {phone:'#(cReceptor)',pin:'#(pin)'}
    * def tokenReceptor = loginReceptor.token


    * def saldos = callonce read('classpath:practica/regresion/saldos.feature'){ tokenEmisor: '#(tokenEmisor)', tokenReceptor: '#(tokenReceptor)'}
    * def saldoEmisor = saldos.resultados.saldoEmisor
    * def saldoReceptor = saldos.resultados.saldoReceptor

  @Prueba1
  Scenario: Registro de usuarios
    # Validacion para un usuario existente
    Given url authService
    And path '/auth/v1/register'
    And request
    """
    {
      "phone": "#(cEmisor)",
      "fullName": "Emisor1515",
      "email": "emisor1515@test.com",
      "pin": "#(pin)"
    }
    """
    When method post
    Then status 409

    # --------------------------------------------------------------------------------------------------------------------------------------------------------
  Scenario: Transferencia del Usuario Emisor al Receptor
    * def id_receptor = usuarios.resultado.idReceptor

    # 02 Realiza una transferencia de saldo
    Given url transactionService
    And path '/transaction/v1/transfer'
    And header Authorization = 'Bearer ' + tokenEmisor
    And request
    """
    {
      "recipientId": "#(id_receptor)",
      "amount": 450,
      "description": "Pago de Servicios",
      "categoryId": "cat_00"
    }
    """
    When method post
    Then status 200

    # 03 Valide la transacción
    * match response.status == "COMPLETED"

    # 04 Guardar el codigo de la transaccion
    * def c_transaccion = response.referenceCode
    * karate.write({ referenceCode: c_transaccion }, 'transferencia.json')
    * print c_transaccion

    # 05 Consulta de saldo al usuario Emisor
    Given url walletService
    And path '/wallet/v1/balance'
    And header Authorization = 'Bearer ' + tokenEmisor
    When method get
    Then status 200

    # 06 Validar la disminución del saldo comparando con el saldo inicial (Escenario 1, paso 3)
    * match response.balance == saldoEmisor-450
    * def seactualizado = response.balance
    * print seactualizado

    # --------------------------------------------------------------------------------------------------------------------------------------------------------
  Scenario: Validación de Transferencia en Receptor
    # 02 Consulta de saldo al usuario Receptor
    Given url walletService
    And path '/wallet/v1/balance'
    And header Authorization = 'Bearer ' + tokenReceptor
    When method get
    Then status 200

    # 03 Valide el incremento de monto comparando el saldo actual con el saldo inicial (Escenario 1, paso 3)
    * match response.balance == saldoReceptor+450
    * def sractualizado = response.balance
    * print sractualizado

    # 04 Consulte las transacciones del usuario Receptor
    Given url walletService
    And path '/wallet/v1/transactions'
    And header Authorization = 'Bearer ' + tokenReceptor
    When method get
    Then status 200

    * def r_referenciaCode = karate.jsonPath(response, '$[*].referenceCode')
    * print r_referenciaCode

    # 05 Valida el número de transacción (compáralo con el número de transacción del Escenario 2, paso 4)
    * def datosTransferencia = read('file:target/transferencia.json')
    * print datosTransferencia.referenceCode

    * match r_referenciaCode contains datosTransferencia.referenceCode
