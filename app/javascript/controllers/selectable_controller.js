import { Controller } from "@hotwired/stimulus"
import Selectable from 'selectable.js';

export default class extends Controller {
  static outlets = ['shopping']
  static targets = ['item', 'input']

  update(e) {
    const input = e.currentTarget.querySelector('input');
    const item  = input.closest(".item");
    input.checked ? this.selectable.select(item) : this.selectable.deselect(item);
  }

  selectAll() {
    for ( const input of this.inputTargets ) {
      this.selectable.select( input.closest(".item") );
    }
  }

  connect() {
    const self      = this;
    self.selectable = new Selectable({
      filter: ".item",
      ignore: "input",
      appendTo: "#items",
      toggle: true
    });

    self.selectable.on("selecteditem", (item) => {
      item.node.querySelector("input").checked = true;
      this.shoppingOutlet.generateShoppingList();
    });

    self.selectable.on("deselecteditem", (item) => {
      item.node.querySelector("input").checked = false;
      this.shoppingOutlet.generateShoppingList();
    });

    self.clear();
  }

  clear() {
    this.selectable.clear();
  }

  itemConnectedCallback(item) {
    this.selectable.add([item]);
  }

  disconnect() {
    this.selectable.destroy();
  }
}
