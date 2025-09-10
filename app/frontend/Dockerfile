# ---- build stage ----
FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# ---- run stage ----
FROM node:20-alpine
WORKDIR /site
# a small static file server
RUN npm install -g serve
COPY --from=build /app/dist /site
EXPOSE 8080
CMD ["serve", "-s", ".", "-l", "8080"]
