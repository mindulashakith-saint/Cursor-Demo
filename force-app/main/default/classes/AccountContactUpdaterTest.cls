@IsTest
private class AccountContactUpdaterTest {
  @IsTest
  static void updateContactMailingCitiesFromAccounts_copiesBillingCityToContacts() {
    Account testAccount = new Account(
      Name = 'Acme Corp',
      BillingCity = 'Melbourne'
    );
    insert testAccount;

    Contact primaryContact = new Contact(
      FirstName = 'Jane',
      LastName = 'Doe',
      AccountId = testAccount.Id,
      MailingCity = 'Sydney'
    );
    Contact secondaryContact = new Contact(
      FirstName = 'John',
      LastName = 'Smith',
      AccountId = testAccount.Id,
      MailingCity = 'Brisbane'
    );
    insert new List<Contact>{ primaryContact, secondaryContact };

    Test.startTest();
    AccountContactUpdater.updateContactMailingCitiesFromAccounts(
      new List<Id>{ testAccount.Id }
    );
    Test.stopTest();

    List<Contact> updatedContacts = [
      SELECT MailingCity
      FROM Contact
      WHERE AccountId = :testAccount.Id
      ORDER BY LastName
    ];

    System.assertEquals(
      2,
      updatedContacts.size(),
      'Both contacts should be updated.'
    );
    System.assertEquals(
      'Melbourne',
      updatedContacts[0].MailingCity,
      'First contact MailingCity should match BillingCity.'
    );
    System.assertEquals(
      'Melbourne',
      updatedContacts[1].MailingCity,
      'Second contact MailingCity should match BillingCity.'
    );
  }

  @IsTest
  static void updateContactMailingCitiesFromAccounts_setsNullWhenBillingCityIsNull() {
    Account testAccount = new Account(
      Name = 'Null City Account',
      BillingCity = null
    );
    insert testAccount;

    Contact testContact = new Contact(
      FirstName = 'Null',
      LastName = 'City',
      AccountId = testAccount.Id,
      MailingCity = 'Perth'
    );
    insert testContact;

    Test.startTest();
    AccountContactUpdater.updateContactMailingCitiesFromAccounts(
      new List<Id>{ testAccount.Id }
    );
    Test.stopTest();

    Contact updatedContact = [
      SELECT MailingCity
      FROM Contact
      WHERE Id = :testContact.Id
    ];

    System.assertEquals(
      null,
      updatedContact.MailingCity,
      'MailingCity should be cleared when BillingCity is null.'
    );
  }

  @IsTest
  static void updateContactMailingCitiesFromAccounts_handlesEmptyAndNullInputs() {
    Account testAccount = new Account(
      Name = 'No Update Account',
      BillingCity = 'Adelaide'
    );
    insert testAccount;

    Contact testContact = new Contact(
      FirstName = 'No',
      LastName = 'Update',
      AccountId = testAccount.Id,
      MailingCity = 'Canberra'
    );
    insert testContact;

    Test.startTest();
    AccountContactUpdater.updateContactMailingCitiesFromAccounts(null);
    AccountContactUpdater.updateContactMailingCitiesFromAccounts(
      new List<Id>()
    );
    Test.stopTest();

    Contact unchangedContact = [
      SELECT MailingCity
      FROM Contact
      WHERE Id = :testContact.Id
    ];

    System.assertEquals(
      'Canberra',
      unchangedContact.MailingCity,
      'Contact should remain unchanged for null or empty input.'
    );
  }

  @IsTest
  static void updateContactMailingCitiesFromAccounts_handlesBulkUpdates() {
    List<Account> accounts = new List<Account>();
    for (Integer index = 0; index < 200; index++) {
      accounts.add(
        new Account(
          Name = 'Bulk Account ' + index,
          BillingCity = 'City ' + index
        )
      );
    }
    insert accounts;

    List<Contact> contacts = new List<Contact>();
    for (Account accountRecord : accounts) {
      contacts.add(
        new Contact(
          FirstName = 'Bulk',
          LastName = 'Contact ' + accountRecord.Name,
          AccountId = accountRecord.Id,
          MailingCity = 'Original City'
        )
      );
    }
    insert contacts;

    List<Id> accountIds = new List<Id>();
    for (Account accountRecord : accounts) {
      accountIds.add(accountRecord.Id);
    }

    Test.startTest();
    AccountContactUpdater.updateContactMailingCitiesFromAccounts(accountIds);
    Test.stopTest();

    Integer matchingContacts = [
      SELECT COUNT()
      FROM Contact
      WHERE AccountId IN :accountIds AND MailingCity LIKE 'City %'
    ];

    System.assertEquals(
      200,
      matchingContacts,
      'All related contacts should receive their account BillingCity.'
    );
  }
}
