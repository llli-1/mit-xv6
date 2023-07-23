// Buffer cache.
//
// The buffer cache is a linked list of buf structures holding
// cached copies of disk block contents.  Caching disk blocks
// in memory reduces the number of disk reads and also provides
// a synchronization point for disk blocks used by multiple processes.
//
// Interface:
// * To get a buffer for a particular disk block, call bread.
// * After changing buffer data, call bwrite to write it to disk.
// * When done with the buffer, call brelse.
// * Do not use the buffer after calling brelse.
// * Only one process at a time can use a buffer,
//     so do not keep them longer than necessary.


#include "types.h"
#include "param.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "riscv.h"
#include "defs.h"
#include "fs.h"
#include "buf.h"

// bucket number for bufmap
#define NBUFMAP_BUCKET 13 
// hash function for bufmap
#define BUFMAP_HASH(dev, blockno) ((((dev)<<27)|(blockno))%NBUFMAP_BUCKET)

struct {
  // struct spinlock lock;
  //struct buf buf[NBUF];
  // 双向链表
  // Linked list of all buffers, through prev/next.
  // Sorted by how recently the buffer was used.
  // head.next is most recent, head.prev is least.
  //struct buf head;
  struct spinlock eviction_lock; // 
  struct buf buf[NBUF]; // linked list
  struct buf bufmap[NBUFMAP_BUCKET]; // 哈希表
  struct spinlock bufmap_locks[NBUFMAP_BUCKET]; // 每个哈希桶的锁
} bcache;

void binit(void)
{
  /* struct buf *b;
  initlock(&bcache.lock, "bcache");

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }*/

  // 初始化bufmap
  for(int i = 0; i < NBUFMAP_BUCKET; i++){
    initlock(&bcache.bufmap_locks[i], "bcache_bufmap");
    bcache.bufmap[i].next = 0;
  }
  // init buf[]
  for(int i = 0; i < NBUF; i++){
    struct buf* b = &bcache.buf[i];
    initsleeplock(&b->lock, "buffer");
    b->lastuse = 0;
    b->refcnt = 0;
    b->next = bcache.bufmap[0].next; // put all the buffers into bufmap[0]
    bcache.bufmap[0].next = b;
  }
  initlock(&bcache.eviction_lock, "bcache_eviction");
}

// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf* bget(uint dev, uint blockno)
{
 // struct buf *b;

  /* acquire(&bcache.lock);

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    if(b->dev == dev && b->blockno == blockno){
      b->refcnt++;
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }*/

  // Not cached.
  // Recycle the least recently used (LRU) unused buffer.
  /*for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    if(b->refcnt == 0) {
      // 记录新的设备号和扇区号，并获取其休眠锁
      b->dev = dev;
      b->blockno = blockno;
      b->valid = 0; // 确保bread从磁盘读取块数据，而不是使用之前的内容
      b->refcnt = 1;
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");*/
  
  struct buf *b;
  uint key = BUFMAP_HASH(dev, blockno); // get specific cache block
  acquire(&bcache.bufmap_locks[key]); // 获取这个哈希桶对应的锁
  // 如果原来就有这个缓存存在
  for(b = bcache.bufmap[key].next; b; b = b->next){
    if(b->dev == dev && b->blockno == blockno){
      b->refcnt++;
      release(&bcache.bufmap_locks[key]);
      acquiresleep(&b->lock);
      return b;
    }
  }

 // if cache not existed
 release(&bcache.bufmap_locks[key]);

 acquire(&bcache.eviction_lock);
 for(b = bcache.bufmap[key].next; b; b = b->next){
   if(b->dev == dev && b->blockno == blockno){
     acquire(&bcache.bufmap_locks[key]);
     b->refcnt++;
     release(&bcache.bufmap_locks[key]);
     release(&bcache.eviction_lock);
     acquiresleep(&b->lock);
     return b;
   }
 }

 // still not cached-LRU
 struct buf *before_least = 0;
 uint holding_bucket = -1;
 for(int i = 0; i < NBUFMAP_BUCKET; i++){
   acquire(&bcache.bufmap_locks[i]);
   int newfound = 0; // new least-recently-used buf found in this bucket
   for(b = &bcache.bufmap[i]; b->next; b = b->next) {
     if(b->next->refcnt == 0 && (!before_least || b->next->lastuse < before_least->next->lastuse)) {
        before_least = b; // 最近最久未使用的就是这个/更新
        newfound = 1;
      }
    }
   // 如果没有找到最近最久未使用的
   if(!newfound) {
      release(&bcache.bufmap_locks[i]);
    } else {
      if(holding_bucket != -1) release(&bcache.bufmap_locks[holding_bucket]);
      holding_bucket = i;
      // keep holding this bucket's lock....
    }
  }
  if(!before_least) {
    panic("bget: no buffers");
  }
  b = before_least->next;

  if(holding_bucket != key) {
    // remove the buf from it's original bucket
    before_least->next = b->next;
    release(&bcache.bufmap_locks[holding_bucket]);
    // rehash and add it to the target bucket
    acquire(&bcache.bufmap_locks[key]);
    b->next = bcache.bufmap[key].next;
    bcache.bufmap[key].next = b;
  }
  b->dev = dev;
  b->blockno = blockno;
   b->refcnt = 1;
  b->valid = 0;
  release(&bcache.bufmap_locks[key]);
  release(&bcache.eviction_lock);
  acquiresleep(&b->lock);
  return b;
}

// 在内存中获取一个可读取/修改的磁盘块的副本
// Return a locked buf with the contents of the indicated block.
struct buf* bread(uint dev, uint blockno)
{
  struct buf *b;

  // 获得一块缓存-根据给定设备号和扇区号
  b = bget(dev, blockno);
  if(!b->valid) {
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}

// 将修改后的缓冲区写入磁盘上对应的区块
// Write b's contents to disk.  Must be locked.
void bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  virtio_disk_rw(b, 1);
}

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");

  releasesleep(&b->lock);

  /*acquire(&bcache.lock);
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
  release(&bcache.lock);*/
  uint key = BUFMAP_HASH(b->dev, b->blockno);
  acquire(&bcache.bufmap_locks[key]);
  b->refcnt--; // 哈希桶上对应的引用-1
  if(b->refcnt == 0){
    b->lastuse = ticks; // 记录最后一次被使用
  }
  release(&bcache.bufmap_locks[key]);
}

void bpin(struct buf *b) {
  // acquire(&bcache.lock);
  uint key = BUFMAP_HASH(b->dev, b->blockno);
  acquire(&bcache.bufmap_locks[key]);
  b->refcnt++;
  release(&bcache.bufmap_locks[key]);
}

void bunpin(struct buf *b) {
  uint key = BUFMAP_HASH(b->dev, b->blockno);
  acquire(&bcache.bufmap_locks[key]);
  // acquire(&bcache.lock);
  b->refcnt--;
  release(&bcache.bufmap_locks[key]);

}


