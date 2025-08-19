# Operating System

This repository contains multiple subdirectories corresponding to different assignments of the course.

## Project Structure

### Machine Problem 0 (MP0) — xv6 Setup

This assignment introduces the xv6 environment using Docker and QEMU.  
The main task is to implement a custom xv6 command `mp0`, which traverses a given directory, counts the occurrences of a specified key in each path, and reports the total number of files and directories.  

## Machine Problem 1 (MP1) — xv6 File System Traversal

In this assignment, we extend xv6 by implementing a user command `mp1`.  
The command recursively traverses a given directory, counts the occurrences of a specified key in each path, and reports the total number of files and directories via parent-child communication using pipes.

## Machine Problem 2 (MP2) — xv6 Slab Memory Allocator

In this assignment, we extend xv6 by implementing a **slab memory allocator** for efficient kernel object management.  
The allocator introduces `kmem_cache` and `slab` structures to manage objects of the same size, supports O(1) allocation and deallocation via a freelist, and ensures thread safety with spinlocks.  
We replace the original `struct file` management with the slab system and provide a system call `printfslab` for debugging and introspection.  
Bonus features include internal fragmentation optimization and Linux-style list management. 

## Machine Problem 3 (MP3) — xv6 Thread Scheduling

In this assignment, we extend xv6 by implementing four thread scheduling algorithms.  
For non-real-time tasks, we implement Highest Response Ratio Next (HRRN) and Priority-based Round Robin (P-RR).  
For real-time tasks, we implement Deadline-Monotonic (DM) and Earliest Deadline First (EDF) with Constant Bandwidth Server (CBS).  
The schedulers handle thread creation, arrival, execution, and termination while ensuring correct preemption, priority handling, and deadline management.

## Machine Problem 4 (MP4) — xv6 Virtual Memory Management

In this assignment, we extend xv6 by implementing virtual memory management with page replacement.  
We handle page faults via demand paging and support multiple replacement policies, including FIFO, Clock, LRU, and Second-Chance.  
System calls `setpolicy` and `printstats` are added for controlling policies and collecting statistics.  
A user program `mp4` is provided to test memory access patterns and verify correct replacement behavior.
