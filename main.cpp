#include <QCoreApplication>
#include "wrapfcntl.h"

int main(int argc, char *argv[])
{

    if(runSingleInstance() == false){
        return -1;
    }
    QCoreApplication a(argc, argv);

    return a.exec();
}
