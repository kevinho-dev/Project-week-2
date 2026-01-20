<script setup>
import { ref, onMounted, computed } from 'vue';
import axios from 'axios';

const BASE_URL = "http://localhost/lessen/Project-week-2/Backend/";

const getImageUrl = (imgName) => {
  if (!imgName) return '';
  if (imgName.startsWith('http')) return imgName;
  return `${BASE_URL}${imgName}`;
};

const handleImageError = (e) => {
  e.target.src = 'https://via.placeholder.com/200x300?text=No+Cover';
};

const items = ref([]);
const selectionPath = ref([]);
const selectedBook = ref(null);
const isLoginModalOpen = ref(false);
const currentUser = ref(null);
const isRegisterMode = ref(false);

const authForm = ref({ username: '', email: '', password: '', role: 'member' });

const toggleLoginModal = () => {
  isLoginModalOpen.value = !isLoginModalOpen.value;
  authForm.value = { username: '', email: '', password: '', role: 'member' };
};

const fetchData = async (parentId = null) => {
  try {
    const res = await axios.get(`${BASE_URL}get_categories.php`, { params: { parent_id: parentId } });
    items.value = res.data;
  } catch (e) { console.error("Error fetching data", e); }
};

onMounted(() => fetchData());

const handleSelect = (item) => {
  if (item.type === 'book') {
    selectedBook.value = item.content;
  } else {
    selectionPath.value.push({ id: item.content.category_id, name: item.content.category_name });
    fetchData(item.content.category_id);
  }
};

const goBack = () => {
  selectedBook.value = null;
  selectionPath.value.pop();
  const lastId = selectionPath.value.length > 0 ? selectionPath.value[selectionPath.value.length-1].id : null;
  fetchData(lastId);
};

const handleAuth = async () => {
  const endpoint = isRegisterMode.value ? 'register.php' : 'login.php';
  try {
    const res = await axios.post(`${BASE_URL}${endpoint}`, authForm.value);
    if (isRegisterMode.value) {
      alert("Registration Successful!");
      isRegisterMode.value = false;
    } else {
      currentUser.value = res.data;
      toggleLoginModal();
    }
  } catch (error) { alert("Auth failed"); }
};

const logout = () => {
  currentUser.value = null;
  selectedBook.value = null;
  selectionPath.value = [];
  fetchData();
};

const progressPercentage = computed(() => (selectionPath.value.length / 5) * 100);

// Filter and Map Icons based on Category Name
const filteredItems = computed(() => {
  const data = selectionPath.value.length === 0 ? items.value.slice(0, 3) : items.value;
  return data.map(item => {
    let icon = '📖'; // Default
    const name = item.content.category_name?.toLowerCase() || '';
    if (name.includes('kinderen')) icon = '🧸';
    else if (name.includes('volwassenen')) icon = '👨‍💼';
    else if (name.includes('ouderen')) icon = '👴';
    return { ...item, icon };
  });
});
</script>

