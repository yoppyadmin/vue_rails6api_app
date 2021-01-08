import Vue from 'vue'
import App from './App.vue'
import router from './router'
import vuetify from './plugins/vuetify'
import store from './store'
import axios from 'axios'

Vue.config.productionTip = false

axios.defaults.baseURL = process.env.VUE_APP_API_ORIGIN
axios.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest'
axios.defaults.withCredentials = true

import VueLoading from 'vue-loading-template'
Vue.use(VueLoading, /** options **/)
import Loading from './components/Loading.vue'
Vue.component('Loading', Loading)

import Message from './components/Message.vue'
Vue.component('Message', Message)
import PostItem from './components/PostItem.vue'
Vue.component('PostItem', PostItem)
import PostNew from './components/PostNew.vue'
Vue.component('PostNew', PostNew)

new Vue({
  router,
  vuetify,
  store,
  render: h => h(App)
}).$mount('#app')
