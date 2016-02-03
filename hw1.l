/*
*  Camron Godbout
* 1/26/16
* Baby Assembly Compiler
*
*/


reg "r"[0-7]{1}
rg2 ","" "*(("("?"r"[0-7]{1}")"?)|([0-9]+)|([A-Za-z_]+))


%%

"$"[A-Za-z_]+":" {printf("this is a label breh");}

" "*"."alloc" "+[A-Za-z_]+","?" "*[0-9]* {printf("alloc thisssssss");}

" "*load" "*{reg}{rg2} {printf("load");}

" "*loada" "*{reg}{rg2}  {printf("loada");}

" "*store" "*{reg}{rg2}  {printf("store");}

" "*move" "*{reg}{rg2}  {printf("move");}

" "*add" "*{reg}{rg2}  {printf("add");}

" "*sub" "*{reg}{rg2}  {printf("sub");}

" "*mul" "*{reg}{rg2}  {printf("sub");}

" "*div" "*{reg}{rg2}  {printf("div");}

" "*mod" "*{reg}{rg2}  {printf("mod");}

" "*cmp" "*{reg}{rg2}  {printf("cmp");}

<<EOF>> {printf("you found the end of the file.. nioce \n");yyterminate();}

%%

#define MAX 65536

enum opCodes { LOAD, LOADA, STORE, MOVE, ADD, SUB, MUL, DIV, MOD, CMP };
enum modes { REGISTER, DIRECT, INDIRECT, IMMEDIATE };
typedef struct INSTRS {
  unsigned char op_code;
  unsigned char mode : 5;
  unsigned char reg1_no : 3;
  union {
    unsigned short loc; //index in one of two arrays
    short imm_const; //immediate constant
    char reg2_no; //these are in different namespaces
  } arg2;
} INSTR; //synonym for this structure type
INSTR programText[MAX];
int pc = 0; //program counter
int freepointer = 0;

int main(argc, argv)
int argc;
char **argv;
{
  ++argv, --argc;
  programText[1].op_code = LOAD;
  programText[1].reg1_no = 6;
  programText[1].mode = DIRECT;
  programText[1].arg2.loc = 100;
  sizeof(INSTR);
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

