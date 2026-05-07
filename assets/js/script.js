let map;
let markers = [];
let streetsLayer;
let satelliteLayer;
let topoLayer;
let userMarker;
let routingControl = null;
let routingActionBar = null;
let panelToggleBtn = null;
let cameraMarkers = [];
let isNavigating = false;
let watchId = null;
let activeDestLat = null;
let activeDestLng = null;

// Enhanced features variables
let voiceRecognition = null;
let weatherData = {};
let offlineMode = false;
let currentUser = null;
let arCameraStream = null;
let itineraryData = [];
let businessData = [];
let eventData = [];
let currentCalendarMonth = new Date().getMonth();
let currentCalendarYear = new Date().getFullYear();

const STORAGE_KEYS = {
    theme: 'tourism_theme',
    favorites: 'tourism_favorites',
    offline_data: 'tourism_offline_data',
    user_preferences: 'tourism_user_preferences',
    itinerary_cache: 'tourism_itinerary_cache',
    language: 'tourism_language'
};

const state = {
    currentLanguage: localStorage.getItem('tourism_language') || 'ku',
    selectedGovernment: null,
    selectedCategory: null,
    searchTerm: '',
    showFavoritesOnly: false,
    favorites: JSON.parse(localStorage.getItem(STORAGE_KEYS.favorites) || '[]'),
    governments: [],
    categories: [],
    locations: [],
    allLocations: [],
    userCoords: null,
    modal: null,
    theme: localStorage.getItem(STORAGE_KEYS.theme) || 'dark'
};

const languageData = {
    ku: {
        app_title: 'شوێنە گەشتیاریەکانی کوردستان',
        app_subtitle: 'نەخشەی شوێنە گەشتیاریەکانی کوردستان',
        government_filter: 'پاڵفتەکردن بەپێی پارێزگاکان',
        category_filter: 'پاڵفتەکردن بەپێی پۆلەکان',
        clear_all: 'پاککردنەوەی هەموو فلتەرەکان',
        focus_duhok: 'بچۆ بۆ پارێزگای دهۆک',
        locations: 'شوێنە گەشتیارییەکان',
        favorites: 'شوێنە دڵخوازەکان',
        about: 'دەربارەی پڕۆژە',
        privacy: 'پاراستنی تایبەتمەندییەکان',
        admin_panel: 'بەشی بەڕێوەبەرایەتی',
        view_details: 'وردەکاریی شوێن',
        send_feedback: 'ناردنی فیدبەک',
        total_visits: 'ژمارەی سەردانەکان',
        rating: 'هەڵسەنگاندن',
        directions: 'دیاریکردنی ڕێگا',
        no_locations: 'بەداخەوە هیچ ئەنجامێک نەدۆزرایەوە',
        feedback_saved: 'سوپاس، فیدبەکەکەت بە سەرکەوتوویی تۆمارکرا',
        locate_me: 'شوێنەکەم بدۆزەرەوە',
        map_layers: 'جۆرەکانی نەخشە',
        street_map: 'نەخشەی ئاسایی',
        satellite: 'نەخشەی مانگی دەستکرد',
        topography: 'نەخشەی تۆپۆگرافی',
        back_to_map: 'گەڕانەوە بۆ نەخشە'
    },
    en: {
        app_title: 'Kurdish Tourism Locations',
        app_subtitle: 'Kurdish Tourism Locations Map',
        gov_filter: 'Governments',
        category_filter: 'Categories',
        clear_all: 'Clear All',
        focus_duhok: 'Focus Duhok',
        locations: 'Locations',
        favorites: 'Favorites',
        about: 'About',
        contact: 'Contact',
        privacy: 'Privacy',
        admin_panel: 'Admin Panel',
        view_details: 'Details',
        send_feedback: 'Feedback',
        total_visits: 'Visits',
        rating: 'Rating',
        directions: 'Directions',
        no_locations: 'No locations found',
        feedback_saved: 'Feedback submitted',
        locate_me: 'Locate Me',
        map_layers: 'Map Layers',
        street_map: 'Street Map',
        satellite: 'Satellite',
        topography: 'Topography',
        back_to_map: 'Back to map'
    },
    ar: {
        app_title: 'مواقع السياحة الكردية',
        app_subtitle: 'خريطة مواقع السياحة الكردية',
        gov_filter: 'ولايات',
        category_filter: 'الفئات',
        clear_all: 'إلغاء جميع الفلاتر',
        focus_duhok: 'تركيز على دهوك',
        locations: 'المواقع',
        favorites: 'المفضلة',
        about: 'حول',
        contact: 'اتصل بنا',
        privacy: 'الخصوصية',
        admin_panel: 'لوحة الإدارة',
        view_details: 'تفاصيل الموقع',
        send_feedback: 'أرسل تعليق',
        total_visits: 'الزيارات',
        rating: 'التقييم',
        directions: 'الإتجاهات',
        no_locations: 'لم يتم العثور على مواقع',
        feedback_saved: 'تم إرسال التعليق',
        locate_me: 'حدد موقعي',
        map_layers: 'طبقات الخريطة',
        street_map: 'خريطة الشوارع',
        satellite: 'الأقمار الصناعية',
        topography: 'الطبوغرافيا',
        back_to_map: 'العودة إلى الخريطة'
    }
};

const uiText = {
    ku: {
        close: 'داخستن',
        cancel: 'هەڵوەشاندنەوە',
        submit: 'ناردن',
        notice: 'زانیاری',
        details: 'وردەکاری شوێن',
        your_name: 'ناوی تەواو',
        your_feedback: 'بۆچوونەکەت',
        rating: 'هەڵسەنگاندن',
        address: 'ناونیشان',
        phone: 'ژمارەی مۆبایل',
        website: 'ماڵپەڕ',
        opening_hours: 'کاتی کراوەبوون',
        ticket_price: 'نرخی بلیت',
        gallery: 'وێنەکان',
        feedback_hint: 'بۆچوونەکەت بنووسە و هەڵسەنگاندن بۆ ئەم شوێنە بکە.',
        all_fields: 'تکایە هەموو خانەکان پڕ بکەوە.',
        geolocation_not_supported: 'ئەم وێبگەڕە پشتگیری دیاریکردنی شوێن ناکات.',
        geolocation_failed: 'نەتوانرا شوێنەکەت دیاری بکرێت.',
        invalid_location_coords: 'ئەم شوێنە کۆردیناتی دروستی نییە.',
        you_are_here: 'تۆ لێرەیت',
        search_placeholder: 'گەڕان بەناوی شوێنەکان...'
    },
    en: {
        close: 'Close',
        cancel: 'Cancel',
        submit: 'Submit',
        notice: 'Notice',
        details: 'Location Details',
        your_name: 'Your name',
        your_feedback: 'Your feedback',
        rating: 'Rating',
        address: 'Address',
        phone: 'Phone',
        website: 'Website',
        opening_hours: 'Opening Hours',
        ticket_price: 'Ticket Price',
        gallery: 'Gallery',
        feedback_hint: 'Share your opinion and leave a rating for this place.',
        all_fields: 'Please fill in all fields.',
        geolocation_not_supported: 'Geolocation is not supported by your browser.',
        geolocation_failed: 'Unable to get your location.',
        invalid_location_coords: 'This location does not have valid map coordinates yet.',
        you_are_here: 'You are here',
        search_placeholder: 'Search locations...'
    },
    ar: {
        close: 'إغلاق',
        cancel: 'إلغاء',
        submit: 'إرسال',
        notice: 'ملاحظة',
        details: 'تفاصيل الموقع',
        your_name: 'اسمك',
        your_feedback: 'تعليقك',
        rating: 'التقييم',
        address: 'العنوان',
        phone: 'الهاتف',
        website: 'الموقع',
        opening_hours: 'ساعات الدوام',
        ticket_price: 'سعر التذكرة',
        gallery: 'الصور',
        feedback_hint: 'أضف رأيك مع تقييم هذا المكان.',
        all_fields: 'يرجى ملء جميع الحقول.',
        geolocation_not_supported: 'المتصفح لا يدعم تحديد الموقع.',
        geolocation_failed: 'تعذر الحصول على موقعك.',
        invalid_location_coords: 'هذا الموقع لا يحتوي بعد على إحداثيات صحيحة.',
        you_are_here: 'أنت هنا',
        search_placeholder: 'ابحث عن المواقع...'
    }
};

function t(key) {
    return uiText[state.currentLanguage]?.[key] || uiText.en[key] || key;
}

// Detect API base path - works from both root and pages/ folder
const API_BASE = window.location.pathname.includes('/pages/') ? '../api.php' : 'api.php';

async function api(endpoint, options = {}) {
    try {
        console.log(`API call: ${endpoint}`, options);
        const response = await fetch(`${API_BASE}?endpoint=${endpoint}`, options);
        
        if (!response.ok) {
            const errorText = await response.text();
            console.error(`API error ${response.status}:`, errorText);
            throw new Error(`HTTP ${response.status}: ${errorText}`);
        }
        
        const data = await response.json();
        console.log(`API response for ${endpoint}:`, data);
        return data;
    } catch (error) {
        console.error(`API call failed for ${endpoint}:`, error);
        throw error;
    }
}

function initModal() {
    state.modal = {
        root: document.getElementById('app-modal'),
        title: document.getElementById('app-modal-title'),
        body: document.getElementById('app-modal-body'),
        footer: document.getElementById('app-modal-footer'),
        close: document.getElementById('app-modal-close')
    };

    state.modal.close.addEventListener('click', closeModal);
    state.modal.root.querySelectorAll('[data-modal-close]').forEach((element) => {
        element.addEventListener('click', closeModal);
    });

    document.addEventListener('keydown', (event) => {
        if (event.key === 'Escape' && state.modal && !state.modal.root.hidden) {
            closeModal();
        }
    });
}

function openModal({ title = '', body = '', buttons = [] }) {
    state.modal.title.textContent = title;
    state.modal.body.innerHTML = body;
    state.modal.footer.innerHTML = '';

    buttons.forEach((button) => {
        const btn = document.createElement('button');
        btn.type = 'button';
        btn.className = `modal-btn ${button.variant === 'secondary' ? 'modal-btn--secondary' : 'modal-btn--primary'}`;
        btn.textContent = button.label;
        btn.addEventListener('click', async () => {
            if (button.onClick) {
                await button.onClick();
                return;
            }
            closeModal();
        });
        state.modal.footer.appendChild(btn);
    });

    state.modal.root.hidden = false;
    document.body.style.overflow = 'hidden';
}

function closeModal() {
    if (!state.modal) return;
    state.modal.root.hidden = true;
    state.modal.body.innerHTML = '';
    state.modal.footer.innerHTML = '';
    document.body.style.overflow = '';
}

function showNotice(message, title = t('notice')) {
    openModal({
        title,
        body: `<p>${escapeHtml(message)}</p>`,
        buttons: [{ label: t('close') }]
    });
}

function buildDetailsCard(label, value) {
    return `
        <div class="details-card">
            <strong>${escapeHtml(label)}</strong>
            <span>${escapeHtml(value || '-')}</span>
        </div>
    `;
}

// Duplicate initMapWithFallback function removed - using enhanced version below

function toggleLayer(layer, enabled) {
    if (enabled) {
        map.addLayer(layer);
    } else {
        map.removeLayer(layer);
    }
}

async function bootstrap() {
    const data = await api('bootstrap');
    state.governments = data.governments;
    state.categories = data.categories;
    renderGovernmentFilter();
    renderCategoryFilter();
    await loadLocations();
}

async function loadLocations(searchTerm = '') {
    try {
        const query = new URLSearchParams();
        if (state.selectedGovernment) query.set('government_id', state.selectedGovernment);
        if (state.selectedCategory) query.set('category_id', state.selectedCategory);
        if (searchTerm && searchTerm.trim()) query.set('search', searchTerm.trim());
        const suffix = query.toString() ? `&${query.toString()}` : '';
        const data = await api(`locations${suffix}`);

        if (data && data.locations && Array.isArray(data.locations)) {
            state.allLocations = data.locations;
            console.log('Locations loaded:', state.allLocations.length, 'items');

            if (searchTerm && state.allLocations.length > 0) {
                const firstLocation = state.allLocations[0];
                const lat = Number(firstLocation.lat);
                const lng = Number(firstLocation.lng);
                if (isValidCoordinate(lat, lng)) {
                    setTimeout(() => map.setView([lat, lng], 14), 100);
                }
            }
        } else {
            state.allLocations = [];
        }
        applyClientFilters();
    } catch (error) {
        console.error('Error loading locations:', error);
        state.allLocations = [];
        applyClientFilters();
    }
}

function applyClientFilters() {
    let filteredLocations = state.allLocations && state.allLocations.length > 0 ? [...state.allLocations] : [];

    if (state.showFavoritesOnly) {
        filteredLocations = filteredLocations.filter(loc => state.favorites && state.favorites.includes(loc.id));
    }

    state.locations = filteredLocations;
    renderLocationsList();
    updateMapMarkers();
}

function renderGovernmentFilter() {
    const container = document.getElementById('government-filter');
    container.innerHTML = state.governments.map((gov) => `
        <button class="gov-btn ${Number(state.selectedGovernment) === Number(gov.id) ? 'active' : ''}" onclick="selectGovernment(${gov.id})">
            <span class="gov-color" style="background:${gov.color}"></span>
            <span class="gov-name">${gov[`name_${state.currentLanguage}`]}</span>
        </button>
    `).join('');
}

function renderCategoryFilter() {
    const container = document.getElementById('category-filter');
    container.innerHTML = state.categories.map((cat) => `
        <button class="cat-btn ${Number(state.selectedCategory) === Number(cat.id) ? 'active' : ''}" onclick="selectCategory(${cat.id})">
            <i class="fas fa-${cat.icon || 'map-marker-alt'}"></i>
            <span class="cat-name">${cat[`name_${state.currentLanguage}`]}</span>
        </button>
    `).join('');
}

function renderLocationsList() {
    const container = document.getElementById('locations-list');
    if (!container) return;

    let list = container.querySelector('.location-items');
    if (!list) {
        list = document.createElement('div');
        list.className = 'location-items';
        container.appendChild(list);
    }

    const countElement = document.getElementById('location-count');
    if (countElement) {
        countElement.textContent = state.locations.length;
    }

    if (state.locations.length === 0) {
        list.innerHTML = `<div class="location-item">${languageData[state.currentLanguage].no_locations}</div>`;
        return;
    }

    list.innerHTML = state.locations.map((loc) => {
        const government = state.governments.find((item) => Number(item.id) === Number(loc.government_id));
        const category = state.categories.find((item) => Number(item.id) === Number(loc.category_id));
        const isFav = isFavorite(loc.id);
        const distance = getDistanceFromUser(loc);

        return `
            <div class="location-item fade-in" onclick="focusLocation(${loc.id})">
                <div class="location-item-img">
                    <img src="${loc.cover_image || 'https://placehold.co/150x150/1e293b/fbbf24?text=No+Image'}" alt="${escapeHtml(loc[`name_${state.currentLanguage}`] || loc.name_ku)}" onerror="this.src='https://placehold.co/150x150/1e293b/fbbf24?text=Error'">
                </div>
                <div class="location-item-content">
                    <div class="location-item-header">
                        <h4>${escapeHtml(loc[`name_${state.currentLanguage}`] || loc.name_ku)}</h4>
                        <div class="location-actions">
                            <button class="favorite-btn ${isFav ? 'active' : ''}" onclick="event.stopPropagation(); toggleFavorite(${loc.id})" title="${isFav ? 'Remove from favorites' : 'Add to favorites'}">
                                <i class="fas fa-heart"></i>
                            </button>
                            <button class="directions-btn" onclick="event.stopPropagation(); openDirections(${loc.id})" title="Get directions">
                                <i class="fas fa-directions"></i>
                            </button>
                        </div>
                    </div>
                    <div class="location-rating"><i class="fas fa-star"></i> ${Number(loc.average_rating || 0).toFixed(1)}</div>
                    <div class="location-details">${escapeHtml(government?.[`name_${state.currentLanguage}`] || '')} - ${escapeHtml(category?.[`name_${state.currentLanguage}`] || '')}</div>
                    <div class="location-meta">
                        <span><i class="fas fa-eye"></i> ${loc.total_visits} ${languageData[state.currentLanguage].total_visits}</span>
                        ${distance ? `<span><i class="fas fa-map-marker-alt"></i> ${distance.toFixed(1)} km</span>` : ''}
                    </div>
                </div>
            </div>
        `;
    }).join('');
}

function updateMapMarkers() {
    markers.forEach((marker) => map.removeLayer(marker));
    markers = [];

    state.locations.forEach((loc) => {
        const lat = Number(loc.lat);
        const lng = Number(loc.lng);
        if (!isValidCoordinate(lat, lng)) return;

        const government = state.governments.find((item) => Number(item.id) === Number(loc.government_id));
        const category = state.categories.find((item) => Number(item.id) === Number(loc.category_id));
        const icon = L.divIcon({
            html: `<div style="background:${government?.color || '#3498db'};width:32px;height:32px;border-radius:50%;border:3px solid #fff;display:flex;align-items:center;justify-content:center;color:#fff;box-shadow:0 8px 18px rgba(0,0,0,.18)"><i class="fas fa-${category?.icon || 'map-marker-alt'}"></i></div>`,
            className: '',
            iconSize: [32, 32],
            iconAnchor: [16, 32]
        });

        const marker = L.marker([lat, lng], { icon }).addTo(map);
        marker.locationId = loc.id;
        marker.bindPopup(buildPopup(loc, government, category));
        markers.push(marker);
    });
}

function buildPopup(loc, government, category) {
    const image = loc.cover_image ? `<img src="${escapeHtml(loc.cover_image)}" alt="" style="width:100%;height:140px;object-fit:cover;border-radius:10px;margin-bottom:10px;">` : '';
    const description = escapeHtml((loc[`description_${state.currentLanguage}`] || loc.description_ku || '').slice(0, 140));
    return `
        ${image}
        <div class="popup-header">
            <div class="popup-title">${escapeHtml(loc[`name_${state.currentLanguage}`] || loc.name_ku)}</div>
            <div class="popup-rating"><i class="fas fa-star"></i> ${Number(loc.average_rating || 0).toFixed(1)}</div>
        </div>
        <div class="popup-category">${escapeHtml(category?.[`name_${state.currentLanguage}`] || '')}</div>
        <div class="popup-description">${description}</div>
        <div style="font-size:.85rem;color:#64748b;margin-bottom:12px;">
            <i class="fas fa-map-marker-alt"></i> ${escapeHtml(government?.[`name_${state.currentLanguage}`] || '')}<br>
            <i class="fas fa-eye"></i> ${loc.total_visits} ${languageData[state.currentLanguage].total_visits}
        </div>
        <div class="popup-actions">
            <button class="popup-btn popup-details" onclick="viewLocationDetails(${loc.id})">${languageData[state.currentLanguage].view_details}</button>
            <button class="popup-btn popup-feedback" onclick="openDirections(${loc.id})">${languageData[state.currentLanguage].directions}</button>
        </div>
        <div class="popup-actions" style="margin-top:8px;">
            <button class="popup-btn popup-feedback" onclick="sendFeedback(${loc.id})">${languageData[state.currentLanguage].send_feedback}</button>
        </div>
    `;
}

