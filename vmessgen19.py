import uuid
import random
import json
import base64
import string
from requests import get
ip = get('https://api.ipify.org').content.decode('utf8')
def get_random_string(length):
    # With combination of lower and upper case
    result_str = ''.join(random.choice(string.ascii_letters) for i in range(length))
    # print random string
    print(result_str)

def getlink1(ip,port,uid):
    config = {
    "v": "2",
    "ps": get_random_string(12),
    "add": ip,
    "port": port,
    "id": uid,
    "aid": 0,
    "net": "ws",
    "type": "none",
    "host": "",
    "path": "/",
    "tls": "none"
    }
    config = json.dumps(config)
    eb = base64.b64encode(config.encode("utf-8"))
    es = str(eb, "utf-8")
    return es

def uidgenerator():
    myuuid = uuid.uuid4()
    #print('Your UUID is: ' + str(myuuid))
    return myuuid

def portgen():
    port = random.choice(range(1111,65520))
    return port 

def inbound():
    inb = random.choice(range(111111111111,999999999999))
    return inb

def jj(port,id,inbo):
        topass = '{"listen":null,"port":%s,"protocol":"vmess","settings":{"clients":[{"id":"%s","alterId":0}],"disableInsecureEncryption":false},"streamSettings":{"network":"ws","security":"none","wsSettings":{"path":"/","headers":{}}},"tag":"inbound-%s","sniffing":{"enabled":true,"destOverride":["http","tls"]}},' % (port,id,inbo)
        #print(topass)
        return topass
first = '{"log":null,"routing":{"rules":[{"inboundTag":["api"],"outboundTag":"api","type":"field"},{"ip":["geoip:private"],"outboundTag":"blocked","type":"field"},{"outboundTag":"blocked","protocol":["bittorrent"],"type":"field"}]},"dns":null,\n'
second = '"inbounds":[\n'
with open("config.json","w") as f:
    f.write(first + second)
for i in range (5000):
    with open("config.json","a+") as f:
        p1 = portgen()
        p2 = uidgenerator()
        p3 = inbound()
        f.write("    " + str(jj(p1,str(p2),p3)))
        f.write("\n")
        f.close()
    with open("links.txt","a+") as f:
        f.write("vmess://" + str(getlink1(ip,p1,str(p2))))
        f.write("\n")
        f.close()    
third = '\n],\n'
fourth = '"outbounds":[{"protocol":"freedom","settings":{}},{"protocol":"blackhole","settings":{},"tag":"blocked"}],"transport":null,"policy":{"system":{"statsInboundDownlink":true,"statsInboundUplink":true}},"api":{"services":["HandlerService","LoggerService","StatsService"],"tag":"api"},"stats":{},"reverse":null,"fakeDns":null}'
with open("config.json","a+") as f:
    f.write(third)
    f.write(fourth)

    
