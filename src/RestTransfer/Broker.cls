Class RestTransfer.Broker Extends %CSP.REST
{

XData UrlMap
{
<Routes>   	
  	<Route Url="/file" Method="POST" Call="InsertFileContents"/>
  	<Route Url="/json" Method="POST" Call="InsertJSON"/>
  	<Route Url="/jsons" Method="POST" Call="InsertJSONSmall"/>
 </Routes>
}

ClassMethod InsertFileContents() As %Status
{
  Set result={}
  Set st=0    
  set f = ##class(RestTransfer.FileDesc).%New()   
  if (f = $$$NULLOREF) {	  
	  do result.%Set("Message", "Couldn't create an instance of class")  
  } else {     	 
#; use query parameter	as file.name        
        set f.Name=$piece(%request.CgiEnvs("REQUEST_URI"),"?",2)
    	set st = f.File.CopyFrom(%request.Content)       
        If $$$ISOK(st) {
	       set st = f.%Save() 
	       If $$$ISOK(st) {	        
              do result.%Set("Status","OK")           
	       } else {		       
          	  do result.%Set("Message",$system.Status.GetOneErrorText(st))  
		   }
        } else {	       
           do result.%Set("Message",$system.Status.GetOneErrorText(st))  
        }     
  } 
  write result.%ToJSON() 
  Quit st
}

ClassMethod InsertJSON() As %Status
{
  Set result={}
  Set st=0  
  
  set t = ##class(%Stream.TmpBinary).%New()
  While '%request.Content.AtEnd {	
     set len = 32000
	 set temp = %request.Content.Read(.len, .sc)
	 set:len<32000 temp = $extract(temp,1,*-2)	 
	 set st = t.Write($ZCONVERT(temp, "I", "RAW"))	    		    		
  }
  
  do t.Rewind()
  
  set f = ##class(RestTransfer.FileDesc).%New()   
  if (f = $$$NULLOREF) {	  
  	do result.%Set("Message", "Couldn't create an instance of class")  
  } else { 
  	set str = t.Read()
  	set pos = $LOCATE(str,""",")
  	set f.Name = $extract(str, 10, pos-1)
  	do f.File.Write($extract(str, pos+11, *))
  	While 't.AtEnd {	
	    do f.File.Write(t.Read(.len, .sc))
	}
  	  	
  	If $$$ISOK(st) {
	  set st = f.%Save() 
	  If $$$ISOK(st) {	        
         do result.%Set("Status","OK")           
	  } else {		       
         do result.%Set("Message",$system.Status.GetOneErrorText(st))  
	  }
    } else {	       
       do result.%Set("Message",$system.Status.GetOneErrorText(st))  
    }     
  }
 
  write result.%ToJSON() 
  Quit st
}

ClassMethod InsertJSONSmall() As %Status
{
  Set result={}
  Set st=0 
  
  set f = ##class(RestTransfer.FileDesc).%New()   
  if (f = $$$NULLOREF) {	  
 	 do result.%Set("Message", "Couldn't create an instance of class")  
  } else {     	
  	set st = f.%JSONImport(%request.Content)  
 	If $$$ISOK(st) {
		set st = f.%Save() 
		If $$$ISOK(st) {	        
     	  do result.%Set("Status","OK")           
		} else {		       
     	  do result.%Set("Message",$system.Status.GetOneErrorText(st))  
		}
  	} else {	       
   	   do result.%Set("Message",$system.Status.GetOneErrorText(st))  
  	}
  }
  write result.%ToJSON() 
  Quit st
}

}
