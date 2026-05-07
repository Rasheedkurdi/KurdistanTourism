<?php
require_once __DIR__ . '/../config/admin_auth.php';
$auth = new AdminAuth();
$admin = $auth->requireLogin();
?>
<!DOCTYPE html>
<html lang="en" dir="ltr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TourismHub | Admin Portal</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:opsz,wght@14..32,300;14..32,400;14..32,500;14..32,600;14..32,700;14..32,800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css">
    <link rel="stylesheet" href="../assets/css/style2.css?v=28.0">
</head>
<body>
<div class="admin-container">
    <!-- SIDEBAR redesigned modern -->
    <aside class="admin-sidebar">
        <div class="admin-logo">
            <h2><i class="fas fa-compass"></i> TourismHub</h2>
            <p><?php echo htmlspecialchars($admin['name'], ENT_QUOTES, 'UTF-8'); ?> · <?php echo htmlspecialchars($admin['role'], ENT_QUOTES, 'UTF-8'); ?></p>
        </div>
        <nav class="admin-nav">
            <ul>
                <li><a href="#dashboard" class="active" data-tab="dashboard"><i class="fas fa-chart-line"></i> Dashboard</a></li>
                <li><a href="#locations" data-tab="locations"><i class="fas fa-map-marker-alt"></i> Locations</a></li>
                <li><a href="#governments" data-tab="governments"><i class="fas fa-building"></i> Governments</a></li>
                <li><a href="#categories" data-tab="categories"><i class="fas fa-tags"></i> Categories</a></li>
                <li><a href="#feedback" data-tab="feedback"><i class="fas fa-comment-dots"></i> Feedback</a></li>
                <li><a href="#suggestions" data-tab="suggestions"><i class="fas fa-lightbulb"></i> User Suggestions <span id="sidebar-suggestion-count" style="background:#f39c12; color:white; padding:2px 6px; border-radius:10px; font-size:12px; margin-right:5px; display:none;">0</span></a></li>
                <li><a href="#contact-messages" data-tab="contact-messages"><i class="fas fa-envelope"></i> Contact Messages <span id="sidebar-contact-count" style="background:#e74c3c; color:white; padding:2px 6px; border-radius:10px; font-size:12px; margin-right:5px; display:none;">0</span></a></li>
                <li><a href="#visitors" data-tab="visitors"><i class="fas fa-users"></i> Visitors</a></li>
                <li><a href="#users" data-tab="users"><i class="fas fa-user-circle"></i> Users</a></li>
                <?php if ($admin['role'] === 'super_admin'): ?>
                <li><a href="#admins" data-tab="admins"><i class="fas fa-user-shield"></i> Admins</a></li>
                <?php endif; ?>
                <li><a href="#settings" data-tab="settings"><i class="fas fa-sliders-h"></i> Settings</a></li>
            </ul>
        </nav>
        <button class="logout-btn" onclick="window.location.href='admin_logout.php'"><i class="fas fa-sign-out-alt"></i> Logout</button>
    </aside>

    <main class="admin-main">
        <div class="admin-header">
            <h1 id="current-tab">Dashboard</h1>
            <div id="current-date"></div>
        </div>

        <!-- DASHBOARD SECTION -->
        <section id="dashboard" class="tab-content active">
            <div class="admin-stats">
                <div class="stat-card"><div class="stat-info"><h3>Total Locations</h3><div class="stat-number" id="total-locations">0</div></div><div class="stat-icon"><i class="fas fa-location-dot"></i></div></div>
                <div class="stat-card"><div class="stat-info"><h3>Today Visitors</h3><div class="stat-number" id="today-visitors">0</div></div><div class="stat-icon"><i class="fas fa-calendar-day"></i></div></div>
                <div class="stat-card"><div class="stat-info"><h3>Pending Feedback</h3><div class="stat-number" id="new-feedback">0</div></div><div class="stat-icon"><i class="fas fa-clock"></i></div></div>
                <div class="stat-card"><div class="stat-info"><h3>Avg Rating ⭐</h3><div class="stat-number" id="avg-rating">0.0</div></div><div class="stat-icon"><i class="fas fa-star"></i></div></div>
            </div>
            <div class="panel">
                <h2><i class="fas fa-history"></i> Recent Activities</h2>
                <div class="table-wrap">
                    <table class="admin-table">
                        <thead><tr><th>Location</th><th>Updated At</th><th>Type</th></tr></thead>
                        <tbody id="recent-activities"><tr><td colspan="3">Loading...</td></tr></tbody>
                    </table>
                </div>
            </div>
        </section>

        <!-- LOCATIONS SECTION (all fields preserved) -->
        <section id="locations" class="tab-content">
            <div class="panel">
                <div class="toolbar"><button class="btn btn-success" onclick="AdminUI.startCreateLocation()"><i class="fas fa-plus"></i> Add Location</button><button class="btn btn-secondary" onclick="AdminUI.reloadLocations()"><i class="fas fa-sync-alt"></i> Refresh</button><button class="btn btn-info" onclick="AdminUI.exportLocationsCSV()"><i class="fas fa-file-export"></i> Export CSV</button></div>
                <div class="help">Complete location details, coordinates, and images.</div>
                <form id="location-form" enctype="multipart/form-data">
                    <input type="hidden" name="id" id="location-id">
                    <input type="hidden" name="suggestion_id" id="suggestion-id-field" value="">
                    <div class="grid-two">
                        <div class="form-group"><label>Name (KU)</label><input class="form-control" name="name_ku" id="location-name-ku" required></div>
                        <div class="form-group"><label>Name (EN)</label><input class="form-control" name="name_en" id="location-name-en" required></div>
                        <div class="form-group"><label>Name (AR)</label><input class="form-control" name="name_ar" id="location-name-ar" required></div>
                        <div class="form-group"><label>Government</label><select class="form-control" name="government_id" id="location-government" required></select></div>
                        <div class="form-group"><label>Category</label><select class="form-control" name="category_id" id="location-category" required></select></div>
                        <div class="form-group"><label>Status</label><select class="form-control" name="status" id="location-status"><option value="published">Published</option><option value="draft">Draft</option></select></div>
                        <div class="form-group"><label>Latitude</label><input class="form-control" type="number" step="any" name="lat" id="location-lat" required></div>
                        <div class="form-group"><label>Longitude</label><input class="form-control" type="number" step="any" name="lng" id="location-lng" required></div>
                        <div class="form-group"><label>Phone</label><input class="form-control" name="phone" id="location-phone"></div>
                        <div class="form-group"><label>Email</label><input class="form-control" name="email" id="location-email"></div>
                        <div class="form-group"><label>Website</label><input class="form-control" name="website" id="location-website"></div>
                        <div class="form-group"><label>Google Maps Link</label><input class="form-control" name="directions_url" id="location-directions-url" placeholder="https://maps.google.com/..."></div>
                        <div class="form-group"><label>Address</label><input class="form-control" name="address" id="location-address"></div>
                        <div class="form-group"><label>Opening Hours</label><input class="form-control" name="opening_hours" id="location-opening-hours"></div>
                        <div class="form-group"><label>Ticket Price</label><input class="form-control" name="ticket_price" id="location-ticket-price"></div>
                        <div class="form-group"><label>Featured</label><select class="form-control" name="featured" id="location-featured"><option value="0">No</option><option value="1">Yes</option></select></div>
                    </div>
                    <div class="form-group"><label>Description (KU)</label><textarea class="form-control" name="description_ku" id="location-description-ku" rows="3"></textarea></div>
                    <div class="form-group"><label>Description (EN)</label><textarea class="form-control" name="description_en" id="location-description-en" rows="3"></textarea></div>
                    <div class="form-group"><label>Description (AR)</label><textarea class="form-control" name="description_ar" id="location-description-ar" rows="3"></textarea></div>
                    <div class="form-group"><label>Pick Location On Map</label><div id="location-picker-map" class="picker-map"></div></div>
                    <div class="form-group"><label>Images</label><input class="form-control" type="file" name="images[]" id="location-images" multiple accept="image/*"><label style="margin-top:10px;"><input type="checkbox" name="replace_images" id="replace-images" value="1"> Replace existing images</label><div id="image-preview" class="thumb-list"></div></div>
                    <div class="form-actions"><button type="button" class="btn btn-secondary" onclick="AdminUI.resetLocationForm()">Clear</button><button type="submit" class="btn btn-success">Save Location</button></div>
                </form>
            </div>
            <div class="panel"><h2><i class="fas fa-list"></i> Locations List</h2><div class="table-wrap"><table class="admin-table"><thead><tr><th>Photo</th><th>Name</th><th>Government</th><th>Category</th><th>Status</th><th>Visits</th><th>Rating</th><th>Actions</th></tr></thead><tbody id="locations-table"></tbody></table></div></div>
        </section>

        <!-- GOVERNMENTS -->
        <section id="governments" class="tab-content">
            <div class="panel"><h2><i class="fas fa-building"></i> Government Form</h2><form id="government-form"><input type="hidden" name="id" id="government-id"><div class="grid-two"><div class="form-group"><label>Name (KU)</label><input class="form-control" name="name_ku" id="government-name-ku" required></div><div class="form-group"><label>Name (EN)</label><input class="form-control" name="name_en" id="government-name-en" required></div><div class="form-group"><label>Name (AR)</label><input class="form-control" name="name_ar" id="government-name-ar" required></div><div class="form-group"><label>Color</label><input class="form-control" name="color" id="government-color" value="#3498db"></div><div class="form-group"><label>Latitude</label><input class="form-control" type="number" step="any" name="lat" id="government-lat"></div><div class="form-group"><label>Longitude</label><input class="form-control" type="number" step="any" name="lng" id="government-lng"></div><div class="form-group"><label>Zoom Level</label><input class="form-control" name="zoom_level" id="government-zoom" value="10"></div></div><div class="form-actions"><button type="button" class="btn btn-secondary" onclick="AdminUI.resetGovernmentForm()">Clear</button><button type="submit" class="btn btn-success">Save Government</button></div></form></div>
            <div class="panel"><h2>Governments</h2><div class="table-wrap"><table class="admin-table"><thead><tr><th>Name</th><th>Locations</th><th>Color</th><th>Actions</th></tr></thead><tbody id="governments-table"></tbody></table></div></div>
        </section>

        <!-- CATEGORIES -->
        <section id="categories" class="tab-content">
            <div class="panel"><h2><i class="fas fa-tags"></i> Category Form</h2><form id="category-form"><input type="hidden" name="id" id="category-id"><div class="grid-two"><div class="form-group"><label>Name (KU)</label><input class="form-control" name="name_ku" id="category-name-ku" required></div><div class="form-group"><label>Name (EN)</label><input class="form-control" name="name_en" id="category-name-en" required></div><div class="form-group"><label>Name (AR)</label><input class="form-control" name="name_ar" id="category-name-ar" required></div><div class="form-group"><label>Icon</label><div class="icon-input-wrapper"><input class="form-control" name="icon" id="category-icon" placeholder="landmark"><div class="icon-preview" id="icon-preview"><i class="fas fa-question"></i></div></div><div class="icon-picker" id="icon-picker">
                <div class="icon-option" data-icon="landmark"><i class="fas fa-landmark"></i><span>Landmark</span></div>
                <div class="icon-option" data-icon="mountain"><i class="fas fa-mountain"></i><span>Mountain</span></div>
                <div class="icon-option" data-icon="hotel"><i class="fas fa-hotel"></i><span>Hotel</span></div>
                <div class="icon-option" data-icon="utensils"><i class="fas fa-utensils"></i><span>Restaurant</span></div>
                <div class="icon-option" data-icon="tree"><i class="fas fa-tree"></i><span>Park</span></div>
                <div class="icon-option" data-icon="map-marker-alt"><i class="fas fa-map-marker-alt"></i><span>Marker</span></div>
                <div class="icon-option" data-icon="water"><i class="fas fa-water"></i><span>Water</span></div>
                <div class="icon-option" data-icon="monument"><i class="fas fa-monument"></i><span>Monument</span></div>
                <div class="icon-option" data-icon="camera"><i class="fas fa-camera"></i><span>Camera</span></div>
                <div class="icon-option" data-icon="hiking"><i class="fas fa-hiking"></i><span>Hiking</span></div>
                <div class="icon-option" data-icon="umbrella-beach"><i class="fas fa-umbrella-beach"></i><span>Beach</span></div>
                <div class="icon-option" data-icon="church"><i class="fas fa-church"></i><span>Church</span></div>
                <div class="icon-option" data-icon="mosque"><i class="fas fa-mosque"></i><span>Mosque</span></div>
                <div class="icon-option" data-icon="theater-masks"><i class="fas fa-theater-masks"></i><span>Theater</span></div>
                <div class="icon-option" data-icon="shopping-cart"><i class="fas fa-shopping-cart"></i><span>Shopping</span></div>
                <div class="icon-option" data-icon="car"><i class="fas fa-car"></i><span>Car</span></div>
                <div class="icon-option" data-icon="bus"><i class="fas fa-bus"></i><span>Bus</span></div>
                <div class="icon-option" data-icon="train"><i class="fas fa-train"></i><span>Train</span></div>
                <div class="icon-option" data-icon="plane"><i class="fas fa-plane"></i><span>Airport</span></div>
                <div class="icon-option" data-icon="hospital"><i class="fas fa-hospital"></i><span>Hospital</span></div>
                <div class="icon-option" data-icon="university"><i class="fas fa-university"></i><span>University</span></div>
                <div class="icon-option" data-icon="castle"><i class="fas fa-castle"></i><span>Castle</span></div>
                <div class="icon-option" data-icon="campground"><i class="fas fa-campground"></i><span>Camping</span></div>
                <div class="icon-option" data-icon="fire"><i class="fas fa-fire"></i><span>Fire</span></div>
                <div class="icon-option" data-icon="star"><i class="fas fa-star"></i><span>Star</span></div>
                <div class="icon-option" data-icon="heart"><i class="fas fa-heart"></i><span>Heart</span></div>
                <div class="icon-option" data-icon="flag"><i class="fas fa-flag"></i><span>Flag</span></div>
                <div class="icon-option" data-icon="gem"><i class="fas fa-gem"></i><span>Gem</span></div>
                <div class="icon-option" data-icon="crown"><i class="fas fa-crown"></i><span>Crown</span></div>
                <div class="icon-option" data-icon="building"><i class="fas fa-building"></i><span>Building</span></div>
            </div><small class="help-text">Click an icon to select it</small></div></div><div class="form-actions"><button type="button" class="btn btn-secondary" onclick="AdminUI.resetCategoryForm()">Clear</button><button type="submit" class="btn btn-success">Save Category</button></div></form></div>
            <div class="panel"><h2>Categories</h2><div class="table-wrap"><table class="admin-table"><thead><tr><th>Name</th><th>Locations</th><th>Icon</th><th>Actions</th></tr></thead><tbody id="categories-table"></tbody></table></div></div>
        </section>

        <!-- FEEDBACK -->
        <section id="feedback" class="tab-content">
            <div class="toolbar"><button class="btn btn-primary" data-feedback-tab="pending">Pending</button><button class="btn btn-secondary" data-feedback-tab="approved">Approved</button><button class="btn btn-secondary" data-feedback-tab="rejected">Rejected</button><button class="btn btn-secondary" data-feedback-tab="all">All</button></div>
            <div class="panel"><div class="table-wrap"><table class="admin-table"><thead><tr><th>Location</th><th>Visitor</th><th>Rating</th><th>Comment</th><th>Status</th><th>Date</th><th>Actions</th></tr></thead><tbody id="feedback-table"></tbody></table></div></div>
        </section>

        <!-- CONTACT MESSAGES -->
        <section id="contact-messages" class="tab-content">
            <div class="toolbar">
                <button class="btn btn-primary" data-contact-tab="unread">Unread <span id="contact-unread-count"></span></button>
                <button class="btn btn-secondary" data-contact-tab="read">Read <span id="contact-read-count"></span></button>
                <button class="btn btn-secondary" data-contact-tab="replied">Replied <span id="contact-replied-count"></span></button>
                <button class="btn btn-secondary" data-contact-tab="all">All <span id="contact-all-count"></span></button>
            </div>
            <div class="panel">
                <div class="table-wrap">
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Subject</th>
                                <th>Message</th>
                                <th>Status</th>
                                <th>Date</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody id="contact-messages-table"></tbody>
                    </table>
                </div>
            </div>
            <!-- Contact Message Detail Modal -->
            <div id="contact-detail-modal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.7); z-index:1000; align-items:center; justify-content:center;">
                <div style="background:white; color:#333; padding:30px; border-radius:10px; max-width:600px; width:90%; max-height:80vh; overflow-y:auto;">
                    <h3 id="contact-detail-subject" style="margin-bottom:15px;"></h3>
                    <p><strong>From:</strong> <span id="contact-detail-name"></span> (<span id="contact-detail-email"></span>)</p>
                    <p><strong>Phone:</strong> <span id="contact-detail-phone"></span></p>
                    <p><strong>Date:</strong> <span id="contact-detail-date"></span></p>
                    <hr style="margin:15px 0;">
                    <p id="contact-detail-message" style="white-space:pre-wrap;"></p>
                    <hr style="margin:15px 0;">
                    <div id="contact-reply-section">
                        <h4>Admin Reply</h4>
                        <textarea id="contact-reply-text" rows="4" style="width:100%; padding:10px; border:1px solid #ddd; border-radius:5px; margin-bottom:10px;" placeholder="Type your reply here..."></textarea>
                        <button onclick="submitContactReply()" class="btn btn-success">Send Reply</button>
                    </div>
                    <div id="contact-existing-reply" style="display:none; margin-top:15px; padding:10px; background:#f0f0f0; border-radius:5px;">
                        <strong>Your Reply:</strong>
                        <p id="contact-reply-content"></p>
                        <small id="contact-reply-date"></small>
                    </div>
                    <button onclick="closeContactModal()" style="margin-top:15px; padding:8px 15px; background:#e74c3c; color:white; border:none; border-radius:5px; cursor:pointer;">Close</button>
                </div>
            </div>
        </section>

        <!-- SUGGESTIONS -->
        <section id="suggestions" class="tab-content">
            <div class="panel">
                <h2><i class="fas fa-lightbulb"></i> User Location Suggestions</h2>
                <div class="toolbar">
                    <button class="btn btn-secondary" onclick="AdminUI.loadSuggestions('pending')"><i class="fas fa-clock"></i> Pending</button>
                    <button class="btn btn-success" onclick="AdminUI.loadSuggestions('approved')"><i class="fas fa-check"></i> Approved</button>
                    <button class="btn btn-danger" onclick="AdminUI.loadSuggestions('rejected')"><i class="fas fa-times"></i> Rejected</button>
                </div>
                <div class="table-wrap">
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th>Image</th>
                                <th>Location Name</th>
                                <th>User</th>
                                <th>Coordinates</th>
                                <th>Status</th>
                                <th>Submitted</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody id="suggestions-table">
                            <tr><td colspan="7" style="text-align:center; padding:20px;">Click a filter button above to load suggestions</td></tr>
                        </tbody>
                    </table>
                </div>
            </div>
            
            <!-- Suggestion Detail Modal -->
            <div id="suggestion-detail-modal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.8); z-index:1000; align-items:center; justify-content:center;">
                <div style="background:white; color:#333; padding:30px; border-radius:12px; max-width:860px; width:95%; max-height:92vh; overflow-y:auto; box-shadow:0 20px 60px rgba(0,0,0,0.4);">
                    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:20px;">
                        <h3 id="suggestion-detail-title">Suggestion Details</h3>
                        <button onclick="document.getElementById('suggestion-detail-modal').style.display='none'" style="background:none; border:none; font-size:1.5rem; cursor:pointer;">&times;</button>
                    </div>
                    <div id="suggestion-detail-image" style="margin-bottom:15px; text-align:center;"></div>
                    <div id="suggestion-detail-content"></div>
                    <hr style="margin:20px 0;">
                    <div id="suggestion-actions" style="display:flex; gap:10px;">
                        <button onclick="AdminUI.approveSuggestion(AdminUI.currentSuggestionId)" class="btn btn-success"><i class="fas fa-check"></i> Approve & Add to Map</button>
                        <button onclick="AdminUI.rejectSuggestion(AdminUI.currentSuggestionId)" class="btn btn-danger"><i class="fas fa-times"></i> Reject</button>
                    </div>
                </div>
            </div>
        </section>

        <!-- VISITORS -->
        <section id="visitors" class="tab-content">
            <div class="panel"><h2><i class="fas fa-chart-simple"></i> Visitor Analytics</h2><div class="table-wrap"><table class="admin-table"><thead><tr><th>IP</th><th>Visits</th><th>Last Visit</th><th>User Agent</th></tr></thead><tbody id="visitors-table"></tbody></table></div></div>
        </section>

        <!-- USERS -->
        <section id="users" class="tab-content">
            <div class="panel"><h2><i class="fas fa-user-circle"></i> Registered Users</h2><div class="table-wrap"><table class="admin-table"><thead><tr><th>Name</th><th>Email</th><th>Verified</th><th>Registered</th></tr></thead><tbody id="users-table"></tbody></table></div></div>
        </section>

        <?php if ($admin['role'] === 'super_admin'): ?>
        <section id="admins" class="tab-content">
            <div class="panel"><h2><i class="fas fa-user-cog"></i> Admin Management</h2><form id="admin-form"><input type="hidden" name="id" id="admin-id"><div class="grid-two"><div class="form-group"><label>Full Name</label><input class="form-control" name="full_name" id="admin-full-name" required></div><div class="form-group"><label>Username</label><input class="form-control" name="username" id="admin-username" required></div><div class="form-group"><label>Email</label><input class="form-control" name="email" id="admin-email"></div><div class="form-group"><label>Password</label><input class="form-control" name="password" id="admin-password" type="password"></div><div class="form-group"><label>Role</label><select class="form-control" name="role" id="admin-role"><option value="admin">Admin</option><option value="super_admin">Super Admin</option></select></div><div class="form-group"><label>Active</label><select class="form-control" name="active" id="admin-active"><option value="1">Yes</option><option value="0">No</option></select></div></div><div class="form-actions"><button type="button" class="btn btn-secondary" onclick="AdminUI.resetAdminForm()">Clear</button><button type="submit" class="btn btn-success">Save Admin</button></div></form></div>
            <div class="panel"><h2>System Admins</h2><div class="table-wrap"><table class="admin-table"><thead><tr><th>Name</th><th>Username</th><th>Email</th><th>Role</th><th>Last Login</th><th>Status</th><th>Actions</th></tr></thead><tbody id="admins-table"></tbody></table></div></div>
        </section>
        <?php endif; ?>

        <!-- SETTINGS -->
        <section id="settings" class="tab-content">
            <div class="panel"><h2><i class="fas fa-sliders-h"></i> General Settings</h2><form id="settings-form"><div class="grid-two"><div class="form-group"><label>Allow Registration</label><select class="form-control" name="allow_registration" id="allow-registration"><option value="1">Yes</option><option value="0">No</option></select></div><div class="form-group"><label>Allow Feedback</label><select class="form-control" name="allow_feedback" id="allow-feedback"><option value="1">Yes</option><option value="0">No</option></select></div><div class="form-group"><label>Feedback Moderation</label><select class="form-control" name="feedback_moderation" id="feedback-moderation"><option value="1">Yes</option><option value="0">No</option></select></div><div class="form-group"><label>Email Notifications</label><select class="form-control" name="email_notifications" id="email-notifications"><option value="1">Yes</option><option value="0">No</option></select></div><div class="form-group"><label>Default Language</label><select class="form-control" name="default_language" id="default-language"><option value="ku">Kurdish</option><option value="en">English</option><option value="ar">Arabic</option></select></div><div class="form-group"><label>Locations Per Page</label><input class="form-control" name="locations_per_page" id="locations-per-page" value="12"></div></div><div class="form-actions"><button class="btn btn-success" type="submit">Save Settings</button></div></form></div>
        </section>
    </main>
