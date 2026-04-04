# Step 1: Build the app
FROM maven:3.8.5-openjdk-17 AS build
COPY . .
RUN mvn clean package -DskipTests

# Step 2: Use Tomcat 10
FROM tomcat:10.1-jre17

# Render uses port 8080 by default
ENV PORT=8080

# Disable the Tomcat shutdown port to stop those "Invalid shutdown" errors
RUN sed -i 's/port="8005" shutdown="SHUTDOWN"/port="-1" shutdown="SHUTDOWN"/g' /usr/local/tomcat/conf/server.xml

# Remove default apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy your war file as ROOT.war
COPY --from=build /target/*.war /usr/local/tomcat/webapps/ROOT.war

# Open the correct port
EXPOSE 8080

# Run Tomcat
CMD ["catalina.sh", "run"]
