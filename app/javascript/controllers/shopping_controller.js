import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static outlets = [ "selectable" ]

  selectedItems = []

  connect() {
    this.gather();
  }

  all() {
    this.selectableOutlet.selectAll();
  }

  clear() {
    this.selectableOutlet.selectable.clear();
  }

  gather() {
    if (!this.hasSelectableOutlet) return

    this.selectedItems = this.selectableOutlet.selectable.getSelectedItems().map((i) => i.node.id );
  }

  generateShoppingList(evt) {
    let form = evt.currentTarget;

    this.gather();

    form.action = `/checkout/?${new URLSearchParams({ selected_item_ids: this.selectedItems })}`

    form.requestSubmit();
  }
}
