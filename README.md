# practica01-09
Para esta práctica el proposito era realizar una instalación normal de la pila LAMP, pero el objetivo era trocearla en 2 maquinas distintas, una que estuviera destinada para la parte frontal (frontend), y otra que se encargue de la gestión de la parte trasera (backend). Por lo tanto obtendremos una arquitectura de 2 máquinas.

Para ello tendremos una configuración de archivos y directorios de esta forma:

``````
.
├── README.md
├── conf
│   └── 000-default.conf
└── scripts
    ├── .env
    ├── install_lamp_frontend.sh
    ├── install_lamp_backend.sh
    ├── setup_letsencrypt_https.sh    
    └── deploy_fontend.sh
    └── deploy_backend.sh

``````
