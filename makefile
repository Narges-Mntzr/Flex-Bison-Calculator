all:	
	bison -d parser.y
	flex lex.l
	g++ parser.tab.c lex.yy.c -lm -o parser

clean:
	rm -r *.o *.c  *.tab.* parser