CHECKOUTS = Carthage/Checkouts

ALAMOFIRE = $(CHECKOUTS)/Alamofire
ARGO = $(CHECKOUTS)/Argo
CURRY = $(CHECKOUTS)/Curry
PROMISE_K = $(CHECKOUTS)/PromiseK
RUNES = $(CHECKOUTS)/Runes

ALAMOFIRE_SRC = $(ALAMOFIRE)/Source/*.swift
ARGO_SRC = $(ARGO)/$(CHECKOUTS)/Runes/Source/Runes.swift $(ARGO)/Argo/Operators/*.swift $(ARGO)/Argo/Types/Decoded/*.swift $(ARGO)/Argo/Types/*.swift $(ARGO)/Argo/Extensions/*.swift $(ARGO)/Argo/Functions/*.swift
CURRY_SRC = $(CURRY)/Source/*.swift
PROMISE_K_SRC = $(PROMISE_K)/Source/*.swift
RUNES_SRC = $(RUNES)/Source/*.swift

all: alamofire argo curry promisek runes app

alamofire:
	swiftc -emit-module -module-name Alamofire $(ALAMOFIRE_SRC)
	swiftc -emit-library -module-name Alamofire $(ALAMOFIRE_SRC)

argo:
	swiftc -emit-module -module-name Argo $(ARGO_SRC)
	swiftc -emit-library -module-name Argo $(ARGO_SRC)

curry:
	swiftc -emit-module -module-name Curry $(CURRY_SRC)
	swiftc -emit-library -module-name Curry $(CURRY_SRC)

promisek:
	swiftc -emit-module -module-name PromiseK $(PROMISE_K_SRC)
	swiftc -emit-library -module-name PromiseK $(PROMISE_K_SRC)

runes:
	swiftc -emit-module -module-name Runes $(RUNES_SRC)
	swiftc -emit-library -module-name Runes $(RUNES_SRC)

app:
	swiftc -I . -L . -lAlamofire -lArgo -lCurry -lPromiseK -lRunes Extensions/*.swift *.swift

.PHONY: clean
clean:
	rm *.swiftdoc *.swiftmodule *.dylib main
