# GUIDE D'INSTALLATION DES LOGICIELS
# SOFTWARE INSTALLATION GUIDE

## Épidémiologie Clinique - Outils Statistiques

---

## 1. R ET RSTUDIO

### 1.1 Installation de R

#### Windows
1. Aller sur https://cran.r-project.org/
2. Télécharger "Download R for Windows"
3. Exécuter l'installeur (.exe)
4. Suivre les instructions par défaut

#### macOS
1. Aller sur https://cran.r-project.org/
2. Télécharger "Download R for macOS"
3. Ouvrir le fichier .pkg et suivre l'assistant

#### Linux (Ubuntu/Debian)
```bash
# Ajouter le dépôt CRAN
sudo apt update
sudo apt install r-base r-base-dev
```

### 1.2 Installation de RStudio

1. Aller sur https://posit.co/download/rstudio-desktop/
2. Télécharger la version appropriée
3. Installer comme un logiciel standard

### 1.3 Configuration de RStudio

#### Thème et apparence
- Tools → Global Options → Appearance
- Choisir un thème sombre (e.g., "Modern" ou "Cobalt")

#### Packages essentiels
```r
# Installation des packages de base
install.packages(c(
  "tidyverse",    # Manipulation des données
  "ggplot2",      # Visualisation
  "dplyr",        # Manipulation
  "readr",        # Import de données
  "lubridate",    # Dates
  "stringr",      # Chaînes de caractères
  "forcats"       # Facteurs
))

# Packages pour analyses statistiques
install.packages(c(
  "survival",     # Analyse de survie
  "epitools",     # Outils épidémiologiques
  "meta",         # Méta-analyses
  "pROC",         # Courbes ROC
  "caret",        # Machine learning
  "rstatix",      # Tests statistiques
  "ggpubr",       # Graphiques publication
  "forestplot",   # Graphiques forest
  "tableone"      # Tableaux descriptifs
))

# Packages pour rapports
install.packages(c(
  "rmarkdown",    # Rapports R Markdown
  "knitr",        # Intégration LaTeX
  "kableExtra",   # Tableaux améliorés
  "officer",      # Documents Word
  "openxlsx"      # Excel
))
```

#### Configuration du répertoire de travail
```r
# Créer un répertoire de travail
setwd("~/Documents/epidemiology_project")

# Vérifier les packages installés
installed.packages()
```

---

## 2. PYTHON

### 2.1 Installation d'Anaconda (Recommandé)

#### Téléchargement
1. Aller sur https://www.anaconda.com/products/distribution
2. Télécharger Anaconda (pas Miniconda)
3. Installer en suivant les instructions

#### Vérification
```bash
# Ouvrir Anaconda Prompt (Windows) ou Terminal (macOS/Linux)
conda --version
python --version
```

### 2.2 Environnements virtuels

#### Créer un environnement pour l'épidémiologie
```bash
# Créer environnement
conda create -n epi_env python=3.9

# Activer environnement
conda activate epi_env

# Installer packages de base
conda install numpy pandas matplotlib seaborn jupyter
```

#### Packages spécialisés
```bash
# Statistiques et sciences des données
pip install scipy statsmodels scikit-learn

# Épidémiologie spécifique
pip install lifelines  # Analyse de survie
pip install statsmodels  # Modèles statistiques
pip install pingouin  # Tests statistiques
pip install plotnine  # ggplot2 pour Python

# Machine learning
pip install xgboost lightgbm

# Rapports et visualisation
pip install jupyter-book plotly dash
```

### 2.3 Configuration de Jupyter

#### Extensions utiles
```bash
# Installation des extensions
pip install jupyter_contrib_nbextensions
jupyter contrib nbextension install --user

# Extension pour table des matières
pip install jupyter_nbextensions_configurator
jupyter nbextensions_configurator enable --user
```

#### Noyau R dans Jupyter
```bash
# Installer r-irkernel
# Dans R:
install.packages('IRkernel')
IRkernel::installspec()
```

---

## 3. SAS

### 3.1 SAS University Edition (Gratuit)

#### Installation
1. Aller sur https://www.sas.com/en_us/software/university-edition.html
2. S'inscrire (gratuit pour étudiants/chercheurs)
3. Télécharger et installer VirtualBox si nécessaire
4. Importer l'image SAS UE

#### Configuration
- Interface web: http://localhost:10080
- Utilisateur par défaut: `sasdemo`
- Mot de passe: `sasdemo`

### 3.2 SAS OnDemand for Academics

#### Accès
1. Aller sur https://welcome.oda.sas.com/
2. Créer un compte académique
3. Accès via interface web

### 3.3 Configuration de base
```sas
/* Configuration initiale */
options nodate nonumber;

/* Librairies */
libname mydata '/folders/myfolders/data';

/* Formats utiles pour épidémiologie */
proc format;
  value sexe
    1 = "Homme"
    2 = "Femme";
  value oui_non
    0 = "Non"
    1 = "Oui";
run;
```

