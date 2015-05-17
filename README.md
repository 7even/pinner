# Pinner

Микросервис для авторизации по PIN-коду.

## Разворачивание

Pinner использует Redis для хранения PIN-ов. Установка для OS X:

``` sh
$ brew install redis
```

Установка на другие платформы описана на
[оф. сайте Redis](http://redis.io/download).

Также для шифрования кодов необходима соль, ее можно сгенерировать rake-таском:

``` sh
$ rake salt
```

Эта команда генерирует соль и сохраняет в файле `.env`, откуда она потом
считывается [dotenv](https://github.com/bkeepers/dotenv) и доступна в приложении
как `ENV['SALT']`. Это действие нужно выполнить один раз в каждом окружении
(после изменения соли существующие PIN-коды становятся недействительными).

После этого приложение готово к запуску под любым rack-совместимым сервером:

``` sh
$ rackup
```

## Использование

(в примерах для HTTP-запросов используется
[httpie](https://github.com/jakubroztocil/httpie))

### Получение PIN

``` sh
$ http -v pinner.dev/send_pin

GET /send_pin HTTP/1.1
Accept: */*
Accept-Encoding: gzip, deflate, compress
Host: pinner.dev
User-Agent: HTTPie/0.7.2

HTTP/1.1 200 OK
Connection: close
Date: Sun, 17 May 2015 13:48:30 GMT

236658
```

### Авторизация по PIN

``` sh
$ http -vf POST pinner.dev/authorize pin=236658

POST /authorize HTTP/1.1
Accept: */*
Accept-Encoding: gzip, deflate, compress
Content-Length: 10
Content-Type: application/x-www-form-urlencoded; charset=utf-8
Host: pinner.dev
User-Agent: HTTPie/0.7.2

pin=236658

HTTP/1.1 200 OK
Connection: close
Date: Sun, 17 May 2015 13:49:29 GMT
X-Access-Token: 447cd08c3488f06156a4e949a8bc4869a6d8352cd35e849bc188d88c4da8e38a
```

При получении недействительного PIN приложение отвечает `401 Unauthorized`.
