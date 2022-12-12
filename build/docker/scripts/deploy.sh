if [ $# == 0 ] 
then
	echo "Usage:
    
Input Parameters :

	1) Profile name for e.x 'docker'"
	exit 1
fi


cd /home/ggregoret3/actions-runner/_work/Allianz/Allianz/
#Install dependencies
sudo apt update
sudo apt install maven default-jdk -y
sudo usermod -aG docker ${USER}
# Build all the modules
mvn clean package

# Enter docker-compose folder

cd /home/ggregoret3/actions-runner/_work/Allianz/Allianz/build/docker/
# Get the profile from
# command line arguement
#export profile=$1

# Deploy
docker compose up --build -d
