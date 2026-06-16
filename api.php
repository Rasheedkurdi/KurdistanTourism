<?php
require_once __DIR__ . '/config/bootstrap.php';

configure_cors();
header('Access-Control-Allow-Methods: GET, POST, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, X-CSRF-Token');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    exit();
}

reject_cross_origin_state_change();

$endpoint = $_GET['endpoint'] ?? '';
$method = $_SERVER['REQUEST_METHOD'];

try {
    switch ($endpoint) {
        
        case 'bootstrap':
            public_bootstrap();
            break;
        case 'locations':
            if ($method === 'GET') {
                public_locations();
            } elseif ($method === 'POST') {
                admin_save_location();
            }
            break;
        case 'location':
            public_location();
            break;
        case 'governments':
            if ($method === 'GET') {
                public_governments();
            } elseif ($method === 'POST') {
                admin_save_government();
            }
            break;
        case 'categories':
            if ($method === 'GET') {
                public_categories();
            } elseif ($method === 'POST') {
                admin_save_category();
            }
            break;
        case 'feedback':
            if ($method === 'GET') {
                admin_feedback();
            } elseif ($method === 'POST') {
                public_feedback();
            }
            break;
        case 'user_current':
            public_user_current();
            break;
        case 'user_register':
            public_user_register();
            break;
        case 'user_login':
            public_user_login();
            break;
        case 'user_logout':
            public_user_logout();
            break;
        case 'user_verify':
            public_user_verify();
            break;
        case 'reviews':
            if ($method === 'GET') {
                public_reviews();
            } elseif ($method === 'POST') {
                public_add_review();
            }
            break;
        case 'photos':
            if ($method === 'GET') {
                public_photos();
            } elseif ($method === 'POST') {
                public_upload_photo();
            }
            break;
        case 'businesses':
            public_businesses();
            break;
        case 'events':
            public_events();
            break;
        case 'itineraries':
            if ($method === 'GET') {
                public_itineraries();
            } elseif ($method === 'POST') {
                public_save_itinerary();
            } elseif ($method === 'DELETE') {
                public_delete_itinerary();
            }
            break;
        case 'weather':
            public_weather();
            break;
        case 'feedback_moderation':
            admin_feedback_moderation();
            break;
        case 'visits':
            public_visit();
            break;
        case 'favorites':
            if ($method === 'GET') {
                public_user_favorites();
            } elseif ($method === 'POST') {
                public_toggle_favorite();
            }
            break;
        case 'suggest_location':
            if ($method === 'GET') {
                admin_suggestions();
            } elseif ($method === 'POST') {
                public_suggest_location();
            }
            break;
        case 'review_suggestion':
            admin_review_suggestion();
            break;
        case 'user_suggestions':
            public_user_suggestions();
            break;
        case 'my_visits':
            public_my_visits();
            break;
        case 'cleanup_expired':
            cleanup_expired_accounts();
            break;
        case 'contact':
            if ($method === 'GET') {
                admin_contact_messages();
            } elseif ($method === 'POST') {
                $data = request_data();
                // Check if this is a status update (has id and status) or new message
                if (isset($data['id']) && isset($data['status'])) {
                    admin_contact_update();
                } else {
                    public_contact_submit();
                }
            } elseif ($method === 'DELETE') {
                admin_contact_delete();
            }
            break;
        case 'contact_reply':
            admin_contact_reply();
            break;
        case 'dashboard':
            admin_dashboard();
            break;
        case 'public_profile':
            public_user_profile();
            break;
        case 'user_profile':
            if ($method === 'GET') {
                user_profile();
            } elseif ($method === 'POST') {
                user_edit_profile();
            } elseif ($method === 'DELETE') {
                user_delete_profile();
            }
            break;
        case 'admin_locations':
            admin_locations();
            break;
        case 'admin_location':
            admin_location();
            break;
        case 'export_locations_csv':
            admin_export_locations_csv();
            break;
        case 'admin_visitors':
            admin_visitors();
            break;
        case 'admin_users':
            admin_users();
            break;
        case 'admins':
            if ($method === 'GET') {
                admin_admins();
            } elseif ($method === 'POST') {
                admin_save_admin();
            }
            break;
        case 'delete_location':
            admin_delete_location();
            break;
        case 'delete_government':
            admin_delete_government();
            break;
        case 'delete_category':
            admin_delete_category();
            break;
        case 'delete_admin':
            admin_delete_admin();
            break;
        case 'settings':
            if ($method === 'GET') {
                admin_settings();
            } elseif ($method === 'POST') {
                admin_save_settings();
            }
            break;
        default:
            json_response(['error' => 'Endpoint not found'], 404);
    }
} catch (Throwable $exception) {
    error_log('API error: ' . $exception->getMessage());
    json_response(['error' => 'Server error: ' . $exception->getMessage()], 500);
}

function public_bootstrap(): void
{
    json_response([
        'governments' => fetch_governments(),
        'categories' => fetch_categories(),
        'settings' => fetch_settings()
    ]);
}

function public_governments(): void
{
    json_response(['governments' => fetch_governments()]);
}

function public_categories(): void
{
    json_response(['categories' => fetch_categories()]);
}

function public_locations(): void
{
    $pdo = pdo();
    $params = [];
    $conditions = ["l.status = 'published'"];

    if (!empty($_GET['government_id'])) {
        $conditions[] = 'l.government_id = ?';
        $params[] = (int) $_GET['government_id'];
    }

    if (!empty($_GET['category_id'])) {
        $conditions[] = 'l.category_id = ?';
        $params[] = (int) $_GET['category_id'];
    }

    if (!empty($_GET['search'])) {
        $search = '%' . trim($_GET['search']) . '%';
        $conditions[] = '(l.name_ku LIKE ? OR l.name_en LIKE ? OR l.name_ar LIKE ? OR l.description_ku LIKE ? OR l.description_en LIKE ? OR l.description_ar LIKE ?)';
        $params[] = $search;
        $params[] = $search;
        $params[] = $search;
        $params[] = $search;
        $params[] = $search;
        $params[] = $search;
    }

    if (!empty($_GET['ids'])) {
        $ids = explode(',', $_GET['ids']);
        $ids = array_filter(array_map('intval', $ids));
        if (!empty($ids)) {
            $placeholders = str_repeat('?,', count($ids) - 1) . '?';
            $conditions[] = "l.id IN ($placeholders)";
            $params = array_merge($params, $ids);
        }
    }

    $sql = "SELECT
                l.*,
                g.name_ku AS gov_name_ku,
                g.name_en AS gov_name_en,
                g.name_ar AS gov_name_ar,
                g.color AS gov_color,
                c.name_ku AS cat_name_ku,
                c.name_en AS cat_name_en,
                c.name_ar AS cat_name_ar,
                c.icon AS category_icon,
                COALESCE(
                    l.image_path,
                    (
                        SELECT image_path
                        FROM location_images li
                        WHERE li.location_id = l.id
                        ORDER BY li.sort_order ASC, li.id ASC
                        LIMIT 1
                    )
                ) AS cover_image
            FROM locations l
            JOIN governments g ON g.id = l.government_id
            JOIN categories c ON c.id = l.category_id
            WHERE " . implode(' AND ', $conditions) . "
            ORDER BY l.featured DESC, l.created_at DESC";
    $stmt = $pdo->prepare($sql);
    $stmt->execute($params);

    json_response(['locations' => $stmt->fetchAll()]);
}

