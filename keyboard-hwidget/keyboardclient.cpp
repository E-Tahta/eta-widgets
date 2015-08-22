#include <QDir>
#include "keyboardclient.h"

#include <math.h>

#include <QFont>
#include <QTimer>
#include <QX11Info>
#include <QDBusInterface>
#include <QTextDocument>
#include <QDesktopWidget>
#include <QtGui/QGraphicsLinearLayout>
#include <QtDeclarative/QDeclarativeEngine>
#include <QtDeclarative/QDeclarativeContext>

#include <KCModuleInfo>
#include <KCModuleProxy>
#include <KColorScheme>
#include <KConfigDialog>
#include <KGlobalSettings>
#include <KIconLoader>
#include <KWindowSystem>
#include <NETRootInfo>
#include <QDebug>

#include <Plasma/FrameSvg>
#include <Plasma/PaintUtils>
#include <Plasma/Theme>
#include <Plasma/ToolTipManager>
#include <Plasma/DeclarativeWidget>
#include <Plasma/Package>


#include <QLocalSocket>


Keyboardclient::Keyboardclient(QObject *parent, const QVariantList &args)
    : Plasma::Applet(parent, args)

{
    socket = 0;
    setAcceptsHoverEvents(true);
    setAcceptDrops(false);
    setHasConfigurationInterface(false);
    setAspectRatioMode(Plasma::IgnoreAspectRatio);
    setBackgroundHints(NoBackground);
    
    QDesktopWidget dw;
    int width = dw.screenGeometry(dw.primaryScreen()).width();
    int height = dw.screenGeometry(dw.primaryScreen()).height();
    resize(QSizeF(width*14/100, height*5/108));
    
    
   
   
}

Keyboardclient::~Keyboardclient()
{
    //delete m_plasmaColorTheme;
}

void Keyboardclient::init()
{

      initDeclarativeUI();

}

void Keyboardclient::initDeclarativeUI()
{
    QGraphicsLinearLayout *layout = new QGraphicsLinearLayout(this);
    m_declarativeWidget = new Plasma::DeclarativeWidget(this);
    m_declarativeWidget->setSizePolicy(QSizePolicy::Minimum, QSizePolicy::Fixed);

    m_declarativeWidget->engine()->rootContext()->setContextProperty("keyboardclient", this);

    Plasma::PackageStructure::Ptr structure = Plasma::PackageStructure::load("Plasma/Generic");
    Plasma::Package package(QString(), "org.kde.keyboardclient", structure);
    m_declarativeWidget->setQmlPath(package.filePath("mainscript"));
    layout->addItem(m_declarativeWidget);
    layout->setContentsMargins(0, 0, 0, 0);
    
    setLayout(layout);
}
void Keyboardclient::toggle()
{
    if (socket != 0) {
      
      qDebug() << "socket is not null";
      
      qDebug() << "0:panel\n";
      socket->write("0:panel\n");
      socket->flush();
    }
    else
    {
      qDebug() << "socket is null";
      socket = new QLocalSocket(this);   
      socket->connectToServer(QDir::homePath()+SERVER_NAME);    
      
      if (socket->waitForConnected()) {
	qDebug() << "Connected";
	qDebug() << "0:panel\n";
	socket->write("0:panel\n");
	socket->flush();
      } else {      
	qDebug() << "failed to connect";
	
	delete socket;
	socket = 0;
      }
    
    }
    
    
    
   
   
    
    //socket->write("0:panel\n");
    //socket->flush();
}






#include "keyboardclient.moc"
