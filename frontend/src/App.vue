<script setup>
import inloggen from './components/inloggen.vue'

class btn-login {
  constructor(parameters) {
    addevenlistener('click', function() {
      window.location.href = 'components/inloggen';
    });
  }
}
</script>

<template>
<div class="app-home">
  <header class="navbar">
    <div class="logo">Forum Library</div>
    <div class="seearch-bar">
      <input type="text" placeholder="Search books..">  
    </div>
    <div class="user-buttons">
      <button class="btn-login">Inloggen</button>
      <button class="btn-regester">Word lid</button>
    </div>
  </header>
  

</div>
</template>

<style scoped>
.logo {
  height: 6em;
  padding: 1.5em;
  will-change: filter;
  transition: filter 300ms;
}
.logo:hover {
  filter: drop-shadow(0 0 2em #646cffaa);
}
.logo.vue:hover {
  filter: drop-shadow(0 0 2em #42b883aa);
}
</style>
