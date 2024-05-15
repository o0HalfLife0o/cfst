NAME = CloudflareST

LDFLAGS = -X main.version=$(VERSION) -s -w -buildid=
PARAMS = -trimpath -ldflags "$(LDFLAGS)" -v
MAIN = ./
PREFIX ?= $(shell go env GOPATH)
ifeq ($(GOOS),windows)
OUTPUT = $(NAME).exe
else
OUTPUT = $(NAME)
endif
ifeq ($(shell echo "$(GOARCH)" | grep -Pq "(mips|mipsle)" && echo true),true) # 
ADDITION = GOMIPS=softfloat go build -o $(NAME)_softfloat -trimpath -ldflags "$(LDFLAGS)" -v $(MAIN)
endif
.PHONY: clean

build:
	go build -o $(OUTPUT) $(PARAMS) $(MAIN)
	$(ADDITION)

install:
	go build -o $(PREFIX)/bin/$(OUTPUT) $(PARAMS) $(MAIN)

clean:
	go clean -v -i $(PWD)
	rm -f CloudflareST CloudflareST.exe CloudflareST_softfloat
