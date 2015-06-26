#include <iostream>

int main(){

//Node structure
struct node{
	int value;
	node* next;
};

//First element pointer
node * first = new node; 

first->value=-1;

//Fill up the linkedlist
node* current = first;
for(int i=0; i<50; ++i){
  node* nextnode = new node;
	current->next = nextnode;
  current = nextnode;
	current->value = i;
}
current->next = NULL;

//Print the list
current = first;
while(current != NULL){
	std::cout << current->value << std::endl;
	node * previous = current;  
	current = current->next;
	delete previous; 
}

return 0;
}



