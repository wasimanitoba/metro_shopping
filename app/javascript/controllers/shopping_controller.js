import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static outlets = [ "selectable"]
  static targets = [ "form", "package" ]

  selection = {}

  all() {
    this.selectableOutlet.selectAll();
    this.generateShoppingList();
  }

  clear() {
    this.selectableOutlet.clear();
    this.generateShoppingList();
  }

  gather() {
    if (this.hasSelectableOutlet) {
      let selectedPackages       = this.selectableOutlet.selectable.getSelectedItems();
      this.selection['packages'] = [];
      this.selection['items']    = [];

      selectedPackages.map((i) => {
        let value = i.node.querySelector('select').value;

        if (value) { this.selection['packages'].push(value);     }
        else       { this.selection['items'].push(i.node.id); }
      });
    }
  }

  generateShoppingList() {
    this.gather();

    // Intended for each form to be used independently but right now we're invoking the first form every time
    let form  = this.formTarget;
    let items = this.selection['items'];
    let pkg   = this.selection['packages'];

    let checkoutParams = new URLSearchParams({ pkg, items })
    form.action = `/checkout/?${checkoutParams}`;

    form.requestSubmit();
  }
}