<template>
<div class="app-home">
  <header class="navbar">
    <div class="nav-content">
      <div class="logo">Forum <span>Library</span></div>
      <div class="search-bar">
        <input type="text" placeholder="Zoek boeken...">
      </div>
      <div class="auth-group">
        <template v-if="!currentUser">
          <button class="nav-btn" @click="isRegisterMode = false; toggleLoginModal()">Inloggen</button>
          <button class="nav-btn primary" @click="isRegisterMode = true; toggleLoginModal()">Word lid</button>
        </template>
        <template v-else>
          <span class="user-name">Welcome, {{ currentUser.username }}</span>
          <button class="nav-btn outline" @click="logout">Logout</button>
        </template>
      </div>
    </div>
  </header>

  <main class="container">
    <div v-if="selectionPath.length > 0" class="stepper">
      <button @click="goBack" class="btn-back">← Back</button>
      <div class="bar-container">
        <div class="bar-fill" :style="{ width: progressPercentage + '%' }"></div>
      </div>
    </div>

    <div v-if="selectionPath.length === 0" class="card-grid">
      <div v-for="item in filteredItems" :key="item.content.category_id" class="square-card" @click="handleSelect(item)">
        <span class="icon">{{ item.icon }}</span>
        <h3>{{ item.content.category_name }}</h3>
        <p class="card-desc">Ontdek boeiende verhalen</p>
      </div>
    </div>

    <div v-else-if="!selectedBook" class="list-container">
      <div v-for="item in items" :key="item.id" class="list-row" @click="handleSelect(item)">
        <span>{{ item.content.category_name || item.content.title }}</span>
        <span class="arrow">→</span>
      </div>
    </div>

    <div v-else class="book-detail">
      <div class="detail-layout">
        <div class="left-side">
          <img :src="getImageUrl(selectedBook.img)" @error="handleImageError" class="large-cover">
        </div>
        <div class="right-side">
          <div class="stock-tag">
        ✓ Op voorraad: {{ selectedBook.stock_quantity }} stuks
      </div>
          <div v-if="selectedBook.is_bestseller == 1" class="bestseller-badge">
        ⭐ Bestseller
      </div>
    
          <h1 class="book-title">{{ selectedBook.title }}</h1>
          <p class="author">Door: {{ selectedBook.author }}</p>
          <div class="description-box">
            <h4>Over dit boek</h4>
            <p>{{ selectedBook.summary }}</p>
          </div>
          <div class="price-row">
            <button class="btn-action rent">Lenen €{{ selectedBook.rent_price }}</button>
            <button class="btn-action buy">Kopen €{{ selectedBook.buy_price }}</button>
          </div>
          <button @click="selectedBook = null" class="back-link">Terug naar lijst</button>
        </div>
      </div>
    </div>
  </main>

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

  <div class="biebcomponent regular section"><ul class="toptask-items plain item-count-5">
            <li class="my-library">
                    <p>
                        <a href="https://probiblio.hostedwise.nl/cgi-bin/bx.pl?vestnr=6025&amp;event=private">
                            Mijn bibliotheek</a>
                    </p>
                </li>
            <li class="agenda">
                    <p>
                        <a href="https://bibliotheekbollenstreek.op-shop.nl/">
                            Agenda</a>
                    </p>
                </li>
            <li class="collection">
                    <p>
                        <a href="https://www.bibliotheekbollenstreek.nl/collectie_.html">
                            Aanbod</a>
                    </p>
                </li>
            <li class="e-books">
                    <p>
                        <a href="https://www.onlinebibliotheek.nl/">
                            Online bibliotheek</a>
                    </p>
                </li>
            <li class="customer-service">
                    <p>
                        <a href="https://www.bibliotheekbollenstreek.nl/organisatie/reactie.html">
                            Ik heb een vraag</a>
                    </p>
                </li>
            </ul>
    </div>
    <div class="container size-3" id="homepostzegelbanner1">
        <div class="column-1 column parbase">
        <h3>Online leren &amp; oefenen</h3>
        <div class="widget-bnl-combo bordered">
            <div class="par_combo_widget parsys"><span class="image section">
        <a href="https://www.bibliotheekbollenstreek.nl/leren/onlineleren.html">
            <img class="bannerimage" src="https://www.bibliotheek.nl/beeldbank/banner/1080x400px-vrouw-in-zitzak-met-koptelefoon.jpg.rendition.792.1267.jpeg" srcset=" https://www.bibliotheek.nl/beeldbank/banner/1080x400px-vrouw-in-zitzak-met-koptelefoon.jpg.rendition.640.1024.jpeg 400w,  https://www.bibliotheek.nl/beeldbank/banner/1080x400px-vrouw-in-zitzak-met-koptelefoon.jpg.rendition.792.1267.jpeg 600w,  https://www.bibliotheek.nl/beeldbank/banner/1080x400px-vrouw-in-zitzak-met-koptelefoon.jpg.rendition.1280.2048.jpeg 800w" alt="naar de online cursussen">
        </a>

