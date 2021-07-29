Class RestTransfer.ChunkedWriter Extends %Net.ChunkedWriter
{

Parameter MAXSIZEOFCHUNK = 10000;

Property Filename As %String;

/// Abstract method to be overridden by subclass to do the chunked output using the 
/// utility functions defined by this abstract super class.
Method OutputStream()
{
	set ..TranslateTable = "RAW"
	set cTime = $zdatetime($Now(), 8, 1) 
			
	set fStream = ##class(%Stream.FileBinary).%New()
	set fStream.Filename = ..Filename
	set size = fStream.Size		
	if size < ..#MAXSIZEOFCHUNK {	
		set buf = fStream.Read(.size, .st)
		if $$$ISERR(st)
		{
			THROW st
		} else {
			set ^log(cTime, ..Filename) = size
			do ..WriteSingleChunk(buf)
		}
	} else {
		set ^log(cTime, ..Filename, 0) = size
		set len = ..#MAXSIZEOFCHUNK
		set buf = fStream.Read(.len, .st)
		if $$$ISERR(st)
		{
			THROW st
		} else {
			set ^log(cTime, ..Filename, 1) = len
			do ..WriteFirstChunk(buf)
		}		
		set i = 2
		While 'fStream.AtEnd {	
    		set len = ..#MAXSIZEOFCHUNK
	 		set temp = fStream.Read(.len, .sc)
	 		if len<..#MAXSIZEOFCHUNK 
	 		{
		 		do ..WriteLastChunk(temp)
		 		
	 		} else {
		 		do ..WriteChunk(temp)
		 	}
		 	set ^log(cTime, ..Filename, i) = len
		 	set i = $increment(i)
  		}			
	}
}

}