</div>

<script>window.ADMIN_ROLE = <?php echo json_encode($admin['role']); ?>;</script>
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<script src="../assets/js/script2.js"></script>
<script>
    // Contact Messages Global Functions
    let currentContactId = null;
    
    function closeContactModal() {
        document.getElementById('contact-detail-modal').style.display = 'none';
        // Refresh the list to update read status
        if (AdminUI && AdminUI.loadContactMessages) {
            AdminUI.loadContactMessages(AdminUI.currentContactTab || 'unread');
        }
    }
    
    async function submitContactReply() {
        const replyText = document.getElementById('contact-reply-text').value.trim();
        if (!replyText) {
            alert('Please enter a reply message');
            return;
        }
        
        if (!currentContactId && AdminUI) {
            currentContactId = AdminUI.currentContactId;
        }
        
        if (!currentContactId) {
            alert('Error: No message selected');
            return;
        }
        
        try {
            const response = await fetch('../api.php?endpoint=contact_reply', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ id: currentContactId, reply: replyText })
            });
            
            const result = await response.json();
            
            if (result.success) {
                alert('Reply saved successfully');
                // Update UI to show the reply
                document.getElementById('contact-reply-section').style.display = 'none';
                document.getElementById('contact-existing-reply').style.display = 'block';
                document.getElementById('contact-reply-content').textContent = replyText;
                document.getElementById('contact-reply-date').textContent = 'Replied: ' + new Date().toLocaleString();
                
                // Refresh the list
                if (AdminUI && AdminUI.loadContactMessages) {
                    AdminUI.loadContactMessages(AdminUI.currentContactTab || 'unread');
                }
            } else {
                alert(result.error || 'Error saving reply');
            }
        } catch (err) {
            alert('Network error: ' + err.message);
        }
    }
    
    // Set up contact tab click handlers
    document.addEventListener('DOMContentLoaded', function() {
        // Contact tab buttons
        document.querySelectorAll('[data-contact-tab]').forEach(btn => {
            btn.addEventListener('click', function() {
                const status = this.dataset.contactTab;
                
                // Update active button
                document.querySelectorAll('[data-contact-tab]').forEach(b => b.classList.remove('btn-primary'));
                document.querySelectorAll('[data-contact-tab]').forEach(b => b.classList.add('btn-secondary'));
                this.classList.remove('btn-secondary');
                this.classList.add('btn-primary');
                
                // Load messages
                if (AdminUI && AdminUI.loadContactMessages) {
                    AdminUI.loadContactMessages(status);
                }
            });
        });
        
        // Load contact messages when tab is shown
        const contactTabLink = document.querySelector('a[data-tab="contact-messages"]');
        if (contactTabLink) {
            contactTabLink.addEventListener('click', function() {
                if (AdminUI && AdminUI.loadContactMessages) {
                    AdminUI.loadContactMessages('unread');
                }
            });
        }
    });
</script>
</body>
</html>