get-sample:
ifeq ($(OS),Windows_NT)
	if exist "build" rmdir /Q /S build
	if exist "downloads" rmdir /Q /S downloads
	mkdir downloads build
	wget http://cdn.mendix.com/sample/SampleAppA.mpk -O downloads/application.mpk
	unzip downloads/application.mpk -d build/
else
	if [ -d build ]; then rm -rf build; fi
	if [ -d downloads ]; then rm -rf downloads; fi
	mkdir -p downloads build
	wget https://cdn.mendix.com/sample/SampleAppA.mpk -O downloads/application.mpk
	unzip downloads/application.mpk -d build/	
endif
	
build-image:
	docker build \
	--build-arg BUILD_PATH=build \
	-t mendix/mendix-buildpack:v1.3 .

test-container:
	tests/test-generic.sh tests/docker-compose-postgres.yml
	tests/test-generic.sh tests/docker-compose-sqlserver.yml
	tests/test-generic.sh tests/docker-compose-azuresql.yml

run-container:
	docker-compose -f tests/docker-compose-mysql.yml up
