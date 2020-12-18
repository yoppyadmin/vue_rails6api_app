import Vue from 'vue'
import App from './App.vue'
import router from './router'
import vuetify from './plugins/vuetify'
import store from './store'
import axios from 'axios'
import Message from './components/Message.vue'

Vue.config.productionTip = false

axios.defaults.baseURL = process.env.VUE_APP_API_ORIGIN
axios.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest'
axios.defaults.withCredentials = true

Vue.component('Message', Message)

new Vue({
  router,
  vuetify,
  store,
  render: h => h(App)
}).$mount('#app')
