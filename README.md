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
Open IRIS terminal to examine globals:
```
$ docker-compose exec iris iris session iris
USER>write ##class(dc.PackageSample.ObjectScript).Test()
```
Follow the guidelines as described here    
- [Transferring Files via REST to Store in a Property, Part 1](https://community.intersystems.com/post/transferring-files-rest-store-property-part-1)    
- [Transferring Files via REST to Store in a Property, Part 2](https://community.intersystems.com/post/transferring-files-rest-store-property-part-2)
