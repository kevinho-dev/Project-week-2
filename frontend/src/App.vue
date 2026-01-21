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
const mylist = ref([]);
const isListModalOpen = ref([]);
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
    let icon = '📖';
    const name = item.content.category_name?.toLowerCase() || '';
    if (name.includes('kinderen')) icon = '🧸';
    else if (name.includes('volwassenen')) icon = '👨‍💼';
    else if (name.includes('ouderen')) icon = '👴';
    return { ...item, icon };
  });
});
const addToMyList =(book) => {
  const exists = mylist.value.find(items => item.book_id === book.book_id);
  if (!exists)  {
    mylist.value.push(book);
    alert(`"${book.title}" is toegevoegd aan je lijst!`);
  }else{
    alert("Dit boek staat al in je lijst.");
  }
};

const removeFromList = (index) => {
  myList.value.splice(index, 1);
};
const myListCount = computed(() => myList.value.length);
</script>

<template>
<div class="app-home">
  <header class="navbar">
    <div class="nav-content">
      <div class="logo">Forum <span>Library</span></div>
      <div class="search-bar" >
        <input  id="zoekBar" placeholder="Zoek boeken...">
      </div>
      <div class="auth-group">
        <template v-if="!currentUser">
          <button class="nav-btn" @click="isRegisterMode = false; toggleLoginModal()" style="background-color: blanchedalmond">Inloggen</button>
          <button class="nav-btn primary" @click="isRegisterMode = true; toggleLoginModal()" style="background-color: blanchedalmond">Word lid</button>
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
          <div  class="bestseller-badge">
        ⭐ Bestseller{{selectedBook.is_bestseller}}
      </div>
    
          <h1 class="book-title">{{ selectedBook.title }}</h1>
          <p class="author">Door: {{ selectedBook.author }}</p>
          <div class="description-box">
            <h4>Over dit boek</h4>
            <p>{{ selectedBook.summary }}</p>
          </div>
          <div class="price-info-grid">
            <div class="price-card highlight">
              <span>Status</span>
              <p>Beschikbaar</p>
              <button class="btn-action buy" style="background-color: aquamarine;"> Reserveren </button>
            </div>
            <div class="price-card">
              <span>Mijn Selectie</span>
              <p>{{ myListCount }} Boeken</p>
              <button class="btn-action rent">Mijn lijsten</button>
            </div>
            
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
    <a href="https://www.bibliotheekbollenstreek.nl/leren/digitaalmeedoen.html" class="button tertiary">Ik heb een digitale vraag</a></p>
</div>
        </div>
</div> 
</div>
<div v-if="isListModalOpen" class="modal-overlay" @click.self="isListModalOpen = false">
  <div class="modal-box list-popup">
    <button class="closew-modal" @click="isListModalOpen = false">×</button>
     <h2>Mijn Gereserveede Boeken</h2>

     <div v-if="myList.length === 0" class="empaty-msg">Je Lijst is nog leeg</div>

     <div v-else class="list.items-container">
      <div v-for="(book, index) in myList" :key="index" class="small-list-row">
        <img :src="getImageUrl(book.img)" @error="handleImageError" class="micro-img">
        <div class="list-info">
          <h4>{{ book.title }}</h4>
          <p>{{ book.author }}</p>
        </div>
        <button @click="removeFromList(index)" class="btn-remove">Verwijder</button>
      </div>
     </div>
     <button v-if="mylist.length > 0" class="btn-submit-full" @click="alert('Bedankt! Je reservering is verwerkt.')">
      Bevastig Reserveren
     </button>
  </div>
</div>
<footer class="footer">
    <div class="footer-content">
      <p class="copyright">
        &copy; 2024 Forum Library. All rights reserved.
      </p>
      <div class="footer-links">
        <span>Privacy Policy</span>
        <span>Terms of Service</span>
        <span>Contact Us</span>
      </div>
    </div>
  </footer>
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
  background: orange;
  border-bottom: 0 solid var(--primary-indigo);
  padding: 0;
  position: fixed;
  top: 0; left: 0; right: 0;
  z-index: 1000;
}

.nav-content {
 
  margin: 0 auto;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 ;
  background-color: orange;
}
.auth-group {
    
    display: flex;
    gap: 8px;
    padding: 10px;
}
span.user-name {
    margin-top: 10px;
}

input#zoekBar {
    width: 400px;
    height: 35px;
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
  margin: 20rem auto;
  max-width: 1000px; /* Limits width to keep cards square and neat */
}

.square-card {
  background: orange;
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

/* --- Footer Styling --- */
.footer {
  background-color: var(--bg-card); /* White background to match navbar */
  border-top: 3px solid var(--primary-indigo); /* Top border for clear separation */
  padding: 2rem 0;
  margin-top: 4rem; /* Spacing from main content */
  width: 100%;
}

.footer-content {
  max-width: 1100px;
  margin: 0 auto;
  padding: 0 1.5rem;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 1rem;
  text-align: center;
  background-color: orange;
}



.copyright {
  font-size: 1rem;
  color: var(--text-muted);
  font-weight: 600;
}

.footer-links {
  display: flex;
  gap: 1.5rem;
  margin-top: 0.5rem;
}

.footer-links span {
  font-size: 0.9rem;
  color: var(--primary-indigo);
  font-weight: 700;
  cursor: pointer;
  transition: text-decoration 0.3s;
}

.footer-links span:hover {
  text-decoration: underline;
}


/* --- Responsive for Mobile --- */
@media (max-width: 768px) {
  .card-grid {
    /* On small tablets, they still stay side-by-side but with less gap */
    gap: 1rem;
  }
  .icon { font-size: 3.5rem; }
  .square-card h3 { font-size: 1.1rem; }

  .footer-content {
    flex-direction: column; /* Horizontal layout on desktop */
    justify-content: space-between;
  }
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
  background-color: #edd2b7;
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

.modal-box h2 {
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