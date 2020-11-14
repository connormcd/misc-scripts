SELECT 'ALTER USER '|| name ||' IDENTIFIED BY VALUES '''|| spare4 ||';'|| password ||''';' FROM sys.user$ WHERE name like 'AP%';


SELECT 'ALTER USER '|| name ||' IDENTIFIED BY VALUES '''|| spare4 ||';'|| password ||''';' FROM sys.user$ WHERE name like 'OR%';
