// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"


void freerange(void *pa_start, void *pa_end);

extern char end[]; // first address after kernel.
                   // defined by kernel.ld.

struct run {
  struct run *next;
};

/*struct {
  struct spinlock lock;
  struct run *freelist;
} kmem;*/

struct{
  struct spinlock lock;
  struct run* freelist;
}kmem[NCPU];

char* kmem_lock_names[] = {
  "kmem_cpu0",
  "kmem_cpu1",
  "kmem_cpu2",
  "kmem_cpu3",
  "kmem_cpu4",
  "kmem_cpu5",
  "kmem_cpu6",
  "kmem_cpu7",
};


void kinit()
{
 /* initlock(&kmem.lock, "kmem");
  freerange(end, (void*)PHYSTOP);
 */
  // 给每个cpu的链表锁都初始化
  for(int i = 0; i < NCPU; i++){
    initlock(&kmem[i].lock,kmem_lock_names[i]);
  }
  freerange(end, (void* )PHYSTOP);
}

void freerange(void *pa_start, void *pa_end)
{
 // push_off();
  char *p;
  p = (char*)PGROUNDUP((uint64)pa_start);
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    kfree(p); // 将空闲的页面分配给cpu
  
}

// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void kfree(void *pa)
{
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);

  r = (struct run*)pa;
  
  push_off();
  int cpu = cpuid();

  acquire(&kmem[cpu].lock);
  r->next = kmem[cpu].freelist;
  kmem[cpu].freelist = r;
  release(&kmem[cpu].lock);

  pop_off();
}

/*void steal(int cpu_id){
  int i;
  int c = cpu_id;
  for(i = 0; i < NCPU && i != c; i++){
    struct run *r1,r2,r; // r1,r2充当快慢指针
    acquire(&kmem[i].lock);
    r = kmem[i].freelist;
    r1 = kmem[i].freelist;
    r2 = r1->next;
    if(!r){
       while(r2 != NULL){
	  r2 = r2->next;
	  r2 = r2->next->next;
	}
       kmem[i].freelist = r1;
      // acquire(&kmem[cpu_id].lock);
      //  kmem[c].freelist = r; 
      // release(&kmem[cpu_id].lock);
       release(&kmem[i].lock);
    }
    break;
  }
}
*/

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *kalloc(void)
{
  struct run *r;

  push_off();
  int cpu = cpuid();

  acquire(&kmem[cpu].lock);
  r = kmem[cpu].freelist;
  if(r)
    kmem[cpu].freelist = r->next;
  release(&kmem[cpu].lock);
  
  acquire(&kmem[cpu].lock);
  if(!r){
   // 如果没有空闲物理页
   for(int i = 0; i < NCPU; i++){
     if(i == cpu) continue;
     struct run *r1, *r2; // r1,r2充当快慢指针
     r = r1 = kmem[i].freelist;
     acquire(&kmem[i].lock);
     if(r1){
       r2 = r1->next;
       while(r2){
          r2 = r2->next;
	  if(r2){
 	    r1 = r1->next;
            r2 = r2->next;
          }
          else break;
	}
       kmem[i].freelist = r1->next;
       r1->next = 0;
       release(&kmem[i].lock);
       kmem[cpu].freelist = r->next;
       
       break;
      }
     release(&kmem[i].lock);
   }
  }
   release(&kmem[cpu].lock);
   pop_off();
  
  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
  return (void*)r;
}
