linux下使用fcntl函数给文件加锁，windows下用什么代替fcntl？？


首先，方法1， 进程名字改变无法监控，又外加了脚本，实在多余

方法2， 这个可以尝试，守护进程用信号量不知道会不会有什么问题，有时间的话可以研究下。

方法3，呃，也是个笨方法了，程序异常退出等无法及时改文件的话就有问题。

方法4，我采用的方法了，感觉很可靠，程序退出释放锁，是不是很靠谱呢。

 

先解释下这个函数的机制，在”/var/run/”目录下建立一个文件，一般是以进程名字命名。里面只写入进程号。注意，这个目录是默认守护进程会写的目录，所以建议大家遵循这个规则。（关于守护进程默认遵循的规则，比如自动重启，作为服务启动关闭等，参考该书即可）

该文件加建议性写锁，进程在运行期间一直持有该锁，不释放，而是在进程退出后自动释放。所以获取该锁失败就说明进程已经在运行。直接退出。

函数中写日志接口是项目中的日志模块，可以直接用linux系统中的syslog日志服务进行监控。

函数中加锁的函数采用fcntl函数，可以参考该书中对fcntl的封装，用起来非常方便。文章最后附上该封装函数。

如果是守护进程，该函数需要在daemon后调用，因为daemon函数会对文件描述符做操作。

如果不是守护进程，直接调用就OK了
