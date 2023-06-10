#include"kernel/types.h"
#include"kernel/stat.h"
#include"user/user.h"
void prime(int pi[2]){

	close(pi[1]);
	int p;
	int n = read(pi[0], &p, sizeof(p));
	// 每次选一个最小的就是这一列的素数，因为其他的都在前面过滤掉了
	// 没有数据传输的时候就关掉管道写端，这样管道读端read所得就是0，根据这个退出递归
	if(n == 0)
		exit(0);
	printf("prime %d\n", p);
	
	int pNext[2];
	pipe(pNext);
	
	if(fork() == 0){
		close(pNext[1]);
		prime(pNext);
		close(pi[0]);
		exit(0);
		
	}
	else{
		close(pNext[0]);
		int num;
		while((n = read(pi[0], &num, sizeof(num))) > 0){
	       	if(num % p != 0){
				// 剩下的这排数要通过管道传给下一个子进程
				if(write(pNext[1], &num, sizeof(num)) == -1){
					printf("write error\n");
					exit(1);
				}
		 	}	
		}
		close(pNext[1]);
		wait(0);
		close(pi[0]);
		exit(0);		
	}	
}

int main(int argc, char* argv[]){
	// 父进程从2开始循环数字，写进一个管道里，然后筛2、3、5、7、、、
	
	int p[2];
	pipe(p);
	if(fork() != 0){
        	close(p[0]);
		for(int i = 2; i <= 35; i++){
			write(p[1], &i, sizeof(i));
		}
		close(p[1]);
		wait(0);
		exit(0);
	}
	else{
		close(p[1]);
		prime(p);
		close(p[0]);
		exit(0);
	}
}