async function viewLocationDetails(locationId) {
    try {
        const data = await api(`location&id=${locationId}`);
        const loc = data.location;

        await api('visits', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ location_id: locationId })
        });

        const gallery = (loc.images || []).length ? `
            <div style="margin-top:25px;">
                <h3 style="font-size:1.2em; margin-bottom:15px; display:flex; align-items:center; gap:8px;">
                    <i class="fas fa-images"></i> ${t('gallery') || 'Gallery'}
                </h3>
                <div style="display:grid; grid-template-columns:repeat(auto-fill, minmax(120px, 1fr)); gap:12px;">
                    ${(loc.images || []).map((img) => `
                        <div style="aspect-ratio:1; border-radius:12px; overflow:hidden; border:2px solid #eee; cursor:pointer;" onclick="window.open('${escapeHtml(img.image_path)}', '_blank')">
                            <img src="${escapeHtml(img.image_path)}" style="width:100%; height:100%; object-fit:cover; transition:transform 0.3s;" onmouseover="this.style.transform='scale(1.1)'" onmouseout="this.style.transform='scale(1)'">
                        </div>
                    `).join('')}
                </div>
            </div>
        ` : '';

        const feedbackHtml = (loc.feedback || []).length ? `
            <div style="margin-top:25px;">
                <h3 style="font-size:1.2em; margin-bottom:15px; display:flex; align-items:center; gap:8px;">
                    <i class="fas fa-comments"></i> ${t('feedback_title') || 'Feedback'}
                </h3>
                <div style="display:flex; flex-direction:column; gap:12px;">
                    ${(loc.feedback || []).map(f => {
                        const avatar = f.avatar ? f.avatar : 'assets/default-avatar.png';
                        const name = f.username || f.visitor_name;
                        const rating = '★'.repeat(f.rating) + '☆'.repeat(5 - f.rating);
                        const date = new Date(f.created_at).toLocaleDateString();
                        const userLink = f.user_id ? `onclick="viewUserProfile(${f.user_id})"` : '';
                        const cursor = f.user_id ? 'cursor:pointer' : '';

                        return `
                            <div style="background:#f9f9f9; padding:12px; border-radius:12px; border:1px solid #eee;">
                                <div style="display:flex; justify-content:space-between; align-items:flex-start; margin-bottom:8px;">
                                    <div style="display:flex; align-items:center; gap:10px; ${cursor}" ${userLink}>
                                        <img src="${avatar}" style="width:36px; height:36px; border-radius:50%; object-fit:cover; background:#eee;">
                                        <div>
                                            <div style="font-weight:600; font-size:0.95em;">${escapeHtml(name)}</div>
                                            <div style="color:#f1c40f; font-size:0.85em;">${rating}</div>
                                        </div>
                                    </div>
                                    <div style="font-size:0.75em; color:#999;">${date}</div>
                                </div>
                                <div style="font-size:0.9em; color:#444; line-height:1.4;">${escapeHtml(f.comment)}</div>
                            </div>
                        `;
                    }).join('')}
                </div>
            </div>
        ` : '';

        openModal({
            title: loc[`name_${state.currentLanguage}`] || loc.name_ku,
            body: `
                <div class="details-description">${escapeHtml(loc[`description_${state.currentLanguage}`] || loc.description_ku || '-')}</div>
                <div class="details-grid">
                    ${buildDetailsCard(t('address'), loc.address)}
                    ${buildDetailsCard(t('phone'), loc.phone)}
                    ${buildDetailsCard(t('website'), loc.website)}
                    ${buildDetailsCard(t('opening_hours'), loc.opening_hours)}
                    ${buildDetailsCard(t('ticket_price'), loc.ticket_price)}
                </div>
                ${gallery}
                ${feedbackHtml}
                <div style="margin-top:20px; text-align:center;">
                    <button class="btn btn-primary" onclick="sendFeedback(${loc.id})">
                        <i class="fas fa-plus"></i> ${t('add_feedback') || 'Add Feedback'}
                    </button>
                </div>
            `,
            buttons: [{ label: t('close') }]
        });

        await loadLocations();
    } catch (error) {
        showNotice(error.message);
    }
}

async function sendFeedback(locationId) {
    await checkUserAuth();
    if (!currentUser) {
        const msg = state.currentLanguage === 'ku' ? 'تکایە سەرەتا بچۆ ژوورەوە بۆ ناردنی فیدبەک.' : (state.currentLanguage === 'ar' ? 'الرجاء تسجيل الدخول أولاً لإرسال تعليق.' : 'Please log in first to send feedback.');
        showNotice(msg);
        setTimeout(() => window.location.href = 'pages/login.php', 1500);
        return;
    }

    openModal({
        title: languageData[state.currentLanguage].send_feedback,
        body: `
            <form id="feedback-form" class="modal-grid">
                <div class="modal-field modal-field--full">
                    <div class="modal-note">${escapeHtml(t('feedback_hint'))}</div>
                </div>
                <div class="modal-field">
                    <label class="modal-label" for="feedback-rating">${escapeHtml(t('rating'))}</label>
                    <select class="modal-select" id="feedback-rating" name="rating">
                        <option value="5">5</option>
                        <option value="4">4</option>
                        <option value="3">3</option>
                        <option value="2">2</option>
                        <option value="1">1</option>
                    </select>
                </div>
                <div class="modal-field modal-field--full">
                    <label class="modal-label" for="feedback-comment">${escapeHtml(t('your_feedback'))}</label>
                    <textarea class="modal-textarea" id="feedback-comment" name="comment" required></textarea>
                </div>
            </form>
        `,
        buttons: [
            { label: t('cancel'), variant: 'secondary' },
            {
                label: t('submit'),
                onClick: async () => {
                    const form = document.getElementById('feedback-form');
                    const formData = new FormData(form);
                    const payload = Object.fromEntries(formData.entries());

                    if (!payload.comment?.trim()) {
                        showNotice(t('all_fields'));
                        return;
                    }

                    try {
                        await api('feedback', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/json' },
                            body: JSON.stringify({
                                location_id: locationId,
                                comment: payload.comment.trim(),
                                rating: payload.rating
                            })
                        });
                        closeModal();
                        showNotice(languageData[state.currentLanguage].feedback_saved);
                    } catch (error) {
                        showNotice(error.message);
                    }
                }
            }
        ]
    });
}

function drawRoute(destLat, destLng) {
    if (routingControl) {
        map.removeControl(routingControl);
        if (routingActionBar) {
            routingActionBar.remove();
        }
        if (panelToggleBtn) {
            panelToggleBtn.remove();
        }
    }

    const lang = state.currentLanguage;
    const enLoc = L.Routing.Localization['en'];
    
    if (!L.Routing.Localization['ar']) {
        L.Routing.Localization['ar'] = {
            directions: Object.assign({}, enLoc.directions, {
                N: 'شمال', NE: 'شمال شرق', E: 'شرق', SE: 'جنوب شرق',
                S: 'جنوب', SW: 'جنوب غرب', W: 'غرب', NW: 'شمال غرب',
                SlightRight: 'يمين خفيف', Right: 'يمين', SharpRight: 'يمين حاد',
                SlightLeft: 'يسار خفيف', Left: 'يسار', SharpLeft: 'يسار حاد', Uturn: 'دوران للخلف'
            }),
            instructions: Object.assign({}, enLoc.instructions, {
                'Head': 'اتجه {dir} على {road}', 'Continue': 'استمر على {road}',
                'SlightRight': 'انعطف يمينا قليلا', 'Right': 'انعطف يمينا', 'SharpRight': 'انعطف يمينا بشدة',
                'SlightLeft': 'انعطف يسارا قليلا', 'Left': 'انعطف يسارا', 'SharpLeft': 'انعطف يسارا بشدة',
                'Uturn': 'استدر للخلف', 'Roundabout': 'خذ المخرج {exitStr} في الدوار',
                'DestinationReached': 'لقد وصلت', 'WaypointReached': 'وصلت إلى النقطة', 'TurnAround': 'استدر'
            }),
            formatOrder: function(n) { return n; },
            ui: Object.assign({}, enLoc.ui, { startPlaceholder: 'نقطة البداية', destinationPlaceholder: 'الوجهة' })
        };
    }
    
    if (!L.Routing.Localization['ku']) {
        L.Routing.Localization['ku'] = {
            directions: Object.assign({}, enLoc.directions, {
                N: 'باکوور', NE: 'باکووری ڕۆژهەڵات', E: 'ڕۆژهەڵات', SE: 'باشووری ڕۆژهەڵات',
                S: 'باشوور', SW: 'باشووری ڕۆژئاوا', W: 'ڕۆژئاوا', NW: 'باکووری ڕۆژئاوا',
                SlightRight: 'کەمێک ڕاست', Right: 'ڕاست', SharpRight: 'توند ڕاست',
                SlightLeft: 'کەمێک چەپ', Left: 'چەپ', SharpLeft: 'توند چەپ', Uturn: 'سوڕانەوە بۆ دواوە'
            }),
            instructions: Object.assign({}, enLoc.instructions, {
                'Head': 'بڕۆ بۆ {dir} لەسەر {road}', 'Continue': 'بەردەوام بە لەسەر {road}',
                'SlightRight': 'کەمێک بادە بۆ ڕاست', 'Right': 'بادە بۆ ڕاست', 'SharpRight': 'بە توندی بادە بۆ ڕاست',
                'SlightLeft': 'کەمێک بادە بۆ چەپ', 'Left': 'بادە بۆ چەپ', 'SharpLeft': 'بە توندی بادە بۆ چەپ',
                'Uturn': 'بسوڕێوە بۆ دواوە', 'Roundabout': 'لە بازنەکە دەرچوونی {exitStr} بگرە',
                'DestinationReached': 'گەیشتیتە شوێنی مەبەست', 'WaypointReached': 'گەیشتیتە خاڵەکە', 'TurnAround': 'بسوڕێوە'
            }),
            formatOrder: function(n) { return n; },
            ui: Object.assign({}, enLoc.ui, { startPlaceholder: 'خاڵی دەستپێک', destinationPlaceholder: 'مەبەست' })
        };
    }

    routingControl = L.Routing.control({
        waypoints: [
            L.latLng(state.userCoords.lat, state.userCoords.lng),
            L.latLng(destLat, destLng)
        ],
        language: lang,
        router: L.Routing.osrmv1({
            language: 'en'
        }),
        routeWhileDragging: true,
        addWaypoints: false,
        fitSelectedRoutes: true,
        showAlternatives: true,
        altLineOptions: {
            styles: [
                {color: '#1e293b', opacity: 0.15, weight: 8},
                {color: '#94a3b8', opacity: 0.7, weight: 6}
            ]
        },
        lineOptions: {
            styles: [
                {color: '#1e293b', opacity: 0.2, weight: 9},
                {color: '#3b82f6', opacity: 1, weight: 6}
            ]
        },
        createMarker: function() { return null; },
        show: true
    }).addTo(map);

    routingActionBar = document.createElement('div');
    routingActionBar.className = 'routing-action-bar fade-in';
    
    const isKu = state.currentLanguage === 'ku';
    const isAr = state.currentLanguage === 'ar';
    const startText = isKu ? 'دەستپێکردن' : (isAr ? 'بدء' : 'Start');
    const stopText = isKu ? 'وەستان' : (isAr ? 'توقف' : 'Stop');
    const cancelText = isKu ? 'داخستن' : (isAr ? 'إلغاء' : 'Cancel');

    const cancelBtn = document.createElement('button');
    cancelBtn.className = 'btn btn-danger action-cancel-btn';
    cancelBtn.innerHTML = `<i class="fas fa-times"></i> ${cancelText}`;
    cancelBtn.onclick = clearDirections;

    const startBtn = document.createElement('button');
    startBtn.className = 'btn btn-success action-start-btn';
    startBtn.innerHTML = `<i class="fas fa-location-arrow"></i> ${startText}`;
    startBtn.onclick = () => {
        if (!isNavigating) {
            isNavigating = true;
            startBtn.classList.remove('btn-success');
            startBtn.classList.add('btn-warning');
            startBtn.innerHTML = `<i class="fas fa-stop"></i> ${stopText}`;
            
            if (navigator.geolocation) {
                watchId = navigator.geolocation.watchPosition((position) => {
                    const lat = position.coords.latitude;
                    const lng = position.coords.longitude;
                    if (userMarker) userMarker.setLatLng([lat, lng]);
                    map.setView([lat, lng], 18, {animate: true});
                }, null, { enableHighAccuracy: true });
            }
        } else {
            isNavigating = false;
            if (watchId !== null) navigator.geolocation.clearWatch(watchId);
            startBtn.classList.remove('btn-warning');
            startBtn.classList.add('btn-success');
            startBtn.innerHTML = `<i class="fas fa-location-arrow"></i> ${startText}`;
            map.fitBounds(routingControl.getBounds());
        }
    };

    panelToggleBtn = document.createElement('button');
    panelToggleBtn.className = 'btn action-toggle-btn';
    panelToggleBtn.innerHTML = '<i class="fas fa-eye-slash"></i>';
    panelToggleBtn.onclick = () => {
        const container = document.querySelector('.leaflet-routing-container');
        if (container) {
            container.classList.toggle('closed');
            if (container.classList.contains('closed')) {
                panelToggleBtn.innerHTML = '<i class="fas fa-route"></i>';
                panelToggleBtn.classList.add('panel-closed');
            } else {
                panelToggleBtn.innerHTML = '<i class="fas fa-eye-slash"></i>';
                panelToggleBtn.classList.remove('panel-closed');
            }
        }
    };

    routingActionBar.appendChild(cancelBtn);
    routingActionBar.appendChild(startBtn);

    document.querySelector('.map-container').appendChild(panelToggleBtn);
    const appendActionBar = setInterval(() => {
        const container = document.querySelector('.leaflet-routing-container');
        if (container) {
            container.appendChild(routingActionBar);
            clearInterval(appendActionBar);
        }
    }, 100);

    function updateCamerasForRoute(route) {
        cameraMarkers.forEach(marker => map.removeLayer(marker));
        cameraMarkers = [];
        if (!route) return;

        const cameraLabel = isKu ? 'کامێرای هاتووچۆ' : (isAr ? 'كاميرا مراقبة' : 'Speed Camera');
        const cameraInterval = 4000;
        const speedInterval  = 2000;
        const coordinates  = route.coordinates;
        const totalDistance = route.summary.totalDistance;

        if (!coordinates || totalDistance < 1000) return;

        const camSize = 28;
        const spdSize = 30;
        let cameraDist = cameraInterval / 2;
        let speedDist  = speedInterval;
        let lastCoord  = coordinates[0];

        for (let i = 1; i < coordinates.length; i++) {
            const coord = coordinates[i];
            const dist  = lastCoord.distanceTo(coord);
            cameraDist += dist;
            speedDist  += dist;

            if (cameraDist >= cameraInterval) {
                const cameraIcon = L.divIcon({
                    html: `<div style="background:white;border-radius:50%;width:${camSize}px;height:${camSize}px;display:flex;align-items:center;justify-content:center;border:2px solid #ef4444;box-shadow:0 4px 10px rgba(239,68,68,0.4);color:#ef4444;font-size:14px;"><i class="fas fa-camera"></i></div>`,
                    className: 'traffic-camera-icon',
                    iconSize: [camSize, camSize],
                    iconAnchor: [camSize / 2, camSize / 2]
                });
                const marker = L.marker([coord.lat, coord.lng], {icon: cameraIcon})
                    .addTo(map)
                    .bindPopup(`<div style="text-align:center;font-family:'Noto Sans Arabic',sans-serif"><strong style="color:#ef4444;font-size:14px"><i class="fas fa-camera"></i> ${cameraLabel}</strong></div>`);
                cameraMarkers.push(marker);
                cameraDist = 0;
            }

            if (speedDist >= speedInterval) {
                const speedIcon = L.divIcon({
                    html: `<div style="background:white;border-radius:50%;width:${spdSize}px;height:${spdSize}px;display:flex;align-items:center;justify-content:center;border:3px solid #ef4444;box-shadow:0 4px 10px rgba(0,0,0,0.3);color:black;font-weight:bold;font-size:12px;font-family:sans-serif;">100</div>`,
                    className: 'speed-limit-icon',
                    iconSize: [spdSize, spdSize],
                    iconAnchor: [spdSize / 2, spdSize / 2]
                });
                const speedMarker = L.marker([coord.lat, coord.lng], {icon: speedIcon}).addTo(map);
                cameraMarkers.push(speedMarker);
                speedDist = 0;
            }
            lastCoord = coord;
        }
    }

    routingControl.on('routesfound', function(e) {
        if (e.routes && e.routes.length > 0) {
            updateCamerasForRoute(e.routes[0]);
        }
    });

    routingControl.on('routeselected', function(e) {
        if (e.route) {
            updateCamerasForRoute(e.route);
        }
    });
}

function clearDirections() {
    if (routingControl) {
        map.removeControl(routingControl);
        routingControl = null;
    }
    if (routingActionBar) {
        routingActionBar.remove();
        routingActionBar = null;
    }
    if (panelToggleBtn) {
        panelToggleBtn.remove();
        panelToggleBtn = null;
    }
    // Remove routing markers if they exist
    map.eachLayer(layer => {
        if (layer instanceof L.Marker && layer.options.routingMarker) {
            map.removeLayer(layer);
        }
    });
    activeDestLat = null;
    activeDestLng = null;
    if (isNavigating) {
        isNavigating = false;
        if (watchId !== null) {
            navigator.geolocation.clearWatch(watchId);
            watchId = null;
        }
    }
    cameraMarkers.forEach(marker => map.removeLayer(marker));
    cameraMarkers = [];
}

