FLUTTER_VERSION?=3.10.5
DART?= fvm dart
FLUTTER?= fvm flutter
REPOSITORIES?=lib/ test/
RUN_VERSION?=--debug

GREEN_COLOR=\033[32m
NO_COLOR=\033[0m

define print_color_message
	@echo "$(GREEN_COLOR)$(1)$(NO_COLOR)";
endef

##
## ---------------------------------------------------------------
## Installation
## ---------------------------------------------------------------
##

.PHONY: install
install: ## Install environment
	@$(call print_color_message,"Install environment")
	fvm install $(FLUTTER_VERSION)
	fvm use $(FLUTTER_VERSION)

##
## ---------------------------------------------------------------
## Dart
## ---------------------------------------------------------------
##

.PHONY: dependencies
dependencies: ## Update dependencies
	@$(call print_color_message,"Update dependencies")
	$(DART) pub get

.PHONY: format
format: ## Format code by default lib directory
	@$(call print_color_message,"Format code by default lib directory")
	$(DART) format $(REPOSITORIES)

.PHONY: analyze
analyze: ## Analyze Dart code of the project
	@$(call print_color_message,"Analyze Dart code of the project")
	$(DART) analyze .

.PHONY: format-analyze
format-analyze: format analyze ## Format & Analyze Dart code of the project

.PHONY: show-dependencies
show-dependencies: ## Show dependencies tree
	@$(call print_color_message,"Show dependencies tree")
	$(DART) pub deps

.PHONY: outdated
outdated: ## Check the version of packages
	@$(call print_color_message,"Check the version of packages")
	$(DART) pub outdated --color

##
## ---------------------------------------------------------------
## Flutter
## ---------------------------------------------------------------
##

.PHONY: test
test: ## Run all tests with coverage
	@$(call print_color_message,"Run all tests with coverage")
	$(FLUTTER) test \
		--coverage \
		--test-randomize-ordering-seed random \
		--reporter expanded
	genhtml coverage/lcov.info \
		--output-directory coverage/html
	open coverage/html/index.html

.PHONY: devtools
devtools: ## Serving DevTools
	@$(call print_color_message,"Serving DevTools")
	$(FLUTTER) pub global run devtools

.PHONY: run-example
run-example: ## Run example by default debug version
	@$(call print_color_message,"Run example by default debug version")
	cd flutter_example && $(FLUTTER) run $(RUN_VERSION)

##
## ---------------------------------------------------------------
## Generator
## ---------------------------------------------------------------
##

.PHONY: generate-files
generate-files: ## Generate files with build_runner
	@$(call print_color_message,"Generate files with build_runner")
	$(FLUTTER) pub run build_runner build --delete-conflicting-outputs

.PHONY: generate-package
generate-package: ## Generate a package
	@$(call print_color_message,"Generate a package")
	$(FLUTTER) flutter create ticket_printer \
      --template=package

.PHONY: generate-flutter-example
generate-flutter-example: ## Generate a flutter project as example
	@$(call print_color_message,"Generate a flutter project as example")
	$(FLUTTER) create ./flutter_example/ \
      --description="A Flutter project as example to use ticket_printer package." \
      --platforms=ios,android \
      --org="com.ticket_printer" \
	  --project-name="example"

##
## ---------------------------------------------------------------
## scrcpy
## ---------------------------------------------------------------
##

.PHONY: mirror
mirror: ## Mirror screen with scrcpy
	@$(call print_color_message,"Mirror screen with scrcpy")
	scrcpy --max-size 1024 --window-title 'My device'

.PHONY: record
record: ## Record screen with scrcpy
	@$(call print_color_message,"Record screen with scrcpy")
	scrcpy --max-size 1024 --no-display --record "flutter_$(shell date +%Y%m%d-%H%M%S).mp4"

#
# ----------------------------------------------------------------
# Help
# ----------------------------------------------------------------
#

.DEFAULT_GOAL := help
.PHONY: help
help:
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "$(GREEN_COLOR)%-30s$(NO_COLOR) %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'