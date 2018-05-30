# serversetup
## WordPress server beállítása Ansible segítségével
#### By: Arnold Tóth
##### felhasznált anyagok: Google, tanórák, git: andreipak/wordpress-ansible
##### init: 2018.03.22 23:00
###### host rendszer: Ubuntu Desktop 17.10, macos 10.13, Windows 10
###### TODO:
[x]install script<br />
[x]basic config<br />
[x]ssh <br />
[]txt változat <br />
[]több, részletes md, esetleges hibakezelés<br />
[]md-ben teljes részletes leírás<br />
[]képek<br />
[]vbox configok<br />
[]pfsense setup<br />
<br /><br />
Kezdjük a szerver virtuális gép beállításával <br />
Csináljuk meg a host-only networkot. Ezt a virtual box beállításai > hálózat pontban találjuk.<br />
!!!KÉP: vbox host only!!!<br />
Csináljuk meg a virtuális gépet *ha nincs fent*, majd egyből *még indítás előtt* állítsuk be be a hálózati adaptereit. *Ideiglenesen* kap egy **bridgelt** és egy **host-only** adaptert, a könnyű ssh elérésért és tesztelésért, *később a bridgelt-et kivesszük, mert a forgalom a tűzfalon keresztül fog folyani.*<br />
**jegyezzük meg meg melyik adapternek mi a neve, később szükségünk lesz rá!**<br />
![Bridged](https://i.imgur.com/ROeeqBU.png) ![Host-only](https://i.imgur.com/ECGbNpN.png)<br />
Általában az enp0s3 adapter a bridgelt, a enp0s8 pedig a host only adapter<br />
Ha nincs felrakva a rendszer, akkor installáljuk. Ez semmi extra, csak a standard Next > Next > OK procedúra <br />
*(Ha esetleg problémád lenne az ubuntu szerver telepítéssel, ebben a gitben lesz egy ubiinstall.md a segítségedre)*<br />
**ezeket a beállításokat fogom használni:**<br />
`felhasználónév: user`<br />
`jelszó: kalifornia`<br />
`hostname: ubuntu-sv`<br />
Telepítésnél elsődleges interfésznek válasszuk a *bridge-lt* adaptert! <br />
Ha a telepítés befejeződött, indítsuk újra a gépet, majd jelentkezzünk be a megadott felhasználó/jelszó kombinációval (user/kalifornia)<br />
[!!] Ha a feladat azt kéri, hogy a beállítást ssh-n keresztül csináljuk, akkor a telepítés után *egyből* csináljuk ezt meg, illetve innentől kezdve *ne* használjuk a virtualboxban futó oprendszert, csak a hoston lévő terminált!<br />
Először is telepítsük az openssh-server-t: `sudo apt install openssh-server`<br />
Lessük meg az ip-címünket az `ip addr sh` parancsot kiadva! Keressük ki a bridgelt kártya ip címét (elméletileg csak ennek van értelmes címe, a neve általában `enp0s3` )<br />
Lépjünk be a **host** gépről: `ssh user@virtuális.gép.ip.címe` <br />
Írjunk be egy *yes*-t majd adjuk meg *user* jelszavát.<br />
!!!KÉP:ssh setup+LOGIN!!!<br />
Szedjük le a szükséges anyagokat a `git clone https://github.com/Intel107/serversetup.git` paranccsal!<br />
Menjünk bele a mappájába (`cd serversetup`), majd futtassuk le a beállító scriptet (`sudo ./setup.sh`) <br />
!!!KÉP:github clone+setup.sh!!!<br />
Hagyjuk, hogy letöltse és telepítse a script a programokat, amikor jelszót kér, adjunk meg neki egyet *(illetve jegyezzük meg)*. Ez lesz a MySQL szervernek a root jelszava. [Ha véletlen nem adsz meg semmit, a jelszó "kalifornia"] <br />
Ha végzett, nézzük meg működik-e!<br />
A script miután lefutott, kidobja nekünk a virtuális gép IP-címét, írjuk is be ezt a címet a host gép böngészőjébe.<br />
!!!KÉP script ip + wp setuppage!!! <br />
Itt láthatjuk a WordPress telepítőjét. Értelemszerűen töltsük ki, jegyezzük meg miket adunk meg (főleg az username/password kombót)<br />
**A szerver beállítását ezzel meg is csináltuk, jöhet a tűzfal**<br />
[!!] Előtte állítsuk le a virtuális gépet, majd a beállításaiból szedjük ki a **bridgelt** adaptert! Utána ne felejtsük el visszakapcsolni a gépet <br />
!!!KÉP: bridgelt kártya off!!<br />
### pfSense
Hozzunk létre egy új virtuális gépet pfsense néven! (ha még nincs) Az alap beállítások /OpenBSD 64-bit/ tökéletesen megfelelnek(next>next>ok) <br />
Indítás előtt adjunk ennek is egy bridgelt meg egy host-only kártyát!<br />
Egy enterrel indítsuk el a telepítőjét.<br />
Az első képernyőn a keymapot érdemes magyarra állítani(hu.iso2 néven szerepel)<br />
Válasszuk ki az Accept > Quick/easy installt > Standard kernel > Reboot menüpontokat<br />
Vegyük ki a virtuális gépből az iso-t. hogy következő induláskor ne arról induljon<br />
!!!KÉP:remove iso!!!<br />
Miután újraindul, megkapjuk a pfsense főmenüjét. Itt kérjünk egy shellt a 8-as gombbal, majd írjuk be a `pfctl -d` parancsot, hogy hozzáférjünk a webconfighoz a WAN lábról is, majd lépjünk ki egy `exit` beütésével<br />
Ezután lessük ki a WAN láb ip-címét, és írjuk be a host gép böngészőjébe<br />
!!!KÉP:WAN IP!!!<br />
A böngészőnek nem feltétlen tetszik az aláíratlan https bizonyítvány, ezért ne ijedjünk meg, teljesen normális a nagy piros felkiáltójeles háromszög.<br />
Az Advanced/Haladó gombbal kérhetjük is, hogy engedjen minket be a teljesen biztonságos pfsense webconfigba.<br />
Itt léjünk be egy `admin/pfsense` párossal <br />
Lefuttat nekünk egy varázslót, amiben kéri, hogy adjuk meg a működéséhez szükséges minenféléket.<br />
Nyomjunk két Next-et, és ezután figyeljük mit hogyan írunk.<br />
Én ezekkel a beállításokkal használtam, a feladat kéréseinek megfelelően módosítsuk őket:<br />
`Hostname: pfSense` <br />
`Domain: suli.lan` <br />
`Primary DNS Server: 8.8.8.8` <br />
`Secondary DNS Server: 8.8.4.4` <br />
`Time server: time.euro.apple.com` <br />
A következő oldalon ijesztően sok konfig közül néhány említésre méltó van csak:<br />
`DHCP Hostname: pfSense-totha<br />`
Illetve a két alsó pipa, abból a felsőt *(private networks)* szedjük ki, hogy a host gépről el tudjuk érni az oldalt<br />
A következő oldalon a LAN beállításokra kérdez rá. Ez megint tőlünk, illetve a feladattól függ. Az alapbeállítás-t írjuk át 192.168.1.1-ről 192.168.**56**.2-re<br />
Az utolsó oldalon pedig adjunk meg egy admin jelszót, majd jegyezzük meg <br />
A Reaload gombbal a szerver újratölti a beállításokat. Kb fél perc múlva adjuk ki megint a `pfctl -d` parancsot, hogy ismét hozzáférjünk a confighoz<br />
