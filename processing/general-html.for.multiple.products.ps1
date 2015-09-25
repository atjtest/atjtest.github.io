# generate html file from multiple image folders
# each folder should contain a list of image files and one readme.txt
# readme.txt file contain product title and price(first line), and descriptions(multiple section seprated by one line starts with '-'
#   product xxxx, $$$
#   desc1
#   desc2
#   --
#   desc3
# NOTE: readme.txt should be using unicode encoding if it contains CHINESE chars!! lines start with "#" will be ignored

function generate-html-for-products($imgsubdirs, $htmlfilename, $htmltitle, $includeheadindex=0){
	# $imgsubdirs=@('waterpik-wp130-wp305')
	# $htmlfilename='waterpik-wp130-wp305.html'
	$htmltitle = (''+$htmltitle).trim()

	$basedir='d:\Data\gitrepos\atjshop.github.io\'
	$outputfilename=$basedir+'html\'+$htmlfilename
	$welnumber = @(1,2,3,2,3,1,3,1,2)

	Write-Host '=====STARTING=====' $outputfilename 

	$htmlbar='<div class="progress"><div class="progress-bar progress-bar-info" style="width: 100%"></div></div>' # a bar to separate different products

	$iDirs=0 #number of folders processed
	$html=$htmlbar #html for all folders' image, productTitle and descriptions
	$htmltmp='<a name="p{3}"></a><div class="news"><div class="container"><h3>{0}</h3><hr/><div class="new-grids">{1}</div></div></div><div class="news"><div class="container">{2}</div></div>'
	#$htmltmp='<div class="news"><div class="container"><h3>{0}</h3><hr/><div class="new-grids">{1}</div></div></div><div class="news"><div class="container">{2}</div></div>'

	$indexhtml='' #html for the table of content
	$indexhtmltmp='<div class="col-md-4 welcome-grid"><a href="#p{0}"><div class="wel{2} hvr-bounce-to-bottom"><h4>{1}</h4></a></div></div>'

	$indexhtml1='' #holding the html for table of content, maximum 3 items

	#loop thru image folders
	foreach($dir in $imgsubdirs)
	{
	    $imgdir= $basedir +'images\' + $dir + '\' # folder path in windows
	    $imgpath='/images/' + $dir +'/'     # image path in html
	    Write-Host $imgdir ' ' $imgpath

	    if ( -not (Test-Path $imgdir) ){
	        Write-Warning  ("folder doesn't exist: " + $imgdir)
	        continue
	    }

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
	    $html+= [string]::Format($htmltmp, $productTitle, $htmlImgDivs, $htmldesc, $iDirs)
	    $html+=$htmlbar

	    $indexhtml1+=[string]::Format($indexhtmltmp,$iDirs,$productTitle,$welnumber[$iDirs%9])

	    $iDirs++

	    if($iDirs%3 -eq 0){
	        $indexhtml+='<div class="welcome"><div class="container">' + $indexhtml1 + '</div></div>' #surround every 3 items with div.
	        $indexhtml1=''
	    }
	    write-host '***dir:' $dir ', img:' $i

	} #end of each folder

	if($indexhtml1 -ne ''){
	    $indexhtml+='<div class="welcome"><div class="container">' + $indexhtml1 + '</div></div>' #surround every 3 items with div.
	}

	# $indexhtml='<div class="welcome"><div class="container">' + $indexhtml + '</div></div>'

	Write-Host $indexhtml
	Write-Host '$includeheadindex=' $includeheadindex

	if( ($iDirs -gt 1) -and ($includeheadindex -eq 1) ){ $html = $indexhtml + $html }

	#write html to file
	$stream = new-object 'System.IO.StreamWriter' -ArgumentList $outputfilename, $false
	$stream.writeline('---')
	$stream.writeline('layout: default')
	if($htmltitle -ne ''){ $stream.writeline('title: ' + $htmltitle) }
	$stream.writeline('date:  ' + [System.DateTime]::Now.ToString())
	$stream.writeline('---')
	$stream.writeline($html)
	$stream.close()

	write-host '***dirs processed:' $iDirs
	write-host '=====ENDING=====' $outputfilename

	return
}

# $imgsubdirs=@('waterpik-wp130-wp305')
# $htmlfilename='waterpik-wp130-wp305.html'
# $title = 'Waterpik豪华版水牙线套装，超值超实用，￥615'

# generate-html-for-products $imgsubdirs $htmlfilename #$title
