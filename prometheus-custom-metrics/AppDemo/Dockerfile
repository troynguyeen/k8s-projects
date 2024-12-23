# Build stage
FROM eclipse-temurin:17-jdk-jammy as build
WORKDIR /build-demoapp
COPY . .
RUN ./mvnw clean package -DskipTests

# Run stage
FROM eclipse-temurin:17-jdk-jammy
WORKDIR /demoapp
COPY --from=build /build-demoapp/target/*.jar demoapp.jar
ENTRYPOINT [ "java", "-jar", "demoapp.jar" ]