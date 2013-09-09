import xmpp

# constants
USER_ID = "mark.nichols@gmail.com"
PASSWORD = "ch1cag0FOHEN"
SERVER = "gmail.com"

jid=xmpp.protocol.JID(USER_ID)
C=xmpp.Client(jid.getDomain(),debug=[])

if not C.connect((SERVER,5222)):
    raise IOError('Can not connect to server')
if not C.auth(jid.getNode(),PASSWORD):
    raise IOError('Can not authorize with server')
    
C.sendInitPresence(requestRoster=1)

def myPresenceHAndler(con, event):
    if event.getType() == 'unavailable':
        print event.getFrom().getStripped()
        
C.RegistrationHandler('presence', myPresenceHandler)
while C.Process(1):
    pass