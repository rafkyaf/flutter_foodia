<?php
header('Content-Type: application/json; charset=utf-8');
require_once __DIR__ . '/db.php';
$pdo = require __DIR__ . '/db.php';

$method = $_SERVER['REQUEST_METHOD'];
$action = isset($_GET['action']) ? $_GET['action'] : null;

// helper to read JSON body
function getJsonBody() {
    $raw = file_get_contents('php://input');
    return json_decode($raw, true);
}

// Ensure users table exists (adds profile fields)
$pdo->exec("CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) UNIQUE,
    password VARCHAR(255) NOT NULL,
    name VARCHAR(200),
    email VARCHAR(200) UNIQUE,
    role_id INT DEFAULT 1,
    is_active TINYINT(1) DEFAULT 1,
    phone VARCHAR(50),
    address TEXT,
    avatar VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;");

if ($method === 'GET') {
    // if id provided => single user
    if (isset($_GET['id'])) {
        $id = (int)$_GET['id'];
        $stmt = $pdo->prepare('SELECT id, username, name, email, role_id, is_active, phone, address, avatar, created_at FROM users WHERE id = :id LIMIT 1');
        $stmt->execute([':id'=>$id]);
        $user = $stmt->fetch();
            if ($user) {
                // add full avatar URL if present
                if (!empty($user['avatar'])) {
                    $proto = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') ? 'https' : 'http';
                    $base = $proto . '://' . $_SERVER['HTTP_HOST'] . dirname($_SERVER['PHP_SELF']) . '/';
                    $user['avatar_url'] = $base . $user['avatar'];
                } else {
                    $user['avatar_url'] = null;
                }
                echo json_encode(['success'=>true,'data'=>$user]);
            }
        else { http_response_code(404); echo json_encode(['success'=>false,'message'=>'User not found']); }
        exit;
    }

    // list users (safe fields only)
    $stmt = $pdo->query('SELECT id, username, name, email, role_id, is_active, phone, avatar FROM users');
    $users = $stmt->fetchAll();
    // attach avatar_url for each user
    $proto = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') ? 'https' : 'http';
    $base = $proto . '://' . $_SERVER['HTTP_HOST'] . dirname($_SERVER['PHP_SELF']) . '/';
    foreach ($users as &$u) {
        $u['avatar_url'] = !empty($u['avatar']) ? $base . $u['avatar'] : null;
    }
    unset($u);
    echo json_encode(['success' => true, 'data' => $users]);
    exit;
}

if ($method === 'POST' && $action === 'register') {
    $data = getJsonBody();
    if (!$data) {
        http_response_code(400);
        echo json_encode(['success'=>false,'message'=>'Invalid JSON']);
        exit;
    }
    $username = $data['username'] ?? null;
    $password = $data['password'] ?? null;
    $email = $data['email'] ?? null;
    $name = $data['name'] ?? null;
    $role_id = $data['role_id'] ?? 1;

    if (!$username || !$password || !$email) {
        http_response_code(400);
        echo json_encode(['success'=>false,'message'=>'username, password and email required']);
        exit;
    }

    // create user
    $hash = password_hash($password, PASSWORD_DEFAULT);
    $sql = 'INSERT INTO users (username, password, role_id, name, email) VALUES (:username, :password, :role_id, :name, :email)';
    $stmt = $pdo->prepare($sql);
    try {
        $stmt->execute([':username'=>$username,':password'=>$hash,':role_id'=>$role_id,':name'=>$name,':email'=>$email]);
        echo json_encode(['success'=>true,'message'=>'User created']);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['success'=>false,'message'=>'Insert failed','error'=>$e->getMessage()]);
    }
    exit;
}

// upload avatar (base64 JSON) -> updates users.avatar
if ($method === 'POST' && $action === 'upload_avatar') {
    $data = getJsonBody();
    $user_id = $data['user_id'] ?? null;
    $b64 = $data['avatar_base64'] ?? null;
    if (!$user_id || !$b64) {
        http_response_code(400);
        echo json_encode(['success'=>false,'message'=>'user_id and avatar_base64 required']);
        exit;
    }

    // create uploads dir if not exists
    $dir = __DIR__ . '/uploads/avatars';
    if (!is_dir($dir)) mkdir($dir, 0755, true);

    // decode base64 (allow data URI)
    if (strpos($b64, ',') !== false) $b64 = explode(',', $b64, 2)[1];
    $bin = base64_decode($b64);
    if ($bin === false) {
        http_response_code(400);
        echo json_encode(['success'=>false,'message'=>'Invalid base64']);
        exit;
    }

    $filename = 'user_' . intval($user_id) . '_' . time() . '.png';
    $path = $dir . '/' . $filename;
    if (file_put_contents($path, $bin) === false) {
        http_response_code(500);
        echo json_encode(['success'=>false,'message'=>'Failed to save file']);
        exit;
    }

    // update DB avatar path (relative)
    $rel = 'uploads/avatars/' . $filename;
    $stmt = $pdo->prepare('UPDATE users SET avatar = :a WHERE id = :id');
    try {
        $stmt->execute([':a'=>$rel, ':id'=> $user_id]);
        echo json_encode(['success'=>true,'avatar'=>$rel]);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['success'=>false,'message'=>'DB update failed','error'=>$e->getMessage()]);
    }
    exit;
}