function drawDirectionsOnMap(destLat, destLng) {
    if (!state.userCoords) return;
    
    // Save destination for redraws (language/theme change)
    activeDestLat = destLat;
    activeDestLng = destLng;
    
    clearDirections();
    
    // Restore saved destination because clearDirections clears it
    activeDestLat = destLat;
    activeDestLng = destLng;
    
    // Ensure LRM translations exist for Arabic and Kurdish to prevent crashes
    if (typeof L !== 'undefined' && L.Routing && L.Routing.Localization && L.Routing.Localization['en']) {
        const enLoc = L.Routing.Localization['en'];
        
        if (!L.Routing.Localization['ar']) {
            L.Routing.Localization['ar'] = {
                directions: Object.assign({}, enLoc.directions, {
                    N: 'شمال', NE: 'شمال شرق', E: 'شرق', SE: 'جنوب شرق',
                    S: 'جنوب', SW: 'جنوب غرب', W: 'غرب', NW: 'شمال غرب',
                    SlightRight: 'يمين خفيف', Right: 'يمين', SharpRight: 'يمين حاد',
                    SlightLeft: 'يسار خفيف', Left: 'يسار', SharpLeft: 'يسار حاد',
                    Uturn: 'دوران للخلف'
                }),
                instructions: Object.assign({}, enLoc.instructions, {
                    'Head': 'اتجه {dir} على {road}', 'Continue': 'استمر على {road}',
                    'SlightRight': 'انعطف يمينا قليلا', 'Right': 'انعطف يمينا', 'SharpRight': 'انعطف يمينا بشدة',
                    'SlightLeft': 'انعطف يسارا قليلا', 'Left': 'انعطف يسارا', 'SharpLeft': 'انعطف يسارا بشدة',
                    'Uturn': 'استدر للخلف', 'Roundabout': 'خذ المخرج {exitStr} في الدوار',
                    'DestinationReached': 'لقد وصلت', 'WaypointReached': 'وصلت إلى النقطة', 'TurnAround': 'استدر'
                }),
                formatOrder: function(n) { return n; },
                ui: Object.assign({}, enLoc.ui, { startPlaceholder: 'نقطة البداية', destinationPlaceholder: 'الوجهة' })
            };
        }
        
        if (!L.Routing.Localization['ku']) {
            L.Routing.Localization['ku'] = {
                directions: Object.assign({}, enLoc.directions, {
                    N: 'باکوور', NE: 'باکووری ڕۆژهەڵات', E: 'ڕۆژهەڵات', SE: 'باشووری ڕۆژهەڵات',
                    S: 'باشوور', SW: 'باشووری ڕۆژئاوا', W: 'ڕۆژئاوا', NW: 'باکووری ڕۆژئاوا',
                    SlightRight: 'کەمێک ڕاست', Right: 'ڕاست', SharpRight: 'توند ڕاست',
                    SlightLeft: 'کەمێک چەپ', Left: 'چەپ', SharpLeft: 'توند چەپ', Uturn: 'سوڕانەوە بۆ دواوە'
                }),
                instructions: Object.assign({}, enLoc.instructions, {
                    'Head': 'بڕۆ بۆ {dir} لەسەر {road}', 'Continue': 'بەردەوام بە لەسەر {road}',
                    'SlightRight': 'کەمێک بادە بۆ ڕاست', 'Right': 'بادە بۆ ڕاست', 'SharpRight': 'بە توندی بادە بۆ ڕاست',
                    'SlightLeft': 'کەمێک بادە بۆ چەپ', 'Left': 'بادە بۆ چەپ', 'SharpLeft': 'بە توندی بادە بۆ چەپ',
                    'Uturn': 'بسوڕێوە بۆ دواوە', 'Roundabout': 'لە بازنەکە دەرچوونی {exitStr} بگرە',
                    'DestinationReached': 'گەیشتیتە شوێنی مەبەست', 'WaypointReached': 'گەیشتیتە خاڵەکە', 'TurnAround': 'بسوڕێوە'
                }),
                formatOrder: function(n) { return n; },
                ui: Object.assign({}, enLoc.ui, { startPlaceholder: 'خاڵی دەستپێک', destinationPlaceholder: 'مەبەست' })
            };
        }
    }

    const lang = state.currentLanguage || 'en';
    
    routingControl = L.Routing.control({
        waypoints: [
            L.latLng(state.userCoords.lat, state.userCoords.lng),
            L.latLng(destLat, destLng)
        ],
        language: lang,
        router: L.Routing.osrmv1({
            language: 'en' // Force backend to English to prevent HTTP 400 errors, local localization will translate it
        }),
        routeWhileDragging: true,
        addWaypoints: false,
        fitSelectedRoutes: true,
        showAlternatives: true,
        altLineOptions: {
            styles: [
                {color: '#1e293b', opacity: 0.15, weight: 8},
                {color: '#94a3b8', opacity: 0.7, weight: 6}
            ]
        },
        lineOptions: {
            styles: [
                {color: '#1e293b', opacity: 0.2, weight: 9}, // Shadow
                {color: '#3b82f6', opacity: 1, weight: 6}    // Main line
            ]
        },
        createMarker: function(i, wp, n) {
            const isLast = i === n - 1;
            const markerColor = isLast ? '#ef4444' : '#3b82f6';
            const markerIcon = isLast ? 'fa-map-marker-alt' : 'fa-user-circle';
            const label = isLast ? (state.currentLanguage === 'ku' ? 'مەبەست' : (state.currentLanguage === 'ar' ? 'الوجهة' : 'Destination')) : 
                                   (state.currentLanguage === 'ku' ? 'شوێنی تۆ' : (state.currentLanguage === 'ar' ? 'موقعك' : 'Your Location'));

            return L.marker(wp.latLng, {
                draggable: false,
                routingMarker: true,
                icon: L.divIcon({
                    className: 'routing-marker',
                    html: `<div style="background: ${markerColor}; color: white; width: 32px; height: 32px; border-radius: 50%; display: flex; align-items: center; justify-content: center; box-shadow: 0 2px 5px rgba(0,0,0,0.3); border: 2px solid white; position: relative; z-index: 1000;">
                             <i class="fas ${markerIcon}" style="font-size: 16px;"></i>
                             <div style="position: absolute; top: -35px; left: 50%; transform: translateX(-50%); background: rgba(0,0,0,0.85); color: white; padding: 4px 10px; border-radius: 6px; font-size: 12px; white-space: nowrap; font-family: inherit; pointer-events: none; border: 1px solid rgba(255,255,255,0.2); box-shadow: 0 2px 8px rgba(0,0,0,0.3);">
                                ${label}
                             </div>
                           </div>`,
                    iconSize: [32, 32],
                    iconAnchor: [16, 16]
                })
            });
        },
        show: true
    }).addTo(map);

    // Create a floating action bar for routing controls
    routingActionBar = document.createElement('div');
    routingActionBar.className = 'routing-action-bar fade-in';
    
    const isKu = state.currentLanguage === 'ku';
    const isAr = state.currentLanguage === 'ar';
    const startText = isKu ? 'دەستپێکردن' : (isAr ? 'بدء' : 'Start');
    const stopText = isKu ? 'وەستان' : (isAr ? 'توقف' : 'Stop');
    const cancelText = isKu ? 'داخستن' : (isAr ? 'إلغاء' : 'Cancel');

    const cancelBtn = document.createElement('button');
    cancelBtn.className = 'btn btn-danger action-cancel-btn';
    cancelBtn.innerHTML = `<i class="fas fa-times"></i> ${cancelText}`;
    cancelBtn.onclick = clearDirections;

    const startBtn = document.createElement('button');
    startBtn.className = 'btn btn-success action-start-btn';
    startBtn.innerHTML = `<i class="fas fa-location-arrow"></i> ${startText}`;
    startBtn.onclick = () => {
        if (!isNavigating) {
            isNavigating = true;
            startBtn.classList.remove('btn-success');
            startBtn.classList.add('btn-warning');
            startBtn.innerHTML = `<i class="fas fa-stop"></i> ${stopText}`;
            
            if (navigator.geolocation) {
                watchId = navigator.geolocation.watchPosition((position) => {
                    const lat = position.coords.latitude;
                    const lng = position.coords.longitude;
                    if (userMarker) userMarker.setLatLng([lat, lng]);
                    map.setView([lat, lng], 18, {animate: true});
                }, null, { enableHighAccuracy: true });
            }
        } else {
            isNavigating = false;
            if (watchId !== null) navigator.geolocation.clearWatch(watchId);
            startBtn.classList.remove('btn-warning');
            startBtn.classList.add('btn-success');
            startBtn.innerHTML = `<i class="fas fa-location-arrow"></i> ${startText}`;
            map.fitBounds(routingControl.getBounds());
        }
    };

    panelToggleBtn = document.createElement('button');
    panelToggleBtn.className = 'btn action-toggle-btn';
    panelToggleBtn.innerHTML = '<i class="fas fa-eye-slash"></i>';
    panelToggleBtn.onclick = () => {
        const container = document.querySelector('.leaflet-routing-container');
        if (container) {
            container.classList.toggle('closed');
            const isClosed = container.classList.contains('closed');
            if (isClosed) {
                panelToggleBtn.innerHTML = '<i class="fas fa-route"></i>';
                panelToggleBtn.classList.add('panel-closed');
                if (routingActionBar) routingActionBar.classList.add('panel-closed');
            } else {
                panelToggleBtn.innerHTML = '<i class="fas fa-eye-slash"></i>';
                panelToggleBtn.classList.remove('panel-closed');
                if (routingActionBar) routingActionBar.classList.remove('panel-closed');
            }
        }
    };

    routingActionBar.appendChild(cancelBtn);
    routingActionBar.appendChild(startBtn);

    const mapContainer = document.querySelector('.map-container');
    mapContainer.appendChild(panelToggleBtn);
    // Float the action bar above the panel on ALL screen sizes
    mapContainer.appendChild(routingActionBar);

    // Function to draw cameras on the active route
    function updateCamerasForRoute(route) {
        cameraMarkers.forEach(marker => map.removeLayer(marker));
        cameraMarkers = [];
        if (!route) return;

        const isKu = state.currentLanguage === 'ku';
        const isAr = state.currentLanguage === 'ar';
        const cameraLabel = isKu ? 'کامێرای هاتووچۆ' : (isAr ? 'كاميرا مراقبة' : 'Speed Camera');

        const cameraInterval = 4000;
        const speedInterval  = 2000;
        const coordinates  = route.coordinates;
        const totalDistance = route.summary.totalDistance;

        if (!coordinates || totalDistance < 1000) return;

        const camSize = 28;
        const spdSize = 30;

        let cameraDist = cameraInterval / 2;
        let speedDist  = speedInterval;
        let lastCoord  = coordinates[0];

        for (let i = 1; i < coordinates.length; i++) {
            const coord = coordinates[i];
            const dist  = lastCoord.distanceTo(coord);
            cameraDist += dist;
            speedDist  += dist;

            // Speed Camera
            if (cameraDist >= cameraInterval) {
                const cameraIcon = L.divIcon({
                    html: `<div style="background:white;border-radius:50%;width:${camSize}px;height:${camSize}px;display:flex;align-items:center;justify-content:center;border:2px solid #ef4444;box-shadow:0 4px 10px rgba(239,68,68,0.4);color:#ef4444;font-size:14px;"><i class="fas fa-camera"></i></div>`,
                    className: 'traffic-camera-icon',
                    iconSize: [camSize, camSize],
                    iconAnchor: [camSize / 2, camSize / 2]
                });
                const marker = L.marker([coord.lat, coord.lng], {icon: cameraIcon})
                    .addTo(map)
                    .bindPopup(`<div style="text-align:center;font-family:'Noto Sans Arabic',sans-serif"><strong style="color:#ef4444;font-size:14px"><i class="fas fa-camera"></i> ${cameraLabel}</strong></div>`);
                cameraMarkers.push(marker);
                cameraDist = 0;
            }

            // Speed Limit Sign
            if (speedDist >= speedInterval) {
                const speedLimitIcon = L.divIcon({
                    html: `<div style="background:white;border-radius:50%;width:${spdSize}px;height:${spdSize}px;display:flex;align-items:center;justify-content:center;border:4px solid #ef4444;box-shadow:0 4px 10px rgba(0,0,0,0.3);color:black;font-size:13px;font-weight:bold;">100</div>`,
                    className: 'speed-limit-icon',
                    iconSize: [spdSize, spdSize],
                    iconAnchor: [spdSize / 2, spdSize / 2]
                });
                const marker = L.marker([coord.lat, coord.lng], {icon: speedLimitIcon}).addTo(map);
                cameraMarkers.push(marker);
                speedDist = 0;
            }

            lastCoord = coord;
        }
    }

    // Update dynamically when recalculating/dragging OR when clicking alternative routes
    routingControl.on('routesfound', function(e) {
        if (e.routes && e.routes.length > 0) {
            updateCamerasForRoute(e.routes[0]);
        }
    });

    routingControl.on('routeselected', function(e) {
        updateCamerasForRoute(e.route);
    });
}

function openDirections(locationId) {
    const loc = state.locations.find((item) => Number(item.id) === Number(locationId));
    if (!loc) return;
    
    const lat = Number(loc.lat);
    const lng = Number(loc.lng);
    
    if (!state.userCoords) {
        if (!navigator.geolocation) {
            showNotice(t('geolocation_not_supported'));
            window.open(`https://www.google.com/maps/dir/?api=1&destination=${lat},${lng}`, '_blank');
            return;
        }
        
        navigator.geolocation.getCurrentPosition((position) => {
            const lat2 = position.coords.latitude;
            const lng2 = position.coords.longitude;

            if (isNaN(lat2) || isNaN(lng2)) {
                showNotice(t('geolocation_failed'));
                window.open(`https://www.google.com/maps/dir/?api=1&destination=${lat},${lng}`, '_blank');
                return;
            }

            state.userCoords = { lat: lat2, lng: lng2 };
            if (userMarker) {
                map.removeLayer(userMarker);
            }
            userMarker = L.marker([lat2, lng2]).addTo(map);
            userMarker.bindPopup(t('you_are_here')).openPopup();
            
            drawDirectionsOnMap(lat, lng);
        }, (error) => {
            showNotice(t('geolocation_failed'));
            console.error('Directions geolocation error:', error.code, error.message);
            window.open(`https://www.google.com/maps/dir/?api=1&destination=${lat},${lng}`, '_blank');
        }, {
            enableHighAccuracy: true,
            timeout: 10000,
            maximumAge: 0
        });
    } else {
        drawDirectionsOnMap(lat, lng);
    }
}

async function locateUser() {
    if (!navigator.geolocation) {
        showNotice(t('geolocation_not_supported'));
        return;
    }

    // Check if secure context (required for geolocation)
    if (location.protocol !== 'https:' && location.hostname !== 'localhost' && location.hostname !== '127.0.0.1') {
        showNotice(state.currentLanguage === 'ku' ? 'بۆ دیاریکردنی شوێن پێویستە بە HTTPS بەستەوە بیت' : 'Location requires HTTPS connection');
        return;
    }

    showNotice(state.currentLanguage === 'ku' ? 'شوێنی تۆ دۆزرایەوە...' : 'Detecting your location...');

    navigator.geolocation.getCurrentPosition((position) => {
        const lat = position.coords.latitude;
        const lng = position.coords.longitude;

        // Validate coordinates
        if (isNaN(lat) || isNaN(lng) || lat < -90 || lat > 90 || lng < -180 || lng > 180) {
            showNotice(state.currentLanguage === 'ku' ? 'کوئۆردینەیتی شوێن نادروستە' : 'Invalid location coordinates');
            return;
        }

        state.userCoords = { lat, lng };
        console.log('✓ User location:', lat, lng);

        map.setView([lat, lng], 14);

        if (userMarker) {
            map.removeLayer(userMarker);
        }

        let iconOptions = {};
        if (typeof currentUser !== 'undefined' && currentUser) {
            if (currentUser.avatar) {
                iconOptions = {
                    icon: L.divIcon({
                        className: 'user-avatar-marker',
                        html: `<img src="${currentUser.avatar}" style="width:40px;height:40px;border-radius:50%;border:2px solid var(--primary-color);box-shadow:0 0 10px rgba(0,0,0,0.5); object-fit:cover;">`,
                        iconSize: [40, 40],
                        iconAnchor: [20, 20]
                    })
                };
            } else if (currentUser.full_name) {
                iconOptions = {
                    icon: L.divIcon({
                        className: 'user-avatar-marker',
                        html: `<div style="width:40px;height:40px;border-radius:50%;border:2px solid var(--primary-color);background:var(--primary-color);color:white;display:flex;align-items:center;justify-content:center;font-weight:bold;box-shadow:0 0 10px rgba(0,0,0,0.5); font-family:var(--font-family);">${currentUser.full_name.charAt(0).toUpperCase()}</div>`,
                        iconSize: [40, 40],
                        iconAnchor: [20, 20]
                    })
                };
            }
        }

        userMarker = L.marker([lat, lng], iconOptions).addTo(map);
        userMarker.bindPopup(t('you_are_here')).openPopup();

        // Add accuracy circle
        if (position.coords.accuracy) {
            L.circle([lat, lng], {
                radius: position.coords.accuracy,
                color: '#3498db',
                fillColor: '#3498db',
                fillOpacity: 0.1,
                weight: 1
            }).addTo(map);
        }

        // Refresh location list to show distances
        renderLocationsList();
    }, (error) => {
        let msg = t('geolocation_failed');
        if (error.code === 1) {
            msg = state.currentLanguage === 'ku' ? 'مۆڵەتی شوێنی پێ نەدرا. تکایە مۆڵەت بدە.' : 'Location permission denied. Please allow location access.';
        } else if (error.code === 2) {
            msg = state.currentLanguage === 'ku' ? 'شوێنی تۆ بەردەست نیە' : 'Location unavailable';
        } else if (error.code === 3) {
            msg = state.currentLanguage === 'ku' ? 'کاتی دۆزینەوەی شوێن تێپەڕا' : 'Location request timed out';
        }
        showNotice(msg);
        console.error('Geolocation error:', error.code, error.message);
    }, {
        enableHighAccuracy: true,
        timeout: 10000,
        maximumAge: 0
    });
}

function focusLocation(id) {
    const loc = state.locations.find((item) => Number(item.id) === Number(id));
    if (!loc) return;
    const lat = Number(loc.lat);
    const lng = Number(loc.lng);
    if (!isValidCoordinate(lat, lng)) {
        showNotice(t('invalid_location_coords'));
        return;
    }
    map.setView([lat, lng], 14);
    const marker = markers.find((item) => Number(item.locationId) === Number(id));
    if (marker) marker.openPopup();
}

function selectGovernment(govId) {
    state.selectedGovernment = Number(state.selectedGovernment) === Number(govId) ? null : Number(govId);
    renderGovernmentFilter();
    loadLocations();
    
    if (state.selectedGovernment) {
        const gov = state.governments.find((g) => Number(g.id) === Number(govId));
        if (gov && gov.lat && gov.lng) {
            map.setView([Number(gov.lat), Number(gov.lng)], gov.zoom_level || 9);
        }
    } else {
        // Reset to default view if government is unselected
        map.setView([36.1911, 44.0092], 7);
    }
}

function selectCategory(catId) {
    state.selectedCategory = Number(state.selectedCategory) === Number(catId) ? null : Number(catId);
    renderCategoryFilter();
    loadLocations();
}

