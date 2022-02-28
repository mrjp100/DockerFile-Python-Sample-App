1st Build the DockerImage

docker build -t my-python-app .

2nd Run the container with port 8080 
(Note - this app is working with port number 8080)
docker run -d -p 8080:8080 my-python-app

3th Test your app is run
Browse your IP or URL from any browser with port number 8080
(http://IPaddress:8080)

