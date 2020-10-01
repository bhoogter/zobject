<?php


declare(strict_types=1);

use PHPUnit\Framework\TestCase;

class zobject_test extends TestCase
{
    public static function setUpBeforeClass(): void
    {
    }

    public function testSetupIsOk(): void {
        $this->assertTrue(true);
    }

    public function testMergeTransformXsl() {
        $res = zobject::merge_xsl();
        // print_r($res->saveXML());
    }
}
