#include"kernel/types.h"
#include"kernel/stat.h"
#include"kernel/fs.h"
#include"user/user.h"

void find(char* path, char* fileName){
	char buf[512], * p;
	int fd;
	struct dirent de;
	struct stat st;
	
	// 打开要遍历的目录，并获取文件描述符
	if((fd = open(path,0)) < 0){
		fprintf(2, "find: cannot open) %s\n", path);
		return;
	}
	if(fstat(fd, &st) < 0){
   		fprintf(2, "find: cannot stat %s\n", path);
    		close(fd);
    		return;
  	}
	switch(st.type){
		case T_FILE:
			// 判断读取到的目录项的名称是否与要查找的文件名相同
			if(strcmp(path+strlen(path)-strlen(fileName),fileName) == 0){
				printf("%s\n",path);
			}
			break;
		case T_DIR:
			strcpy(buf, path);
    			p = buf+strlen(buf);
    			*p++ = '/';
			// 使用read系统调用，从文件描述符中读取子目录项的信息
			while(read(fd, &de, sizeof(de)) == sizeof(de)){
				if(de.inum == 0)
					continue;
				memmove(p, de.name, DIRSIZ);
				p[DIRSIZ] = 0;
				if(stat(buf, &st) < 0){
					printf("find: cannot stat %s\n", buf);
					continue;
				}
				// 对每一个子目录项再递归查找，但不能递归. 和 ..
				if(strcmp(buf+strlen(buf)-2, "/.") != 0 && strcmp(buf+strlen(buf)-3, "/..") != 0)
				find(buf,fileName);
			}
			break;
	}
	close(fd);
}
int main(int argc, char* argv[]){
	if(argc < 3){
		printf("find : no argument\n");
		exit(0);
	}
	// 需要为查找到的文件名添加 / 在开头
	char fileName[512];
	fileName[0] = '/';
	strcpy(fileName+1, argv[2]);
	find(argv[1], fileName);
	exit(0);
}
