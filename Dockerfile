# START STAGE 1
FROM openjdk:8

USER root

WORKDIR /tmp

RUN apt-get update && apt-get -y install git ant


WORKDIR /home/build-app
COPY . .
RUN ant


# START STAGE 2
FROM existdb/existdb:release

COPY --from=0 /home/build-app/build/*.xar /exist/autodeploy

EXPOSE 8080 8443

CMD [ "java", "-jar", "start.jar", "jetty" ]
