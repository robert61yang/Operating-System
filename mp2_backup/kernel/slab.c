#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"
#include "slab.h"
#include "debug.h"
// #include "file.h"


struct slab *create_slab(uint object_size){
  void *page = kalloc();
  struct slab *s = (struct slab *)page;
  void *obj_start = (void *)(s + 1);
  int space_available = PGSIZE - sizeof(struct slab);
  int num_objects = space_available / object_size;
  // s->total_objects = num_objects;
  struct run *curr, *next;

  for(int i = 0; i < num_objects; i++){
    curr = (struct run *)((char *)obj_start + i * object_size);
    next = (i < num_objects - 1)
            ? (struct run *)((char *)obj_start + (i + 1) * object_size)
            : NULL;
    curr->next = next;
  }
  s->freelist = (struct run *)obj_start;
  // s->state = SLAB_FREE;
  // s->inuse = 0;
  return s;
}

int count_slab_freelist(struct slab *s) {
  int count = 0;
  struct run *r = s->freelist;
  while (r != NULL) {
    count++;
    r = r->next;
  }
  return count;
}


void print_kmem_cache(struct kmem_cache *cache, void (*slab_obj_printer)(void *))
{
  // TODO: Implement print_kmem_cache
  // printf("[SLAB] TODO: print_kmem_cache is not yet implemented \n");
  acquire(&cache->lock);
  debug("[SLAB] kmem_cache { name: %s, object_size: %d, at: %p, in_cache_obj: %d }\n",
        cache->name, cache->object_size, cache, cache->incache_num);
  int cache_free_objs = count_slab_freelist(((struct slab *)cache));
  if(cache_free_objs != cache->incache_num){
    debug("[SLAB]  [ cache slabs ]\n");
    debug("[SLAB]   [ slab %p ] { freelist: %p, nxt: %p }\n", cache, cache->slab_base.freelist, NULL);
    int *is_free = (int *)kalloc();
    memset(is_free, 0, sizeof(int) * cache->incache_num);
  
    void *obj_start = (void *)(cache + 1);
    struct run *r = cache->slab_base.freelist;
    for (; r != NULL; r = r->next) {
        int idx = ((char *)r - (char *)obj_start) / cache->object_size;
        if (idx >= 0 && idx < cache->incache_num) {
            is_free[idx] = 1;
        }
    }
  
    for (int i = 0; i < cache->incache_num; i++) {
      void *obj = (char *)obj_start + i * cache->object_size;
      void *as_ptr = *(void **)obj;
      debug("[SLAB]    [ idx %d ] { addr: %p, as_ptr: %p, as_obj: {", i, obj, as_ptr);
      if (slab_obj_printer)
        slab_obj_printer(obj);  
      debug("} }\n");
    }
  
    kfree(is_free);
  }
  if (!list_empty(&cache->partial)) {
    debug("[SLAB]  [ partial slabs ]\n");
  }
  struct slab *s;
  list_for_each_entry(s, &cache->partial, list) {
    debug("[SLAB]   [ slab %p ] { freelist: %p, nxt: %p }\n", s, s->freelist, s->list.next);
  
    int *is_free = (int *)kalloc();
    memset(is_free, 0, sizeof(int) * cache->num_objects);
  
    void *obj_start = (void *)(s + 1);
    struct run *r = s->freelist;
    for (; r != NULL; r = r->next) {
        int idx = ((char *)r - (char *)obj_start) / cache->object_size;
        if (idx >= 0 && idx < cache->num_objects) {
            is_free[idx] = 1;
        }
    }
  
    for (int i = 0; i < cache->num_objects; i++) {
      void *obj = (char *)obj_start + i * cache->object_size;
      void *as_ptr = *(void **)obj;
      debug("[SLAB]    [ idx %d ] { addr: %p, as_ptr: %p, as_obj: {", i, obj, as_ptr);
      if (slab_obj_printer)
        slab_obj_printer(obj);  
      debug("} }\n");
    }
  
    kfree(is_free);
  }
  debug("[SLAB] print_kmem_cache end\n");
  release(&cache->lock);
}

struct kmem_cache *kmem_cache_create(char *name, uint object_size)
{
  // TODO: Implement kmem_cache_create
  // printf("[SLAB] TODO: kmem_cache_create is not yet implemented \n");
  
  struct kmem_cache *cache = (struct kmem_cache *)kalloc();
  int len = strlen(name) + 1;
  strncpy(cache->name, name, len);
  cache->object_size = object_size;
  cache->member_num = 0;

  INIT_LIST_HEAD(&cache->full);
  INIT_LIST_HEAD(&cache->partial);
  INIT_LIST_HEAD(&cache->free);
  initlock(&cache->lock, cache->name);

  int slab_space_available = PGSIZE - sizeof(struct slab);
  int slab_num_objects = slab_space_available / object_size;
  cache->num_objects = slab_num_objects;

  //create in-cache slab
  int space_available = PGSIZE - sizeof(struct kmem_cache);
  int num_objects = space_available / cache->object_size;
  cache->incache_num = num_objects;
  void *obj_start = (void *)(cache + 1);
  struct run *curr, *next;

  for (int i = 0; i < num_objects; i++) {
    curr = (struct run *)((char *)obj_start + i * cache->object_size);
    next = (i < num_objects - 1) ? 
            (struct run *)((char *)obj_start + (i + 1) * cache->object_size) : NULL;
    curr->next = next;
  }

