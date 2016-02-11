/*
*  Camron Godbout
* 1/26/16
* Baby Assembly Compiler
*
*/

crap ","" "*
tab [\t]*
reg "r"[0-7]{1}
rg2 [^\$](r[0-7]{1})
imrg2 [^\$]?([0-9]+)
drg2 ([A-Za-z_]+)
inrg2 [^\$]("("?"r"[0-7]{1}")"?)
pre [ \0\t\s]*,*[ \0\t\s]*

    #include <stdbool.h>
    bool alreadyReg1 = false;
    bool allocInstr = false;
    unsigned char opcode = 0;
    unsigned char mode = 0;
    short labelSize = 0;
    short lineNumbers = 0;
    char *label = "";
    char *reg1 = "";
    char *reg2 = "";
    enum comp { LESS, EQUAL, GREATER };
    unsigned char compVar = 0;
    short im_constant;
    int handleBranch(unsigned char opcode, char* label);
    int handleLabel(char *label);
    int executeInstructions();
    int processRg1(unsigned char opcode, unsigned char mode, char *reg1);
    int processRg2(unsigned char opcode, char *reg1, char *reg2);
    int processDRg2(unsigned char opcode, char *reg1, char *var);
    int processInRg2(unsigned char opcode, char *reg1, char *reg2);
    int processImRg2(unsigned char opcode, char *reg1, short imm_constant);
    int processAlloc(char *label, short size);
    int executeLoad(int i);
    int executeLoada(int i);
    int executeStore(int i);
    int executeMove(int i);
    int executeAdd(int i);
    int executeSub(int i);
    int executeMul(int i);
    int executeDiv(int i);
    int executeMod(int i);
    int executeCmp(int i);
    int executeB(int *i);
    int executeBlt(int *i);
    int executeBle(int *i);
    int executeBne(int *i);
    int executeBeq(int *i);
    int executeBge(int *i);
    int executeBgt(int *i);
    int executeWrite(int i);
    int executeRead(int i);
%%

"$"[A-Za-z_]+ {
               char *mystring;
	       mystring = malloc(yyleng+1);
	       strcpy(mystring, yytext);
               handleBranch(opcode, mystring);
	       /*fprintf(stderr, "this is a label breh");*/
	      }

"$"[A-Za-z_]+":" {
                  char *mystring;
		  mystring = malloc(yyleng+1);
		  yytext[yyleng - 1]='\0';
		  strcpy(mystring, yytext);
                  handleLabel(mystring);
		  /*fprintf(stderr, "this is a label branch");*/
		 }

{crap}


[\n]  {
       if(allocInstr) {
         labelSize = 1;
	 //fprintf(stderr, "%s", yytext);
	 processAlloc(label, labelSize);
	 allocInstr = false;
       } else if (reg1 != "" && alreadyReg1 == true) {
         processRg1(opcode, mode,reg1);
       }
       lineNumbers++;
       alreadyReg1 = false;
       reg1 = "";
       reg2 = "";
       opcode = 0;
       label = "";
       labelSize = 0;
      }

{reg}  {
          if (alreadyReg1 == false) {
            //fprintf(stderr, "this is reg1: ");
            reg1= malloc(yyleng+1);
            strcpy(reg1, yytext);
            //fprintf(stderr, "%s", reg2);
	    alreadyReg1 = true;
	  }
	  else  {
	    //fprintf(stderr, "this is reg2: ");
	    reg2 = malloc(yyleng+1);
	    strcpy(reg2, yytext);
	    //fprintf(stderr, "%s", reg2);
	    processRg2(opcode, reg1, reg2);
	    alreadyReg1 = false;
	  }
       }

{rg2} {
         if (alreadyReg1) {
           //fprintf(stderr, "this is reg2: ");
           reg2 = malloc(yyleng+1);
           strcpy(reg2, yytext); 
           //fprintf(stderr, "%s", reg2);
	   processRg2(opcode, reg1, reg2);
	   alreadyReg1 = false;
	 }
      }



{drg2} { if(allocInstr) 
         {
	   char *s = yytext;
	   while(isspace(*s)) s++;
	   label= malloc(strlen(s)+1);
	   strcpy(label, s);
	   //fprintf(stderr, "%s", label);
         }
         if(alreadyReg1) {
	   //fprintf(stderr, "this is direct reg2: ");
	   reg2 = malloc(yyleng+1);
	   strcpy(reg2, yytext);
	   //fprintf(stderr, "%s", reg2);
	   processDRg2(opcode, reg1, reg2);
	   alreadyReg1 = false;
	 }
       }