function clearFilters() {
    state.selectedGovernment = null;
    state.selectedCategory = null;
    renderGovernmentFilter();
    renderCategoryFilter();
    loadLocations();
    clearDirections();
    map.setView([36.1911, 44.0092], 7);
}

function resetToDuhok() {
    const duhok = state.governments.find((gov) => (gov.name_en || '').toLowerCase() === 'duhok') || state.governments[0];
    if (!duhok) return;
    state.selectedGovernment = duhok.id;
    renderGovernmentFilter();
    loadLocations();
    if (duhok.lat && duhok.lng) {
        map.setView([Number(duhok.lat), Number(duhok.lng)], duhok.zoom_level || 10);
    }
}

function changeLanguage(lang) {
    if (!languageData[lang]) return;
    state.currentLanguage = lang;
    localStorage.setItem(STORAGE_KEYS.language, lang);
    document.documentElement.lang = lang;
    document.documentElement.dir = lang === 'en' ? 'ltr' : 'rtl';
    document.querySelectorAll('.lang-btn').forEach((button) => button.classList.toggle('active', button.dataset.lang === lang));
    document.querySelectorAll('.lang-text').forEach((element) => { const key = element.dataset.key; if (languageData[lang][key]) element.textContent = languageData[lang][key]; });
    const searchInput = document.getElementById('search-input'); if (searchInput) searchInput.placeholder = t('search_placeholder');
    renderGovernmentFilter(); renderCategoryFilter(); renderLocationsList(); updateMapMarkers();
    
    // Redraw directions if active to translate instructions and buttons
    if (activeDestLat !== null && activeDestLng !== null) {
        const lat = activeDestLat;
        const lng = activeDestLng;
        // Temporarily save navigation state if we want to, or just reset it
        const wasNavigating = isNavigating;
        drawDirectionsOnMap(lat, lng);
    }
}

function updateLanguageTexts() {
    document.querySelectorAll('.lang-text').forEach((element) => {
        const key = element.dataset.key;
        if (languageData[state.currentLanguage][key]) {
            element.textContent = languageData[state.currentLanguage][key];
        }
    });
}

function toggleSidebar() {
    const sidebar = document.getElementById('sidebar');
    const toggleBtn = document.getElementById('sidebar-toggle');
    const headerMenuBtn = document.getElementById('header-menu-btn');
    if (sidebar) {
        const isClosing = !sidebar.classList.contains('closed');
        sidebar.classList.toggle('closed');
        
        // Update main toggle button
        if (toggleBtn) {
            const icon = toggleBtn.querySelector('i');
            if (icon) {
                if (isClosing) {
                    icon.classList.remove('fa-times');
                    icon.classList.add('fa-bars');
                } else {
                    icon.classList.remove('fa-bars');
                    icon.classList.add('fa-times');
                }
            }
        }

        // Update header menu button
        if (headerMenuBtn) {
            const icon2 = headerMenuBtn.querySelector('i');
            if (icon2) {
                if (isClosing) {
                    icon2.classList.remove('fa-times');
                    icon2.classList.add('fa-bars');
                } else {
                    icon2.classList.remove('fa-bars');
                    icon2.classList.add('fa-times');
                }
            }
        }
        
        // Ensure map scroll wheel zoom is enabled when sidebar is closed
        if (isClosing) {
            // Sidebar is being closed, enable map zoom
            if (map && map.scrollWheelZoom && !map.scrollWheelZoom.enabled()) {
                map.scrollWheelZoom.enable();
            }
        }
        
        setTimeout(() => map?.invalidateSize(), 360);
    }
}

function escapeHtml(value) {
    return String(value ?? '').replace(/[&<>"']/g, (char) => ({
        '&': '&amp;',
        '<': '&lt;',
        '>': '&gt;',
        '"': '&quot;',
        "'": '&#39;'
    }[char]));
}

function isValidCoordinate(lat, lng) {
    return Number.isFinite(lat) && Number.isFinite(lng) && lat >= -90 && lat <= 90 && lng >= -180 && lng <= 180;
}

async function searchLocationsFromDatabase(searchTerm) {
    await loadLocations(searchTerm);
}

function initSearch() {
    const searchInput = document.getElementById('search-input');
    const clearSearchBtn = document.getElementById('clear-search');

    if (!searchInput) return;

    let searchTimeout;

    searchInput.addEventListener('input', () => {
        clearTimeout(searchTimeout);

        searchTimeout = setTimeout(() => {
            searchLocationsFromDatabase(searchInput.value);
        }, 300);

        if (clearSearchBtn) {
            clearSearchBtn.style.display = searchInput.value ? 'flex' : 'none';
        }
    });

    if (clearSearchBtn) {
        clearSearchBtn.addEventListener('click', async () => {
            searchInput.value = '';
            clearSearchBtn.style.display = 'none';
            await loadLocations();
        });
    }
}

function calculateDistance(lat1, lon1, lat2, lon2) {
    const R = 6371;
    const dLat = (lat2 - lat1) * Math.PI / 180;
    const dLon = (lon2 - lon1) * Math.PI / 180;
    const a =
        Math.sin(dLat / 2) * Math.sin(dLat / 2) +
        Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) *
        Math.sin(dLon / 2) * Math.sin(dLon / 2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    return R * c;
}

function getDistanceFromUser(location) {
    if (!state.userCoords) return null;
    const { lat: userLat, lng: userLng } = state.userCoords;
    return calculateDistance(userLat, userLng, Number(location.lat), Number(location.lng));
}

function showDirections(location) {
    const lat = Number(location.lat);
    const lng = Number(location.lng);
    const url = `https://www.google.com/maps/dir/?api=1&destination=${lat},${lng}`;
    window.open(url, '_blank');
}

function toggleFavoritesView() {
    state.showFavoritesOnly = !state.showFavoritesOnly;
    const favoritesBtn = document.getElementById('toggle-favorites');
    if (favoritesBtn) {
        favoritesBtn.classList.toggle('active', state.showFavoritesOnly);
    }
    loadLocations();
}

function isFavorite(id) {
    return state.favorites && state.favorites.includes(id);
}

async function loadServerFavorites() {
    try {
        const data = await api('favorites');
        if (data.success && Array.isArray(data.favorites)) {
            state.favorites = data.favorites;
            localStorage.setItem(STORAGE_KEYS.favorites, JSON.stringify(state.favorites));
            renderLocationsList();
        }
    } catch (error) {
        console.error('Failed to load server favorites:', error);
    }
}

async function toggleFavorite(id) {
    if (!state.favorites) {
        state.favorites = [];
    }
    const index = state.favorites.indexOf(id);
    const wasFavorite = index > -1;

    if (wasFavorite) {
        state.favorites.splice(index, 1);
    } else {
        state.favorites.push(id);
    }
    localStorage.setItem(STORAGE_KEYS.favorites, JSON.stringify(state.favorites));
    renderLocationsList();

    if (currentUser) {
        try {
            await api('favorites', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ location_id: id })
            });
        } catch (error) {
            console.error('Failed to sync favorite with server:', error);
            state.favorites.splice(wasFavorite ? index : state.favorites.indexOf(id), 1);
            if (!wasFavorite) state.favorites.push(id);
            localStorage.setItem(STORAGE_KEYS.favorites, JSON.stringify(state.favorites));
            renderLocationsList();
        }
    }
}

function initTheme() {
    // Apply saved theme
    const isLight = state.theme === 'light';
    document.body.classList.toggle('light-mode', isLight);
    
    const themeToggle = document.getElementById('theme-toggle');
    if (themeToggle) {
        const icon = themeToggle.querySelector('i');
        if (icon) {
            icon.className = isLight ? 'fas fa-sun' : 'fas fa-moon';
        }
        
        themeToggle.addEventListener('click', () => {
            state.theme = state.theme === 'dark' ? 'light' : 'dark';
            localStorage.setItem(STORAGE_KEYS.theme, state.theme);
            document.body.classList.toggle('light-mode', state.theme === 'light');
            
            const newIcon = themeToggle.querySelector('i');
            if (newIcon) {
                newIcon.className = state.theme === 'light' ? 'fas fa-sun' : 'fas fa-moon';
            }
            
            // Redraw map markers for theme specific styles if any
            updateMapMarkers();
        });
    }
}

function showPageContent(title, content) {
    const pageContent = document.getElementById('page-content');
    const pageTitle = document.getElementById('page-title');
    const pageBody = document.getElementById('page-body');
    const mapEl = document.getElementById('map');
    
    if (!pageContent || !pageTitle || !pageBody) return;
    
    pageTitle.textContent = title;
    pageBody.innerHTML = content;
    pageContent.hidden = false;
    if (mapEl) mapEl.style.display = 'none';
    
    updateLanguageTexts();
}

function showMap() {
    const pageContent = document.getElementById('page-content');
    const mapEl = document.getElementById('map');
    
    if (pageContent) pageContent.hidden = true;
    if (mapEl) mapEl.style.display = 'block';
    
    if (window.map) {
        setTimeout(() => window.map.invalidateSize(), 100);
    }
}

async function loadPage(page) {
    try {
        const response = await fetch(page + '.html');
        if (!response.ok) throw new Error('Page not found');
        const html = await response.text();
        
        const parser = new DOMParser();
        const doc = parser.parseFromString(html, 'text/html');
        
        let contentEl = doc.querySelector('.privacy-content') ||
                        doc.querySelector('.page-content') ||
                        doc.querySelector('.main-content > div');
        
        if (!contentEl) {
            contentEl = doc.querySelector('body');
        }
        
        const header = contentEl.querySelector('header');
        const footer = contentEl.querySelector('footer');
        if (header) header.remove();
        if (footer) footer.remove();
        
        const pageTitle = doc.querySelector('title')?.textContent ||
                         doc.querySelector('h1, h2')?.textContent ||
                         page.charAt(0).toUpperCase() + page.slice(1);
        
        showPageContent(pageTitle, contentEl.innerHTML);
    } catch (error) {
        console.error('Failed to load page:', error);
        showPageContent('Error', '<p>Unable to load page content.</p>');
    }
}

function initPageLinks() {
    document.querySelectorAll('.page-link').forEach(link => {
        link.addEventListener('click', (e) => {
            e.preventDefault();
            window.open(link.href, '_blank');
        });
    });
}

// Simple direct map initialization
async function initializeApplication() {
    console.log('Starting application initialization...');
    
    try {
        if (typeof L !== 'undefined' && document.getElementById('map')) {
            console.log('Creating map...');
            
            // Create map
            map = L.map('map').setView([36.1911, 44.0092], 7);
            
            // Add tile layer
            streetsLayer = L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                attribution: '&copy; OpenStreetMap contributors',
                maxZoom: 19
            }).addTo(map);

            satelliteLayer = L.tileLayer('https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}', {
                attribution: '&copy; Esri',
                maxZoom: 19
            });

            topoLayer = L.tileLayer('https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png', {
                attribution: '&copy; OpenTopoMap',
                maxZoom: 17
            });

            // Layer toggle handlers
            const streetsCheckbox = document.getElementById('streets-layer');
            const satelliteCheckbox = document.getElementById('satellite-layer');
            const topoCheckbox = document.getElementById('topo-layer');

            if (streetsCheckbox) {
                streetsCheckbox.addEventListener('change', function() {
                    toggleLayer(streetsLayer, this.checked);
                });
            }
            if (satelliteCheckbox) {
                satelliteCheckbox.addEventListener('change', function() {
                    toggleLayer(satelliteLayer, this.checked);
                });
            }
            if (topoCheckbox) {
                topoCheckbox.addEventListener('change', function() {
                    toggleLayer(topoLayer, this.checked);
                });
            }

            console.log('✓ Map created successfully');
            
            // Initialize UI components
            if (typeof initModal === 'function') initModal();
            if (typeof initEnhancedSearch === 'function') initEnhancedSearch();
            if (typeof initTheme === 'function') initTheme();
            initializeSidebar();
            
            // Initialize location tracking
            const locateMeBtn = document.getElementById('locate-me');
            if (locateMeBtn) {
                locateMeBtn.addEventListener('click', locateUser);
                console.log('✓ Locate me button initialized');
            }
            
            // Automatic location tracking on page load
            if (navigator.geolocation) {
                setTimeout(() => {
                    navigator.geolocation.getCurrentPosition(
                        (position) => {
                            const lat = position.coords.latitude;
                            const lng = position.coords.longitude;

                            if (isNaN(lat) || isNaN(lng) || lat < -90 || lat > 90 || lng < -180 || lng > 180) {
                                console.log('Invalid auto-detect coordinates');
                                return;
                            }

                            state.userCoords = { lat, lng };
                            console.log('✓ User location auto-detected:', lat, lng);

                            if (userMarker) {
                                map.removeLayer(userMarker);
                            }
                            userMarker = L.marker([lat, lng]).addTo(map);
                            userMarker.bindPopup(t('you_are_here'));

                            if (position.coords.accuracy) {
                                L.circle([lat, lng], {
                                    radius: position.coords.accuracy,
                                    color: '#3498db',
                                    fillColor: '#3498db',
                                    fillOpacity: 0.1,
                                    weight: 1
                                }).addTo(map);
                            }

                            renderLocationsList();
                        },
                        (error) => {
                            console.log('Auto location detection failed:', error.code, error.message);
                        },
                        {
                            enableHighAccuracy: true,
                            timeout: 10000,
                            maximumAge: 0
                        }
                    );
                }, 2000);
            }
            
            // Load bootstrap data (governments, categories, locations)
            try {
                await bootstrap();
                console.log('✓ Bootstrap data loaded - governments and categories rendered');
            } catch (error) {
                console.error('Bootstrap failed, using fallback:', error);
                if (typeof useFallbackBootstrapData === 'function') {
                    useFallbackBootstrapData();
                }
            }
            
            // Initialize enhanced features
            initializeEnhancedFeatures();
            
            // Track visits
            try {
                await api('visits', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({})
                });
            } catch (error) {
                // Visits tracking is non-critical
            }
            
        } else {
            console.error('Leaflet or map container not available');
        }
        
    } catch (error) {
        console.error('Application initialization failed:', error);
    }
}

// Initialize sidebar
function initializeSidebar() {
    const sidebar = document.getElementById('sidebar');
    const toggleBtn = document.getElementById('sidebar-toggle');
    if (sidebar && toggleBtn) {
        const icon = toggleBtn.querySelector('i');
        if (icon) {
            if (sidebar.classList.contains('closed')) {
                icon.classList.remove('fa-times');
                icon.classList.add('fa-bars');
            } else {
                icon.classList.remove('fa-bars');
                icon.classList.add('fa-times');
            }
        }
    }
}

// Use multiple initialization methods to ensure it works
document.addEventListener('DOMContentLoaded', initializeApplication);

// Also try window load as backup
window.addEventListener('load', () => {
    if (!map) {
        console.log('DOMContentLoaded failed, trying window.load...');
        setTimeout(initializeApplication, 500);
    }
});

// Final backup - try immediately if everything else fails
setTimeout(() => {
    if (!map && document.readyState === 'complete') {
        console.log('Final initialization attempt...');
        initializeApplication();
    }
}, 2000);

// Expose functions to global scope
window.changeLanguage = changeLanguage;
window.showMap = showMap;
window.selectGovernment = selectGovernment;
window.selectCategory = selectCategory;
window.clearFilters = clearFilters;
window.resetToDuhok = resetToDuhok;
async function viewUserProfile(userId) {
    try {
        const response = await fetch(`${API_BASE}?endpoint=public_profile&id=${userId}`);
        const data = await response.json();

        if (!data.success) {
            throw new Error(data.error || 'User not found');
        }

        const user = data.user;
        const avatar = user.avatar ? user.avatar : 'assets/default-avatar.png';
        const lang = state.currentLanguage || 'ku';

        let suggestionsHtml = (user.suggestions || []).length ? `
            <div style="margin-top:20px;">
                <h4 style="border-bottom:2px solid #eee; padding-bottom:8px; margin-bottom:12px;">
                    <i class="fas fa-map-marker-alt"></i> ${lang === 'ku' ? 'شوێنە پێشنیارکراوەکان' : 'Suggested Locations'}
                </h4>
                <div style="display:grid; grid-template-columns:1fr 1fr; gap:10px;">
                    ${user.suggestions.map(s => `
                        <div style="background:#f8f9fa; border-radius:8px; overflow:hidden; border:1px solid #eee;">
                            ${s.image_path ? `<img src="${s.image_path}" style="width:100%; height:80px; object-fit:cover;">` : '<div style="height:80px; background:#eee;"></div>'}
                            <div style="padding:8px; font-size:0.85em; font-weight:600;">${escapeHtml(s[`name_${lang}`] || s.name_ku)}</div>
                        </div>
                    `).join('')}
                </div>
            </div>
        ` : '';

        let feedbackHtml = (user.feedback || []).length ? `
            <div style="margin-top:20px;">
                <h4 style="border-bottom:2px solid #eee; padding-bottom:8px; margin-bottom:12px;">
                    <i class="fas fa-comments"></i> ${lang === 'ku' ? 'فیدبەکەکان' : 'Feedbacks'}
                </h4>
                <div style="display:flex; flex-direction:column; gap:10px;">
                    ${user.feedback.map(f => `
                        <div style="background:#fff; border:1px solid #eee; border-radius:10px; padding:10px;">
                            <div style="font-weight:600; font-size:0.9em; color:#3498db; margin-bottom:4px;">${escapeHtml(f[`location_name_${lang}`] || f.location_name_ku)}</div>
                            <div style="color:#f1c40f; font-size:0.8em; margin-bottom:4px;">${'★'.repeat(f.rating) + '☆'.repeat(5 - f.rating)}</div>
                            <div style="font-size:0.85em; color:#555;">${escapeHtml(f.comment)}</div>
                        </div>
                    `).join('')}
                </div>
            </div>
        ` : '';

        openModal({
            title: lang === 'ku' ? 'پڕۆفایلی بەکارهێنەر' : 'User Profile',
            body: `
                <div style="text-align:center; padding:10px 0 20px 0;">
                    <img src="${avatar}" style="width:100px; height:100px; border-radius:50%; object-fit:cover; border:3px solid #3498db; margin-bottom:15px; background:#eee;">
                    <h3 style="margin:0 0 5px 0;">${escapeHtml(user.full_name || user.username)}</h3>
                    <div style="color:#888; font-size:0.9em; margin-bottom:15px;">@${escapeHtml(user.username)}</div>
                    ${user.bio ? `<div style="background:#f9f9f9; padding:15px; border-radius:12px; font-style:italic; font-size:0.95em; line-height:1.5; color:#555;">"${escapeHtml(user.bio)}"</div>` : ''}
                </div>
                <div class="user-profile-content" style="max-height:400px; overflow-y:auto; padding-right:5px;">
                    ${suggestionsHtml}
                    ${feedbackHtml}
                </div>
            `,
            buttons: [{ label: t('close') }]
        });
    } catch (error) {
        showNotice(error.message);
    }
}