---

## 4. SPSS

### 4.1 Installation

#### Version commerciale
1. Acheter/acquérir licence SPSS
2. Télécharger depuis IBM site
3. Installer normalement

#### Alternatives gratuites
- **PSPP**: clone open-source de SPSS
  ```bash
  # Ubuntu/Debian
  sudo apt install pspp

  # macOS
  brew install pspp
  ```

### 4.2 Configuration initiale

#### Préférences
- Edit → Options
- General: définir répertoire de données par défaut
- Output: format des tableaux
- Charts: styles par défaut

#### Syntaxe utile
```spss
/* Configuration */
SET PRINTBACK=ON.
SET MXLOOPS=10000.

/* Formats de variables */
VALUE LABELS sexe
  1 "Homme"
  2 "Femme".

VALUE LABELS diabete
  0 "Non diabétique"
  1 "Diabétique".
```

---

## 5. STATA

### 5.1 Installation

#### Stata IC/MP/SE
1. Acquérir licence Stata
2. Télécharger depuis https://www.stata.com
3. Installer normalement

### 5.2 Configuration

#### Profile do-file
```stata
/* Créer un fichier profile.do dans le répertoire Stata */

* Configuration générale
set more off
set linesize 120
set logtype text

* Formats de date
set dp comma, permanently

* Mémoire
set max_memory 1g

* Graphiques
set scheme s1color
```

#### Packages utiles
```stata
* Installation de packages communautaires
ssc install estout     /* Export de résultats */
ssc install outreg2    /* Tableaux de régression */
ssc install table1     /* Tableaux descriptifs */
ssc install coefplot   /* Graphiques de coefficients */
```

---

## 6. LOGICIELS COMPLÉMENTAIRES

### 6.1 Git et GitHub

#### Installation
```bash
# Windows: télécharger depuis https://git-scm.com/
# macOS: xcode-select --install
# Linux: sudo apt install git

# Configuration
git config --global user.name "Votre Nom"
git config --global user.email "votre.email@exemple.com"
```

#### Configuration pour recherche
```bash
# Créer .gitignore pour projets R
echo "*.Rhistory
*.RData
.Rproj.user/
*.tmp" > .gitignore
```

### 6.2 LaTeX (pour rapports)

#### Windows
1. Installer MiKTeX: https://miktex.org/
2. Ou TeX Live: https://tug.org/texlive/

#### macOS
```bash
brew install mactex
```

#### Linux
```bash
sudo apt install texlive-full
```

### 6.3 Éditeurs de code

#### VS Code (Recommandé)
1. Télécharger depuis https://code.visualstudio.com/
2. Extensions essentielles:
   - R (pour R)
   - Python (pour Python)
   - LaTeX Workshop (pour LaTeX)
   - GitLens (pour Git)

#### Configuration VS Code pour R
```json
// settings.json
{
    "r.rterm.windows": "C:\\Program Files\\R\\R-4.x.x\\bin\\R.exe",
    "r.rterm.mac": "/usr/local/bin/R",
    "r.rterm.linux": "/usr/bin/R",
    "r.bracketedPaste": true
}
```

---

## 7. CONFIGURATION ENVIRONNEMENT DE TRAVAIL

### 7.1 Structure de projet standard

```
/project_root/
├── data/
│   ├── raw/           # Données brutes
│   ├── processed/     # Données traitées
│   └── dictionaries/  # Dictionnaires des données
├── scripts/           # Scripts d'analyse
│   ├── descriptive/   # Analyses descriptives
│   ├── bivariate/     # Analyses bivariées
│   └── multivariate/  # Analyses multivariées
├── results/           # Résultats
│   ├── figures/       # Graphiques
│   ├── tables/        # Tableaux
│   └── outputs/       # Sorties d'analyse
├── docs/              # Documentation
└── reports/           # Rapports finaux
```

### 7.2 Répertoires par défaut

#### R
```r
# Créer répertoire par défaut
dir.create("~/Documents/epidemiology_projects", showWarnings = FALSE)

# Fonction pour initialiser nouveau projet
init_project <- function(project_name) {
  project_path <- file.path("~/Documents/epidemiology_projects", project_name)

  # Créer structure
  dir.create(project_path)
  dir.create(file.path(project_path, "data", "raw"))
  dir.create(file.path(project_path, "data", "processed"))
  dir.create(file.path(project_path, "scripts"))
  dir.create(file.path(project_path, "results", "figures"))
  dir.create(file.path(project_path, "results", "tables"))

  # Créer fichier R principal
  writeLines(c(
    "# =======================================================",
    paste("# PROJET:", project_name),
    "# =======================================================",
    "",
    "# Chargement des packages",
    "library(tidyverse)",
    "library(ggplot2)",
    "",
    "# Configuration",
    paste0("setwd('", project_path, "')"),
    "",
    "# Analyse principale",
    "# [Votre code ici]"
  ), file.path(project_path, "main_analysis.R"))

  message("Projet initialisé dans: ", project_path)
}
```

