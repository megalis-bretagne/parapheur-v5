# Karate

## @fixme

- [x] pageSize -> size
- [x] page -> page
- [ ] asc et sortBy => sort["name,ASC", "id,DESC"...]

## @todo

- [x] que la création avec les métadonnées ? à scripter alors... (autre issue)
- voir https://gitlab.libriciel.fr/libriciel/pole-signature/i-Parapheur-v5/i-Parapheur/ip-web/-/issues/270

## WIP

```bash
# IP 4
# Augmenter les 3G -> 6G ?
# docker-compose down --volumes --remove-orphans && sudo rm -rf ./data && docker-compose up
# parapheur-core_1     | 07-Sep-2022 12:17:37.676 INFO [main] org.apache.catalina.startup.Catalina.start Server startup in [165085] milliseconds
./gradlew test --info -Dkarate.options="--tags @wip" -Dkarate.headless=true -Dkarate.baseUrl=https://ip4.dom.local/

./gradlew test --info -Dkarate.options="--tags @legacy-bridge --tags @ip4 --tags ~@setup" -Dkarate.headless=true  -Dkarate.baseUrl=https://iparapheur47.test.libriciel.fr -Dkarate.soapBaseUrl=https://secure-iparapheur47.test.libriciel.fr
# IP 5@20220803 - 40m 5s - 610 tests completed, 106 failed
./gradlew test --info -Dkarate.options="--tags @demo-simple-bde,@formats-de-signature,@legacy-bridge --tags ~@ignore --tags ~@ip4" -Dkarate.headless=true

# IP 5@20220809 - 26m 31s - 84 tests completed, 12 failed
./gradlew test --info -Dkarate.options="--tags @demo-simple-bde --tags ~@ignore --tags ~@ip4" -Dkarate.headless=true
# IP 5@20220809 - 9m 48s - 482 tests completed, 65 failed
./gradlew test --info -Dkarate.options="--tags @formats-de-signature --tags ~@ignore --tags ~@ip4" -Dkarate.headless=true
# IP 5@20220809 - 5m 38s - 101 tests completed, 7 failed
./gradlew test --info -Dkarate.options="--tags @legacy-bridge --tags ~@ignore --tags ~@ip4" -Dkarate.headless=true
# IP 5@20220809 - 42m 13s - 654 tests completed, 82 failed
./gradlew test --info -Dkarate.options="--tags @demo-simple-bde,@formats-de-signature,@legacy-bridge --tags ~@ignore --tags ~@ip4" -Dkarate.headless=true
```

---

## Nouveau contenu de l'_issue_

- [x] signature des dossiers via karate (IP4, IP5)
- [ ] circuit complet pour les dossiers monodoc (entité "Formats de signature")
  - [x] création et envoi de dossiers
  - [x] signature / cachet
  - [x] récupération de l'ensemble des fichiers du dossier
  - [x] vérifications sur ces fichiers
    - [x] liste des fichiers attendus
    - [x] verification que certains fichiers n'ont pas été modifiés (primo-signatures, fichiers signés CAdES/XAdES)
    - [ ] vérification des signatures (et cachets serveur pour le format PAdES) des documents, avec un utilisateur "normal" et un utilisateur "surchargé"
      - [x] Automatique (suivant la configuration par défaut, vérification des formats attendus)
      - [x] CAdES - validité des signatures
      - [x] HELIOS - XAdES enveloppé
        - [x] validité vis-à-vis du schéma XML
        - [x] validité des signatures (adaptation du code de S2LOW)
        - [x] vérification du contenu des champs `City`, `PostalCode`, `CountryName`, `ClaimedRole` (avec un utilisateur "normal" et un utilisateur "surchargé")
      - [x] PAdES
        - [x] validité des signatures
        - [x] détails des signatures ("Signé par"/"Certifié par", "Motif" et "Lieu")
        - [x] grigris de signature (position, images et texte)
      - [ ] XAdES détaché
        - [x] validité vis-à-vis du schéma XML
        - [ ] validité des signatures
        - [x] vérification du contenu des champs `City`, `PostalCode`, `CountryName`, `ClaimedRole` (avec un utilisateur "normal" et un utilisateur "surchargé")
    - [x] l'ensemble des fichiers contenus dans les dossiers (hors annexes) sont disponibles dans le répertoire `build/ip5-folders`

## Liste des dossiers (monodoc)

- Automatique
  - Signature
    - PDF_avec_tags - repositionnement signature
    - PDF_avec_tags - signe_cades
    - PDF_avec_tags - signe_pades
    - PDF_avec_tags - signe_xades
    - PDF_avec_tags
    - PDF_sans_tags - repositionnement signature
    - PDF_sans_tags - signe_cades
    - PDF_sans_tags - signe_pades
    - PDF_sans_tags - signe_xades
    - PDF_sans_tags
    - RTF - signe_cades
    - RTF - signe_xades
    - RTF