function public_location(): void
{
    $id = (int) ($_GET['id'] ?? 0);
    if ($id <= 0) {
        json_response(['error' => 'Invalid location'], 422);
    }

    $pdo = pdo();
    $stmt = $pdo->prepare(
        "SELECT
            l.*,
            g.name_ku AS gov_name_ku,
            g.name_en AS gov_name_en,
            g.name_ar AS gov_name_ar,
            g.color AS gov_color,
            c.name_ku AS cat_name_ku,
            c.name_en AS cat_name_en,
            c.name_ar AS cat_name_ar,
            c.icon AS category_icon,
            COALESCE(
                l.image_path,
                (
                    SELECT image_path
                    FROM location_images li
                    WHERE li.location_id = l.id
                    ORDER BY li.sort_order ASC, li.id ASC
                    LIMIT 1
                )
            ) AS cover_image
         FROM locations l
         JOIN governments g ON g.id = l.government_id
         JOIN categories c ON c.id = l.category_id
         WHERE l.id = ? AND l.status = 'published'
         LIMIT 1"
    );
    $stmt->execute([$id]);
    $location = $stmt->fetch();
    if (!$location) {
        json_response(['error' => 'Location not found'], 404);
    }

    $images = $pdo->prepare("SELECT id, image_path FROM location_images WHERE location_id = ? ORDER BY sort_order ASC, id ASC");
    $images->execute([$id]);
    $location['images'] = $images->fetchAll();

    $feedback = $pdo->prepare(
        "SELECT f.user_id, f.visitor_name, f.rating, f.comment, f.created_at, u.avatar, u.username
         FROM feedback f
         LEFT JOIN users u ON u.id = f.user_id
         WHERE f.location_id = ? AND f.status = 'approved'
         ORDER BY f.created_at DESC
         LIMIT 20"
    );
    $feedback->execute([$id]);
    $location['feedback'] = $feedback->fetchAll();

    // Include user-uploaded photos in the gallery
    $photos = $pdo->prepare("SELECT id, image_path, title FROM photos WHERE location_id = ? AND status = 'published' ORDER BY created_at DESC");
    $photos->execute([$id]);
    $userPhotos = $photos->fetchAll();
    
    // Merge both types of images for the visitor
    foreach($userPhotos as $up) {
        $location['images'][] = [
            'id' => 'u' . $up['id'],
            'image_path' => $up['image_path'],
            'is_user_upload' => true
        ];
    }

    json_response(['location' => $location]);
}

function public_feedback(): void
{
    $settings = fetch_settings();
    if (($settings['allow_feedback'] ?? '1') !== '1') {
        json_response(['error' => 'Feedback is disabled'], 403);
    }

    $data = request_data();
    $rating = (int) ($data['rating'] ?? 0);
    $locationId = (int) ($data['location_id'] ?? 0);
    
    $user = current_user();
    if (!$user) {
        json_response(['error' => 'You must be logged in to submit feedback'], 401);
    }
    
    $visitorName = $user['name'];
    $visitorEmail = $user['email'];
    $userId = $user['id'];

    if ($locationId <= 0 || $rating < 1 || $rating > 5 || empty(trim($data['comment'] ?? ''))) {
        json_response(['error' => 'Invalid feedback payload'], 422);
    }

    $status = ($settings['feedback_moderation'] ?? '1') === '1' ? 'pending' : 'approved';
    $stmt = pdo()->prepare(
        "INSERT INTO feedback (location_id, user_id, visitor_name, visitor_email, rating, comment, status)
         VALUES (?, ?, ?, ?, ?, ?, ?)"
    );
    $stmt->execute([
        $locationId,
        $userId,
        $visitorName,
        $visitorEmail,
        $rating,
        trim($data['comment']),
        $status
    ]);

    recalculate_location_rating($locationId);
    json_response(['success' => true, 'status' => $status]);
}

function public_visit(): void
{
    $data = request_data();
    $locationId = isset($data['location_id']) ? (int) $data['location_id'] : null;
    $user = current_user();
    $userId = $user ? $user['id'] : null;

    // Check if user already visited this location recently (within 24h)
    if ($userId && $locationId) {
        $recent = pdo()->prepare("SELECT id FROM location_visits WHERE location_id = ? AND user_id = ? AND visited_at > DATE_SUB(NOW(), INTERVAL 24 HOUR) LIMIT 1");
        $recent->execute([$locationId, $userId]);
        if ($recent->fetch()) {
            json_response(['success' => true, 'message' => 'Already visited recently']);
            return;
        }
    }

    $stmt = pdo()->prepare(
        "INSERT INTO location_visits (location_id, user_id, ip_address, user_agent)
         VALUES (?, ?, ?, ?)"
    );
    $stmt->execute([
        $locationId ?: null,
        $userId,
        $_SERVER['REMOTE_ADDR'] ?? '',
        substr($_SERVER['HTTP_USER_AGENT'] ?? '', 0, 255)
    ]);

    if ($locationId) {
        $update = pdo()->prepare("UPDATE locations SET total_visits = total_visits + 1 WHERE id = ?");
        $update->execute([$locationId]);
    }

    json_response(['success' => true]);
}

function admin_dashboard(): void
{
    require_admin();
    $pdo = pdo();

    $stats = [
        'total_locations' => (int) $pdo->query("SELECT COUNT(*) FROM locations")->fetchColumn(),
        'today_visitors' => (int) $pdo->query("SELECT COUNT(*) FROM location_visits WHERE DATE(visited_at) = CURDATE()")->fetchColumn(),
        'new_feedback' => (int) $pdo->query("SELECT COUNT(*) FROM feedback WHERE status = 'pending'")->fetchColumn(),
        'avg_rating' => (float) ($pdo->query("SELECT COALESCE(AVG(average_rating), 0) FROM locations")->fetchColumn() ?: 0),
    ];

    $recentStmt = $pdo->query(
        "SELECT l.name_ku AS location_name, l.updated_at AS happened_at, 'location' AS activity_type
         FROM locations l
         ORDER BY l.updated_at DESC
         LIMIT 5"
    );

    json_response([
        'stats' => $stats,
        'recent' => $recentStmt->fetchAll()
    ]);
}

function admin_locations(): void
{
    require_admin();
    $stmt = pdo()->query(
        "SELECT
            l.*,
            g.name_ku AS gov_name,
            c.name_ku AS cat_name,
            (SELECT image_path FROM location_images li WHERE li.location_id = l.id ORDER BY sort_order ASC LIMIT 1) as cover_image
         FROM locations l
         JOIN governments g ON g.id = l.government_id
         JOIN categories c ON c.id = l.category_id
         ORDER BY l.created_at DESC"
    );
    json_response(['locations' => $stmt->fetchAll()]);
}

function admin_location(): void
{
    require_admin();
    $id = (int) ($_GET['id'] ?? 0);
    if ($id <= 0) {
        json_response(['error' => 'Invalid location'], 422);
    }

    $pdo = pdo();
    $stmt = $pdo->prepare("SELECT * FROM locations WHERE id = ?");
    $stmt->execute([$id]);
    $location = $stmt->fetch();
    
    if (!$location) {
        json_response(['error' => 'Location not found'], 404);
    }

    $images = $pdo->prepare("SELECT id, image_path FROM location_images WHERE location_id = ? ORDER BY sort_order ASC, id ASC");
    $images->execute([$id]);
    $location['images'] = $images->fetchAll();

    json_response(['location' => $location]);
}

function admin_feedback(): void
{
    require_admin();
    $status = $_GET['status'] ?? 'all';
    $params = [];
    $where = '';
    if (in_array($status, ['pending', 'approved', 'rejected'], true)) {
        $where = 'WHERE f.status = ?';
        $params[] = $status;
    }

    $stmt = pdo()->prepare(
        "SELECT
            f.*,
            l.name_ku AS location_name
         FROM feedback f
         JOIN locations l ON l.id = f.location_id
         {$where}
         ORDER BY f.created_at DESC"
    );
    $stmt->execute($params);
    json_response(['feedback' => $stmt->fetchAll()]);
}

function admin_feedback_moderation(): void
{
    require_admin();
    $data = request_data();
    $id = (int) ($data['id'] ?? 0);
    if ($id <= 0) {
        json_response(['error' => 'Invalid feedback'], 422);
    }

    if (($data['action'] ?? '') === 'delete') {
        $locationId = feedback_location_id($id);
        $stmt = pdo()->prepare("DELETE FROM feedback WHERE id = ?");
        $stmt->execute([$id]);
        if ($locationId) {
            recalculate_location_rating($locationId);
        }
        json_response(['success' => true]);
    }

    $status = $data['status'] ?? '';
    if (!in_array($status, ['pending', 'approved', 'rejected'], true)) {
        json_response(['error' => 'Invalid status'], 422);
    }

    $stmt = pdo()->prepare("UPDATE feedback SET status = ? WHERE id = ?");
    $stmt->execute([$status, $id]);
    $locationId = feedback_location_id($id);
    if ($locationId) {
        recalculate_location_rating($locationId);
    }
    json_response(['success' => true]);
}

function admin_visitors(): void
{
    require_admin();
    $stmt = pdo()->query(
        "SELECT
            COALESCE(MAX(location_visits.id), 0) AS id,
            ip_address,
            COUNT(*) AS visits,
            MAX(visited_at) AS last_visit,
            MAX(user_agent) AS user_agent
         FROM location_visits
         GROUP BY ip_address
         ORDER BY last_visit DESC
         LIMIT 100"
    );
    json_response(['visitors' => $stmt->fetchAll()]);
}

function admin_users(): void
{
    require_admin();
    $stmt = pdo()->query(
        "SELECT id, full_name, email, is_verified, created_at
         FROM users
         ORDER BY created_at DESC"
    );
    json_response(['users' => $stmt->fetchAll()]);
}

