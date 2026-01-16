<script setup>
import { ref, onMounted } from 'vue';
import axios from 'axios';

const categories = ref([]);
const selectionPath = ref([]);
const isLoginModalOpen = ref(false);
const API_URL = "http://localhost/lessen/Project-week-2/Backend/get_categories.php";

const toggleLoginModal = () => {
  isLoginModalOpen.value = !isLoginModalOpen.value;
};

const fetchCategories = async () => {
  try {
    const response = await axios.get(API_URL);
    categories.value = response.data;
  } catch (error) {
    console.error('Error fetching categories:', error);
  }
};

const handleCategoryclick = (category) => {
  selectionPath.value.push({
    id: category.category_id,
    name: category.category_name
  });
  fetchCategories(category.category_id);
};

const reserSearch = () => {
  selectionPath.value = [];
};

const handleLogin = () => {
  // Implement login logic here
  console.log('Login submitted');
  toggleLoginModal();
};

onMounted(() => {
  fetchCategories();
});
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
  <main class="main-content">
<div v-if="selectionPath.length > 0" class="stepper-header">
        <button @click="goBack" class="back-link">← Terug naar categorieën</button>
        <h1 class="page-title">Vragen voor {{ selectionPath[0].name }}</h1>
        <div class="progress-wrapper">
          <div class="progress-track">
            <div class="progress-fill" :style="{ width: progressPercentage + '%' }"></div>
          </div>
       <p class="step-text">Vraag {{ selectionPath.length }} van 5</p>
        </div>
      </div>
      <div class="display-area">
        
        <div v-if="selectionPath.length === 0" class="hero-grid">
          <div v-for="item in items" :key="item.content.category_id" 
               class="hero-card" @click="handleSelect(item)">
            <div class="card-icon">👤</div>
            <h2>{{ item.content.category_name }}</h2>
            <p>Ontdek boeiende verhalen voor {{ item.content.category_name.toLowerCase() }}</p>
          </div>
        </div>
       <div v-else-if="!selectedBook" class="options-list">
          <h2 class="question-text">{{ dynamicQuestion }}</h2>
          <div v-for="item in items" :key="item.content.category_id || item.content.book_id" 
               class="list-option" @click="handleSelect(item)">
            <span>{{ item.content.category_name || item.content.title }}</span>
            <span class="arrow">→</span>
          </div>
        </div>
      <div v-else class="book-detail-card">
          <div class="recommendation-header">
            <span class="badge-rec">Aanbevolen voor u</span>
            <span v-if="selectedBook.is_bestseller" class="badge-bestseller"> Bestseller</span>
          </div>
          <div class="book-main-content">
            <div class="book-cover-art">📖</div>
            
            <div class="book-info">
              <h1>{{ selectedBook.title }}</h1>
              <p class="author-name">door {{ selectedBook.author }}</p>
              
              <div class="book-meta">
                <span :class="{'in-stock': selectedBook.stock_quantity > 0, 'out-stock': selectedBook.stock_quantity <= 0}">
                  ● {{ selectedBook.stock_quantity > 0 ? 'Op voorraad' : 'Niet op voorraad' }}
                </span>
                <span>• 4.8 ⭐</span>
              </div>
             <p class="summary-text">{{ selectedBook.summary }}</p>
              
              <div class="pricing-actions">
                <button class="btn-rent" :disabled="selectedBook.stock_quantity <= 0">
                  Lenen € {{ selectedBook.rent_price }}
                </button>
                <button class="btn-buy">
                  Kopen € {{ selectedBook.buy_price }}
                </button>
              </div>
            </div>
          </div>
        </div>

      </div>

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
