import { Controller } from "@hotwired/stimulus"
import Selectable from 'selectable.js';

export default class extends Controller {
  static targets = ['item', 'input']

  update(e) {
    const input = e.currentTarget;
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

    for ( const input of this.inputTargets ) {
        if ( input.checked ) {
          self.selectable.select( input.closest(".item") );
        }
    }

    self.selectable.on("selecteditem", (item) => {
        item.node.querySelector("input").checked = true;
    });

    self.selectable.on("deselecteditem", (item) => {
      item.node.querySelector("input").checked = false;
    });
  }

  itemConnectedCallback(item) {
    this.selectable.add([item]);
  }

  disconnect() {
    this.selectable.destroy();
  }
}
