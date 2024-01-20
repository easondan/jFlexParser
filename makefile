JAVAC=javac
#JFLEX=jflex
JFLEX=/Users/eason/jflex-1.9.1/bin/jflex

all: Token.class Lexer.class Scanner.class

%.class: %.java
	$(JAVAC) $^

Lexer.java: doc.flex
	$(JFLEX) doc.flex

clean:
	rm -f Lexer.java *.class *~
