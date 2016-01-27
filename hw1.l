/*
*  Camron Godbout
* 1/26/16
* Baby Assembly Compiler
*
*/
	int instructions[65536];

reg "r"[0-7]{1}

%%

"$"[A-Za-z_]+":" {printf("this is a label breh");}

" "*"."alloc" "+[A-Za-z_]+","?" "*[0-9]* {printf("alloc thisssssss");}

" "*load {printf("load");}

" "*loada {printf("loada");}

" "*store {printf("store");}

" "*move {printf("move");}

" "*add {printf("add");}

" "*sub {printf("sub");}

" "*mul {printf("sub");}

" "*div {printf("div");}

" "*mod {printf("mod");}

<<EOF>> {printf("you found the end of the file.. nioce \n");yyterminate();}

%%
int main(argc, argv)
int argc;
char **argv;
{
  ++argv, --argc;
  if (argc > 0)
  {
    yyin = fopen(argv[0], "r");
  }
  else
  {
    yyin = stdin;
  }
  yylex();
}

