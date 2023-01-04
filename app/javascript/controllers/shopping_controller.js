import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static outlets = [ "result" ]

  generateShoppingList(evt) {
    let items = this.resultOutlet.selectable.getSelectedItems().map((i) => i.node.id );
    let form  = evt.currentTarget;
    // have to check for pre-existing value and update it
    form.action += `?${new URLSearchParams({ selected_item_ids: items })}`
    console.log(items, form, form.action);

    // form.requestSubmit();
  }
}
