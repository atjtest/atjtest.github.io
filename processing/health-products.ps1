. "d:\Data\gitrepos\atjshop.github.io\processing\general-html.for.multiple.products.ps1"
$imgsubdirs=@('NatureMade-Fishoil-200x2','schiff-melatonin-3mg','NatureMade-Flaxseed-Oil','Trunature-grape-seed','Trunature-lutein','Trunature-Cranberry','NatureMade-CoQ10')
$htmlfilename='nutrition-health.html'
$title = '营养保健品系列'
generate-html-for-products $imgsubdirs $htmlfilename $title 1