{imrg2} { //double threat regex
         if(allocInstr) 
	 {
	   labelSize = atoi(yytext);
	   //fprintf(stderr, "%s", yytext);
	   processAlloc(label, labelSize);
	   allocInstr = false;
	 }
         if(alreadyReg1) {
	   //fprintf(stderr, "this is immediate reg2: ");
	   im_constant = atoi(yytext);
	   //fprintf(stderr, "%s", yytext);
	   processImRg2(opcode, reg1, im_constant);
	   alreadyReg1 = false;
	 }
       }

{inrg2} {
        if(alreadyReg1) {
	  //fprintf(stderr, "this is indirect reg2: ");
	  reg2 = malloc(yyleng+1);
	  strcpy(reg2, yytext);
	  //fprintf(stderr, "%s", reg2);
	  processInRg2(opcode, reg1, reg2);
	  alreadyReg1 = false;
	}

       }

{pre}\.alloc{pre}   {allocInstr = true;/* fprintf(stderr, "alloc. : ");*/}


{pre}load{pre} {opcode = 0;/*fprintf(stderr, "load");*/}

{pre}loada{pre}  {opcode = 1;/*fprintf(stderr, "loada");*/}

{pre}store{pre}  {opcode = 2;/*fprintf(stderr,"store");*/}

{pre}move{pre}  {opcode = 3;/*fprintf(stderr, "move");*/}

{pre}add{pre}  {opcode = 4;/*fprintf(stderr, "add");*/}

{pre}sub{pre}  {opcode = 5;/*fprintf(stderr, "sub");*/}

{pre}mul{pre}  {opcode = 6;/*fprintf(stderr, "sub");*/}

{pre}div{pre}  {opcode = 7;/*fprintf(stderr, "div");*/}

{pre}mod{pre}  {opcode = 8;/*fprintf(stderr, "mod");*/}

{pre}cmp{pre}  {opcode = 9;/*fprintf(stderr, "cmp");*/}

{pre}b{pre} {opcode = 10;/*fprintf(stderr, "b");*/}

{pre}blt{pre} {opcode = 11;/*fprintf(stderr, "blt");*/}

{pre}ble{pre} {opcode = 12;/*fprintf(stderr, "ble");*/}

{pre}bne{pre} {opcode = 13;/*fprintf(stderr, "bne");*/}

{pre}beq{pre} {opcode = 14;/*fprintf(stderr, "beq");*/}

{pre}bge{pre} {opcode = 15;/*fprintf(stderr, "bge");*/}

{pre}bgt{pre} {opcode = 16;/*fprintf(stderr, "bgt");*/}

{pre}write{pre} {opcode = 17;/*fprintf(stderr, "write");*/}

{pre}read{pre} {opcode = 18; /*fprintf(stderr, "read");*/}

<<EOF>> {/*fprintf(stderr, "you found the end of the file.. nioce \n");*/executeInstructions();yyterminate();}

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
    char *status;
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
struct nlist *install(char *name, char *defn, char *status)
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
	free((void *) np->status);
    if ((np->defn = strdup(defn)) == NULL)
       return NULL;
    if ((np->status = strdup(status)) == NULL)
       return NULL;
    return np;
}
//end of nlist implementation from The C Programming Language 2nd edition

enum opCodes { LOAD, LOADA, STORE, MOVE, ADD, SUB, MUL, DIV, MOD, CMP, B, BLT, BLE, BNE, BEQ, BGE, BGT, WRITE, READ };
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
long int mainMemory[MAX];
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

//$label: is a resolved label. Store in symbol table
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
//when finally get down to $done... the backpatch it

int processAlloc(char *label, short size) {
  //access symbol table
  //symtab: (list: pc)
  //allocate main memory size long
  struct nlist *look;
  look = lookup(label);
  if (look != NULL) {
    //duplicate allocation error
    fprintf(stderr, "Duplicate allocation error");
    yyterminate();
    exit(1);
  }
  struct nlist *np;
  char conv[10];
  sprintf(conv, "%d", freep);
  np = install(label, conv, "ID");
  int i;
  freep += size;
  
  //types of alloc errors:
  // if there is already a symbol duplicate allocation
  // direct addressing reference and its not in symbol table (undeclared variable error
  
  //see a label followed by a colon and its already there and already resolved
  //check to see if any unresolved labels left.. if so thats an error.
  
}

int processRg1(unsigned char opcode, unsigned char mode, char *reg1)
{
  programText[pc].op_code = opcode;
  while(*reg1 != 'r') reg1++;
  unsigned char reg1_no = reg1[1] - '0';
  programText[pc].reg1_no = reg1_no;
  programText[pc].mode = mode;
  pc++;

}

