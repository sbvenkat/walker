# default value for the python package
export SHELL := /bin/bash
PYTHON_PKG_DEFAULT_VER = 0.0.1

APP_PATH = $(WALKER_DIR)/$(APP_NAME)
PIP_INSTALL_FLAGS = 

#develop configuration
DEVELOP_ENV	= devenv
DEV_PATH	= $(APP_PATH)/$(DEVELOP_ENV)

#build configuration
APP_BUILD_PATH   = /tmp/build-pkg
APP_ENV          = $(APP_BUILD_PATH)/opt/$(APP_NAME)/app-env
APP_DEB_PKG_NAME = $(APP_NAME).deb

#modify python pkg version
ifeq ($(BUILD_NUM), 1)
	APP_PKG_VER = $(PYTHON_PKG_DEFAULT_VER)
else
	APP_PKG_VER = 0.0.$(BUILD_NUM)
endif

build:
	@echo "Create $(APP_NAME) python package";
	rm -rf dist/*;
	@sed -ie "s/$(PYTHON_PKG_DEFAULT_VER)/$(APP_PKG_VER)/g" setup.py || { \
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

deb-app-env:
	@echo "Create python runtime environment";
	@if [ -r $(APP_BUILD_PATH) ]; then \
		echo "Delete old build path"; \
		rm -rf $(APP_BUILD_PATH); \
	fi;
	@mkdir $(APP_BUILD_PATH);
	@echo "Create virtual env";
	@virtualenv $(APP_ENV) || { \
		echo "Failed to create virtual env";\
		exit 1; \
	};
	@echo "Activate build virtualenv and install pkgs";\
	source $(APP_ENV)/bin/activate || { \
		echo "Failed to activate build env"; \
		exit 1; \
	}; \
	pkgs_to_install="dist/$(APP_NAME)-$(APP_PKG_VER).tar.gz"; \
	for pkg in $${pkgs_to_install}; do \
		pip install $(PIP_INSTALL_FLAGS) $${pkg} || { \
			echo "Failed to install $${pkg}"; \
			exit 1; \
		}; \
	done;
	 
deb-pkg: build deb-app-env
	@echo "Create $(APP_NAME) debian package";
	@cp -R $(APP_PATH)/debian $(APP_BUILD_PATH)/DEBIAN;
	@sed -ie "s/APPVERSION/$(APP_PKG_VER)/g" $(APP_BUILD_PATH)/DEBIAN/control || { \
		echo "Failed to rewrite DEBIAN control version"; \
		exit 1; \
	};
	dpkg-deb --build $(APP_BUILD_PATH) $(APP_BUILD_PATH)/$(APP_DEB_PKG_NAME);
	@echo "$(APP_NAME) debian package created";	

develop-clean:
	@echo "Cleanup devenv environment"; 
	@rm -rf $(DEV_PATH);

dist-clean:
	@rm -rf dist src/*.egg-info;

clean: develop-clean dist-clean
	@echo "Project dev setup is clear";

