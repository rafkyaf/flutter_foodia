<?php
header('Content-Type: application/json; charset=utf-8');
$pdo = require __DIR__ . '/db.php';

$pdo->exec("CREATE TABLE IF NOT EXISTS orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    total DECIMAL(10,2) DEFAULT 0,
    status VARCHAR(50) DEFAULT 'pending',
    payment_status VARCHAR(50) DEFAULT 'pending',
    payment_sent TINYINT(1) DEFAULT 0,
    admin_confirmed_delivery TINYINT(1) DEFAULT 0,
    user_confirmed_delivery TINYINT(1) DEFAULT 0,
    delivered_at TIMESTAMP NULL DEFAULT NULL,
    payload JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;");

$method = $_SERVER['REQUEST_METHOD'];
function getJsonBody() { $raw = file_get_contents('php://input'); return json_decode($raw, true); }

// load config (payment keys)
$config = require __DIR__ . '/config.php';

if ($method === 'GET') {
    if (isset($_GET['id'])) {
        $id = (int)$_GET['id'];
        $stmt = $pdo->prepare('SELECT * FROM orders WHERE id = :id');
        $stmt->execute([':id'=>$id]);
        echo json_encode(['success'=>true,'data'=>$stmt->fetch()]);
        exit;
    }
    if (isset($_GET['user_id'])) {
        $uid = (int)$_GET['user_id'];
        $stmt = $pdo->prepare('SELECT * FROM orders WHERE user_id = :u ORDER BY created_at DESC');
        $stmt->execute([':u'=>$uid]);
        echo json_encode(['success'=>true,'data'=>$stmt->fetchAll()]);
        exit;
    }
    $stmt = $pdo->query('SELECT * FROM orders ORDER BY created_at DESC');
    echo json_encode(['success'=>true,'data'=>$stmt->fetchAll()]);
    exit;
}

if ($method === 'POST') {
    $data = getJsonBody();
    $user_id = $data['user_id'] ?? null;
    $total = $data['total'] ?? 0;
    $payload = isset($data['payload']) ? json_encode($data['payload']) : null;
    if (!$user_id) { http_response_code(400); echo json_encode(['success'=>false,'message'=>'user_id required']); exit; }

    $stmt = $pdo->prepare('INSERT INTO orders (user_id,total,payload) VALUES (:u,:t,:p)');
    try {
        $stmt->execute([':u'=>$user_id,':t'=>$total,':p'=>$payload]);
        $orderId = $pdo->lastInsertId();
        // create notifications for admin(s)
        // try to include user name/email in notification
        $userInfo = null;
        try {
            $uStmt = $pdo->prepare('SELECT id, name, email FROM users WHERE id = :id LIMIT 1');
            $uStmt->execute([':id'=>$user_id]);
            $userInfo = $uStmt->fetch();
        } catch (Exception $e) { $userInfo = null; }

        // accept optional message from user when ordering
        $userMessage = $data['message'] ?? null;

        // find admins by role_id=2 or is_admin flag
        try {
            $admins = $pdo->query("SELECT id FROM users WHERE role_id = 2 OR is_admin = 1")->fetchAll(PDO::FETCH_COLUMN);
        } catch (Exception $e) {
            $admins = [];
        }

        // store the message into messages table (one per admin if admins present)
        if (!empty($userMessage)) {
            try {
                $stmtMsg = $pdo->prepare('INSERT INTO messages (from_user,to_user,content,metadata) VALUES (:f,:t,:c,:m)');
                $meta = json_encode(['order_id'=>$orderId]);
                if (empty($admins)) {
                    $stmtMsg->execute([':f'=>$user_id,':t'=>null,':c'=>$userMessage,':m'=>$meta]);
                } else {
                    foreach ($admins as $aid) {
                        $stmtMsg->execute([':f'=>$user_id,':t'=>$aid,':c'=>$userMessage,':m'=>$meta]);
                    }
                }
            } catch (Exception $e) {
                // ignore message save failures
            }
        }

        // build notification message and include user message in data
        $msg = 'New order #' . $orderId . ' from user ' . ($userInfo['name'] ?? $user_id) . (!empty($userMessage) ? ' - Message: ' . $userMessage : '');
        $dataForNotif = ['order_id'=>$orderId,'user'=>$userInfo,'payload'=>json_decode($payload)];
        if (!empty($userMessage)) $dataForNotif['user_message'] = $userMessage;

        if (empty($admins)) {
            // fallback create a single notification with null admin_id
            $stmt2 = $pdo->prepare('INSERT INTO notifications (user_id, admin_id, type, message, data) VALUES (:u, :a, :t, :m, :d)');
            $stmt2->execute([':u'=>$user_id,':a'=>null,':t'=>'order_created',':m'=>$msg,':d'=>json_encode($dataForNotif)]);
        } else {
            $stmt2 = $pdo->prepare('INSERT INTO notifications (user_id, admin_id, type, message, data) VALUES (:u, :a, :t, :m, :d)');
            foreach ($admins as $aid) {
                $stmt2->execute([':u'=>$user_id,':a'=>$aid,':t'=>'order_created',':m'=>$msg,':d'=>json_encode(array_merge($dataForNotif,['admin_id'=>$aid]))]);
            }
        }
        echo json_encode(['success'=>true,'order_id'=>$orderId]);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['success'=>false,'message'=>'Insert failed','error'=>$e->getMessage()]);
    }
    exit;
}

