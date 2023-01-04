import { Controller } from "@hotwired/stimulus"
import { Tabulator, AjaxModule, DownloadModule, ExportModule } from "tabulator-tables";

export default class extends Controller {
  static values = { url: String, title: String, height: String, columns: Array }
  static targets = ['container']

  downloadCSV() {
    this.table.download("csv", "data.csv");
  }

  downloadPDF() {
    this.table.download("pdf", "data.pdf", {
      orientation: "portrait",
      title: this.titleValue,
    });
  }

  downloadXLSX() { this.table.download("xlsx", "data.xlsx", { sheetName: this.titleValue }); }
  downloadJSON() { this.table.download("json", "data.json"); }
  downloadHTML() { this.table.download("html", "data.html", { style: true }); }

  connect() {
    Tabulator.registerModule([AjaxModule, DownloadModule, ExportModule]);

    this.table = new Tabulator(`#${this.containerTarget.id}`, {
      layout: "fitColumns",
      addRowPos: "top",
      maxHeight: this.heightValue,
      ajaxURL: this.urlValue,
      columns: this.columnsValue
    });
  }
}
