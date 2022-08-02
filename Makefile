SRC_DIR := src
OBJ_DIR := obj
BIN_DIR := bin
DIRS := $(SRC_DIR) $(OBJ_DIR) $(BIN_DIR)
SRCS := $(wildcard $(SRC_DIR)/*.c)
SRCS_MAIN := $(wildcard $(SRC_DIR)/task_*.c)
SRCS_FUNC := $(filter-out $(SRCS_MAIN), $(SRCS))
OBJS := $(patsubst $(SRC_DIR)/%.c,$(OBJ_DIR)/%.o,$(SRCS))
OBJS_MAIN := $(patsubst $(SRC_DIR)/%.c,$(OBJ_DIR)/%.o,$(SRCS_MAIN))
OBJS_FUNC := $(filter-out $(OBJS_MAIN),$(OBJS))
TARGETS := $(patsubst $(SRC_DIR)/task_%.c, $(BIN_DIR)/task_%, $(SRCS_MAIN))
DEPEND_DESP := depend.mk

INC_FLAGS := -I./include
LIB_FLAGS :=
CC_FLAGS := -g -Wall

CC := g++

.PHONY: default clean depend build mkdebug
default: build
mkdebug:
	@echo "[$(SRCS)]"
	@echo "[$(SRCS_MAIN)]"
	@echo "[$(SRCS_FUNC)]"
	@echo "[$(OBJS)]"
	@echo "[$(OBJS_MAIN)]"
	@echo "[$(OBJS_FUNC)]"
clean:
	@rm -f $(OBJ_DIR)/*
	@rm -f $(BIN_DIR)/*
	@rm -f $(DEPEND_DESP)

# generate source file dependency tree to depend.mk
depend: $(DEPEND_DESP)
	@echo Depend Generated
$(DEPEND_DESP): $(SRCS)
	@rm -f $(DEPEND_DESP)
	@echo "# AUTO GENERATED FILE, DO NOT EDIT!" > $(DEPEND_DESP)
	@$(foreach SRC, $(SRCS), $(CC) $(INC_FLAGS) -E -MM -MT $(patsubst $(SRC_DIR)/%.c, $(OBJ_DIR)/%.o, $(SRC)) $(SRC) >> $(DEPEND_DESP) ;)
ifneq ($(MAKECMDGOALS),clean)
-include $(DEPEND_DESP)
endif

# generate dir 
$(DIRS):
	@mkdir -p $@
$(OBJS): | $(OBJ_DIR)
$(TARGETS): | $(BIN_DIR)

# build
build: $(TARGETS)
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	$(CC) $(CC_FLAGS) $(INC_FLAGS) -o $@ -c $< $(LIB_FLAGS)
$(BIN_DIR)/%: $(OBJS_FUNC) $(OBJ_DIR)/%.o
	$(CC) $(CC_FLAGS) $(INC_FLAGS) -o $@ $^ $(LIB_FLAGS)
