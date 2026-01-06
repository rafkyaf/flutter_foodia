<?php
// Payment gateway configuration (sandbox/test)
// Fill STRIPE_SECRET with your Stripe Test Secret Key to enable Stripe integration.
// If left empty, the code will use a simple internal sandbox simulator.

define('PAYMENT_GATEWAY', 'stripe'); // 'stripe' or 'sandbox'
define('STRIPE_SECRET', getenv('STRIPE_SECRET') ?: '');
define('STRIPE_WEBHOOK_SECRET', getenv('STRIPE_WEBHOOK_SECRET') ?: '');

// Base URL for your app (adjust to your local dev host)
define('APP_BASE_URL', getenv('APP_BASE_URL') ?: 'http://localhost');

return [
    'gateway' => PAYMENT_GATEWAY,
    'stripe_secret' => STRIPE_SECRET,
    'stripe_webhook_secret' => STRIPE_WEBHOOK_SECRET,
    'base_url' => APP_BASE_URL,
];
