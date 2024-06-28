Change Log
==========

Toutes les modifications apportées au projet seront documentées dans ce fichier.

Le format est basé sur le modèle [Keep a Changelog](http://keepachangelog.com/)
et adhère aux principes du [Semantic Versioning](http://semver.org/).


## [5.1.4] - 2024-06-10

### Ajouts

- Vérification de la casse à la création d'un circuit
- Recherche de bureaux par nom court dans l'administration
- Modification d'un sous-type à l'étape brouillon
- Fusion des colonnes "action" et "état" dans l'historique d'un dossier
- Passage automatique dossier suivant après une action

### Corrections

- Icônes manquantes dans l'éditeur de circuits
- Suppressions des fichiers stockés en cas d'échec de création du brouillon
- Augmentation des timeout des requêtes
- Logo pixélisé
- Message d'erreur lors de la création d'un utilisateur existant sur une autre entité
- Labels
- Message d'erreur sur l'API SOAP lorsqu'un dossier a été supprimé
- Status d'un dossier transféré dans l'API SOAP
- Encodage des caractères spéciaux, et catégories des notifications dans le mail groupé
- Affichage des calques "Après signature"
- Acteur variable en fin de circuit, via les scripts de sélections
- Timeout lors d'une grande page via l'API SOAP
- Les dossiers n'étaient pas marqués comme lus quand ouverts depuis un mail de notification
- Rafraîchissement automatique du PDF dans l'interface après ajout d'un commentaire
- Affichage de la liste des destinataire pour le mail sécurisé
- Couleur du toaster en cas d'erreur sur un mail sécurisé

### Suppressions

- Possibilité de créer par erreur une étape externe parallèle dans l'éditeur de circuit


## [5.0.26] - 2024-06-10

### Ajouts

- Vérification de la casse à la création d'un circuit
- Recherche de bureaux par nom court dans l'administration
- Modification d'un sous-type à l'étape brouillon
- Fusion des colonnes "action" et "état" dans l'historique d'un dossier
- Passage automatique dossier suivant après une action

### Corrections

- Icônes manquantes dans l'éditeur de circuits
- Suppressions des fichiers stockés en cas d'échec de création du brouillon
- Augmentation des timeout des requêtes
- Logo pixélisé
- Message d'erreur lors de la création d'un utilisateur existant sur une autre entité
- Labels
- Message d'erreur sur l'API SOAP lorsqu'un dossier a été supprimé
- Status d'un dossier transféré dans l'API SOAP
- Encodage des caractères spéciaux, et catégories des notifications dans le mail groupé
- Affichage des calques "Après signature"
- Acteur variable en fin de circuit, via les scripts de sélections
- Timeout lors d'une grande page via l'API SOAP
- Les dossiers n'étaient pas marqués comme lus quand ouverts depuis un mail de notification
- Rafraîchissement automatique du PDF dans l'interface après ajout d'un commentaire
- Affichage de la liste des destinataire pour le mail sécurisé
- Couleur du toaster en cas d'erreur sur un mail sécurisé

### Suppressions

- Possibilité de créer par erreur une étape externe parallèle dans l'éditeur de circuit


## [5.1.3] - 2024-04-22
[5.1.3]: https://nexus.libriciel.fr/repository/ls-raw/public/signature/iparapheur-5.1.3.tar.gz

### Ajouts

- Nouvel éditeur de circuit
- Nouveau modèle de notifications groupées
- Signatures détachées dans la création d'un dossier dans l'API REST
- Signatures détachées en fichiers dans le ZIP, en plus du PREMIS
- Suppression du fichier stocké sur le serveur si une transformation en PDF échoue à la création d'un dossier
- Le menu d'administration peut s'ouvrir dans un nouvel onglet avec un Ctrl+click

### Corrections

- Annulation de modification dans l'éditeur de configuration de signature externe
- Métadonnées dupliquées dans les sous-type
- Bureaux notifiés à l'étape
- Problèmes de suppression de l'image de signature, depuis les préférences utilisateurs et depuis l'admin
- Problèmes de visualisation de l'image de signature avec un admin d'entité
- Ajout des métadonnées du dossier pour le téléchargement au format premis
- Enchaînement de circuit
- Ajout de document en annexe
- Mention "en l'absence de" dans le tampon de signature quand le placeholder y figure
- Unicité des noms de définitions de circuits en modification
- Limite de caractères des annotations
- Image du cachet pixelisée
- Affichage des actions après modification du brouillon
- Affichage des URL longues en métadonnées
- Blocage des doublons de noms de circuits
- Gestion des bureaux multiples dans l'éditeur de circuits
- Éllipse d'une longe métadonnée
- Modification d'un token à l'édition d'un connecteur de signature externe
- La prévisualisation du cachet utilise l'image du sceau du cachet, et non scan de signature
- Message d'erreur lors d'une signature avec un modèle personnalisé invalide
- Lien vers le dossier dans la notification, lorsque le dossier est en délégation
- Gestion des noms de fichiers trop longs dans l'affichage
- Métadonnée du bureau délégataire sur le modèle personnalisé de signature
- Validation multiple depuis le tableau de bord, lorsqu'un des dossier est en lecture obligatoire
- Application du modèle de signature personnalisé sur un tag de signature
- Position de signature sur un PDF avec une rotation


## [5.0.25] - 2024-04-22
[5.0.25]: https://nexus.libriciel.fr/repository/ls-raw/public/signature/iparapheur-5.0.25.tar.gz

### Ajouts

- Nouvel éditeur de circuit
- Nouveau modèle de notifications groupées
- Signatures détachées dans la création d'un dossier dans l'API REST
- Signatures détachées en fichiers dans le ZIP, en plus du PREMIS

### Corrections

- Annulation de modification dans l'éditeur de configuration de signature externe
- Métadonnées dupliquées dans les sous-type
- Bureaux notifiés à l'étape
- Problèmes de suppression de l'image de signature, depuis les préférences utilisateurs et depuis l'admin
- Problèmes de visualisation de l'image de signature avec un admin d'entité
- Ajout des métadonnées du dossier pour le téléchargement au format premis
- Enchaînement de circuit
- Ajout de document en annexe
- Mention "en l'absence de" dans le tampon de signature quand le placeholder y figure
- Unicité des noms de définitions de circuits en modification
- Limite de caractères des annotations
- Image du cachet pixelisée
- Affichage des actions après modification du brouillon
- Affichage des URL longues en métadonnées
- Blocage des doublons de noms de circuits
- Gestion des bureaux multiples dans l'éditeur de circuits
- Éllipse d'une longe métadonnée
- Modification d'un token à l'édition d'un connecteur de signature externe


## [5.1.2] - 2024-03-15
[5.1.2]: https://nexus.libriciel.fr/repository/ls-raw/public/signature/iparapheur-5.1.2.tar.gz

### Ajouts

- Vérification du certificat présenté par Pastell sur un mail-sécurisé
- Limite du nombre de caractères pour les annotations

### Corrections

- Notifications
- Mention "En l'absence de" à la signature
- Différence v4-v5 sur le `getHistoDossier` via l'API SOAP
- Permission de création de sous-type vide
- Compatibilité LemonLDAP
- "Bordereau d'impression" renommé en "Bordereau" dans l'administration
- Script de sélection de circuits avec Bureaux variables
- Persistence des valeurs de métadonnées sur plusieurs exécution de scripts de sélections
- Affichage du sélecteur pour l'association du calque au type de document
- Métadonnées non renseignées dans le PDF d'impression
- Ordre des modèles

### Suppressions

- Propositions de traduction des navigateurs.
- Onglet IPNG dans l'administration avancée
- Étapes IPNG dans l'administration d'un circuit
- Onglet "Permissions en filtre" dans l'administration d'un sous-type


## [5.0.24] - 2024-03-15
[5.0.24]: https://nexus.libriciel.fr/repository/ls-raw/public/signature/iparapheur-5.0.24.tar.gz

### Ajouts

- Vérification du certificat présenté par Pastell sur un mail-sécurisé

### Corrections

- Différence v4-v5 sur le `getHistoDossier` via l'API SOAP
- Permission de création de sous-type vide
- Compatibilité LemonLDAP
- "Bordereau d'impression" renommé en "Bordereau" dans l'administration
- Script de sélection de circuits avec Bureaux variables
- Persistence des valeurs de métadonnées sur plusieurs exécution de scripts de sélections
- Limite du nombre de caractères pour les annotations
- Affichage du sélecteur pour l'association du calque au type de document
- Langage de la page
- Métadonnées non renseignées dans le pdf d'impression

### Suppressions

- Onglet IPNG dans l'administration avancée
- Étapes IPNG dans l'administration d'un circuit
- Onglet "Permissions en filtre" dans l'administration d'un sous-type


## [5.1.1] - 2024-02-22
[5.1.1]: https://nexus.libriciel.fr/repository/ls-raw/public/signature/iparapheur-5.1.1.tar.gz

### Ajouts

- Message lorsque l'utilisateur ne possède aucun bureau
- Mention "en l'absence de" lors d'une notification à un suppléant

### Corrections

- Enregistrement de l'images de signature
- Doublon de dossiers dans les notifications groupées
- Gestion du caractère `:` dans l'API SOAP
- Modification d'une permission de création d'un sous-type
- Affichage d'un nom long de type/sous-type
- Changement de modèle sur une signature PAdES en cours
- Affichage du document lors d'un avis complémentaire
- Label de rejet dans le journal des évènements
- Action de l'avis complémentaire depuis le tableau de bord
- Création d'un circuit sans étape
- Suppression d'un brouillon si le démarrage s'est mal passé via API
- Problèmes d'accents dans le nom avec la récupération depuis Pastell
- Signature et rejets via délégation
- Ajout d'un commentaire PDF
- Gestion de la suppression d'un champ dans le formulaire de création de calque
- Info-bulle incorrecte dans le champ complémentaire de l'utilisateur
- Gestion de la métadonnée booléenne à `false` sur l'évaluation du script de sélection
- Message d'erreur à l'édition d'un bureau avec un mauvais paramètre
- Validité de la signature avec le modèle de signature alternatif (signature personnalisée)

### Suppression

- Actions instantanées sur les formulaires contenant une image de signature
- Avis complémentaire et transfert d'un dossier en brouillon
- Avis complémentaire et transfert d'un dossier en fin de circuit
- Boutons en double dans la popup de signature


## [5.0.23] - 2024-02-22
[5.0.23]: https://nexus.libriciel.fr/repository/ls-raw/public/signature/iparapheur-5.0.23.tar.gz

### Ajouts

- Message lorsque l'utilisateur ne possède aucun bureau
- Mention "en l'absence de" lors d'une notification à un suppléant

### Corrections

- Enregistrement de l'images de signature
- Doublon de dossiers dans les notifications groupées
- Gestion du caractère `:` dans l'API SOAP
- Modification d'une permission de création d'un sous-type
- Affichage d'un nom long de type/sous-type
- Changement de modèle sur une signature PAdES en cours
- Affichage du document lors d'un avis complémentaire
- Label de rejet dans le journal des évènements
- Action de l'avis complémentaire depuis le tableau de bord
- Création d'un circuit sans étape
- Suppression d'un brouillon si le démarrage s'est mal passé via API
- Problèmes d'accents dans le nom avec la récupération depuis Pastell
- Signature et rejets via délégation
- Ajout d'un commentaire PDF
- Gestion de la suppression d'un champ dans le formulaire de création de calque
- Info-bulle incorrecte
- Gestion de la métadonnée booléenne à `false` sur l'évaluation du script de sélection
- Message d'erreur à l'édition d'un bureau avec un mauvais paramètre

### Suppression

- Actions instantanées sur les formulaires contenant une image de signature
- Avis complémentaire et transfert sur un dossier en brouillon
- Avis complémentaire et transfert sur un dossier en fin de circuit
- Boutons en double dans la popup de signature


## [5.1.0] - 2023-02-07
[5.1.0]: https://nexus.libriciel.fr/repository/ls-raw/public/signature/iparapheur-5.1.0.tar.gz

### Ajouts

- Lien vers les notes de versions dans la page "À propos"
- Liste des licences tierces dans la page "À propos"
- Modification des modèles de signature et de cachet dans l'admin avancée
- Recueil de modèles de signatures
- Bouton "Créer un super-administrateur" dans la liste globale des utilisateurs
- Lien cliquable sur les métadonnées de type URL
- Nom court du bureau dans le tampon de signature
- Icône indiquant la validité technique de la signature sur les documents PAdES

### Corrections

- Tampons de signatures par défaut re-dessinés
- Taille par défaut du cadre de signature

### Suppression

- Mention "Action automatique" dans l'image du cachet automatique par défaut


## [5.0.22] - 2024-01-25
[5.0.22]: https://nexus.libriciel.fr/repository/ls-raw/public/signature/iparapheur-5.0.22.tar.gz

### Ajouts

- Gestion du retour à la ligne dans le champ Informations complémentaires

### Corrections

- Crash à la dissociation de l'élément d'un calque
- Suppression d'un circuit dont la clé est contenue dans une autre clé
- Délai de chargement des bureaux
- Position d'un tag de signature lorsque deux tags sont sur la même ligne
- Gestion d'un ZIP en annexe
- Message d'erreur lors de la suppression d'une métadonnée utilisée
- Affichage des noms longs de bureaux
- Infobulle du champ Informations complémentaires
- Transfert de dossier depuis l'administration
- Signature papier
- Échanges avec PASTELL lors d'un dossier avec un circuit de création
- Affichage de la liste des circuits parfois vide
- Affichage de l'aperçu du circuit
- Recyclage d'un dossier rejeté
- Recherche de dossier automatique depuis v5 vers ancienne v4
- Mime type des documents lors de leur téléchargement
- Ajout de Metadata à la création depuis l'API  standard
- Augmentation du nombre de caractère autorisé dans les annotations publiques et privées (256 -> 512)


## [5.0.21] - 2024-01-08
[5.0.21]: https://nexus.libriciel.fr/repository/ls-raw/public/signature/iparapheur-5.0.21.tar.gz

### Corrections

- Script de rotation de backups


## [5.0.20] - 2023-12-07
[5.0.20]: https://nexus.libriciel.fr/repository/ls-raw/public/signature/iparapheur-5.0.20.tar.gz

### Ajouts

- Circuits dans l'API Standard
- Contrôles d'intégrité à la suppression d'un circuit
- Gestion fine de la taille des backups
- Indicateur de document principal dans le Premis
- Verrouillage des champs "Nom/Prénom/Mail" à l'édition d'un utilisateur synchronisé par LDAP

### Corrections

- Montée de version de Libersign, pour une version en OpenJDK
- Erreur à l'édition d'un calque, lors de la suppression d'un élément
- Erreur à l'association d'un calque à un sous-type
- Échanges avec Yousign V3
- Positionnement de page avec Universign
- Positionnement manuel de la signature
- Blocage à l'envoi d'un dossier à la corbeille
- Affichage de l'aperçu d'un circuit à la création d'un dossier en cas de script de sélection.
- Ajout d'un `_` au résultat d'un script de sélection commençant par un chiffre
- Préservation des tirets dans les migrations des circuits
- Liaisons avec Pastell
- Ajout d'une signature détachée à un dossier multi-docs
- Enregistrement du bureau émetteur dans les bureaux notifiées d'une étape finale
- Suppression d'une entité interrompue
- Récupération des signatures externes bloquées lorsqu'un des dossiers a été supprimé
- Échanges avec l'API Yousign
- Verrouillage des champs id lors d'une édition d'un utilisateur
- Verrouillage des champs id lors d'une édition d'un circuit
- Récupération des infos d'une entité
- Duplication d'un circuit
- Envoi à la corbeille depuis le tableau de bord
- Typos
- Remplacement de la Cosignature détachée par le fichier à signer

### Suppressions

- Label "action automatique" dans le modèle de cachet par défaut
- Positionnement de signature pour une typologie à signature détachée


## [5.0.19] - 2023-10-25
[5.0.19]: https://nexus.libriciel.fr/repository/ls-raw/public/signature/iparapheur-5.0.19.tar.gz

### Ajouts

- Contrôle d'usage à la modification/suppression des métadonnées
- Création d'un dossier dans l'API standard
- Liste des types dans l'API standard
- Liste des types disponibles à la création de dossier dans l'API standard
- Liste des sous-types dans l'API standard
- Liste des sous-types disponibles à la création de dossier dans l'API standard

### Corrections

- Affichage des types limités dans les champs de recherches
- Affichage des circuits limités dans les champs de recherche
- Blocages lors de la suppression en masse de dossiers
- Méthode `isBureau` dans les scripts de sélection
- Notation de variables en `${variable}` dans les scripts de sélection
- Récupération via Pastell
- Erreur de syntaxe dans le Premis
- Divers bugs graphiques
- Contrôle de la version du PDF à l'envoi en signature externe via Yousign


## [5.0.18] - 2023-09-29
[5.0.18]: https://nexus.libriciel.fr/repository/ls-raw/public/signature/iparapheur-5.0.18.tar.gz

### Ajouts

- Support de l'API v3 de YouSign
- Ouverture de l'API standard
- Redémarrage nocturne de l'application
- Vérification de la non-utilisation d'un bureau à sa suppression
- Message d'erreur spécifique lorsqu'un dossier cherche à avancer vers bureau supprimé

### Corrections

- Restrictions des droits des superviseurs (actions en lots, annotations)
- Respect de l'habilitation 'Créer un dossier'
- Liste des entités associées pour les utilisateurs LDAP
- Gestion plus permissive des métadonnées inconnues à la création de dossier
- Accès aux dossiers après suppression d'un bureau du circuit
- Typos sur les caractères accentués dans la visionneuse PES
- Sélection de la taille de police (auto / fixe) dans le tampon de signature
- Libellé approprié pour les notifications de rejets
- Récupération d'une signature détachée par l'API SOAP
- Affichage du nom de l'utilisateur connecté dans le header
- Message lors de la suppression de documents en lot dans les dossiers rejetés
- Enregistrement des bureaux favoris
- Emplacement de signatures successives
- Signatures externes en lot
- Position de la signature avec Yousign et Universign
- Affichage du rejet dans l'historique du fichier PREMIS
- Retour d'API lors d'un mauvais login
- Emplacement de signature lorsque 2 tags sont sur la même ligne
- Statut dans iparapheur_historique.xml (API SOAP)
- Accès aux dossiers en fin de circuit depuis la page principale
- Affichage du bureau supérieur hiérarchique dans l'édition d'un bureau
- Récupération des dossiers Universign

### Suppression

- Notification à la création de Brouillon
- Étape variable dans les circuits de création
- Accès à la corbeille aux admin fonctionnels

### Patch

- Version 3.1 de de partie client-natif de Libersign
- Mise à jour de la librairie Angular
- Mise à jour de la librairie FontAwesome, et des icônes


## [5.0.17] - 2023-07-13
[5.0.17]: https://nexus.libriciel.fr/repository/ls-raw/public/signature/iparapheur-5.0.17.tar.gz

### Ajouts

- Aide à la saisie des mots de passe
- Liste des tenants dans l'API provisioning
- CRUDL des cachets serveur dans l'API provisioning
- Modification d'un cachet serveur
- Tooltip pour les utilisateurs LDAP

### Corrections

- Templates de mails
- Messages d'erreurs
- Récupération de la signature détachée
- Métadonnées obligatoires lors d'une annulation
- Erreur lors d'un sous-type supprimé
- Page de la signature sur Yousign
- Liste des types limités à 50
- Changement de tenant dans l'administration des dossiers
- Envoi à la corbeille depuis les dossiers rejetés
- Absence avec typologie
- Téléchargement du dossier avec annexes
- Métadonnées obligatoires sur le tableau de bord
- Labels


## [5.0.16] - 2023-06-30
[5.0.16]: https://nexus.libriciel.fr/repository/ls-raw/public/signature/iparapheur-5.0.16.tar.gz

### Corrections

- Connexion avec PASTELL
- Métadonnée décimale
- Affichage des message d'erreurs


## [5.0.15] - 2023-06-23
[5.0.15]: https://nexus.libriciel.fr/repository/ls-raw/public/signature/iparapheur-5.0.15.tar.gz

### Ajouts

- Rectangle sur l'emplacement de signature
- Métadonnées dans l'API de provisioning

### Corrections

- Liste des bureaux associés
- Emplacement de signature
- Affichage des boutons d'action
- Données manquantes dans le fichier PREMIS
- Édition d'une étape de signature externe
- Téléchargement d'un dossier
- Annulation de signature externe
- Duplication d'un circuit
- Infobulles
- Évènement "Lu" dans l'historique
- Étape collaborative
- Affichage des permissions dans l'administration
- Valeurs par défaut à la création d'un sous-type
- Tri des dossiers traités
- Popup de bureau
- Recherche de bureaux variables
- Messages d'erreurs explicites
- Affichage de l'image de signature
- Date limite dans l'API SOAP
- Webservices via PASTELL
- Sélection d'administration fonctionnelle à la création d'un utilisateur
- Annotations sur les avis complémentaires

### Suppressions

- Affichage de la métadonnée obligatoire à un avis complémentaire
- Sortie de la popup lors d'un clic hors-cadre


## [5.0.14] - 2023-05-31
[5.0.14]: https://nexus.libriciel.fr/repository/ls-raw/public/signature/iparapheur-5.0.14.tar.gz

### Ajouts

- Injection de métadonnées techniques sans avoir à les créer
- Champs de recherche dans l'administration
- Limite du nombre de caractères dans le champ libre de l'utilisateur
- Libersign v3

### Corrections

- Actions sur un dossier
- Annotations au démarrage d'un dossier
- Champs de Recherche
- Dissociation d'un utilisateur
- Historique des évènements dans l'API SOAP
- Locale et Timezone
- Labels
- Suppression d'un tenant
- Suppression d'un dossier par un administrateur fonctionnel
- Connexion avec Pastell
- Récupération des types par Pastell
- Permissions via Pastell
- Unification des labels dans la visionneuse de dossiers
- Dissociation d'un utilisateur d'une entité
- Édition d'un utilisateur
- Notifications groupées

### Suppressions

- Actions instantanées dans la popup d'édition des bureaux
- Bouton d'envoi à la corbeille pour un utilisateur sans droit approprié


## [5.0.13] - 2023-05-09
[5.0.13]: https://nexus.libriciel.fr/repository/ls-raw/public/signature/iparapheur-5.0.13.tar.gz

### Corrections

- Labels rétrocompatibles de signature externe via SOAP
- Marqueur "Lu" sur un dossier


## [5.0.12] - 2023-04-28
[5.0.12]: https://nexus.libriciel.fr/repository/ls-raw/public/signature/iparapheur-5.0.12.tar.gz

### Corrections

- Rollback de Libersign


## [5.0.11] - 2023-04-25
[5.0.11]: https://nexus.libriciel.fr/repository/ls-raw/public/signature/iparapheur-5.0.11.tar.gz

### Ajouts

- Label générique lors d'une action multiple groupée
- Suppression automatique des espaces dans les formulaires de création
- API de provisioning
- Mise à jour des compteurs de dossiers par WebSocket

### Corrections

- Redirection lors d'une action groupée
- Reconnaissance du Mimetype d'une PJ PES
- Injection de métadonnées
- Métadonnée dans un script de sélection
- Tag et emplacements de signature
- Suffixe de la signature CAdES générée
- Suppression d'une absence
- Labels
- Dossier de preuve lors d'un envoi à la corbeille
- Détection du tag sur une signature externe
- Mise à jour du header
- Notifications groupées
- Affichage du bureau émetteur dans l'aperçu du sous-type

### Suppressions

- Bouton en double

### Patch
- Version 3.0 de de partie client-natif de Libersign


## [5.0.10] - 2023-03-30
[5.0.10]: https://nexus.libriciel.fr/repository/ls-raw/public/signature/iparapheur-5.0.10.tar.gz

### Corrections

- Envoi d'un dossier avec métadonnées via le webservice SOAP


## [5.0.9] - 2023-03-24
[5.0.9]: https://nexus.libriciel.fr/repository/ls-raw/public/signature/iparapheur-5.0.9.tar.gz

### Corrections

- Disparition des boutons d'annotations sur les petits écrans
- Disparition des annotations au redimensionnement de la fenêtre
- Affichage des flux PES signés
- Création d'un dossier avec métadonnées par webservice SOAP


## [5.0.8] - 2023-03-17
[5.0.8]: https://nexus.libriciel.fr/repository/ls-raw/public/signature/iparapheur-5.0.8.tar.gz

### Ajouts

- Filtre "Traités"
- Règles de sécurité NginX

### Corrections

- Affichage des métadonnées à valeur prédéfinies
- Téléchargement depuis la corbeille
- Ouverture d'un dossier
- Tri sur la colonne de création
- Orthographe et affichage
- Historique de la signature externe externe
- Parse des métadonnées Entières/Décimales
- Forcer les métadonnées vides à `null` dans le script Groovy
- Affichage des actions lors d'une délégation
- Hiérarchie des bureaux préservée lors d'une édition
- Affichage des actions pour les absences spécifiques à un type / sous-type
- Droits de visualisation sur les dossiers pour le bureau remplaçant en cas d'absence

### Suppressions

- Affichage des Zips dans la visionneuse PDF
- Sous-dossier `./src` sur l'installation serveur
- Messages d'alerte sur les métadonnées lors d'une création d'un dossier manuel avec script de sélection
- Possibilité de créer un calque sans image


## [5.0.7] - 2023-02-17
[5.0.7]: https://nexus.libriciel.fr/repository/ls-raw/public/signature/iparapheur-5.0.7.tar.gz

### Ajouts

- Backup interne, avec roulement sur 2 jours
- Redirection en cas de bureau unique

### Corrections

- Notifications groupées
- Rejet depuis le tableau de bord
- Historique lors d'un rejet de signature externe
- Transfert de fichier

### Suppressions

- Possibilité de supprimer la dernière entité d'un utilisateur non-admin


## [5.0.6] - 2023-01-17
[5.0.6]: https://nexus.libriciel.fr/repository/ls-raw/public/signature/iparapheur-5.0.6.tar.gz

### Ajouts

- Bouton "Télécharger" à toutes les étapes d'un dossier
- Option de débridage de la taille des scripts de sélection (paramétrable sur le serveur uniquement)
- Placeholder "heure-minute-seconde" dans le tampon de signature
- Règles de sécurité Nginx
- Crash (volontaire) lors d'une tentative de signature de PES non valide
- Point d'entrée de version
- Nouveau logos Libriciel/iparapheur


### Corrections
- Changement de page dans la visionneuse
- Espaces dans les champs recherche
- Supprimer une annexe dans les étapes de création
- Filtre par type/sous-type
- Déclaration d'une absence par type/sous-type
- Xpath automatique
- Fonction isBureau sur les noms courts dans les scripts de sélections
- Métadonnées à virgules dans les scripts de sélections
- Logs dans les scripts de sélection
- Message d'erreur explicite à la création d'un dossier
- Nom de filtre tronqué
- Labels des cartouches
- Signature multi-documents
- Message d'erreur lors d'un doublon
- Signature en XAdES détaché
- Format de signature AUTO
- Affichage de l'absence par sous-types
- Affichage des dossiers délégués
- Permission de création en public
- Affichage de la liste des tenants
- Téléchargement des dossiers à toutes les étapes
- Liens depuis la recherche du header
- Tri par colonne "date de création"
- Évènement "lu" dans le bordereau
- Signature PKCS7
- Visionneuse PES

### Suppressions

- Lien (inutile) sur un envoi par mail direct
- Création d'un dossier avec circuit de création par webservices


## [5.0.5] - 2023-01-17
[5.0.5]: https://nexus.libriciel.fr/repository/ls-raw/public/signature/iparapheur-5.0.5.tar.gz

### Ajouts

- Bouton download à toutes les étapes

### Corrections

- Performances
- Erreur sur le tri par date
- Création de plusieurs absences
- Affichage de métadonnées à valeurs restreintes

### Suppressions

- Feeder


## [5.0.4] - 2022-12-08
[5.0.4]: https://nexus.libriciel.fr/repository/ls-raw/public/signature/iparapheur-5.0.4.tar.gz

### Ajouts

- Purge automatique
- Changement de version majeure  (et de socle technologique) de Keycloak
- Redirection automatique HTTP -> HTTPS
- Vérification de la présence de dossiers en cours avant de supprimer un bureau
- Limite mémoire adaptée sur la nouvelle version de keycloak

### Corrections

- Signature de dossiers multi-documents
- Absences déclarées le jour même
- Inversion des métadonnées de validation/ de rejet à l'enregistrement des définitions de circuit
- Autorisation d'action principale (ajout d'annexe par le superviseur possible)
- Gestion des noms de dossiers long sur TDB
- Stabilisation de la sélection de bureaux associés (bureau variable)
- Affichage de la liste déroulante d'entités
- Menu initial pour l'administrateur d'entité
- Association d'entité à la création d'un utilisateur
- Réparation des popup de création de type et sous-type

### Suppressions

- Options de sous-type en protocole HELIOS
- Permission d'ajouter des annexes en protocole HELIOS


## [5.0.3] - 2022-11-29
[5.0.3]: https://nexus.libriciel.fr/repository/ls-raw/public/signature/iparapheur-5.0.3.tar.gz

### Ajouts

- Action "Enchaîner" dans l'historique des évènements
- Variable d'environnement pour l'emplacement des données

### Corrections

- Possibilité de modifier les préférences d'un utilisateur LDAP
- Label "Imprimer" en "Générer le PDF d'impression"
- Labels mal nommés
- Utilisation du docker compose natif
- Noms des processus sur le serveur
- Suppressions des annexes ajoutées à l'étape courante

### Suppressions

- Permission d'ajouter des annexes pour un superviseur
- Permission de supprimer des annexes dans le circuit de validation
- Permission de modifier les champs LDAP d'un utilisateur
- Champs ID
- Bouton "Supprimer" en fin de circuit, et permissions associées à la suppression


## [5.0.2] - 2022-11-08
[5.0.2]: https://nexus.libriciel.fr/repository/ls-raw/public/signature/iparapheur-5.0.2.tar.gz

### Ajouts

- Fallback v4 sur le Legacy Bridge
- Spinners dans les listes
- Heure dans le bordereau d'impression par défaut
- Affichage prévisionnel du circuit en cas de script de sélection
- Bordereau dans le mail sécurisé

### Corrections

- Nom de l'entité par défaut, sur les nouvelles installs
- Enchaîner un circuit (effectif sur les nouveaux dossiers créés)
- Script de sélection avec bureau variable
- Nom de l'action automatique dans les mails
- Permission de création des sous-types
- Titre de popup
- Connecteur Pastell
- Messages d'erreur en anglais
- Signature, visa et cachet multiples

### Suppressions

- Visibilités non autorisées par l'admin dans création d'un dossier
- Visuel du circuit après une dé-selection de typologie


## [5.0.1] - 2022-10-20
[5.0.1]: https://nexus.libriciel.fr/repository/ls-raw/public/signature/iparapheur-5.0.1.tar.gz

### Ajouts

- Points d'entrée d'API
- Analyses de failles de sécurité via Trivy

### Corrections

- Cachet automatique
- Tampon de signature sur un cachet
- Message d'erreur en cas de certificat de cachet expiré
- Injection de documents no nPDF via Webservices
- Sauvegarde des fréquences de notifications
- Label dans le mail de notification

### Suppressions

- Service de transfert de fichiers d'IPNG, sur les installations non-IPNG


## [5.0.0] - 2022-10-09
[5.0.0]: https://nexus.libriciel.fr/repository/ls-raw/public/signature/iparapheur-5.0.0.tar.gz

### Ajouts

- Page "À propos"
- Popup d'historique des évènements
- Circuit de création visible dans l'affichage d'un circuit en cours
- Drag-N-Drop des documents sur la création d'un nouveau dossier
- Tri par colonne dans l'administration des connecteurs de signature externe
- Les tags de positionnements (par défaut `#signature#` et `#cachet#`) sont utilisés
- Les tags de positionnements numérotés `#xxx_%n#` sont supportés, à paramétrer sur le serveur
- Les délégations et délégations par dates dans la console d'administration
- Les délégations auto-gérées par chaque utilisateur
- Tests de prévention de doublon dans les noms/clé des circuits
- Dupliquer un circuit
- Date limite d'un dossier
- Charte graphique sur la visualisation d'un dossier
- Interdiction de création d'une étape externe parallèle
- Vérifications des types de documents principaux ajoutés selon le type de signature
- Transformation des documents bureautique en PDF
- Masquage du bouton des commentaires PDF lorsque le sous-type l'interdit
- Fond blanc et bordure sur la signature par défaut
- Masquage du bouton de positionnement de signature lorsqu'il n'y a pas de signature à venir dans le circuit
- Masquage du bouton de positionnement de signature lorsque ce n'est pas cohérent avec le format de signature
- Bouton suppression sur un dossier en fin de circuit
- Verrouillage des points d'entrée API admin aux seuls administrateurs
- Annotations publiques/privées
- Paramètres serveurs à la personnalisation de l'UI
- Signature XAdES détachée sur tous les types de documents
- Compatibilité GetDoc & PushDoc
- Reconnexion automatique à la BDD. Le crash existant est toujours là, mais dorénavant on devrait avoir une récupération automatique, plus souple
- Mails en doublons
- Format de signature Auto
- Métadonnée obligatoire à une étape
- Page "À propos"
- Auto-diagnostic d'installation de Libersign
- Compatibilité PushDoc
- Compatibilité Pastell
- Renforcement des permissions sur le `FolderController` (API uniquement, devrait être transparent depuis le Web)
- Renforcement des permissions sur le `DocumentController` (API uniquement, devrait être transparent depuis le Web)
- Message d'alerte sur un enchaînement non-compatible
- Métadonnée obligatoire à une étape de validation
- Métadonnée obligatoire à une étape de rejet
- Pastell multi-doc et métadonnées
- Contrôles d'intégrité sur les circuits des sous-types
- Filtres par banette
- Alertes sur les contrôles d'intégrité des circuits la popup de sous-type
- Filtre "Dossier en retard" et "Dossier récupérable"
- Transfert depuis l'administration des dossiers
- Filtre des espaces sur un formulaire de mail
- Possibilité de surcharger la signature par défaut en créant un fichier `/default_signature.yml`
- Positionnement de la signature externe
- Suppression d'un brouillon
- Conversion des fichiers RTF
- Position de signature via YouSign
- Position de signature détachée
- Label sur les étapes parallèles
- Envoyer par mail
- Signature XAdES détachée
- Multi-doc à la signature externe
- Gestion des doublons dans les noms des dossiers extraits
- Message d'erreur lors d'un envoi de fichier trop gros
- Message d'erreur en cas de PDF protégé
- Affichage de la liste vide des certificats
- Auto-selection d'un sous-type unique
- Contrôles de validité sur le formulaire d'admin de signature externe
- Icônes d'administrateurs
- Message d'erreur en français
- Pastell-connector, External-signature-connector et Workflow dans le monitoring
- Nom générique sur une action automatique
- Annotations sur les transferts/Avis complémentaires
- Actions secondaires sur une étape de cachet
- Action "Lu" dans l'historique du dossier
- Traduction partielle des messages d'erreurs retournés par les signatures externes
- Récupération des signatures détachées par les webservices
- Enregistrement de la visibilité
- Bureaux favoris
- Popup des bureaux à notifier
- Popup RGPD de première connexion
- Évènement "lu" dans l'historique SOAP
- No-MTOM sur les requêtes SOAP
- Modification des documents pendant le circuit de création
- Notifications d'erreur manquantes
- Icône dédiée pour l'avis complémentaire
- Troncage des noms longs
- tri par nom sur la page des bureaux
- Valeurs par défaut du tag de signature
- Remplacement du document principal en création
- Footer sur la page de login
- Super-Administrateurs sans entités
- Conversion des images en PDF
- Récupération des signatures détachées dans PASTELL
- Script de sélection de circuit
- Affichage des annexes non-PDF
- Label "En l'absence de..." dans la cartouche de circuit
- Tooltips
- Cachet automatique
- Formulaires IPNG
- Administrateur fonctionnel
- Absences : séparation de la liste des dossiers à traiter pour cause de remplacement et ajout du filtre correspondant
- Transfert/second opinion depuis la liste
- Date limite d'un dossier modifiable
- Librairie générée par IP-core
- PDF d'impression dans le zip envoyé à la corbeille
- Bordereau d'impression dans les templates modifiables
- Augmentation de la limite de caractère des noms de sous-types
- Affichage du type parent dans la recherche de sous-type
- Gestion des circuits avec un bureau sans acteur
- Bordereau dans les modèles éditables
- Métadonnées dans le bordereau
- Enregistrement décalé des formulaires
- Infos du certificat dans le bordereau d'impression, sur les nouvelles signatures
- Contrôle de l'unicité des noms courts de bureau
- Valeurs négatives de la page de tampon (`-1` pour la dernière page, `-2` pour l'avant-dernière, `-3` pour l'avant-avant dernière...)
- Fonctionnement du formulaire mot de passe oublié
- Préremplir le champ sign externe
- Calques : Métadonnées internes
- Inclure les pièces jointes par défaut
- Vérification des informations saisies pour la signature externe en cours
- Ajout de signature externe à la page de création
- Indexes négatifs de page de signature
- Redirection sur le dossier après le recyclage
- Page négatives sur la signature externe, pour les opérateurs le supportant
- Alerte de certificat expiré
- Mail de dossier en retard, tous les lundi matin
- Délégation par type/sous-type
- Signature détachées à la création
- Bordereau dans le mail
- Utilisation des indexes des métadonnées
- Notifications de l'émetteur

### Corrections

- Reporting avec Sentry
- Édition d'un sous-type
- Nombre de documents principaux
- Charte graphique sur l'administration des dossiers
- Charte graphique sur l'administration des connecteurs de signature externe
- Charte graphique sur l'administration des métadonnées
- Charte graphique sur la création d'un nouveau dossier
- Reporting avec Sentry
- Enregistrement de tous les champs à la création d'un utilisateur
- Charte graphique sur les popups de création/suppression d'un utilisateur
- Charte graphique sur la popup d'édition d'un sous-type
- Enregistrer et envoyer dans le circuit
- Suppression des entités
- Type de signature automatique
- Scripts de sélection de circuit trop courts
- Charte graphique sur l'administration des entités
- Charte graphique sur l'administration de tous les utilisateurs
- Charte graphique sur l'administration des délégations
- Charte graphique sur l'administration des typologies
- Replier les entités dans la vue principale
- Récupération de tous les bureaux de l'arborescence
- Charte graphique sur l'administration des circuits
- Charte graphique à la navigation
- Charte graphique à la création d'un dossier
- Charte graphique à la création d'un dossier
- Modifications des habilitation des bureaux
- Signature externes qui remplacent le document original
- Nommage des signatures détachées
- Bug occasionnel sur la visualisation des circuits
- Suppression d'un dossier rejeté
- Signature valide après un positionnement manuel
- Positionnement de signature
- Charte graphique à l'administration des dossiers
- Signature de multi-docs principaux
- Petites retouches de performances
- Retours sur la page de création
- Retours sur la page d'administration de dossiers
- Transformation de documents
- Augmentation de la RAM par défaut pour Crypto
- Les nouveaux dossiers sans typologie sont mono-doc par défaut
- Limite du nombre de doc principaux
- Affichage du circuit en cours
- Charte graphique sur les dossiers en cours
- Charte graphique sur les archives
- Utilisation des bureau finaux sur les circuits de validation
- Assez gros refactor de PES-Viewer, résolutions de vulnérabilités
- Transferts/Visa complémentaires dans l'aperçu des circuits
- Crash à la récupération des bureaux favoris
- Enchaîner un circuit
- Design global
- Aperçu des circuits
- Contrôle sur les métadonnées dans l'admin
- Charte graphique sur les métadonnées
- Charte graphique sur les enchaînement
- Charte graphique sur les circuits
- Imprimer un dossier
- Fil d'Ariane dans l'admin
- Erreur 502 au rechargement
- Enregistrement des bureaux associés
- Liste de typologie
- Charte graphique sur les listes de tâches
- Création d'un bureau
- Création d'un sous-type
- Associations sous-type/métadonnées et sous-type/calques
- Création d'une métadonnée
- Signature/Cachet en mode AUTO
- Signature avec métadonnée obligatoire
- Charte graphique à la création de métadonnée
- Colonne émetteurs/bureau courant dans les bannettes Fin de circuit/Brouillons
- Mail sécurisé
- Tri par nom
- Diagnostic Libersign
- Faille de sécurité Spring4Shell sur nos briques internes
- Archives
- Position de signature manuelle
- Administration des mails sécurisés
- Impression de dossier
- Édition d'une configuration de mail sécurisé
- Édition d'une configuration de signature externe
- Rejet d'une tâche externe
- Signature externe - Docage
- Signature externe - Yousign
- Signature externe - Universign
- Renommage des archives en corbeille
- Contrôles sur les circuits dans l'administration des sous-types
- Annotations sur les étapes externes
- Charte graphique sur le header
- Charte graphique sur le tableau de bord
- Paramètre de signature externe dans un sous-type
- Cachet automatique
- Métadonnées obligatoires à une étape
- Affichage du circuit de création
- Taille des popups de signature
- Charte graphique à l'aperçu d'un brouillon
- Aperçu des circuits
- Nom dans le header
- Label du visa complémentaire
- Récupération d'un dossier par webservices
- Affichage des étapes à venir
- Pagination incorrecte
- Journal des évènements
- Valeur par défaut des booléens
- Affichage de la visionneuse PES
- Tri par défaut dans les préférences
- Sauvegarde d'un sous-type
- Mise en page des mails de signature externe
- Icône de placement de signature
- Traduction des tooltips de la visionneuse PDF
- Administration - Utilisateurs
- Administration - Tous les utilisateurs
- Métadonnées à une étape
- Charte sur le menu d'administration
- Éditeur de script de sélection
- Extraction des dossiers contenant un `/`
- Icônes dans la visionneuse PDF
- Commentaires dans la visionneuse PDF
- Préférences d'utilisateur
- Enregistrement d'une métadonnée à un sous-type
- Charte graphique à l'écran rejeté
- Affichage de l'image de signature
- Affichage des étapes collaboratives
- Envoi par mail
- Rejet des dossiers en cas de refus de signature externe
- Conformité des status et des liste renvoyée lors des recherche pour l'api SOAP
- Meilleure gestion de charge lors de la création du document d'impression
- Gestion de gros volumes de ressources et de permissions sur Keycloak
- Émetteur d'un dossier
- Enchaîner un circuit
- Recherche de dossiers par l'API SOAP
- Message d'erreur dans l'API SOAP
- Message d'erreur sur le login de la signature externe
- Titre du filtre par défaut
- Retirer le filtre par défaut
- Historique après un rejet
- Blocage de l'application après plusieurs impressions de dossiers
- Charte graphique sur le panneau de certificat de cachet serveur
- Augmentation de la mémoire tampon de la signature externe
- Charte graphique sur le header
- Erreur à l'enregistrement des préférences
- Bureaux inaccessibles
- Erreur 502 au rafraichissement de la page
- Affichage des images de signatures
- Enregistrement des paramètres de notifications
- Affichage du statut d'admin
- Signature externe enchainées
- Messages d'erreur à l'enregistrement de la signature externe
- Formulaire d'envoi par mail
- Augmentation du timeout
- Conversions de documents
- Valeurs incorrectes dans les sélecteurs
- Optimisation de la mémoire à la récupération des signatures externes
- Charte graphique sur les droits
- Enregistrement des droits
- Conversion des fichiers depuis Pastell
- Messages explicites pour les cachets serveur
- Création de dossiers
- Préférences d'utilisateur
- Envoi depuis Pastell
- Charte graphique sur les métadonnées
- Charte graphique sur les listes de dossiers
- Info-bulle sur un bureau variable
- Labels
- Info-bulles
- Charte graphique sur l'admin des bureaux
- Liens cliquables
- Message d'alerte à l'enchaînement de circuit
- Conversion DOC/DOCX
- Compatibilité SOAP
- Avis complémentaire
- Nommage des circuits
- Impression d'un dossier avec le bordereau
- Surcharge des métadonnées de la signature
- Envoi à la corbeille
- Dissociation d'un utilisateur d'une entité
- Charte sur le header
- Charte graphique sur la liste des dossiers
- Info-bulles
- Positionnement de signature externe
- Charte sur la signature externe
- Injection par Pastell
- Renommage de la partie "Profil/Administration" en "Profil/Débogage"
- Envoi à la corbeille
- Envoi avec Docage
- Charte graphique sur le header
- Supervision
- Informations du serveur
- Modification des étapes
- Pagination des dossiers
- Gestion des super-admins
- Supervisions
- Délégations
- Visa complémentaire
- Noms longs de bureaux
- Transfers de dossiers depuis l'administration
- État des dossiers dans l'administration
- Actions manquantes
- Supprimer un brouillon
- Contrôle des métadonnées
- Signature papier
- Charte sur les boutons de création de dossier
- Infobulles sur les actions
- Signatures détachées et Pastell
- Titre de la page de login
- Erreur d'association des utilisateurs
- Modèles de mail dans l'administration
- Modèle du mail envoyé
- Envoi à la corbeille
- Recyclage
- Avis complémentaire
- Affichage des étapes concurrentes, collaboratives
- Banettes non-cliquables
- Labels sur les filtres
- Affichage des métadonnées
- Étapes de lecture bloquées en "En cours"
- Ajout d'un connecteur mail-sec
- Extraction par le Feeder
- Création par PASTELL
- Suppression d'un circuit
- Erreur d'enregistrement en cas de métadonnée obligatoire
- No-MTOM sur l'API REST
- Super-admins
- Listes vides
- Récupération via Pastell
- Extraction via Feeder
- Fichiers non-PDF via Pastell
- Icône lu/non-lu dans les tâches en cours
- Conversions des Docs depuis une VM Win10/Google Chrome
- Tests de mails depuis un admin de tenant
- Journal des évènements sur les transferts
- Supprimer une absence
- Visibilité des sous-types
- Labels
- Bureaux associés
- Visibilité des dossiers
- Archiver un dossier
- Icônes
- Vérifications de formulaires
- Actions en doublon
- Labels
- Sélections des types dans l'administration des dossiers
- Interdiction de la suppression d'une conf utilisée
- Fermeture de la popup de signature externe pour éviter les doubles-actions
- Envoi à la corbeille
- Sélection de tenant dans la corbeille
- Historique d'un dossier
- Droits de remord sur un dossier
- Visibilité d'une popup
- Colonnes manquantes
- Bureaux favoris
- Enchaînement de circuits
- Affichage plus propre d'un bureau supprimé
- Échanges avec Pastell
- Tag `#signature#` reconnu comme un `#signature0#`
- Signature par lot
- Déclarations des absences
- Déclaration des superviseurs
- Supervision multi-collectivités
- Suppression d'une supervision
- Contourner une étape externe
- Transfert depuis l'administration
- Suppression d'une absence
- Bordereau d'impression
- Affichage de la cartouche de circuit
- Journal des évènements
- Labels
- Message d'erreur
- Envoi à la corbeille
- Webservices
- Accents dans les mails
- Création de dossier et UUID
- Extraction de dossier
- Recherche par état
- Récupération des signatures détachées dans Pastell
- Signature détachée d'un fichier primo-signé
- ACTE générique et automatique vers ACTE CAdES et CAdES sans protocole
- Namespace SOAP
- Nom du doc d'impression
- Fil d'Ariane super-admin
- Redirection après démarrage d'un dossier
- Logo et nom "iparapheur"
- Footer de la page de login
- Téléchargement de signatures détachées depuis l'UI
- Tampon PAdES par défaut
- Corrections de Label et de disposition
- Affichages des étapes d'un dossier en cours
- Recherche de dossier (non-admin)
- Les compteurs de dossiers en retard ne comptent que les dossiers en cours
- Étapes externes bloquées
- Dossiers avec métadonnée obligatoire bloqués
- Configuration d'une étape externe
- Paramètre d'un sous-type
- Message d'erreur sur le mail-sec
- Impression du fichier
- Messages d'erreur
- Création de circuit
- Recherche depuis le header
- Création d'un admin fonctionnel
- Bordereau de signature
- Enchaînement de circuits
- Calques
- Enregistrement des métadonnées
- Cachet automatique
- Retour direct, sans écriture disque, lors d'un appel à PDF-Stamp
- URL et hash par défaut du PES-Policy de la signature PES
- Inversions des valeurs de page de calque `-1/0`. La valeur `0` devient `Toutes les pages` et `-1` devient `Dernière page`.
- Minimum 2 caractères contre 3 en V4
- Paramètre Permissions de création et Visibilité en filtre restent en 'Public
- Renommer un fichier à l'étape brouillon
- Calques
- Droit de remords
- Lecture obligatoire dans le sous-type
- Feeder : échec de l'extraction
- Modifier du sous-type d'un brouillon avec métadonnées
- Signature externe - configuration
- MailSec - avec case "Envoyer le bordereau"
- Journal des évènements - étapes externes
- Signature externe - Afficher le bon message d'erreur
- Utilisation de la surcharge des sous-types des infos de signature
- Police automatique dans le macaron de signature
- Injection d'un flux Helios via Pastell
- Enregistrement des fréquences de notifications
- Tests des templates
- Accents et labels dans les mails de notifications unitaires
- Affichage des actions groupées
- Suppression d'un dossier malgré un sous-type supprimé
- Retour de rejet Universign
- Extraction via Feeder
- Infos du formulaire de signature externe
- Recherche de dossiers via l'API SOAP
- Script de sélection de circuit et métadonnée
- Bureaux à notifier
- Notifications unitaires
- Notifications groupées
- Envoi par mail
- Affichage des éléments partiellement supprimés
- Script de sélection avec métadonnée
- Affichage de la corbeille
- Appels SOAP
- Connexion Pastell
- Fréquence de notifications
- Lien dans le mail
- Surcharge des infos de signature
- Aperçu du circuit
- Journal des évènements
- Messages d'erreur sur la signature détachée
- Modification de "En cours" en "À traiter"
- Redirection après une erreur

### Suppressions

- Login par l'adresse mail (conséquence de l'autorisation des doublons)
- Modification du MdP par l'administrateur (Selon le RGPD, seul l'utilisateur doit pouvoir le faire)
- Formulaires PDF
- Métadonnées dans l'envoi par mail simple
- Champs inutilisés dans le formulaire de signature externe
- Gestion des notifications par l'admin à la création de l'utilisateur, non-RGPD
- Service Docage, le temps de trancher le cas de la primo-signature
- Affichage des menu d'admin aux non-admins
- Signature enveloppée et/ou externe sur un fichier avec une signature détachée
- Exécuter plusieurs fois la même action
- Affichage des menu d'admin aux non-admins
- Cohérence de l'icône lu/non-lu dans la liste des tâches
- Réglage de super-admin dans l'administration de tenant
- Vue grille pour un utilisateur à plus de 15 bureaux
- Positionnement de signature sur un dossier sans signature à venir
- Popup d'erreur au chargement d'un dossier
- Accès à un bureau non autorisé
- Onglets de stats
- Bouton rejet en cas d'attente d'étape externe
- Redirection vers le dossier lors de l'envoi
- Lien vers les statistiques
- Option d'emplacement de signature quand il n'y a plus de signature dans le circuit
- Absences sans date de début
- Possibilité de supprimer les utilisateurs internes
- Possibilité d'ajouter une signature détachée sur un format enveloppé
- Mots de passe par défaut
- Colonne inutile dans le dashboard
