#include "kernel/types.h"
#include "user/user.h"
#include "user/list.h"
#include "user/threads.h"
#include "user/threads_sched.h"
#include <limits.h>
#define NULL 0

int last_thread_id = -1;
int last_priority = -1;

/* default scheduling algorithm */
#ifdef THREAD_SCHEDULER_DEFAULT
struct threads_sched_result schedule_default(struct threads_sched_args args)
{
    struct thread *thread_with_smallest_id = NULL;
    struct thread *th = NULL;
    list_for_each_entry(th, args.run_queue, thread_list) {
        if (thread_with_smallest_id == NULL || th->ID < thread_with_smallest_id->ID)
            thread_with_smallest_id = th;
    }

    struct threads_sched_result r;
    if (thread_with_smallest_id != NULL) {
        r.scheduled_thread_list_member = &thread_with_smallest_id->thread_list;
        r.allocated_time = thread_with_smallest_id->remaining_time;
    } else {
        r.scheduled_thread_list_member = args.run_queue;
        r.allocated_time = 1;
    }

    return r;
}
#endif

/* MP3 Part 1 - Non-Real-Time Scheduling */

// HRRN
#ifdef THREAD_SCHEDULER_HRRN
struct threads_sched_result schedule_hrrn(struct threads_sched_args args)
{
    struct threads_sched_result r;
    // TO DO
    struct thread *thread_with_hrrn = NULL;
    int hrrn_val = -1;
    int hrrn_bt = 1;
    struct thread *th = NULL;
    // run queue empty
    struct release_queue_entry *entry;
    if(list_empty(args.run_queue)){
        r.scheduled_thread_list_member = args.run_queue;
        int earliest_thread_arrival_time = -1;
        list_for_each_entry(entry, args.release_queue, thread_list) {
            if(entry->thrd->arrival_time > args.current_time){
                if(earliest_thread_arrival_time == -1 || earliest_thread_arrival_time > entry->thrd->arrival_time){
                    earliest_thread_arrival_time = entry->thrd->arrival_time;
                }
            }
        }
        r.allocated_time = earliest_thread_arrival_time - args.current_time;
        return r;
    }
    list_for_each_entry(th, args.run_queue, thread_list) {
        int numerator = (args.current_time - th->arrival_time - (th->processing_time - th->remaining_time));
        if(numerator * hrrn_bt > hrrn_val * th->processing_time) {
            thread_with_hrrn = th;
            hrrn_val = numerator;
            hrrn_bt = th->processing_time;
        }
    }
    if(thread_with_hrrn != NULL) {
        r.scheduled_thread_list_member = &thread_with_hrrn->thread_list;
        r.allocated_time = thread_with_hrrn->remaining_time;
    } else {
        r.scheduled_thread_list_member = args.run_queue;
        r.allocated_time = 1;
    }
    return r;
}
#endif


#ifdef THREAD_SCHEDULER_PRIORITY_RR
// priority Round-Robin(RR)
struct threads_sched_result schedule_priority_rr(struct threads_sched_args args) 
{
    struct threads_sched_result r;
    // TO DO
    struct thread *thread_with_high_priority = NULL;
    struct thread *th = NULL;
    int best_priority = -1;
    int cur_id = -1;
    int thread_same_priority = 0;
       // Step 1: 找出最小 priority 值
    list_for_each_entry(th, args.run_queue, thread_list) {
        // printf("th ID: %d\n", th->ID);
        // printf("priority: %d\n", th->priority);
        if (best_priority == -1 || th->priority < best_priority) {
            best_priority = th->priority;
        }
    }

    list_for_each_entry(th, args.run_queue, thread_list) {
        if(th->priority == best_priority){
            thread_same_priority += 1;
        }
    }

    if(thread_same_priority > 1){
        if(best_priority == last_priority) { //find next by RR 
            list_for_each_entry(th, args.run_queue, thread_list) {
                if (th->priority == best_priority && th->ID > last_thread_id) {
                    if (thread_with_high_priority == NULL || th->ID < cur_id) {
                        cur_id = th->ID;
                        thread_with_high_priority = th;
                    }
                }
            }
            if (thread_with_high_priority == NULL) {
                list_for_each_entry(th, args.run_queue, thread_list) {
                    if (th->priority == best_priority) {
                        if (thread_with_high_priority == NULL || th->ID < cur_id) {
                            cur_id = th->ID;
                            thread_with_high_priority = th;
                        }
                    }
                }
            }
        } else { // find smallest ID
            list_for_each_entry(th, args.run_queue, thread_list) {
                if (th->priority == best_priority) {
                    if (thread_with_high_priority == NULL || th->ID < cur_id) {
                        cur_id = th->ID;
                        thread_with_high_priority = th;
                    }
                }
            }
        }
        r.scheduled_thread_list_member = &thread_with_high_priority->thread_list;
        if(thread_with_high_priority->remaining_time < args.time_quantum){
            r.allocated_time = thread_with_high_priority->remaining_time;
        }else{
            r.allocated_time = args.time_quantum;
        }
        last_priority = best_priority;
        last_thread_id = thread_with_high_priority->ID;
        return r;
    }else{
        list_for_each_entry(th, args.run_queue, thread_list) {
            if(th->priority == best_priority){
                thread_with_high_priority = th;
                r.scheduled_thread_list_member = &thread_with_high_priority->thread_list;
                r.allocated_time = thread_with_high_priority->remaining_time;
                last_priority = best_priority;
                last_thread_id = th->ID;
                return r;
            }
        }
    }
   
