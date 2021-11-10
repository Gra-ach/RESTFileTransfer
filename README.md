# RESTFileTransfer
Example of how to transfer files using RESTful services     
The motivation and the explanations are available in these articles in Developer Commnunity:     
[Transferring Files via REST to Store in a Property, Part 1](https://community.intersystems.com/post/transferring-files-rest-store-property-part-1)    
[Transferring Files via REST to Store in a Property, Part 2](https://community.intersystems.com/post/transferring-files-rest-store-property-part-2)

## Prerequisites
Make sure you have [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) and [Docker desktop](https://www.docker.com/products/docker-desktop) installed.
## Installation 
Clone/git pull the repo into any local directory
```
$ git clone https://github.com/intersystems-community/objectscript-docker-template.git
```
Open the terminal in this directory and build and run the IRIS container with your project:   
```
$ docker-compose up  -d --build
```

## How to Test it

From POSTMAN or ARC client send a **POST** request with your file as **BODY**   
- http://localhost:52773//RestTransfer/file     
or adding a file name as query parameter     
- http://localhost:52773//RestTransfer/file?myfile.xyz     

Use SMP or IRIS terminal to examine globals:
```
$ docker-compose exec iris iris session iris
USER>zwriet ^RestTransfer.FileDescD
^RestTransfer.FileDescD=5
^RestTransfer.FileDescD(1)=$lb("","1","")
^RestTransfer.FileDescD(2)=$lb("","2","")
^RestTransfer.FileDescD(3)=$lb("","3","")
^RestTransfer.FileDescD(4)=$lb("","4","Writer.cls")
^RestTransfer.FileDescD(5)=$lb("","5","dev.md")
USER> 
USER>zwrite ^RestTransfer.FileDescS(4)
^RestTransfer.FileDescS(4)=1
^RestTransfer.FileDescS(4,0)=1219
^RestTransfer.FileDescS(4,1)="Class RestTransfer.ChunkedWriter Extends %Net.ChunkedWriter"_$c(10)_"{"_$c(10,10)_"Parameter MAXSIZEOFCHUNK = 10000;"_$c(10,10)_"Property Filename As %String;"_$c(10,10)_"/// Abstract method to be overridden by subclass to do the chunked output using the "_$c(10)_"/// utility functions defined by this abstract super class."_$c(10)_"Method OutputStream()"_$c(10)_"{"_$c(10,9)_"set ..TranslateTable = ""RAW"""_$c(10,9)_"set cTime = $zdatetime($Now(), 8, 1) "_$c(10,9,9,9,10,9)_"set fStream = ##class(%Stream.FileBinary).%New()"_$c(10,9)_"set fStream.Filename = ..Filename"_$c(10,9)_"set size = fStream.Size"_$c(9,9,10,9)_"if size < ..#MAXSIZEOFCHUNK {"_$c(9,10,9,9)_"set buf = fStream.Read(.size, .st)"_$c(10,9,9)_"if $$$ISERR(st)"_$c(10,9,9)_"{"_$c(10,9,9,9)_"THROW st"_$c(10,9,9)_"} else {"_$c(10,9,9,9)_"set ^log(cTime, ..Filename) = size"_$c(10,9,9,9)_"do ..WriteSingleChunk(buf)"_$c(10,9,9)_"}"_$c(10,9)_"} else {"_$c(10,9,9)_"set ^log(cTime, ..Filename, 0) = size"_$c(10,9,9)_"set len = ..#MAXSIZEOFCHUNK"_$c(10,9,9)_"set buf = fStream.Read(.len, .st)"_$c(10,9,9)_"if $$$ISERR(st)"_$c(10,9,9)_"{"_$c(10,9,9,9)_"THROW st"_$c(10,9,9)_"} else {"_$c(10,9,9,9)_"set ^log(cTime, ..Filename, 1) = len"_$c(10,9,9,9)_"do ..WriteFirstChunk(buf)"_$c(10,9,9)_"}"_$c(9,9,10,9,9)_"set i = 2"_$c(10,9,9)_"While 'fStream.AtEnd {"_$c(9,10)_"    "_$c(9,9)_"set len = ..#MAXSIZEOFCHUNK"_$c(10,9)_" "_$c(9,9)_"set temp = fStream.Read(.len, .sc)"_$c(10,9)_" "_$c(9,9)_"if len<..#MAXSIZEOFCHUNK "_$c(10,9)_" "_$c(9,9)_"{"_$c(10,9,9)_" "_$c(9,9)_"do ..WriteLastChunk(temp)"_$c(10,9,9)_" "_$c(9,9,10,9)_" "_$c(9,9)_"} else {"_$c(10,9,9)_" "_$c(9,9)_"do ..WriteChunk(temp)"_$c(10,9,9)_" "_$c(9)_"}"_$c(10,9,9)_" "_$c(9)_"set ^log(cTime, ..Filename, i) = len"_$c(10,9,9)_" "_$c(9)_"set i = $increment(i)"_$c(10)_"  "_$c(9,9)_"}"_$c(9,9,9,10,9)_"}"_$c(10)_"}"_$c(10,10)_"}"_$c(10)
```
Follow the guidelines as described here    
- [Transferring Files via REST to Store in a Property, Part 1](https://community.intersystems.com/post/transferring-files-rest-store-property-part-1)    
- [Transferring Files via REST to Store in a Property, Part 2](https://community.intersystems.com/post/transferring-files-rest-store-property-part-2)
