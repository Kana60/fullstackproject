# 1. Используем образ с Gradle и Java 17 для сборки
FROM gradle:8.5-jdk17 AS builder

# Копируем файлы проекта внутрь контейнера
COPY --chown=gradle:gradle . /home/gradle/src
WORKDIR /home/gradle/src

# Запускаем сборку (пропуская тесты, чтобы быстрее)
RUN gradle build --no-daemon -x test

# 2. Используем легкий образ Java для запуска
FROM eclipse-temurin:17-jdk-alpine

# Берем созданный jar-файл из первого этапа
COPY --from=builder /home/gradle/src/build/libs/*.jar app.jar

# Открываем порт 8080
EXPOSE 8080
# Команда запуска
ENTRYPOINT ["java", "-jar", "/app.jar"]