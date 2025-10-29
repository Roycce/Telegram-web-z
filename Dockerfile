# 1️⃣ Этап сборки
FROM node:18-alpine AS builder

# Установим git (иначе npm install не сможет подтянуть пакеты из GitHub)
RUN apk add --no-cache git

# Рабочая директория
WORKDIR /app

# Скопируем проект из репозитория
RUN git clone https://github.com/Roycce/Telegram-web-z.git . 

# Иногда Portainer ломает .git, поэтому создаём фейковый репозиторий
RUN [ -d .git ] || git init && git add . && git commit -m "fake commit"

# Устанавливаем зависимости
RUN npm install

# Собираем фронтенд
RUN npm run build

# 2️⃣ Этап запуска (лёгкий образ для продакшна)
FROM node:18-alpine AS runner

WORKDIR /app

# Копируем собранный билд из первого этапа
COPY --from=builder /app/dist ./dist

# Устанавливаем лёгкий HTTP сервер
RUN npm install -g serve

# Экспонируем порт 1234 (или 80 — как хочешь)
EXPOSE 1234

# Запускаем
CMD ["serve", "-s", "dist", "-l", "1234"]