function admin_admins(): void
{
    require_admin('super_admin');
    $stmt = pdo()->query(
        "SELECT id, full_name, username, email, role, active, created_at, last_login
         FROM admins
         ORDER BY created_at DESC"
    );
    json_response(['admins' => $stmt->fetchAll()]);
}

function admin_save_admin(): void
{
    require_admin('super_admin');
    $data = request_data();
    $id = (int) ($data['id'] ?? 0);
    $username = trim($data['username'] ?? '');
    $fullName = trim($data['full_name'] ?? '');
    $password = trim($data['password'] ?? '');
    $role = ($data['role'] ?? 'admin') === 'super_admin' ? 'super_admin' : 'admin';
    $email = trim($data['email'] ?? '');
    $active = !empty($data['active']) ? 1 : 0;

    if ($username === '' || $fullName === '') {
        json_response(['error' => 'Missing admin fields'], 422);
    }
    if ($password !== '' && strlen($password) < 12) {
        json_response(['error' => 'Admin password must be at least 12 characters'], 422);
    }

    if ($id > 0) {
        if ($password !== '') {
            $stmt = pdo()->prepare(
                "UPDATE admins SET username = ?, full_name = ?, email = ?, role = ?, active = ?, password_hash = ?
                 WHERE id = ?"
            );
            $stmt->execute([$username, $fullName, $email, $role, $active, password_hash($password, PASSWORD_DEFAULT), $id]);
        } else {
            $stmt = pdo()->prepare(
                "UPDATE admins SET username = ?, full_name = ?, email = ?, role = ?, active = ?
                 WHERE id = ?"
            );
            $stmt->execute([$username, $fullName, $email, $role, $active, $id]);
        }
    } else {
        if ($password === '') {
            json_response(['error' => 'Password is required'], 422);
        }
        $stmt = pdo()->prepare(
            "INSERT INTO admins (username, password_hash, full_name, email, role, active)
             VALUES (?, ?, ?, ?, ?, ?)"
        );
        $stmt->execute([$username, password_hash($password, PASSWORD_DEFAULT), $fullName, $email, $role, $active]);
    }

    json_response(['success' => true]);
}

function admin_save_location(): void
{
    $admin = require_admin();
    $data = $_POST;
    $id = (int) ($data['id'] ?? 0);

    $required = ['name_ku', 'name_en', 'name_ar', 'lat', 'lng', 'government_id', 'category_id'];
    foreach ($required as $field) {
        if (!isset($data[$field]) || trim((string) $data[$field]) === '') {
            json_response(['error' => "Missing field: {$field}"], 422);
        }
    }

    $lat = (float) $data['lat'];
    $lng = (float) $data['lng'];
    if (!is_valid_coordinate($lat, $lng)) {
        json_response(['error' => 'Invalid coordinates'], 422);
    }

    $payload = [
        trim($data['name_ku']),
        trim($data['name_en']),
        trim($data['name_ar']),
        trim($data['description_ku'] ?? ''),
        trim($data['description_en'] ?? ''),
        trim($data['description_ar'] ?? ''),
        $lat,
        $lng,
        (int) $data['government_id'],
        (int) $data['category_id'],
        trim($data['address'] ?? ''),
        trim($data['phone'] ?? ''),
        trim($data['email'] ?? ''),
        trim($data['website'] ?? ''),
        trim($data['directions_url'] ?? ''),
        trim($data['opening_hours'] ?? ''),
        trim($data['ticket_price'] ?? ''),
        !empty($data['featured']) ? 1 : 0,
        ($data['status'] ?? 'published') === 'draft' ? 'draft' : 'published'
    ];

    if ($id > 0) {
        $stmt = pdo()->prepare(
            "UPDATE locations SET
                name_ku = ?, name_en = ?, name_ar = ?,
                description_ku = ?, description_en = ?, description_ar = ?,
                lat = ?, lng = ?, government_id = ?, category_id = ?,
                address = ?, phone = ?, email = ?, website = ?, directions_url = ?,
                opening_hours = ?, ticket_price = ?, featured = ?, status = ?
             WHERE id = ?"
        );
        $stmt->execute(array_merge($payload, [$id]));

        if (!empty($_POST['replace_images'])) {
            delete_location_images($id);
        }
        save_uploaded_images($id, $_FILES['images'] ?? []);
    } else {
        $stmt = pdo()->prepare(
            "INSERT INTO locations (
                name_ku, name_en, name_ar,
                description_ku, description_en, description_ar,
                lat, lng, government_id, category_id,
                address, phone, email, website, directions_url, opening_hours, ticket_price,
                featured, status, created_by
             ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
        );
        $stmt->execute(array_merge($payload, [$admin['id']]));
        $id = (int) pdo()->lastInsertId();
        save_uploaded_images($id, $_FILES['images'] ?? []);

        // Auto-approve suggestion and MIGRATE IMAGE if this location was created from one
        $suggestionId = (int) ($data['suggestion_id'] ?? 0);
        if ($suggestionId > 0) {
            $pdo = pdo();
            // Check if suggestion has an image that needs to be moved to the location gallery
            $suggStmt = $pdo->prepare("SELECT image_path FROM location_suggestions WHERE id = ?");
            $suggStmt->execute([$suggestionId]);
            $suggImage = $suggStmt->fetchColumn();
            
            if ($suggImage) {
                // Insert into location_images so it shows in the visitor gallery
                $imgStmt = $pdo->prepare("INSERT INTO location_images (location_id, image_path, sort_order) VALUES (?, ?, 99)");
                $imgStmt->execute([$id, $suggImage]);
            }

            $stmt = $pdo->prepare("UPDATE location_suggestions SET status = 'approved', reviewed_at = NOW(), admin_note = 'Auto-approved: added to map' WHERE id = ?");
            $stmt->execute([$suggestionId]);
        }
    }

    json_response(['success' => true, 'id' => $id]);
}

function admin_delete_location(): void
{
    require_admin();
    $data = request_data();
    $id = (int) ($data['id'] ?? 0);
    if ($id <= 0) {
        json_response(['error' => 'Invalid location'], 422);
    }

    delete_location_images($id);
    $stmt = pdo()->prepare("DELETE FROM locations WHERE id = ?");
    $stmt->execute([$id]);
    json_response(['success' => true]);
}

function admin_save_government(): void
{
    require_admin();
    $data = request_data();
    $id = (int) ($data['id'] ?? 0);
    $lat = ($data['lat'] ?? '') === '' ? null : (float) $data['lat'];
    $lng = ($data['lng'] ?? '') === '' ? null : (float) $data['lng'];

    if (($lat !== null || $lng !== null) && !is_valid_coordinate($lat, $lng)) {
        json_response(['error' => 'Invalid government coordinates'], 422);
    }

    $values = [
        trim($data['name_ku'] ?? ''),
        trim($data['name_en'] ?? ''),
        trim($data['name_ar'] ?? ''),
        sanitize_hex_color(trim($data['color'] ?? '#3498db')),
        $lat,
        $lng,
        (int) ($data['zoom_level'] ?? 10)
    ];

    if ($values[0] === '' || $values[1] === '' || $values[2] === '') {
        json_response(['error' => 'Missing government fields'], 422);
    }

    if ($id > 0) {
        $stmt = pdo()->prepare(
            "UPDATE governments SET name_ku = ?, name_en = ?, name_ar = ?, color = ?, lat = ?, lng = ?, zoom_level = ?
             WHERE id = ?"
        );
        $stmt->execute(array_merge($values, [$id]));
    } else {
        $stmt = pdo()->prepare(
            "INSERT INTO governments (name_ku, name_en, name_ar, color, lat, lng, zoom_level)
             VALUES (?, ?, ?, ?, ?, ?, ?)"
        );
        $stmt->execute($values);
    }
    json_response(['success' => true]);
}

function admin_delete_government(): void
{
    require_admin();
    $id = (int) (request_data()['id'] ?? 0);
    if ($id <= 0) {
        json_response(['error' => 'Invalid government'], 422);
    }
    $stmt = pdo()->prepare("DELETE FROM governments WHERE id = ?");
    $stmt->execute([$id]);
    json_response(['success' => true]);
}