int processRg2(unsigned char opcode, char *reg1, char *reg2) 
{
  programText[pc].op_code = opcode;
  while(*reg1 != 'r') reg1++;
  unsigned char reg1_no = reg1[1] - '0';
  programText[pc].reg1_no = reg1_no;
  programText[pc].mode = REGISTER;
  while (*reg2 != 'r') reg2++;
  unsigned char reg2_no = reg2[1] - '0';
  programText[pc].arg2.reg2_no = reg2_no;
  pc++;
    
}

int processDRg2(unsigned char opcode, char *reg1, char *var) 
{
  programText[pc].op_code = opcode;
  while (*reg1 != 'r') reg1++;
  unsigned char reg1_no = reg1[1] - '0';
  programText[pc].reg1_no = reg1_no;
  programText[pc].mode = DIRECT;
  struct nlist *np;
  np = lookup(var);
  if (np == NULL) 
  {
    //throw undeclared variable error
    fprintf(stderr, "Undeclared variable error");
    yyterminate();
    exit(1);
  }
  unsigned short loc = atoi(np->defn);
  programText[pc].arg2.loc = loc;
  pc++;
}

int processInRg2(unsigned char opcode, char *reg1,char *reg2) 
{
  programText[pc].op_code = opcode;
  while(*reg1 != 'r') reg1++;
  unsigned char reg1_no = reg1[1] - '0';
  programText[pc].reg1_no = reg1_no;
  programText[pc].mode = INDIRECT;
  while(*reg2 != 'r') reg2++;
  unsigned char reg2_no = reg2[1] - '0';
  programText[pc].arg2.reg2_no = reg2_no;
  pc++;
}

int processImRg2(unsigned char opcode, char *reg1, short imm_constant) 
{
  programText[pc].op_code = opcode;
  while(*reg1 != 'r') reg1++;
  unsigned char reg1_no = reg1[1] - '0';
  programText[pc].reg1_no = reg1_no;
  programText[pc].mode = IMMEDIATE;
  programText[pc].arg2.imm_const = imm_constant;
  pc++;
}

int handleBranch(unsigned char opcode, char *label) 
{
  programText[pc].op_code = opcode;
  struct nlist *np;
  np = lookup(label);
  if (np == NULL)
  {
    //we add it and put pc of 0 with
    programText[pc].arg2.loc = 0;
    char temp[10];
    sprintf(temp, "%d", pc);
    np = install(label, temp, "UNRESOLVED");
  } else if (strstr(np->status, "UNRESOLVED") != NULL)
  {
    
    programText[pc].arg2.loc = atoi(np->defn);
    char temp[10];
    sprintf(temp, "%d", pc);
    np = install(label, temp, "UNRESOLVED");
  } else 
  {
    programText[pc].arg2.loc = atoi(np->defn);
  }
  pc++;
}

int handleLabel(char *label)
{
  struct nlist *np;
  np = lookup(label);
  if (np == NULL) 
  {
    char temp[10];
    sprintf(temp, "%d", pc);
    np = install(label, temp, "RESOLVED");
  }
  else if (strstr(np->status, "UNRESOLVED") != NULL)
  {
    int next = atoi(np->defn);
    char temp[10];
    sprintf(temp, "%d", pc);
    np = install(label, temp, "RESOLVED");
    int current;
    while(next != 0) {
      current = next;
      next = programText[current].arg2.loc;
      programText[current].arg2.loc = pc;
    }
  }
  else if (strstr(np->status, "RESOLVED"))
  {
    fprintf(stderr, "duplicate  label error");
    yyterminate();
    exit(1);
  }
}

int executeInstructions() 
{
 int i;
 for(i = 1; i < pc; i++){
   switch(programText[i].op_code) {
     case LOAD: executeLoad(i);
     break;
     case LOADA: executeLoada(i);
     break;
     case STORE: executeStore(i);
     break;
     case MOVE: executeMove(i);
     break;
     case ADD: executeAdd(i);
     break;
     case SUB: executeSub(i);
     break;
     case MUL: executeMul(i);
     break;
     case DIV: executeDiv(i);
     break;
     case MOD: executeMod(i);
     break;
     case CMP: executeCmp(i);
     break;
     case B: executeB(&i);
     break;
     case BLT: executeBlt(&i);
     break;
     case BLE: executeBle(&i);
     break;
     case BNE: executeBne(&i);
     break;
     case BEQ: executeBeq(&i);
     break;
     case BGE: executeBge(&i);
     break;
     case BGT: executeBgt(&i);
     break;
     case WRITE: executeWrite(i);
     break;
     case READ: executeRead(i);
     break;
   }
 }
}

