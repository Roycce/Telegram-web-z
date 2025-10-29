FROM node:18-alpine

# Установим git
RUN apk add --no-cache git

# Рабочая директория
WORKDIR /app

# Копируем всё внутрь контейнера
COPY . .

# Иногда Portainer копирует без .git — создаём фиктивный репозиторий, чтобы не ломался GitRevisionPlugin
RUN [ -d .git ] || git init && git add . && git commit -m "fake commit"

# Установка зависимостей и сборка проекта
RUN npm install
RUN npm run build

# Устанавливаем лёгкий HTTP-сервер
RUN npm install -g serve

# Открываем порт 1234
EXPOSE 1234

# Запускаем
CMD ["serve", "-s", "dist", "-l", "1234"]