// payment webhook/update
if ($method === 'POST' && isset($_GET['action']) && $_GET['action'] === 'payment') {
    $data = getJsonBody();
    $order_id = $data['order_id'] ?? null;
    $status = $data['status'] ?? 'paid';
    if (!$order_id) { http_response_code(400); echo json_encode(['success'=>false,'message'=>'order_id required']); exit; }
    // map payment status to an explicit DB status for admin workflow
    $dbStatus = $status === 'paid' ? 'payment_received' : $status;
    $stmt = $pdo->prepare('UPDATE orders SET status = :s, payment_status = :ps WHERE id = :id');
    try {
        $stmt->execute([':s'=>$dbStatus,':ps'=>$status,':id'=>$order_id]);
        // fetch order to get user_id
        $stmt2 = $pdo->prepare('SELECT user_id FROM orders WHERE id = :id');
        $stmt2->execute([':id'=>$order_id]);
        $order = $stmt2->fetch();
        $user_id = $order ? $order['user_id'] : null;
        // notify admin(s) and user
        // include user info in payment notification
        $userInfo = null;
        try {
            $uStmt = $pdo->prepare('SELECT id, name, email FROM users WHERE id = :id LIMIT 1');
            $uStmt->execute([':id'=>$user_id]);
            $userInfo = $uStmt->fetch();
        } catch (Exception $e) { $userInfo = null; }
        $msg = 'Payment update for order #' . $order_id . ' status: ' . $status . ' by ' . ($userInfo['name'] ?? $user_id);
        try {
            $admins = $pdo->query("SELECT id FROM users WHERE role_id = 2 OR is_admin = 1")->fetchAll(PDO::FETCH_COLUMN);
        } catch (Exception $e) {
            $admins = [];
        }
        $dataJson = json_encode(['order_id'=>$order_id,'status'=>$status,'user'=>$userInfo]);
        if (empty($admins)) {
            $stmt3 = $pdo->prepare('INSERT INTO notifications (user_id, admin_id, type, message, data) VALUES (:u, :a, :t, :m, :d)');
            $stmt3->execute([':u'=>$user_id,':a'=>null,':t'=>'payment',':m'=>$msg,':d'=>$dataJson]);
        } else {
            $stmt3 = $pdo->prepare('INSERT INTO notifications (user_id, admin_id, type, message, data) VALUES (:u, :a, :t, :m, :d)');
            foreach ($admins as $aid) {
                $stmt3->execute([':u'=>$user_id,':a'=>$aid,':t'=>'payment',':m'=>$msg,':d'=>$dataJson]);
            }
        }
        echo json_encode(['success'=>true]);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['success'=>false,'message'=>'Update failed','error'=>$e->getMessage()]);
    }
    exit;
}

