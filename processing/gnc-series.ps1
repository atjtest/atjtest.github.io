. "d:\Data\gitrepos\atjshop.github.io\processing\general-html.for.multiple.products.ps1"
$imgsubdirs=@('GNC-Grape-Seed')
$htmlfilename='GNC-Grape-Seed.html'
$title = '美容圣品健安喜GNC葡萄籽精华'
# generate-html-for-products $imgsubdirs $htmlfilename $title 1
generate-html-for-products $imgsubdirs $htmlfilename $title 


$imgsubdirs=@('GNC-Super-Digestive-Enzymes')
$htmlfilename='GNC-Super-Digestive-Enzymes.html'
$title = '超级多维消化酶健安喜GNC酵素胶囊'
generate-html-for-products $imgsubdirs $htmlfilename $title 1


$imgsubdirs=@('GNC-Lutein')
$htmlfilename='GNC-Lutein.html'
$title = '键安喜GNC天然叶黄素'
generate-html-for-products $imgsubdirs $htmlfilename $title 1

$imgsubdirs=@('GNC-Soy-Isoflavone')
$htmlfilename='GNC-Soy-Isoflavone.html'
$title = '键安喜GNC纯天然异黄酮'
generate-html-for-products $imgsubdirs $htmlfilename $title 1
