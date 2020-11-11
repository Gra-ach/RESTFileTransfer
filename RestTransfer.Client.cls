Class RestTransfer.Client Extends %ZEN.DataModel.Adaptor
{

Parameter Server = "localhost";

Parameter Port = 52773;

Parameter Https = 0;

ClassMethod GetLink() As %Net.HttpRequest
{
	
 Set request = ##class(%Net.HttpRequest).%New() 		
 Set request.Server = ..%GetParameter("Server")
 Set request.Port = ..%GetParameter("Port")
 set request.ContentType = "application/base64" 		
 quit request
}

ClassMethod SendFile(aFileName) As %Status
{
 Set sc = $$$OK
 Set request = ..GetLink()
  
 set s = ##class(%Stream.FileBinary).%New()
 set s.Filename = aFileName
 
 if s.Size > 3459000 {   //3641144 max length of the string in IRIS  5%
 
	do request.EntityBody.Write("{""Name"":"""_s.Filename_""", ""File"":""") 	 
 	While 's.AtEnd {	
	    set temp = s.Read(.len, .sc)
	    do request.EntityBody.Write($ZCONVERT(temp, "O", "RAW"))	    
	    Quit:$System.Status.IsError(sc)
 	} 	
 	do request.EntityBody.Write("""}")   
	set sc = request.Post("/RestTransfer/json")			
 } else
 {
	set p = ##class(%ZEN.proxyObject).%New()
 	set p.Name = s.Filename 
 	While 's.AtEnd {	
	    set p.File = p.File_s.Read(.len, .sc)	    	    
		Quit:$System.Status.IsError(sc)
	} 	
 	set sc = ##class(%ZEN.Auxiliary.jsonProvider).%WriteJSONStreamFromObject(request.EntityBody, p)
 	Quit:$System.Status.IsError(sc)
 	set sc = request.Post("/RestTransfer/jsons")				 
 }
	 
 Quit:$System.Status.IsError(sc)
 
 Set response=request.HttpResponse
 do response.OutputToDevice()
  
 Quit sc
}

ClassMethod SendFileT(aFileName) As %Status
{
 Set sc = $$$OK
 Set request = ..GetLink()  
 set s = ##class(%Stream.FileBinary).%New()
 set s.Filename = aFileName 
 
 set p = ##class(%ZEN.proxyObject).%New()
 set p.Name = s.Filename 
 While 's.AtEnd {	
	set p.File = p.File_s.Read(.len, .sc)	    	    
	Quit:$System.Status.IsError(sc)
 } 	
 set sc = ##class(%ZEN.Auxiliary.jsonProvider).%WriteJSONStreamFromObject(request.EntityBody, p)
 Quit:$System.Status.IsError(sc)
 
 set sc = request.Post("/RestTransfer/jsons")				 
 Quit:$System.Status.IsError(sc)
 
 Set response=request.HttpResponse
 do response.OutputToDevice()
  
 Quit sc
}

ClassMethod SendFileDirect(aFileName) As %Status
{
 Set sc = $$$OK
  
 Set request = ..GetLink()
  
 set s = ##class(%Stream.FileBinary).%New()
 set s.Filename = aFileName
 While 's.AtEnd {
	do request.EntityBody.Write(s.Read(.len, .sc))	
	Quit:$System.Status.IsError(sc)
 } 
 Quit:$System.Status.IsError(sc)
 
 set sc = request.Post("/RestTransfer/file")			
 Quit:$System.Status.IsError(sc)
 
 Set response=request.HttpResponse
 do response.OutputToDevice()
 
 Quit sc
}

ClassMethod Run()
{
	
	/*set resp1=##class(RestTransfer.Client).SendFileDirect("D:\Downloads\2020_1012_114732_020.JPG")	      
	set resp1=##class(RestTransfer.Client).SendFileDirect("D:\Downloads\Archive.xml")	      
	set resp1=##class(RestTransfer.Client).SendFileDirect("D:\Downloads\arc-setup.exe")	      */
	  	
   	set resp1=##class(RestTransfer.Client).SendFile("D:\Downloads\Outline Template.pdf")	      
   	if $$$ISERR(resp1) do $System.OBJ.DisplayError(resp1)
   	set resp1=##class(RestTransfer.Client).SendFileDirect("D:\Downloads\Outline Template.pdf")	      
   	if $$$ISERR(resp1) do $System.OBJ.DisplayError(resp1)
   	
   	set resp1=##class(RestTransfer.Client).SendFile("D:\Downloads\pic3.png")	      
   	if $$$ISERR(resp1) do $System.OBJ.DisplayError(resp1)   	
   	set resp1=##class(RestTransfer.Client).SendFileDirect("D:\Downloads\pic3.png")	      
   	if $$$ISERR(resp1) do $System.OBJ.DisplayError(resp1)
   	   	   	
   	set resp1=##class(RestTransfer.Client).SendFile("D:\Downloads\Archive (1).xml")	      
   	if $$$ISERR(resp1) do $System.OBJ.DisplayError(resp1)
   	set resp1=##class(RestTransfer.Client).SendFileDirect("D:\Downloads\Archive (1).xml")	      
   	if $$$ISERR(resp1) do $System.OBJ.DisplayError(resp1)
   	
   	set resp1=##class(RestTransfer.Client).SendFile("D:\Downloads\Imagine Dragons-Thunder.mp3")	      
   	if $$$ISERR(resp1) do $System.OBJ.DisplayError(resp1)
   	set resp1=##class(RestTransfer.Client).SendFileDirect("D:\Downloads\Imagine Dragons-Thunder.mp3")	      
   	if $$$ISERR(resp1) do $System.OBJ.DisplayError(resp1)
   	
   	set resp1=##class(RestTransfer.Client).SendFile("D:\Downloads\ffmpeg-win-2.2.2.exe")	      
   	if $$$ISERR(resp1) do $System.OBJ.DisplayError(resp1)
   	set resp1=##class(RestTransfer.Client).SendFileDirect("D:\Downloads\ffmpeg-win-2.2.2.exe")	      
   	if $$$ISERR(resp1) do $System.OBJ.DisplayError(resp1)
}

}
