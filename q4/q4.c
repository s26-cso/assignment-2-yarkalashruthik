#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dlfcn.h> // library which is used for doing dynamic loading operations
int main() {
    char op[6];
    int a, b;
    while (scanf("%5s %d %d",op,&a,&b)==3){ //loop till EOF
        // then string "./lib<op>.so" is construced,./ to look in the current directory
        char lib_name[50];
        char prefix[]="./lib";
        char suffix[]=".so";
        int n=strlen(op);
        for(int i=0;i<5;i++) lib_name[i]=prefix[i];
        for(int i=0;i<n;i++) lib_name[i+5]=op[i];
        for(int i=0;i<4;i++) lib_name[i+n+5]=suffix[i]; //null terminator copied from suffix itself
        void *handle = dlopen(lib_name,RTLD_LAZY); //Dynamically load the shared library into memory with lazy loading
        typedef int (*operation_func)(int, int);
        operation_func func=(operation_func)dlsym(handle,op); //finding and loading the function from lib
        int result=func(a,b);
        printf("%d\n", result);
        dlclose(handle); //unload the library to preserve memory
    }
    return 0;
}