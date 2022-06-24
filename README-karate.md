# Karate

## WIP

### Exécution

```bash
./gradlew test --info -Dkarate.options="--tags @business,@demo-simple-bde" -Dkarate.headless=true
```

- 540 tests
- 18 failures
- 0 ignored
- 22m51.23s duration
- 96% successful

## _Legacy bridge_

@see  `<wsdl:portType name="InterfaceParapheur">`
@see https://otrs.libriciel.fr/otrs/index.pl?Action=AgentFAQZoom;ItemID=583;Nav=
  - voir 6.1. Statuts de dossiers possibles

### Lancement des tests

#### Forme générale

```bash
./gradlew test \
  --info \
  -Dkarate.baseUrl=https://iparapheur-5-0.recette.libriciel.net/ \
  -Dkarate.options="--tags @legacy-bridge --tags @tests"
```

##### Arguments de la ligne de commande

| Argument           | Obligatoire | Valeur par défaut              |
| ---                | ---         | ---                            |
| `-Dkarate.baseUrl` | -           | `http://iparapheur.dom.local/` |
| `karate.chromeBin` | -           | `/usr/bin/chromium-browser`    |
| `karate.headless`  | -           | `true`                         |
| `-Dkarate.options` | Oui         | -                              |

##### _Tags_

| Usage                            | `-Dkarate.options`                                   | Dossier ou fichier                                                                  |
| ---                              | ---                                                  | ---                                                                                 |
| Intégration continue             | `--tags @legacy-bridge`                              | `src/test/resources/features/004_legacy-bridge/SOAP`                                |
| Paramétrage                      | `--tags @legacy-bridge --tags @setup`                | `src/test/resources/features/004_legacy-bridge/SOAP/001_setup/001_setup.feature`    |
| Création de dossiers             | `--tags @legacy-bridge --tags @folder`               | `src/test/resources/features/004_legacy-bridge/SOAP/001_setup/002_folders.feature ` |
| Traitement des dossiers via l'UI | `--tags @legacy-bridge --tags @folder-ui-processing` | `src/test/resources/features/004_legacy-bridge/SOAP/001_setup/003_ui.feature`       |
| Lancement des tests              | `--tags @legacy-bridge --tags @tests`                | `src/test/resources/features/004_legacy-bridge/SOAP/002_tests`                      |

### Informations / @fixme

#### `CreerDossier` / `DossierID`

- [ ] le `DossierID` semble bien renvoyé en v.5 également, pourquoi est-ce que je ne le retrouve pas ? A cause du préfixe ??
- [x] Pastell génère un UUID et l'envoie à la requête
- [ ] web-delib, en direct, [récupère l'id du dossier généré par IP](https://gitlab.libriciel.fr/libriciel/pole-actes-administratifs/web-delib-6/web-delib/-/blob/08256d2d8da94a3bcc209ea4a58e5212bd55ff68/app/Controller/Component/IparapheurComponent.php#L449)
- [ ] web-gfc, en direct ?

#### Préfixe de namespace

- [ ] web-delib [utilise de temps en temps le préfixe `S:`](https://gitlab.libriciel.fr/libriciel/pole-actes-administratifs/web-delib-6/web-delib/-/blob/08256d2d8da94a3bcc209ea4a58e5212bd55ff68/app/Controller/Component/IparapheurComponent.php#L429) (qui est `SOAP-ENV:` en IP 5.0.0-EA.beta40)

#### `echo`

- [x] web-delib vérifie que [le message de retour contient bien la chaîne qu'il a envoyé](https://gitlab.libriciel.fr/libriciel/pole-actes-administratifs/web-delib-6/web-delib/-/blob/08256d2d8da94a3bcc209ea4a58e5212bd55ff68/app_check/Lib/VerificationLib.php#L480)

### Questions / @todo

- [x] version de l'API SOAP ? -> Non
- [ ] vérification des messages d'erreur
  - [ ] lors d'une mauvaise création de dossiers
    - [ ] en spécifiant 2 fois un même `DossierID`
- [ ] issue IP 4, `RechercherDossiers`
  - [ ] la création d'un dossier multidoc est possible en monodoc (il ne bronche pas) 
  - [ ] la création dun dossier "cossu" (multidoc, dont un avec primo-signature XML et annexes) fonctionne mais le dossier est ensuite bloqué à l'étape de visa ()
  - [ ] la recherche de dossier `Rejet*` ne fonctionne plus depuis que j'ai modifié le nom du type (`Auto` -> `Auto monodoc`)
  - [ ] la dernière annotation publique ne remonte pas
    - probablement pas corrigée (c'est comme ça depuis un moment, au moins 3 ans) 
  - `match foo count(/records//record) == 3`
- @fixme: tests `CreerDossier`
  - `DocumentsSupplementaires`/`DocAnnexe` -> multidoc en plus de DocumentPrincipal
  - `DocumentsAnnexes`/`DocAnnexe` -> vraies annexes
  - `DossierID`
    - il est retourné par `CreerDossier` (à vérifier)
    - pas spécifié -> UUID
    - en spécifiant (par des vieux connecteurs probablement), à déprécier, probablement à ne pas tester
      - par exemple un nom de fichier
      - pas de doublon possible

### _Endpoints_

- [x] `ArchiverDossier` **
- [x] `CreerDossier` ***
- [x] `echo` ***
- [x] `EffacerDossierRejete` **
- [x] `ExercerDroitRemordDossier` *
- [x] `ForcerEtape` *
- [x] `GetCircuit` **
- [x] `GetDossier` ***
- [x] `GetHistoDossier` **
- [x] `GetListeMetaDonnees` **
- [x] `GetListeSousTypes` **
- [x] `GetListeTypes` **
- [x] `GetMetaDonneesRequisesPourTypeSoustype` **
- [x] `RechercherDossiers` ***

#### "À déprécier" (tâches d'administration)

- `GetCircuitPourUtilisateur`
- `GetListeSousTypesPourUtilisateur`
- `GetListeTypesPourUtilisateur`
- `IsUtilisateurExiste`

#### Dépréciés (S2LOW)

- `CreerDossierPES` 
- `EnvoyerDossierMailSecurise`
- `EnvoyerDossierPES`
- `EnvoyerDossierTdT`
- `GetClassificationActesTdt`
- `GetStatutTdT`

## Paramètres

## Démo

### [Scénario original](https://lsoffice.libriciel.fr/pad/#/2/pad/edit/7luyoZ1VSHfCwGkVYwqWtSEU/)

- [Comparatif du scénario sur plusieurs beta](https://lsoffice.libriciel.fr/sheet/#/2/sheet/view/gpOCRl+pGFDsfLs8K4h8laRKd0M3-ySbXnkvbHbC7Ok/)

---

- [ ] Administration
    - [x] Connexion avec un superadmin
    - [x] Créer une entité
    - [x] Supprimer une entité
    - [x] Créer un Administrateur
    - [x] Créer un Administrateur d'entité puis se connecter
    - [x] Créer un user sans droit avec notif unitaire
    - [x] Créer un user sans droit avec une image de signature
    - [x] Créer un utilisateur WebService
    - [x] Créer un bureau pour visa pour le user sans droit
    - [x] Créer un bureau pour le WebService
    - [x] Créer un circuit 1 étape de signature du bureau signataire
    - [x] Créer un circuit de validation Visa
    - [x] Créer un type Monodoc/sous-type ACTES/Délibération en PAdES, protocole ACTES
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
