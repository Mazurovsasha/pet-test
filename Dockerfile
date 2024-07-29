# Этап 1: Сборка приложения
FROM node:14 AS builder

# Устанавливаем рабочую директорию в контейнере
WORKDIR /app

# Копируем package.json и package-lock.json в рабочую директорию
COPY package*.json ./

# Устанавливаем зависимости
RUN npm install

# Копируем остальные файлы проекта в рабочую директорию
COPY . .

# Сборка проекта
RUN npm run build

# Этап 2: Запуск сервера
FROM nginx:alpine

# Копируем собранные файлы из предыдущего этапа
COPY --from=builder /app/build /usr/share/nginx/html

# Копируем конфигурацию NGINX
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Открываем порт, на котором будет работать сервер
EXPOSE 80

# Запуск NGINX
CMD ["nginx", "-g", "daemon off;"]
