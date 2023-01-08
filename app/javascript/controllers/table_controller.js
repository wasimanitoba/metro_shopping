import { Controller } from "@hotwired/stimulus"
import {
  AjaxModule,
  DownloadModule,
  ExportModule,
  HtmlTableImportModule,
  MenuModule,
  MoveColumnsModule,
  MoveRowsModule,
  PrintModule,
  PageModule,
  ResizeTableModule,
  ResponsiveLayoutModule,
  SortModule,
  Tabulator,
} from "tabulator-tables";

Tabulator.registerModule([
  AjaxModule,
  DownloadModule,
  ExportModule,
  HtmlTableImportModule,
  MenuModule,
  MoveColumnsModule,
  MoveRowsModule,
  PrintModule,
  ResizeTableModule,
  ResponsiveLayoutModule,
  PageModule,
  SortModule
]);

export default class extends Controller {
  static values = { url: String, title: String, height: String, columns: Array }
  static targets = ['container']

  downloadCSV() {
    self.table.download("csv", "data.csv");
  }

  downloadPDF() {
    self.table.download("pdf", "data.pdf", {
      orientation: "portrait",
      title: self.titleValue,
    });
  }

  downloadXLSX() { self.table.download("xlsx", "data.xlsx", { sheetName: self.titleValue }); }
  downloadJSON() { self.table.download("json", "data.json"); }
  downloadHTML() { self.table.download("html", "data.html", { style: true }); }

  connect() {
    const self = this;

    let headerMenu = [
      {
        label:"Hide Column",
        action: function(e, column){
            column.hide();
        }
      },
    ]

    let settings = {
      layout: "fitColumns",
      movableColumns:true,
      movableRows: true,
      paginationSize: 2,
      paginationCounter:"rows",
      responsiveLayout: true,
      autoResize: false,
    }

    if (self.hasHeightValue)  settings.maxHeight = self.heightValue;
    if (self.hasUrlValue)     settings.ajaxURL   = self.urlValue;
    if (self.hasColumnsValue) settings.columns   = self.columnsValue;

    self.table = new Tabulator(`#${self.containerTarget.id}`, settings);

    self.table.on("dataLoaded", function(_data){
      self.table.getColumns().forEach(column => { column.updateDefinition({ headerMenu: headerMenu }); });
    });
  }
}