function admin_save_category(): void
{
    require_admin();
    $data = request_data();
    $id = (int) ($data['id'] ?? 0);
    $values = [
        trim($data['name_ku'] ?? ''),
        trim($data['name_en'] ?? ''),
        trim($data['name_ar'] ?? ''),
        sanitize_icon_name(trim($data['icon'] ?? 'map-marker-alt'))
    ];

    if ($values[0] === '' || $values[1] === '' || $values[2] === '') {
        json_response(['error' => 'Missing category fields'], 422);
    }

    if ($id > 0) {
        $stmt = pdo()->prepare(
            "UPDATE categories SET name_ku = ?, name_en = ?, name_ar = ?, icon = ? WHERE id = ?"
        );
        $stmt->execute(array_merge($values, [$id]));
    } else {
        $stmt = pdo()->prepare(
            "INSERT INTO categories (name_ku, name_en, name_ar, icon) VALUES (?, ?, ?, ?)"
        );
        $stmt->execute($values);
    }

    json_response(['success' => true]);
}

function admin_delete_category(): void
{
    require_admin();
    $id = (int) (request_data()['id'] ?? 0);
    if ($id <= 0) {
        json_response(['error' => 'Invalid category'], 422);
    }
    $stmt = pdo()->prepare("DELETE FROM categories WHERE id = ?");
    $stmt->execute([$id]);
    json_response(['success' => true]);
}

function admin_delete_admin(): void
{
    $admin = require_admin('super_admin');
    $id = (int) (request_data()['id'] ?? 0);
    if ($id <= 0 || $id === $admin['id']) {
        json_response(['error' => 'Cannot delete your own account'], 422);
    }
    $stmt = pdo()->prepare("DELETE FROM admins WHERE id = ?");
    $stmt->execute([$id]);
    json_response(['success' => true]);
}

function admin_settings(): void
{
    require_admin();
    json_response(['settings' => fetch_settings()]);
}

function admin_save_settings(): void
{
    require_admin();
    $data = request_data();
    $stmt = pdo()->prepare(
        "INSERT INTO settings (setting_key, setting_value) VALUES (?, ?)
         ON DUPLICATE KEY UPDATE setting_value = VALUES(setting_value)"
    );

    $allowed = [
        'allow_registration',
        'allow_feedback',
        'feedback_moderation',
        'email_notifications',
        'default_language',
        'locations_per_page'
    ];

    foreach ($allowed as $key) {
        if (array_key_exists($key, $data)) {
            $stmt->execute([$key, (string) $data[$key]]);
        }
    }

    json_response(['success' => true]);
}

function fetch_governments(): array
{
    $stmt = pdo()->query(
        "SELECT g.*,
                COUNT(l.id) AS location_count
         FROM governments g
         LEFT JOIN locations l ON l.government_id = g.id
         GROUP BY g.id
         ORDER BY g.name_ku ASC"
    );
    return $stmt->fetchAll();
}

function fetch_categories(): array
{
    $stmt = pdo()->query(
        "SELECT c.*,
                COUNT(l.id) AS location_count
         FROM categories c
         LEFT JOIN locations l ON l.category_id = c.id
         GROUP BY c.id
         ORDER BY c.name_ku ASC"
    );
    return $stmt->fetchAll();
}

function is_valid_coordinate(?float $lat, ?float $lng): bool
{
    if ($lat === null || $lng === null) {
        return false;
    }

    return $lat >= -90 && $lat <= 90 && $lng >= -180 && $lng <= 180;
}

function fetch_settings(): array
{
    $stmt = pdo()->query("SELECT setting_key, setting_value FROM settings");
    $settings = [];
    foreach ($stmt->fetchAll() as $row) {
        $settings[$row['setting_key']] = $row['setting_value'];
    }
    return $settings;
}

function feedback_location_id(int $feedbackId): ?int
{
    $stmt = pdo()->prepare("SELECT location_id FROM feedback WHERE id = ?");
    $stmt->execute([$feedbackId]);
    $value = $stmt->fetchColumn();
    return $value ? (int) $value : null;
}

function admin_export_locations_csv(): void
{
    // Check admin authentication
    require_admin();

    $pdo = pdo();
    $stmt = $pdo->query("
        SELECT
            l.id,
            l.name_ku,
            l.name_en,
            l.name_ar,
            g.name_ku AS government_ku,
            g.name_en AS government_en,
            g.name_ar AS government_ar,
            c.name_ku AS category_ku,
            c.name_en AS category_en,
            c.name_ar AS category_ar,
            l.lat,
            l.lng,
            l.address,
            l.phone,
            l.email,
            l.website,
            l.directions_url,
            l.opening_hours,
            l.ticket_price,
            l.average_rating,
            l.total_visits,
            l.featured,
            l.status,
            l.created_at,
            l.updated_at
        FROM locations l
        LEFT JOIN governments g ON l.government_id = g.id
        LEFT JOIN categories c ON l.category_id = c.id
        ORDER BY l.id DESC
    ");
    
    $locations = $stmt->fetchAll();
    
    // Set headers for CSV download
    header('Content-Type: text/csv; charset=utf-8');
    header('Content-Disposition: attachment; filename="locations_export_' . date('Y-m-d') . '.csv"');
    
    // Create output stream
    $output = fopen('php://output', 'w');
    
    // Add BOM for UTF-8 compatibility with Excel
    fwrite($output, "\xEF\xBB\xBF");
    
    // Header row
    fputcsv($output, [
        'ID',
        'Name (Kurdish)',
        'Name (English)',
        'Name (Arabic)',
        'Government (KU)',
        'Government (EN)',
        'Government (AR)',
        'Category (KU)',
        'Category (EN)',
        'Category (AR)',
        'Latitude',
        'Longitude',
        'Address',
        'Phone',
        'Email',
        'Website',
        'Google Maps URL',
        'Opening Hours',
        'Ticket Price',
        'Average Rating',
        'Total Visits',
        'Featured',
        'Status',
        'Created At',
        'Updated At'
    ]);
    
    // Data rows
    foreach ($locations as $location) {
        fputcsv($output, [
            $location['id'],
            $location['name_ku'],
            $location['name_en'],
            $location['name_ar'],
            $location['government_ku'],
            $location['government_en'],
            $location['government_ar'],
            $location['category_ku'],
            $location['category_en'],
            $location['category_ar'],
            $location['lat'],
            $location['lng'],
            $location['address'],
            $location['phone'],
            $location['email'],
            $location['website'],
            $location['directions_url'],
            $location['opening_hours'],
            $location['ticket_price'],
            $location['average_rating'],
            $location['total_visits'],
            $location['featured'] ? 'Yes' : 'No',
            $location['status'],
            $location['created_at'],
            $location['updated_at']
        ]);
    }
    
    fclose($output);
    exit;
}

function recalculate_location_rating(int $locationId): void
{
    $stmt = pdo()->prepare(
        "SELECT COALESCE(AVG(rating), 0) FROM feedback WHERE location_id = ? AND status = 'approved'"
    );
    $stmt->execute([$locationId]);
    $average = (float) $stmt->fetchColumn();

    $update = pdo()->prepare("UPDATE locations SET average_rating = ? WHERE id = ?");
    $update->execute([round($average, 2), $locationId]);
}

// User Authentication & Profile
function current_user(): ?array
{
    if (empty($_SESSION['user_logged_in']) || empty($_SESSION['user_id'])) {
        return null;
    }
    return [
        'id' => (int) $_SESSION['user_id'],
        'name' => $_SESSION['user_name'] ?? '',
        'email' => $_SESSION['user_email'] ?? ''
    ];
}

function require_user(): array
{
    $user = current_user();
    if (!$user) {
        json_response(['error' => 'User authentication required'], 401);
    }
    return $user;
}

function public_user_register(): void
{
    $data = request_data();
    $name = trim($data['name'] ?? '');
    $username = trim($data['username'] ?? '');
    $email = trim($data['email'] ?? '');
    $password = trim($data['password'] ?? '');

    if ($name === '' || $email === '' || $password === '') {
        json_response(['error' => 'All fields are required'], 422);
    }
    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        json_response(['error' => 'Invalid email format'], 422);
    }
    if (strlen($password) < 8) {
        json_response(['error' => 'Password must be at least 8 characters'], 422);
    }

    $pdo = pdo();

    // Check if email already exists
    $stmt = $pdo->prepare("SELECT id FROM users WHERE email = ?");
    $stmt->execute([$email]);
    if ($stmt->fetch()) {
        json_response(['error' => 'Email is already registered'], 409);
    }

    // Check if username already exists (if provided)
    if ($username !== '') {
        $stmt = $pdo->prepare("SELECT id FROM users WHERE username = ?");
        $stmt->execute([$username]);
        if ($stmt->fetch()) {
            json_response(['error' => 'Username is already taken'], 409);
        }
    }

    // Use email as username fallback if not provided
    $finalUsername = $username !== '' ? $username : $email;

    $code = sprintf('%06d', mt_rand(100000, 999999));
    $expiresAt = date('Y-m-d H:i:s', strtotime('+15 minutes'));
    $hash = password_hash($password, PASSWORD_DEFAULT);

    $stmt = $pdo->prepare(
        "INSERT INTO users (full_name, username, email, password_hash, verification_code, code_expires_at) 
         VALUES (?, ?, ?, ?, ?, ?)"
    );
    $stmt->execute([$name, $finalUsername, $email, $hash, $code, $expiresAt]);

    // In a real app, send email with $code here.
    // mail($email, "Your Verification Code", "Your code is: $code");
    
    $message = 'Registration successful. Check your email for the verification code.';
    if ((getenv('SHOW_VERIFICATION_CODES') ?: '') === '1') {
        $message .= ' Verification code: ' . $code;
    }

    json_response(['success' => true, 'message' => $message]);
}