// create payment session / request
if ($method === 'POST' && isset($_GET['action']) && $_GET['action'] === 'create_payment') {
    $data = getJsonBody();
    $order_id = $data['order_id'] ?? null;
    $amount = isset($data['amount']) ? (int)round($data['amount'] * 100) : null; // amount in cents
    $currency = $data['currency'] ?? 'usd';
    if (!$order_id || !$amount) { http_response_code(400); echo json_encode(['success'=>false,'message'=>'order_id and amount required']); exit; }

    if ($config['gateway'] === 'stripe' && !empty($config['stripe_secret'])) {
        // Create Stripe PaymentIntent via HTTP API (test mode)
        $ch = curl_init('https://api.stripe.com/v1/payment_intents');
        $post = http_build_query([
            'amount' => $amount,
            'currency' => $currency,
            'metadata[order_id]' => $order_id,
        ]);
        curl_setopt($ch, CURLOPT_POST, 1);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $post);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_USERPWD, $config['stripe_secret'] . ':');
        $resp = curl_exec($ch);
        $code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        if ($code >= 200 && $code < 300) {
            $json = json_decode($resp, true);
            // return client_secret for client-side confirmation
            echo json_encode(['success'=>true,'provider'=>'stripe','client_secret'=>$json['client_secret'],'payment_intent'=>$json]);
            exit;
        } else {
            http_response_code(500);
            echo json_encode(['success'=>false,'message'=>'Stripe API error','detail'=>$resp]);
            exit;
        }
    }

    // fallback: sandbox simulator - create a simple payment token and URL
    $token = bin2hex(random_bytes(12));
    $paymentUrl = rtrim($config['base_url'], '/') . '/api/sandbox_pay.php?token=' . $token . '&order_id=' . urlencode($order_id);
    // store a simple record in notifications table to simulate pending payment (optional)
    try {
        $stmt = $pdo->prepare('INSERT INTO notifications (user_id, admin_id, type, message, data) VALUES (:u,:a,:t,:m,:d)');
        $stmt->execute([':u'=>null,':a'=>null,':t'=>'sandbox_payment_created',':m'=>'Sandbox payment created',':d'=>json_encode(['order_id'=>$order_id,'token'=>$token])]);
    } catch (Exception $e) {}

    echo json_encode(['success'=>true,'provider'=>'sandbox','payment_token'=>$token,'payment_url'=>$paymentUrl]);
    exit;
}

// admin marks order as sent (items shipped)
if ($method === 'POST' && isset($_GET['action']) && $_GET['action'] === 'sent') {
    $data = getJsonBody();
    $order_id = $data['order_id'] ?? null;
    $admin_id = $data['admin_id'] ?? null;
    if (!$order_id || !$admin_id) { http_response_code(400); echo json_encode(['success'=>false,'message'=>'order_id and admin_id required']); exit; }
    try {
        $stmt->execute([':s'=>'ON DELIVERY',':id'=>$order_id]);
        // notify user
        $stmt2 = $pdo->prepare('SELECT user_id FROM orders WHERE id = :id');
        $stmt2->execute([':id'=>$order_id]);
        $order = $stmt2->fetch();
        $user_id = $order ? $order['user_id'] : null;
        $msg = 'Your order #' . $order_id . ' has been shipped.';
        $stmt3 = $pdo->prepare('INSERT INTO notifications (user_id, admin_id, type, message, data) VALUES (:u, :a, :t, :m, :d)');
        $stmt3->execute([':u'=>$user_id,':a'=>$admin_id,':t'=>'order_sent',':m'=>$msg,':d'=>json_encode(['order_id'=>$order_id])]);
        echo json_encode(['success'=>true]);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['success'=>false,'message'=>'Update failed','error'=>$e->getMessage()]);
    }
    exit;
}

// admin confirms that order has arrived (admin detected delivery)
if ($method === 'POST' && isset($_GET['action']) && $_GET['action'] === 'admin_confirm_delivery') {
    $data = getJsonBody();
    $order_id = $data['order_id'] ?? null;
    $admin_id = $data['admin_id'] ?? null;
    if (!$order_id || !$admin_id) { http_response_code(400); echo json_encode(['success'=>false,'message'=>'order_id and admin_id required']); exit; }
    $stmt = $pdo->prepare('UPDATE orders SET admin_confirmed_delivery = 1, status = :s, delivered_at = CURRENT_TIMESTAMP WHERE id = :id');
    try {
        $stmt->execute([':s'=>'delivered',':id'=>$order_id]);
        // notify user to confirm
        $stmt2 = $pdo->prepare('SELECT user_id FROM orders WHERE id = :id');
        $stmt2->execute([':id'=>$order_id]);
        $order = $stmt2->fetch();
        $user_id = $order ? $order['user_id'] : null;
        $msg = 'Admin marked order #' . $order_id . ' as delivered. Please confirm receipt.';
        $stmt3 = $pdo->prepare('INSERT INTO notifications (user_id, admin_id, type, message, data) VALUES (:u, :a, :t, :m, :d)');
        $stmt3->execute([':u'=>$user_id,':a'=>$admin_id,':t'=>'admin_confirmed_delivery',':m'=>$msg,':d'=>json_encode(['order_id'=>$order_id])]);
        echo json_encode(['success'=>true]);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['success'=>false,'message'=>'Update failed','error'=>$e->getMessage()]);
    }
    exit;
}

