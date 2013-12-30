<?php

$files = $argv;

if (count($files) != 4){
    throw new Exception(
        sprintf('Invalid arguments passed')
);
}

$default_php_fpm_ini = parse_ini_file($files[1], true, INI_SCANNER_RAW);
$custom_php_fpm_ini = parse_ini_file($files[2], true, INI_SCANNER_RAW);

$configuration = array_replace_recursive($default_php_fpm_ini, $custom_php_fpm_ini);

$content = '';
$sections = '';
$globals = '';
if (!empty($configuration)) {
    foreach ($configuration as $section => $item) {
        if (!is_array($item)) {
            $value = $item;
            $globals .= $section . ' = ' . $value . "\n";
        }
    }
    $content .= $globals;
    foreach ($configuration as $section => $item) {
        if (is_array($item)) {
            $sections .= "\n"
                        . "[" . $section . "]" . "\n";
            foreach ($item as $key => $value) {
                if (is_array($value)) {
                    foreach ($value as $arrkey => $arrvalue) {
                        //$arrvalue = $this->normalizeValue($arrvalue);
                        $arrkey = $key . '[' . $arrkey . ']';
                        $sections .= $arrkey . ' = ' . $arrvalue
                                    . "\n";
                    }
                } else {
                    //$value = $this->normalizeValue($value);
                    $sections .= $key . ' = ' . $value . "\n";
                }
            }
        }
    }
    $content .= $sections;
}

$filename = $files[3];

if (false === file_put_contents($filename, $content)) {
    throw new Exception(
        sprintf(
            'failed to write file `%s\' for writing.', $filename
        )
    );
}

?>
