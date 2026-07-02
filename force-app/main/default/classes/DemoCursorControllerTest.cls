@IsTest
private class DemoCursorControllerTest {
  @IsTest
  static void getAccounts_returnsAccountSummaries() {
    Account testAccount = new Account(
      Name = 'Demo Account',
      Industry = 'Technology',
      Phone = '555-0100',
      Website = 'https://example.com',
      AnnualRevenue = 500000,
      BillingCity = 'Melbourne'
    );
    insert testAccount;

    Test.startTest();
    List<DemoCursorController.AccountSummary> results = DemoCursorController.getAccounts();
    Test.stopTest();

    System.assertEquals(
      1,
      results.size(),
      'One account summary should be returned.'
    );
    DemoCursorController.AccountSummary summary = results[0];
    System.assertEquals(testAccount.Id, summary.id, 'Account Id should match.');
    System.assertEquals(
      'Demo Account',
      summary.name,
      'Account name should match.'
    );
    System.assertEquals(
      'Technology',
      summary.industry,
      'Industry should match.'
    );
    System.assertEquals('555-0100', summary.phone, 'Phone should match.');
    System.assertEquals(
      'https://example.com',
      summary.website,
      'Website should match.'
    );
    System.assertEquals(
      500000,
      summary.annualRevenue,
      'Annual revenue should match.'
    );
    System.assertEquals(
      'Melbourne',
      summary.billingCity,
      'Billing city should match.'
    );
  }

  @IsTest
  static void getAccounts_returnsEmptyListWhenNoAccountsExist() {
    Test.startTest();
    List<DemoCursorController.AccountSummary> results = DemoCursorController.getAccounts();
    Test.stopTest();

    System.assertEquals(
      0,
      results.size(),
      'No account summaries should be returned.'
    );
  }

  @IsTest
  static void getAccounts_respectsRecordLimit() {
    List<Account> accounts = new List<Account>();
    for (Integer index = 0; index < 55; index++) {
      accounts.add(new Account(Name = 'Limit Test Account ' + index));
    }
    insert accounts;

    Test.startTest();
    List<DemoCursorController.AccountSummary> results = DemoCursorController.getAccounts();
    Test.stopTest();

    System.assertEquals(
      50,
      results.size(),
      'Results should be limited to 50 accounts.'
    );
  }
}
