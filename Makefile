# Variables
IMAGE_NAME := brainleakings
CONTAINER_NAME := brainleakings-container
TAG := latest
PORT := 1313

# Default target
.PHONY: all
all: build run

# Build the Docker image
.PHONY: build
build:
	@echo "Building Docker image $(IMAGE_NAME):$(TAG)..."
	docker build -t $(IMAGE_NAME):$(TAG) .

# Run the Docker container
.PHONY: run
run:
	@echo "Running Docker container $(CONTAINER_NAME)..."
	docker run --name $(CONTAINER_NAME) -p $(PORT):$(PORT) --rm $(IMAGE_NAME):$(TAG)

# Stop the Docker container
.PHONY: stop
stop:
	@echo "Stopping Docker container $(CONTAINER_NAME)..."
	docker stop $(CONTAINER_NAME) || true

# Clean up - remove container and image
.PHONY: clean
clean: stop
	@echo "Removing Docker image $(IMAGE_NAME):$(TAG)..."
	docker rmi $(IMAGE_NAME):$(TAG) || true

# Show help
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  all    - Build and run the Docker container (default)"
	@echo "  build  - Build the Docker image"
	@echo "  run    - Run the Docker container"
	@echo "  stop   - Stop the Docker container"
	@echo "  clean  - Remove the Docker container and image"
	@echo "  help   - Show this help message"
