import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

const store = new Vuex.Store({
  state: {
    alert: false,
    message: '',
  },
  getters: {
    alert: function(state) {
      return state.alert;
    },
    message: function(state) {
      return state.message;
    }
  },
  mutations: {
    flashMessage(state, sentMessage) {
      state.alert = true;
      state.message = sentMessage;
    },
    toggleAlertBoolean(state, value) { // Message.vue
      state.alert = value;
    }
  },
  actions: {
    deleteMessage(context, value)  {
      setTimeout(function() {
        context.commit('toggleAlertBoolean', value);
      }, 5000)
    }
  }
})

export default store
