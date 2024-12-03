FUNCTION=$1
DAT_FILE=$2

build() {
	echo "Building Docker image"
	docker build -f Dockerfile -t cygnss .
	echo "Done"
}

run() {
	# Checking which case we are in based on the execution below
	if [ "$#" -ne 1 ]; then
		echo "Running the CYGNSS processsing with config file present when Docker image was built"
		docker run --name cygnssdocker cygnss
	else
		DAT_FILE=${PWD}/$1
		echo "Running the CYGNSS processsing with provided config file: "${DAT_FILE}
		docker run --name cygnssdocker -v ${DAT_FILE}:/app/CYGNSS_DDMP_config.dat cygnss
	fi
	echo "Copying processed DDM file to host"
	docker cp cygnssdocker:/app/Processed_DDMs.bin .
	echo "Cleaning up container"
	docker container rm --force --volumes cygnssdocker
	echo "Done"
}

if [[ "${FUNCTION}" == "run" ]]; then
	# If we do not have a file as input, use the file present when the container
	# was built
	if [ "$#" -ne 2 ]; then
		${FUNCTION}
	else
		${FUNCTION} ${DAT_FILE}
	fi
else
	${FUNCTION}
fi