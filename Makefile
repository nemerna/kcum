WORK_DIRECTORY := $(shell pwd)/data

help: ## Prints help for targets with comments
	@grep -E '^[a-zA-Z0-9.\ _-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build-docker:
	docker build -t quay.io/ecosystem-appeng/kc-exim .

build-podman:
	podman build -t quay.io/ecosystem-appeng/kc-exim .

export: ## run an export job, exports remote server users into local filesystem
	docker run -it \
	-e EXPORT_KEYCLOAK_SERVER=$(EXPORT_KEYCLOAK_SERVER) \
	-e EXPORT_REALM=$(EXPORT_REALM) \
	-e EXPORT_TOKEN=$(EXPORT_TOKEN) \
	-v $(WORK_DIRECTORY):/home/default/kc-exim \
	quay.io/ecosystem-appeng/kc-exim export

import: ## run an import job, imports local users/groups into a remote server
	docker run -it \
	-e IMPORT_KEYCLOAK_SERVER=$(IMPORT_KEYCLOAK_SERVER) \
	-e IMPORT_REALM=$(IMPORT_REALM) \
	-e IMPORT_TOKEN=$(IMPORT_TOKEN) \
	-v $(WORK_DIRECTORY):/home/default/kc-exim/ \
	quay.io/ecosystem-appeng/kc-exim import

generate-token: 	## TO-DO maybe support generating token based on username/password