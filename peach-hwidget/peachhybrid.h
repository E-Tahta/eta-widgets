#ifndef PEACHHYBRID_H
#define PEACHHYBRID_H

#include <QGraphicsSceneHoverEvent>
#include <QList>

#include <Plasma/Applet>


namespace Plasma
{
    class DeclarativeWidget;
   
}

class Peachhybrid : public Plasma::Applet
{
    Q_OBJECT
    

    public:
        Peachhybrid(QObject *parent, const QVariantList &args);
        ~Peachhybrid();

        void init();
        Q_INVOKABLE void fakekey();
    private:

        void initDeclarativeUI();
        Plasma::DeclarativeWidget *m_declarativeWidget;
        


        enum DisplayedText {
            Number,
            Name,
            None
        };

        DisplayedText m_displayedText;

};

K_EXPORT_PLASMA_APPLET(peachhybrid, Peachhybrid)

#endif