window.viewUserProfile = viewUserProfile;
window.viewLocationDetails = viewLocationDetails;
window.sendFeedback = sendFeedback;
window.focusLocation = focusLocation;
window.openDirections = openDirections;
window.toggleFavorite = toggleFavorite;
window.showDirections = showDirections;
window.toggleFavoritesView = toggleFavoritesView;
window.toggleSidebar = toggleSidebar;
window.loadPage = loadPage;
window.locateUser = locateUser;

// --- User Account Management ---
// currentUser already declared above

async function checkUserAuth() {
    try {
        const data = await api('user_profile', { method: 'GET' });
        if (data.user) {
            currentUser = data.user;
        } else {
            currentUser = null;
        }
    } catch (e) {
        currentUser = null;
    }
}

async function openUserModal() {
    await checkUserAuth();
    if (currentUser) {
        window.location.href = 'pages/profile.php';
    } else {
        window.location.href = 'pages/login.php';
    }
}

// Login modal removed - using dedicated login.php page instead
function renderLoginView() {
    // Redirect to login page instead of modal
    window.location.href = 'pages/login.php';
}

function renderRegisterView() {
    // Redirect to register page instead of modal
    window.location.href = 'pages/register.php';
}

// Email verification - redirect to dedicated page instead of modal
function renderVerifyView(email) {
    window.location.href = `verify.php?email=${encodeURIComponent(email)}`;
}

// Profile view - redirect to dedicated profile page instead of modal
function renderProfileView() {
    window.location.href = 'pages/profile.php';
}

function handleAvatarSelect(event) {
    const file = event.target.files[0];
    if (file) {
        const reader = new FileReader();
        reader.onload = function(e) {
            document.getElementById('editAvatarBase64').value = e.target.result;
            const avatarPreview = document.getElementById('avatar-preview');
            if (avatarPreview) {
                avatarPreview.innerHTML = `<img src="${e.target.result}" style="width:100%; height:100%; object-fit:cover; border-radius:50%;">`;
            }
        };
        reader.readAsDataURL(file);
    }
}
window.handleAvatarSelect = handleAvatarSelect;

async function handleLogin(e) {
    e.preventDefault();
    const email = document.getElementById('loginEmail').value;
    const password = document.getElementById('loginPassword').value;
    try {
        const res = await api('user_login', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ email, password })
        });
        if (res.success) {
            currentUser = res.user;
            loadServerFavorites();
            renderProfileView();
        } else {
            alert(res.error || 'هەڵە ڕوویدا');
            if (res.error === 'Email is not verified') {
                renderVerifyView(email);
            }
        }
    } catch (err) {
        alert('هەڵە لە پەیوەندی کردن بە سێرڤەر');
    }
}

async function handleRegister(e) {
    e.preventDefault();
    const name = document.getElementById('regName').value;
    const email = document.getElementById('regEmail').value;
    const password = document.getElementById('regPassword').value;
    try {
        const res = await api('user_register', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ name, email, password })
        });
        if (res.success) {
            alert(res.message);
            renderVerifyView(email);
        } else {
            alert(res.error || 'هەڵە ڕوویدا');
        }
    } catch (err) {
        alert('هەڵە لە پەیوەندی کردن بە سێرڤەر');
    }
}

async function handleVerify(e, email) {
    e.preventDefault();
    const code = document.getElementById('verifyCode').value;
    try {
        const res = await api('user_verify', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ email, code })
        });
        if (res.success) {
            alert('دڵنیابوونەوە سەرکەوتوو بوو، ئێستا دەتوانیت بچیتە ژوورەوە');
            window.location.href = 'pages/login.php';
            return;
        } else {
            alert(res.error || 'کۆدەکە هەڵەیە');
        }
    } catch (err) {
        alert('هەڵە لە پەیوەندی کردن بە سێرڤەر');
    }
}

async function handleEditProfile(e) {
    e.preventDefault();
    const name = document.getElementById('editName').value;
    const password = document.getElementById('editPassword').value;
    const avatar = document.getElementById('editAvatarBase64').value;
    try {
        const res = await api('user_profile', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ name, password, avatar })
        });
        if (res.success) {
            currentUser.full_name = res.name;
            if (res.avatar !== undefined) currentUser.avatar = res.avatar;
            alert('گۆڕانکاریەکان پاشەکەوت کران');
            renderProfileView();
            updateUIForLoggedInUser();
            if (state.userCoords) {
                locateUser(); // refresh location marker if already on map
            }
        } else {
            alert(res.error || 'هەڵە ڕوویدا');
        }
    } catch (err) {
        alert('هەڵە لە پەیوەندی کردن بە سێرڤەر');
    }
}

async function handleDeleteProfile() {
    if (!confirm('دڵنیایت کە دەتەوێت هەژمارەکەت بسڕیتەوە؟\n\nئەم کردارە هەژمارەکەت نەک سڕێتەوە بەڵکو بۆ 30 ڕۆژ دەچێتە ژێر پێداچوونەوە. ئەگەر لەم ماوەیەدا چووتە ژوورەوە، سڕینەوەکە هەڵدەوەشێنرێتەوە.')) return;
    try {
        const res = await api('user_profile', { method: 'DELETE' });
        if (res.success) {
            currentUser = null;
            closeModal();
            alert(res.message || 'هەژمارەکەت نیشانکرا بۆ سڕینەوە. 30 ڕۆژ کاتت هەیە بۆ چوونە ژوورەوە و هەڵوەشاندنەوەی.');
        }
    } catch (err) {
        alert('هەڵە ڕوویدا');
    }
}

async function handleLogout() {
    try {
        await api('user_logout', { method: 'POST' });
        currentUser = null;
        closeModal();
        updateUIForLoggedInUser(); // Update UI after logout
    } catch (err) {
        alert('هەڵە ڕوویدا');
    }
}

function openSuggestLocation() {
    const govOptions = state.governments.map(g => `<option value="${g.id}">${g['name_' + state.currentLanguage] || g.name_ku}</option>`).join('');
    const catOptions = state.categories.map(c => `<option value="${c.id}">${c['name_' + state.currentLanguage] || c.name_ku}</option>`).join('');

    openModal({
        title: state.currentLanguage === 'ku' ? 'پێشنیارکردنی شوێن' : (state.currentLanguage === 'ar' ? 'اقتراح موقع' : 'Suggest a Location'),
        body: `
            <form id="suggest-form" onsubmit="handleSuggestLocation(event)" style="display:flex; flex-direction:column; gap:12px;">
                <input type="text" id="suggest-name-ku" required placeholder="ناوی شوێن (کوردی)" style="padding:8px; border:1px solid #ddd; border-radius:5px;" />
                <input type="text" id="suggest-name-en" placeholder="Name (English)" style="padding:8px; border:1px solid #ddd; border-radius:5px;" />
                <input type="text" id="suggest-name-ar" placeholder="الاسم (عربي)" style="padding:8px; border:1px solid #ddd; border-radius:5px;" />
                <textarea id="suggest-desc-ku" placeholder="وەسف (کوردی)" rows="2" style="padding:8px; border:1px solid #ddd; border-radius:5px;"></textarea>
                <div style="display:flex; gap:8px;">
                    <input type="number" step="any" id="suggest-lat" required placeholder="Lat" style="flex:1; padding:8px; border:1px solid #ddd; border-radius:5px;" />
                    <input type="number" step="any" id="suggest-lng" required placeholder="Lng" style="flex:1; padding:8px; border:1px solid #ddd; border-radius:5px;" />
                </div>
                <select id="suggest-gov" style="padding:8px; border:1px solid #ddd; border-radius:5px;">
                    <option value="">-- ${languageData[state.currentLanguage].gov_filter} --</option>
                    ${govOptions}
                </select>
                <select id="suggest-cat" style="padding:8px; border:1px solid #ddd; border-radius:5px;">
                    <option value="">-- ${languageData[state.currentLanguage].category_filter} --</option>
                    ${catOptions}
                </select>
                <input type="text" id="suggest-address" placeholder="ناونیشان / Address" style="padding:8px; border:1px solid #ddd; border-radius:5px;" />
                <button type="submit" class="btn btn-primary" style="padding:10px; border:none; border-radius:5px; background:var(--primary-color); color:white; cursor:pointer;">
                    <i class="fas fa-paper-plane"></i> ${state.currentLanguage === 'ku' ? 'ناردن' : (state.currentLanguage === 'ar' ? 'إرسال' : 'Submit')}
                </button>
            </form>
        `,
        buttons: [{ label: t('cancel'), variant: 'secondary' }]
    });
}

async function handleSuggestLocation(e) {
    e.preventDefault();
    const payload = {
        name_ku: document.getElementById('suggest-name-ku').value.trim(),
        name_en: document.getElementById('suggest-name-en').value.trim(),
        name_ar: document.getElementById('suggest-name-ar').value.trim(),
        description_ku: document.getElementById('suggest-desc-ku').value.trim(),
        lat: parseFloat(document.getElementById('suggest-lat').value),
        lng: parseFloat(document.getElementById('suggest-lng').value),
        government_id: document.getElementById('suggest-gov').value || null,
        category_id: document.getElementById('suggest-cat').value || null,
        address: document.getElementById('suggest-address').value.trim()
    };

    if (!payload.name_ku || isNaN(payload.lat) || isNaN(payload.lng)) {
        showNotice(state.currentLanguage === 'ku' ? 'تکایە ناو و کوئردینەیتەکان پڕ بکەوە' : 'Please fill in name and coordinates');
        return;
    }

    try {
        const res = await api('suggest_location', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(payload)
        });
        if (res.success) {
            closeModal();
            showNotice(state.currentLanguage === 'ku' ? 'پێشنیارەکەت ناردرا بۆ پێداچوونەوە' : 'Suggestion submitted for review');
        } else {
            showNotice(res.error || 'Error submitting suggestion');
        }
    } catch (err) {
        showNotice(err.message);
    }
}

window.openUserModal = openUserModal;
window.renderLoginView = renderLoginView;
window.renderRegisterView = renderRegisterView;
window.handleLogin = handleLogin;
window.handleRegister = handleRegister;
window.handleVerify = handleVerify;
window.handleEditProfile = handleEditProfile;
window.handleDeleteProfile = handleDeleteProfile;
window.handleLogout = handleLogout;
window.openSuggestLocation = openSuggestLocation;
window.handleSuggestLocation = handleSuggestLocation;

async function openMyVisits() {
    const title = state.currentLanguage === 'ku' ? 'سەردانەکانم' : (state.currentLanguage === 'ar' ? 'زياراتي' : 'My Visits');
    openModal({ title, body: '<div id="visits-list" style="text-align:center;padding:20px;"><i class="fas fa-spinner fa-spin"></i></div>' });

    try {
        const data = await api('my_visits');
        const visits = data.visits || [];
        const container = document.getElementById('visits-list');

        if (visits.length === 0) {
            container.innerHTML = `<p style="color:var(--text-secondary);text-align:center;padding:20px;">${state.currentLanguage === 'ku' ? 'هیچ سەردانێکت نییە' : 'No visits yet'}</p>`;
            return;
        }

        container.innerHTML = visits.map(v => {
            const name = v[`name_${state.currentLanguage}`] || v.name_ku || '—';
            const govName = v.gov_name_ku || '';
            const catIcon = v.category_icon || 'map-marker-alt';
            const date = v.visited_at ? new Date(v.visited_at).toLocaleDateString() : '';
            return `
                <div style="display:flex;align-items:center;gap:12px;padding:10px;border-bottom:1px solid var(--border-color);cursor:pointer;" onclick="focusLocation(${v.location_id})">
                    <div style="width:36px;height:36px;border-radius:50%;background:${v.gov_color || '#3498db'};display:flex;align-items:center;justify-content:center;color:#fff;flex-shrink:0;">
                        <i class="fas fa-${catIcon}"></i>
                    </div>
                    <div style="flex:1;min-width:0;">
                        <div style="font-weight:600;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;">${escapeHtml(name)}</div>
                        <div style="font-size:.8rem;color:var(--text-secondary);">${escapeHtml(govName)} · ${date}</div>
                    </div>
                </div>
            `;
        }).join('');
    } catch (err) {
        const container = document.getElementById('visits-list');
        if (container) container.innerHTML = `<p style="color:#e74c3c;">${err.message}</p>`;
    }
}
window.openMyVisits = openMyVisits;

async function openMyFavorites() {
    const title = state.currentLanguage === 'ku' ? 'فەیڤۆریتەکان' : (state.currentLanguage === 'ar' ? 'المفضلة' : 'My Favorites');
    openModal({ title, body: '<div id="favorites-list" style="text-align:center;padding:20px;"><i class="fas fa-spinner fa-spin"></i></div>' });

    try {
        const data = await api('favorites');
        const favorites = data.favorites || [];
        const container = document.getElementById('favorites-list');

        if (favorites.length === 0) {
            container.innerHTML = `<p style="color:var(--text-secondary);text-align:center;padding:20px;">${state.currentLanguage === 'ku' ? 'هیچ فەیڤۆریتێکت نییە' : 'No favorites yet'}</p>`;
            return;
        }

        // Get location details for all favorites
        const locationIds = favorites.join(',');
        const locationsData = await api(`locations?ids=${locationIds}`);
        const locations = locationsData.locations || [];

        container.innerHTML = locations.map(loc => {
            const name = loc[`name_${state.currentLanguage}`] || loc.name_ku || '—';
            const govName = loc.gov_name_ku || '';
            const catIcon = loc.category_icon || 'map-marker-alt';
            return `
                <div style="display:flex;align-items:center;gap:12px;padding:10px;border-bottom:1px solid var(--border-color);">
                    <div style="width:36px;height:36px;border-radius:50%;background:${loc.gov_color || '#3498db'};display:flex;align-items:center;justify-content:center;color:#fff;flex-shrink:0;cursor:pointer;" onclick="focusLocation(${loc.id})">
                        <i class="fas fa-${catIcon}"></i>
                    </div>
                    <div style="flex:1;min-width:0;cursor:pointer;" onclick="focusLocation(${loc.id})">
                        <div style="font-weight:600;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;">${escapeHtml(name)}</div>
                        <div style="font-size:.8rem;color:var(--text-secondary);">${escapeHtml(govName)}</div>
                    </div>
                    <button onclick="event.stopPropagation(); removeFavoriteFromList(${loc.id})" style="padding:6px 10px;background:#e74c3c;color:white;border:none;border-radius:4px;cursor:pointer;" title="Remove from favorites">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
            `;
        }).join('');
    } catch (err) {
        const container = document.getElementById('favorites-list');
        if (container) container.innerHTML = `<p style="color:#e74c3c;">${err.message}</p>`;
    }
}

async function removeFavoriteFromList(locationId) {
    try {
        await toggleFavorite(locationId);
        // Refresh the favorites list
        openMyFavorites();
    } catch (err) {
        showNotice(err.message);
    }
}

window.openMyFavorites = openMyFavorites;
window.removeFavoriteFromList = removeFavoriteFromList;

// Enhanced Features Implementation

// User Authentication Handler
async function handleUserAccount() {
    // Check auth first, then redirect
    await checkUserAuth();
    if (!currentUser) {
        window.location.href = 'pages/login.php';
    } else {
        window.location.href = 'pages/profile.php';
    }
}

// Enhanced Voice Search Implementation
function initVoiceSearch() {
    if ('webkitSpeechRecognition' in window || 'SpeechRecognition' in window) {
        const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
        voiceRecognition = new SpeechRecognition();
        voiceRecognition.continuous = false;
        voiceRecognition.interimResults = true;
        voiceRecognition.lang = state.currentLanguage === 'ku' ? 'ku-IQ' :
                                state.currentLanguage === 'ar' ? 'ar-SA' : 'en-US';

        voiceRecognition.onstart = function() {
            console.log('Voice recognition started');
            const voiceBtn = document.getElementById('voice-search-btn');
            if (voiceBtn) {
                voiceBtn.classList.add('listening');
                voiceBtn.innerHTML = '<i class="fas fa-microphone"></i>';
                voiceBtn.title = 'گۆکردن... کلیک بکە بۆ وەستان';
            }
            showVoiceCommandHint();
        };

        voiceRecognition.onresult = function(event) {
            let interimTranscript = '';
            let finalTranscript = '';
            
            for (let i = event.resultIndex; i < event.results.length; ++i) {
                if (event.results[i].isFinal) {
                    finalTranscript += event.results[i][0].transcript;
                } else {
                    interimTranscript += event.results[i][0].transcript;
                }
            }
            
            const searchInput = document.getElementById('search-input');
            if (searchInput) {
                if (finalTranscript) {
                    searchInput.value = finalTranscript;
                    processVoiceCommand(finalTranscript);
                    addToSearchHistory(finalTranscript);
                } else if (interimTranscript) {
                    searchInput.value = interimTranscript;
                    // Show interim results in a subtle way
                    searchInput.style.color = '#94a3b8';
                }
            }
        };

        voiceRecognition.onerror = function(event) {
            console.error('Voice recognition error:', event.error);
            const voiceBtn = document.getElementById('voice-search-btn');
            if (voiceBtn) {
                voiceBtn.classList.remove('listening');
                voiceBtn.innerHTML = '<i class="fas fa-microphone"></i>';
                voiceBtn.title = 'گەڕانی دەنگی';
            }
            hideVoiceCommandHint();
            
            // Show user-friendly error message
            if (event.error === 'not-allowed') {
                showNotification('میکرۆفۆنەکەت ڕێگەپێدراو نییە. تکایە ڕێگەبدە بە میکرۆفۆن', 'error');
            } else if (event.error === 'no-speech') {
                showNotification('هیچ دەنگێک نەبیسترا. تکایە دووبارە هەوڵبدەرەوە', 'warning');
            } else {
                showNotification('هەڵەیەک ڕوویدا لە گەڕانی دەنگی: ' + event.error, 'error');
            }
        };

        voiceRecognition.onend = function() {
            console.log('Voice recognition ended');
            const voiceBtn = document.getElementById('voice-search-btn');
            if (voiceBtn) {
                voiceBtn.classList.remove('listening');
                voiceBtn.innerHTML = '<i class="fas fa-microphone"></i>';
                voiceBtn.title = 'گەڕانی دەنگی';
            }
            hideVoiceCommandHint();
            
            // Reset input color
            const searchInput = document.getElementById('search-input');
            if (searchInput) {
                searchInput.style.color = '';
            }
        };
        
        return true;
    } else {
        console.warn('Speech recognition not supported in this browser');
        return false;
    }
}

