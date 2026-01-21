<script setup>
import { ref } from 'vue'

const isLoginModalOpen = ref(false)
const isRegisterMode = ref(false)
const authForm = ref({
  username: '',
  email: '',
  password: '',
  role: 'member'
})

const toggleLoginModal = () => {
  isLoginModalOpen.value = !isLoginModalOpen.value
}

const handleAuth = () => {
  // Placeholder for authentication logic
  console.log('Auth form:', authForm.value)
  // Here you would typically call an API for login/register
  // For now, just toggle the modal
  toggleLoginModal()
}
</script>

<template>
  <transition name="fade">
    <div v-if="isLoginModalOpen" class="modal-overlay" @click.self="toggleLoginModal">
      <div class="modal-box">
        <button class="close-modal" @click="toggleLoginModal">×</button>
        <h2>{{ isRegisterMode ? 'Account aanmaken' : 'Inloggen' }}</h2>
        <form @submit.prevent="handleAuth" class="auth-form">
          <div class="input-group" v-if="isRegisterMode">
             <label>Full Name</label>
             <input v-model="authForm.username" placeholder="Full Name" required />
          </div>
          <div class="input-group">
             <label>Email</label>
             <input v-model="authForm.email" type="email" placeholder="email@example.com" required />
          </div>
          <div class="input-group">
             <label>Password</label>
             <input v-model="authForm.password" type="password" placeholder="******" required />
          </div>
          <div v-if="isRegisterMode" class="input-group">
            <label>Role</label>
            <select v-model="authForm.role" class="styled-select">
              <option value="member">User (Member)</option>
              <option value="admin">Administrator (Admin)</option>
            </select>
          </div>
          <button type="submit" class="btn-submit-full">{{ isRegisterMode ? 'Register' : 'Login' }}</button>
        </form>
        <p class="switch-text" @click="isRegisterMode = !isRegisterMode">
          {{ isRegisterMode ? 'Already have an account? Login' : 'No account? Register' }}
        </p>
      </div>
    </div>
  </transition>
</template>

<style scoped>
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.7);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
  backdrop-filter: blur(5px);
}

.modal-box {
  background-color: #fff;
  border-radius: 12px;
  padding: 2rem;
  max-width: 400px;
  width: 90%;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
  position: relative;
  animation: slideIn 0.3s ease-out;
}

.close-modal {
  position: absolute;
  top: 10px;
  right: 10px;
  background: none;
  border: none;
  font-size: 1.5rem;
  cursor: pointer;
  color: #666;
  transition: color 0.2s;
}

.close-modal:hover {
  color: #000;
}

h2 {
  margin-top: 0;
  margin-bottom: 1.5rem;
  color: #333;
  text-align: center;
}

.auth-form {
  display: flex;
  flex-direction: column;
}

.input-group {
  margin-bottom: 1rem;
}

.input-group label {
  display: block;
  margin-bottom: 0.5rem;
  font-weight: 500;
  color: #555;
}

.input-group input,
.input-group select {
  width: 100%;
  padding: 0.75rem;
  border: 1px solid #ddd;
  border-radius: 6px;
  font-size: 1rem;
  transition: border-color 0.2s, box-shadow 0.2s;
}

.input-group input:focus,
.input-group select:focus {
  outline: none;
  border-color: #646cff;
  box-shadow: 0 0 0 3px rgba(100, 108, 255, 0.1);
}

.styled-select {
  appearance: none;
  background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 20 20'%3e%3cpath stroke='%236b7280' stroke-linecap='round' stroke-linejoin='round' stroke-width='1.5' d='m6 8 4 4 4-4'/%3e%3c/svg%3e");
  background-position: right 0.5rem center;
  background-repeat: no-repeat;
  background-size: 1.5em 1.5em;
  padding-right: 2.5rem;
}

.btn-submit-full {
  width: 100%;
  padding: 0.75rem;
  background-color: #646cff;
  color: white;
  border: none;
  border-radius: 6px;
  font-size: 1rem;
  font-weight: 500;
  cursor: pointer;
  transition: background-color 0.2s;
  margin-top: 1rem;
}

.btn-submit-full:hover {
  background-color: #535bf2;
}

.switch-text {
  text-align: center;
  margin-top: 1rem;
  color: #646cff;
  cursor: pointer;
  font-size: 0.9rem;
}

.switch-text:hover {
  text-decoration: underline;
}

.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

@keyframes slideIn {
  from {
    transform: scale(0.9);
    opacity: 0;
  }
  to {
    transform: scale(1);
    opacity: 1;
  }
}

@media (max-width: 480px) {
  .modal-box {
    padding: 1.5rem;
    margin: 1rem;
  }
}
</style>
