FROM alpine/git AS clone
COPY . /data
WORKDIR /data

# Initialize and update submodules, and force latest commit
RUN git submodule update --init --recursive \
    && cd themes/hugo-profile \
    && git fetch origin \
    && git checkout master \
    && git pull origin master

# Build the Hugo site
FROM klakegg/hugo:ext-ubuntu-onbuild AS build
# Copy everything from the clone stage
COPY --from=clone /data /data
WORKDIR /data

# Build the site, include drafts if needed
RUN hugo -D --theme hugo-profile

# Serve the site with NGINX
FROM nginx:alpine
# Copy the generated static site to NGINX root
COPY --from=build /data/public /usr/share/nginx/html
