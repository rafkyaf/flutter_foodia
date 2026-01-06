<?php
// Simple sandbox payment page to simulate a user completing payment.
// Access: /api/sandbox_pay.php?token=...&order_id=...
$token = $_GET['token'] ?? null;
$order_id = $_GET['order_id'] ?? null;
if (!$token || !$order_id) {
    http_response_code(400);
    echo "Missing token or order_id";
    exit;
}
?>
<!doctype html>
<html>
<head><meta charset="utf-8"><title>Sandbox Pay</title></head>
<body>
  <h2>Sandbox Payment</h2>
  <p>Order ID: <?php echo htmlspecialchars($order_id); ?></p>
  <form method="post" action="/api/payment_webhook.php">
    <input type="hidden" name="order_id" value="<?php echo htmlspecialchars($order_id); ?>" />
    <input type="hidden" name="status" value="paid" />
    <button type="submit">Simulate Pay (mark paid)</button>
  </form>
</body>
</html>
