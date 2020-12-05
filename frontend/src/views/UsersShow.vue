<template>
  <div>
    <p>UsersShow</p>
    <p v-show="errorFlag">サーバとの通信にエラーが発生しています</p>
    <div id="users-show">
      <h3>users#show</h3>
      <div>
        <p>{{ user.id }}</p>
        <p>{{ user.name }}</p>
        <p>{{ user.email }}</p>
        <template v-if="user.avatar && node_env !== 'production'">
          <img v-bind:src="'http://localhost:3000' + user.avatar.url">
        </template>
        <template v-else-if="user.avatar && node_env == 'production'">
          <img v-bind:src="user.avatar.url">
        </template>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  props: ['id'],
  data: function() {
    return {
      errorFlag: false,
      user: {},
      node_env: process.env.NODE_ENV,
    }
  },
  mounted: function() { // -> GET, users#show
    const self = this;
    axios
      .get('/api/v1/users/' + self.$route.params.id, {
        withCredentials: true
      })
      .then(function(response) {
        self.user = response.data;
        console.log(response);
      })
      .catch(function(error) {
        self.errorFlag = true;
        console.log(error);
      })
  }
}
</script>
