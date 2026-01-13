<script setup>
import { ref, onMounted } from 'vue';
//import axios from 'axios';

const categories = ref([]);
const selectionPath = ref([]);
const isLoginModalOpen = ref(false);
const API_URL = "http://localhost/backend/get_categories.php";

const toggleLoginModal = () => {
  isLoginModalOpen.value = !isLoginModalOpen.value;
};

</script>

<template>
<div class="app-home">
  <header class="navbar">
    <div class="logo">Forum Library</div>
    <div class="seearch-bar">
      <input type="text" placeholder="Search books..">  
    </div>
    <div class="user-buttons">
      <button class="btn-login" @click="toggleLoginModal">Inloggen</button>
      <button class="btn-regester">Word lid</button>
    </div>
  </header>
  <main class="content">
<div class=""></div>
  </main>
  <div v-if="isLoginModalOpen" class="modal-overlay" @click.self="toggleLoginModal">
  <div class="modal-content">
    <span class="close-btn" @click="toggleLoginModal">&times;</span>
    <h2>Login to Your Account</h2>
    <form @submit.prevent="handleLogin">
      <div class="form-group">
        <label>Email:</label>
        <input type="email" placeholder="Enter your email" required />
      </div>
      <div class="form-group">
        <label>Password:</label>
        <input type="password" placeholder="Enter your password" required />
      </div>
      <button type="submit" class="btn-submit">Login Now</button>
    </form>
  </div>
</div>

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
