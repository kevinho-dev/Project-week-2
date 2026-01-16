<script setup>
import { ref, onMounted, computed } from 'vue';
import axios from 'axios';

const items = ref([]);
const selectionPath = ref([]);
const selectedBook = ref([]);
const isLoginModalOpen = ref(false);
const API_URL = "http://localhost/Project-week-2/Backend/get_categories.php";

const toggleLoginModal = () => {
  isLoginModalOpen.value = !isLoginModalOpen.value;
};
//add core logic for fetching hierarchy data from PHP backend(API)
const fetchData = async (parentId = null) => {
  try {
    const res = await axios.get(API_URL, { params: { parent_id: parentId } });
    items.value = res.data;
  } catch (e) { console.error("Error fetching data", e); }
};
//handle item selection with conditional fetching and book detail display
const handleSelect = (item) => {
  if (item.type === 'book') {
    selectedBook.value = item.content;
  } else {
    selectionPath.value.push({ id: item.content.category_id, name: item.content.category_name });
    fetchData(item.content.category_id);
  }
};
//add back-navigation logic to allow users to return to previous category levels
const goBack = () => {
  selectedBook.value = null;
  selectionPath.value.pop();
  const lastId = selectionPath.value.length > 0 ? selectionPath.value[selectionPath.value.length-1].id : null;
  fetchData(lastId);
};
//add computed properties for dynamic progress tracking and contextual questions
const progressPercentage = computed(() => (selectionPath.value.length / 5) * 100);
const dynamicQuestion = computed(() => {
  const qs = ["Welk genre spreekt je het meest aan?", "Waar mag het verhaal zich afspelen?", "Kies een schrijfstijl", "Bijna daar..."];
  return qs[selectionPath.value.length - 1] || "Kies een optie";
});

const handleLogin = () => {
  // Implement login logic here
  console.log('Login submitted');
  toggleLoginModal();
};

onMounted(() => {
  fetchData();
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
            <div class="book-cover-art">
              <img 
              v-if="selectedBook.img"
              :src="selectedBook.img"
              :alt="selectedBook.img"
              class="book-img"
              ?>
            
            <span v-else>📖</span>
            </div>
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
