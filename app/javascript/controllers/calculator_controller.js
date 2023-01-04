import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['measurement', 'units']

  updateUnits(evt) {
    const label = evt.currentTarget.selectedOptions[0].label;
    let value   = 'grams';

    if (label === 'volume') { value = 'millilitres'; }

    this.unitsTarget.innerText = value;
  }

  updatemeasurement(evt) {
    let grams      = evt.currentTarget.value * 1000
    let weightUnit = (this.unitsTarget.innerText === 'grams') ? 'kilograms' : 'litres';
    let kilograms  = `${evt.currentTarget.value} ${weightUnit} = ${grams}`;

    this.measurementTarget.innerText = kilograms;
  }
}
