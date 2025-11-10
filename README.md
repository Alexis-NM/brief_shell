## Console

La console est un canal textuel fourni par le système d’exploitation.  
Elle sert surtout à afficher du texte en output.

## Terminal

Le terminal est une application qui émule une console dans une fenêtre graphique.
Il gère les entrées input et les sorties output. Il gère l’affichage (couleurs, défilement) et la saisie clavier.
C’est l’interface dans laquelle on tape les commandes, mais il ne les interprète pas : il les transmet simplement au shell.

## Shell

Le shell est le programme qui interprète les commandes.  
Il analyse la ligne tapée, applique les expansions et exécute les programmes demandés.  
C’est lui qui transforme ce que l’utilisateur écrit en actions réelles sur le système.

## Commande et arguments

Une commande correspond soit à un programme, soit à une instruction interne du shell.  
Les arguments aident à préciser ce que la commande doit faire.  
Pour exécuter une commande externe, lell recherche le programme she dans les répertoires listés dans la variable d’environnement `PATH`.  
Les variables d’environnement servent à transmettre des informations au shell et aux programmes (ex. `PATH`, `HOME`, `USER`).  
Une fois la commande trouvée, le shell l’exécute avec ses arguments et renvoie un code de sortie indiquant le résultat.

## Script

Un script est un **fichier texte** dans lequel on écrit plusieurs **commandes**, c’est-à-dire des instructions textuelles que l’on pourrait taper à la main dans le terminal pour demander des actions au système.
Pour pouvoir être utilisé, le script doit préciser quel **programme de lecture** va le prendre en charge.  
Ce programme de lecture est appelé un **interpréteur** : c’est un logiciel capable de lire du texte ligne par ligne et de transformer chaque ligne en action concrète. Dans les environnements Unix, l’interpréteur utilisé est généralement un **shell**, c’est-à-dire le programme spécialisé dans la compréhension et l’exécution des commandes. Cela signifie ici analyser l’instruction, trouver le programme à appeler si nécessaire, puis demander au système de réaliser l’action décrite. Le choix de cet interpréteur se fait grâce au **shebang**, qui est la première ligne du script et qui indique clairement quel programme doit lire le fichier.
Si le fichier dispose des bonnes **permissions d’exécution**, il peut être lancé directement comme un programme, même s’il reste en réalité un simple fichier texte lu séquentiellement par un interpréteur.