    r.scheduled_thread_list_member = args.run_queue;
    r.allocated_time = 1;
    
    return r;
}
#endif

/* MP3 Part 2 - Real-Time Scheduling*/

#if defined(THREAD_SCHEDULER_EDF_CBS) || defined(THREAD_SCHEDULER_DM)
static struct thread *__check_deadline_miss(struct list_head *run_queue, int current_time)
{
    struct thread *th = NULL;
    struct thread *thread_missing_deadline = NULL;
    list_for_each_entry(th, run_queue, thread_list) {
        if (th->current_deadline <= current_time) {
            if (thread_missing_deadline == NULL)
                thread_missing_deadline = th;
            else if (th->ID < thread_missing_deadline->ID)
                thread_missing_deadline = th;
        }
    }
    return thread_missing_deadline;
}
#endif

#ifdef THREAD_SCHEDULER_DM
/* Deadline-Monotonic Scheduling */
static int __dm_thread_cmp(struct thread *a, struct thread *b)
{
    //To DO
    int a_deadline = a->current_deadline - a->arrival_time;
    int b_deadline = b->current_deadline - b->arrival_time;
    if(a_deadline < b_deadline){
        return 0;
    }else if(a_deadline == b_deadline){
        if(a->ID < b->ID){
            return 0;
        }else{
            return 1;
        }
    }else{
        return 1;
    }
}

struct threads_sched_result schedule_dm(struct threads_sched_args args)
{
    struct threads_sched_result r;

    // first check if there is any thread has missed its current deadline
    // TO DO
    struct thread *thread_missing_deadline = __check_deadline_miss(args.run_queue, args.current_time);
    if(thread_missing_deadline != NULL){
        r.scheduled_thread_list_member = &thread_missing_deadline->thread_list;
        r.allocated_time = 0;
        return r;
    }
    // // handle the case where run queue is empty
    // // TO DO
    struct thread *th = NULL;
    struct release_queue_entry *entry;
    if(list_empty(args.run_queue)){
        r.scheduled_thread_list_member = args.run_queue;
        int earliest_thread_arrival_time = -1;
        list_for_each_entry(entry, args.release_queue, thread_list) {
            if(entry->thrd->arrival_time > args.current_time){
                if(earliest_thread_arrival_time == -1 || earliest_thread_arrival_time > entry->thrd->arrival_time){
                    earliest_thread_arrival_time = entry->thrd->arrival_time;
                }
            }
        }
        r.allocated_time = earliest_thread_arrival_time - args.current_time;
        return r;
    }
    
    struct thread *thread_dm = NULL;
    list_for_each_entry(th, args.run_queue, thread_list) {
        if(thread_dm == NULL){
            thread_dm = th;
            continue;
        }
        int cmp = __dm_thread_cmp(thread_dm, th);
        if(cmp == 1){
            thread_dm = th;
        }
    }
    int allocate_time = thread_dm->remaining_time;
    entry = NULL;
    list_for_each_entry(entry, args.release_queue, thread_list) {
        int cmp = __dm_thread_cmp(thread_dm, entry->thrd);
        if(cmp == 1 && entry->thrd->arrival_time > args.current_time){
            if(allocate_time + args.current_time > entry->thrd->arrival_time) {
                allocate_time = entry->thrd->arrival_time - args.current_time;
            }
        }
    }

    

    r.scheduled_thread_list_member = &thread_dm->thread_list;
    r.allocated_time = allocate_time;

    return r;
}
#endif

void check_bandwidth(struct thread *th, struct threads_sched_args args)
{
    if((th->cbs.remaining_budget * th->period) > (th->cbs.budget * (th->current_deadline - args.current_time)))
    {
        // printf("before %d\n",th->current_deadline);
        th->current_deadline = args.current_time + th->period;
        // printf("after %d\n", th->current_deadline);
        th->cbs.remaining_budget = th->cbs.budget; 
    }
} 

#ifdef THREAD_SCHEDULER_EDF_CBS
// EDF with CBS comparation
static int __edf_thread_cmp(struct thread *a, struct thread *b)
{
    // TO DO
    int a_deadline = a->current_deadline;
    int b_deadline = b->current_deadline;
    if(a_deadline < b_deadline){
        return 0;
    }else if(a_deadline == b_deadline){
        if(a->ID < b->ID){
            return 0;
        }else{
            return 1;
        }
    }else{
        return 1;
    }
    return 0;
}
//  EDF_CBS scheduler
struct threads_sched_result schedule_edf_cbs(struct threads_sched_args args)
{
    struct threads_sched_result r;
    
