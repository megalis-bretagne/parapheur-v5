# Tests Karate

## Organisation des fichiers et dossier

### Premier niveau de dossiers

Étant donné que certaines parties des tests sont communes à IP 4 et IP 5 mais nécessitent du paramétrage - distinct suivant
la version d'IP, en amont (pour les tests du _legacy-bridge_) - le premier niveau de dossier, on ajoute en début de nom de
dossier une numérotation.

- __001-ip4:__ Tests IP 4
- __002-ip5:__ Tests IP 5
- __003-ip4-ip5:__ Tests IP 4 et IP 5

### Second niveau de dossiers

- __api:__ tests d'API (par contrôleur)
- __business:__ tests de fonctionnalités métier de bout en bout (par entité thématique, par exemple "Formats de signature")
- __demo:__ scénarios de démonstration
- __load:__ tests de charge
- __migration:__ tests suite au script de migration
- __prepare-business:__ paramétrage et éventuelle création de dossiers (par entité thématique, par exemple "Circuits unitaires"), les tests de bout en bout ne sont pas encore écrits
- __ui:__ tests d'interface graphique

## Notes pour IP 4

à partir du projet [i-Parapheur-4/iparapheur-core](https://gitlab.libriciel.fr/libriciel/pole-signature/i-Parapheur-4/iparapheur-core).

Si on exécute en docker / local, il faudra exclure les _features_ ayant le tag `@not-dom-local` (en ajoutant `--tags ~@not-dom-local`).

- `parapheur.document.openxml.accept=true dans alfresco-global.properties`

Si on exécute sur une autre plate-forme

- __Fichier de config:__ `/opt/iParapheur/tomcat/shared/classes/alfresco-global.properties`
- __Redémarrer IP:__ `/etc/init.d/alfresco stop && /etc/init.d/alfresco start`
- __Remise à zéro des données__
  - voir les valeurs de `dir.root`, `db.username`, `db.password` et `db.name` dans `/opt/iParapheur/tomcat/shared/classes/alfresco-global.properties` 
  - `/etc/init.d/alfresco stop`
  - `rm -rf /opt/iParapheur/alf_data` (`dir.root`)
  - `mysql -u alfresco -p` (`db.username` et `db.password`)
    - `drop database alfresco;` (`db.name`)
    - `create database alfresco;` (`db.name`)
  - `/etc/init.d/alfresco start`
  - `tail -f /opt/iParapheur/tomcat/logs/catalina.out`

Dans le fichier `gradlew`, `DEFAULT_JVM_OPTS='"-Xmx4096m" "-Xms4096m"'`, sinon `java.lang.OutOfMemoryError: Java heap space` avec `ip.signature.helios.validateSchema` (?)

```bash
# /etc/hosts
#127.0.0.1       ip4.dom.local
#127.0.0.1       secure-ip4.dom.local
# Augmenter les 3G -> 6G ?
# docker-compose down --volumes --remove-orphans && sudo rm -rf ./data && docker-compose up
# parapheur-core_1     | 07-Sep-2022 12:17:37.676 INFO [main] org.apache.catalina.startup.Catalina.start Server startup in [165085] milliseconds
./gradlew test --info -Dkarate.options="--tags @legacy-bridge --tags @ip4 --tags ~@setup" -Dkarate.headless=true  -Dkarate.baseUrl=https://iparapheur47.test.libriciel.fr -Dkarate.soapBaseUrl=https://secure-iparapheur47.test.libriciel.fr
```

```bash
./gradlew test --info -Dkarate.options="--tags @ip4 --tags @legacy-bridge" -Dkarate.headless=true  -Dkarate.baseUrl=https://ip4.dom.local -Dkarate.soapBaseUrl=https://secure-ip4.dom.local
./gradlew test --info -Dkarate.options="--tags @ip4 --tags @setup --tags @formats-de-signature" -Dkarate.headless=true  -Dkarate.baseUrl=https://ip4.dom.local -Dkarate.soapBaseUrl=https://secure-ip4.dom.local
./gradlew test --info -Dkarate.options="--tags @ip4 --tags @wip" -Dkarate.headless=true  -Dkarate.baseUrl=https://ip4.dom.local -Dkarate.soapBaseUrl=https://secure-ip4.dom.local

# 20230118 - 10h00 - succès pour les tests de 110 dossiers (55 normal et 55 surcharge) en 34m 13s
# 20230118 - 16h30 - 7 erreurs en 21m 11s (à cause de features/001-ip4/business/Formats de signature/002_folders/ACTES - PAdES/Cachet serveur - PDF_sans_tags - signe_pades.feature)
./gradlew test --info -Dkarate.options="--tags @ip4 --tags ~@not-dom-local --tags @formats-de-signature" -Dkarate.headless=true  -Dkarate.baseUrl=https://ip4.dom.local -Dkarate.soapBaseUrl=https://secure-ip4.dom.local
```

```
./gradlew test --info -Dkarate.options="--tags @ip4 --tags @wip" -Dkarate.headless=true  -Dkarate.baseUrl=https://ip4.dom.local -Dkarate.soapBaseUrl=https://secure-ip4.dom.local
```

```bash
./gradlew test --info -Dkarate.options="--tags @ip4 --tags @setup --tags @formats-de-signature" -Dkarate.headless=true  -Dkarate.baseUrl=https://iparapheur-4-7-10.recette.libriciel.org -Dkarate.soapBaseUrl=https://secure-iparapheur-4-7-10.recette.libriciel.org
./gradlew test --info -Dkarate.options="--tags @ip4 --tags @wip" -Dkarate.headless=true  -Dkarate.baseUrl=https://iparapheur-4-7-10.recette.libriciel.org -Dkarate.soapBaseUrl=https://secure-iparapheur-4-7-10.recette.libriciel.org
```

### @fixme

```
* What went wrong:
Execution failed for task ':test'.
> Multiple build operations failed.
      Could not write XML test results for [features/001-ip4/business/Formats de signature/002_folders/ACTES - PAdES/Cachet serveur - PDF_avec_tags - repositionnement signature] ACTES - PAdES - Cachet serveur - PDF_avec_tags - repositionnement signature to file /home/cbuffin/Documents/gitlab.libriciel.fr/libriciel/pole-signature/i-Parapheur-v5/compose/build/test-results/test/TEST-#5bfeatures#2f001-ip4#2fbusiness#2fFormats#20de#20signature#2f002_folders#2fACTES#20-#20PAdES#2fCachet#20serveur#20-#20PDF_avec_tags#20-#20repositionnement#20signature#5d#20ACTES#20-#20PAdES#20-#20Cachet#20serveur#20-#20PDF_avec_tags#20-#20repositionnement#20signature.xml.
      Could not write XML test results for [features/001-ip4/business/Formats de signature/002_folders/ACTES - PAdES/Cachet serveur - PDF_sans_tags - repositionnement signature] ACTES - PAdES - Cachet serveur - PDF_sans_tags - repositionnement signature to file /home/cbuffin/Documents/gitlab.libriciel.fr/libriciel/pole-signature/i-Parapheur-v5/compose/build/test-results/test/TEST-#5bfeatures#2f001-ip4#2fbusiness#2fFormats#20de#20signature#2f002_folders#2fACTES#20-#20PAdES#2fCachet#20serveur#20-#20PDF_sans_tags#20-#20repositionnement#20signature#5d#20ACTES#20-#20PAdES#20-#20Cachet#20serveur#20-#20PDF_sans_tags#20-#20repositionnement#20signature.xml.
      Could not write XML test results for [features/001-ip4/business/Formats de signature/002_folders/ACTES - PAdES/Signature - PDF_avec_tags - repositionnement signature] ACTES - PAdES - Signature - PDF_avec_tags - repositionnement signature to file /home/cbuffin/Documents/gitlab.libriciel.fr/libriciel/pole-signature/i-Parapheur-v5/compose/build/test-results/test/TEST-#5bfeatures#2f001-ip4#2fbusiness#2fFormats#20de#20signature#2f002_folders#2fACTES#20-#20PAdES#2fSignature#20-#20PDF_avec_tags#20-#20repositionnement#20signature#5d#20ACTES#20-#20PAdES#20-#20Signature#20-#20PDF_avec_tags#20-#20repositionnement#20signature.xml.
      Could not write XML test results for [features/001-ip4/business/Formats de signature/002_folders/ACTES - PAdES/Signature - PDF_sans_tags - repositionnement signature] ACTES - PAdES - Signature - PDF_sans_tags - repositionnement signature to file /home/cbuffin/Documents/gitlab.libriciel.fr/libriciel/pole-signature/i-Parapheur-v5/compose/build/test-results/test/TEST-#5bfeatures#2f001-ip4#2fbusiness#2fFormats#20de#20signature#2f002_folders#2fACTES#20-#20PAdES#2fSignature#20-#20PDF_sans_tags#20-#20repositionnement#20signature#5d#20ACTES#20-#20PAdES#20-#20Signature#20-#20PDF_sans_tags#20-#20repositionnement#20signature.xml.
   > Could not write XML test results for [features/001-ip4/business/Formats de signature/002_folders/ACTES - PAdES/Cachet serveur - PDF_avec_tags - repositionnement signature] ACTES - PAdES - Cachet serveur - PDF_avec_tags - repositionnement signature to file /home/cbuffin/Documents/gitlab.libriciel.fr/libriciel/pole-signature/i-Parapheur-v5/compose/build/test-results/test/TEST-#5bfeatures#2f001-ip4#2fbusiness#2fFormats#20de#20signature#2f002_folders#2fACTES#20-#20PAdES#2fCachet#20serveur#20-#20PDF_avec_tags#20-#20repositionnement#20signature#5d#20ACTES#20-#20PAdES#20-#20Cachet#20serveur#20-#20PDF_avec_tags#20-#20repositionnement#20signature.xml.
   > Could not write XML test results for [features/001-ip4/business/Formats de signature/002_folders/ACTES - PAdES/Cachet serveur - PDF_sans_tags - repositionnement signature] ACTES - PAdES - Cachet serveur - PDF_sans_tags - repositionnement signature to file /home/cbuffin/Documents/gitlab.libriciel.fr/libriciel/pole-signature/i-Parapheur-v5/compose/build/test-results/test/TEST-#5bfeatures#2f001-ip4#2fbusiness#2fFormats#20de#20signature#2f002_folders#2fACTES#20-#20PAdES#2fCachet#20serveur#20-#20PDF_sans_tags#20-#20repositionnement#20signature#5d#20ACTES#20-#20PAdES#20-#20Cachet#20serveur#20-#20PDF_sans_tags#20-#20repositionnement#20signature.xml.
   > Could not write XML test results for [features/001-ip4/business/Formats de signature/002_folders/ACTES - PAdES/Signature - PDF_avec_tags - repositionnement signature] ACTES - PAdES - Signature - PDF_avec_tags - repositionnement signature to file /home/cbuffin/Documents/gitlab.libriciel.fr/libriciel/pole-signature/i-Parapheur-v5/compose/build/test-results/test/TEST-#5bfeatures#2f001-ip4#2fbusiness#2fFormats#20de#20signature#2f002_folders#2fACTES#20-#20PAdES#2fSignature#20-#20PDF_avec_tags#20-#20repositionnement#20signature#5d#20ACTES#20-#20PAdES#20-#20Signature#20-#20PDF_avec_tags#20-#20repositionnement#20signature.xml.
   > Could not write XML test results for [features/001-ip4/business/Formats de signature/002_folders/ACTES - PAdES/Signature - PDF_sans_tags - repositionnement signature] ACTES - PAdES - Signature - PDF_sans_tags - repositionnement signature to file /home/cbuffin/Documents/gitlab.libriciel.fr/libriciel/pole-signature/i-Parapheur-v5/compose/build/test-results/test/TEST-#5bfeatures#2f001-ip4#2fbusiness#2fFormats#20de#20signature#2f002_folders#2fACTES#20-#20PAdES#2fSignature#20-#20PDF_sans_tags#20-#20repositionnement#20signature#5d#20ACTES#20-#20PAdES#20-#20Signature#20-#20PDF_sans_tags#20-#20repositionnement#20signature.xml.
```

### @todo

- SOAP getDossier (sans paramètre, seul moyen de récupérer la primo-signature)
- `conf/alfresco-global.properties`
  - `parapheur.document.openxml.accept=true`
  - `parapheur.filename.signature.detachee=%d-%o-%50s`

## Lancement des tests

### Forme générale

```bash
./gradlew test \
  --info \
  -Dkarate.options="--tags @legacy-bridge --tags @tests --tags ~@fixme-tests"
```

Tests les plus basiques uniquement :
```bash
./gradlew test --info -Dkarate.options="--tags @basic" -Dkarate.headless=true
```


#### Lancement des tests sur IP 4

Attention, il faudra faire le ménage après et supprimer tous les dossiers nommés `SOAP` ("Rechercher par titre", dans la recherche de dossiers partie administrateur).

```bash
./gradlew test \
  --info \
  -Dkarate.options="--tags @legacy-bridge --tags @tests --tags ~@fixme-tests" \
  -Dkarate.soapBaseUrl=https://secure-iparapheur47.test.libriciel.fr
```

#### Arguments de la ligne de commande

| Argument               | Obligatoire | Valeur par défaut                |
| ---                    | ---         | ---                              |
| `-Dkarate.baseUrl`     | -           | `http://iparapheur.dom.local/`   |
| `-Dkarate.soapBaseUrl` | -           | Même valeur que `karate.baseUrl` |
| `-Dkarate.chromeBin`   | -           | `/usr/bin/chromium-browser`      |
| `-Dkarate.headless`    | -           | `true`                           |
| `-Dkarate.options`     | Oui         | -                                |

#### _Tags_

| Usage                            | `-Dkarate.options`                                   | Dossier ou fichier                                                                  |
| ---                              | ---                                                  | ---                                                                                 |
| Intégration continue             | `--tags @legacy-bridge`                              | `src/test/resources/features/004_legacy-bridge/SOAP`                                |
| Paramétrage                      | `--tags @legacy-bridge --tags @setup`                | `src/test/resources/features/004_legacy-bridge/SOAP/001_setup/001_setup.feature`    |
| Création de dossiers             | `--tags @legacy-bridge --tags @folder`               | `src/test/resources/features/004_legacy-bridge/SOAP/001_setup/002_folders.feature ` |
| Traitement des dossiers via l'UI | `--tags @legacy-bridge --tags @folder-ui-processing` | `src/test/resources/features/004_legacy-bridge/SOAP/001_setup/003_ui.feature`       |
| Lancement des tests              | `--tags @legacy-bridge --tags @tests`                | `src/test/resources/features/004_legacy-bridge/SOAP/002_tests`                      |
| Tout sauf les tests              | `--tags @legacy-bridge --tags ~@tests`               | `src/test/resources/features/004_legacy-bridge/SOAP/002_tests`                      |

## Démo BDE

### [Scénario original](https://lsoffice.libriciel.fr/pad/#/2/pad/edit/7luyoZ1VSHfCwGkVYwqWtSEU/)

- [Comparatif du scénario sur plusieurs beta](https://lsoffice.libriciel.fr/sheet/#/2/sheet/view/gpOCRl+pGFDsfLs8K4h8laRKd0M3-ySbXnkvbHbC7Ok/)

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
