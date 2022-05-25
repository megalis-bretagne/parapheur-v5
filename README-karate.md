# Karate 

## Paramètres

## Démo

### [Scénario original](https://lsoffice.libriciel.fr/sheet/#/2/sheet/view/gpOCRl+pGFDsfLs8K4h8laRKd0M3-ySbXnkvbHbC7Ok/)

- [ ] Administration
    - [x] Connexion avec un superadmin
    - [x] Créer une entité
    - [x] Supprimer une entité
    - [x] Créer un Administrateur
    - [x] Créer un Administrateur d'entité puis se connecter
    - [x] Créer un user sans droit avec notif unitaire
    - [ ] Créer un user sans droit avec une image de signature
    - [ ] Créer un utilisateur WebService
    - [ ] Créer un bureau pour visa pour le user sans droit
    - [ ] Créer un bureau pour le WebService
    - [ ] Créer un circuit 1 étape de signature du bureau signataire
    - [ ] Créer un circuit de validation Visa
    - [ ] Créer un type Monodoc/sous-type ACTES/Délibération en PAdES, protocole ACTES
- [ ] Utilisation
    - [ ] Tester un flux .doc avec tag + un fichier .odt depuis bureau ws -> signataire -> Fin de circuit
    - [ ] Saisir des annotations publiques et privées
    - [ ] Imprimer
    - [ ] Télécharger le documet original
    - [ ] Visualiser le journal des évènements
    - [ ] Envoi par mail
    - [ ] Demande d’avis complémentaire sur l’étape de signature
    - [ ] Positionner la signature par défaut
    - [ ] Visuel de signature dans Adobe
- [ ] Utilisation flux Webservice
    - [ ] Injection PASTELL => CONVENTIONS/Conv. à cosigner externe (monodoc PDF)
    - [ ] Visa collaboratif (ET)
    - [ ] Signature externe placement tag
    - [ ] Signature interne étape concurrente (OU) avec placement manuel
    - [ ] Récupération du document dans pa
- [ ] Utilisation flux PES
    - [ ] xpath de signature (. ou //Bordereau)
    - [ ] Visionneuse PES
    - [ ] ASAP consultables
    - [ ] Signature
    - [ ] Visualisation de la signature dans notepad++
- [ ] Utilisation format automatique
    - [ ] Signature pdf primo signé en détaché
    - [ ] Récupération des signatures et check du format

### @todo

- [ ] vérifier dans quels cas, le fait d'aller jusqu'à "Créer un user sans droit avec notif unitaire" en mode @wip empêche de supprimer les 4 utilisateurs de l'entité
  - à cause de l'utilisateur pour lequel on a changé la configuration des notifications, mais si on le supprime à part, on peut supprimer l'entité

### Exemples de démarrages

```bash
# En mode développement, affichage du navigateur
./gradlew test --info -Dkarate.options="--tags @demo-bde" -Dkarate.headless=false
# Pour l'intégration continue
# @todo
```

## @todo

- [ ] pouvoir spécifier l'URL en ligne de commande
- [ ] pouvoir spécifier `CHROME_BIN` en ligne de commande
- [ ] il faudrait aussi tester la suppression à la fin du scénario (entité chargée)
