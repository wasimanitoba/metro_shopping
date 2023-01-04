import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static outlets = [ "selectable" ]

  generateShoppingList(evt) {
    let items = this.selectableOutlet.selectable.getSelectedItems().map((i) => i.node.id );
    let form  = evt.currentTarget;
    // have to check for pre-existing value and update it
    form.action += `?${new URLSearchParams({ selected_item_ids: items })}`

    form.requestSubmit();
  }
}