- CAdES
  - Signature
    - PDF_avec_tags - signe_cades
    - PDF_avec_tags - signe_xades
    - PDF_avec_tags
    - PDF_sans_tags - signe_cades
    - PDF_sans_tags - signe_xades
    - PDF_sans_tags
    - RTF - signe_cades
    - RTF - signe_xades
    - RTF
- HELIOS - XAdES env
  - Signature
    - XML (ISO-8859-1, PJ PDF incluses)
    - XML (UTF-8)
- PAdES
  - Cachet serveur
    - PDF_avec_tags - repositionnement signature
    - PDF_avec_tags - signe_pades
    - PDF_avec_tags
    - PDF_sans_tags - repositionnement signature
    - PDF_sans_tags - signe_pades
    - PDF_sans_tags
  - Signature
    - PDF_avec_tags
    - PDF_avec_tags
    - PDF_avec_tags - repositionnement signature
    - PDF_avec_tags-signature_pades
    - PDF_avec_tags
    - PDF_sans_tags - repositionnement signature
    - PDF_sans_tags-signature_pades - signe_pades
    - PDF_sans_tags
- XAdES det
  - Signature
    - PDF_avec_tags - signe_cades
    - PDF_avec_tags - signe_xades
    - PDF_avec_tags
    - PDF_sans_tags - signe_cades
    - PDF_sans_tags - signe_xades
    - PDF_sans_tags
    - RTF - signe_cades
    - RTF - signe_xades
    - RTF

---

@see src/test/resources/features/999_business/998_Formats de signature/002_folders/XAdES det/001 - Signature - RTF.feature

// sudo snap install xmlstarlet
// @todo
//  /SignedInfo
// @see https://opensource.com/article/21/4/encryption-decryption-openssl
// openssl rsa -in "${privateKey}" -pubout > /home/cbuffin/test.pem
// @see https://stackoverflow.com/questions/32757454/how-to-compute-the-digest-for-the-signedproperties-of-a-xades-signature
// xml c14n --exc-with-comments /home/cbuffin/_20220804/foo.xml

```bash
openssl dgst -binary -sha256 bar.xml | openssl enc -base64
openssl dgst -binary -sha512 /home/cbuffin/Documents/gitlab.libriciel.fr/libriciel/pole-signature/i-Parapheur-v5/compose/src/test/resources/files/certificates/signature/public.pem | openssl enc -base64
```

- https://pypi.org/project/pyasice/
- https://pypi.org/project/signxml/

```bash
# https://serverfault.com/a/1106205
```

```bash
#https://serverfault.com/a/515842 (non)
p12="certificate.p12"
p12_new="certificate-nopass.p12"
public="public.crt"
combined="combined.pem"
private="private.key"
ca="ca-cert.ca"
private_new="private-nopass.key"
PASSWORD="christian.buffin@libriciel.coop"
openssl pkcs12 -clcerts -nokeys -in "${p12}" -out "${public}" -password pass:$PASSWORD -passin pass:$PASSWORD
openssl pkcs12 -cacerts -nokeys -in "${p12}" -out "${ca}" -password pass:$PASSWORD -passin pass:$PASSWORD
openssl pkcs12 -nocerts -in "${p12}" -out "${private}" -password pass:$PASSWORD -passin pass:$PASSWORD -passout pass:$PASSWORD
openssl rsa -in "${private}" -out "${private_new}" -passin pass:$PASSWORD
cat "${private_new}" "${public}" "${ca}" > "${combined}"
openssl pkcs12 -export -nodes -CAfile "${ca}" -in "${combined}" -out "${p12_new}"

openssl pkcs12 -in "certificate.p12" -nodes -out temp.pem
openssl pkcs12 -export -in temp.pem  -out "certificate-unprotected.p12"
```

### Vérification des dossiers en fin de circuit

- [ ] Généralités
  - [x] liste des documents et signatures détachées contenus dans le dossier
  - [ ] liste des annexes éventuelles
  - [x] monodoc
  - [ ] multidoc
- [ ] Par format
  - [ ] Automatique (voir ci-dessous)
  - [x] CAdES
    - [x] document original
    - [x] primo-signature
    - [x] jeton de signature
  - [ ] HELIOS - XAdES env
    - [x] validation xsd
    - [x] informations du signataire
    - [ ] validation des signatures intégrées
    - [ ] validation du certificat intégré
  - [ ] PAdES
    - [x] signatures électroniques  
    - [x] propriétés des signatures électroniques  
    - [x] position du grigri
    - [x] texte du grigri (annotations)
    - [ ] image du grigri
  - [ ] XAdES det
    - [ ] validation xsd
    - [ ] informations du signataire
    - [ ] validation des signatures intégrées
    - [ ] validation du certificat intégré

#### Vérification des signatures XAdES détachées

