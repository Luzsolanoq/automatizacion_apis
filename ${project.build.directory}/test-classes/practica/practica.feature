Feature: Mi estructura

  Background:
    * def generarCelular = function() { return Math.floor(Math.random() * 100) }


  Scenario: Primer escenario
    * def n1 = generarCelular()
    * print 'n1:', n1

  Scenario: Segundo escenario
    * def n2 = generarCelular()
    * print 'n2:', n2