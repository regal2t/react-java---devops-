# Use a base image with Maven and Java (JDK 17 in this case)
FROM maven:3.8.4-openjdk-17-slim AS build

# Set the working directory
WORKDIR /app

# Copy the pom.xml file
COPY pom.xml .

# Copy the rest of the project and build
COPY src ./src

# Build the application with Maven
RUN mvn clean package -DskipTests

# Create a separate stage for the final image
FROM openjdk:17-jdk-alpine AS final

# Set the working directory
WORKDIR /app

# Copy the JAR file built in the previous stage
COPY --from=build /app/target/lakeSide-hotel-0.0.1-SNAPSHOT.jar ./app.jar

# Expose the port your app runs on (default Spring Boot port is 8080)
EXPOSE 9192

# Command to run the application
CMD ["java", "-jar", "app.jar"]
