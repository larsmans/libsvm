CC ?= gcc
CXX ?= g++
CFLAGS = -Wall -Wconversion -O3 -fPIC
CXXFLAGS = -Wall -Wconversion -O3 -fPIC
SHVER = 2
OS = $(shell uname)

all: svm-train svm-predict svm-scale

lib: svm.o
	if [ "$(OS)" = "Darwin" ]; then \
		SHARED_LIB_FLAG="-dynamiclib -Wl,-install_name,libsvm.so.$(SHVER)"; \
	else \
		SHARED_LIB_FLAG="-shared -Wl,-soname,libsvm.so.$(SHVER)"; \
	fi; \
	$(CXX) $${SHARED_LIB_FLAG} svm.o -o libsvm.so.$(SHVER)

svm-predict: svm-predict.o svm.o
	$(CXX) $(CXXFLAGS) svm-predict.o svm.o -o svm-predict -lm
svm-train: svm-train.o svm.o
	$(CXX) $(CXXFLAGS) svm-train.o svm.o -o svm-train -lm
svm-scale: svm-scale.o
	$(CC) $(CFLAGS) svm-scale.o -o svm-scale
svm.o: svm.cpp svm.h
	$(CXX) $(CXXFLAGS) -c svm.cpp
clean:
	rm -f *~ svm.o svm-train svm-predict svm-scale libsvm.so.$(SHVER)
