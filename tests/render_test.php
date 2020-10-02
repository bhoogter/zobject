<?php


declare(strict_types=1);

use PHPUnit\Framework\TestCase;

class render_test extends TestCase
{
    public static function setUpBeforeClass(): void
    {
        require_once("test_logger.php");
        require_once("test_serve.php");
        require_once("test_site.php");
        xml_serve::$types = "zobject";
        xml_site::init();

        php_logger::$on = false;
    }

    public function testRender(): void
    {
        // php_logger::$on = true;
        php_logger::call();
        $result = xml_file::toXml(zobject::render_object('y_datatype', ['mode' => 'display'], 'T=email'));
        $this->assertTrue(strlen($result) > 100);
    }
}
