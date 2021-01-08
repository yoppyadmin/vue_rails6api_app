import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

const store = new Vuex.Store({
  state: {
    alert: false,
    message: '',
    style: ''
  },
  mutations: {
    insertMessage(state, sentMessage) {
      state.message = sentMessage;
    },
    toggleAlertBoolean(state, value) { // Message.vue
      state.alert = value;
    },
    confirmStyle: function(state, type) {
      state.style = type;
    }
  },
  actions: {
    flashMessage({ commit }, { message, type })  {
      commit('insertMessage', message);
      commit('toggleAlertBoolean', true);
      commit('confirmStyle', type)
      if (message === "サーバーとの通信にエラーが発生しています") {
        return
      } else {
        setTimeout(function() {
          commit('toggleAlertBoolean', false);
        }, 5000)
      }
    }
  },
})

export default store