```
# @todo; pige pas DigestValue: sha256sum ../document_rtf.rtf | sed "s/ .*$//g" | python -m base64 -e
# @info: 20220727 ->
# @todo: vérifier le jeton xml....
# @see https://github.com/esig/dss
# @see https://github.com/thorgate/pyasice/tree/main/pyasice
# @see https://github.com/Good-Samaritan/signature-demo
# @see https://github.com/m32/endesive/blob/master/examples/xml-xmlsigner-verify.py
# @see https://www.w3.org/Signature/2001/04/05-xmldsig-interop.html
# @see https://githubhelp.com/PeculiarVentures/xmldsigjs
# @see https://cknotes.com/online-xml-digital-signature-validators/
# @see ++ http://tools.chilkat.io/xmlDsigVerify.cshtml#generatedCode
# https://www.chilkatsoft.com/chilkat2-python.asp#linuxDownloads
# @see ++ https://support.kemptechnologies.com/hc/en-us/articles/217970743-Verifying-XML-Signatures
# Non
# sudo apt install libdigidoc-tools

# Non
# sudo apt install xmlsec1
# xmlsec1 --verify --trusted-pem root_ca.pem --untrusted-pem intermediate_ca_1.pem --untrusted-pem intermediate_ca_2.pem sample-signed.xml
# xmlsec1 --verify  sample-signed.xml

https://github.com/XML-Security/signxml
  sudo pip3 install setuptools-rust
  sudo pip3 install --upgrade pip
https://stackoverflow.com/questions/71293125/xades-xml-sign-policy
```

### IP 5

```bash
# Seulement les tests passants, pour l'intégration continue (26m 57s, scenarios/passed:  121)
./gradlew test --info -Dkarate.options="--tags @demo-simple-bde,@legacy-bridge --tags ~@fixme-ip" -Dkarate.headless=true
# Tests passants et non passants, pour l'intégration continue (31m 49s, scenarios: 144 total, 122 passed, 22 failed  )
./gradlew test --info -Dkarate.options="--tags @demo-simple-bde,@legacy-bridge --tags ~@ip4" -Dkarate.headless=true
```

### IP 4

```bash
# Seulement les tests passants (1m 17s, scenarios/passed:  34)
./gradlew test --info -Dkarate.options="--tags @legacy-bridge --tags @tests --tags ~@fixme-ip" -Dkarate.headless=true -Dkarate.soapBaseUrl=https://secure-iparapheur47.test.libriciel.fr
```

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
  -Dkarate.options="--tags @legacy-bridge --tags @tests --tags ~@fixme-tests"
```

##### Lancement des tests sur IP 4

Attention, il faudra faire le ménage après et supprimer tous les dossiers nommés `SOAP` ("Rechercher par titre", dans la recherche de dossiers partie administrateur).

```bash
./gradlew test \
  --info \
  -Dkarate.options="--tags @legacy-bridge --tags @tests --tags ~@fixme-tests" \
  -Dkarate.soapBaseUrl=https://secure-iparapheur47.test.libriciel.fr
```

##### Arguments de la ligne de commande

| Argument               | Obligatoire | Valeur par défaut                |
| ---                    | ---         | ---                              |
| `-Dkarate.baseUrl`     | -           | `http://iparapheur.dom.local/`   |
| `-Dkarate.soapBaseUrl` | -           | Même valeur que `karate.baseUrl` |
| `-Dkarate.chromeBin`   | -           | `/usr/bin/chromium-browser`      |
| `-Dkarate.headless`    | -           | `true`                           |
| `-Dkarate.options`     | Oui         | -                                |

##### _Tags_

| Usage                            | `-Dkarate.options`                                   | Dossier ou fichier                                                                  |
| ---                              | ---                                                  | ---                                                                                 |
| Intégration continue             | `--tags @legacy-bridge`                              | `src/test/resources/features/004_legacy-bridge/SOAP`                                |
| Paramétrage                      | `--tags @legacy-bridge --tags @setup`                | `src/test/resources/features/004_legacy-bridge/SOAP/001_setup/001_setup.feature`    |
| Création de dossiers             | `--tags @legacy-bridge --tags @folder`               | `src/test/resources/features/004_legacy-bridge/SOAP/001_setup/002_folders.feature ` |
| Traitement des dossiers via l'UI | `--tags @legacy-bridge --tags @folder-ui-processing` | `src/test/resources/features/004_legacy-bridge/SOAP/001_setup/003_ui.feature`       |
| Lancement des tests              | `--tags @legacy-bridge --tags @tests`                | `src/test/resources/features/004_legacy-bridge/SOAP/002_tests`                      |
| Tout sauf les tests              | `--tags @legacy-bridge --tags ~@tests`               | `src/test/resources/features/004_legacy-bridge/SOAP/002_tests`                      |

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
- [ ] il faudrait aussi tester la suppression à la fin du scénario (entité chargée)
