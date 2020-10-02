<?php
// This stub is not included in the PHAR.  It is used mainly for loading classes for testing.
if (strpos(__FILE__, ".phar") === false) {
    define('DEPENDENCY_MANAGER_PHAR', __DIR__ . "/phars/php-dependency-manager.phar");
    require_once("phar://" . DEPENDENCY_MANAGER_PHAR . "/src/class-dependency-manager.php");
    // dependency_manager::$log_dump = true;
    dependency_manager(__DIR__ . "/dependencies.xml", __DIR__ . "/phars/");
}

require_once("zobject-access.php");
require_once("zobject-bench.php");
require_once("zobject-source-check.php");
require_once("zobject-format.php");
require_once("zobject-validation.php");



spl_autoload_register(function ($name) {
    $d = (strpos(__FILE__, ".phar") === false ? __DIR__ : "phar://" . __FILE__ . "/src");

    if (file_exists("$d" . DIRECTORY_SEPARATOR . "$name.php")) require_once("$d" . DIRECTORY_SEPARATOR . "$name.php");
    else if (file_exists("$d" . DIRECTORY_SEPARATOR . "$name.php")) require_once("$d" . DIRECTORY_SEPARATOR . "$name.php");
});

__HALT_COMPILER();
