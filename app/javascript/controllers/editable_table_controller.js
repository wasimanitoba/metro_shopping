import { Controller } from "@hotwired/stimulus"
import { Tabulator, EditModule } from "tabulator-tables";

export default class extends Controller {
  static values = { url: String, columns: Array, stores: Object, items: Array }
  static targets = ['container']

  addRows() {
    // the dropdown lists are going off-screen when there are too few rows
    // an error is raised if we try this in the connect() method, so have the user do it manually.
    for (let index = 0; index < 12; index++) {
      this.table.addRow({});
    }
  }

  save() {
    const self      = this;
    const csrfToken = document.querySelector("[name='csrf-token']").content
    let data        = { bulk_purchases: this.table.rowManager.rows.map((row) => row.data) };
    let url         = '/bulk_create';

    // Default options are marked with *
    fetch(url, {
      method: 'POST',
      mode: 'cors',
      cache: 'no-cache',
      credentials: 'same-origin',
      headers: {
        'Content-Type': 'application/json',
        "X-CSRF-Token": csrfToken,
      },
      redirect: 'follow',
      referrerPolicy: 'no-referrer',
      body: JSON.stringify(data)
    }).then((response)=>{

      if (!response.ok) { throw response.statusText; }

      alert('Successfully uploaded!')

      self.table.clearData();

      return;

    }).catch((err)=>{
      alert(`Failed to upload! ${err}`)
    });
  }

initialize() {
  Tabulator.registerModule([EditModule]);
  let stores = this.storesValue
  let items = this.itemsValue
  this.table = new Tabulator(`#${this.containerTarget.id}`, {
    layout: "fitColumns",
    addRowPos: "top",
    columns: [
      { title: 'Product', field: 'item_package', editor: 'list', editorParams: { values: items }, clearable:true, listOnEmpty:true },
      { title: 'Store', field: 'store', editor: 'list', editorParams: { values: stores }, clearable:true, listOnEmpty:true },
      { title: 'Quantity', field: 'quantity', sorter: 'number', editor: true },
      { title: 'Total Price ($)', field: 'price', sorter: 'number', editor: true },
      // TODO: Use Luxon to impose format (https://tabulator.info/docs/5.4/edit#editor-date) and add min/max validations as follows:
      // min: this.minDateValue,
      // max: this.maxDateValue,
      // format:"dd/MM/yyyy", // the format of the date value stored in the cell
      { title: "Purchase Date", field: "date", editor: "date", editorParams: { elementAttributes: { title: "slide bar to choose option" } } }
    ]
  });
}
}
