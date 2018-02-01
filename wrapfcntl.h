#ifndef WRAPFCNTL_H
#define WRAPFCNTL_H


#include <stdio.h>
#include <string.h>
#include <sys/types.h> /* about files */
#include <sys/stat.h>
#include <sys/file.h>
#include <fcntl.h>
#include <unistd.h>
#include <string>

std::string currentExeName()
{
    char buf[PATH_MAX] = {'\0'};

    int ret = readlink("/proc/self/exe", buf, PATH_MAX);
    if (ret < 0 || ret >= PATH_MAX)
    {
        return "";
    }

    std::string path(buf);
    int pos = path.find_last_of("/");
    if (pos == -1)
    {
        return "";
    }

    path = path.substr(pos + 1, path.size() - 1);

    return path;
}


/* fcntl函数的包装，带w表示阻塞调用*/

#define read_lock(fd, offset, whence, len) lock_reg((fd), F_SETLK, F_RDLCK, (offset), (whence), (len))
#define readw_lock(fd, offset, whence, len) lock_reg((fd), F_SETLKW, F_RDLCK, (offset), (whence), (len))
#define write_lock(fd, offset, whence, len) lock_reg((fd), F_SETLK, F_WRLCK, (offset), (whence), (len))
#define writew_lock(fd, offset, whence, len) lock_reg((fd), F_SETLKW, F_WRLCK, (offset), (whence), (len))
#define un_lock(fd, offset, whence, len) lock_reg((fd), F_SETLK, F_UNLCK, (offset), (whence), (len))



int lock_reg(int fd, int cmd, int type, off_t offset, int whence, off_t len);


static bool runSingleInstance(void)
{
    // 获取当前可执行文件名
    std::string processName = currentExeName();
    if (processName.empty())
    {
        exit(1);
    }

    // 打开或创建一个文件
    std::string filePath = std::string("/home/cz_jjq/") + processName + ".pid";
    //std::string filePath = std::string("/var/run/") + processName + ".pid";
    int fd = open(filePath.c_str(), O_RDWR | O_CREAT, 0666);
    if (fd < 0) {
        printf("Open file failed, error : %s", strerror(errno));
        exit(1);
        return 1;
    }
    /* 加建议性写锁 */
    if (write_lock(fd,  0, SEEK_SET, 0) < 0) {
        if (errno == EACCES || errno == EAGAIN)
        {
            printf("%s already locked, error: %s\n", filePath.c_str(), strerror(errno));
            close(fd);
            return false;
        }
    }


    // 锁定文件后，将该进程的pid写入文件
    char buf[16] = {'\0'};
    sprintf(buf, "%d", getpid());
    ftruncate(fd, 0);/* 文件清零，因为只写一次pid号 */
    int ret = write(fd, buf, strlen(buf)+1);
    if (ret < 0)
    {
        printf("Write file failed, file: %s, error: %s\n", filePath.c_str(), strerror(errno));
        close(fd);
        exit(1);
    }

    // 函数返回时不需要调用close(fd)
    // 不然文件锁将失效
    // 程序退出后kernel会自动close
    return true;
}

//#include "wrapfcntl.h"



int lock_reg(int fd, int cmd, int type, off_t offset, int whence, off_t len)
{
    struct flock lock;
    lock.l_type = type; /* F_RDLCK, F_WRLCK, F_UNLCK */
    lock.l_start = offset; /* byte offset, relative to l_whence */
    lock.l_whence = whence; /* SEEK_SET, SEEK_CUR, SEEK_END */
    lock.l_len = len; /* #bytes (0 means to EOF) */
    return (fcntl(fd, cmd, &lock));
}


#endif // WRAPFCNTL_H
