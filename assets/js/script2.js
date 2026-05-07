// Detect API base path - works from both root and pages/ folder
const ADMIN_API_BASE = window.location.pathname.includes('/pages/') ? '../api.php' : 'api.php';

const AdminUI = {
    state: {
        governments: [],
        categories: [],
        locations: [],
        feedbackStatus: 'pending',
        admins: [],
        pickerMap: null,
        pickerMarker: null
    },

    async init() {
        document.getElementById('current-date').textContent = new Date().toLocaleString();
        this.bindNavigation();
        this.bindForms();
        this.bindImagePreview();
        this.initLocationPicker();
        await this.loadReferenceData();
        await Promise.all([
            this.loadDashboard(),
            this.reloadLocations(),
            this.loadFeedback(),
            this.loadVisitors(),
            this.loadUsers(),
            this.loadSettings(),
            this.loadAdminsIfNeeded()
        ]);
        this.activateTabFromHash();
    },

    bindNavigation() {
        document.querySelectorAll('.admin-nav a').forEach((link) => {
            link.addEventListener('click', async (event) => {
                event.preventDefault();
                const tab = link.dataset.tab;
                window.location.hash = tab;
                await this.activateTab(tab);
            });
        });

        window.addEventListener('hashchange', () => {
            this.activateTabFromHash();
        });

        document.querySelectorAll('[data-feedback-tab]').forEach((button) => {
            button.addEventListener('click', async () => {
                document.querySelectorAll('[data-feedback-tab]').forEach((item) => {
                    item.classList.remove('btn-primary');
                    item.classList.add('btn-secondary');
                });
                button.classList.add('btn-primary');
                button.classList.remove('btn-secondary');
                this.state.feedbackStatus = button.dataset.feedbackTab;
                await this.loadFeedback();
            });
        });
    },

    async activateTabFromHash() {
        const tab = window.location.hash.replace('#', '') || 'dashboard';
        await this.activateTab(tab);
    },

    async activateTab(tab) {
        const targetLink = document.querySelector(`.admin-nav a[data-tab="${tab}"]`);
        const targetSection = document.getElementById(tab);
        if (!targetLink || !targetSection) return;

        document.querySelectorAll('.admin-nav a').forEach((item) => item.classList.remove('active'));
        document.querySelectorAll('.tab-content').forEach((item) => item.classList.remove('active'));
        targetLink.classList.add('active');
        targetSection.classList.add('active');
        document.getElementById('current-tab').textContent = targetLink.textContent.trim();
        targetSection.scrollIntoView({ behavior: 'smooth', block: 'start' });

        if (tab === 'locations') await this.reloadLocations();
        if (tab === 'governments') await this.loadGovernmentsTable();
        if (tab === 'categories') {
            await this.loadCategoriesTable();
            // Ensure icon picker is properly initialized when categories tab is shown
            this.bindIconPicker();
            this.updateIconSelection();
            this.updateIconPreview();
        }
        if (tab === 'feedback') await this.loadFeedback();
        if (tab === 'contact-messages') await this.loadContactMessages();
        if (tab === 'visitors') await this.loadVisitors();
        if (tab === 'users') await this.loadUsers();
        if (tab === 'admins') await this.loadAdminsIfNeeded();
        if (tab === 'settings') await this.loadSettings();
    },

    bindForms() {
        document.getElementById('location-form').addEventListener('submit', (event) => this.submitLocation(event));
        document.getElementById('government-form').addEventListener('submit', (event) => this.submitSimpleForm(event, 'governments', this.resetGovernmentForm.bind(this), this.afterTaxonomySave.bind(this)));
        document.getElementById('category-form').addEventListener('submit', (event) => this.submitSimpleForm(event, 'categories', this.resetCategoryForm.bind(this), this.afterTaxonomySave.bind(this)));
        document.getElementById('settings-form').addEventListener('submit', (event) => this.submitSettings(event));
        document.getElementById('location-lat').addEventListener('input', () => this.syncPickerFromInputs());
        document.getElementById('location-lng').addEventListener('input', () => this.syncPickerFromInputs());
        this.bindIconPicker();

        const adminForm = document.getElementById('admin-form');
        if (adminForm) {
            adminForm.addEventListener('submit', (event) => this.submitSimpleForm(event, 'admins', this.resetAdminForm.bind(this), this.loadAdminsIfNeeded.bind(this)));
        }
    },

    bindIconPicker() {
        const iconPicker = document.getElementById('icon-picker');
        if (!iconPicker) return;
        
        const iconInput = document.getElementById('category-icon');
        const iconPreview = document.getElementById('icon-preview');
        
        // Add click event to all icon options
        iconPicker.querySelectorAll('.icon-option').forEach(option => {
            option.addEventListener('click', () => {
                const icon = option.dataset.icon;
                iconInput.value = icon;
                
                // Remove selected class from all options
                iconPicker.querySelectorAll('.icon-option').forEach(opt => {
                    opt.classList.remove('selected');
                });
                
                // Add selected class to clicked option
                option.classList.add('selected');
                
                // Update icon preview
                this.updateIconPreview();
            });
        });
        
        // Initialize selection based on current input value
        this.updateIconSelection();
        this.updateIconPreview();
        
        // Update selection when input changes (e.g., when editing)
        iconInput.addEventListener('input', () => {
            this.updateIconSelection();
            this.updateIconPreview();
        });
    },
    
    updateIconSelection() {
        const iconPicker = document.getElementById('icon-picker');
        const iconInput = document.getElementById('category-icon');
        if (!iconPicker || !iconInput) return;
        
        const currentIcon = iconInput.value.trim();
        
        // Remove selected class from all options
        iconPicker.querySelectorAll('.icon-option').forEach(opt => {
            opt.classList.remove('selected');
        });
        
        // Add selected class to matching option
        if (currentIcon) {
            const matchingOption = iconPicker.querySelector(`.icon-option[data-icon="${currentIcon}"]`);
            if (matchingOption) {
                matchingOption.classList.add('selected');
            }
        }
    },
    
    updateIconPreview() {
        const iconInput = document.getElementById('category-icon');
        const iconPreview = document.getElementById('icon-preview');
        if (!iconInput || !iconPreview) return;
        
        const currentIcon = iconInput.value.trim();
        const iconElement = iconPreview.querySelector('i');
        
        if (currentIcon) {
            // Update icon class
            iconElement.className = `fas fa-${currentIcon}`;
            iconPreview.style.color = '#1d4ed8';
            iconPreview.style.backgroundColor = '#dbeafe';
            iconPreview.style.borderColor = '#3b82f6';
        } else {
            // Show default/question icon
            iconElement.className = 'fas fa-question';
            iconPreview.style.color = '#475569';
            iconPreview.style.backgroundColor = '#f1f5f9';
            iconPreview.style.borderColor = '#cbd5e1';
        }
    },

    bindImagePreview() {
        const input = document.getElementById('location-images');
        input.addEventListener('change', () => {
            const preview = document.getElementById('image-preview');
            preview.innerHTML = '';
            Array.from(input.files).forEach((file) => {
                const image = document.createElement('img');
                image.src = URL.createObjectURL(file);
                image.onload = () => URL.revokeObjectURL(image.src);
                preview.appendChild(image);
            });
        });
    },

    initLocationPicker() {
        const mapElement = document.getElementById('location-picker-map');
        if (!mapElement || typeof L === 'undefined') return;

        this.state.pickerMap = L.map(mapElement).setView([36.8665, 43.0], 8);
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '&copy; OpenStreetMap contributors',
            maxZoom: 19
        }).addTo(this.state.pickerMap);

        this.state.pickerMap.on('click', (event) => {
            const lat = Number(event.latlng.lat.toFixed(7));
            const lng = Number(event.latlng.lng.toFixed(7));
            document.getElementById('location-lat').value = lat;
            document.getElementById('location-lng').value = lng;
            this.setPickerMarker(lat, lng, true);
        });

        setTimeout(() => this.state.pickerMap.invalidateSize(), 200);
    },

    setPickerMarker(lat, lng, recenter = false) {
        if (!this.isValidCoordinatePair(lat, lng) || !this.state.pickerMap) return;

        if (!this.state.pickerMarker) {
            this.state.pickerMarker = L.marker([lat, lng]).addTo(this.state.pickerMap);
        } else {
            this.state.pickerMarker.setLatLng([lat, lng]);
        }

        if (recenter) {
            this.state.pickerMap.setView([lat, lng], Math.max(this.state.pickerMap.getZoom(), 13));
        }
    },

    syncPickerFromInputs() {
        const lat = Number(document.getElementById('location-lat').value);
        const lng = Number(document.getElementById('location-lng').value);
        if (!this.isValidCoordinatePair(lat, lng)) return;
        this.setPickerMarker(lat, lng);
    },

    isValidCoordinatePair(lat, lng) {
        return Number.isFinite(lat) && Number.isFinite(lng) && lat >= -90 && lat <= 90 && lng >= -180 && lng <= 180;
    },

    async api(endpoint, options = {}) {
        // Parse endpoint that may contain query parameters (e.g., "contact?status=all")
        let baseEndpoint = endpoint;
        let queryString = '';
        
        if (endpoint.includes('?')) {
            const idx = endpoint.indexOf('?');
            baseEndpoint = endpoint.substring(0, idx);
            queryString = endpoint.substring(idx + 1);
        }
        
        let url = `${ADMIN_API_BASE}?endpoint=${baseEndpoint}`;
        if (queryString) {
            url += '&' + queryString;
        }
        url += `&_t=${Date.now()}`; // cache buster
        
        const response = await fetch(url, options);
        const data = await response.json();
        if (!response.ok) {
            throw new Error(data.error || 'Request failed');
        }
        return data;
    },

    async loadReferenceData() {
        const [governmentsData, categoriesData] = await Promise.all([
            this.api('governments'),
            this.api('categories')
        ]);
        this.state.governments = governmentsData.governments;
        this.state.categories = categoriesData.categories;
        this.populateSelect('location-government', this.state.governments, 'Select government');
        this.populateSelect('location-category', this.state.categories, 'Select category');
    },

    populateSelect(id, items, placeholder) {
        const select = document.getElementById(id);
        select.innerHTML = `<option value="">${placeholder}</option>` + items.map((item) => (
            `<option value="${item.id}">${item.name_ku}</option>`
        )).join('');
    },

    async loadDashboard() {
        const data = await this.api('dashboard');
        document.getElementById('total-locations').textContent = data.stats.total_locations;
        document.getElementById('today-visitors').textContent = data.stats.today_visitors;
        document.getElementById('new-feedback').textContent = data.stats.new_feedback;
        document.getElementById('avg-rating').textContent = Number(data.stats.avg_rating || 0).toFixed(1);
        document.getElementById('recent-activities').innerHTML = data.recent.map((item) => `
            <tr>
                <td>${item.location_name}</td>
                <td>${this.formatDate(item.happened_at)}</td>
                <td>${item.activity_type}</td>
            </tr>
        `).join('') || '<tr><td colspan="3">No recent updates</td></tr>';
    },

    async reloadLocations() {
        const data = await this.api('admin_locations');
        this.state.locations = data.locations;
        document.getElementById('locations-table').innerHTML = data.locations.map((loc) => `
            <tr>
                <td>
                    <div style="width:40px;height:40px;border-radius:6px;overflow:hidden;background:#eee;border:1px solid #ddd;">
                        <img src="${loc.cover_image || 'assets/placeholder.jpg'}" style="width:100%;height:100%;object-fit:cover;">
                    </div>
                </td>
                <td>${loc.name_ku}</td>
                <td>${loc.gov_name}</td>
                <td>${loc.cat_name}</td>
                <td><span class="status-chip status-${loc.status}">${loc.status}</span></td>
                <td>${loc.total_visits}</td>
                <td>${Number(loc.average_rating || 0).toFixed(1)}</td>
                <td class="action-btns">
                    <button class="action-btn edit-btn" onclick="AdminUI.editLocation(${loc.id})">Edit</button>
                    <button class="action-btn delete-btn" onclick="AdminUI.deleteItem('delete_location', ${loc.id}, AdminUI.reloadLocations.bind(AdminUI))">Delete</button>
                </td>
            </tr>
        `).join('') || '<tr><td colspan="8">No locations yet</td></tr>';
        await this.loadDashboard();
    },

    async editLocation(id) {
        try {
            const data = await this.api(`admin_location&id=${id}`);
            const loc = data.location;
            
            document.getElementById('location-id').value = loc.id;
            document.getElementById('location-name-ku').value = loc.name_ku || '';
            document.getElementById('location-name-en').value = loc.name_en || '';
            document.getElementById('location-name-ar').value = loc.name_ar || '';
            document.getElementById('location-description-ku').value = loc.description_ku || '';
            document.getElementById('location-description-en').value = loc.description_en || '';
            document.getElementById('location-description-ar').value = loc.description_ar || '';
            document.getElementById('location-lat').value = loc.lat || '';
            document.getElementById('location-lng').value = loc.lng || '';
            document.getElementById('location-government').value = loc.government_id || '';
            document.getElementById('location-category').value = loc.category_id || '';
            document.getElementById('location-phone').value = loc.phone || '';
            document.getElementById('location-email').value = loc.email || '';
            document.getElementById('location-website').value = loc.website || '';
            document.getElementById('location-directions-url').value = loc.directions_url || '';
            document.getElementById('location-address').value = loc.address || '';
            document.getElementById('location-opening-hours').value = loc.opening_hours || '';
            document.getElementById('location-ticket-price').value = loc.ticket_price || '';
            document.getElementById('location-featured').value = String(loc.featured || 0);
            document.getElementById('location-status').value = loc.status || 'published';
            document.getElementById('replace-images').checked = false;

            // Show existing images
            const preview = document.getElementById('image-preview');
            preview.innerHTML = (loc.images || []).map(img => `
                <div class="thumb">
                    <img src="${img.image_path}" style="width:80px;height:80px;object-fit:cover;border-radius:6px;border:1px solid #ddd;">
                </div>
            `).join('');

            this.setPickerMarker(Number(loc.lat), Number(loc.lng), true);
            document.getElementById('locations').scrollIntoView({ behavior: 'smooth' });
        } catch (error) {
            alert(error.message);
        }
    },

    startCreateLocation() {
        this.resetLocationForm();
        document.getElementById('locations').scrollIntoView({ behavior: 'smooth' });
    },

    resetLocationForm() {
        document.getElementById('location-form').reset();
        document.getElementById('location-id').value = '';
        document.getElementById('image-preview').innerHTML = '';
        // Clear suggestion tracking
        this.state.fromSuggestionId = null;
        const suggField = document.getElementById('suggestion-id-field');
        if (suggField) suggField.value = '';
        if (this.state.pickerMarker) {
            this.state.pickerMap.removeLayer(this.state.pickerMarker);
            this.state.pickerMarker = null;
        }
        if (this.state.pickerMap) {
            this.state.pickerMap.setView([36.8665, 43.0], 8);
        }
    },

    async submitLocation(event) {
        event.preventDefault();
        const form = document.getElementById('location-form');
        const lat = Number(document.getElementById('location-lat').value);
        const lng = Number(document.getElementById('location-lng').value);
        if (!this.isValidCoordinatePair(lat, lng)) {
            alert('Enter valid coordinates. Latitude must be between -90 and 90, longitude between -180 and 180.');
            return;
        }
        const formData = new FormData(form);
        // Attach suggestion_id if this was loaded from a suggestion
        if (this.state.fromSuggestionId) {
            formData.set('suggestion_id', this.state.fromSuggestionId);
        }
        try {
            await this.api('locations', { method: 'POST', body: formData });
            const wasSuggestion = !!this.state.fromSuggestionId;
            this.resetLocationForm();
            await this.reloadLocations();
            if (wasSuggestion) {
                alert('Location saved and suggestion automatically approved!');
            } else {
                alert('Location saved.');
            }
        } catch (error) {
            alert(error.message);
        }
    },

    async loadGovernmentsTable() {
        const data = await this.api('governments');
        this.state.governments = data.governments;
        this.populateSelect('location-government', this.state.governments, 'Select government');
        document.getElementById('governments-table').innerHTML = this.state.governments.map((item) => `
            <tr>
                <td>${item.name_ku}</td>
                <td>${item.location_count}</td>
                <td><span style="display:inline-block;width:16px;height:16px;background:${item.color};border-radius:50%;"></span> ${item.color}</td>
                <td class="action-btns">
                    <button class="action-btn edit-btn" onclick="AdminUI.editGovernment(${item.id})">Edit</button>
                    <button class="action-btn delete-btn" onclick="AdminUI.deleteItem('delete_government', ${item.id}, AdminUI.afterTaxonomySave.bind(AdminUI))">Delete</button>
                </td>
            </tr>
        `).join('') || '<tr><td colspan="4">No governments yet</td></tr>';
    },

    editGovernment(id) {
        const item = this.state.governments.find((gov) => Number(gov.id) === Number(id));
        if (!item) return;
        document.getElementById('government-id').value = item.id;
        document.getElementById('government-name-ku').value = item.name_ku || '';
        document.getElementById('government-name-en').value = item.name_en || '';
        document.getElementById('government-name-ar').value = item.name_ar || '';
        document.getElementById('government-color').value = item.color || '#3498db';
        document.getElementById('government-lat').value = item.lat || '';
        document.getElementById('government-lng').value = item.lng || '';
        document.getElementById('government-zoom').value = item.zoom_level || 10;
    },

    resetGovernmentForm() {
        document.getElementById('government-form').reset();
        document.getElementById('government-id').value = '';
        document.getElementById('government-color').value = '#3498db';
    },

    async loadCategoriesTable() {
        const data = await this.api('categories');
        this.state.categories = data.categories;
        this.populateSelect('location-category', this.state.categories, 'Select category');
        document.getElementById('categories-table').innerHTML = this.state.categories.map((item) => `
            <tr>
                <td>${item.name_ku}</td>
                <td>${item.location_count}</td>
                <td><i class="fas fa-${item.icon || 'map-marker-alt'}"></i> ${item.icon || ''}</td>
                <td class="action-btns">
                    <button class="action-btn edit-btn" onclick="AdminUI.editCategory(${item.id})">Edit</button>
                    <button class="action-btn delete-btn" onclick="AdminUI.deleteItem('delete_category', ${item.id}, AdminUI.afterTaxonomySave.bind(AdminUI))">Delete</button>
                </td>
            </tr>
        `).join('') || '<tr><td colspan="4">No categories yet</td></tr>';
    },

    editCategory(id) {
        const item = this.state.categories.find((cat) => Number(cat.id) === Number(id));
        if (!item) return;
        document.getElementById('category-id').value = item.id;
        document.getElementById('category-name-ku').value = item.name_ku || '';
        document.getElementById('category-name-en').value = item.name_en || '';
        document.getElementById('category-name-ar').value = item.name_ar || '';
        document.getElementById('category-icon').value = item.icon || '';
        this.updateIconSelection();
        this.updateIconPreview();
    },

    resetCategoryForm() {
        document.getElementById('category-form').reset();
        document.getElementById('category-id').value = '';
        document.getElementById('category-icon').value = '';
        this.updateIconSelection();
        this.updateIconPreview();
    },

    async afterTaxonomySave() {
        await this.loadReferenceData();
        await this.loadGovernmentsTable();
        await this.loadCategoriesTable();
        await this.reloadLocations();
    },

    async loadFeedback() {
        const data = await this.api(`feedback&status=${encodeURIComponent(this.state.feedbackStatus)}`);
        document.getElementById('feedback-table').innerHTML = data.feedback.map((item) => `
            <tr>
                <td>${item.location_name}</td>
                <td>${item.visitor_name}</td>
                <td>${'★'.repeat(item.rating)}</td>
                <td>${item.comment}</td>
                <td><span class="status-chip status-${item.status}">${item.status}</span></td>
                <td>${this.formatDate(item.created_at)}</td>
                <td class="action-btns">
                    <button class="action-btn view-btn" onclick="AdminUI.setFeedbackStatus(${item.id}, 'approved')">Approve</button>
                    <button class="action-btn edit-btn" onclick="AdminUI.setFeedbackStatus(${item.id}, 'rejected')">Reject</button>
                    <button class="action-btn delete-btn" onclick="AdminUI.deleteFeedback(${item.id})">Delete</button>
                </td>
            </tr>
        `).join('') || '<tr><td colspan="7">No feedback found</td></tr>';
        await this.loadDashboard();
    },

    async setFeedbackStatus(id, status) {
        try {
            await this.api('feedback_moderation', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ id, status })
            });
            await this.loadFeedback();
            await this.reloadLocations();
        } catch (error) {
            alert(error.message);
        }
    },

    async deleteFeedback(id) {
        try {
            await this.api('feedback_moderation', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ id, action: 'delete' })
            });
            await this.loadFeedback();
            await this.reloadLocations();
        } catch (error) {
            alert(error.message);
        }
    },

    async loadVisitors() {
        const data = await this.api('admin_visitors');
        document.getElementById('visitors-table').innerHTML = data.visitors.map((item) => `
            <tr>
                <td>${item.ip_address || '-'}</td>
                <td>${item.visits}</td>
                <td>${this.formatDate(item.last_visit)}</td>
                <td>${item.user_agent || ''}</td>
            </tr>
        `).join('') || '<tr><td colspan="4">No visits yet</td></tr>';
    },

    async loadUsers() {
        const data = await this.api('admin_users');
        document.getElementById('users-table').innerHTML = data.users.map((item) => `
            <tr>
                <td>${item.full_name || '-'}</td>
                <td>${item.email || '-'}</td>
                <td><span class="status-chip status-${item.is_verified ? 'active' : 'inactive'}">${item.is_verified ? 'Yes' : 'No'}</span></td>
                <td>${this.formatDate(item.created_at)}</td>
            </tr>
        `).join('') || '<tr><td colspan="4">No users found</td></tr>';
    },

    async loadAdminsIfNeeded() {
        if (window.ADMIN_ROLE !== 'super_admin') return;
        const data = await this.api('admins');
        this.state.admins = data.admins;
        document.getElementById('admins-table').innerHTML = data.admins.map((item) => `
            <tr>
                <td>${item.full_name}</td>
                <td>${item.username}</td>
                <td>${item.email || ''}</td>
                <td>${item.role}</td>
                <td>${item.last_login ? this.formatDate(item.last_login) : '-'}</td>
                <td><span class="status-chip status-${item.active ? 'active' : 'inactive'}">${item.active ? 'active' : 'inactive'}</span></td>
                <td class="action-btns">
                    <button class="action-btn edit-btn" onclick="AdminUI.editAdmin(${item.id})">Edit</button>
                    <button class="action-btn delete-btn" onclick="AdminUI.deleteItem('delete_admin', ${item.id}, AdminUI.loadAdminsIfNeeded.bind(AdminUI))">Delete</button>
                </td>
            </tr>
        `).join('') || '<tr><td colspan="7">No admins found</td></tr>';
    },

    editAdmin(id) {
        const item = this.state.admins.find((admin) => Number(admin.id) === Number(id));
        if (!item) return;
        document.getElementById('admin-id').value = item.id;
        document.getElementById('admin-full-name').value = item.full_name || '';
        document.getElementById('admin-username').value = item.username || '';
        document.getElementById('admin-email').value = item.email || '';
        document.getElementById('admin-password').value = '';
        document.getElementById('admin-role').value = item.role || 'admin';
        document.getElementById('admin-active').value = item.active ? '1' : '0';
    },

    resetAdminForm() {
        const form = document.getElementById('admin-form');
        if (!form) return;
        form.reset();
        document.getElementById('admin-id').value = '';
        document.getElementById('admin-active').value = '1';
    },

    async loadSettings() {
        const data = await this.api('settings');
        Object.entries(data.settings).forEach(([key, value]) => {
            const element = document.getElementById(key.replace(/_/g, '-'));
            if (element) element.value = value;
        });
    },

    async submitSettings(event) {
        event.preventDefault();
        const payload = Object.fromEntries(new FormData(event.target).entries());
        try {
            await this.api('settings', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(payload)
            });
            alert('Settings saved.');
        } catch (error) {
            alert(error.message);
        }
    },

    async submitSimpleForm(event, endpoint, resetFn, reloadFn) {
        event.preventDefault();
        const payload = Object.fromEntries(new FormData(event.target).entries());
        try {
            await this.api(endpoint, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(payload)
            });
            resetFn();
            await reloadFn();
            alert('Saved.');
        } catch (error) {
            alert(error.message);
        }
    },

    async deleteItem(endpoint, id, reloadFn) {
        if (!confirm('Delete this item?')) return;
        try {
            await this.api(endpoint, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ id })
            });
            await reloadFn();
        } catch (error) {
            alert(error.message);
        }
    },

    async exportLocationsCSV() {
        // Open the CSV export endpoint in a new window/tab
        // This will trigger a file download
        window.open('api.php?endpoint=export_locations_csv', '_blank');
    },

    formatDate(value) {
        if (!value) return '-';
        return new Date(value).toLocaleString();
    },

    // Contact Messages Management
    currentContactTab: 'unread',
    currentContactId: null,

    async loadContactMessages(status = 'unread', page = 1) {
        try {
            this.currentContactTab = status;
            console.log('Loading contact messages, status:', status);
            const data = await this.api(`contact?status=${status}&page=${page}`);
            console.log('Contact API response:', data);
            
            if (!data.success) {
                console.error('API error:', data.error);
                const tbody = document.getElementById('contact-messages-table');
                if (tbody) tbody.innerHTML = `<tr><td colspan="7" style="text-align:center; padding:40px; color:#999;">Error: ${data.error || 'Failed to load'}</td></tr>`;
                return;
            }
        
        // Update counts
        document.getElementById('contact-unread-count').textContent = data.counts?.unread > 0 ? `(${data.counts.unread})` : '';
        document.getElementById('contact-read-count').textContent = data.counts.read > 0 ? `(${data.counts.read})` : '';
        document.getElementById('contact-replied-count').textContent = data.counts.replied > 0 ? `(${data.counts.replied})` : '';
        document.getElementById('contact-all-count').textContent = data.counts.all > 0 ? `(${data.counts.all})` : '';
        
        // Update sidebar count badge
        const sidebarBadge = document.getElementById('sidebar-contact-count');
        if (sidebarBadge) {
            if (data.counts.unread > 0) {
                sidebarBadge.textContent = data.counts.unread;
                sidebarBadge.style.display = 'inline';
            } else {
                sidebarBadge.style.display = 'none';
            }
        }
        
        const tbody = document.getElementById('contact-messages-table');
        if (!data.messages || data.messages.length === 0) {
            tbody.innerHTML = '<tr><td colspan="7" style="text-align:center; padding:40px; color:#999;">No messages found</td></tr>';
            return;
        }
        
        tbody.innerHTML = data.messages.map(msg => {
            const statusClass = {
                'unread': 'status-pending',
                'read': 'status-approved',
                'replied': 'status-published'
            }[msg.status] || 'status-pending';
            
            const statusText = {
                'unread': 'Unread',
                'read': 'Read',
                'replied': 'Replied'
            }[msg.status] || msg.status;
            
            const shortMessage = msg.message.length > 50 ? msg.message.substring(0, 50) + '...' : msg.message;
            
            return `
                <tr class="${msg.status === 'unread' ? 'unread-row' : ''}" style="${msg.status === 'unread' ? 'background:#fff3cd;' : ''}">
                    <td><strong>${this.escapeHtml(msg.full_name)}</strong></td>
                    <td>${this.escapeHtml(msg.email)}</td>
                    <td>${this.escapeHtml(msg.subject)}</td>
                    <td title="${this.escapeHtml(msg.message)}">${this.escapeHtml(shortMessage)}</td>
                    <td><span class="status-chip ${statusClass}">${statusText}</span></td>
                    <td>${this.formatDate(msg.created_at)}</td>
                    <td class="action-btns">
                        <button class="action-btn view-btn" onclick="AdminUI.viewContactMessage(${msg.id})">View</button>
                        <button class="action-btn delete-btn" onclick="AdminUI.deleteContactMessage(${msg.id})">Delete</button>
                    </td>
                </tr>
            `;
        }).join('');
        } catch (error) {
            console.error('Error loading contact messages:', error);
            const tbody = document.getElementById('contact-messages-table');
            if (tbody) tbody.innerHTML = `<tr><td colspan="7" style="text-align:center; padding:40px; color:#999;">Error loading messages: ${error.message}</td></tr>`;
        }
    },

    async viewContactMessage(id) {
        // Set both local and global currentContactId for reply function
        this.currentContactId = id;
        window.currentContactId = id;
        
        try {
            const data = await this.api(`contact?status=all`);
            console.log('All messages:', data.messages);
            console.log('Looking for ID:', id, 'type:', typeof id);
            
            // Convert ID to number for comparison (database returns strings)
            const numericId = Number(id);
            const msg = data.messages.find(m => Number(m.id) === numericId);
            
            if (!msg) {
                console.error('Message not found with ID:', id, 'Available IDs:', data.messages.map(m => m.id));
                alert('Message not found. ID: ' + id);
                return;
            }
        
        // Mark as read if unread
        if (msg.status === 'unread') {
            await this.api('contact', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ id: id, status: 'read' })
            });
        }
        
        // Populate modal
        document.getElementById('contact-detail-subject').textContent = msg.subject;
        document.getElementById('contact-detail-name').textContent = msg.full_name;
        document.getElementById('contact-detail-email').textContent = msg.email;
        document.getElementById('contact-detail-phone').textContent = msg.phone || 'N/A';
        document.getElementById('contact-detail-date').textContent = this.formatDate(msg.created_at);
        document.getElementById('contact-detail-message').textContent = msg.message;
        
        // Show/hide reply sections
        const replySection = document.getElementById('contact-reply-section');
        const existingReply = document.getElementById('contact-existing-reply');
        
        if (msg.status === 'replied' && msg.admin_reply) {
            replySection.style.display = 'none';
            existingReply.style.display = 'block';
            document.getElementById('contact-reply-content').textContent = msg.admin_reply;
            document.getElementById('contact-reply-date').textContent = 'Replied: ' + this.formatDate(msg.replied_at);
        } else {
            replySection.style.display = 'block';
            existingReply.style.display = 'none';
            document.getElementById('contact-reply-text').value = '';
        }
        
        // Show modal
        document.getElementById('contact-detail-modal').style.display = 'flex';
        } catch (error) {
            console.error('Error viewing contact message:', error);
            alert('Error loading message: ' + error.message);
        }
    },

    async deleteContactMessage(id) {
        if (!confirm('Are you sure you want to delete this message?')) return;
        
        try {
            await this.api('contact', {
                method: 'DELETE',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ id: id })
            });
            await this.loadContactMessages(this.currentContactTab);
        } catch (error) {
            alert('Error deleting message: ' + error.message);
        }
    },

    escapeHtml(text) {
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    },

    // SUGGESTIONS MANAGEMENT
    async loadSuggestions(status = 'pending') {
        try {
            console.log('Loading suggestions with status:', status);
            const data = await this.api(`suggest_location?status=${status}`);
            console.log('Suggestions API response:', data);
            
            const tbody = document.getElementById('suggestions-table');
            
            if (!data.success) {
                console.error('API error:', data.error);
                tbody.innerHTML = `<tr><td colspan="7" style="text-align:center; padding:40px; color:#e74c3c;">Error: ${data.error || 'Failed to load'}</td></tr>`;
                return;
            }
            
            if (!data.suggestions || data.suggestions.length === 0) {
                tbody.innerHTML = `<tr><td colspan="7" style="text-align:center; padding:40px;">No ${status} suggestions found</td></tr>`;
                return;
            }
            
            this.currentSuggestions = data.suggestions;
            
            tbody.innerHTML = data.suggestions.map(s => {
                const imageHtml = s.image_path 
                    ? `<img src="${s.image_path}" style="width:60px; height:60px; object-fit:cover; border-radius:5px;">`
                    : (s.image_base64 
                        ? `<img src="${s.image_base64.substring(0, 100)}..." style="width:60px; height:60px; object-fit:cover; border-radius:5px;">`
                        : '<i class="fas fa-image" style="font-size:2rem; color:#ccc;"></i>');
                
                return `
                    <tr>
                        <td>${imageHtml}</td>
                        <td><strong>${this.escapeHtml(s.name_ku)}</strong><br><small>${this.escapeHtml(s.name_en || '')}</small></td>
                        <td>${this.escapeHtml(s.user_name || 'Unknown')}<br><small>${this.escapeHtml(s.user_email || '')}</small></td>
                        <td>${s.lat}, ${s.lng}</td>
                        <td><span class="status-chip status-${s.status}">${s.status}</span></td>
                        <td>${this.formatDate(s.created_at)}</td>
                        <td class="action-btns">
                            <button class="action-btn view-btn" onclick="AdminUI.viewSuggestion(${s.id})">View</button>
                            ${s.status === 'pending' ? `
                                <button class="action-btn edit-btn" onclick="AdminUI.approveSuggestion(${s.id})">Approve</button>
                                <button class="action-btn delete-btn" onclick="AdminUI.rejectSuggestion(${s.id})">Reject</button>
                            ` : ''}
                        </td>
                    </tr>
                `;
            }).join('');
            
            // Update sidebar badge
            const pendingCount = data.suggestions.filter(s => s.status === 'pending').length;
            const badge = document.getElementById('sidebar-suggestion-count');
            if (badge) {
                badge.textContent = pendingCount;
                badge.style.display = pendingCount > 0 ? 'inline-block' : 'none';
            }
            
        } catch (error) {
            console.error('Error loading suggestions:', error);
            document.getElementById('suggestions-table').innerHTML = 
                `<tr><td colspan="7" style="text-align:center; padding:40px; color:#e74c3c;">Error loading suggestions</td></tr>`;
        }
    },

    async viewSuggestion(id) {
        const suggestion = this.currentSuggestions?.find(s => Number(s.id) === Number(id));
        if (!suggestion) {
            alert('Suggestion not found');
            return;
        }
        // Show detail modal
        this.viewSuggestionDetail(id);
    },
    
    async viewSuggestionDetail(id) {
        // Full detail modal view (called from action buttons in table)
        const suggestion = this.currentSuggestions?.find(s => Number(s.id) === Number(id));
        if (!suggestion) {
            alert('Suggestion not found');
            return;
        }
        
        this.currentSuggestionId = id;
        
        // Show image
        const imageContainer = document.getElementById('suggestion-detail-image');
        if (suggestion.image_path) {
            imageContainer.innerHTML = `<img src="${suggestion.image_path}" style="max-width:100%; max-height:300px; border-radius:8px;">`;
        } else if (suggestion.image_base64) {
            imageContainer.innerHTML = `<img src="${suggestion.image_base64}" style="max-width:100%; max-height:300px; border-radius:8px;">`;
        } else {
            imageContainer.innerHTML = '<p style="color:#999;"><i class="fas fa-image"></i> No image uploaded</p>';
        }
        
        // Resolve government & category names
        const govName = (this.state.governments || []).find(g => Number(g.id) === Number(suggestion.government_id));
        const catName = (this.state.categories || []).find(c => Number(c.id) === Number(suggestion.category_id));
        const govLabel = govName ? `${govName.name_ku} / ${govName.name_en || ''}` : (suggestion.government_id || 'N/A');
        const catLabel = catName ? `${catName.name_ku} / ${catName.name_en || ''}` : (suggestion.category_id || 'N/A');
        // Show details
        document.getElementById('suggestion-detail-content').innerHTML = `
            <div class="suggestion-info-grid">
                <div class="suggestion-info-section">
                    <div style="padding:15px; background:#fff; border-radius:10px; border:1px solid #e1e8ed;">
                            <h4 style="margin-top:0; margin-bottom:12px; font-size:1.1em; color:#2c3e50; border-bottom:1px solid #eee; padding-bottom:8px;"><i class="fas fa-info-circle"></i> Suggestion Details</h4>
                            <table style="width:100%; border-collapse:collapse; font-size:0.92em;">
                                <tr><td style="padding:6px 8px; font-weight:600; color:#555; width:40%;">Name (KU)</td><td style="padding:6px 8px;">${this.escapeHtml(suggestion.name_ku)}</td></tr>
                                <tr style="background:#f8f9fa;"><td style="padding:6px 8px; font-weight:600; color:#555;">Name (EN)</td><td style="padding:6px 8px;">${this.escapeHtml(suggestion.name_en || '—')}</td></tr>
                                <tr><td style="padding:6px 8px; font-weight:600; color:#555;">Name (AR)</td><td style="padding:6px 8px; direction:rtl; text-align:right;">${this.escapeHtml(suggestion.name_ar || '—')}</td></tr>
                                <tr style="background:#f8f9fa;"><td style="padding:6px 8px; font-weight:600; color:#555;">Government</td><td style="padding:6px 8px;">${this.escapeHtml(suggestion.government_name || suggestion.government_id || '—')}</td></tr>
                                <tr><td style="padding:6px 8px; font-weight:600; color:#555;">Category</td><td style="padding:6px 8px;">${this.escapeHtml(suggestion.category_name || suggestion.category_id || '—')}</td></tr>
                                <tr style="background:#f8f9fa;"><td style="padding:6px 8px; font-weight:600; color:#555;">Description (KU)</td><td style="padding:6px 8px; font-size:0.9em;">${this.escapeHtml(suggestion.description_ku || '—')}</td></tr>
                                <tr><td style="padding:6px 8px; font-weight:600; color:#555;">Address</td><td style="padding:6px 8px;">${this.escapeHtml(suggestion.address || '—')}</td></tr>
                                <tr style="background:#f8f9fa;"><td style="padding:6px 8px; font-weight:600; color:#555;">Phone</td><td style="padding:6px 8px;">${this.escapeHtml(suggestion.phone || '—')}</td></tr>
                                <tr><td style="padding:6px 8px; font-weight:600; color:#555;">Email</td><td style="padding:6px 8px;">${this.escapeHtml(suggestion.email || '—')}</td></tr>
                                <tr style="background:#f8f9fa;"><td style="padding:6px 8px; font-weight:600; color:#555;">Website</td><td style="padding:6px 8px;">${suggestion.website ? `<a href="${this.escapeHtml(suggestion.website)}" target="_blank" style="color:#3498db; text-decoration:none;"><i class="fas fa-external-link-alt"></i> Link</a>` : '—'}</td></tr>
                                <tr><td style="padding:6px 8px; font-weight:600; color:#555;">Opening Hours</td><td style="padding:6px 8px;">${this.escapeHtml(suggestion.opening_hours || '—')}</td></tr>
                                <tr style="background:#f8f9fa;"><td style="padding:6px 8px; font-weight:600; color:#555;">Ticket Price</td><td style="padding:6px 8px;">${this.escapeHtml(suggestion.ticket_price || '—')}</td></tr>
                                <tr><td style="padding:6px 8px; font-weight:600; color:#555;">Google Maps URL</td><td style="padding:6px 8px;">${suggestion.directions_url ? `<a href="${this.escapeHtml(suggestion.directions_url)}" target="_blank" style="color:#3498db; text-decoration:none;"><i class="fas fa-map-marked-alt"></i> View</a>` : '—'}</td></tr>
                            </table>
                            
                            ${suggestion.image_path ? `
                            <div style="margin-top:15px; border-top:1px solid #eee; padding-top:15px;">
                                <div style="font-weight:600; color:#555; margin-bottom:8px; font-size:0.92em;">Suggested Image:</div>
                                <img src="${suggestion.image_path}" style="width:100%; border-radius:8px; max-height:220px; object-fit:cover; border:1px solid #ddd; cursor:pointer;" onclick="window.open(this.src)">
                            </div>` : ''}
                        </div>
                </div>
                <div class="suggestion-info-section" style="margin-top:15px;">
                    <h4 style="margin:0 0 10px; color:#2c3e50; border-bottom:2px solid #e67e22; padding-bottom:6px;"><i class="fas fa-crosshairs"></i> Coordinates &amp; Map Preview</h4>
                    <p style="margin:0 0 8px; font-family:monospace; background:#f8f9fa; padding:8px; border-radius:6px; border-left:3px solid #e67e22;">
                        <strong>Lat:</strong> ${suggestion.lat} &nbsp;&nbsp; <strong>Lng:</strong> ${suggestion.lng}
                        &nbsp;<a href="https://www.google.com/maps?q=${suggestion.lat},${suggestion.lng}" target="_blank" style="font-size:0.8em; color:#3498db;"><i class="fas fa-external-link-alt"></i> Open in Google Maps</a>
                    </p>
                    <div id="suggestion-preview-map" style="width:100%; height:220px; border-radius:8px; border:1px solid #ddd; overflow:hidden;"></div>
                </div>
                <div class="suggestion-info-section" style="margin-top:15px;">
                    <h4 style="margin:0 0 10px; color:#2c3e50; border-bottom:2px solid #9b59b6; padding-bottom:6px;"><i class="fas fa-user"></i> Submitted By</h4>
                    <p style="margin:3px 0;"><strong>Name:</strong> ${this.escapeHtml(suggestion.user_name || 'Unknown')}</p>
                    <p style="margin:3px 0;"><strong>Email:</strong> ${this.escapeHtml(suggestion.user_email || 'N/A')}</p>
                    <p style="margin:3px 0;"><strong>Date:</strong> ${this.formatDate(suggestion.created_at)}</p>
                    <p style="margin:3px 0;"><strong>Status:</strong> <span class="status-chip status-${suggestion.status}">${suggestion.status}</span></p>
                </div>
            </div>
            <div style="margin-top:15px; padding:10px; background:#fff8e1; border:1px solid #f39c12; border-radius:8px;">
                <button onclick="AdminUI.loadSuggestionIntoForm()" class="btn btn-secondary" style="font-size:0.85em;">
                    <i class="fas fa-edit"></i> Load into &quot;Add Location&quot; Form for Review
                </button>
                <small style="display:block; margin-top:5px; color:#888;">Opens the location form pre-filled with this suggestion's data so you can check and correct before saving.</small>
            </div>
        `;
        
        document.getElementById('suggestion-detail-modal').style.display = 'flex';
        
        // Initialize mini preview map after modal is shown
        setTimeout(() => {
            this._initSuggestionPreviewMap(suggestion.lat, suggestion.lng);
        }, 100);
    },
    
    _initSuggestionPreviewMap(lat, lng) {
        if (typeof L === 'undefined') return;
        const mapEl = document.getElementById('suggestion-preview-map');
        if (!mapEl) return;
        
        // Destroy previous map instance if any
        if (this._suggestionPreviewMap) {
            this._suggestionPreviewMap.remove();
            this._suggestionPreviewMap = null;
        }
        
        this._suggestionPreviewMap = L.map(mapEl, { zoomControl: true, scrollWheelZoom: false }).setView([lat, lng], 14);
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '© OpenStreetMap contributors',
            maxZoom: 19
        }).addTo(this._suggestionPreviewMap);
        L.marker([lat, lng]).addTo(this._suggestionPreviewMap)
            .bindPopup('<strong>Suggested Location</strong>')
            .openPopup();
        
        setTimeout(() => this._suggestionPreviewMap.invalidateSize(), 150);
    },
    
    loadSuggestionIntoForm() {
        const id = this.currentSuggestionId;
        const suggestion = this.currentSuggestions?.find(s => Number(s.id) === Number(id));
        if (!suggestion) return;
        this.loadSuggestionIntoFormById(suggestion);
    },

    loadSuggestionIntoFormById(suggestion) {
        // Switch to locations tab
        window.location.hash = 'locations';
        this.activateTab('locations').then(() => {
            // Pre-fill the location form
            this.resetLocationForm();
            console.log('AdminUI: Populating form with suggestion:', suggestion);
            
            // Track which suggestion this came from
            this.state.fromSuggestionId = suggestion.id;
            const suggField = document.getElementById('suggestion-id-field');
            if (suggField) suggField.value = suggestion.id;

            const fields = {
                'location-name-ku': suggestion.name_ku,
                'location-name-en': suggestion.name_en,
                'location-name-ar': suggestion.name_ar,
                'location-description-ku': suggestion.description_ku,
                'location-description-en': suggestion.description_en,
                'location-description-ar': suggestion.description_ar,
                'location-lat': suggestion.lat,
                'location-lng': suggestion.lng,
                'location-address': suggestion.address,
                'location-phone': suggestion.phone,
                'location-email': suggestion.email,
                'location-website': suggestion.website,
                'location-directions-url': suggestion.directions_url,
                'location-opening-hours': suggestion.opening_hours,
                'location-ticket-price': suggestion.ticket_price,
                'location-government': suggestion.government_id,
                'location-category': suggestion.category_id
            };

            for (const [id, value] of Object.entries(fields)) {
                const el = document.getElementById(id);
                if (el) el.value = value || '';
            }

            this.setPickerMarker(Number(suggestion.lat), Number(suggestion.lng), true);
            this.syncPickerFromInputs();

            if (suggestion.image_path) {
                const preview = document.getElementById('image-preview');
                if (preview) {
                    preview.innerHTML = `<div class="thumb" style="border:2px solid #3498db;"><img src="${suggestion.image_path}" style="width:100px;height:100px;object-fit:cover;"><div style="font-size:9px;text-align:center;background:#3498db;color:white;">Suggested</div></div>`;
                }
            }

            // Close modal if open
            const modal = document.getElementById('suggestion-detail-modal');
            if (modal) modal.style.display = 'none';

            // Banner notification
            const banner = document.createElement('div');
            banner.style.cssText = 'background:#fff3cd;border:1px solid #f39c12;padding:12px 16px;border-radius:8px;margin-bottom:15px;display:flex;align-items:center;gap:10px;font-weight:500;';
            banner.innerHTML = `<i class="fas fa-info-circle" style="color:#f39c12;"></i> Loaded from suggestion by <strong>${this.escapeHtml(suggestion.user_name || 'user')}</strong>. Save this location to automatically approve the suggestion.
                <button onclick="this.parentElement.remove()" style="margin-left:auto;background:none;border:none;font-size:1.2em;cursor:pointer;">×</button>`;
            const form = document.getElementById('location-form');
            form.insertBefore(banner, form.firstChild);

            // Scroll to form
            form.scrollIntoView({ behavior: 'smooth' });
        });
    },


    async approveSuggestion(id) {
        if (!id && !this.currentSuggestionId) {
            alert('No suggestion selected');
            return;
        }
        
        const suggestionId = id || this.currentSuggestionId;
        
        if (!confirm('Approve this suggestion and add it to the map?')) return;
        
        try {
            const response = await this.api('review_suggestion', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ 
                    id: suggestionId, 
                    action: 'approve',
                    admin_note: 'Approved by admin'
                })
            });
            
            if (response.success) {
                alert('Suggestion approved! It has been added to the map.');
                document.getElementById('suggestion-detail-modal').style.display = 'none';
                this.loadSuggestions('pending');
            } else {
                alert(response.error || 'Failed to approve suggestion');
            }
        } catch (error) {
            console.error('Error approving suggestion:', error);
            alert('Error approving suggestion');
        }
    },

    async rejectSuggestion(id) {
        if (!id && !this.currentSuggestionId) {
            alert('No suggestion selected');
            return;
        }
        
        const suggestionId = id || this.currentSuggestionId;
        
        if (!confirm('Reject this suggestion?')) return;
        
        try {
            const response = await this.api('review_suggestion', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ 
                    id: suggestionId, 
                    action: 'reject',
                    admin_note: 'Rejected by admin'
                })
            });
            
            if (response.success) {
                alert('Suggestion rejected.');
                document.getElementById('suggestion-detail-modal').style.display = 'none';
                this.loadSuggestions('pending');
            } else {
                alert(response.error || 'Failed to reject suggestion');
            }
        } catch (error) {
            console.error('Error rejecting suggestion:', error);
            alert('Error rejecting suggestion');
        }
    }
};

document.addEventListener('DOMContentLoaded', () => {
    AdminUI.init().catch((error) => {
        console.error(error);
        alert(error.message);
    });
});

window.AdminUI = AdminUI;
