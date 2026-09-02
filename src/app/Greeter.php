<?php

declare(strict_types=1);

namespace HTLW3R\WHP;

class Greeter
{
    public function hello(string $name): string
    {
        return "Hallo, {$name}!";
    }
}
