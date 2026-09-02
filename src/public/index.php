<?php

declare(strict_types=1);

// Autoloader liegt eine Ebene über dem Web-Root (public/).
require __DIR__ . '/../vendor/autoload.php';

use HTLW3R\WHP\Greeter;

$greeter = new Greeter();

echo $greeter->hello('Welt');
