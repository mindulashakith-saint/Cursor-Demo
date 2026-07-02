import { LightningElement, wire } from "lwc";
import getAccounts from "@salesforce/apex/DemoCursorController.getAccounts";

const COLUMNS = [
  { label: "Name", fieldName: "name", type: "text" },
  { label: "Industry", fieldName: "industry", type: "text" },
  { label: "Phone", fieldName: "phone", type: "phone" },
  {
    label: "Website",
    fieldName: "website",
    type: "url",
    typeAttributes: {
      label: { fieldName: "website" },
      target: "_blank"
    }
  },
  {
    label: "Annual Revenue",
    fieldName: "annualRevenue",
    type: "currency",
    typeAttributes: {
      currencyCode: "USD",
      minimumFractionDigits: 0
    }
  },
  { label: "Billing City", fieldName: "billingCity", type: "text" }
];

export default class DemoCursor extends LightningElement {
  accounts;
  error;
  columns = COLUMNS;

  @wire(getAccounts)
  wiredAccounts({ data, error }) {
    if (data) {
      this.accounts = data;
      this.error = undefined;
    } else if (error) {
      this.error = error;
      this.accounts = undefined;
    }
  }

  get isLoading() {
    return !this.accounts && !this.error;
  }

  get hasError() {
    return !!this.error;
  }

  get isEmpty() {
    return Array.isArray(this.accounts) && this.accounts.length === 0;
  }

  get hasData() {
    return Array.isArray(this.accounts) && this.accounts.length > 0;
  }

  get errorMessage() {
    return "Unable to load accounts. Please try again later.";
  }

  get emptyMessage() {
    return "No accounts found.";
  }
}
