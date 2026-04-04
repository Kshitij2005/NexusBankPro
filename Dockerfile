# Step 1: Build the app using Maven and JDK 17
FROM maven:3.8.5-openjdk-17 AS build
COPY . .
RUN mvn clean package -DskipTests

# Step 2: Use a guaranteed Tomcat 10 image
FROM tomcat:10.1-jre17
# Remove default Tomcat apps to avoid confusion
RUN rm -rf /usr/local/tomcat/webapps/*
# Copy your war file from the build stage to the Tomcat webapps folder as ROOT.war
COPY --from=build /target/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
