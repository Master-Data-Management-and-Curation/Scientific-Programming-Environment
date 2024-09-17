// C program to implement the cat view file functionality 
#include <stdio.h> 
#include <string.h>
#include <unistd.h>

// function to print file contents 
void print_file(const char* filename) 
{ 
	FILE *file = fopen(filename, "r"); 
	if (file == NULL) { 
		printf("Unable to open file %s\n", filename); 
		return; 
	} 

	// Read and print the file 
	char ch; 
	while ((ch = fgetc(file)) != EOF) {
          putchar(ch);
	  usleep(1000);
	} 

	// Close the file 
	fclose(file); 
} 

// driver code 
int main(int argc, char* argv[]) 
{ 
	FILE* file; 
	char ch; 

	// Check if filename was given or not 
	if (argc != 2) { 
		printf("Usage: %s filename\n", argv[0]); 
		return 1; 
	} 

	// calling function to read file 
	print_file(argv[1]); 

	return 0; 
}
