<?php

class xml_site 
{
    public static $ajax = false;
    public static $source = null;

    public static function init() {
        self::$source = new source();
        $p = dirname(__DIR__) . DIRECTORY_SEPARATOR . "src" . DIRECTORY_SEPARATOR . "module.xml";
        // print("\np====$p");
        self::$source->add_source("MODULES", $p);
    }

    public static function include_support_files() {
        
    }
}