function startVoiceSearch() {
    if (!voiceRecognition) {
        const supported = initVoiceSearch();
        if (!supported) {
            showNotification('گەڕانی دەنگی پشتگیری ناکرێت لەم وێبگەڕەدا. تکایە وێبگەڕێکی مۆدێرن بەکاربهێنە', 'error');
            return;
        }
    }
    
    try {
        const voiceBtn = document.getElementById('voice-search-btn');
        if (voiceBtn) {
            voiceBtn.classList.add('listening');
        }
        voiceRecognition.start();
    } catch (error) {
        console.error('Failed to start voice recognition:', error);
        showNotification('نەتوانرا گەڕانی دەنگی دەستپێبکات: ' + error.message, 'error');
    }
}

function processVoiceCommand(transcript) {
    console.log('Processing voice command:', transcript);
    
    // Convert to lowercase for easier matching
    const command = transcript.toLowerCase().trim();
    
    // Check for specific voice commands
    if (command.includes('پاککردنەوە') || command.includes('clear') || command.includes('مسح')) {
        clearSearch();
        showNotification('گەڕان پاککرایەوە', 'success');
        return;
    }
    
    if (command.includes('فیلتەر') || command.includes('filter') || command.includes('تصفية')) {
        // Extract filter type from command
        if (command.includes('هەرێم') || command.includes('government') || command.includes('محافظة')) {
            showNotification('فیلتەری هەرێم چالاککرا', 'info');
            // Could implement voice-based filtering here
        } else if (command.includes('جۆر') || command.includes('category') || command.includes('فئة')) {
            showNotification('فیلتەری جۆر چالاککرا', 'info');
        }
        return;
    }
    
    if (command.includes('شوێنی من') || command.includes('my location') || command.includes('موقعي')) {
        locateUser();
        showNotification('شوێنی تۆ نیشاندرا', 'success');
        return;
    }
    
    if (command.includes('نەخشە') || command.includes('map') || command.includes('خريطة')) {
        if (command.includes('هەسارەیی') || command.includes('satellite') || command.includes('قمر صناعي')) {
            toggleLayer('satellite');
            showNotification('نەخشەی هەسارەیی چالاککرا', 'success');
            return;
        } else if (command.includes('شەقام') || command.includes('street') || command.includes('شارع')) {
            toggleLayer('streets');
            showNotification('نەخشەی شەقام چالاککرا', 'success');
            return;
        }
    }
    
    // If no specific command matched, perform regular search
    performSearch(transcript);
}

function performSearch(searchTerm) {
    if (!searchTerm || searchTerm.trim() === '') {
        return;
    }
    
    console.log('Performing search for:', searchTerm);
    searchLocationsFromDatabase(searchTerm);
    
    // Add to search history
    addToSearchHistory(searchTerm);
    
    // Show search results count notification
    setTimeout(() => {
        const resultCount = state.allLocations.length;
        if (resultCount > 0) {
            showNotification(`${resultCount} شوێن دۆزرایەوە بۆ "${searchTerm}"`, 'success');
        } else {
            showNotification(`هیچ شوێنێک نەدۆزرایەوە بۆ "${searchTerm}"`, 'warning');
        }
    }, 500);
}

function clearSearch() {
    const searchInput = document.getElementById('search-input');
    if (searchInput) {
        searchInput.value = '';
        searchInput.focus();
    }
    
    const clearBtn = document.getElementById('clear-search-btn');
    if (clearBtn) {
        clearBtn.style.display = 'none';
    }
    
    // Reload all locations
    loadLocations();
}

// Search History and Helper Functions
function addToSearchHistory(searchTerm) {
    if (!searchTerm || searchTerm.trim() === '') {
        return;
    }
    
    const history = getSearchHistory();
    const trimmedTerm = searchTerm.trim();
    
    // Remove if already exists (to avoid duplicates)
    const existingIndex = history.findIndex(item => item.term === trimmedTerm);
    if (existingIndex !== -1) {
        history.splice(existingIndex, 1);
    }
    
    // Add to beginning of array
    history.unshift({
        term: trimmedTerm,
        timestamp: Date.now(),
        type: 'manual'
    });
    
    // Keep only last 20 searches
    if (history.length > 20) {
        history.pop();
    }
    
    // Save to localStorage
    localStorage.setItem('search_history', JSON.stringify(history));
    
    // Update suggestions if they're visible
    updateSearchSuggestions();
}

function getSearchHistory() {
    try {
        const history = localStorage.getItem('search_history');
        return history ? JSON.parse(history) : [];
    } catch (error) {
        console.error('Error reading search history:', error);
        return [];
    }
}

function clearSearchHistory() {
    localStorage.removeItem('search_history');
    updateSearchSuggestions();
    showNotification('مێژووی گەڕان پاککرایەوە', 'success');
}

function updateSearchSuggestions() {
    const suggestionsContainer = document.getElementById('suggestions-list');
    const searchSuggestions = document.getElementById('search-suggestions');
    
    if (!suggestionsContainer || !searchSuggestions) {
        return;
    }
    
    const searchInput = document.getElementById('search-input');
    const currentValue = searchInput ? searchInput.value.trim() : '';
    
    // Hide suggestions if input is empty and not focused
    if (currentValue === '' && document.activeElement !== searchInput) {
        searchSuggestions.style.display = 'none';
        return;
    }
    
    const history = getSearchHistory();
    const popularSearches = [
        { term: 'هەولێر', type: 'popular' },
        { term: 'دهۆک', type: 'popular' },
        { term: 'سلێمانی', type: 'popular' },
        { term: 'کەرکووک', type: 'popular' },
        { term: 'شارباژێر', type: 'popular' }
    ];
    
    let suggestionsHTML = '';
    
    // Add recent searches
    if (history.length > 0) {
        suggestionsHTML += '<div class="suggestion-section">';
        history.slice(0, 5).forEach(item => {
            suggestionsHTML += `
                <div class="suggestion-item recent" data-term="${item.term}">
                    <i class="fas fa-history"></i>
                    <span>${item.term}</span>
                </div>
            `;
        });
        suggestionsHTML += '</div>';
    }
    
    // Add popular searches if no recent history or current value is empty
    if (history.length === 0 || currentValue === '') {
        suggestionsHTML += '<div class="suggestion-section">';
        popularSearches.forEach(item => {
            suggestionsHTML += `
                <div class="suggestion-item popular" data-term="${item.term}">
                    <i class="fas fa-fire"></i>
                    <span>${item.term}</span>
                </div>
            `;
        });
        suggestionsHTML += '</div>';
    }
    
    // Add voice search suggestion
    suggestionsHTML += `
        <div class="suggestion-item voice" onclick="startVoiceSearch()">
            <i class="fas fa-microphone"></i>
            <span>گەڕانی دەنگی</span>
        </div>
    `;
    
    suggestionsContainer.innerHTML = suggestionsHTML;
    
    // Add click handlers to suggestion items
    suggestionsContainer.querySelectorAll('.suggestion-item[data-term]').forEach(item => {
        item.addEventListener('click', () => {
            const term = item.getAttribute('data-term');
            const searchInput = document.getElementById('search-input');
            if (searchInput) {
                searchInput.value = term;
                searchInput.focus();
                performSearch(term);
            }
            document.getElementById('search-suggestions').style.display = 'none';
        });
    });
    
    // Show suggestions if we have content
    if (suggestionsHTML.trim() !== '') {
        searchSuggestions.style.display = 'block';
    } else {
        searchSuggestions.style.display = 'none';
    }
}

function showNotification(message, type = 'info') {
    // Remove existing notification if any
    const existingNotification = document.querySelector('.search-notification');
    if (existingNotification) {
        existingNotification.remove();
    }
    
    const notification = document.createElement('div');
    notification.className = `search-notification notification-${type}`;
    notification.innerHTML = `
        <div style="display: flex; align-items: center; gap: 10px;">
            <i class="fas ${type === 'success' ? 'fa-check-circle' : type === 'error' ? 'fa-exclamation-circle' : type === 'warning' ? 'fa-exclamation-triangle' : 'fa-info-circle'}"></i>
            <span>${message}</span>
        </div>
        <button class="notification-close" onclick="this.parentElement.remove()">
            <i class="fas fa-times"></i>
        </button>
    `;
    
    // Add styles
    notification.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        background: ${type === 'success' ? '#10b981' : type === 'error' ? '#ef4444' : type === 'warning' ? '#f59e0b' : '#3b82f6'};
        color: white;
        padding: 12px 16px;
        border-radius: 8px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        z-index: 9999;
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 15px;
        max-width: 400px;
        animation: slideIn 0.3s ease;
    `;
    
    // Add close button styles
    notification.querySelector('.notification-close').style.cssText = `
        background: none;
        border: none;
        color: white;
        cursor: pointer;
        opacity: 0.8;
        transition: opacity 0.2s;
        padding: 4px;
        border-radius: 4px;
    `;
    
    notification.querySelector('.notification-close').addEventListener('mouseover', function() {
        this.style.opacity = '1';
    });
    
    notification.querySelector('.notification-close').addEventListener('mouseout', function() {
        this.style.opacity = '0.8';
    });
    
    document.body.appendChild(notification);
    
    // Auto-remove after 5 seconds
    setTimeout(() => {
        if (notification.parentNode) {
            notification.style.animation = 'slideOut 0.3s ease';
            setTimeout(() => {
                if (notification.parentNode) {
                    notification.remove();
                }
            }, 300);
        }
    }, 5000);
}

function showVoiceCommandHint() {
    let hint = document.getElementById('voice-command-hint');
    if (!hint) {
        hint = document.createElement('div');
        hint.id = 'voice-command-hint';
        hint.className = 'voice-command-hint';
        hint.innerHTML = `
            <h4>فەرمانە دەنگیەکان</h4>
            <ul class="voice-command-list">
                <li><i class="fas fa-microphone"></i> "پاککردنەوە" - پاککردنەوەی گەڕان</li>
                <li><i class="fas fa-microphone"></i> "شوێنی من" - نیشاندانی شوێنی تۆ</li>
                <li><i class="fas fa-microphone"></i> "هەسارەیی" - گۆڕینی نەخشە بۆ هەسارەیی</li>
                <li><i class="fas fa-microphone"></i> "شەقام" - گۆڕینی نەخشە بۆ شەقام</li>
                <li><i class="fas fa-microphone"></i> "فیلتەر هەرێم" - فیلتەری هەرێم</li>
            </ul>
        `;
        document.body.appendChild(hint);
    }
    hint.style.display = 'block';
}

function hideVoiceCommandHint() {
    const hint = document.getElementById('voice-command-hint');
    if (hint) {
        hint.style.display = 'none';
    }
}

// Initialize enhanced search
function initEnhancedSearch() {
    const searchInput = document.getElementById('search-input');
    const clearSearchBtn = document.getElementById('clear-search-btn');
    const voiceSearchBtn = document.getElementById('voice-search-btn');
    const clearHistoryBtn = document.getElementById('clear-history');
    
    if (!searchInput) return;
    
    // Initialize voice search
    initVoiceSearch();
    
    // Search input events
    searchInput.addEventListener('focus', () => {
        updateSearchSuggestions();
    });
    
    searchInput.addEventListener('input', () => {
        const value = searchInput.value.trim();
        
        // Show/hide clear button
        if (clearSearchBtn) {
            clearSearchBtn.style.display = value ? 'flex' : 'none';
        }
        
        // Update suggestions
        updateSearchSuggestions();
        
        // Debounced search
        clearTimeout(window.searchDebounce);
        window.searchDebounce = setTimeout(() => {
            if (value) {
                performSearch(value);
            } else {
                loadLocations();
            }
        }, 300);
    });
    
    searchInput.addEventListener('keydown', (e) => {
        if (e.key === 'Enter') {
            performSearch(searchInput.value);
            document.getElementById('search-suggestions').style.display = 'none';
        } else if (e.key === 'Escape') {
            document.getElementById('search-suggestions').style.display = 'none';
        }
    });
    
    // Clear search button
    if (clearSearchBtn) {
        clearSearchBtn.addEventListener('click', () => {
            clearSearch();
            updateSearchSuggestions();
        });
    }
    
    // Voice search button
    if (voiceSearchBtn) {
        voiceSearchBtn.addEventListener('click', startVoiceSearch);
    }
    
    // Clear history button
    if (clearHistoryBtn) {
        clearHistoryBtn.addEventListener('click', clearSearchHistory);
    }
    
    // Close suggestions when clicking outside
    document.addEventListener('click', (e) => {
        const searchSuggestions = document.getElementById('search-suggestions');
        const searchSection = document.querySelector('.search-section');
        
        if (searchSuggestions && searchSection && !searchSection.contains(e.target)) {
            searchSuggestions.style.display = 'none';
        }
    });
    
    // Load initial search history
    updateSearchSuggestions();
}

// Weather Integration
async function fetchWeatherForLocation(lat, lng) {
    try {
        // Check cache first
        const cacheKey = `weather_${lat}_${lng}`;
        const cached = localStorage.getItem(cacheKey);
        
        if (cached) {
            const data = JSON.parse(cached);
            if (Date.now() - data.timestamp < 3600000) { // 1 hour cache
                updateWeatherDisplay(data.weather);
                return;
            }
        }
        
        // Check if API key is configured
        const apiKey = 'YOUR_OPENWEATHER_API_KEY';
        if (apiKey === 'YOUR_OPENWEATHER_API_KEY') {
            console.log('Weather API key not configured, using fallback data');
            // Use fallback weather data for demo purposes
            const fallbackWeather = {
                temperature: 22,
                condition: 'Partly cloudy',
                icon: '02d',
                humidity: 45,
                windSpeed: 3.5
            };
            updateWeatherDisplay(fallbackWeather);
            return;
        }
        
        // Fetch from API (using OpenWeatherMap)
        const response = await fetch(`https://api.openweathermap.org/data/2.5/weather?lat=${lat}&lon=${lng}&appid=${apiKey}&units=metric`);
        
        if (!response.ok) {
            throw new Error(`HTTP ${response.status}: ${response.statusText}`);
        }
        
        const data = await response.json();
        
        // Check for API errors
        if (data.cod && data.cod !== 200) {
            throw new Error(data.message || 'API error');
        }
        
        const weather = {
            temperature: Math.round(data.main.temp),
            condition: data.weather[0].description,
            icon: data.weather[0].icon,
            humidity: data.main.humidity,
            windSpeed: data.wind.speed
        };
        
        // Cache the data
        localStorage.setItem(cacheKey, JSON.stringify({
            weather: weather,
            timestamp: Date.now()
        }));
        
        updateWeatherDisplay(weather);
    } catch (error) {
        console.error('Weather fetch error:', error);
        // Show weather unavailable message instead of null
        updateWeatherDisplay({
            temperature: null,
            condition: 'Weather unavailable',
            icon: '01d',
            humidity: null,
            windSpeed: null,
            error: true
        });
    }
}

function updateWeatherDisplay(weather) {
    const weatherInfo = document.getElementById('weather-info');
    
    if (!weather) {
        weatherInfo.innerHTML = '<div class="weather-error"><i class="fas fa-exclamation-triangle"></i><span>Weather unavailable</span></div>';
        return;
    }

    weatherInfo.innerHTML = `
        <div class="weather-current">
            <div class="weather-temp">${weather.temperature}°C</div>
            <div class="weather-condition">${weather.condition}</div>
            <div class="weather-details">
                <div><i class="fas fa-tint"></i> ${weather.humidity}%</div>
                <div><i class="fas fa-wind"></i> ${weather.windSpeed} m/s</div>
            </div>
        </div>
    `;
}

// AR Camera Implementation
function openARCamera() {
    if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
        alert('AR Camera is not supported in your browser');
        return;
    }

    const modalBody = document.getElementById('app-modal-body');
    
    modalBody.innerHTML = `
        <div class="ar-camera-container">
            <video id="ar-video" autoplay playsinline style="width: 100%; height: 400px; object-fit: cover;"></video>
            <canvas id="ar-canvas" style="position: absolute; top: 0; left: 0; width: 100%; height: 400px; pointer-events: none;"></canvas>
            <div class="ar-controls">
                <button onclick="closeARCamera()" class="btn btn-secondary">Close</button>
                <button onclick="captureARPhoto()" class="btn btn-primary">Capture</button>
            </div>
            <div class="ar-overlay">
                <div class="ar-crosshair">+</div>
            </div>
        </div>
    `;

    if (state.modal) {
        state.modal.title.textContent = state.currentLanguage === 'ku' ? 'کامێرای AR' : (state.currentLanguage === 'ar' ? 'كاميرا AR' : 'AR Camera');
        state.modal.footer.innerHTML = '';
        state.modal.root.hidden = false;
        document.body.style.overflow = 'hidden';
    }
    
    navigator.mediaDevices.getUserMedia({ 
        video: { facingMode: 'environment' } 
    }).then(stream => {
        arCameraStream = stream;
        const video = document.getElementById('ar-video');
        video.srcObject = stream;
        
        // Start AR overlay
        startAROverlay();
    }).catch(error => {
        console.error('Camera access error:', error);
        alert('Unable to access camera');
        closeARCamera();
    });
}

function closeARCamera() {
    if (arCameraStream) {
        arCameraStream.getTracks().forEach(track => track.stop());
        arCameraStream = null;
    }
    closeModal();
}

function startAROverlay() {
    const video = document.getElementById('ar-video');
    const canvas = document.getElementById('ar-canvas');
    const ctx = canvas.getContext('2d');
    
    // Set canvas size
    canvas.width = video.videoWidth;
    canvas.height = video.videoHeight;
    
    function drawOverlay() {
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        
        // Draw nearby locations on camera view
        if (state.userCoords && state.locations.length > 0) {
            const nearbyLocations = state.locations.filter(loc => {
                const distance = calculateDistance(state.userCoords.lat, state.userCoords.lng, loc.lat, loc.lng);
                return distance < 5; // Within 5km
            });
            
            nearbyLocations.forEach(location => {
                // Calculate position on screen (simplified)
                const bearing = calculateBearing(state.userCoords.lat, state.userCoords.lng, location.lat, location.lng);
                const screenX = canvas.width / 2 + Math.cos(bearing) * 100;
                const screenY = canvas.height / 2 + Math.sin(bearing) * 100;
                
                // Draw location marker
                ctx.fillStyle = 'rgba(255, 0, 0, 0.7)';
                ctx.beginPath();
                ctx.arc(screenX, screenY, 10, 0, 2 * Math.PI);
                ctx.fill();
                
                // Draw location name
                ctx.fillStyle = 'white';
                ctx.font = '14px Arial';
                ctx.fillText(location.name_ku, screenX + 15, screenY + 5);
            });
        }
        
        requestAnimationFrame(drawOverlay);
    }
    
    drawOverlay();
}

function captureARPhoto() {
    const video = document.getElementById('ar-video');
    const canvas = document.createElement('canvas');
    canvas.width = video.videoWidth;
    canvas.height = video.videoHeight;
    const ctx = canvas.getContext('2d');
    ctx.drawImage(video, 0, 0);
    
    // Convert to blob and upload
    canvas.toBlob(blob => {
        // Here you would upload the photo to your server
        console.log('AR Photo captured', blob);
        alert('AR Photo captured! (Upload functionality to be implemented)');
    });
}

