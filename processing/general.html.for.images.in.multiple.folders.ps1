# generate html file from multiple image folders
# each folder should contain a list of image files and one readme.txt
# readme.txt file contain product title and price(first line), and descriptions(multiple section seprated by one line starts with '-'
#   product xxxx, $$$
#   desc1
#   desc2
#   --
#   desc3
# NOTE: readme.txt should be using unicode encoding if it contains CHINESE chars!! lines start with "#" will be ignored

$imgsubdirs='mia2.1', 'mia2.2'
$htmlfilename='mia22.html'

$basedir='d:\Data\gitrepos\atjshop.github.io\'
$outputfilename=$basedir+'html\'+$htmlfilename

Write-Host $outputfilename 

#loop thru image folders
$iDirs=0
$html=''
#$htmltmp='<div class="news"><div class="container"><h3><a name="#p{3}">{0}</a></h3><hr/><div class="new-grids">{1}</div></div></div><div class="news"><div class="container">{2}</div></div>'
$htmltmp='<div class="news"><div class="container"><h3>{0}</h3><hr/><div class="new-grids">{1}</div></div></div><div class="news"><div class="container">{2}</div></div>'
foreach($dir in $imgsubdirs)
{
    $imgdir= $basedir +'images\' + $dir + '\' # folder path in windows
    $imgpath='/images/' + $dir +'/'     # image path in html
    Write-Host $imgdir ' ' $imgpath
    $files=Get-ChildItem -Path $imgdir –File

    $i=0
    $productTitle=''
    $htmlImgDivs=''
    $htmlImgDiv='<div class="col-md-4 view"><a href="{0}" data-lightbox=s><img src="{0}" class="img-responsive"/></a></div>'
    $htmldesc='<div class="news"><div class="container">'
    foreach ($file in $files)
    {  
      if($file.Name -match "readme.txt"){
        # read the content of readme.txt, first line is title, rest of them are descriptions
        $readme=$imgdir+'readme.txt'
        $reader = [System.IO.File]::OpenText($readme)


        try {
            $isFirstline=1
            for(;;) {
                $line = $reader.ReadLine()
                if ($line -eq $null) { break }
                $line = $line.Trim()
                if(($line -eq "") -or ($line.StartsWith("#"))) { continue }
                # process the line
                if($isFirstline -eq 1){
                    $productTitle = $line
                    $isFirstline = 0
                }elseif($line.StartsWith('-')){
                    $htmldesc+='<hr/>'
                }else{
                    $htmldesc+='<h4>'+$line+'</h4><br/>'
                }
            } #end of for each line in readme.txt
            $htmldesc+='</div></div>'
        }
        finally {
            $reader.Close()
        }
        write-host $productTitle ':' $htmldesc

      } #end of reading file readme.txt
      
      if(($file.Name -match ".jpg") -or ($file.Name -match ".png")){
        $i++
        Write-Host $i $file.Name
        $htmlImgDivs+=[string]::Format($htmlImgDiv,$imgpath+$file)
      } #end of handing each image file      

    } #end of each file in one folder
    #$html+= [string]::Format($htmltmp, $productTitle, $htmlImgDivs, $htmldesc, $iDirs)
    $html+= [string]::Format($htmltmp, $productTitle, $htmlImgDivs, $htmldesc)
    $html+='<div class="progress"><div class="progress-bar progress-bar-info" style="width: 100%"></div></div>'

    write-host '***dir:' $dir ', img:' $i
    $iDirs++
} #end of each folder

#write html to file
$stream = new-object 'System.IO.StreamWriter' -ArgumentList $outputfilename, $false
$stream.writeline('---')
$stream.writeline('layout: default')
$stream.writeline('date:  ' + [System.DateTime]::Now.ToString())
$stream.writeline('---')
$stream.writeline($html)
$stream.close()

write-host '***dirs processed:' $iDirs
write-host '***outputfile:' $outputfilename

return
