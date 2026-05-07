// AI-Powered Location Recommendations System

class AIRecommendations {
    constructor() {
        this.userPreferences = this.loadUserPreferences();
        this.locationData = [];
        this.userBehavior = this.loadUserBehavior();
    }

    // Load user preferences from localStorage
    loadUserPreferences() {
        const stored = localStorage.getItem('user_preferences');
        return stored ? JSON.parse(stored) : {
            categories: [],
            priceRange: 'medium',
            travelStyle: 'cultural',
            groupSize: 2,
            accessibility: false,
            season: 'spring'
        };
    }

    // Load user behavior data
    loadUserBehavior() {
        const stored = localStorage.getItem('user_behavior');
        return stored ? JSON.parse(stored) : {
            viewedLocations: [],
            favoriteCategories: {},
            searchHistory: [],
            timeSpentOnLocations: {},
            ratingsGiven: {}
        };
    }

    // Save user preferences
    saveUserPreferences(preferences) {
        this.userPreferences = { ...this.userPreferences, ...preferences };
        localStorage.setItem('user_preferences', JSON.stringify(this.userPreferences));
    }

    // Track user behavior
    trackBehavior(action, data) {
        switch (action) {
            case 'view_location':
                this.userBehavior.viewedLocations.push(data.locationId);
                this.userBehavior.timeSpentOnLocations[data.locationId] = 
                    (this.userBehavior.timeSpentOnLocations[data.locationId] || 0) + (data.duration || 0);
                break;
            case 'search':
                this.userBehavior.searchHistory.push(data.query);
                break;
            case 'rate_location':
                this.userBehavior.ratingsGiven[data.locationId] = data.rating;
                break;
            case 'favorite_category':
                const category = data.category;
                this.userBehavior.favoriteCategories[category] = 
                    (this.userBehavior.favoriteCategories[category] || 0) + 1;
                break;
        }
        
        localStorage.setItem('user_behavior', JSON.stringify(this.userBehavior));
    }

    // Get personalized recommendations
    async getRecommendations(locationId = null, count = 5) {
        if (!this.locationData.length) {
            await this.loadLocationData();
        }

        const recommendations = [];
        
        if (locationId) {
            // Get similar locations to the current one
            recommendations.push(...this.getSimilarLocations(locationId, Math.ceil(count / 2)));
        }
        
        // Get recommendations based on user preferences
        recommendations.push(...this.getPreferenceBasedRecommendations(Math.ceil(count / 2)));
        
        // Remove duplicates and limit to requested count
        const uniqueRecommendations = this.removeDuplicates(recommendations);
        return uniqueRecommendations.slice(0, count);
    }

    // Load location data
    async loadLocationData() {
        try {
            const response = await fetch('api.php?endpoint=locations');
            const data = await response.json();
            this.locationData = data.locations || [];
        } catch (error) {
            console.error('Failed to load location data:', error);
        }
    }

    // Get similar locations based on current location
    getSimilarLocations(locationId, count) {
        const currentLocation = this.locationData.find(loc => loc.id === locationId);
        if (!currentLocation) return [];

        const similarities = this.locationData
            .filter(loc => loc.id !== locationId)
            .map(location => ({
                location,
                score: this.calculateSimilarity(currentLocation, location)
            }))
            .sort((a, b) => b.score - a.score)
            .slice(0, count);

        return similarities.map(item => item.location);
    }

    // Calculate similarity between two locations
    calculateSimilarity(loc1, loc2) {
        let score = 0;

        // Category similarity (30% weight)
        if (loc1.category_id === loc2.category_id) {
            score += 0.3;
        }

        // Government/region similarity (20% weight)
        if (loc1.government_id === loc2.government_id) {
            score += 0.2;
        }

        // Rating similarity (20% weight)
        const ratingDiff = Math.abs((loc1.average_rating || 0) - (loc2.average_rating || 0));
        score += Math.max(0, 0.2 - (ratingDiff / 5));

        // Distance similarity (15% weight)
        const distance = this.calculateDistance(loc1.lat, loc1.lng, loc2.lat, loc2.lng);
        if (distance < 50) { // Within 50km
            score += 0.15 * (1 - distance / 50);
        }

        // User behavior similarity (15% weight)
        if (this.userBehavior.viewedLocations.includes(loc2.id)) {
            score += 0.1;
        }
        if (this.userBehavior.ratingsGiven[loc2.id] && this.userBehavior.ratingsGiven[loc2.id] >= 4) {
            score += 0.05;
        }

        return score;
    }

