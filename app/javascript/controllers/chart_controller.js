import { Controller } from "@hotwired/stimulus";
import * as echarts from 'echarts/core';

// Import bar charts, all suffixed with Chart
import { BarChart } from 'echarts/charts';

// Import the tooltip, title, rectangular coordinate system, dataset and transform components
import {
  LegendComponent,
  TitleComponent,
  TooltipComponent,
  GridComponent,
  DatasetComponent,
  TransformComponent
} from 'echarts/components';

// Features like Universal Transition and Label Layout
import { LabelLayout, UniversalTransition } from 'echarts/features';

// Import the Canvas renderer
// Note that including the CanvasRenderer or SVGRenderer is a required step
import { CanvasRenderer } from 'echarts/renderers';

// Register the required components
echarts.use([
  BarChart,
  TitleComponent,
  TooltipComponent,
  GridComponent,
  DatasetComponent,
  TransformComponent,
  LabelLayout,
  UniversalTransition,
  CanvasRenderer,
  LegendComponent
]);


export default class extends Controller {
  static targets = [ 'card']
  static values = {
    item: String,
    title: String,
    yLabel: String,
    series: Array,
    seriesName: String,
    stores: Array
   }

  connect() {
      this.chart = echarts.init(this.cardTarget);

      let option = {
        title: { text: this.titleValue },
        tooltip: {},
        legend: { data: ['prices'] },
        xAxis: {
          type: 'category',
          data: this.storesValue
        },
        yAxis: { type: 'value', name: this.yLabelValue },
        series: [
          {
            type: 'bar',
            name: this.seriesNameValue,
            data: this.seriesValue
          }
        ]
      };

      this.chart.setOption(option);
  }

  draw() {
    this.chart.resize();
  }

  // avoid leaking browser memory
  disconnect() { this.chart.dispose(); }
}
