PROTO_DIRS = models service

OUT_DIR = gen/go

PROTOC = protoc
PROTOC_GEN_GO = protoc-gen-go
PROTOC_GEN_GO_GRPC = protoc-gen-go-grpc

PROTO_FILES := $(shell find $(PROTO_DIRS) -name '*.proto')

OUT_FILES := $(patsubst %.proto,$(OUT_DIR)/%.pb.go,$(PROTO_FILES))

all: $(OUT_FILES)

$(PROTOC_GEN_GO):
	go install google.golang.org/protobuf/cmd/protoc-gen-go@latest

$(PROTOC_GEN_GO_GRPC):
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

$(OUT_DIR)/%.pb.go: %.proto | $(PROTOC_GEN_GO_GRPC) $(PROTOC_GEN_GO)
	@mkdir -p $(dir $@)
	$(PROTOC) --proto_path=. --go_out=$(OUT_DIR) --go_opt=paths=source_relative --go-grpc_out=$(OUT_DIR) --go-grpc_opt=paths=source_relative $<

clean:
	rm -rf $(OUT_DIR)

.PHONY: all clean debug
