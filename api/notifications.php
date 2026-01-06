<?php
header('Content-Type: application/json; charset=utf-8');
$pdo = require __DIR__ . '/db.php';

// Ensure table exists
$pdo->exec("CREATE TABLE IF NOT EXISTS notifications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    admin_id INT,
    type VARCHAR(100),
    message TEXT,
    data JSON,
    is_read TINYINT(1) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;");

$method = $_SERVER['REQUEST_METHOD'];

function getJsonBody() { $raw = file_get_contents('php://input'); return json_decode($raw, true); }

if ($method === 'GET') {
    // list notifications for user or admin
    $user_id = isset($_GET['user_id']) ? (int)$_GET['user_id'] : null;
    $admin_id = isset($_GET['admin_id']) ? (int)$_GET['admin_id'] : null;
    if ($user_id) {
        $stmt = $pdo->prepare('SELECT * FROM notifications WHERE user_id = :u ORDER BY created_at DESC');
        $stmt->execute([':u'=>$user_id]);
        $rows = $stmt->fetchAll();
        echo json_encode(['success'=>true,'data'=>$rows]);
        exit;
    }
    if ($admin_id) {
        $stmt = $pdo->prepare('SELECT * FROM notifications WHERE admin_id = :a ORDER BY created_at DESC');
        $stmt->execute([':a'=>$admin_id]);
        $rows = $stmt->fetchAll();
        echo json_encode(['success'=>true,'data'=>$rows]);
        exit;
    }
    // all (admin usage)
    $stmt = $pdo->query('SELECT * FROM notifications ORDER BY created_at DESC LIMIT 200');
    echo json_encode(['success'=>true,'data'=>$stmt->fetchAll()]);
    exit;
}

if ($method === 'POST') {
    $data = getJsonBody();
    $user_id = $data['user_id'] ?? null;
    $admin_id = $data['admin_id'] ?? null;
    $type = $data['type'] ?? 'generic';
    $message = $data['message'] ?? '';
    $meta = isset($data['data']) ? json_encode($data['data']) : null;

    $stmt = $pdo->prepare('INSERT INTO notifications (user_id, admin_id, type, message, data) VALUES (:u,:a,:t,:m,:d)');
    try {
        $stmt->execute([':u'=>$user_id,':a'=>$admin_id,':t'=>$type,':m'=>$message,':d'=>$meta]);
        echo json_encode(['success'=>true,'id'=>$pdo->lastInsertId()]);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['success'=>false,'message'=>'Insert failed','error'=>$e->getMessage()]);
    }
    exit;
}

if ($method === 'PUT') {
    // mark read or update
    parse_str(file_get_contents('php://input'), $put);
    $id = isset($put['id']) ? (int)$put['id'] : null;
    $is_read = isset($put['is_read']) ? (int)$put['is_read'] : null;
    if ($id && $is_read !== null) {
        $stmt = $pdo->prepare('UPDATE notifications SET is_read = :r WHERE id = :id');
        $stmt->execute([':r'=>$is_read,':id'=>$id]);
        echo json_encode(['success'=>true]);
        exit;
    }
}

http_response_code(405);
echo json_encode(['success'=>false,'message'=>'Method not allowed']);