// user confirms delivery (user confirms they received the order)
if ($method === 'POST' && isset($_GET['action']) && $_GET['action'] === 'user_confirm_delivery') {
    $data = getJsonBody();
    $order_id = $data['order_id'] ?? null;
    $user_id = $data['user_id'] ?? null;
    if (!$order_id || !$user_id) { http_response_code(400); echo json_encode(['success'=>false,'message'=>'order_id and user_id required']); exit; }
    $stmt = $pdo->prepare('UPDATE orders SET user_confirmed_delivery = 1 WHERE id = :id');
    try {
        $stmt->execute([':id'=>$order_id]);
        // notify admins
        try {
            $admins = $pdo->query("SELECT id FROM users WHERE role_id = 2 OR is_admin = 1")->fetchAll(PDO::FETCH_COLUMN);
        } catch (Exception $e) { $admins = []; }
        $msg = 'User confirmed delivery for order #' . $order_id . '.';
        $stmt3 = $pdo->prepare('INSERT INTO notifications (user_id, admin_id, type, message, data) VALUES (:u, :a, :t, :m, :d)');
        if (empty($admins)) {
            $stmt3->execute([':u'=>$user_id,':a'=>null,':t'=>'user_confirmed_delivery',':m'=>$msg,':d'=>json_encode(['order_id'=>$order_id])]);
        } else {
            foreach ($admins as $aid) {
                $stmt3->execute([':u'=>$user_id,':a'=>$aid,':t'=>'user_confirmed_delivery',':m'=>$msg,':d'=>json_encode(['order_id'=>$order_id])]);
            }
        }
        echo json_encode(['success'=>true]);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['success'=>false,'message'=>'Update failed','error'=>$e->getMessage()]);
    }
    exit;
}

// admin verifies order -> change status to 'verified' and notify user
if ($method === 'POST' && isset($_GET['action']) && $_GET['action'] === 'verify') {
    $data = getJsonBody();
    $order_id = $data['order_id'] ?? null;
    $admin_id = $data['admin_id'] ?? null;
    $note = $data['note'] ?? null;
    if (!$order_id || !$admin_id) { http_response_code(400); echo json_encode(['success'=>false,'message'=>'order_id and admin_id required']); exit; }
    // When admin verifies/accepts the order, mark it as ON DELIVERY so it appears in tracking
    $stmt = $pdo->prepare('UPDATE orders SET status = :s, payment_sent = 1 WHERE id = :id');
    try {
        $stmt->execute([':s'=>'ON DELIVERY',':id'=>$order_id]);
        // fetch order and user
        $stmt2 = $pdo->prepare('SELECT user_id, payload FROM orders WHERE id = :id');
        $stmt2->execute([':id'=>$order_id]);
        $order = $stmt2->fetch();
        $user_id = $order ? $order['user_id'] : null;
        $payload = $order ? $order['payload'] : null;
        // notify user that order is verified
        $stmt3 = $pdo->prepare('INSERT INTO notifications (user_id, admin_id, type, message, data) VALUES (:u, :a, :t, :m, :d)');
        $message = 'Your order #' . $order_id . ' has been accepted and is now out for delivery.' . ($note ? ' Note: ' . $note : '');
        $stmt3->execute([':u'=>$user_id,':a'=>$admin_id,':t'=>'order_accepted',':m'=>$message,':d'=>json_encode(['order_id'=>$order_id,'payload'=>json_decode($payload),'admin_id'=>$admin_id,'note'=>$note])]);
        echo json_encode(['success'=>true]);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['success'=>false,'message'=>'Update failed','error'=>$e->getMessage()]);
    }
    exit;
}

http_response_code(405);
echo json_encode(['success'=>false,'message'=>'Method not allowed']);
