<?php
header('Content-Type: application/json; charset=utf-8');
$pdo = require __DIR__ . '/db.php';

// Ensure products table exists
$pdo->exec("CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL DEFAULT 0,
    image_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;");

// Seed sample data if empty
$count = (int)$pdo->query('SELECT COUNT(*) FROM products')->fetchColumn();
if ($count === 0) {
    $stmt = $pdo->prepare('INSERT INTO products (name, description, price, image_url) VALUES (:n,:d,:p,:i)');
    $samples = [
        ['name'=>'Nasi Goreng','description'=>'Nasi goreng spesial','price'=>15000,'image'=>''],
        ['name'=>'Mie Ayam','description'=>'Mie ayam porsi besar','price'=>12000,'image'=>''],
        ['name'=>'Sate Ayam','description'=>'Sate ayam lengkap dengan bumbu','price'=>20000,'image'=>'']
    ];
    foreach ($samples as $s) $stmt->execute([':n'=>$s['name'],':d'=>$s['description'],':p'=>$s['price'],':i'=>$s['image']]);
}

$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'GET') {
    $stmt = $pdo->query('SELECT id, name, description, price, image_url FROM products ORDER BY created_at DESC');
    $rows = $stmt->fetchAll();
    echo json_encode(['success'=>true,'data'=>$rows]);
    exit;
}

http_response_code(405);
echo json_encode(['success'=>false,'message'=>'Method not allowed']);
