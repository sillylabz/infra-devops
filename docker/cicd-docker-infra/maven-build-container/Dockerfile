FROM openjdk:8-jdk-alpine
RUN apk update \
  && apk add --no-cache curl tar bash procps \
  && apk add --upgrade junit

# Downloading and installing Maven
# 1- version of maven you want to install
ARG MAVEN_VERSION=3.6.3       

# 2- maven working directory
ARG USER_HOME_DIR="/root"

# 4- maven download url
ARG BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries

# 5- Create the directories, download maven, validate the download, install it, remove downloaded file and set links
RUN mkdir -p /usr/share/maven /usr/share/maven/ref /root/.m2/repository \
  && echo "Downlaoding maven" \
  && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
  \
  && echo "Unziping maven" \
  && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
  \
  && echo "Cleaning and setting links" \
  && rm -f /tmp/apache-maven.tar.gz \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn
COPY settings.xml /root/.m2

# 6- Define environmental variables required by Maven, like Maven_Home directory and where the maven repo is located
ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG /root/.m2

WORKDIR $USER_HOME_DIR

CMD [""]

