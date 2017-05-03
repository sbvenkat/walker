# default value for the python package
export SHELL := /bin/bash
PYTHON_PKG_DEFAULT_VER = 0.0.1

APP_PATH = $(WALKER_DIR)/$(APP_NAME)
PIP_INSTALL_FLAGS = 

#develop configuration
DEVELOP_ENV	= devenv
DEV_PATH	= $(APP_PATH)/$(DEVELOP_ENV)

#modify python pkg version
ifeq ($(BUILD_NUM), 1)
	APP_PKG_VER = $(PYTHON_PKG_DEFAULT_VER)
else
	APP_PKG_VER = 0.0.$(BUILD_NUM)
endif

build:
	@echo "Create $(APP_NAME) python package";
	rm -rf dist/*;
	@sed -i "s/$(PYTHON_PKG_DEFAULT_VER)/$(APP_PKG_VER)/g" setup.py || { \
		echo "Failed to rewrite setup.py version"; \
		exit 1; \
	};
	@python setup.py sdist || { \
		echo "Failed to create distribution for $(APP_NAME)"; \
		exit 1; \
	};

develop: build
	echo "Create develop environment";
	@if [ -r $(DEV_PATH) ]; then \
	    echo "Deleting existing devenv"; \
	    rm -rf $(DEV_PATH); \
	fi;
	@echo "- create virtualenv...";
	@virtualenv $(DEV_PATH) || { \
	    echo "Failed to create virutal env";\
	    exit 1; \
	}; \
	echo "- activate virtualenv and install pkgs"; \
	source $(DEV_PATH)/bin/activate || { \
	    echo "Failed to activate devenv"; \
	    exit 1; \
	}; \
	pkgs_to_install="dist/$(APP_NAME)-$(APP_PKG_VER).tar.gz"; \
	for pkg in $${pkgs_to_install}; do \
		pip install $(PIP_INSTALL_FLAGS) $${pkg} || { \
			echo "Failed to install $${pkg}"; \
			exit 1; \
		}; \
	done;

develop-clean:
	@echo "Cleanup devenv environment"; 
	@rm -rf $(DEV_PATH);

dist-clean:
	@rm -rf dist;

clean: develop-clean dist-clean
	@echo "Project dev setup is clean";

