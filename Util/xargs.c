#include"kernel/types.h"
#include"kernel/param.h"
#include"kernel/stat.h"
#include"user/user.h"
#include<stddef.h>
#define MAXBUF 128
int main(int argc, char* argv[]){
	
	char* args[MAXARG]; // 参数数组
	int n = 0; // 参数个数
	char buf[MAXBUF]; // 缓冲区
	
	// 把xargs后面的参数也保存到参数数组中
	for(int i = 1; i < argc; i++){
		args[i] = malloc(strlen(argv[i]) + 1);
		strcpy(args[n++], argv[i]);
	}
	args[n] = NULL;
	
	
	// 读取每一行-读到的每一行再分割
	while(1){
		int j = 0; // 下标：记录缓存区读到的位置
	
		int len = 0;
		while((len = read(0, &buf[j], 1)) > 0){
			if(buf[j] == '\n' )  break; // 读完一行之后退出
			j++; // 下标增加
		}
		if(len == 0) break;
		
		buf[j] = '\0'; // buf[j]和p都指向同一位置，替换buf[j]的话，p也是替换了的
		args[argc-1]=buf; 
		if(fork() == 0){
			exec(args[0], args); // args[0]:命令；args[1]作为参数列表的起始位置
			exit(0);
		}
		else{
			wait(0);

		}
	}
	exit(0);
}
