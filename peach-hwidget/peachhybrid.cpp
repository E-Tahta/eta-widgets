#include "peachhybrid.h"

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

#include <Plasma/FrameSvg>
#include <Plasma/PaintUtils>
#include <Plasma/Theme>
#include <Plasma/ToolTipManager>
#include <Plasma/DeclarativeWidget>
#include <Plasma/Package>

#include <X11/XKBlib.h>
#include <qx11info_x11.h>
#include <X11/extensions/XTest.h>


Peachhybrid::Peachhybrid(QObject *parent, const QVariantList &args)
    : Plasma::Applet(parent, args),
      m_displayedText(None)

{
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

Peachhybrid::~Peachhybrid()
{
    //delete m_plasmaColorTheme;
}

void Peachhybrid::init()
{

      initDeclarativeUI();

}

void Peachhybrid::initDeclarativeUI()
{
    QGraphicsLinearLayout *layout = new QGraphicsLinearLayout(this);
    m_declarativeWidget = new Plasma::DeclarativeWidget(this);
    m_declarativeWidget->setSizePolicy(QSizePolicy::Minimum, QSizePolicy::Fixed);

    m_declarativeWidget->engine()->rootContext()->setContextProperty("peachhybrid", this);

    Plasma::PackageStructure::Ptr structure = Plasma::PackageStructure::load("Plasma/Generic");
    Plasma::Package package(QString(), "org.kde.peachhybrid", structure);
    m_declarativeWidget->setQmlPath(package.filePath("mainscript"));
    layout->addItem(m_declarativeWidget);
    layout->setContentsMargins(0, 0, 0, 0);
    
    setLayout(layout);
}
void Peachhybrid::fakekey()
{
    XTestFakeKeyEvent(QX11Info::display(), 133, true, 0); // meta
    XSync(QX11Info::display(), False);
    XTestFakeKeyEvent(QX11Info::display(), 50, true, 0); // shift
    XSync(QX11Info::display(), False);
    XTestFakeKeyEvent(QX11Info::display(), 114, true, 0); // right
    XSync(QX11Info::display(), False);
    XTestFakeKeyEvent(QX11Info::display(), 114, false, 0);
    XSync(QX11Info::display(), False);
    XTestFakeKeyEvent(QX11Info::display(), 50, false, 0);
    XSync(QX11Info::display(), False);
    XTestFakeKeyEvent(QX11Info::display(), 133, false, 0);
    XSync(QX11Info::display(), False);
}



#include "peachhybrid.moc"