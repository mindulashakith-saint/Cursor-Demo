import { createElement } from "lwc";
import DemoCursor from "c/demoCursor";
import getAccounts from "@salesforce/apex/DemoCursorController.getAccounts";

const MOCK_ACCOUNTS = [
  {
    id: "001000000000001AAA",
    name: "Acme Corporation",
    industry: "Technology",
    phone: "555-0100",
    website: "https://www.acme.example",
    annualRevenue: 1000000,
    billingCity: "San Francisco"
  }
];

jest.mock(
  "@salesforce/apex/DemoCursorController.getAccounts",
  () => {
    const { createApexTestWireAdapter } = require("@salesforce/sfdx-lwc-jest");
    return {
      default: createApexTestWireAdapter()
    };
  },
  { virtual: true }
);

describe("c-demo-cursor", () => {
  afterEach(() => {
    while (document.body.firstChild) {
      document.body.removeChild(document.body.firstChild);
    }
  });

  it("renders accounts in a datatable when data is returned", () => {
    const element = createElement("c-demo-cursor", {
      is: DemoCursor
    });
    document.body.appendChild(element);

    getAccounts.emit(MOCK_ACCOUNTS);

    return Promise.resolve().then(() => {
      const datatable = element.shadowRoot.querySelector("lightning-datatable");
      const spinner = element.shadowRoot.querySelector("lightning-spinner");

      expect(spinner).toBeNull();
      expect(datatable).not.toBeNull();
    });
  });

  it("shows a message when no accounts are returned", () => {
    const element = createElement("c-demo-cursor", {
      is: DemoCursor
    });
    document.body.appendChild(element);

    getAccounts.emit([]);

    return Promise.resolve().then(() => {
      const message = element.shadowRoot.querySelector(
        "p.slds-text-body_regular"
      );

      expect(message).not.toBeNull();
      expect(message.textContent).toBe("No accounts found.");
    });
  });
});
