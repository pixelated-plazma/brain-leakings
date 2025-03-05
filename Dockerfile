FROM alpine:3.18

# Install dependencies including glibc for DNS resolution
RUN apk add --no-cache curl tar libc6-compat libstdc++ gcompat

# Set Hugo version to install
ENV HUGO_VERSION=0.144.2
ENV HUGO_BINARY=hugo_extended_${HUGO_VERSION}_linux-amd64.tar.gz

# Download and install Hugo
RUN mkdir -p /tmp/hugo && \
    curl -L https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/${HUGO_BINARY} -o /tmp/hugo/${HUGO_BINARY} && \
    tar -xzf /tmp/hugo/${HUGO_BINARY} -C /tmp/hugo && \
    mv /tmp/hugo/hugo /usr/local/bin/ && \
    chmod +x /usr/local/bin/hugo && \
    rm -rf /tmp/hugo

# Set working directory for your Hugo site
WORKDIR /site

# Copy your site content
COPY . .

# Expose port for Hugo server
EXPOSE 1313

# Run Hugo server with appropriate flags when container starts
CMD ["hugo", "server", "--bind", "0.0.0.0", "-D"]
