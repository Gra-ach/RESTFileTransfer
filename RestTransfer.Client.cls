Class RestTransfer.Client
{

Parameter Server = "localhost";

Parameter Port = 52774;

Parameter Https = 0;

ClassMethod GetLink() As %Net.HttpRequest
{
	
 Set request = ##class(%Net.HttpRequest).%New() 		
 Set request.Server = ..#Server
 Set request.Port = ..#Port
 set request.ContentType = "application/octet-stream" 		
 quit request
}

ClassMethod Base64EncodeStream(pStream As %Stream, Output pEncoded As %Stream) As %Status
{
  s tSC=$$$OK
  try {
    s tSC=pStream.Rewind()
    q:$$$ISERR(tSC)

    s pEncoded=##class(%Stream.TmpCharacter).%New()
    while 'pStream.AtEnd {
      s tLen=24573 
      s tSC=pEncoded.Write($system.Encryption.Base64Encode(pStream.Read(.tLen)))
      q:$$$ISERR(tSC)
    }
    q:$$$ISERR(tSC)
        
    s tSC=pEncoded.Rewind()
  } catch (e) {
    s tSC=e.AsStatus()
  }
  q tSC
}

ClassMethod SendFile(aFileName) As %Status
{
 Set sc = $$$OK
 Set request = ..GetLink()
  
 set s = ##class(%Stream.FileBinary).%New()
 set s.Filename = aFileName
  
 if s.Size > 2000000 {   //3641144 max length of the string in IRIS   
	do request.EntityBody.Write("{""Name"":"""_s.Filename_""", ""File"":""") 	 
 	While 's.AtEnd {		    
	    do request.EntityBody.Write($ZCONVERT(s.Read(.len, .sc),"O", "RAW"))
	    Quit:$System.Status.IsError(sc)
 	} 	
 	do request.EntityBody.Write("""}")   
 	set sc = request.Post("/RestTransfer/json")		
  } else
  {
	set p = {}
 	set p.Name = s.Filename 
 	
 	set sc = ..Base64EncodeStream(s, .t)
 	Quit:$System.Status.IsError(sc)
 	
 	While 't.AtEnd {	
		set p.File = p.File_t.Read(.len, .sc)
		Quit:$System.Status.IsError(sc)
 	}  
 	do p.%ToJSON(request.EntityBody) 	
 	Quit:$System.Status.IsError(sc) 	 	
 	set sc = request.Post("/RestTransfer/jsons")
  }  
  Quit:$System.Status.IsError(sc) sc
 
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
 Quit:$System.Status.IsError(sc) sc
 
 Set response=request.HttpResponse
 do response.OutputToDevice()
 
 Quit sc
}

ClassMethod SendFileChunked(aFileName) As %Status
{
 Set sc = $$$OK  
 Set request = ..GetLink()
 
 set cw = ##class(RestTransfer.ChunkedWriter).%New()
 set cw.Filename = aFileName
 set request.EntityBody = cw

 set sc = request.Post("/RestTransfer/file")			
 Quit:$System.Status.IsError(sc) sc
 
 Set response=request.HttpResponse
 do response.OutputToDevice()
 
 Quit sc
}
}