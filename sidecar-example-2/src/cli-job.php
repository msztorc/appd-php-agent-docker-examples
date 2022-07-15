<?php

// Useless facts
$jreq = file_get_contents('https://uselessfacts.jsph.pl/random.json?language=en');
$json = json_decode($jreq, true);

if (isset($json['text'])) {

    echo "\n\nUseless fact: " . $json['text'] . "\n";
    echo "source: " . $json['source'] . "\n-----------\n";
}

// Generate cool tech-savvy sounding phrases
$text = file_get_contents('https://techy-api.vercel.app/api/text');
echo "tech-savvy sounding phrase: " . $text . "\n-----------\n";

$ajson = file_get_contents('https://api.adviceslip.com/advice');
$advice_json = json_decode($ajson, true);

if (isset($advice_json['slip']['advice'])) {
    echo "Random advice: " . $advice_json['slip']['advice'] . "\n\n";
}
