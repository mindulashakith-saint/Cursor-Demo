import { createElement } from "lwc";
import AccountDetails from "c/accountDetails";
import { getRecord } from "lightning/uiRecordApi";

const MOCK_RECORD_ID = "001000000000001AAA";

const mockAccountRecord = {
  apiName: "Account",
  id: MOCK_RECORD_ID,
  fields: {
    Name: { displayValue: null, value: "Acme Corporation" },
    Industry: { displayValue: null, value: "Technology" },
    Phone: { displayValue: null, value: "555-0100" },
    Website: { displayValue: null, value: "https://www.acme.example" },
    AnnualRevenue: { displayValue: null, value: 1000000 },
    NumberOfEmployees: { displayValue: null, value: 250 },
    BillingCity: { displayValue: null, value: "San Francisco" },
    BillingState: { displayValue: null, value: "CA" }
  }
};

const mockAccountRecordWithNullIndustry = {
  ...mockAccountRecord,
  fields: {
    ...mockAccountRecord.fields,
    Industry: { displayValue: null, value: null }
  }
};

describe("c-account-details", () => {
  afterEach(() => {
    while (document.body.firstChild) {
      document.body.removeChild(document.body.firstChild);
    }
  });

  function createComponent(recordId = MOCK_RECORD_ID) {
    const element = createElement("c-account-details", {
      is: AccountDetails
    });
    element.recordId = recordId;
    document.body.appendChild(element);
    return element;
  }

  it("renders account fields when getRecord returns data", () => {
    const element = createComponent();

    getRecord.emit(mockAccountRecord);

    return Promise.resolve().then(() => {
      const nameField = element.shadowRoot.querySelector('[data-field="name"]');
      const industryField = element.shadowRoot.querySelector(
        '[data-field="industry"]'
      );
      const spinner = element.shadowRoot.querySelector("lightning-spinner");

      expect(spinner).toBeNull();
      expect(nameField.textContent).toBe("Acme Corporation");
      expect(industryField.textContent).toBe("Technology");
    });
  });

  it("displays em dash when a field value is null", () => {
    const element = createComponent();

    getRecord.emit(mockAccountRecordWithNullIndustry);

    return Promise.resolve().then(() => {
      const industryField = element.shadowRoot.querySelector(
        '[data-field="industry"]'
      );

      expect(industryField.textContent).toBe("—");
    });
  });
});
