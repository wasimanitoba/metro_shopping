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
  ResizeTableModule,
  ResponsiveLayoutModule,
  SortModule,
  PageModule,
  PrintModule
]);

export default class extends Controller {
  static values = { url: String, fit: Boolean, title: String, height: String, columns: Array }
  static targets = ['container', 'footer']

  downloadHTML() { this.table.download("html", "data.html", { style: true }); }

  print() { this.table.print(false, true); }

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
      movableColumns:true,
      movableRows: true,
      pagination:"local",
      paginationSize: 10,
      paginationCounter:"rows",
      responsiveLayout: true,
      autoResize: false,
      printAsHtml: true,
      footerElement: `#${this.footerTarget.id}`,
      placeholder:"No Data Available"
    }

    if (this.hasFitValue && this.fitValue) { settings.layout = "fitColumns"; }

    if (self.hasHeightValue)  settings.maxHeight = self.heightValue;
    if (self.hasUrlValue)     settings.ajaxURL   = self.urlValue;
    if (self.hasColumnsValue) settings.columns   = self.columnsValue;

    self.table = new Tabulator(`#${self.containerTarget.id}`, settings);

    self.table.on("dataLoaded", function(_data){
      self.table.getColumns().forEach(column => { column.updateDefinition({ headerMenu: headerMenu }); });
    });
  }
}
