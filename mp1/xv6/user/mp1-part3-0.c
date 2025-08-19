#include "kernel/types.h"
#include "user/user.h"
#include "user/threads.h"

#define NULL 0

int mat[3][3] = {{1, 2, 3}, {4, 5, 6}, {7, 8, 9}};
int mat2[3][3] = {{1, 0, 0}, {0, 1, 0}, {0, 0 ,1}};
int mat3[2][5] = { {1, 2, 3, 4, 5},
					{1, 2, 3, 4, 5}};
int mat4[5][20] = { {1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1 ,1 ,1, 0, 0, 0, 0, 0},
					{1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1 ,1 ,1, 0, 0, 0, 0, 0},
					{1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1 ,1 ,1, 0, 0, 0, 0, 0},
					{1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1 ,1 ,1, 0, 0, 0, 0, 0},
					{1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1 ,1 ,1, 0, 0, 0, 0, 0}};
int outcome[3][3];
int outcome2[2][20];

int done_works = 0;
struct thread *manager_thread;

void worker1(void *arg){
	int row, col;
	int working_cell;
	working_cell = *((int*) arg);
	row = working_cell / 3;
	col = working_cell % 3;
	outcome[row][col] = 0;
	//printf("The worker %d is established\n", working_cell);
	//print_current_thread();
	thread_yield();

	for (int i = 0; i < 3; ++i){
		outcome[row][col] += (mat[row][i] * mat2[i][col]);
		//printf("Worker %d: do one multiplication\n", working_cell);
		thread_yield();
	}
	//printf("Worker %d: complete its work\n", working_cell);
	done_works ++;
	thread_resume(manager_thread);
	thread_suspend(get_current_thread());
}

void worker2(void* arg){
	int working_col;
	working_col = (int) arg;
	outcome2[0][working_col] = 0;
	outcome2[1][working_col] = 0;
	thread_yield();

	for (int i = 0; i < 2; ++i){
		for (int k = 0; k < 5; ++k){
			outcome2[i][working_col] += (mat3[i][k] * mat4[k][working_col]);		
		}
		thread_yield();
	}
	done_works ++;
	thread_resume(manager_thread);
	return;
}

void print_current_thread(void){
	struct thread *t;
	printf("Current ready queue: ");
	t = get_current_thread();
	do {
		if(t->suspended == 0){
			printf("%d ", t->ID);
		}
		t = t->next;
	} while (t != get_current_thread());
	printf("\n");
}

void manager(void *arg){
	// 1-st (3,3)*(3,3)
	int args[9];
	int i, j;
	struct thread *workers[20];
	printf("------------------\n");
	printf("Firstly, let's multiply the two matrices.\n");
	printf("------------------\n");
	printf("Matrix 1\n");
	for (i = 0; i < 3; ++i){
		for (j = 0; j < 3; ++j){
			printf("%d ", mat[i][j]);
		}
		printf("\n");
	}
	printf("Matrix 2\n");
	for (i = 0; i < 3; ++i){
		for (j = 0; j < 3; ++j){
			printf("%d ", mat2[i][j]);
		}
		printf("\n");
	}
	printf("------------------\n");
	for (i = 0; i < 9; ++i){
		args[i] = i;
		workers[i] = thread_create(worker1, (void*) (args + i));
		thread_add_runqueue(workers[i]);
		thread_yield();
	}

	while (done_works != 9)
		thread_suspend(get_current_thread());

	for (i = 0; i < 9; ++i){
		thread_kill(workers[i], 0);
		thread_resume(workers[i]);
		workers[i] = 0;
	}

	thread_yield();

	printf("The outcome\n");
	for (i = 0; i < 3; ++i){
		for (j = 0; j < 3; ++j){
			printf("%d ", outcome[i][j]);
		}
		printf("\n");
	}
	
	printf("------------------\n");
	print_current_thread();
	printf("------------------\n");
	
	printf("Secondly, let's multiply the two matrices.\n");
	printf("------------------\n");
	printf("Matrix 2\n");
	for (i = 0; i < 2; ++i){
		for (j = 0; j < 5; ++j){
			printf("%d ", mat3[i][j]);
		}
		printf("\n");
	}
	printf("Matrix 2\n");
	for (i = 0; i < 5; ++i){
		for (j = 0; j < 20; ++j){
			printf("%d ", mat4[i][j]);
		}
		printf("\n");
	}

	done_works = 0;
	for (i = 0; i < 20; ++i){
		workers[i] = thread_create(worker2, (void*) i);
		thread_add_runqueue(workers[i]);
		thread_yield();
	}

	while (done_works != 20)
		thread_suspend(get_current_thread());

	printf("The outcome\n");
	for (i = 0; i < 2; ++i){
		for (j = 0; j < 20; ++j){
			printf("%d ", outcome2[i][j]);
		}
		printf("\n");
	}
	printf("------------------\n");
	print_current_thread();
	
	thread_exit();
}

int main(int argc, char **argv)
{
	printf("mp1-part3-0\n");
	printf("Let's do some matrix multiplications\n");
	manager_thread = thread_create(manager, NULL);
	thread_add_runqueue(manager_thread);
	thread_start_threading();
	printf("\nexited\n");
	exit(0);
}
