LEX=flex

ba: lex.yy.c
	gcc -o $@ $(LDFLAGS) $^ -lfl

lex.yy.c: hw1.l
	$(LEX) $^

clean: 
	$(RM) ba *.o lex.yy.c
