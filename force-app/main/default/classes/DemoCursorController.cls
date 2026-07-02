public with sharing class DemoCursorController {
  private static final Integer MAX_RECORDS = 50;

  @AuraEnabled(cacheable=true)
  public static List<AccountSummary> getAccounts() {
    List<Account> accounts = [
      SELECT Id, Name, Industry, Phone, Website, AnnualRevenue, BillingCity
      FROM Account
      WITH SECURITY_ENFORCED
      ORDER BY Name ASC
      LIMIT :MAX_RECORDS
    ];

    List<AccountSummary> results = new List<AccountSummary>();
    for (Account accountRecord : accounts) {
      results.add(new AccountSummary(accountRecord));
    }
    return results;
  }

  public class AccountSummary {
    @AuraEnabled
    public String id { get; set; }
    @AuraEnabled
    public String name { get; set; }
    @AuraEnabled
    public String industry { get; set; }
    @AuraEnabled
    public String phone { get; set; }
    @AuraEnabled
    public String website { get; set; }
    @AuraEnabled
    public Decimal annualRevenue { get; set; }
    @AuraEnabled
    public String billingCity { get; set; }

    public AccountSummary(Account accountRecord) {
      this.id = accountRecord.Id;
      this.name = accountRecord.Name;
      this.industry = accountRecord.Industry;
      this.phone = accountRecord.Phone;
      this.website = accountRecord.Website;
      this.annualRevenue = accountRecord.AnnualRevenue;
      this.billingCity = accountRecord.BillingCity;
    }
  }
}
