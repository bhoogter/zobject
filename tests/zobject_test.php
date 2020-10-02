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
        $this->assertTrue(strlen(xml_file::toXml($res)) > 100);
    }
}
