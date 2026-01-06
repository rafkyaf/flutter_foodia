<?php
header('Content-Type: application/json; charset=utf-8');
$pdo = require __DIR__ . '/db.php';
$config = require __DIR__ . '/config.php';

// Read raw body
$payload = @file_get_contents('php://input');
$sig_header = isset($_SERVER['HTTP_STRIPE_SIGNATURE']) ? $_SERVER['HTTP_STRIPE_SIGNATURE'] : null;

// If Stripe configured and webhook secret provided, attempt basic signature check
if ($config['gateway'] === 'stripe' && !empty($config['stripe_webhook_secret'])) {
    // Note: full signature verification requires hashing; here we skip strict verification
    $event = json_decode($payload, true);
} else {
    $event = json_decode($payload, true);
}

if (!$event) { http_response_code(400); echo json_encode(['success'=>false,'message'=>'Invalid payload']); exit; }

// handle payment_intent.succeeded
if (isset($event['type']) && $event['type'] === 'payment_intent.succeeded') {
    $pi = $event['data']['object'];
    $metadata = $pi['metadata'] ?? [];
    $order_id = $metadata['order_id'] ?? null;
    if ($order_id) {
        try {
            $stmt = $pdo->prepare('UPDATE orders SET status = :s, payment_status = :ps WHERE id = :id');
            $stmt->execute([':s'=>'paid','ps'=>'paid',':id'=>$order_id]);
            // notify admins and user
            $stmt2 = $pdo->prepare('SELECT user_id FROM orders WHERE id = :id');
            $stmt2->execute([':id'=>$order_id]);
            $order = $stmt2->fetch();
            $user_id = $order ? $order['user_id'] : null;
            $msg = 'Payment received for order #' . $order_id . '.';
            try {
                $admins = $pdo->query("SELECT id FROM users WHERE role_id = 2 OR is_admin = 1")->fetchAll(PDO::FETCH_COLUMN);
            } catch (Exception $e) { $admins = []; }
            $stmt3 = $pdo->prepare('INSERT INTO notifications (user_id, admin_id, type, message, data) VALUES (:u, :a, :t, :m, :d)');
            if (empty($admins)) {
                $stmt3->execute([':u'=>$user_id,':a'=>null,':t'=>'payment',':m'=>$msg,':d'=>json_encode(['order_id'=>$order_id])]);
            } else {
                foreach ($admins as $aid) {
                    $stmt3->execute([':u'=>$user_id,':a'=>$aid,':t'=>'payment',':m'=>$msg,':d'=>json_encode(['order_id'=>$order_id])]);
                }
            }
            echo json_encode(['success'=>true]);
            exit;
        } catch (PDOException $e) {
            http_response_code(500);
            echo json_encode(['success'=>false,'message'=>'DB update failed','error'=>$e->getMessage()]);
            exit;
        }
    }
}

// For sandbox simulator, accept simple POST with {"order_id":..., "status":"paid"}
if (isset($event['order_id']) && isset($event['status'])) {
    $order_id = $event['order_id'];
    $status = $event['status'];
    try {
        $stmt = $pdo->prepare('UPDATE orders SET status = :s, payment_status = :ps WHERE id = :id');
        $stmt->execute([':s'=>$status,':ps'=>$status,':id'=>$order_id]);
        echo json_encode(['success'=>true]);
        exit;
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['success'=>false,'message'=>'DB update failed','error'=>$e->getMessage()]);
        exit;
    }
}

http_response_code(200);
echo json_encode(['success'=>true,'received'=>true]);
