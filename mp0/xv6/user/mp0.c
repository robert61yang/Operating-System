#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"


int countChar(const char *str, char key) {
    int count = 0;
    while (*str != '\0') {
        if (*str == key)
            count++;
        str++;
    }
    return count;
}

char*
fmtname(char *path)
{
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
    ;
  p++;

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
    return p;
  memmove(buf, p, strlen(p));
//   memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}

void open_file(char *path, char key, int* file, int* dir){
    char buf[512], *p;
    int fd;
    struct dirent de;
    struct stat st;


    if((fd = open(path, 0)) < 0){
        printf("%s [error opening dir]\n", path);
        return;
    }

    if(fstat(fd, &st) < 0){
        fprintf(2, "ls: cannot stat %s\n", path);
        close(fd);
        return;
    }

    switch(st.type){
    case T_FILE:
        // printf("%s %d\n", path, count);
        *file += 1;
        break;

    case T_DIR:
        *dir += 1;
        if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
            printf("mp0: path too long\n");
            break;
        }
        strcpy(buf, path);
        p = buf+strlen(buf); // pointer to the last char of "path"
        *p++ = '/';
        while(read(fd, &de, sizeof(de)) == sizeof(de)){
            if(de.inum == 0) // de is not point to file or dir
                continue;
            if(strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0){
                continue;
            }
            memmove(p, de.name, DIRSIZ); // add file or dir name after path
            p[DIRSIZ] = 0; // add '\0' to the end of str
            if(stat(buf, &st) < 0){
                printf("ls: cannot stat %s\n", buf);
                continue;
            }
            printf("%s %d\n", buf, countChar(buf, key));
            char *new_path = malloc(512);
            strcpy(new_path, buf);
            open_file(new_path, key, file, dir);
            free(new_path);
        }
        break;
    }
    close(fd);
}


int main(int argc, char *argv[]){
    int pipefd[2];

    if(pipe(pipefd) == -1){
        printf("pipe error\n");
        exit(1);
    }

    int pid = fork();
    if(pid == 0){
        int file = 0;
        int dir = 0;
        int fd;
        close(pipefd[0]);
        if((fd = open(argv[1], 0)) >= 0){
            printf("%s %d\n", argv[1], countChar(argv[1], argv[2][0]));
        }
        close(fd);
        open_file(argv[1], argv[2][0], &file, &dir);
        printf("\n");
        write(pipefd[1], &file, sizeof(file));
        write(pipefd[1], &dir, sizeof(dir));
        close(pipefd[1]);
    }
    if(pid > 0){
        wait(0);
        int file;
        int dir;
        read(pipefd[0], &file, sizeof(file));
        read(pipefd[0], &dir, sizeof(dir));
        if (dir > 0)
            dir -= 1;
        printf("%d directories, %d files\n", dir, file);
        close(pipefd[0]);
    }
    exit(0);
}