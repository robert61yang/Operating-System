#include "kernel/types.h"
#include "user/user.h"
#include "user/threads.h"

#define NULL 0

int task1_sigchecker[2] = {0};
struct thread *manager;

void func1(void* arg){
	task1_sigchecker[(int) arg] = 1;
}

void sighandler1(int signo){
	if (task1_sigchecker[signo] == 1)
		printf("The thread %d did not receive signal %d before running, Fail.\n", get_current_thread()->ID, signo);
	else
		printf("The thread %d received signal %d before running, Correct.\n", get_current_thread()->ID, signo);
	thread_exit();
}

int count_thread(void){
	struct thread *t;
	int counter = 0;
	t = get_current_thread();
	do {
		counter ++;
		t = t->next;
	} while (t != get_current_thread());
	return counter;
}

void task1(void){

	struct thread *t0, *t1;
	thread_register_handler(0, sighandler1);
	thread_register_handler(1, sighandler1);
	t0 = thread_create(func1, (void*) 0);
	t1 = thread_create(func1, (void*) 1);

	thread_add_runqueue(t0);
	thread_add_runqueue(t1);

	thread_kill(t0, 0);
	thread_kill(t1, 1);

	printf("================    TASK1    ================\n\n");
	thread_yield();
	printf("Now there is %d thread in the ready queue\n", count_thread());
	printf("\n================ End Of Task1 ================\n\n");

	thread_register_handler(0, NULL_FUNC);
	thread_register_handler(1, NULL_FUNC);

	return;
}

void func2_2(void){
	int frame_canary = 522;
	thread_yield();
	if (frame_canary != 522)
		printf("The thread %d's stack frame was destroyed, Fail.\n", get_current_thread()->ID);
	else
		printf("The thread %d's stack frame was taken care successfully, Correct.\n", get_current_thread()->ID);
	return;
}

void func2_1(void){
	func2_2();
	return;
}


void func2(void* arg){
	func2_1();
	return;
}

void sighandler2_stuff(int layer){
	char offset[2] = {0};
	if (layer == 0) return;
	sighandler2_stuff(layer - 1);
	return;
}

void sighandler2(int signo){
	sighandler2_stuff(10);
}

void task2(void){

	struct thread *t0;
	thread_register_handler(0, sighandler2);
	t0 = thread_create(func2, NULL);

	thread_add_runqueue(t0);

	printf("================    TASK2    ================\n\n");
	thread_yield();
	thread_kill(t0, 0);
	thread_yield();

	printf("Now there is %d thread in the ready queue\n", count_thread());
	printf("\n================ End Of Task2 ================\n\n");

	thread_register_handler(0, NULL_FUNC);

	return;
}

void func3(void *arg){
	int thread_id = (int) arg;
	if (thread_id & 1){
		thread_suspend(get_current_thread());
		printf("%d ", thread_id);
		thread_yield();
		printf("%d ", thread_id);
		thread_exit();
	}else{
		printf("%d ", thread_id);
		thread_yield();
		printf("%d ", thread_id);
		thread_suspend(get_current_thread());
		printf("%d ", thread_id);
		thread_exit();
	}
}

void task3(void){
	// order check
	int i;
	struct thread *threads[30];
	for (i = 0; i < 30; ++i){
		threads[i] = thread_create(func3, (void*) (i+1));
		thread_add_runqueue(threads[i]);
	}

	printf("================    TASK3    ================\n\n");

	printf("The first round (should be even number range from 1-30): ");
	thread_yield();
	printf("\n");

	for (i = 0; i < 30; ++i)
		if ((i+1) & 1) thread_resume(threads[i]);

	printf("The second round (should be all number range from 1-30): ");
	thread_yield();
	printf("\n");

	
	printf("The third round (should be odd number range from 1-30): ");
	thread_yield();
	printf("\n");

	printf("Now there is %d thread in the ready queue (should be 15+1=16)\n", count_thread());

	for (i = 0; i < 30; ++i)
		if (!((i+1) & 1)) thread_resume(threads[i]);

	printf("The fourth round (should be even number range from 1-30): ");
	thread_yield();
	printf("\n");

	printf("Now there is %d thread in the ready queue\n", count_thread());
	printf("\n================ End Of Task3 ================\n\n");

}

