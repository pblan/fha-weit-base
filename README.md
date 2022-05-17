# fha-weit-base

Dieses Repo dient als Basis für die Veranstaltung "Web-Engineerung und Internettechnologien" an der FH Aachen. 

## Nutzung
Statt XAMPP oder ähnliches zu verwenden, setzen wir hier auf Docker.

Es werden Container erstellt für: 
- Apache
- MySQL
- phpmyadmin (optional)

Siehe `docker-compose.yml`:
    
```docker
version: "3.7"
services:
  www:
    build: .
    ports:
      - 8101:80
    volumes:
      - ./www:/var/www/html/
      - ./config/php/php.ini:/usr/local/etc/php/php.ini
    links:
      - db
    networks:
      - default
    restart: always

  # Diesen Block auskommentieren, um phpmyadmin nicht zu nutzen
  phpmyadmin:
    image: phpmyadmin/phpmyadmin:latest
    ports:
      - 8100:80
    links:
      - db:db
    restart: always

  db:
    image: mysql
    ports:
      - 3310:3306
    environment:
      MYSQL_USER: user
      MYSQL_PASSWORD: password
      MYSQL_ROOT_PASSWORD: root
    command:
      [
        '--default_authentication_plugin=mysql_native_password',
        '--character-set-server=utf8',
        '--collation-server=utf8_general_ci'
      ]
    volumes:
      - ./mysql_data:/var/lib/mysql
      # automatisches Importieren von allen Dumps in `dumps`
      - ./dumps/:/docker-entrypoint-initdb.d
    networks:
      - default
```

Der Webserver wird gestartet mit dem Befehl:

```bash
docker-compose up -d
```

Dabei wird:
1. Das Image in der `Dockerfile` gebaut (Apache-Server)
    - Image `php:7.1.2-apache` für PHP-Support
    - `docker-php-ext-install mysqli` installiert eine Extension für MySQL-Support
    - `node` und `nodejs` werden ebenfalls installiert 
2. Ein MySQL-Container wird gestartet
    - root-Passwort: `root`
3. Ein phpmyadmin-Container wird gestartet
    - Der Container ist optional und kann auskommentiert werden 

## Testen

Nachdem alle Container gebaut wurden, kann der Webserver über die URL `http://localhost:8101` aufgerufen werden.

Es sollte standardmäßig die `index.php` aus dem Ordner `/www` aufgerufen werden.

Wenn alles funktioniert, wird eine Liste aller Pokemon angezeigt, die testweise in die Datenbank geladen wurde.

Um die Datenbank zu inspizieren (oder sonstige Schmuddeldinge) kann phpmyadmin über die URL `http://localhost:8100` aufgerufen werden.
Dabei sind die Zugangsdaten `root` und `root`.