</span>
<div class="richtext section">  
        <p>Ontdek het veelzijdige online cursusaanbod van de bibliotheek! Oefen voor je <a href="https://theorie-nl.kb.idm.oclc.org/dashboard/auto/partnerexamens">CBR theorie-examen</a>, leer programmeren of volg een cursus fotografie. Gratis voor bibliotheekleden.&nbsp;<br>
</p>
</div>
<p class="section">
    <a href="https://www.bibliotheekbollenstreek.nl/leren/onlineleren.html" class="button tertiary">Naar online cursussen</a>
</p>
</div>
        </div> 
</div>
        <div class="column-2 column parbase">
        <h3>Activiteiten</h3>
        <div class="widget-bnl-combo bordered">
            <div class="par_combo_widget parsys"><span class="image section">
        <a href="https://bibliotheekbollenstreek.op-shop.nl/">
            <img class="bannerimage" src="https://www.bibliotheek.nl/beeldbank/banner/1080x400px-kinderen-in-de-maakplaats.jpg.rendition.792.1267.jpeg" srcset=" https://www.bibliotheek.nl/beeldbank/banner/1080x400px-kinderen-in-de-maakplaats.jpg.rendition.640.1024.jpeg 400w,  https://www.bibliotheek.nl/beeldbank/banner/1080x400px-kinderen-in-de-maakplaats.jpg.rendition.792.1267.jpeg 600w,  https://www.bibliotheek.nl/beeldbank/banner/1080x400px-kinderen-in-de-maakplaats.jpg.rendition.1280.2048.jpeg 800w" alt="bekijk de agenda">
        </a>
</span>
<div class="richtext section">
        <p>Van striptekenen en Lego-ateliers tot schrijversavonden, politiek cafés, taalcursussen en kledingruilavonden – er is voor elke leeftijd iets te doen in jouw bibliotheek!</p>
</div>
<p class="section">
  <a href="https://bibliotheekbollenstreek.op-shop.nl/" class="button tertiary">
        
        Bekijk de agenda
    </a>
</p>
</div>
        </div>
  
</div>

        <div class="column-3 column parbase">    
        <h3>Digitale vaardigheden</h3>
        <div class="widget-bnl-combo bordered">
            <div class="par_combo_widget parsys"><span class="image section">
        <a href="https://www.bibliotheekbollenstreek.nl/leren/digitaalmeedoen.html">
            <img class="bannerimage" src="https://www.bibliotheek.nl/beeldbank/banner/1080x400px-man-met-een-grijze-baard-maakt-een-dansende-beweging.jpg.rendition.792.1267.jpeg" srcset=" https://www.bibliotheek.nl/beeldbank/banner/1080x400px-man-met-een-grijze-baard-maakt-een-dansende-beweging.jpg.rendition.640.1024.jpeg 400w,  https://www.bibliotheek.nl/beeldbank/banner/1080x400px-man-met-een-grijze-baard-maakt-een-dansende-beweging.jpg.rendition.792.1267.jpeg 600w,  https://www.bibliotheek.nl/beeldbank/banner/1080x400px-man-met-een-grijze-baard-maakt-een-dansende-beweging.jpg.rendition.1280.2048.jpeg 800w" alt="ik heb een digitale vraag">
        </a>
</span>
<div class="richtext section">
        <p>Wil je beter leren omgaan met de computer, tablet of telefoon? Heb je hulp nodig bij het aanvragen van een DigiD of toeslag? Volg een cursus of kom naar een van onze spreekuren.&nbsp;<br>
</p>
</div>
<p class="section">
    <a href="https://www.bibliotheekbollenstreek.nl/leren/digitaalmeedoen.html" class="button tertiary">
        
        Ik heb een digitale vraag
    </a>

</p>

</div>

        </div>
    
    
</div>


        
    
</div>
</div>
</template>

<style scoped>
/* --- Design Variables --- */
:root {
  --primary-indigo: #4f46e5;
  --secondary-green: #16a34a;
  --bg-page: #f3f4f6;
  --bg-card: #ffffff;
  --text-main: #111827;
  --border-color: #d1d5db;
  --shadow-standard: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
}

