<template>
  <div>
    <p>UsersShow</p>
    <p v-show="errorFlag">サーバとの通信にエラーが発生しています</p>
    <div id="users-show">
      <h3>users#show</h3>
      <div>
        <p>{{ user }}</p>
      </div>
      <p>deploy</p>
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
