# generate one html page to list all images in one folder
# assume the file name is like xxxx.price.jpg or xxx-price.jpg (other image formats are fine too)
# the price will be extracted and displayed under the image

$imgsubdir='Kipling-bag'
$title='kipling包包' # html title
$title1='kipling包包' 

$basedir='d:\Data\gitrepos\atjshop.github.io\'
$imgdir= $basedir +'images\' + $imgsubdir + '\'
$imgpath1='/images/' + $imgsubdir +'/'
$outputfilename=$basedir+'html\'+$imgsubdir.Replace('.','-') + '.html'

$html1='<div class="col-md-6 new-grid"><img src="'
$html2='" class="img-responsive" alt=""><h3>'
$html3='</h3></div>'
$html4='<div class="clearfix"></div>'

$files=Get-ChildItem -Path $imgdir –File

$i=0

$html=''
foreach ($file in $files)
{  $i++
   Write-Host $i $file.Name
   $separator='-','.'
   $namesplit=$file.Name.Split($separator)
   $price='￥'+$namesplit[$namesplit.Count-2]
   write-host $price
   $tmp=$html1+$imgpath1+$file.Name+$html2+$price+$html3
   # Write-Host $tmp
   $html=$html+$tmp
   if($i%2 -eq 0){
    # write-host $i 'even!'
    $html=$html+$html4
   }
}

$div='<div class="news"><div class="container"><h3>{0}</h3><div class="new-grids">{1}</div></div></div>'
$stream = new-object 'System.IO.StreamWriter' -ArgumentList $outputfilename, $false
$stream.writeline('---')
$stream.writeline('layout: default')
$stream.writeline('title:  ' + $title)
$stream.writeline('date:  ' + [System.DateTime]::Now.ToString())
$stream.writeline('---')
$div1=[string]::Format($div, $title1, $html)
$stream.writeline($div1)
$stream.close()

write-host '***** total files processed: ' $i
