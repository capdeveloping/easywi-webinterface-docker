# easywi-webinterface-docker

# What is Easy-WI?
First of all Easy-Wi is a Web-interface that allows you to manage server daemons like gameservers. In addition it provides you with a CMS which includes a fully automated game- and voiceserver lending service. The development goal is always to automate as far as possible. The daily work which requires an administrator should be reduced to a minimum.

# Information
Das EasyWi Webinterface wurde in ein Docker container gepackt.

# Variables

`GAMESERVERUPDATEHOURS`

Sollen die Gameserver updates jede Stunde laufen oder nur nachts?

default: "1-6"

 
`SERVERNAME`

Setzen des Webserver Hostnamens.

default: "_"


# Updaten von Easy-WI
Bei jedem erstellen des Containers wird immer das Offizielle Repo geclont. Möchte man immer den gleichen stand haben muss man den Mountpoint anpassen.

Immer das neuste erhalten:

    volumes:
      - "/path/to/host/folder/config.php:/home/easywi_web/htdocs/stuff/config.php"
      - "/path/to/host/folder/keyphrasefile.php:/home/easywi_web/htdocs/stuff/keyphrasefile.php"

Immer den gleichen Stand erhalten:

    volumes:
      - "/path/to/host/folder/:/home/easywi_web/htdocs/"