.stock-tag {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  background-color: #dcfce7; /* Light green background */
  color: var(--secondary-green); /* Bold green text */
  padding: 0.4rem 1rem;
  border-radius: 999px; /* Pill shape */
  font-size: 0.9rem;
  font-weight: 800;
  text-transform: uppercase;
  border: 1px solid #bbf7d0;
  margin-bottom: 1rem;
}

.app-home {
  font-family: 'Inter', sans-serif;
  background-color: var(--bg-page);
  min-height: 100vh;
  color: var(--text-main);
  font-size: 18px;
  line-height: 1.6;
}

/* --- Navbar: Fixed top --- */
.navbar {
  background: var(--bg-card);
  border-bottom: 3px solid var(--primary-indigo);
  padding: 0.8rem 0;
  position: fixed;
  top: 0; left: 0; right: 0;
  z-index: 1000;
}

.nav-content {
  max-width: 1200px;
  margin: 0 auto;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 1.5rem;
}

/* --- Main Container --- */
.container {
  max-width: 1100px;
  margin: 7rem auto 3rem;
  padding: 0 1rem;
}

/* --- Fixed Category Grid: Side-by-Side --- */
.card-grid {
  display: grid;
  /* Forces 3 columns side-by-side on desktop */
  grid-template-columns: repeat(3, 1fr); 
  gap: 2rem;
  margin: 2rem auto;
  max-width: 1000px; /* Limits width to keep cards square and neat */
}

.square-card {
  background: var(--bg-card);
  aspect-ratio: 1 / 1; /* Keeps them perfectly square */
  border-radius: 24px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  border: 1px solid var(--border-color);
  transition: transform 0.3s, box-shadow 0.3s;
  padding: 1.5rem;
  box-shadow: var(--shadow-standard);
}

.square-card:hover {
  transform: translateY(-10px);
  border-color: var(--primary-indigo);
}

.icon {
  font-size: 5rem;
  margin-bottom: 0.5rem;
}

.square-card h3 {
  font-size: 1.4rem;
  font-weight: 800;
  margin: 0;
}
ul.toptask-items.plain.item-count-5 {
    display: flex;
    gap: 100px;
    justify-content: center;
    /* align-items: center; */
    list-style: none;
    padding: 0;
    margin: 0;
}
div#homepostzegelbanner1 {
    display: flex;
    gap: 68px;
    justify-content: center;
    /* align-items: center; */
    list-style: none;
    padding: 0;
    margin-top: 180px;
}
img.bannerimage {
    width: 100%;
    height: auto;
    object-fit: cover;
}

/* --- Responsive for Mobile --- */
@media (max-width: 768px) {
  .card-grid {
    /* On small tablets, they still stay side-by-side but with less gap */
    gap: 1rem;
  }
  .icon { font-size: 3.5rem; }
  .square-card h3 { font-size: 1.1rem; }
}

@media (max-width: 480px) {
  .card-grid {
    /* Only on very small phones, they stack to remain readable */
    grid-template-columns: 1fr;
    max-width: 300px;
  }

  ul.toptask-items.plain.item-count-5 {
    flex-wrap: wrap;
    justify-content: center;
}
img.bannerimage {
    width: 100%;
}
}

/* --- Rest of the styles (Modal, Book Details, etc.) --- */
.detail-layout {
  display: flex;
  flex-direction: column;
  background: white;
  padding: 2.5rem;
  border-radius: 25px;
  box-shadow: var(--shadow-standard);
}

@media (min-width: 768px) {
  .detail-layout { flex-direction: row; gap: 3rem; }
  .left-side { flex: 0 0 300px; }
}

.large-cover {
  width: 100%;
  border-radius: 15px;
}

.modal-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.6);
  backdrop-filter: blur(10px);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 2000;
}

.modal-box {
  background: white;
  padding: 2.5rem;
  border-radius: 24px;
  width: 90%;
  max-width: 400px;
}
</style>