// Itinerary Planner
function openItineraryPlanner() {
    const modalBody = document.getElementById('app-modal-body');
    
    modalBody.innerHTML = `
        <div class="itinerary-planner">
            <h3>پلانی گەشت</h3>
            <div class="itinerary-form">
                <div class="form-group">
                    <label>ناوی گەشت</label>
                    <input type="text" id="itinerary-title" placeholder="ناوی گەشتەکەت بنووسە">
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>لە بەروار</label>
                        <input type="date" id="itinerary-start">
                    </div>
                    <div class="form-group">
                        <label>تا بەروار</label>
                        <input type="date" id="itinerary-end">
                    </div>
                </div>
                <div class="form-group">
                    <label>ژمارەی گەشتیاران</label>
                    <input type="number" id="itinerary-travelers" min="1" value="1">
                </div>
                <div class="itinerary-days" id="itinerary-days">
                    <!-- Days will be added dynamically -->
                </div>
                <div class="itinerary-actions">
                    <button onclick="addItineraryDay()" class="btn btn-secondary">زیادکردنی ڕۆژ</button>
                    <button onclick="saveItinerary()" class="btn btn-primary">پاشەکەوتکردن</button>
                </div>
            </div>
        </div>
    `;
    
    if (state.modal) {
        state.modal.title.textContent = state.currentLanguage === 'ku' ? 'پلانی گەشت' : (state.currentLanguage === 'ar' ? 'مخطط الرحلة' : 'Trip Planner');
        state.modal.footer.innerHTML = '';
        state.modal.root.hidden = false;
        document.body.style.overflow = 'hidden';
    }

    // Set default dates
    const today = new Date();
    const tomorrow = new Date(today);
    tomorrow.setDate(tomorrow.getDate() + 1);
    
    document.getElementById('itinerary-start').value = today.toISOString().split('T')[0];
    document.getElementById('itinerary-end').value = tomorrow.toISOString().split('T')[0];
    
    // Add first day
    addItineraryDay();
}

function addItineraryDay() {
    const daysContainer = document.getElementById('itinerary-days');
    const dayNumber = daysContainer.children.length + 1;
    
    const dayElement = document.createElement('div');
    dayElement.className = 'itinerary-day';
    dayElement.innerHTML = `
        <h4>ڕۆژ ${dayNumber}</h4>
        <div class="day-items" id="day-${dayNumber}-items">
            <div class="itinerary-item">
                <select class="item-type">
                    <option value="location">شوێن</option>
                    <option value="business">بازرگانی</option>
                    <option value="transport">گواستنەوە</option>
                    <option value="rest">پشوو</option>
                </select>
                <input type="text" class="item-title" placeholder="ناوی بابەت">
                <input type="time" class="item-time">
                <button onclick="removeItineraryItem(this)" class="btn btn-sm btn-danger">سڕینەوە</button>
            </div>
        </div>
        <button onclick="addItineraryItem(${dayNumber})" class="btn btn-sm btn-secondary">زیادکردنی بابەت</button>
    `;
    
    daysContainer.appendChild(dayElement);
}

function addItineraryItem(dayNumber) {
    const dayItems = document.getElementById(`day-${dayNumber}-items`);
    const itemElement = document.createElement('div');
    itemElement.className = 'itinerary-item';
    itemElement.innerHTML = `
        <select class="item-type">
            <option value="location">شوێن</option>
            <option value="business">بازرگانی</option>
            <option value="transport">گواستنەوە</option>
            <option value="rest">پشوو</option>
        </select>
        <input type="text" class="item-title" placeholder="ناوی بابەت">
        <input type="time" class="item-time">
        <button onclick="removeItineraryItem(this)" class="btn btn-sm btn-danger">سڕینەوە</button>
    `;
    
    dayItems.appendChild(itemElement);
}

function removeItineraryItem(button) {
    button.parentElement.remove();
}

async function saveItinerary() {
    const title = document.getElementById('itinerary-title').value;
    const startDate = document.getElementById('itinerary-start').value;
    const endDate = document.getElementById('itinerary-end').value;
    const travelers = parseInt(document.getElementById('itinerary-travelers').value) || 1;
    
    if (!title || !startDate || !endDate) {
        alert(state.currentLanguage === 'ku' ? 'تکایە زانیاری پێویست پڕ بکە' : (state.currentLanguage === 'ar' ? 'يرجى ملء جميع الحقول المطلوبة' : 'Please fill in all required fields'));
        return;
    }
    
    // Collect all days and items
    const days = {};
    const dayElements = document.querySelectorAll('.itinerary-day');
    
    dayElements.forEach((dayElement, index) => {
        const dayNumber = index + 1;
        const items = [];
        const itemElements = dayElement.querySelectorAll('.itinerary-item');
        
        itemElements.forEach((itemElement, itemIndex) => {
            const timeValue = itemElement.querySelector('.item-time').value;
            items.push({
                type: itemElement.querySelector('.item-type').value,
                title: itemElement.querySelector('.item-title').value,
                start_time: timeValue,
                end_time: timeValue,
                order_number: itemIndex
            });
        });
        
        days[dayNumber] = items;
    });
    
    const itinerary = {
        title,
        start_date: startDate,
        end_date: endDate,
        travelers,
        days
    };
    
    try {
        const response = await fetch(`${API_BASE}?endpoint=itineraries`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(itinerary)
        });
        
        const data = await response.json();
        
        if (data.success) {
            alert(state.currentLanguage === 'ku' ? 'پلانی گەشت بە سەرکەوتوویی پاشەکەوت کرا!' : (state.currentLanguage === 'ar' ? 'تم حفظ خطة الرحلة بنجاح!' : 'Trip plan saved successfully!'));
            closeModal();
            // Refresh trips count in profile
            if (typeof refreshUserStats === 'function') {
                refreshUserStats();
            }
        } else {
            alert(data.error || (state.currentLanguage === 'ku' ? 'هەڵە ڕوویدا' : 'Error occurred'));
        }
    } catch (error) {
        console.error('Error saving itinerary:', error);
        alert(state.currentLanguage === 'ku' ? 'هەڵە لە پاشەکەوتکردنی پلان' : (state.currentLanguage === 'ar' ? 'خطأ في حفظ الخطة' : 'Error saving trip plan'));
    }
}

// View My Trips
async function openMyTrips() {
    // Check if user is logged in
    await checkUserAuth();
    if (!currentUser) {
        window.location.href = 'pages/login.php';
        return;
    }
    
    const modalBody = document.getElementById('app-modal-body');
    
    modalBody.innerHTML = `
        <div class="my-trips">
            <h3>${state.currentLanguage === 'ku' ? 'گەشتەکانم' : (state.currentLanguage === 'ar' ? 'رحلاتي' : 'My Trips')}</h3>
            <div id="trips-list" class="trips-list">
                <p class="loading-text">${state.currentLanguage === 'ku' ? 'بارکردن...' : (state.currentLanguage === 'ar' ? 'جاري التحميل...' : 'Loading...')}</p>
            </div>
            <div class="trips-actions">
                <button onclick="openItineraryPlanner()" class="btn btn-primary">
                    ${state.currentLanguage === 'ku' ? 'پلانی گەشتی نوێ' : (state.currentLanguage === 'ar' ? 'خطة رحلة جديدة' : 'New Trip Plan')}
                </button>
            </div>
        </div>
    `;
    
    if (state.modal) {
        state.modal.title.textContent = state.currentLanguage === 'ku' ? 'گەشتەکانم' : (state.currentLanguage === 'ar' ? 'رحلاتي' : 'My Trips');
        state.modal.footer.innerHTML = '';
        state.modal.root.hidden = false;
        document.body.style.overflow = 'hidden';
    }
    
    // Load trips from server
    try {
        const response = await fetch('api.php?endpoint=itineraries');
        const data = await response.json();
        
        const tripsList = document.getElementById('trips-list');
        
        if (!data.success) {
            tripsList.innerHTML = `<p class="error-text">${data.error || 'Error loading trips'}</p>`;
            return;
        }
        
        if (!data.itineraries || data.itineraries.length === 0) {
            tripsList.innerHTML = `
                <div class="empty-trips">
                    <p>${state.currentLanguage === 'ku' ? 'هێشتا هیچ گەشتێکت پلان نەکردووە' : (state.currentLanguage === 'ar' ? 'لم تقم بتخطيط أي رحلات بعد' : 'You haven\'t planned any trips yet')}</p>
                </div>
            `;
            return;
        }
        
        tripsList.innerHTML = data.itineraries.map(trip => {
            const startDate = new Date(trip.start_date).toLocaleDateString();
            const endDate = new Date(trip.end_date).toLocaleDateString();
            const daysCount = trip.total_days || 1;
            const itemsCount = trip.items_count || 0;
            
            return `
                <div class="trip-card" data-trip-id="${trip.id}">
                    <div class="trip-header">
                        <h4>${trip.title}</h4>
                        <span class="trip-status status-${trip.status}">${trip.status}</span>
                    </div>
                    <div class="trip-details">
                        <p><strong>${state.currentLanguage === 'ku' ? 'بەروار' : 'Date'}:</strong> ${startDate} - ${endDate}</p>
                        <p><strong>${state.currentLanguage === 'ku' ? 'ژمارەی ڕۆژ' : 'Days'}:</strong> ${daysCount}</p>
                        <p><strong>${state.currentLanguage === 'ku' ? 'ژمارەی بابەت' : 'Items'}:</strong> ${itemsCount}</p>
                        <p><strong>${state.currentLanguage === 'ku' ? 'گەشتیاران' : 'Travelers'}:</strong> ${trip.travelers_count || 1}</p>
                    </div>
                    <div class="trip-actions">
                        <button onclick="viewTripDetails(${trip.id})" class="btn btn-sm btn-secondary">${state.currentLanguage === 'ku' ? 'بینین' : 'View'}</button>
                        <button onclick="deleteTrip(${trip.id})" class="btn btn-sm btn-danger">${state.currentLanguage === 'ku' ? 'سڕینەوە' : 'Delete'}</button>
                    </div>
                </div>
            `;
        }).join('');
        
    } catch (error) {
        console.error('Error loading trips:', error);
        document.getElementById('trips-list').innerHTML = `
            <p class="error-text">${state.currentLanguage === 'ku' ? 'هەڵە لە بارکردنی گەشتەکان' : (state.currentLanguage === 'ar' ? 'خطأ في تحميل الرحلات' : 'Error loading trips')}</p>
        `;
    }
}

async function viewTripDetails(tripId) {
    const modalBody = document.getElementById('app-modal-body');
    const lang = state.currentLanguage || 'ku';
    
    // Show loading state
    modalBody.innerHTML = `<div style="text-align:center; padding:40px; color:#666;">
        <i class="fas fa-spinner fa-spin fa-2x"></i>
        <p style="margin-top:10px;">${lang === 'ku' ? 'بارکردن...' : (lang === 'ar' ? 'جاري التحميل...' : 'Loading details...')}</p>
    </div>`;

    try {
        const response = await fetch(`${API_BASE}?endpoint=itineraries&id=${tripId}`);
        const data = await response.json();

        if (!data.success || !data.itinerary) {
            throw new Error(data.error || 'Trip not found');
        }

        const trip = data.itinerary;
        const items = data.items || [];

        // Organize items by day
        const daysMap = {};
        items.forEach(item => {
            if (!daysMap[item.day_number]) daysMap[item.day_number] = [];
            daysMap[item.day_number].push(item);
        });

        let html = `
            <div class="trip-details-view">
                <div class="trip-info-header" style="background:#f8f9fa; padding:15px; border-radius:10px; margin-bottom:20px; border-left:4px solid #3498db;">
                    <h3 style="margin:0 0 10px 0; color:#2c3e50;">${trip.title}</h3>
                    <div style="display:grid; grid-template-columns:1fr 1fr; gap:10px; font-size:0.9em; color:#666;">
                        <span><i class="fas fa-calendar-alt"></i> ${new Date(trip.start_date).toLocaleDateString()} - ${new Date(trip.end_date).toLocaleDateString()}</span>
                        <span><i class="fas fa-users"></i> ${trip.travelers_count} ${lang === 'ku' ? 'گەشتیار' : 'Travelers'}</span>
                    </div>
                </div>
                <div class="trip-timeline">
        `;

        const sortedDays = Object.keys(daysMap).sort((a, b) => a - b);
        
        if (sortedDays.length === 0) {
            html += `<p style="text-align:center; color:#999; padding:20px;">${lang === 'ku' ? 'هیچ بابەتێک نییە لەم گەشتەدا' : 'No items in this trip'}</p>`;
        } else {
            sortedDays.forEach(dayNum => {
                html += `
                    <div class="timeline-day" style="margin-bottom:20px;">
                        <h4 style="background:#3498db; color:white; padding:5px 15px; border-radius:20px; display:inline-block; margin-bottom:15px; font-size:0.9em;">
                            ${lang === 'ku' ? 'ڕۆژی' : 'Day'} ${dayNum}
                        </h4>
                        <div class="day-items-list" style="border-left:2px dashed #ddd; margin-left:15px; padding-left:20px;">
                `;

                daysMap[dayNum].sort((a, b) => a.order_number - b.order_number).forEach(item => {
                    const icon = {
                        location: 'fa-map-marker-alt',
                        business: 'fa-store',
                        transport: 'fa-car',
                        rest: 'fa-bed'
                    }[item.item_type] || 'fa-info-circle';

                    html += `
                        <div class="timeline-item" style="position:relative; margin-bottom:15px; background:white; padding:12px; border-radius:8px; box-shadow:0 2px 5px rgba(0,0,0,0.05); border:1px solid #eee;">
                            <div style="display:flex; justify-content:space-between; align-items:center;">
                                <div style="display:flex; align-items:center; gap:10px;">
                                    <span style="color:#3498db;"><i class="fas ${icon}"></i></span>
                                    <strong style="font-size:1em;">${item.title}</strong>
                                </div>
                                <span style="font-size:0.85em; color:#888; background:#f0f0f0; padding:2px 8px; border-radius:10px;">
                                    <i class="far fa-clock"></i> ${item.start_time || '--:--'}
                                </span>
                            </div>
                            ${item.description ? `<p style="margin:8px 0 0 25px; font-size:0.85em; color:#777;">${item.description}</p>` : ''}
                        </div>
                    `;
                });

                html += `</div></div>`;
            });
        }

        html += `
                </div>
                <div style="margin-top:20px; display:flex; gap:10px;">
                    <button onclick="openMyTrips()" class="btn btn-secondary" style="flex:1;">
                        <i class="fas fa-arrow-left"></i> ${lang === 'ku' ? 'گەڕانەوە' : 'Back'}
                    </button>
                </div>
            </div>
        `;

        modalBody.innerHTML = html;
        if (state.modal) {
            state.modal.title.textContent = lang === 'ku' ? 'وردەکاری گەشت' : 'Trip Details';
        }

    } catch (error) {
        console.error('Error loading trip details:', error);
        modalBody.innerHTML = `<div style="text-align:center; padding:40px; color:#e74c3c;">
            <i class="fas fa-exclamation-triangle fa-2x"></i>
            <p style="margin-top:10px;">${error.message}</p>
            <button onclick="openMyTrips()" class="btn btn-secondary" style="margin-top:15px;">Back to Trips</button>
        </div>`;
    }
}

async function deleteTrip(tripId) {
    if (!confirm(state.currentLanguage === 'ku' ? 'دڵنیایت لە سڕینەوەی ئەم گەشتە؟' : (state.currentLanguage === 'ar' ? 'هل أنت متأكد من حذف هذه الرحلة؟' : 'Are you sure you want to delete this trip?'))) {
        return;
    }
    
    try {
        const response = await fetch(`${API_BASE}?endpoint=itineraries`, {
            method: 'DELETE',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ id: tripId })
        });
        
        const data = await response.json();
        
        if (data.success) {
            // Refresh the list
            openMyTrips();
        } else {
            alert(data.error || 'Error deleting trip');
        }
    } catch (error) {
        console.error('Error deleting trip:', error);
        alert('Error deleting trip');
    }
}

// Business Directory
function openBusinessDirectory() {
    const modalBody = document.getElementById('app-modal-body');
    
    modalBody.innerHTML = `
        <div class="business-directory">
            <h3>بازرگانی و خزمەتگوزاریەکان</h3>
            <div class="business-filters">
                <select id="business-type-filter">
                    <option value="">هەموو جۆرەکان</option>
                    <option value="hotel">هۆتێل</option>
                    <option value="restaurant">خواردنگە</option>
                    <option value="transport">گواستنەوە</option>
                    <option value="tour_guide">ڕێبەری گەشت</option>
                    <option value="shopping">بازاڕ</option>
                </select>
                <input type="text" id="business-search" placeholder="گەڕانی بازرگانی...">
            </div>
            <div class="business-list" id="business-list">
                <div class="loading">دەستکاریکردنی بازرگانیەکان...</div>
            </div>
        </div>
    `;
    
    if (state.modal) {
        state.modal.title.textContent = state.currentLanguage === 'ku' ? 'بازرگانی و خزمەتگوزاریەکان' : (state.currentLanguage === 'ar' ? 'دليل الأعمال' : 'Business Directory');
        state.modal.footer.innerHTML = '';
        state.modal.root.hidden = false;
        document.body.style.overflow = 'hidden';
    }

    // Load businesses
    loadBusinesses();
    
    // Add event listeners
    document.getElementById('business-type-filter').addEventListener('change', loadBusinesses);
    document.getElementById('business-search').addEventListener('input', loadBusinesses);
}

async function loadBusinesses() {
    const typeFilter = document.getElementById('business-type-filter').value;
    const searchTerm = document.getElementById('business-search').value;
    const businessList = document.getElementById('business-list');
    
    try {
        const response = await fetch(`${API_BASE}?endpoint=businesses&type=${typeFilter}&search=${encodeURIComponent(searchTerm)}`);
        const data = await response.json();
        
        if (!data.success) {
            throw new Error(data.error || 'Failed to load businesses');
        }
        
        const businesses = data.businesses || [];
        
        if (businesses.length === 0) {
            businessList.innerHTML = '<div class="no-results">هیچ بازرگانییەک نەدۆزرایەوە</div>';
            return;
        }
        
        businessList.innerHTML = businesses.map(business => `
            <div class="business-item">
                <div class="business-info">
                    <h4>${business.name_ku}</h4>
                    <p>${business.description_ku}</p>
                    <div class="business-details">
                        <span><i class="fas fa-phone"></i> ${business.phone}</span>
                        <span><i class="fas fa-map-marker-alt"></i> ${business.address}</span>
                    </div>
                    <div class="business-rating">
                        ${'★'.repeat(Math.floor(business.rating))}${'☆'.repeat(5 - Math.floor(business.rating))}
                        <span>${business.rating}</span>
                    </div>
                </div>
                <div class="business-actions">
                    <button onclick="showBusinessOnMap(${business.lat}, ${business.lng})" class="btn btn-sm btn-primary">
                        <i class="fas fa-map"></i> نەخشە
                    </button>
                    <button onclick="callBusiness('${business.phone}')" class="btn btn-sm btn-secondary">
                        <i class="fas fa-phone"></i>
                    </button>
                </div>
            </div>
        `).join('');
        
    } catch (error) {
        console.error('Business load error:', error);
        businessList.innerHTML = '<div class="error">هەڵە لە بارکردنی بازرگانیەکان</div>';
    }
}

