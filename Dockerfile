# Stage 1: Build the Angular application
FROM node:20-alpine as build

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm install

COPY . .

RUN npm run build --prod

# Stage 2: Serve the Angular app with NGINX
FROM nginx:alpine
COPY --from=build /app/dist/my-angular-app /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
