/*
*  Camron Godbout
* 1/26/16
* Baby Assembly Compiler
*
*/

crap ","" "*
reg "r"[0-7]{1}
rg2 [^\$]("r"[0-7]{1})
imrg2 [^\$]([0-9]+)
drg2 ([A-Za-z_]+)
inrg2 [^\S]("("?"r"[0-7]{1}")"?)

    #include <stdbool.h>
    bool alreadyReg1 = false;
    unsigned char opcode = -1;
    unsigned char mode = -1;
    char *mystring;
    unsigned char reg1 = -1;
    unsigned char reg2 = -1;
%%

"$"[A-Za-z_]+ {fprintf(stderr, "this is a label breh");}

"$"[A-Za-z_]+":" {fprintf(stderr, "this is a label branch");}

{crap}

[\n]  {alreadyReg1 = false;}

{reg}  {
          if (alreadyReg1 == false) {
          fprintf(stderr, "this is reg1: ");
          mystring = malloc(yyleng+1);
          strcpy(mystring, yytext);
          fprintf(stderr, "%s", mystring);
	  alreadyReg1 = true;
	  }
       }

{rg2} {
         if (alreadyReg1) {
         fprintf(stderr, "this is reg2: ");
         mystring = malloc(yyleng+1);
         strcpy(mystring, yytext); 
         fprintf(stderr, "%s", mystring); 
	 alreadyReg1 = false;
	 }
      }



{drg2} {
         if(alreadyReg1) {
	   fprintf(stderr, "this is direct reg2: ");
	   mystring = malloc(yyleng+1);
	   strcpy(mystring, yytext);
	   fprintf(stderr, "%s", mystring);
	   alreadyReg1 = false;
	 }
       }

{imrg2} {
         if(alreadyReg1) {
	 fprintf(stderr, "this is immediate reg2: ");
	 mystring = malloc(yyleng+1);
	 strcpy(mystring, yytext);
	 fprintf(stderr, "%s", mystring);
	 alreadyReg1 = false;
	 }
       }

{inrg2} {
        if(alreadyReg1) {
	  fprintf(stderr, "this is indirect reg2: ");
	  mystring = malloc(yyleng+1);
	  strcpy(mystring, yytext);
	  fprintf(stderr, "%s", mystring);
	  alreadyReg1 = false;
	}

       }

" "*"."alloc" "+[A-Za-z_]+","?" "*[0-9]* {fprintf(stderr,"alloc thisssssss");}

" "*load" "* {opcode = 0;fprintf(stderr, "load");}

" "*loada" "*  {opcode = 1;fprintf(stderr, "loada");}

" "*store" "*  {opcode = 2;fprintf(stderr,"store");}

" "*move" "*  {opcode = 3;fprintf(stderr, "move");}

" "*add" "*  {opcode = 4;fprintf(stderr, "add");}

" "*sub" "*  {opcode = 5;fprintf(stderr, "sub");}

" "*mul" "*  {opcode = 6;fprintf(stderr, "sub");}

" "*div" "*  {opcode = 7;fprintf(stderr, "div");}

" "*mod" "*  {opcode = 8;fprintf(stderr, "mod");}

" "*cmp" "*  {opcode = 9;fprintf(stderr, "cmp");}

" "*b" "* {opcode = 10;fprintf(stderr, "b");}

" "*ble" "* {opcode = 11;fprintf(stderr, "ble");}

" "*bge" "* {opcode = 12;fprintf(stderr, "bge");}

" "*write" "* {opcode = 13;fprintf(stderr, "write");}

" "*read" "* {opcode = 14; fprintf(stderr, "read");}

<<EOF>> {fprintf(stderr, "you found the end of the file.. nioce \n");yyterminate();}

%%

#define MAX 65536

#include <stdlib.h>

/* 
* nlist is hashtable implementation from C programming book
* taken in section 6.6 of The C programming language 2nd edition
* 
* authored by Dennis Ritchie and Brian Kernighan
*
*
* ACM Citation: 
* Brian W. Kernighan and Dennis M. Ritchie. 1989. The C Programming Language. Prentice Hall Press, Upper Saddle River, NJ, USA.
*/
struct nlist { /* table entry: */
    struct nlist *next; /* next entry in chain */
    char *name; /* defined name */
    char *defn; /* replacement text */
};

#define HASHSIZE 101
static struct nlist *hashtab[HASHSIZE]; /* pointer table */

/* hash: form hash value for string s */
unsigned hash(char *s)
{
    unsigned hashval;
    for (hashval = 0; *s != '\0'; s++)
      hashval = *s + 31 * hashval;
    return hashval % HASHSIZE;
}

/* lookup: look for s in hashtab */
struct nlist *lookup(char *s)
{
    struct nlist *np;
    for (np = hashtab[hash(s)]; np != NULL; np = np->next)
        if (strcmp(s, np->name) == 0)
          return np; /* found */
    return NULL; /* not found */
}

/* install: put (name, defn) in hashtab */
struct nlist *install(char *name, char *defn)
{
    struct nlist *np;
    unsigned hashval;
    if ((np = lookup(name)) == NULL) { /* not found */
        np = (struct nlist *) malloc(sizeof(*np));
        if (np == NULL || (np->name = strdup(name)) == NULL)
          return NULL;
        hashval = hash(name);
        np->next = hashtab[hashval];
        hashtab[hashval] = np;
    } else /* already there */
        free((void *) np->defn); /*free previous defn */
    if ((np->defn = strdup(defn)) == NULL)
       return NULL;
    return np;
}
//end of nlist implementation from The C Programming Language 2nd edition

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
int pc = 1; //program counter
int freep = 0;
long int r[8];
int main(argc, argv)
int argc;
char **argv;
{
  ++argv, --argc;
  //programText[1].op_code = LOAD;
  //programText[1].reg1_no = 6;
  //programText[1].mode = DIRECT;
  //programText[1].arg2.loc = 100;
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
  unsigned char reg1_no = s[1] - '0';//get the reg no of 
}

int processRg2(char *opcode, unsigned char mode, unsigned char reg1, unsigned char reg2) 
{
  
}

int processDRg2(char *opcode, unsigned char mode, unsigned char reg1, char *var) 
{
  
}

int processInRg2(char *opcode, unsigned char mode, unsigned char reg1, unsigned char reg2) 
{
  
}

int processIm(char *opcode, unsigned char mode, unsigned char reg1, short imm_constant) 
{
  
}
