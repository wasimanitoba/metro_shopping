import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static outlets = [ "selectable"]
  static targets = ["form" ]

  selectedItems = []

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
      this.selectedItems = this.selectableOutlet.selectable.getSelectedItems().map((i) => i.node.id );
    }
  }

  generateShoppingList() {
    let form = this.formTarget;

    this.gather();

    form.action = `/checkout/?${new URLSearchParams({ selected_item_ids: this.selectedItems })}`

    form.requestSubmit();
  }
}