    // Get recommendations based on user preferences
    getPreferenceBasedRecommendations(count) {
        const scored = this.locationData
            .filter(location => !this.userBehavior.viewedLocations.includes(location.id))
            .map(location => ({
                location,
                score: this.calculatePreferenceScore(location)
            }))
            .filter(item => item.score > 0)
            .sort((a, b) => b.score - a.score)
            .slice(0, count);

        return scored.map(item => item.location);
    }

    // Calculate preference score for a location
    calculatePreferenceScore(location) {
        let score = 0;

        // Category preference
        if (this.userPreferences.categories.includes(location.category_id)) {
            score += 0.4;
        }

        // Favorite categories from behavior
        const categoryFrequency = this.userBehavior.favoriteCategories[location.category_id] || 0;
        if (categoryFrequency > 0) {
            score += Math.min(0.3, categoryFrequency * 0.1);
        }

        // Rating preference
        if (location.average_rating >= 4) {
            score += 0.2;
        }

        // Search history matching
        const searchMatches = this.userBehavior.searchHistory.filter(search => 
            this.searchMatchesLocation(search, location)
        ).length;
        if (searchMatches > 0) {
            score += Math.min(0.1, searchMatches * 0.05);
        }

        return score;
    }

    // Check if search query matches location
    searchMatchesLocation(query, location) {
        const lowerQuery = query.toLowerCase();
        return location.name_ku.toLowerCase().includes(lowerQuery) ||
               location.name_en.toLowerCase().includes(lowerQuery) ||
               location.description_ku?.toLowerCase().includes(lowerQuery) ||
               location.description_en?.toLowerCase().includes(lowerQuery);
    }

