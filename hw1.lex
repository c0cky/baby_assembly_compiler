%%
"load" {printf("load");}

"loada" {printf("loada");}

"store" {printf("store");}

"move" {printf("move");}

"add" {printf("add");}

"sub" {printf("sub");}

"mul" {printf("sub");}

"div" {printf("div");}

"mod" {printf("mod");}

%%
int main()
{
  yylex();
}
