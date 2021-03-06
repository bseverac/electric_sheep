Feature: MongoDB Dump
  In order to backup my data
  As a backup operator
  I want to dump my MongoDB database

  Scenario: Create a dump
    Given I tell the sheep to work on job "mongodb-dump"
    Then a MongoDB dump of the database should have been created

  Scenario: Authentication error on a dump
    Given I tell the sheep to work on failing job "mongodb-dump-auth-fail"
    Then I am notified the mongodump command failed