    // Calculate distance between two points
    calculateDistance(lat1, lon1, lat2, lon2) {
        const R = 6371; // Earth's radius in kilometers
        const dLat = (lat2 - lat1) * Math.PI / 180;
        const dLon = (lon2 - lon1) * Math.PI / 180;
        const a = Math.sin(dLat/2) * Math.sin(dLat/2) +
                  Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) *
                  Math.sin(dLon/2) * Math.sin(dLon/2);
        const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
        return R * c;
    }

    // Remove duplicates from recommendations
    removeDuplicates(recommendations) {
        const seen = new Set();
        return recommendations.filter(item => {
            if (seen.has(item.id)) {
                return false;
            }
            seen.add(item.id);
            return true;
        });
    }

    // Get trending locations
    getTrendingLocations(count = 5) {
        return this.locationData
            .filter(location => location.featured || location.total_visits > 10)
            .sort((a, b) => (b.total_visits || 0) - (a.total_visits || 0))
            .slice(0, count);
    }

    // Get hidden gems (less visited but highly rated)
    getHiddenGems(count = 5) {
        return this.locationData
            .filter(location => 
                (location.total_visits || 0) < 20 && 
                (location.average_rating || 0) >= 4.5
            )
            .sort((a, b) => (b.average_rating || 0) - (a.average_rating || 0))
            .slice(0, count);
    }

    // Update recommendations UI
    async updateRecommendationsUI(locationId = null) {
        const recommendations = await this.getRecommendations(locationId);
        const container = document.getElementById('recommendations-container');
        
        if (!container) return;

        if (recommendations.length === 0) {
            container.innerHTML = `
                <div class="no-recommendations">
                    <i class="fas fa-lightbulb"></i>
                    <p>هیچ پێشنیازێک بۆ ئێستا نییە</p>
                </div>
            `;
            return;
        }

        container.innerHTML = recommendations.map(location => `
            <div class="recommendation-item" onclick="showLocationDetails(${location.id})">
                <div class="recommendation-image">
                    <img src="${location.image_path || 'https://via.placeholder.com/150x100'}" alt="${location.name_ku}">
                </div>
                <div class="recommendation-info">
                    <h4>${location.name_ku}</h4>
                    <p>${this.truncateText(location.description_ku || '', 80)}</p>
                    <div class="recommendation-meta">
                        <span class="rating">
                            ${'★'.repeat(Math.floor(location.average_rating || 0))}${'☆'.repeat(5 - Math.floor(location.average_rating || 0))}
                            ${location.average_rating || 0}
                        </span>
                        <span class="category">${this.getCategoryName(location.category_id)}</span>
                    </div>
                </div>
            </div>
        `).join('');
    }

    // Get category name
    getCategoryName(categoryId) {
        const category = state.categories.find(cat => cat.id === categoryId);
        return category ? category.name_ku : '';
    }

    // Truncate text
    truncateText(text, maxLength) {
        if (text.length <= maxLength) return text;
        return text.substring(0, maxLength) + '...';
    }

    // Initialize preference collection
    initPreferenceCollection() {
        // Create preference modal
        const modal = document.createElement('div');
        modal.className = 'preference-modal';
        modal.innerHTML = `
            <div class="preference-modal-content">
                <h3>دڵنیابەرەوە لە پێشنیازەکانی تۆ</h3>
                <form id="preference-form">
                    <div class="form-group">
                        <label>پەسەندکراوترین جۆرەکان</label>
                        <div class="category-checkboxes">
                            ${this.generateCategoryCheckboxes()}
                        </div>
                    </div>
                    <div class="form-group">
                        <label>شێوازی گەشتکردن</label>
                        <select name="travelStyle">
                            <option value="cultural">فرهەنگی</option>
                            <option value="adventure">سەرکێشیکاری</option>
                            <option value="relaxation">ئارامبەخش</option>
                            <option value="family">خێزانی</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>ژمارەی گەشتیاران</label>
                        <input type="number" name="groupSize" min="1" max="20" value="2">
                    </div>
                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">پاشەکەوتکردن</button>
                        <button type="button" onclick="this.closest('.preference-modal').remove()" class="btn btn-secondary">هەڵوەشاندنەوە</button>
                    </div>
                </form>
            </div>
        `;
        
        document.body.appendChild(modal);
        
        // Handle form submission
        document.getElementById('preference-form').addEventListener('submit', (e) => {
            e.preventDefault();
            const formData = new FormData(e.target);
            const preferences = {
                categories: Array.from(formData.getAll('categories')).map(Number),
                travelStyle: formData.get('travelStyle'),
                groupSize: parseInt(formData.get('groupSize'))
            };
            
            this.saveUserPreferences(preferences);
            modal.remove();
            this.updateRecommendationsUI();
        });
    }

    // Generate category checkboxes
    generateCategoryCheckboxes() {
        return state.categories.map(category => `
            <label class="checkbox-label">
                <input type="checkbox" name="categories" value="${category.id}">
                <span>${category.name_ku}</span>
            </label>
        `).join('');
    }
}

// Initialize AI Recommendations
let aiRecommendations;

// Export for global use
window.AIRecommendations = AIRecommendations;
window.initAIRecommendations = function() {
    aiRecommendations = new AIRecommendations();
    
    // Track user interactions
    if (typeof trackUserInteraction === 'function') {
        trackUserInteraction('ai_recommendations_loaded');
    }
    
    return aiRecommendations;
};

window.getRecommendations = async function(locationId, count) {
    if (!aiRecommendations) {
        aiRecommendations = new AIRecommendations();
    }
    return await aiRecommendations.getRecommendations(locationId, count);
};

window.trackUserBehavior = function(action, data) {
    if (aiRecommendations) {
        aiRecommendations.trackBehavior(action, data);
    }
};
