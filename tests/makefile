SOURCES=learning
ASMCOMP=rgbasm
ASMLINK=rgblink
EMUL=sameboy

all: compile link play

compile:
	$(ASMCOMP) $(SOURCES).asm -o $(SOURCES).o

link:
	$(ASMLINK) $(SOURCES).o -o $(SOURCES).gb

play:
	$(EMUL) $(SOURCES).gb

clean:
	rm *.o *.gb
