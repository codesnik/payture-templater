.PHONY: server install

default: install server

install:
	@bundle --quiet

server:
	rackup -p 8080
