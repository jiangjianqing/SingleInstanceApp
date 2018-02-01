#include <QCoreApplication>
#include "run_single_instance.h"

int main(int argc, char *argv[])
{

    if(runSingleInstance() == false){
        exit(1);
    }
    QCoreApplication a(argc, argv);

    return a.exec();
}
