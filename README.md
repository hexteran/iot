# Что это?
Это туториал о том, как поставить Hyperledger Sawtooth на узлы CORE.
# Зачем это?
В задачах, связанных с разработкой IoT устройств осуществляющих хранение и обработку данных посредством систем распределенных реестров, на этапе проектирования зачастую бывает необходимым провести симуляцию поведения различных DLT решений и проверить характеристики их работы в условиях динамической сетевой конфигурации.
# Как с этим работать?
Адекватно это работает только под Ubuntu 18.04.

Что делать чтобы заработало:
1) Поставить Sawtooth:

```
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 8AA7AF1F1091A5FD

sudo add-apt-repository 'deb [arch=amd64] http://repo.sawtooth.me/ubuntu/chime/stable bionic universe'

sudo apt-get update

sudo apt-get install -y sawtooth \
python3-sawtooth-poet-cli \
python3-sawtooth-poet-engine \
python3-sawtooth-poet-families

```
2) Сделать так, чтобы Sawtooth запускался в нескольких экземплярах. Так как core не виртуализует файловую систему, надо разнести данные, ключи и логи по разным директориям в зависимости от узла.
Делается это так: в /etc/sawtooth скопировать файлы path*.toml. Теперь важно создать папки /etc/sawtooth/n1/data, /etc/sawtooth/n1/log, /etc/sawtooth/n1/keys (сделать то же самое для n2 и n3).
Дальше нужно сгенерировать ключи для валидатора, для этого надо выполнить команды: 
```
 sudo sawtooth keygen root
 
 cd /etc/sawtooth
 
 sudo cp path1.toml path.toml
 sudo sawadm keygen
 
 sudo rm path.toml
 sudo cp path2.toml path.toml
 sudo sawadm keygen
 
 sudo rm path.toml
 sudo cp path3.toml path.toml
 sudo sawadm keygen
 
```
3) Дальше надо поставить CORE как написано тут http://coreemu.github.io/core/install.html
4) Запустить core-daemon и core-gui
5) Выбрать файл mytest1.imn
(Вообще можно создать свою сеть, но обязательно нужно чтобы первый узел имел ip 192.168.0.21, второй - 192.168.0.20, третий - 192.168.0.22)
6) Чтобы все двигалось, загрузить ns2 сценарий, нажав на wlan3, ткнув на ns2-scripts и выбрав mytest1.scen
7) Запустить сессию
8) Открыть последовательно каждый узел и запустить start*.sh (лучше запускать их последовательно, но это вроде как не обязательно, они должны сами найти друг друга когда запустятся)
9) Если все прошло нормально, теперь можно посылать транзакции. Можно делать это через intkey, например intkey set w1 10 --url http://192.168.0.20:8008 создаст кошелек w1 с 10 штуками на счету через второй узел. Есть еще inc и dec - синтаксис аналогичный, но первый прибавляет n монет, второй отнимает. Посмотреть все кошельки и содержимое можно через intkey list --url http://192.168.0.21:8008 (выгрузит через первый узел)