    // notify the throttle task
    // TO DO
    struct thread *th = NULL;
    list_for_each_entry(th, args.run_queue, thread_list) {
        if(th->cbs.is_throttled == 1 && th->cbs.throttled_arrived_time == args.current_time){
            th->cbs.is_throttled = 0;
            th->current_deadline = th->cbs.throttle_new_deadline;
            th->cbs.remaining_budget = th->cbs.budget;
        }
            
    }
    // first check if there is any thread has missed its current deadline
    // TO DO
    struct thread *thread_missing_deadline = __check_deadline_miss(args.run_queue, args.current_time);
    if(thread_missing_deadline != NULL && thread_missing_deadline->cbs.is_hard_rt == 1){
        r.scheduled_thread_list_member = &thread_missing_deadline->thread_list;
        r.allocated_time = 0;
        return r;
    }
    // handle the case where run queue is empty
    // TO DO
    // struct thread *th = NULL;
    struct release_queue_entry *entry;
    if(list_empty(args.run_queue)){
        r.scheduled_thread_list_member = args.run_queue;
        int earliest_thread_arrival_time = -1;
        list_for_each_entry(entry, args.release_queue, thread_list) {
            if(entry->thrd->arrival_time > args.current_time){
                if(earliest_thread_arrival_time == -1 || earliest_thread_arrival_time > entry->thrd->arrival_time){
                    earliest_thread_arrival_time = entry->thrd->arrival_time;
                }
            }
        }
        // printf("%d\n", earliest_thread_arrival_time);
        r.allocated_time = earliest_thread_arrival_time - args.current_time;
        return r;
    }
    //
    struct thread *thread_edf = NULL;
    list_for_each_entry(th, args.run_queue, thread_list) {
        if(th->cbs.is_throttled){
            continue;
        }else if(th->cbs.is_hard_rt == 0){
            check_bandwidth(th, args);
        }
        if(thread_edf == NULL){
            thread_edf = th;
            continue;
        }
        int cmp = __edf_thread_cmp(thread_edf, th);
        if(cmp == 1){
            thread_edf = th;
        }
    }
    if(thread_edf == NULL){
        // printf("yes\n");
        // printf("%d\n",list_empty(args.run_queue));
        entry = NULL;
        r.scheduled_thread_list_member = args.run_queue;
        int earliest_thread_arrival_time = -1;
        list_for_each_entry(entry, args.release_queue, thread_list) {
            // printf("%d\n", entry->thrd->arrival_time);
            if(entry->thrd->arrival_time > args.current_time){
                if(earliest_thread_arrival_time == -1 || earliest_thread_arrival_time > entry->thrd->arrival_time){
                    earliest_thread_arrival_time = entry->thrd->arrival_time;
                }
            }
        }
        th = NULL;
        list_for_each_entry(th, args.run_queue, thread_list) {
            if(th->cbs.is_throttled){
                if(earliest_thread_arrival_time == -1 || earliest_thread_arrival_time > th->cbs.throttled_arrived_time){
                    earliest_thread_arrival_time = th->cbs.throttled_arrived_time;
                }
            }
        }
        r.allocated_time = earliest_thread_arrival_time - args.current_time;
        return r;
    }
    int allocate_time;
    if(thread_edf->cbs.is_hard_rt){
        if(thread_edf->remaining_time + args.current_time > thread_edf->current_deadline){
            allocate_time = thread_edf->current_deadline;
        }else{
            allocate_time = thread_edf->remaining_time;
        }
    }else{
        if(thread_edf->remaining_time > thread_edf->cbs.remaining_budget){
            allocate_time = thread_edf->cbs.remaining_budget;
        }else{
            allocate_time = thread_edf->remaining_time;
        }    
    }
    //check release_qeueu
    entry = NULL;
    list_for_each_entry(entry, args.release_queue, thread_list) {
        int cmp = __edf_thread_cmp(thread_edf, entry->thrd);
        if(cmp == 1 && entry->thrd->arrival_time > args.current_time){
            if(allocate_time + args.current_time > entry->thrd->arrival_time) {
                allocate_time = entry->thrd->arrival_time - args.current_time;
            }
        }
    }

    //check if someone unthrottle
    list_for_each_entry(th, args.run_queue, thread_list) {
        if(th->cbs.is_throttled && th->cbs.throttle_new_deadline < thread_edf->current_deadline){
            if(allocate_time + args.current_time > th->cbs.throttled_arrived_time){
                allocate_time = th->cbs.throttled_arrived_time - args.current_time;
            }
        }
    }


    //set throttle
    if(thread_edf->remaining_time - allocate_time != 0 && thread_edf->cbs.remaining_budget - allocate_time == 0){
        thread_edf->cbs.is_throttled = 1;
        thread_edf->cbs.throttled_arrived_time = thread_edf->current_deadline;
        thread_edf->cbs.throttle_new_deadline = thread_edf->cbs.throttled_arrived_time + thread_edf->period;
    }

    r.scheduled_thread_list_member = &thread_edf->thread_list;
    r.allocated_time = allocate_time;
    return r;
}
#endif