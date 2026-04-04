# Step 1: Build the app
FROM maven:3.8.5-openjdk-17 AS build
COPY . .
RUN mvn clean package -DskipTests

# Step 2: Use Tomcat 10
FROM tomcat:10.1-jre17

# Set the port environment variable explicitly for Render
ENV PORT=8080

# Remove default apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy your war file as ROOT.war
COPY --from=build /target/*.war /usr/local/tomcat/webapps/ROOT.war

# Open the port
EXPOSE 8080

# Run Tomcat and bind it correctly
CMD ["catalina.sh", "run"]
