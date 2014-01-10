<?php

if (count($argv) != 4){
    throw new Exception(
        sprintf('Invalid arguments passed')
);
}

$default_php_fpm_ini = parse_ini_file($argv[1], true, INI_SCANNER_RAW);
$custom_php_fpm_ini = parse_ini_file($argv[2], true, INI_SCANNER_RAW);

$configuration = array_replace_recursive($default_php_fpm_ini, $custom_php_fpm_ini);

$content = '';
$sections = '';
$globals = '';
if (!empty($configuration)) {
    foreach ($configuration as $section => $item) {
        if (!is_array($item)) {
            $globals .= $section . ' = ' . $item . "\n";
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
                        $arrkey = $key . '[' . $arrkey . ']';
                        $sections .= $arrkey . ' = ' . $arrvalue
                                    . "\n";
                    }
                } else {
                    $sections .= $key . ' = ' . $value . "\n";
                }
            }
        }
    }
    $content .= $sections;
}

$filename = $argv[3];

if (false === file_put_contents($filename, $content)) {
    throw new Exception(
        sprintf(
            'failed to write file `%s\' for writing.', $filename
        )
    );
}

?>
