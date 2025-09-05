# prepare source with submodules
#FROM alpine/git AS source
#WORKDIR /src

# Copy repo into the container
#COPY . .

# Make sure submodules are initialized and updated
#RUN git submodule update --init --recursive

# build with Hugo
FROM klakegg/hugo:ext-ubuntu-onbuild AS build
WORKDIR /src

# Copy prepared source (with submodules)
#COPY --from=source /src /src

# Build the site
RUN hugo --minify

# Stage 3: serve with NGINX
FROM nginx:alpine
COPY --from=build /src/public /usr/share/nginx/html

