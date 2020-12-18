<template>
  <div>
    <v-container class="mx-auto">
      <v-row>
        <v-col cols="12" sm="6" md="4" lg="4" xl="3" class="mx-auto">
          <v-card>
            <BarChart class="chart" :chartData="chartData" :options="options" :height="height" :width="width"/>
            <v-btn>button</v-btn>
            <v-btn>button</v-btn>
            <v-btn>button</v-btn>
            <v-btn>button</v-btn>
            <v-btn>button</v-btn>
            <v-btn>button</v-btn>
            <v-btn>button</v-btn>
            <v-btn>button</v-btn>
            <v-btn>button</v-btn>
            <v-btn>button</v-btn>
          </v-card>
        </v-col>
        <v-col cols="12" sm="6" md="4" lg="4" xl="3" class="mx-auto">
          <v-card>
            <BarChart class="chart" :chartData="chartData" :options="options" :height="height" :width="width"/>
            <v-btn>button</v-btn>
            <v-btn>button</v-btn>
            <v-btn>button</v-btn>
            <v-btn>button</v-btn>
            <v-btn>button</v-btn>
            <v-btn>button</v-btn>
            <v-btn>button</v-btn>
            <v-btn>button</v-btn>
            <v-btn>button</v-btn>
            <v-btn>button</v-btn>
          </v-card>
        </v-col>
        <v-col cols="12" sm="6" md="4" lg="4" xl="3" class="mx-auto">
          <v-card>
            <BarChart class="chart" :chartData="chartData" :options="options" :height="height" :width="width"/>
            <v-btn>button</v-btn>
            <v-btn>button</v-btn>
            <v-btn>button</v-btn>
            <v-btn>button</v-btn>
            <v-btn>button</v-btn>
            <v-btn>button</v-btn>
            <v-btn>button</v-btn>
            <v-btn>button</v-btn>
            <v-btn>button</v-btn>
            <v-btn>button</v-btn>
          </v-card>
        </v-col>
      </v-row>
    </v-container>
  </div>
</template>

<script>
import BarChart from '../components/BarChart.vue';

export default {
  data: function() {
    return {
      chartData: {
        labels: ['January', 'February', 'March', 'April', 'May'],
        datasets: [
          {
            data: [1, 20, 50, 80, 100],
            backgroundColor: [
              'rgba(255, 99, 132, 1)',
              'rgba(54, 162, 235, 1)',
              'rgba(255, 206, 86, 1)',
              'rgba(75, 192, 192, 1)',
              'rgba(153, 102, 255, 1)',
            ],
            borderColor: [
              'rgba(255, 99, 132, 1)',
              'rgba(54, 162, 235, 1)',
              'rgba(255, 206, 86, 1)',
              'rgba(75, 192, 192, 1)',
              'rgba(153, 102, 255, 1)',
            ],
          }
        ]
      },
      height: window.innerHeight / 4,
      width: window.innerWidth / 2,
      options: {
        responsive: true,
        maintainAspectRatio: false,
        legend: {
          display: false
        },
        scales: {
          xAxes: [{
            ticks: {
              display: true,
              beginAtZero: true,
              stepSize: 100,
              callback: function(label) {
                return label + '%';
              },
              max: 100,
              min: 0,
            },
            gridLines: {
              display: false,
              drawBorder: false,
            }
          }],
          yAxes: [{
            barPercentage: 0.9,
            categoryPercentage: 0.9,
            ticks: {
              display: true,
            },
            gridLines: {
              display: false,
              drawBorder: false,
            }
          }],
        },
      },
    }
  },
  components: {
    BarChart,
  }
}
</script>

<style lang="scss" scoped>
</style>
