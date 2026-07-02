public with sharing class AccountContactUpdater {
  public static void updateContactMailingCitiesFromAccounts(
    List<Id> accountIds
  ) {
    if (accountIds == null || accountIds.isEmpty()) {
      return;
    }

    Map<Id, Account> accountsById = new Map<Id, Account>(
      [
        SELECT Id, BillingCity
        FROM Account
        WHERE Id IN :accountIds
        WITH SECURITY_ENFORCED
      ]
    );

    if (accountsById.isEmpty()) {
      return;
    }

    List<Contact> contactsToUpdate = [
      SELECT Id, AccountId, MailingCity
      FROM Contact
      WHERE AccountId IN :accountsById.keySet()
      WITH SECURITY_ENFORCED
    ];

    for (Contact contactRecord : contactsToUpdate) {
      contactRecord.MailingCity = accountsById.get(contactRecord.AccountId)
        .BillingCity;
    }

    if (!contactsToUpdate.isEmpty()) {
      SObjectAccessDecision updateDecision = Security.stripInaccessible(
        AccessType.UPDATABLE,
        contactsToUpdate
      );
      update updateDecision.getRecords();
    }
  }
}