int executeLoad(int i) {
  switch(programText[i].mode) {
    case DIRECT:
      r[programText[i].reg1_no] = mainMemory[programText[i].arg2.loc];
    break;
    case INDIRECT:
      r[programText[i].reg1_no] = mainMemory[r[programText[i].arg2.reg2_no]];
    break;

  }
}

int executeLoada(int i) {
  switch(programText[i].mode){
    case DIRECT:
      r[programText[i].reg1_no] = programText[i].arg2.loc;
    break;
    case INDIRECT:
      r[programText[i].reg1_no] = r[programText[i].arg2.reg2_no];
    break;
  }
}

int executeStore(int i) {
  switch(programText[i].mode){
    case DIRECT:
      mainMemory[programText[i].arg2.loc] = r[programText[i].reg1_no];
    break;
    case INDIRECT:
      mainMemory[r[programText[i].arg2.reg2_no]] = r[programText[i].reg1_no];
    break;
  }
}

int executeMove(int i) {
  switch(programText[i].mode){
    case REGISTER:
      r[programText[i].reg1_no] = r[programText[i].arg2.reg2_no];
    break;
    case IMMEDIATE:
      r[programText[i].reg1_no] = programText[i].arg2.imm_const;
    break;
  }
}

int executeAdd(int i) {
switch(programText[i].mode){
    case REGISTER:
      r[programText[i].reg1_no] += r[programText[i].arg2.reg2_no];
    break;
    case IMMEDIATE:
      r[programText[i].reg1_no] += programText[i].arg2.imm_const;
    break;
  }
}

int executeSub(int i) {
  switch(programText[i].mode){
    case REGISTER:
      r[programText[i].reg1_no] -= r[programText[i].arg2.reg2_no];
    break;
    case IMMEDIATE:
      r[programText[i].reg1_no] -= programText[i].arg2.imm_const;
    break;
  }
}

int executeMul(int i) {
  switch(programText[i].mode){
    case REGISTER:
      r[programText[i].reg1_no] *= r[programText[i].arg2.reg2_no];
    break;
    case IMMEDIATE:
      r[programText[i].reg1_no] *= programText[i].arg2.imm_const;
    break;
  }
}

int executeDiv(int i) {
  switch(programText[i].mode){
    case REGISTER:
      r[programText[i].reg1_no] /= r[programText[i].arg2.reg2_no];
    break;
    case IMMEDIATE:
      r[programText[i].reg1_no] /= programText[i].arg2.imm_const;
    break;
  }
}

int executeMod(int i) {
  switch(programText[i].mode){
    case REGISTER:
      r[programText[i].reg1_no] %= r[programText[i].arg2.reg2_no];
    break;
    case IMMEDIATE:
      r[programText[i].reg1_no] %= programText[i].arg2.imm_const;
    break;
  }
}

int executeCmp(int i) {
  switch(programText[i].mode){
    case REGISTER:
      if (r[programText[i].reg1_no] == r[programText[i].arg2.reg2_no]){
        compVar = EQUAL;
      } else if (r[programText[i].reg1_no] < r[programText[i].arg2.reg2_no]){
        compVar = LESS;
      } else {
        compVar = GREATER;
      }
    break;
    case IMMEDIATE:
      if (r[programText[i].reg1_no] == programText[i].arg2.imm_const) {
        compVar = EQUAL;
      } else if (r[programText[i].reg1_no] < programText[i].arg2.imm_const){
        compVar = LESS;
      } else {
        compVar = GREATER;
      }
    break;
  }
}

int executeB(int *i) {
  int sub = *i;
  *i = programText[sub].arg2.loc-1;
}

int executeBlt(int *i) {
  if (compVar == LESS) {
    int sub = *i;
    *i = programText[sub].arg2.loc-1;
  }
}

int executeBle(int *i) {
  if (compVar == LESS || compVar == EQUAL) {
    int sub = *i;
    *i = programText[sub].arg2.loc-1;
  }
}

int executeBne(int *i) {
  if (compVar == LESS || compVar == GREATER) {
    int sub = *i;
    *i = programText[sub].arg2.loc-1;
  }
}


int executeBeq(int *i) {
  if(compVar == EQUAL) {
    int sub = *i;
    *i = programText[sub].arg2.loc-1;
  }
}

int executeBge(int *i) {
  if(compVar == EQUAL || compVar == GREATER) {
    int sub = *i;
    *i = programText[sub].arg2.loc-1;
  }
}
int executeBgt(int *i) {
  if(compVar ==  GREATER) {
    int sub = *i;
    *i = programText[sub].arg2.loc-1;
  }
}

int executeWrite(int i) {
  fprintf(stdout, "%ld\n", r[programText[i].reg1_no]);
}

int executeRead(int i) {
  scanf("%ld", &r[programText[i].reg1_no]);
}


