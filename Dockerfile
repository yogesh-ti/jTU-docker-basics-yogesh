# # Install the base requirements for the app.
# # This stage is to support development.
# FROM python:alpine AS base
# WORKDIR /app
# COPY requirements.txt .
# RUN pip install -r requirements.txt

FROM node:12-alpine AS app-base
WORKDIR /app
COPY app_1/package.json app_1/yarn.lock ./
COPY app_1/spec ./spec
COPY app_1/src ./src

# Run tests to validate app
FROM app-base AS test
RUN apk add --no-cache python2 g++ make
RUN yarn install --production
CMD ["node", "src/index.js"]
EXPOSE 3000
# # Clear out the node_modules and create the zip
# FROM app-base AS app-zip-creator
# COPY app/package.json app/yarn.lock ./
# COPY app/spec ./spec
# COPY app/src ./src
# RUN apk add zip && \
#     zip -r /app.zip /app

# # Dev-ready container - actual files will be mounted in
# FROM base AS dev
# CMD ["mkdocs", "serve", "-a", "0.0.0.0:8000"]

# # Do the actual build of the mkdocs site
# FROM base AS build
# COPY . .
# RUN mkdocs build

# # Extract the static content from the build
# # and use a nginx image to serve the content
# FROM nginx:alpine
# COPY --from=app-zip-creator /app.zip /usr/share/nginx/html/assets/app.zip
# COPY --from=build /app/site /usr/share/nginx/html
