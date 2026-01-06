-- foodia_db.sql
-- Database dan schema untuk Foodia: roles, users, dan password reset support

-- Buat database
CREATE DATABASE IF NOT EXISTS `foodia_db`
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE `foodia_db`;

CREATE TABLE IF NOT EXISTS `roles` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

  payment_status VARCHAR(50) DEFAULT 'pending',
  payment_sent TINYINT(1) DEFAULT 0,
  admin_confirmed_delivery TINYINT(1) DEFAULT 0,
  user_confirmed_delivery TINYINT(1) DEFAULT 0,
  delivered_at TIMESTAMP NULL DEFAULT NULL,
-- Tabel users (dengan kolom untuk register & verification)
CREATE TABLE IF NOT EXISTS `users` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `username` VARCHAR(100) NOT NULL UNIQUE,
  `password` VARCHAR(255) NOT NULL,
  `role_id` INT NOT NULL,
  `name` VARCHAR(200),
  `email` VARCHAR(200) NOT NULL UNIQUE,
  `is_active` TINYINT(1) NOT NULL DEFAULT 1,
  `email_verified` TINYINT(1) NOT NULL DEFAULT 0,
  `verification_token` VARCHAR(255) DEFAULT NULL,
  `verification_expires_at` DATETIME DEFAULT NULL,
  `last_login` DATETIME DEFAULT NULL,
  `password_changed_at` DATETIME DEFAULT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`role_id`) REFERENCES `roles`(`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabel untuk menyimpan token reset password (forgot password)
CREATE TABLE IF NOT EXISTS `password_reset_tokens` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT NOT NULL,
  `token` VARCHAR(255) NOT NULL UNIQUE,
  `expires_at` DATETIME NOT NULL,
  `used` TINYINT(1) NOT NULL DEFAULT 0,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Index untuk pencarian cepat berdasarkan email
CREATE INDEX idx_users_email ON users (email);

-- Masukkan role standar
INSERT INTO `roles` (`name`) VALUES ('customer'), ('restaurant')
  ON DUPLICATE KEY UPDATE name = VALUES(name);

-- Masukkan user contoh (password di-hash dengan SHA2 untuk contoh)
INSERT INTO `users` (`username`, `password`, `role_id`, `name`, `email`, `email_verified`) VALUES
('palai', SHA2('palai123',256), (SELECT id FROM roles WHERE name='customer'), 'Palai', 'palai@example.com', 1),
('foodiaadmin', SHA2('adminfoodia12345',256), (SELECT id FROM roles WHERE name='restaurant'), 'Foodia Admin', 'admin@foodia.local', 1)
ON DUPLICATE KEY UPDATE username=VALUES(username);

-- Contoh: membuat token reset (contoh; biasanya dibuat oleh aplikasi)
-- INSERT INTO password_reset_tokens (user_id, token, expires_at) VALUES ((SELECT id FROM users WHERE username='palai'), 'example-token-123', DATE_ADD(NOW(), INTERVAL 1 HOUR));

-- Catatan: Untuk produksi, gunakan hashing yang lebih kuat (bcrypt) di aplikasi, dan jangan simpan token plain-text tanpa enkripsi atau expiration handling.
