FROM alpine/git AS clone
COPY . /data
WORKDIR /data

RUN rm -rf themes/*
RUN git clone https://github.com/kamahell87/hugo-profile.git

# Build the Hugo site
FROM klakegg/hugo:ext-ubuntu-onbuild AS build
# Copy everything from the clone stage
COPY --from=clone /data /data
WORKDIR /data

# Build the site, include drafts if needed
RUN hugo -D

# Serve the site with NGINX
FROM nginx:alpine
# Copy the generated static site to NGINX root
COPY --from=build /data/public /usr/share/nginx/html
