#ifndef KEYBOARDCLIENT_H
#define KEYBOARDCLIENT_H

#include <QGraphicsSceneHoverEvent>
#include <QList>

#include <Plasma/Applet>

class QLocalSocket;

#define SERVER_NAME "/.eta-keyboard"


namespace Plasma
{
    class DeclarativeWidget;
   
}

class Keyboardclient : public Plasma::Applet
{
    Q_OBJECT
    

    public:
        Keyboardclient(QObject *parent, const QVariantList &args);
        ~Keyboardclient();

        void init();
        Q_INVOKABLE void toggle();
    private:

        void initDeclarativeUI();
        Plasma::DeclarativeWidget *m_declarativeWidget;
	QLocalSocket *socket;
    
    
   

};

K_EXPORT_PLASMA_APPLET(keyboardclient, Keyboardclient)

#endif
