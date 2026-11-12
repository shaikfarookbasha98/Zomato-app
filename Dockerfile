
# Stage 1: Build React application
FROM node:22-bookworm-slim AS build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci

COPY . .

RUN npm run build


# Stage 2: Production runtime
FROM node:22-bookworm-slim

WORKDIR /app

# Install static file server
RUN npm install -g serve

# Copy production build
COPY --from=build /app/build ./build

# Run application as non-root user
USER node

EXPOSE 3000

CMD ["serve", "-s", "build", "-l", "3000"]