function public_user_verify(): void
{
    $data = request_data();
    $email = trim($data['email'] ?? '');
    $code = trim($data['code'] ?? '');

    if ($email === '' || $code === '') {
        json_response(['error' => 'Email and code are required'], 422);
    }

    $pdo = pdo();
    $stmt = $pdo->prepare("SELECT id, code_expires_at FROM users WHERE email = ? AND verification_code = ?");
    $stmt->execute([$email, $code]);
    $user = $stmt->fetch();

    if (!$user) {
        json_response(['error' => 'Invalid verification code or email'], 400);
    }
    if (strtotime($user['code_expires_at']) < time()) {
        json_response(['error' => 'Verification code expired'], 400);
    }

    $update = $pdo->prepare("UPDATE users SET is_verified = 1, verification_code = NULL, code_expires_at = NULL WHERE id = ?");
    $update->execute([$user['id']]);

    json_response(['success' => true, 'message' => 'Email verified successfully']);
}

function public_user_login(): void
{
    $data = request_data();
    $email = trim($data['email'] ?? '');
    $password = trim($data['password'] ?? '');

    if ($email === '' || $password === '') {
        json_response(['error' => 'Email and password are required'], 422);
    }

    $pdo = pdo();
    $stmt = $pdo->prepare("SELECT id, full_name, email, password_hash, is_verified, marked_for_deletion_at FROM users WHERE email = ?");
    $stmt->execute([$email]);
    $user = $stmt->fetch();

    if (!$user || !password_verify($password, $user['password_hash'])) {
        json_response(['error' => 'Invalid email or password'], 401);
    }

    if (!$user['is_verified']) {
        json_response(['error' => 'Email is not verified'], 403);
    }

    // Cancel deletion if user logs in during grace period
    if ($user['marked_for_deletion_at']) {
        $cancelStmt = $pdo->prepare("UPDATE users SET marked_for_deletion_at = NULL, deletion_reason = NULL WHERE id = ?");
        $cancelStmt->execute([$user['id']]);
    }

    session_regenerate_id(true);
    $_SESSION['user_logged_in'] = true;
    $_SESSION['user_id'] = $user['id'];
    $_SESSION['user_name'] = $user['full_name'];
    $_SESSION['user_email'] = $user['email'];

    json_response([
        'success' => true, 
        'user' => [
            'id' => $user['id'],
            'name' => $user['full_name'],
            'email' => $user['email']
        ]
    ]);
}

function public_user_logout(): void
{
    if (session_status() === PHP_SESSION_ACTIVE) {
        unset($_SESSION['user_logged_in'], $_SESSION['user_id'], $_SESSION['user_name'], $_SESSION['user_email']);
    }
    json_response(['success' => true]);
}

function user_profile(): void
{
    $user = require_user();
    json_response(['user' => $user]);
}