  cache->slab_base.freelist = (struct run *)obj_start;

  debug("[SLAB] New kmem_cache (name: %s, object size: %d bytes, at: %p, max objects per slab: %d, support in cache obj: %d) is created\n",
        cache->name, cache->object_size, cache, cache->num_objects, cache->incache_num);
  return cache;
}

void kmem_cache_destroy(struct kmem_cache *cache)
{
  // TODO: Implement kmem_cache_destroy (will not be tested)
  // printf("[SLAB] TODO: kmem_cache_destroy is not yet implemented \n");
  struct slab *s, *tmp;

    // Free all slabs in free list
    list_for_each_entry_safe(s, tmp, &cache->free, list) {
        list_del(&s->list);
        kfree((void *)s);
    }

    // Free all slabs in partial list
    list_for_each_entry_safe(s, tmp, &cache->partial, list) {
        list_del(&s->list);
        kfree((void *)s);
    }

    // Free all slabs in full list
    list_for_each_entry_safe(s, tmp, &cache->full, list) {
        list_del(&s->list);
        kfree((void *)s);
    }

    kfree(cache);
}

void *kmem_cache_alloc(struct kmem_cache *cache)
{
  // TODO: Implement kmem_cache_alloc
  // printf("[SLAB] TODO: kmem_cache_alloc is not yet implemented \n");
  acquire(&cache->lock); // acquire the lock before modification
  debug("[SLAB] Alloc request on cache %s\n", cache->name);
  if(cache->slab_base.freelist != NULL){
    void *obj = cache->slab_base.freelist;
    cache->slab_base.freelist = cache->slab_base.freelist->next;
    // debug("[IN-CACHE] Object %p is allocated and initialized in cache %p\n", obj, cache);
    debug("[SLAB] Object %p in slab %p (%s) is allocated and initialized\n", obj, cache, cache->name);
    release(&cache->lock);
    return obj;
  }else if(!list_empty(&cache->partial)){
    struct slab *s = list_first_entry(&cache->partial, struct slab, list);
    void *obj = (void *)s->freelist;
    s->freelist = s->freelist->next;
    // s->inuse += 1;
    if(s->freelist == NULL){
      list_move(&s->list, &cache->full);
      // s->state = SLAB_FULL;
      cache->member_num -= 1;
    }
    // debug("partial\n");
    debug("[SLAB] Object %p in slab %p (%s) is allocated and initialized\n"
          , obj, s, cache->name);
    release(&cache->lock);
    return obj;
  }else if(!list_empty(&cache->free)){
    struct slab *s = list_first_entry(&cache->free, struct slab, list);
    void *obj = (void *)s->freelist;
    s->freelist = s->freelist->next;
    // s->inuse += 1;
    // s->state = SLAB_PARTIAL;
    list_move(&s->list, &cache->partial);
    debug("[SLAB] Object %p in slab %p (%s) is allocated and initialized\n"
          , obj, s, cache->name);
    release(&cache->lock);
    return obj;
  }else{
    struct slab *s = create_slab(cache->object_size);
    // debug("objnum: %d, freeobj: %d\n", cache->num_objects, count_slab_freelist(s));
    debug("[SLAB] A new slab %p (%s) is allocated\n", s, cache->name);
    list_add_tail(&s->list, &cache->partial);
    cache->member_num += 1;
    void *obj = (void *)s->freelist;
    s->freelist = s->freelist->next;
    // s->inuse += 1;
    // s->state = SLAB_PARTIAL;
    debug("[SLAB] Object %p in slab %p (%s) is allocated and initialized\n"
          , obj, s, cache->name);
    release(&cache->lock);
    return obj;
  }
  release(&cache->lock); // release the lock before return
  return 0;
}

void kmem_cache_free(struct kmem_cache *cache, void *obj)
{
  // TODO: Implement kmem_cache_free
  // printf("[SLAB] TODO: kmem_cache_free is not yet implemented \n");
  acquire(&cache->lock); // acquire the lock before modification
  struct slab *s = (struct slab *)((uint64)obj & ~(PGSIZE - 1));
  struct run *r = (struct run *)obj;
  r->next = s->freelist;
  s->freelist = r;
  if((void *)s == (void *)cache){ // free the in-cache object and return
    debug("[SLAB] Free %p in slab %p (%s)\n", obj, cache, cache->name);
    debug("[SLAB] End of free\n");
    release(&cache->lock); // release the lock before return
    return;
  }
  // s->inuse -= 1;
  debug("[SLAB] Free %p in slab %p (%s)\n", obj, s, cache->name);
  int free_objs = count_slab_freelist(s);
  if(free_objs == 1){
    // s->state = SLAB_PARTIAL;
    list_move(&s->list, &cache->partial);
    cache->member_num += 1;
  }
  if(free_objs == cache->num_objects){
    // s->state = SLAB_FREE;
    list_move(&s->list, &cache->free);
    //check MP2_MIN_AVAIL_SLAB
    if(cache->member_num > MP2_MIN_AVAIL_SLAB){
      debug("[SLAB] slab %p (%s) is freed due to save memory\n", s, cache->name);
      list_del(&s->list);
      kfree((void *) s);
    }
  }
  debug("[SLAB] End of free\n");
  release(&cache->lock); // release the lock before return
}

// uint64 sys_printfslab(void)
// {
//   // print_kmem_cache(file_cache, fileprint_metadata);
//   return 0;
// }