void sighandler4_1(int signo){
	int i;
	for (i = 1; i <= 15; ++i){
		printf("Ts-1: %d, ", i);
		thread_yield();
	}
}

void sighandler4_2(int signo){
	printf("Thread %d receive signo %d and kill itself\n", get_current_thread()->ID, signo);
	thread_exit();
}	

void func4_1(void *arg){
	int i;
	thread_register_handler(0, sighandler4_1);
	for (i = 1; i <= 15; ++i){
		printf("Tt-1: %d, ", i);
		thread_yield();
	}
	thread_suspend(get_current_thread());
}

void func4_2(void *arg){
	int i;
	thread_register_handler(1, sighandler4_2);
	for (i = 1; i <= 30; ++i){
		printf("Tt-2: %d%c%c", i, ((i&1) ? ',' : ' '), ((!(i&1)) ? '\n' : ' '));
		thread_yield();
	}
	thread_suspend(get_current_thread());
}

void task4(void){
	// yield in signal handler
	struct thread *t0, *t1;
	int i;
	t0 = thread_create(func4_1, NULL);
	thread_add_runqueue(t0);
	t1 = thread_create(func4_2, NULL);
	thread_add_runqueue(t1);

	printf("================    TASK4    ================\n\n");

	for (i = 1; i <= 30; ++i){
		printf("Tt-0: %d, ", i);
		if (i == 6) thread_kill(t0, 0);
		thread_yield();
	}
	
	thread_kill(t0, 1);
	thread_kill(t1, 1);
	thread_yield();

	printf("Now there is %d thread in the ready queue\n", count_thread());
	printf("\n================ End Of Task4 ================\n\n");

	return;
}

jmp_buf taske_env;

void funfun_sighandler(int signo){
	char offset[256];
	offset[255] = 'd';

	if (setjmp(taske_env) == 0){
		printf("The fun fun environment is set\n");
	}else{
		if (offset[255] = 'd')
			printf("You used correct stack to handle the signals, Correct\n");
		else
			printf("You used incorrect stack to handle the signals, Fail\n");
		thread_exit();
	}
}

void stuff(void *arg){
	thread_exit();
}

void funfunthread(void *arg){	
	void *ptr, *buf;
	thread_register_handler(0, funfun_sighandler);
	thread_yield();
	ptr = malloc(0x800);
	free(ptr);
	ptr = malloc(0x800);
	free(ptr);
	ptr = malloc(sizeof(struct thread));
	buf = malloc(sizeof(unsigned long) * 0x100);
	free(ptr);
	memset(buf, 0, sizeof(unsigned long) * 0x100);
	printf("The fun fun thread clean the memory starting from %p\n", buf);
	free(buf);
	longjmp(taske_env, 1);
}

void mypotthread(void *arg){
	thread_yield();
	thread_exit();
}


void taske(void){
	struct thread *t0, *t1;

	void *ptr;
	ptr = malloc(sizeof(struct thread));
	free(ptr);
	
	t0 = thread_create(mypotthread, NULL);
	t1 = thread_create(funfunthread, NULL);
	thread_add_runqueue(t0);
	thread_add_runqueue(t1);

	printf("================    TASKe    ================\n\n");
	printf("Azukashine... t0 stack is starting from %p\n", t0->stack);

	thread_yield();
	thread_kill(t1, 0);
	thread_yield();

	printf("Now there is %d thread in the ready queue\n", count_thread());
	printf("You're still alive, hurray\n");
	printf("\n================ End Of Taske ================\n\n");
}

void manager_func(void* arg){
	task1();
	task2();
	task3();
	task4();
	taske();
	thread_exit();
}

int main(int argc, char** argv){
	printf("mp1-part3-1\n");
	manager = thread_create(manager_func, NULL);
	thread_add_runqueue(manager);
	thread_start_threading();
	printf("exited\n");
	exit(0);
}
