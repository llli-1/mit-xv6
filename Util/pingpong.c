#include"kernel/types.h"
#include"user/user.h"
#include"kernel/stat.h"
int main(int argc, char* argv[]){

	// 第一个管道-父进程写，子进程读
	int ping[2];

	// 第二个管道-子进程写，父进程读
	int pong[2];

	// 创建管道
	pipe(ping);
	pipe(pong);
	int childPid, parentPid;
	
	if(fork() == 0){
		close(0);
	        dup(ping[0]);
		childPid = getpid();
		close(ping[0]);
		close(ping[1]);

		// 子进程读到了之后输出
		printf("%d: received ping\n",childPid);
		// 子进程在第二个管道中写
		close(1);
		write(pong[1], "c", 1);
		close(pong[0]);
		close(pong[1]);
		exit(0);
	}
	else{
		parentPid = getpid();
		write(ping[1], "p", 1);
		close(ping[0]);
		close(ping[1]);

		wait(&childPid);
		// 父进程读
		close(0);
		dup(pong[1]);
		//int parentPid = getpid();
		close(pong[0]);
		close(pong[1]);
		printf("%d: received pong\n",parentPid);
		exit(0);
	}
}
