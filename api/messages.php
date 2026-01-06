<?php
header('Content-Type: application/json; charset=utf-8');
$pdo = require __DIR__ . '/db.php';

$pdo->exec("CREATE TABLE IF NOT EXISTS messages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    from_user INT,
    to_user INT,
    content TEXT,
    metadata JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;");

// ensure notifications table exists (used for notifying message recipients)
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
    // conversation between two users: from & to params
    $u1 = isset($_GET['u1']) ? (int)$_GET['u1'] : null;
    $u2 = isset($_GET['u2']) ? (int)$_GET['u2'] : null;
    if ($u1 && $u2) {
        $stmt = $pdo->prepare('SELECT * FROM messages WHERE (from_user = :u1 AND to_user = :u2) OR (from_user = :u2 AND to_user = :u1) ORDER BY created_at ASC');
        $stmt->execute([':u1'=>$u1,':u2'=>$u2]);
        echo json_encode(['success'=>true,'data'=>$stmt->fetchAll()]);
        exit;
    }
    // unread or all for a user
    $uid = isset($_GET['user_id']) ? (int)$_GET['user_id'] : null;
    if ($uid) {
        $stmt = $pdo->prepare('SELECT * FROM messages WHERE to_user = :u ORDER BY created_at DESC');
        $stmt->execute([':u'=>$uid]);
        echo json_encode(['success'=>true,'data'=>$stmt->fetchAll()]);
        exit;
    }
    http_response_code(400);
    echo json_encode(['success'=>false,'message'=>'u1 & u2 or user_id required']);
    exit;
}

if ($method === 'POST') {
    $data = getJsonBody();
    $from = $data['from_user'] ?? null;
    $to = $data['to_user'] ?? null;
    $content = $data['content'] ?? '';
    $meta = isset($data['metadata']) ? json_encode($data['metadata']) : null;
    if (!$from || !$to) { http_response_code(400); echo json_encode(['success'=>false,'message'=>'from_user & to_user required']); exit; }
    $stmt = $pdo->prepare('INSERT INTO messages (from_user,to_user,content,metadata) VALUES (:f,:t,:c,:m)');
    try {
        $stmt->execute([':f'=>$from,':t'=>$to,':c'=>$content,':m'=>$meta]);
        // create a notification for recipient
        $msgId = $pdo->lastInsertId();
        try {
            $notif = $pdo->prepare('INSERT INTO notifications (user_id, admin_id, type, message, data) VALUES (:u, :a, :t, :m, :d)');
            $noteMsg = 'New message from user ' . $from;
            $notif->execute([':u'=>$to,':a'=>null,':t'=>'message',':m'=>$noteMsg,':d'=>json_encode(['message_id'=>$msgId])]);
        } catch (Exception $e) {
            // ignore notification failures
        }
        echo json_encode(['success'=>true,'id'=>$msgId]);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['success'=>false,'message'=>'Insert failed','error'=>$e->getMessage()]);
    }
    exit;
}

http_response_code(405);
echo json_encode(['success'=>false,'message'=>'Method not allowed']);
