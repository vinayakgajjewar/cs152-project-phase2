CC = gcc
CFLAGS = -g -O0 -std=c99

minil: miniL.lex miniL.y
	bison -d -v --file-prefix=y miniL.y
	flex miniL.lex	
	gcc -o parser y.tab.c lex.yy.c -lfl
	rm -f lex.yy.c
 

clean:
	rm -f *.o