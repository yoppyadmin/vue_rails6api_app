import Vue from 'vue'
import App from './App.vue'
import router from './router'
import vuetify from './plugins/vuetify';
import axios from 'axios';

Vue.config.productionTip = false

axios.defaults.baseURL = process.env.VUE_APP_API_ORIGIN
axios.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest';

new Vue({
  router,
  vuetify,
  render: h => h(App)
}).$mount('#app')