function showBusinessOnMap(lat, lng) {
    closeModal();
    map.setView([lat, lng], 16);
    
    // Add marker for business
    L.marker([lat, lng]).addTo(map)
        .bindPopup('Business Location')
        .openPopup();
}

function callBusiness(phone) {
    window.location.href = `tel:${phone}`;
}

// Event Calendar
function openEventCalendar() {
    const modalBody = document.getElementById('app-modal-body');
    
    modalBody.innerHTML = `
        <div class="event-calendar">
            <h3>رووداوەکان و فێستیڤاڵەکان</h3>
            <div class="calendar-controls">
                <button onclick="previousMonth()" class="btn btn-sm btn-secondary">
                    <i class="fas fa-chevron-left"></i>
                </button>
                <span id="current-month">January 2024</span>
                <button onclick="nextMonth()" class="btn btn-sm btn-secondary">
                    <i class="fas fa-chevron-right"></i>
                </button>
            </div>
            <div class="calendar-grid" id="calendar-grid">
                <!-- Calendar will be generated here -->
            </div>
            <div class="events-list" id="events-list">
                <h4>رووداوەکانی ئەم مانگە</h4>
                <div class="events-container" id="events-container">
                    <div class="loading">دەستکاریکردنی رووداوەکان...</div>
                </div>
            </div>
        </div>
    `;
    
    if (state.modal) {
        state.modal.title.textContent = state.currentLanguage === 'ku' ? 'رووداوەکان' : (state.currentLanguage === 'ar' ? 'تقويم الفعاليات' : 'Event Calendar');
        state.modal.footer.innerHTML = '';
        state.modal.root.hidden = false;
        document.body.style.overflow = 'hidden';
    }

    // Initialize calendar
    initEventCalendar();
}

function initEventCalendar() {
    const now = new Date();
    currentCalendarMonth = now.getMonth();
    currentCalendarYear = now.getFullYear();
    
    renderCalendar();
    loadEvents();
}

function renderCalendar() {
    const monthNames = ['January', 'February', 'March', 'April', 'May', 'June',
                       'July', 'August', 'September', 'October', 'November', 'December'];
    
    document.getElementById('current-month').textContent = 
        monthNames[currentCalendarMonth] + ' ' + currentCalendarYear;
    
    const firstDay = new Date(currentCalendarYear, currentCalendarMonth, 1).getDay();
    const daysInMonth = new Date(currentCalendarYear, currentCalendarMonth + 1, 0).getDate();
    
    const calendarGrid = document.getElementById('calendar-grid');
    calendarGrid.innerHTML = '';
    
    // Day headers
    const dayHeaders = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    dayHeaders.forEach(day => {
        const header = document.createElement('div');
        header.className = 'calendar-header';
        header.textContent = day;
        calendarGrid.appendChild(header);
    });
    
    // Empty cells for days before month starts
    for (let i = 0; i < firstDay; i++) {
        const emptyCell = document.createElement('div');
        emptyCell.className = 'calendar-empty';
        calendarGrid.appendChild(emptyCell);
    }
    
    // Days of the month
    for (let day = 1; day <= daysInMonth; day++) {
        const dayCell = document.createElement('div');
        dayCell.className = 'calendar-day';
        dayCell.textContent = day;
        // dayCell.onclick = () => showDayEvents(day); // Function not implemented yet
        calendarGrid.appendChild(dayCell);
    }
}

// Placeholder for future day events feature
function showDayEvents(day) {
    console.log('Day clicked:', day);
    alert('Day ' + day + ' events - Feature coming soon!');
}

async function loadEvents() {
    const eventsContainer = document.getElementById('events-container');
    
    try {
        // Use fallback data for demo purposes
        const fallbackEvents = [
            {
                id: 1,
                title_ku: 'فێستیڤاڵەکی نەورۆز',
                title_en: 'Nowruz Festival',
                description_ku: 'ئاهەنگاری ساڵی نەورۆز لەگەلەنێوەی کوردستان',
                start_date: new Date(2024, 2, 21).toISOString().split('T')[0],
                start_time: '10:00',
                location_name: 'شاری هەولێر',
                lat: 36.1911,
                lng: 44.0092
            },
            {
                id: 2,
                title_ku: 'پێشەنگانی کورد',
                title_en: 'Kurdish Heritage Day',
                description_ku: 'بۆنەوەی دەستکردنی پێشەنگانی کوردی و کولتووری',
                start_date: new Date(2024, 3, 21).toISOString().split('T')[0],
                start_time: '14:00',
                location_name: 'شاری سلێمانی',
                lat: 35.5576,
                lng: 45.4359
            },
            {
                id: 3,
                title_ku: 'پێشەنگانی سروشتی',
                title_en: 'Kurdish Nature Day',
                description_ku: 'پێشەنگانی دەستکردنی سروشتی کوردستان',
                start_date: new Date(2024, 4, 21).toISOString().split('T')[0],
                start_time: '09:00',
                location_name: 'دەری سەفەدین',
                lat: 36.2000,
                lng: 44.0200
            }
        ];
        
        // Filter events for current month
        const currentMonth = currentCalendarMonth + 1;
        const currentYear = currentCalendarYear;
        
        const filteredEvents = fallbackEvents.filter(event => {
            const eventDate = new Date(event.start_date);
            return eventDate.getMonth() + 1 === currentMonth && 
                   eventDate.getFullYear() === currentYear;
        });
        
        if (filteredEvents.length === 0) {
            eventsContainer.innerHTML = '<div class="no-events">هیچ رووداوێک لەم مانگەدا نییە</div>';
            return;
        }
        
        eventsContainer.innerHTML = filteredEvents.map(event => `
            <div class="event-item">
                <div class="event-date">
                    <div class="event-day">${new Date(event.start_date).getDate()}</div>
                    <div class="event-month">${new Date(event.start_date).toLocaleDateString('en', { month: 'short' })}</div>
                </div>
                <div class="event-info">
                    <h5>${event.title_ku}</h5>
                    <p>${event.description_ku}</p>
                    <div class="event-details">
                        <span><i class="fas fa-map-marker-alt"></i> ${event.location_name || 'Custom Location'}</span>
                        ${event.start_time ? `<span><i class="fas fa-clock"></i> ${event.start_time}</span>` : ''}
                    </div>
                </div>
                <div class="event-actions">
                    <button onclick="showEventOnMap(${event.lat}, ${event.lng})" class="btn btn-sm btn-primary">
                        <i class="fas fa-map"></i>
                    </button>
                </div>
            </div>
        `).join('');
        
        console.log('Loaded', filteredEvents.length, 'events with fallback data');
        
    } catch (error) {
        console.error('Events load error:', error);
        eventsContainer.innerHTML = '<div class="error">هەڵە لە بارکردنی رووداوەکان</div>';
    }
}

// Offline Mode
function toggleOfflineMode() {
    offlineMode = !offlineMode;
    
    if (offlineMode) {
        enableOfflineMode();
    } else {
        disableOfflineMode();
    }
}

function enableOfflineMode() {
    // Cache current data
    const offlineData = {
        locations: state.locations,
        governments: state.governments,
        categories: state.categories,
        timestamp: Date.now()
    };
    
    localStorage.setItem(STORAGE_KEYS.offline_data, JSON.stringify(offlineData));
    
    // Show notification
    showNotification('Offline mode enabled - Data cached for offline use', 'success');
    
    // Update UI
    document.querySelector('.feature-btn[onclick="toggleOfflineMode()"]').classList.add('active');
}

function disableOfflineMode() {
    // Clear offline cache
    localStorage.removeItem(STORAGE_KEYS.offline_data);
    
    // Show notification
    showNotification('Offline mode disabled', 'info');
    
    // Update UI
    document.querySelector('.feature-btn[onclick="toggleOfflineMode()"]').classList.remove('active');
}

function checkOfflineMode() {
    const offlineData = localStorage.getItem(STORAGE_KEYS.offline_data);
    
    if (offlineData && !navigator.onLine) {
        const data = JSON.parse(offlineData);
        
        // Use cached data
        state.locations = data.locations;
        state.governments = data.governments;
        state.categories = data.categories;
        
        // Show offline indicator
        showNotification('Using offline data - Some features may be limited', 'warning');
        
        return true;
    }
    
    return false;
}

// Utility Functions
// calculateDistance already defined at line 1315 - duplicate removed

function calculateBearing(lat1, lon1, lat2, lon2) {
    const dLon = (lon2 - lon1) * Math.PI / 180;
    const y = Math.sin(dLon) * Math.cos(lat2 * Math.PI / 180);
    const x = Math.cos(lat1 * Math.PI / 180) * Math.sin(lat2 * Math.PI / 180) -
              Math.sin(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) * Math.cos(dLon);
    return Math.atan2(y, x);
}

function showNotification(message, type = 'info') {
    const notification = document.createElement('div');
    notification.className = `notification notification-${type}`;
    notification.innerHTML = `
        <i class="fas fa-${type === 'success' ? 'check-circle' : type === 'error' ? 'exclamation-circle' : 'info-circle'}"></i>
        <span>${message}</span>
    `;
    
    document.body.appendChild(notification);
    
    // Auto-remove after 3 seconds
    setTimeout(() => {
        notification.remove();
    }, 3000);
}

// Use fallback bootstrap data
function useFallbackBootstrapData() {
    state.governments = [
        {id: 1, name_ku: 'دهۆک', name_en: 'Duhok', name_ar: 'دهوك', color: '#e74c3c'},
        {id: 2, name_ku: 'هەولێر', name_en: 'Erbil', name_ar: 'أربيل', color: '#2ecc71'},
        {id: 3, name_ku: 'سلێمانی', name_en: 'Sulaymaniyah', name_ar: 'السليمانية', color: '#3498db'}
    ];
    
    state.categories = [
        {id: 1, name_ku: 'مێژوویی', name_en: 'Historical', name_ar: 'تاريخي', icon: 'landmark'},
        {id: 2, name_ku: 'سروشتی', name_en: 'Natural', name_ar: 'طبيعي', icon: 'mountain'},
        {id: 3, name_ku: 'هۆتێل', name_en: 'Hotel', name_ar: 'فندق', icon: 'hotel'},
        {id: 4, name_ku: 'خواردنگە', name_en: 'Restaurant', name_ar: 'مطعم', icon: 'utensils'},
        {id: 5, name_ku: 'پارک', name_en: 'Park', name_ar: 'حديقة', icon: 'tree'}
    ];
    
    renderGovernmentFilter();
    renderCategoryFilter();
}

// Show error message
function showError(message) {
    const errorDiv = document.createElement('div');
    errorDiv.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        background: #e74c3c;
        color: white;
        padding: 15px 20px;
        border-radius: 8px;
        z-index: 10000;
        max-width: 300px;
    `;
    errorDiv.innerHTML = `
        <div style="font-weight: bold;">Error</div>
        <div>${message}</div>
        <button onclick="this.parentElement.remove()" style="
            background: white;
            color: #e74c3c;
            border: none;
            padding: 5px 10px;
            border-radius: 4px;
            cursor: pointer;
            margin-top: 10px;
        ">Close</button>
    `;
    document.body.appendChild(errorDiv);
    
    // Auto-remove after 10 seconds
    setTimeout(() => {
        if (errorDiv.parentElement) {
            errorDiv.remove();
        }
    }, 10000);
}

// Initialize enhanced features safely
function initializeEnhancedFeatures() {
    try {
        // Voice search
        const voiceBtn = document.getElementById('voice-search-btn');
        if (voiceBtn && typeof startVoiceSearch === 'function') {
            voiceBtn.addEventListener('click', startVoiceSearch);
        }
        
        // AI recommendations
        try {
            // Initialize AI recommendations with sample data
            setTimeout(() => {
                const container = document.getElementById('recommendations-container');
                if (container) {
                    showRecommendationTab('personal');
                }
            }, 1500);
        } catch (error) {
            console.log('AI recommendations not available');
        }
        
        // Social sharing
        try {
            if (typeof initSocialSharing === 'function') {
                socialSharing = initSocialSharing();
                // Initialize with current page data
                if (socialSharing) {
                    socialSharing.shareData = {
                        title: 'Kurdish Tourism Locations Map',
                        description: 'Explore beautiful tourism locations in Kurdistan Region',
                        url: window.location.href,
                        hashtags: ['KurdishTourism', 'VisitKurdistan', 'ExploreKurdistan']
                    };
                }
            }
        } catch (error) {
            console.log('Social sharing not available');
        }
        
        // User data
        try {
            checkUserAuth().then(() => {
                updateUIForLoggedInUser();
                if (currentUser) loadServerFavorites();
            });
        } catch (error) {
            console.log('User auth check failed');
        }
        
        // Offline mode
        if (typeof checkOfflineMode === 'function') {
            checkOfflineMode();
        }
        
        // User data
        if (typeof loadUserData === 'function') {
            loadUserData();
        }
        
        // Weather
        if (typeof fetchWeatherForLocation === 'function' && navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(
                position => fetchWeatherForLocation(position.coords.latitude, position.coords.longitude),
                error => console.log('Geolocation denied or unavailable')
            );
        }
        
        console.log('Enhanced features initialized');
    } catch (error) {
        console.error('Enhanced features initialization failed:', error);
    }
}

async function loadUserData() {
    try {
        const response = await fetch(`${API_BASE}?endpoint=user_current`);
        if (response.ok) {
            const result = await response.json();
            // API returns { success: true, user: {...} } — extract the user object
            if (result.success && result.user) {
                currentUser = result.user;
                updateUIForLoggedInUser();
            } else {
                currentUser = null;
            }
        } else {
            currentUser = null;
        }
    } catch (error) {
        currentUser = null;
    }
}

function updateUIForLoggedInUser() {
    if (currentUser) {
        // Update user account button
        const userBtn = document.getElementById('user-account-btn');
        if (currentUser.avatar) {
            userBtn.innerHTML = `<img src="${currentUser.avatar}" style="width:100%; height:100%; object-fit:cover; border-radius:50%;" />`;
        } else {
            const initial = (currentUser.full_name || '?').charAt(0).toUpperCase();
            userBtn.innerHTML = `<span style="font-weight:bold; font-family:var(--font-family);">${initial}</span>`;
        }
        userBtn.title = currentUser.full_name;
    }
}

// AI Recommendations Tab Functions
function showRecommendationTab(tab, buttonEl) {
    // Update active tab
    document.querySelectorAll('.recommendations-tab').forEach(t => t.classList.remove('active'));
    if (buttonEl) buttonEl.classList.add('active');
    
    // Load appropriate recommendations
    const container = document.getElementById('recommendations-container');
    if (!container) return;
    
    container.innerHTML = '<div class="recommendations-loading"><i class="fas fa-spinner fa-spin"></i><span>دەستکاریکردنی پێشنیازەکان...</span></div>';
    
    setTimeout(() => {
        let recommendations = [];
        
        switch(tab) {
            case 'personal':
                recommendations = [
                    {id: 1, name_ku: 'قەڵای هەولێر', description_ku: 'قەڵایەکی مێژوویی لە ناوەندی شاری هەولێر', average_rating: 4.7, category_id: 1},
                    {id: 2, name_ku: 'دەری سەفەدین', description_ku: 'چیایەکی سروشتی لە نزیک هەولێر', average_rating: 4.2, category_id: 2}
                ];
                break;
            case 'trending':
                recommendations = [
                    {id: 1, name_ku: 'قەڵای هەولێر', description_ku: 'قەڵایەکی مێژوویی لە ناوەندی شاری هەولێر', average_rating: 4.7, category_id: 1},
                    {id: 3, name_ku: 'شاری سلێمانی', description_ku: 'شاری سلێمانی، شارێکی گەور لە کوردستان', average_rating: 4.6, category_id: 1}
                ];
                break;
            case 'hidden':
                recommendations = [
                    {id: 5, name_ku: 'چیای قەندیل', description_ku: 'چیایەکی بەناوبانگە لە ناوچەی قەندیل', average_rating: 4.8, category_id: 2},
                    {id: 3, name_ku: 'دەری سەفەدین', description_ku: 'چیایەکی سروشتی لە نزیک هەولێر', average_rating: 4.2, category_id: 2}
                ];
                break;
        }
        
        renderRecommendations(recommendations);
    }, 500);
}

function renderRecommendations(recommendations) {
    const container = document.getElementById('recommendations-container');
    if (!container) return;
    
    if (recommendations.length === 0) {
        container.innerHTML = '<div class="no-recommendations"><i class="fas fa-lightbulb"></i><p>هیچ پێشنیازێک بۆ ئێستا نییە</p></div>';
        return;
    }
    
    container.innerHTML = recommendations.map(location => `
        <div class="recommendation-item" onclick="showLocationDetails(${location.id})">
            <div class="recommendation-image">
                <img src="https://via.placeholder.com/280x120" alt="${location.name_ku}">
            </div>
            <div class="recommendation-info">
                <h4>${location.name_ku}</h4>
                <p>${location.description_ku}</p>
                <div class="recommendation-meta">
                    <span class="rating">
                        ${'★'.repeat(Math.floor(location.average_rating))}${'☆'.repeat(5 - Math.floor(location.average_rating))}
                        ${location.average_rating}
                    </span>
                    <span class="category">${getCategoryName(location.category_id)}</span>
                </div>
            </div>
        </div>
    `).join('');
}

function getCategoryName(categoryId) {
    const category = state.categories.find(cat => cat.id === categoryId);
    return category ? category.name_ku : '';
}

// Export new functions for global access
window.handleUserAccount = handleUserAccount;
window.startVoiceSearch = startVoiceSearch;
window.openARCamera = openARCamera;
window.closeARCamera = closeARCamera;
window.openItineraryPlanner = openItineraryPlanner;
window.openMyTrips = openMyTrips;
window.viewTripDetails = viewTripDetails;
window.deleteTrip = deleteTrip;
window.openBusinessDirectory = openBusinessDirectory;
window.openEventCalendar = openEventCalendar;
window.toggleOfflineMode = toggleOfflineMode;
window.showRecommendationTab = showRecommendationTab;