function public_user_profile(): void
{
    $id = (int) ($_GET['id'] ?? 0);
    if ($id <= 0) {
        json_response(['error' => 'Invalid user'], 422);
    }

    $pdo = pdo();
    $stmt = $pdo->prepare("SELECT id, username, full_name, bio, avatar, created_at FROM users WHERE id = ?");
    $stmt->execute([$id]);
    $user = $stmt->fetch();

    if (!$user) {
        json_response(['error' => 'User not found'], 404);
    }

    // Suggestions by this user
    $suggestions = $pdo->prepare("SELECT id, name_ku, name_en, image_path, status, created_at FROM location_suggestions WHERE user_id = ? AND status = 'approved' ORDER BY created_at DESC");
    $suggestions->execute([$id]);
    $user['suggestions'] = $suggestions->fetchAll();

    // Feedback/Reviews by this user
    $feedback = $pdo->prepare("
        SELECT f.*, l.name_ku as location_name_ku, l.name_en as location_name_en
        FROM feedback f
        JOIN locations l ON l.id = f.location_id
        WHERE f.user_id = ? AND f.status = 'approved'
        ORDER BY f.created_at DESC
    ");
    $feedback->execute([$id]);
    $user['feedback'] = $feedback->fetchAll();

    json_response(['success' => true, 'user' => $user]);
}

function user_edit_profile(): void
{
    $user = require_user();
    $data = request_data();
    $name = trim($data['name'] ?? '');
    $password = trim($data['password'] ?? '');

    $avatar = trim($data['avatar'] ?? '');

    if ($name === '') {
        json_response(['error' => 'Name cannot be empty'], 422);
    }

    $pdo = pdo();
    $updateFields = ['full_name = ?'];
    $params = [$name];
    
    if ($password !== '') {
        $updateFields[] = 'password_hash = ?';
        $params[] = password_hash($password, PASSWORD_DEFAULT);
    }
    
    if ($avatar !== '') {
        $updateFields[] = 'avatar = ?';
        $params[] = $avatar;
    }
    
    $params[] = $user['id'];
    $setClause = implode(', ', $updateFields);
    
    $stmt = $pdo->prepare("UPDATE users SET $setClause WHERE id = ?");
    $stmt->execute($params);

    $_SESSION['user_name'] = $name;
    json_response(['success' => true, 'name' => $name, 'avatar' => $avatar]);
}

function user_delete_profile(): void
{
    $user = require_user();
    $pdo = pdo();
    
    // Mark for deletion instead of immediate deletion
    $stmt = $pdo->prepare("UPDATE users SET marked_for_deletion_at = DATE_ADD(NOW(), INTERVAL 30 DAY), deletion_reason = 'User requested deletion' WHERE id = ?");
    $stmt->execute([$user['id']]);
    
    unset($_SESSION['user_logged_in'], $_SESSION['user_id'], $_SESSION['user_name'], $_SESSION['user_email']);
    json_response(['success' => true, 'message' => 'Account marked for deletion. You have 30 days to login and cancel.']);
}

function cleanup_expired_accounts(): void
{
    require_admin();
    $pdo = pdo();
    $stmt = $pdo->prepare("DELETE FROM users WHERE marked_for_deletion_at IS NOT NULL AND marked_for_deletion_at < NOW()");
    $stmt->execute();
    json_response(['success' => true]);
}

// Enhanced API Functions

function public_user_current(): void
{
    // Use current_user() to keep session check consistent with the rest of the API
    $session = current_user();
    if ($session) {
        $pdo = pdo();
        $stmt = $pdo->prepare("SELECT id, username, email, full_name, phone, avatar, bio, language, created_at FROM users WHERE id = ? AND status = 'active'");
        $stmt->execute([$session['id']]);
        $user = $stmt->fetch();

        if ($user) {
            json_response(['success' => true, 'user' => $user]);
        }
    }

    json_response(['success' => false, 'error' => 'Not logged in'], 401);
}

function public_reviews(): void
{
    $locationId = $_GET['location_id'] ?? null;
    $pdo = pdo();
    
    if ($locationId) {
        $stmt = $pdo->prepare("
            SELECT r.*, u.full_name, u.avatar 
            FROM reviews r 
            LEFT JOIN users u ON r.user_id = u.id 
            WHERE r.location_id = ? AND r.status = 'published'
            ORDER BY r.created_at DESC
        ");
        $stmt->execute([$locationId]);
    } else {
        $stmt = $pdo->prepare("
            SELECT r.*, u.full_name, u.avatar, l.name_ku as location_name 
            FROM reviews r 
            LEFT JOIN users u ON r.user_id = u.id 
            LEFT JOIN locations l ON r.location_id = l.id 
            WHERE r.status = 'published'
            ORDER BY r.created_at DESC
            LIMIT 50
        ");
        $stmt->execute();
    }
    
    $reviews = $stmt->fetchAll();
    json_response(['success' => true, 'reviews' => $reviews]);
}

function public_add_review(): void
{
    $user = require_user();
    $data = request_data();
    
    $locationId = $data['location_id'] ?? null;
    $rating = $data['rating'] ?? null;
    $title = $data['title'] ?? '';
    $comment = $data['comment'] ?? '';
    
    $locationId = (int) $locationId;
    $rating = (int) $rating;
    if ($locationId <= 0 || !$rating || $comment === '') {
        json_response(['error' => 'Missing required fields'], 422);
    }
    
    if ($rating < 1 || $rating > 5) {
        json_response(['error' => 'Invalid rating'], 422);
    }
    
    $pdo = pdo();
    
    // Check if location exists
    $stmt = $pdo->prepare("SELECT id FROM locations WHERE id = ?");
    $stmt->execute([$locationId]);
    if (!$stmt->fetch()) {
        json_response(['error' => 'Location not found'], 404);
    }
    
    // Insert review
    $stmt = $pdo->prepare("
        INSERT INTO reviews (location_id, user_id, rating, title, comment, status, created_at) 
        VALUES (?, ?, ?, ?, ?, 'published', NOW())
    ");
    $stmt->execute([$locationId, $user['id'], $rating, $title, $comment]);
    
    // Update location average rating
    $stmt = $pdo->prepare("
        UPDATE locations 
        SET average_rating = (
            SELECT COALESCE(AVG(rating), 0) 
            FROM reviews 
            WHERE location_id = ? AND status = 'published'
        )
        WHERE id = ?
    ");
    $stmt->execute([$locationId, $locationId]);
    
    json_response(['success' => true, 'message' => 'Review added successfully']);
}

function public_photos(): void
{
    $locationId = $_GET['location_id'] ?? null;
    $userId = $_GET['user_id'] ?? null;
    $pdo = pdo();
    
    $sql = "
        SELECT p.*, u.full_name, l.name_ku as location_name 
        FROM photos p 
        LEFT JOIN users u ON p.user_id = u.id 
        LEFT JOIN locations l ON p.location_id = l.id 
        WHERE p.status = 'published'
    ";
    $params = [];
    
    if ($locationId) {
        $sql .= " AND p.location_id = ?";
        $params[] = $locationId;
    }
    
    if ($userId) {
        $sql .= " AND p.user_id = ?";
        $params[] = $userId;
    }
    
    $sql .= " ORDER BY p.created_at DESC LIMIT 50";
    
    $stmt = $pdo->prepare($sql);
    $stmt->execute($params);
    $photos = $stmt->fetchAll();
    
    json_response(['success' => true, 'photos' => $photos]);
}

function public_upload_photo(): void
{
    $user = require_user();
    
    if (!isset($_FILES['photo'])) {
        json_response(['error' => 'No photo uploaded'], 422);
    }
    
    $photo = $_FILES['photo'];
    $locationId = (int) ($_POST['location_id'] ?? 0);
    $title = $_POST['title'] ?? '';
    $description = $_POST['description'] ?? '';

    if ($locationId <= 0) {
        json_response(['error' => 'Invalid location'], 422);
    }

    $pdo = pdo();
    $locationStmt = $pdo->prepare("SELECT id FROM locations WHERE id = ? AND status = 'published'");
    $locationStmt->execute([$locationId]);
    if (!$locationStmt->fetch()) {
        json_response(['error' => 'Location not found'], 404);
    }

    $extension = uploaded_image_extension($photo, 10 * 1024 * 1024);
    if ($extension === null) {
        json_response(['error' => 'Invalid image. Only JPG, PNG, GIF, and WebP files up to 10MB are allowed'], 422);
    }

    $filename = secure_random_filename('photo_' . $user['id'] . '_', $extension);
    
    // Use absolute path for server-side operations
    $baseDir = app()->uploadDir(); // e.g., C:/AppServ/www/project/uploads
    $photosDir = $baseDir . '/photos';
    
    if (!is_dir($photosDir)) {
        mkdir($photosDir, 0755, true);
    }
    
    $destination = $photosDir . '/' . $filename;
    $uploadPath = 'uploads/photos/' . $filename; // Relative path for DB and frontend
    
    // Move file
    if (!move_uploaded_file($photo['tmp_name'], $destination)) {
        json_response(['error' => 'Upload failed'], 500);
    }
    
    // Get image dimensions - use absolute path
    $imageInfo = getimagesize($destination);
    $width = $imageInfo[0] ?? 0;
    $height = $imageInfo[1] ?? 0;
    
    // Save to database
    $stmt = $pdo->prepare("
        INSERT INTO photos (location_id, user_id, title, description, image_path, file_size, width, height, status, created_at) 
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'published', NOW())
    ");
    $stmt->execute([
        $locationId,
        $user['id'],
        $title,
        $description,
        $uploadPath,
        $photo['size'],
        $width,
        $height
    ]);
    
    json_response(['success' => true, 'message' => 'Photo uploaded successfully', 'photo_path' => $uploadPath]);
}

function public_businesses(): void
{
    $type = $_GET['type'] ?? '';
    $search = $_GET['search'] ?? '';
    $pdo = pdo();
    
    $sql = "
        SELECT * FROM businesses 
        WHERE status = 'published'
    ";
    $params = [];
    
    if ($type) {
        $sql .= " AND type = ?";
        $params[] = $type;
    }
    
    if ($search) {
        $sql .= " AND (name_ku LIKE ? OR name_en LIKE ? OR description_ku LIKE ?)";
        $searchTerm = "%$search%";
        $params[] = $searchTerm;
        $params[] = $searchTerm;
        $params[] = $searchTerm;
    }
    
    $sql .= " ORDER BY rating DESC, featured DESC LIMIT 50";
    
    $stmt = $pdo->prepare($sql);
    $stmt->execute($params);
    $businesses = $stmt->fetchAll();
    
    json_response(['success' => true, 'businesses' => $businesses]);
}

function public_events(): void
{
    $month = $_GET['month'] ?? date('n');
    $year = $_GET['year'] ?? date('Y');
    $pdo = pdo();
    
    $stmt = $pdo->prepare("
        SELECT e.*, l.name_ku as location_name 
        FROM events e 
        LEFT JOIN locations l ON e.location_id = l.id 
        WHERE e.status = 'published' 
        AND MONTH(e.start_date) = ? 
        AND YEAR(e.start_date) = ?
        ORDER BY e.start_date ASC
    ");
    $stmt->execute([$month, $year]);
    $events = $stmt->fetchAll();
    
    json_response(['success' => true, 'events' => $events]);
}

function public_itineraries(): void
{
    $user = require_user();
    $pdo = pdo();
    
    $id = (int) ($_GET['id'] ?? 0);
    
    if ($id > 0) {
        // Fetch single itinerary
        $stmt = $pdo->prepare("SELECT * FROM itineraries WHERE id = ? AND user_id = ? AND status != 'deleted'");
        $stmt->execute([$id, $user['id']]);
        $itinerary = $stmt->fetch();
        
        if (!$itinerary) {
            json_response(['error' => 'Trip not found'], 404);
        }
        
        // Fetch items
        $stmt = $pdo->prepare("SELECT * FROM itinerary_items WHERE itinerary_id = ? ORDER BY day_number, order_number");
        $stmt->execute([$id]);
        $items = $stmt->fetchAll();
        
        json_response(['success' => true, 'itinerary' => $itinerary, 'items' => $items]);
    } else {
        // Fetch all itineraries
        $stmt = $pdo->prepare("
            SELECT i.*, 
                   (SELECT COUNT(*) FROM itinerary_items WHERE itinerary_id = i.id) as items_count
            FROM itineraries i
            WHERE i.user_id = ? AND i.status != 'deleted'
            ORDER BY i.created_at DESC
        ");
        $stmt->execute([$user['id']]);
        $itineraries = $stmt->fetchAll();
        
        json_response(['success' => true, 'itineraries' => $itineraries]);
    }
}

function public_save_itinerary(): void
{
    $user = require_user();
    $data = request_data();
    
    $title = $data['title'] ?? '';
    $description = $data['description'] ?? '';
    $startDate = $data['start_date'] ?? '';
    $endDate = $data['end_date'] ?? '';
    $travelers = $data['travelers'] ?? 1;
    $days = $data['days'] ?? [];
    
    if (!$title || !$startDate || !$endDate) {
        json_response(['error' => 'Missing required fields'], 422);
    }
    
    $pdo = pdo();
    $pdo->beginTransaction();
    
    try {
        // Insert itinerary
        $stmt = $pdo->prepare("
            INSERT INTO itineraries (user_id, title, description, start_date, end_date, total_days, travelers_count, status, created_at) 
            VALUES (?, ?, ?, ?, ?, ?, ?, 'published', NOW())
        ");
        $stmt->execute([
            $user['id'],
            $title,
            $description,
            $startDate,
            $endDate,
            count($days),
            $travelers
        ]);
        
        $itineraryId = $pdo->lastInsertId();
        
        // Insert itinerary items
        foreach ($days as $dayNumber => $items) {
            foreach ($items as $index => $item) {
                $stmt = $pdo->prepare("
                    INSERT INTO itinerary_items (itinerary_id, day_number, item_type, item_id, title, description, start_time, end_time, duration_minutes, order_number, created_at) 
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())
                ");
                $stmt->execute([
                    $itineraryId,
                    $dayNumber,
                    $item['type'] ?? 'location',
                    $item['item_id'] ?? null,
                    $item['title'] ?? '',
                    $item['description'] ?? '',
                    $item['start_time'] ?? null,
                    $item['end_time'] ?? null,
                    $item['duration_minutes'] ?? 0,
                    $index
                ]);
            }
        }
        
        $pdo->commit();
        json_response(['success' => true, 'itinerary_id' => $itineraryId]);
        
    } catch (Exception $e) {
        $pdo->rollback();
        json_response(['error' => 'Failed to save itinerary'], 500);
    }
}

function public_delete_itinerary(): void
{
    $user = require_user();
    $data = request_data();
    
    $itineraryId = (int) ($data['id'] ?? 0);
    
    if ($itineraryId <= 0) {
        json_response(['error' => 'Invalid itinerary ID'], 422);
    }
    
    $pdo = pdo();
    
    // Verify ownership
    $stmt = $pdo->prepare("SELECT user_id FROM itineraries WHERE id = ?");
    $stmt->execute([$itineraryId]);
    $itinerary = $stmt->fetch();
    
    if (!$itinerary) {
        json_response(['error' => 'Itinerary not found'], 404);
    }
    
    if ((int)$itinerary['user_id'] !== (int)$user['id']) {
        json_response(['error' => 'Not authorized'], 403);
    }
    
    // Soft delete - mark as deleted
    $stmt = $pdo->prepare("UPDATE itineraries SET status = 'deleted' WHERE id = ?");
    $stmt->execute([$itineraryId]);
    
    json_response(['success' => true, 'message' => 'Trip deleted successfully']);
}

function public_weather(): void
{
    $lat = isset($_GET['lat']) ? (float) $_GET['lat'] : null;
    $lng = isset($_GET['lng']) ? (float) $_GET['lng'] : null;
    
    if ($lat === null || $lng === null || !is_valid_coordinate($lat, $lng)) {
        json_response(['error' => 'Valid latitude and longitude required'], 422);
    }
    
    $pdo = pdo();
    
    // Check cache first
    $stmt = $pdo->prepare("
        SELECT * FROM weather_cache 
        WHERE location_id = (
            SELECT id FROM locations 
            WHERE ABS(lat - ?) < 0.01 AND ABS(lng - ?) < 0.01 
            LIMIT 1
        ) 
        AND expires_at > NOW()
    ");
    $stmt->execute([$lat, $lng]);
    $cached = $stmt->fetch();
    
    if ($cached) {
        json_response(['success' => true, 'weather' => [
            'temperature' => $cached['temperature'],
            'condition' => $cached['condition_text'],
            'humidity' => $cached['humidity'],
            'windSpeed' => $cached['wind_speed'],
            'icon' => $cached['icon_url']
        ]]);
    }
    
    $apiKey = getenv('OPENWEATHER_API_KEY') ?: '';
    if ($apiKey === '') {
        json_response(['error' => 'Weather service unavailable'], 503);
    }

    $url = 'https://api.openweathermap.org/data/2.5/weather?' . http_build_query([
        'lat' => $lat,
        'lon' => $lng,
        'appid' => $apiKey,
        'units' => 'metric',
    ]);
    
    $response = file_get_contents($url);
    if ($response === false) {
        json_response(['error' => 'Weather service unavailable'], 503);
    }
    
    $data = json_decode($response, true);
    if (
        !is_array($data)
        || !isset($data['main']['temp'], $data['main']['humidity'], $data['weather'][0]['description'], $data['weather'][0]['icon'], $data['wind']['speed'])
    ) {
        json_response(['error' => 'Weather service unavailable'], 503);
    }
    
    $weather = [
        'temperature' => round($data['main']['temp']),
        'condition' => $data['weather'][0]['description'],
        'humidity' => $data['main']['humidity'],
        'windSpeed' => $data['wind']['speed'],
        'icon' => $data['weather'][0]['icon']
    ];
    
    // Cache for 1 hour
    $stmt = $pdo->prepare("
        INSERT INTO weather_cache (location_id, temperature, humidity, wind_speed, condition_text, icon_url, expires_at) 
        VALUES ((SELECT id FROM locations WHERE ABS(lat - ?) < 0.01 AND ABS(lng - ?) < 0.01 LIMIT 1), ?, ?, ?, ?, ?, DATE_ADD(NOW(), INTERVAL 1 HOUR))
        ON DUPLICATE KEY UPDATE 
        temperature = VALUES(temperature),
        humidity = VALUES(humidity),
        wind_speed = VALUES(wind_speed),
        condition_text = VALUES(condition_text),
        icon_url = VALUES(icon_url),
        expires_at = VALUES(expires_at)
    ");
    $stmt->execute([
        $lat, $lng,
        $weather['temperature'],
        $weather['humidity'],
        $weather['windSpeed'],
        $weather['condition'],
        "https://openweathermap.org/img/wn/{$weather['icon']}@2x.png"
    ]);
    
    json_response(['success' => true, 'weather' => $weather]);
}

function public_user_favorites(): void
{
    $user = current_user();
    if (!$user) {
        json_response(['success' => true, 'favorites' => []]);
        return;
    }

    $stmt = pdo()->prepare("SELECT location_id FROM user_favorites WHERE user_id = ?");
    $stmt->execute([$user['id']]);
    $favorites = array_map('intval', array_column($stmt->fetchAll(), 'location_id'));
    json_response(['success' => true, 'favorites' => $favorites]);
}

function public_toggle_favorite(): void
{
    $user = require_user();
    $data = request_data();
    $locationId = (int) ($data['location_id'] ?? 0);
    if ($locationId <= 0) {
        json_response(['error' => 'Invalid location'], 422);
    }

    $pdo = pdo();
    $stmt = $pdo->prepare("SELECT id FROM user_favorites WHERE user_id = ? AND location_id = ?");
    $stmt->execute([$user['id'], $locationId]);
    $existing = $stmt->fetch();

    if ($existing) {
        $pdo->prepare("DELETE FROM user_favorites WHERE user_id = ? AND location_id = ?")->execute([$user['id'], $locationId]);
        json_response(['success' => true, 'action' => 'removed']);
    } else {
        $pdo->prepare("INSERT INTO user_favorites (user_id, location_id) VALUES (?, ?)")->execute([$user['id'], $locationId]);
        json_response(['success' => true, 'action' => 'added']);
    }
}

function public_suggest_location(): void
{
    $user = require_user();
    $data = request_data();

    $nameKu = trim($data['name_ku'] ?? '');
    $lat = (float) ($data['lat'] ?? 0);
    $lng = (float) ($data['lng'] ?? 0);

    if ($nameKu === '' || !is_valid_coordinate($lat, $lng)) {
        json_response(['error' => 'Name and valid coordinates are required'], 422);
    }

    // Handle image upload
    $imagePath = null;
    $imageBase64 = $data['image_base64'] ?? null;
    
    if ($imageBase64 && preg_match('#^data:image/(jpeg|png|gif|webp);base64,#i', $imageBase64)) {
        $imageData = base64_decode(preg_replace('#^data:image/(jpeg|png|gif|webp);base64,#i', '', $imageBase64), true);
        if ($imageData !== false) {
            $extension = image_data_extension($imageData, 5 * 1024 * 1024);
            if ($extension === null) {
                json_response(['error' => 'Invalid suggestion image'], 422);
            }

            $baseDir = app()->uploadDir();
            $suggestionsDir = $baseDir . '/suggestions';
            
            if (!is_dir($suggestionsDir)) {
                mkdir($suggestionsDir, 0755, true);
            }
            
            $filename = secure_random_filename('suggestion_' . $user['id'] . '_', $extension);
            $destination = $suggestionsDir . '/' . $filename;
            
            if (file_put_contents($destination, $imageData)) {
                $imagePath = 'uploads/suggestions/' . $filename;
            }
        }
    }

    $stmt = pdo()->prepare(
        "INSERT INTO location_suggestions (user_id, name_ku, name_en, name_ar, description_ku, description_en, description_ar, lat, lng, government_id, category_id, address, phone, email, website, directions_url, opening_hours, ticket_price, image_path, image_base64)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
    );
    $stmt->execute([
        $user['id'],
        $nameKu,
        trim($data['name_en'] ?? ''),
        trim($data['name_ar'] ?? ''),
        trim($data['description_ku'] ?? ''),
        trim($data['description_en'] ?? ''),
        trim($data['description_ar'] ?? ''),
        $lat,
        $lng,
        !empty($data['government_id']) ? (int) $data['government_id'] : null,
        !empty($data['category_id']) ? (int) $data['category_id'] : null,
        trim($data['address'] ?? ''),
        trim($data['phone'] ?? ''),
        trim($data['email'] ?? ''),
        trim($data['website'] ?? ''),
        trim($data['directions_url'] ?? ''),
        trim($data['opening_hours'] ?? ''),
        trim($data['ticket_price'] ?? ''),
        $imagePath,
        null
    ]);

    json_response(['success' => true, 'message' => 'Suggestion submitted for review']);
}

function admin_suggestions(): void
{
    require_admin();
    $status = $_GET['status'] ?? 'pending';
    $params = [];
    $where = '';
    if (in_array($status, ['pending', 'approved', 'rejected'], true)) {
        $where = 'WHERE s.status = ?';
        $params[] = $status;
    }

    $stmt = pdo()->prepare(
        "SELECT s.*, u.full_name AS user_name, u.email AS user_email
         FROM location_suggestions s
         LEFT JOIN users u ON u.id = s.user_id
         {$where}
         ORDER BY s.created_at DESC"
    );
    $stmt->execute($params);
    json_response(['success' => true, 'suggestions' => $stmt->fetchAll()]);
}

function admin_review_suggestion(): void
{
    require_admin();
    $data = request_data();
    $id = (int) ($data['id'] ?? 0);
    $action = $data['action'] ?? '';

    if ($id <= 0) {
        json_response(['error' => 'Invalid suggestion'], 422);
    }

    if ($action === 'approve') {
        $stmt = pdo()->prepare("UPDATE location_suggestions SET status = 'approved', reviewed_at = NOW(), admin_note = ? WHERE id = ?");
        $stmt->execute([trim($data['admin_note'] ?? ''), $id]);
        json_response(['success' => true]);
    }

    if ($action === 'reject') {
        $stmt = pdo()->prepare("UPDATE location_suggestions SET status = 'rejected', reviewed_at = NOW(), admin_note = ? WHERE id = ?");
        $stmt->execute([trim($data['admin_note'] ?? ''), $id]);
        json_response(['success' => true]);
    }

    json_response(['error' => 'Invalid action'], 422);
}

function public_user_suggestions(): void
{
    $user = require_user();
    $stmt = pdo()->prepare(
        "SELECT id, name_ku, name_en, name_ar, status, created_at, reviewed_at, admin_note, image_path, lat, lng
         FROM location_suggestions
         WHERE user_id = ?
         ORDER BY created_at DESC"
    );
    $stmt->execute([$user['id']]);
    json_response(['success' => true, 'suggestions' => $stmt->fetchAll()]);
}

function public_my_visits(): void
{
    $user = current_user();
    if (!$user) {
        json_response(['success' => true, 'visits' => []]);
        return;
    }

    $stmt = pdo()->prepare(
        "SELECT lv.location_id, lv.visited_at, l.name_ku, l.name_en, l.name_ar,
                g.name_ku AS gov_name_ku, g.color AS gov_color,
                c.name_ku AS cat_name_ku, c.icon AS category_icon
         FROM location_visits lv
         LEFT JOIN locations l ON l.id = lv.location_id
         LEFT JOIN governments g ON g.id = l.government_id
         LEFT JOIN categories c ON c.id = l.category_id
         WHERE lv.user_id = ? AND lv.location_id IS NOT NULL
         GROUP BY lv.location_id
         ORDER BY MAX(lv.visited_at) DESC
         LIMIT 50"
    );
    $stmt->execute([$user['id']]);
    json_response(['success' => true, 'visits' => $stmt->fetchAll()]);
}

// Contact Messages Functions
function public_contact_submit(): void
{
    $data = request_data();
    
    $fullName = trim($data['full_name'] ?? '');
    $email = trim($data['email'] ?? '');
    $phone = trim($data['phone'] ?? '');
    $subject = trim($data['subject'] ?? '');
    $message = trim($data['message'] ?? '');
    
    // Validation
    if (empty($fullName) || empty($email) || empty($subject) || empty($message)) {
        json_response(['error' => 'Please fill in all required fields'], 422);
    }
    
    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        json_response(['error' => 'Invalid email address'], 422);
    }
    
    $pdo = pdo();
    $stmt = $pdo->prepare(
        "INSERT INTO contact_messages (full_name, email, phone, subject, message, ip_address, created_at)
         VALUES (?, ?, ?, ?, ?, ?, NOW())"
    );
    
    $ipAddress = $_SERVER['REMOTE_ADDR'] ?? null;
    $stmt->execute([$fullName, $email, $phone, $subject, $message, $ipAddress]);
    
    json_response(['success' => true, 'message' => 'Message sent successfully. We will get back to you soon!']);
}

function admin_contact_messages(): void
{
    require_admin();
    
    $status = $_GET['status'] ?? 'all';
    $pdo = pdo();
    
    $where = '';
    $params = [];
    
    if ($status !== 'all' && in_array($status, ['unread', 'read', 'replied'])) {
        $where = 'WHERE status = ?';
        $params[] = $status;
    }
    
    // Get messages with pagination
    $page = (int) ($_GET['page'] ?? 1);
    $perPage = 20;
    $offset = ($page - 1) * $perPage;
    
    // Use direct integer values for LIMIT/OFFSET (cast to int for safety)
    $stmt = $pdo->prepare(
        "SELECT * FROM contact_messages
         {$where}
         ORDER BY created_at DESC
         LIMIT {$perPage} OFFSET {$offset}"
    );
    $stmt->execute($params);
    $messages = $stmt->fetchAll();
    
    // Get counts for each status
    $counts = [
        'all' => $pdo->query("SELECT COUNT(*) FROM contact_messages")->fetchColumn(),
        'unread' => $pdo->query("SELECT COUNT(*) FROM contact_messages WHERE status = 'unread'")->fetchColumn(),
        'read' => $pdo->query("SELECT COUNT(*) FROM contact_messages WHERE status = 'read'")->fetchColumn(),
        'replied' => $pdo->query("SELECT COUNT(*) FROM contact_messages WHERE status = 'replied'")->fetchColumn()
    ];
    
    json_response([
        'success' => true,
        'messages' => $messages,
        'counts' => $counts,
        'page' => $page,
        'per_page' => $perPage
    ]);
}

function admin_contact_reply(): void
{
    require_admin();
    
    $data = request_data();
    $id = (int) ($data['id'] ?? 0);
    $reply = trim($data['reply'] ?? '');
    
    if ($id <= 0) {
        json_response(['error' => 'Invalid message ID'], 422);
    }
    
    if (empty($reply)) {
        json_response(['error' => 'Reply message is required'], 422);
    }
    
    $pdo = pdo();
    $stmt = $pdo->prepare(
        "UPDATE contact_messages 
         SET status = 'replied', admin_reply = ?, replied_at = NOW()
         WHERE id = ?"
    );
    $stmt->execute([$reply, $id]);
    
    json_response(['success' => true, 'message' => 'Reply saved successfully']);
}

function admin_contact_update(): void
{
    require_admin();
    
    $data = request_data();
    $id = (int) ($data['id'] ?? 0);
    $status = $data['status'] ?? '';
    
    if ($id <= 0) {
        json_response(['error' => 'Invalid message ID'], 422);
    }
    
    if (!in_array($status, ['unread', 'read', 'replied'])) {
        json_response(['error' => 'Invalid status'], 422);
    }
    
    $pdo = pdo();
    $stmt = $pdo->prepare("UPDATE contact_messages SET status = ? WHERE id = ?");
    $stmt->execute([$status, $id]);
    
    json_response(['success' => true, 'message' => 'Status updated']);
}

function admin_contact_delete(): void
{
    require_admin();
    
    $data = request_data();
    $id = (int) ($data['id'] ?? 0);
    
    if ($id <= 0) {
        json_response(['error' => 'Invalid message ID'], 422);
    }
    
    $pdo = pdo();
    $stmt = $pdo->prepare("DELETE FROM contact_messages WHERE id = ?");
    $stmt->execute([$id]);
    
    json_response(['success' => true, 'message' => 'Message deleted']);
}
?>