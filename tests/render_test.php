<?php


declare(strict_types=1);

use PHPUnit\Framework\TestCase;

class render_test extends TestCase
{
    public static function setUpBeforeClass(): void
    {
        require_once("test_logger.php");
        require_once("test_site.php");
        xml_site::init();

        php_logger::$on = true;
    }
    
    public function testSetupIsOk(): void {
        print "\n----------\n";
        print "\nLST=" . print_r(xml_site::$source->lst("//MODULES/modules/module/zobjectdef/@name"));
        print "\nLST0=" . print_r(xml_site::$source->lst("//MODULES/modules/module/zobjectdef/@name")[0]);
        print "\nMATCH=" . zobject::FetchObjPart("y_datatype", "@name");
        php_logger::$on = true;
        php_logger::call();
        $result = zobject::render_object('y_datatype', [ 'mode' => 'display'], 'T=email');
        print $result;
    }

}
