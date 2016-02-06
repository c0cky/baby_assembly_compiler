/*
*  Camron Godbout
* 1/26/16
* Baby Assembly Compiler
*
*/


reg "r"[0-7]{1}
rg2 ","" "*(("("?"r"[0-7]{1}")"?)|([0-9]+)|([A-Za-z_]+))

    unsigned char opcode = -1;

%%

"$"[A-Za-z_]+":" {printf("this is a label breh");}

" "*"."alloc" "+[A-Za-z_]+","?" "*[0-9]* {printf("alloc thisssssss");}

" "*load" "*{reg}{rg2} {opcode = 0;printf("load");}

" "*loada" "*{reg}{rg2}  {opcode = 1;printf("loada");}

" "*store" "*{reg}{rg2}  {opcode = 2;printf("store");}

" "*move" "*{reg}{rg2}  {opcode = 3;printf("move");}

" "*add" "*{reg}{rg2}  {opcode = 4;printf("add");}

" "*sub" "*{reg}{rg2}  {opcode = 5;printf("sub");}

" "*mul" "*{reg}{rg2}  {opcode = 6;printf("sub");}

" "*div" "*{reg}{rg2}  {opcode = 7;printf("div");}

" "*mod" "*{reg}{rg2}  {opcode = 8;printf("mod");}

" "*cmp" "*{reg}{rg2}  {opcode = 9;printf("cmp");}

<<EOF>> {printf("you found the end of the file.. nioce \n");yyterminate();}

%%

#define MAX 65536

#include <stdlib.h>
#define INITIAL_HASH_SIZE 8
#define MAX_LOAD_FACTOR 2
#define SCALE_FACTOR 2
int h_size;     // Current size of the hash table array
int num_items;  // Number of items stored in the dictionary
DR *hash_tab;   // The actual array (dynamically allocated)
h_size = INITIAL_HASH_SIZE;
/* Assume DR is a type defined as a pointer to a hash table record */
hash_tab = (DR *) malloc(h_size * sizeof(DR));

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
int freep = 0;
long int r[8];
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

//$ is a resolved label. Store in symbol table
//identifier, resolved, and unresolved label
//indirect is store r0, (r2) look at contents of r2
//interpret as index of main memory and get that

//put 0 for a null pointer for a forward branch
//add to dictionary forward reference to instruction #


//blt $done
//sub r1, w
//cmp r1, r0
//bgt $done

//put a pointer for bgt back to the blt then update the 
//dictionary $done: 12 (the bgt index)
//when finally get down to $done... the backpack it

int preProcessAllocFunction(char *instructionString) {
  char *s = instructionString;
  char *label;
  while(*s != '.') s++;
  s += 6; //skip over ".alloc"
  while(!isalpha(*s)) s++;
  label += s;
  s++;
  while((isalpha(*s) || isdigit(*s)) && *s != ',' && *s != ' ') s++;
  
}

int processAllocFunction(char *name,unsigned char size) {
  //access symbol table
  //symtab: (list: pc)
  //allocate main memory size long


  //types of alloc errors:
  // if there is already a symbol duplicate allocation
  // direct addressing reference and its not in symbol table (undeclared variable error
  
  //see a label followed by a colon and its already there and already resolved
  //check to see if any unresolved labels left.. if so thats an error.


  freep += size;
  
}

int preProcessLoadInstruction(char *instructionString) {
  char *s = instructionString;
  while(*s != 'l') s++;
  s += 4; //skip over "load"
  while(*s != 'r') s++; //first arg will be a register
  reg1_no = s[1] - '0';//get the reg no of 
}

int processInstruction(char *opcode, unsigned char mode, unsigned char reg1, unsigned char other) {
  
}

int hash(const char *key, int h_size)
{
  int sum = 0;
  for (; *key; key++)
    sum = (37*sum + *key) % h_size;
  return sum;
}
