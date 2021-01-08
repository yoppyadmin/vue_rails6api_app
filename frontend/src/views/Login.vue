<template>
  <div>
    <p>sessions#new, sessions#create</p>
    <div id="login">
      <v-container>
        <v-row>
          <v-col cols="12" sm="8" md="6" class="mx-auto">
            <v-card>
              <v-card-title>
                <div class="grey--text text--darken-3">ログイン</div>
              </v-card-title>
              <v-card-text>
                <ValidationObserver v-slot="{ invalid }">
                  <div>
                    <ValidationProvider name="メールアドレス" rules="required|loginMailAddress" v-slot="{ errors }">
                    <v-text-field
                      prepend-icon="mdi-email"
                      v-model="unauthUser.email"
                      :error-messages="errors"
                      outlined
                      dense
                      label="メールアドレス"
                      color="teal lighten-2"
                    ></v-text-field></ValidationProvider>
                    <ValidationProvider name="パスワード" rules="required|loginPassword" v-slot="{ errors }">
                    <v-text-field
                      prepend-icon="mdi-lock"
                      v-bind:append-icon="showLoginPassword ? 'mdi-eye' : 'mdi-eye-off'"
                      v-model="unauthUser.password"
                      :error-messages="errors"
                      outlined
                      dense
                      counter="32"
                      label="パスワード"
                      v-bind:type="showLoginPassword ? 'text' : 'password'"
                      @click:append="showLoginPassword = !showLoginPassword"
                      color="teal lighten-2"
                    ></v-text-field></ValidationProvider>
                    <v-checkbox
                      v-model="unauthUser.remember_me"
                      id="unauth_user_remember_me"
                      label="ログイン情報を保存する"
                    ></v-checkbox>
                    <v-card-actions>
                      <v-btn :disabled="invalid" v-on:click="loginUser()">送信</v-btn>
                    </v-card-actions>
                  </div>
                </ValidationObserver>
              </v-card-text>
            </v-card>
          </v-col>
        </v-row>
      </v-container>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import { extend, localize, ValidationObserver, ValidationProvider } from 'vee-validate';
import ja from 'vee-validate/dist/locale/ja'
localize("ja", ja);
import {
  required,
} from 'vee-validate/dist/rules';
extend('required', {
  ...required,
  message: '入力内容は必須項目です'
});
extend('loginMailAddress', function(value) {
  return /^[A-Za-z0-9]{1}[A-Za-z0-9_.-]*@{1}[A-Za-z0-9_.-]{1,}\.[A-Za-z0-9]{1,}$/.test(value) || '{_field_}は正しくありません';
});
extend('loginPassword', function(value) {
  return /^[a-zA-Z0-9!#%&,:;<=>@_`~$*+-./?\\^|]{8,32}$/.test(value) || '{_field_}は半角英数字記号で8~32文字で入力してください';
});

export default {
  components: {
    ValidationObserver,
    ValidationProvider
  },
  data: function() {
    return {
      unauthUser: {},
      authUser: {},
      showLoginPassword: false,
      successLoginMessage: '',
      failureLoginMessage: '',
      loginErrors: {}
    }
  },
  beforeRouteEnter(to, from, next) { // -> GET, sessions#new
    axios
      .get('/api/v1/login')
      .then(function(response) {
        if (response.data.auth_user) { // logged_in_userが存在する場合にルート画面へルーティング
          next('/');
        } else if (response.data.unauth_user){ // logged_in_userが存在しない場合にログイン画面へルーティング
          next();
        }
        console.log(response);
      })
      .catch(function(error) {
        console.log(error);
      })
  },
  methods: {
    loginUser: function() { // -> POST, sessions#create
      const self = this
      const rememberMe = document.getElementById('unauth_user_remember_me');
      if (rememberMe.checked) {
        self.unauthUser.remember_me = true
      } else {
        self.unauthUser.remember_me = false
      }
      axios
        .post('/api/v1/login', {
          session: {
            email: self.unauthUser.email,
            password: self.unauthUser.password,
            remember_me: self.unauthUser.remember_me
          }
        })
        .then(function(response) {
          if ((response.data.message === "ログインに成功しました") && (self.successLoginMessage = response.data.message)) {
            self.$store.dispatch('flashMessage', { message: self.successLoginMessage, type: "success"});
            self.authUser = response.data.auth_user;
            response.data.path ? self.$router.push('/' + response.data.path) : self.$router.push('/')
          } else if((response.data.message === "ログインに失敗しました") && (self.failureLoginMessage = response.data.message)) {
            self.$store.dispatch('flashMessage', { message: self.failureLoginMessage, type: "error"});
            self.loginErrors = response.data.errors;
            self.unauthUser = {};
            rememberMe.checked = false;
          }
          console.log(response);
        })
        .catch(function(error) {
          self.$store.dispatch('flashMessage', { message: "サーバーとの通信にエラーが発生しています", type: "warning"});
          console.log(error);
        })
    }
  },
  created: function() {
    const self = this;
    axios
      .get('/api/v1/login') // -> GET, sessions#new
      .then(function(response) {
        self.unauthUser = response.data.unauth_user;
        console.log(response);
      })
      .catch(function(error) {
        self.$store.dispatch('flashMessage', { message: "サーバーとの通信にエラーが発生しています", type: "warning"});
        console.log(error);
      })
  }
}
</script>

<style lang="scss" scoped>
</style>