#### Python
```python
# Structure de projet Python
import os
from pathlib import Path

def create_project_structure(project_name):
    """
    Crée la structure de base pour un projet d'épidémiologie
    """
    base_path = Path.home() / "epidemiology_projects" / project_name

    # Créer les dossiers
    directories = [
        base_path,
        base_path / "data" / "raw",
        base_path / "data" / "processed",
        base_path / "scripts",
        base_path / "results" / "figures",
        base_path / "results" / "tables",
        base_path / "notebooks"
    ]

    for directory in directories:
        directory.mkdir(parents=True, exist_ok=True)

    # Créer fichiers de base
    create_main_notebook(base_path, project_name)
    create_requirements_file(base_path)

    print(f"Projet créé dans: {base_path}")

def create_main_notebook(base_path, project_name):
    """Crée le notebook Jupyter principal"""
    notebook_content = f'''{{
 "cells": [
  {{
   "cell_type": "markdown",
   "metadata": {{}},
   "source": [
    "# Analyse Épidémiologique\\n",
    "## {project_name}\\n",
    "---\\n",
    "Date: {{}}\\n".format(pd.Timestamp.today().strftime('%Y-%m-%d'))
   ]
  }},
  {{
   "cell_type": "code",
   "execution_count": null,
   "metadata": {{}},
   "outputs": [],
   "source": [
    "# Configuration et imports\\n",
    "import pandas as pd\\n",
    "import numpy as np\\n",
    "import matplotlib.pyplot as plt\\n",
    "import seaborn as sns\\n",
    "from scipy import stats\\n",
    "import statsmodels.api as sm\\n",
    "\\n",
    "# Configuration\\n",
    "plt.style.use('seaborn')\\n",
    "sns.set_palette('husl')\\n",
    "\\n",
    "# Chargement des données\\n",
    "# data = pd.read_csv('data/raw/donnees.csv')\\n",
    "print('Environnement configuré')"
   ]
  }}
 ],
 "metadata": {{
  "kernelspec": {{
   "display_name": "Python 3",
   "language": "python",
   "name": "python3"
  }}
 }},
 "nbformat": 4,
 "nbformat_minor": 4
}}'''

    with open(base_path / "notebooks" / "main_analysis.ipynb", 'w', encoding='utf-8') as f:
        f.write(notebook_content)

def create_requirements_file(base_path):
    """Crée le fichier requirements.txt"""
    requirements = '''pandas>=1.3.0
numpy>=1.21.0
matplotlib>=3.4.0
seaborn>=0.11.0
scipy>=1.7.0
statsmodels>=0.12.0
scikit-learn>=1.0.0
jupyter>=1.0.0
lifelines>=0.26.0
plotly>=5.0.0'''

    with open(base_path / "requirements.txt", 'w') as f:
        f.write(requirements)
```

---

## 8. DÉPANNAGE COURANT

### 8.1 Problèmes R

#### Package qui ne s'installe pas
```r
# Installer depuis CRAN alternatif
install.packages("nom_package", repos = "https://cloud.r-project.org/")

# Ou installer depuis source
install.packages("nom_package", type = "source")
```

#### Mémoire insuffisante
```r
# Augmenter la mémoire
memory.limit(size = 8000)  # Windows
```

### 8.2 Problèmes Python

#### Environnements conda
```bash
# Lister environnements
conda env list

# Supprimer environnement corrompu
conda env remove -n nom_environnement

# Recréer environnement
conda create -n nouveau_env python=3.9
conda activate nouveau_env
pip install -r requirements.txt
```

#### Packages conflictuels
```bash
# Utiliser mamba (plus rapide que conda)
conda install mamba
mamba install nom_package
```

### 8.3 Problèmes généraux

#### Encodage de fichiers
- Sauvegarder en UTF-8
- Éviter les caractères spéciaux dans les noms de fichiers
- Utiliser des noms en anglais pour les variables

#### Versions de packages
- Documenter les versions utilisées
- Utiliser `sessionInfo()` en R
- Utiliser `pip freeze` en Python

---

## 9. RESSOURCES D'APPRENTISSAGE

### Documentation officielle
- **R**: https://cran.r-project.org/manuals.html
- **Python**: https://docs.python.org/3/
- **SAS**: https://documentation.sas.com/
- **SPSS**: https://www.ibm.com/support/pages/spss-documentation
- **Stata**: https://www.stata.com/manuals/

### Tutoriels spécialisés épidémiologie
- **R pour épidémiologie**: https://www.r-bloggers.com/tag/epidemiology/
- **Python en santé**: https://pythonhealthcare.org/
- **Cours Coursera**: "Epidemiology in Public Health Practice"

### Communautés
- **Stack Overflow**: recherche de solutions
- **Cross Validated**: questions statistiques
- **RStudio Community**: aide pour R
- **PyData**: communauté Python

---

*Ce guide est régulièrement mis à jour. Vérifiez les dernières versions des logiciels avant installation.*