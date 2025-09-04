# Cloning the repository

FROM alpine/git AS clone
COPY . /data
WORKDIR /data
RUN git clone https://github.com/mdaleo404/mdsysadmin-website.git

# Building the site with Hugo

FROM klakegg/hugo:ext-ubuntu-onbuild AS build
COPY --from=clone /data /data
WORKDIR /data
RUN hugo -D

# Expose the site using NGINX

FROM nginx:alpine
COPY --from=build /data/public /usr/share/nginx/html
