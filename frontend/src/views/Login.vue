<template>
  <div>
    <p>sessions#new, sessions#create</p>
    <hr>
    <v-btn v-on:click="showSession">notLoggedInUser</v-btn>
    <v-btn v-on:click="showUser">loggedInUser</v-btn>
    <p v-show="errorFlag">サーバとの通信にエラーが発生しています</p>
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
                      v-model="notLoggedInUser.email"
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
                      v-model="notLoggedInUser.password"
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
                      v-model="notLoggedInUser.remember_me"
                      id="not_logged_in_user_remember_me"
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
      notLoggedInUser: {},
      loggedInUser: {},
      errorFlag: false,
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
        if (response.data.logged_in_user) { // logged_in_userが存在する場合にルート画面へルーティング
          next('/');
        } else if (response.data.not_logged_in_user){ // logged_in_userが存在しない場合にログイン画面へルーティング
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
      const rememberMe = document.getElementById('not_logged_in_user_remember_me');
      if (rememberMe.checked) {
        self.notLoggedInUser.remember_me = true
      } else {
        self.notLoggedInUser.remember_me = false
      }
      axios
        .post('/api/v1/login', {
          session: {
            email: self.notLoggedInUser.email,
            password: self.notLoggedInUser.password,
            remember_me: self.notLoggedInUser.remember_me
          }
        })
        .then(function(response) {
          if ((response.data.message === "ログインに成功しました") && (self.successLoginMessage = response.data.message)) {
            self.loggedInUser = response.data.logged_in_user;
            self.$store.commit('flashMessage', self.successLoginMessage)
            response.data.path ? self.$router.push('/' + response.data.path) : self.$router.push('/users/' + self.loggedInUser.id)
          } else if((response.data.message === "ログインに失敗しました") && (self.failureLoginMessage = response.data.message)) {
            self.loginErrors = response.data.errors;
            self.$store.commit('flashMessage', self.failureLoginMessage)
            self.notLoggedInUser.email = '';
            self.notLoggedInUser.password = '';
            rememberMe.checked = false;
          }
          console.log(response);
        })
        .catch(function(error) {
          self.errorFlag = true;
          console.log(error);
        })
    },
    showSession: function() {
      console.log(this.notLoggedInUser);
    },
    showUser: function() {
      console.log(this.loggedInUser);
    }
  },
  mounted: function() { // -> GET, sessions#new
    const self = this;
    axios
      .get('/api/v1/login')
      .then(function(response) {
        if((response.data.not_logged_in_user)) { // ユーザーがログインしていない場合
          self.notLoggedInUser = response.data.not_logged_in_user;
          console.log(response);
        } else if(response.data.logged_in_user) {  // ユーザーがログインしている場合
          self.loggedInUser = response.data.logged_in_user;
          console.log(response);
        }
      })
      .catch(function(error) {
        self.errorFlag = true;
        console.log(error);
      })
  }
}
</script>

<style lang="scss" scoped>
</style>
