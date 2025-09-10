# Makefile for building & deploying frontend and backend images to GCP Artifact Registry
# and upgrading Helm releases with pinned commit SHA

PROJECT_ID = gcp-demo-project-471714
REGION = us-central1

# Retrieve the short git commit SHA
SHA := $(shell git rev-parse --short HEAD)
BACK_IMAGE = $(REGION)-docker.pkg.dev/$(PROJECT_ID)/apps/backend:$(SHA)
FRONT_IMAGE = $(REGION)-docker.pkg.dev/$(PROJECT_ID)/apps/frontend:$(SHA)

.PHONY: pin-deploy build-backend build-frontend push-backend push-frontend

## Build and push backend + frontend images with current commit SHA, then upgrade Helm releases\pin-deploy: build-backend push-backend build-frontend push-frontend
	@echo "Upgrading Helm releases with image tag $(SHA) ..."
	helm upgrade --install backend ./helm/charts/backend -n app --set image.tag=$(SHA)
	helm upgrade --install frontend ./helm/charts/frontend -n app --set image.tag=$(SHA)
	kubectl -n app rollout status deploy/backend
	kubectl -n app rollout status deploy/frontend

## Build backend image
default: build-backend

build-backend:
	cd app/backend && docker build -t $(BACK_IMAGE) .

## Build frontend image
build-frontend:
	cd app/frontend && docker build -t $(FRONT_IMAGE) .

## Push backend image
push-backend:
	docker push $(BACK_IMAGE)

## Push frontend image
push-frontend:
	docker push $(FRONT_IMAGE)
