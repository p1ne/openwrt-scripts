
<div dir="ltr" style="text-align: left;" trbidi="on">
В репозитории <a href="https://github.com/p1ne/openwrt-scripts">https://github.com/p1ne/openwrt-scripts</a> выложены мои скрипты для OpenWRT на роутере TP-Link MR3020/модеме Huawei E353 для использования в автомобиле для следующих задач<br />
<br />
1. Отсылка сообщения с примерным местоположением машины, которое определяется по данным текущей сотовой вышки, если к роутеру подключен 3G-модем<br />
2. Автоматическое переключение раздачи интернета между модемом, подключенным к роутеру и мобильным телефоном в режиме hotspot<br />
3. Автоматическая активация бесплатного режима Yota в случае, если к роутеру подключен Yota-модем<br />
<br />
Предполагается следующее:<br />
<br />
<ul style="text-align: left;">
<li>на роутере установлена прошивка <a href="http://acs-house.ru/category/files/">Peppy Snowdrop</a>&nbsp;и на нем при помощи патча 4gmodem-fix.patch исправлена строка 352 скрипта /usr/bin/4gmodem</li>
<li>используется модем Huawei (проверялась работа на E353)</li>
<li>Название интерфейса модема не содержит пробелов</li>
</ul>
<br />
Для работы с HTTP-запросами в репозитории представлены разные скрипты в зависимости от того, какие утилиты есть в системе - curl, wget или netcat (nc)<br />
<br />
<ul style="text-align: left;">
<li>curl самый нормальный и надежный способ, но для установки curl на MR3020 требуется дополнительное место на корневом разделе, которое можно организовать при помощи&nbsp;<a href="https://wiki.openwrt.org/ru/doc/howto/extroot">extroot</a>. Но для этого потребуется или вставить флешку в модем Huawei и сконфигурировать его или воспользоваться хабом</li>
<li>wget не работает с POST и https, но есть в составе busybox</li>
<li>netcat самый ненадежный способ, но не требует ничего кроме busybox</li>
</ul>
<br />
<div>
<br /></div>
Для корректной работы скриптов необходимо задать переменные окружения в файле <a href="https://github.com/p1ne/openwrt-scripts/blob/master/root/variables.sh">/root/variables.sh</a><br />
<br />
При помощи переменных задаются параметры точек доступа, ключи для провайдеров координат и сервисов нотификации, а также выбираются скрипты для получения координат и нотификаций.<br />
<br />
<b>Провайдеры координат по данным сотовых вышек (можно использовать только один):</b><br />
OPENCELLID_KEY - opencellid.org, требует регулярной отсылки данных вышек, поэтому может быть не очень удобен ( <a href="http://opencellid.org/#action=database.requestForApiKey">получить ключ</a>&nbsp;)<br />
YANDEX_KEY - Yandex Location API ( <a href="https://tech.yandex.ru/maps/keys/get/">получить ключ</a> )<br />
<br />
<b>Сервисы нотификации (можно использовать только один)</b><br />
NMA_KEY - Notify My Android для телефонов на Android ( <a href="https://play.google.com/store/apps/details?id=com.usk.app.notifymyandroid">приложение</a>&nbsp;)<br />
QPUSH_CODE, QPUSH_NAME - qpush.me для iPhone ( <a href="https://itunes.apple.com/us/app/qpush-push-text-links-from/id776837597">приложение</a> )<br />
<br />
<b>Точки доступа</b><br />
ROUTER_AP_NAME, ROUTER_AP_PASSWORD - имя и пароль точки доступа когда доступ в сеть раздается через модем<br />
<br />
PHONE_AP_NAME, PHONE_AP_MAC, PHONE_AP_PASSWORD - имя, MAC-адрес и пароль телефона, раздающего доступ в сеть<br />
<br />
Конфигурацию точек доступа можно посмотреть в <a href="https://github.com/p1ne/openwrt-scripts/blob/master/root/wireless.Modem">/root/wireless.Modem</a> и <a href="https://github.com/p1ne/openwrt-scripts/blob/master/root/wireless.Phone">/root/wireless.Phone</a><br />
<br />
<b>Скрипты</b><br />
NOTIFY_SCRIPT - скрипт нотификации. В названии скрипта указан сервис нотификации и используемая утилита для работы с HTTP-запросами<br />
COORDINATES_SCRIPT - скрипт получения координат. В названии скрипта указано название провайдера координат<br />
YOTA_SCRIPT - скрипт активации бесплатного режима работы Yota. В названии скрипта указана используемая утилита для работы с HTTP-запросами<br />
<br />
Скрипт отсылки координат запускается один раз при загрузке роутера через <a href="https://github.com/p1ne/openwrt-scripts/blob/master/etc/rc.local">/etc/rc.local</a><br />
Скрипт переключения на телефон, раздающий доступ в сеть, и обратно - раз в минуту через <a href="https://github.com/p1ne/openwrt-scripts/blob/master/etc/crontabs/root">/etc/crontabs/root</a><br />
<br /></div>
