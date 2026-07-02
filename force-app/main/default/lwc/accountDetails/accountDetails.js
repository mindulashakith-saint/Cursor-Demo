import { LightningElement, api, wire } from "lwc";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import NAME_FIELD from "@salesforce/schema/Account.Name";
import INDUSTRY_FIELD from "@salesforce/schema/Account.Industry";
import PHONE_FIELD from "@salesforce/schema/Account.Phone";
import WEBSITE_FIELD from "@salesforce/schema/Account.Website";
import ANNUAL_REVENUE_FIELD from "@salesforce/schema/Account.AnnualRevenue";
import NUMBER_OF_EMPLOYEES_FIELD from "@salesforce/schema/Account.NumberOfEmployees";
import BILLING_CITY_FIELD from "@salesforce/schema/Account.BillingCity";
import BILLING_STATE_FIELD from "@salesforce/schema/Account.BillingState";

const FIELDS = [
  NAME_FIELD,
  INDUSTRY_FIELD,
  PHONE_FIELD,
  WEBSITE_FIELD,
  ANNUAL_REVENUE_FIELD,
  NUMBER_OF_EMPLOYEES_FIELD,
  BILLING_CITY_FIELD,
  BILLING_STATE_FIELD
];

const EMPTY_VALUE = "—";

export default class AccountDetails extends LightningElement {
  @api recordId;

  account;
  error;

  @wire(getRecord, { recordId: "$recordId", fields: FIELDS })
  wiredAccount({ data, error }) {
    if (data) {
      this.account = data;
      this.error = undefined;
    } else if (error) {
      this.error = error;
      this.account = undefined;
    }
  }

  get isLoading() {
    return !this.account && !this.error;
  }

  get hasError() {
    return !!this.error;
  }

  get errorMessage() {
    if (!this.error) {
      return EMPTY_VALUE;
    }
    return this.error.body?.message || "Unable to load account details.";
  }

  get name() {
    return this.formatText(getFieldValue(this.account, NAME_FIELD));
  }

  get industry() {
    return this.formatText(getFieldValue(this.account, INDUSTRY_FIELD));
  }

  get phone() {
    return this.formatText(getFieldValue(this.account, PHONE_FIELD));
  }

  get billingCity() {
    return this.formatText(getFieldValue(this.account, BILLING_CITY_FIELD));
  }

  get billingState() {
    return this.formatText(getFieldValue(this.account, BILLING_STATE_FIELD));
  }

  get numberOfEmployees() {
    const value = getFieldValue(this.account, NUMBER_OF_EMPLOYEES_FIELD);
    if (value === null || value === undefined) {
      return EMPTY_VALUE;
    }
    return value;
  }

  get annualRevenue() {
    const value = getFieldValue(this.account, ANNUAL_REVENUE_FIELD);
    if (value === null || value === undefined) {
      return null;
    }
    return value;
  }

  get hasAnnualRevenue() {
    return this.annualRevenue !== null;
  }

  get website() {
    const value = getFieldValue(this.account, WEBSITE_FIELD);
    if (value === null || value === undefined || value === "") {
      return null;
    }
    return value;
  }

  get hasWebsite() {
    return this.website !== null;
  }

  get emptyDisplay() {
    return EMPTY_VALUE;
  }

  get websiteDisplay() {
    return EMPTY_VALUE;
  }

  formatText(value) {
    if (value === null || value === undefined || value === "") {
      return EMPTY_VALUE;
    }
    return value;
  }
}