// admin: update user
if ($method === 'POST' && $action === 'update') {
    $data = getJsonBody();
    $id = $data['id'] ?? null;
    if (!$id) { http_response_code(400); echo json_encode(['success'=>false,'message'=>'id required']); exit; }
    $fields = [];
    $params = [':id'=>$id];
    $allowed = ['username','name','email','phone','address','role_id','is_active','avatar'];
    foreach ($allowed as $f) {
        if (isset($data[$f])) { $fields[] = "$f = :$f"; $params[":".$f] = $data[$f]; }
    }
    if (count($fields) === 0) { echo json_encode(['success'=>false,'message'=>'no fields to update']); exit; }
    $sql = 'UPDATE users SET ' . implode(', ', $fields) . ' WHERE id = :id';
    $stmt = $pdo->prepare($sql);
    try {
        $stmt->execute($params);
        echo json_encode(['success'=>true]);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['success'=>false,'message'=>'Update failed','error'=>$e->getMessage()]);
    }
    exit;
}

// admin: delete user
if ($method === 'POST' && $action === 'delete') {
    $data = getJsonBody();
    $id = $data['id'] ?? null;
    if (!$id) { http_response_code(400); echo json_encode(['success'=>false,'message'=>'id required']); exit; }
    $stmt = $pdo->prepare('DELETE FROM users WHERE id = :id');
    try {
        $stmt->execute([':id'=>$id]);
        echo json_encode(['success'=>true]);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['success'=>false,'message'=>'Delete failed','error'=>$e->getMessage()]);
    }
    exit;
}

// admin: set active / deactivate
if ($method === 'POST' && $action === 'set_active') {
    $data = getJsonBody();
    $id = $data['id'] ?? null;
    $v = isset($data['is_active']) ? (int)$data['is_active'] : null;
    if (!$id || $v === null) { http_response_code(400); echo json_encode(['success'=>false,'message'=>'id and is_active required']); exit; }
    $stmt = $pdo->prepare('UPDATE users SET is_active = :v WHERE id = :id');
    try {
        $stmt->execute([':v'=>$v,':id'=>$id]);
        echo json_encode(['success'=>true]);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['success'=>false,'message'=>'Update failed','error'=>$e->getMessage()]);
    }
    exit;
}

// admin: change role
if ($method === 'POST' && $action === 'change_role') {
    $data = getJsonBody();
    $id = $data['id'] ?? null;
    $role = $data['role_id'] ?? null;
    if (!$id || $role === null) { http_response_code(400); echo json_encode(['success'=>false,'message'=>'id and role_id required']); exit; }
    $stmt = $pdo->prepare('UPDATE users SET role_id = :r WHERE id = :id');
    try {
        $stmt->execute([':r'=>$role,':id'=>$id]);
        echo json_encode(['success'=>true]);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['success'=>false,'message'=>'Update failed','error'=>$e->getMessage()]);
    }
    exit;
}

if ($method === 'POST' && $action === 'login') {
    $data = getJsonBody();
    $username = $data['username'] ?? null;
    $password = $data['password'] ?? null;
    if (!$username || !$password) {
        http_response_code(400);
        echo json_encode(['success'=>false,'message'=>'username and password required']);
        exit;
    }

    $sql = 'SELECT id, username, password, email, name, role_id, is_active FROM users WHERE username = :u OR email = :u LIMIT 1';
    $stmt = $pdo->prepare($sql);
    $stmt->execute([':u'=>$username]);
    $user = $stmt->fetch();
    if (!$user) {
        http_response_code(401);
        echo json_encode(['success'=>false,'message'=>'Invalid credentials']);
        exit;
    }

    $stored = $user['password'];
    $ok = false;
    if (password_verify($password, $stored)) {
        $ok = true;
    } else {
        // fallback for SHA2-stored example users (compatibility)
        if (hash('sha256', $password) === $stored) {
            $ok = true;
        }
    }

    if (!$ok) {
        http_response_code(401);
        echo json_encode(['success'=>false,'message'=>'Invalid credentials']);
        exit;
    }

    // For demo: return user info (don't return password)
    unset($user['password']);
    echo json_encode(['success'=>true,'data'=>$user]);
    exit;
}

http_response_code(404);
echo json_encode(['success'=>false,'message'=>'Unsupported route']);
