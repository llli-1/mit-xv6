// 收集空闲内存的函数
uint64 kcollect_freemem(void)
{
   int freemem = 0;
   struct run *r;
   acquire(&kmem.lock);
   r = kmem.freelist;
   while(r){
   // PGSIZE是定义在kernel/param.h中的宏，代表一个页面大小为4KB
      freemem += PGSIZE;
      r = r->next;
   }
   release(&kmem.lock);
   return freemem;
 }
 
 // 收集进程数量
 uint64 collect_process(void)
{
  struct proc *p;
  int process_num = 0;
  for(p = proc; p < &proc[NPROC]; p++) {
   // 看上面的procdump函数中定义了的state
	if(p->state != UNUSED){
	  // 只是读取进程列表的话不需要写
	  // acquire(&p->lock);
	  process_num++;
	  // release(&p->lock);
	}
  }
  return process_num;
}

// 最后编写系统调用的代码
uint64 sys_sysinfo(void)
{
   uint64 addr;
   if(argaddr(0, &addr) < 0)
        return -1;
   struct sysinfo sinfo;
   sinfo.freemem = kcollect_freemem();
   sinfo.nproc = collect_process();

   // 使用copyout
   if(copyout(myproc()->pagetable, addr, (char*)&sinfo, sizeof(sinfo)))
        return -1;
   return 0;
}
