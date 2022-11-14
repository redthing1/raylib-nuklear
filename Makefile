CXX ?= g++

# path #
SRC_PATH = src
BUILD_PATH = build
BIN_PATH = $(BUILD_PATH)/bin

RELEASE ?= 0

EXTRA_COMPILE_FLAGS :=
EXTRA_INCLUDES :=

# executable # 
BIN_NAME = libraylib_nuklear.a

# extensions #
SRC_EXT = c

# code lists #
# Find all source files in the source directory, sorted by
# most recently modified
SOURCES = $(shell find $(SRC_PATH) -name '*.$(SRC_EXT)' | sort -k 1nr | cut -f2-)
# Set the object file names, with the source directory stripped
# from the path, and the build path prepended in its place
OBJECTS = $(SOURCES:$(SRC_PATH)/%.$(SRC_EXT)=$(BUILD_PATH)/%.o)
# Set the dependency files that will be used to add header dependencies
DEPS = $(OBJECTS:.o=.d)

# flags #
# COMPILE_FLAGS = -std=c++11 -Wall -Wextra -g
# INCLUDES = -I include/ -I /usr/local/include
DEFAULT_DEBUG_COMPILE_FLAGS = -std=c++11 -Wall -Wextra -g
DEFAULT_RELEASE_COMPILE_FLAGS = -std=c++11 -Wall -Wextra -O3

COMPILE_FLAGS :=
INCLUDES := -I include/ -I /usr/local/include

# if release is set, use release flags
ifeq ($(RELEASE), 1)
	COMPILE_FLAGS += $(DEFAULT_RELEASE_COMPILE_FLAGS)
else
	COMPILE_FLAGS += $(DEFAULT_DEBUG_COMPILE_FLAGS)
endif

COMPILE_FLAGS += $(EXTRA_COMPILE_FLAGS)
INCLUDES += $(EXTRA_INCLUDES)

# Space-separated pkg-config libraries used by this project
LIBS =

.PHONY: default_target
default_target: release

.PHONY: release
release: export CXXFLAGS := $(CXXFLAGS) $(COMPILE_FLAGS)
release: dirs
	@$(MAKE) all

.PHONY: dirs
dirs:
	@echo "Creating directories"
	@mkdir -p $(dir $(OBJECTS))
	@mkdir -p $(BIN_PATH)

.PHONY: clean
clean:
	@echo "Deleting $(BIN_NAME) symlink"
	@$(RM) $(BIN_NAME)
	@echo "Deleting directories"
	@$(RM) -r $(BUILD_PATH)
	@$(RM) -r $(BIN_PATH)

# checks the executable and symlinks to the output
.PHONY: all
all: $(BIN_PATH)/$(BIN_NAME)
	@echo "Making symlink: $(BIN_NAME) -> $<"
	@$(RM) $(BIN_NAME)
	@ln -s $(BIN_PATH)/$(BIN_NAME) $(BIN_NAME)

# Creation of the executable
$(BIN_PATH)/$(BIN_NAME): $(OBJECTS)
	@echo "Linking: $@"
#	$(CXX) $(OBJECTS) -o $@ ${LIBS}
# build instead a static library
	$(AR) rcs $@ $(OBJECTS)

# Add dependency files, if they exist
-include $(DEPS)

# Source file rules
# After the first compilation they will be joined with the rules from the
# dependency files to provide header dependencies
$(BUILD_PATH)/%.o: $(SRC_PATH)/%.$(SRC_EXT)
	@echo "Compiling: $< -> $@"
	$(CXX) $(CXXFLAGS) $(INCLUDES) -MP -MMD -c $< -o $@
