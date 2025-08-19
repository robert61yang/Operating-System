#include "kernel/types.h"
#include "user/user.h"
#include "user/threads.h"

#define NULL 0

void *bp_after_corrupt;

void corrupt(int layer){
	if (layer == 0){
		__asm__("mv %0, s0" : "=r" (bp_after_corrupt));
   		printf(" <-> %p is used by corrupt function \n", bp_after_corrupt);
		return;
	}
	corrupt(layer - 1);
}

void func2(void *arg){
	void *f2sp;
	// 4-3
	thread_yield();
	// 5-3
	__asm__("mv %0, sp" : "=r" (f2sp));
    printf("The memory %p", f2sp);	
	corrupt(100);
	thread_yield();
	// 6-3
	thread_exit();
}

void func1(void *arg){
	// 1-2
	thread_yield();
	// 2-2
	thread_yield();
	// 3-2 (exit due to signal)
}

void func3_sighand(int signo){
	// 2-3
	char offset[64];
	void *bp;
	offset[0] = '\0';
	__asm__("mv %0, s0" : "=r" (bp));
    printf("The w_thread signal handler's base pointer: %p\n", bp);	
	thread_yield();
	// 3-3
	thread_yield();
	// 4-2
	thread_yield();
	// 5-2
	thread_yield();
	// 6-2
	// It is expected that you'll get an error here
}

void func3(void *arg){
	// 1-3
	thread_register_handler(0, func3_sighand);
	thread_yield();

	// 6-2 (return from signal)
	printf("I'm still alive\n");
	thread_exit();

	return;
}

void manager_func(void *arg){
	struct thread *t_thread, *w_thread;
	
	// setup
	w_thread = thread_create(func3, NULL);
	t_thread = thread_create(func1, NULL);	
	printf("1st t_thead stack: %p\n", t_thread->stack);

	// 1-1
	thread_add_runqueue(t_thread);
	thread_add_runqueue(w_thread);	
	thread_yield();
	// 2-1
	thread_kill(w_thread, 0);
	thread_yield();
	// 3-1
	thread_kill(t_thread, 0);
	thread_yield();
	// 4-1
	t_thread = thread_create(func2, NULL);
	printf("2nd t_thread stack: %p\n", t_thread->stack);
	thread_add_runqueue(t_thread);
	thread_yield();
	// 5-1
	thread_yield();
	// 6-1
	thread_yield();
	// End
	thread_exit();
}

int main(int argc, char** argv){
	printf("mp1-part3-2\n");
	struct thread *manager;
	manager = thread_create(manager_func, NULL);
	thread_add_runqueue(manager);
	thread_start_threading();
	printf("\nexited\n");
	exit(0);
}
