import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['placeholder', 'container']
  static values  = { placeholder: Array }

  connect() {
    const self   = this;
    const looper = () => {
      let rand = Math.floor(Math.random() * self.placeholderValue.length);
      let item = self.placeholderValue[rand];

      let previous = this.containerTarget.querySelector(`[data-controller="chart"]:not(.hidden)`);

      if (previous) { previous.classList.add('hidden'); }
      this.containerTarget.querySelector(`[data-chart-item-value="${item}"]`).classList.remove('hidden');

      let a    = document.createElement('a');
      a.href   = `/items/deals?item_name=${item}`;

      a.innerText = item;

      self.placeholderTarget.innerHTML = a.outerHTML;
    }

     setTimeout(()=>{ looper(); }, 750);

     setInterval(()=>{ looper(); }, 7000);
  }
}
