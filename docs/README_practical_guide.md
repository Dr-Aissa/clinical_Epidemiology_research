# GUIDE PRATIQUE - ÉPIDÉMIOLOGIE CLINIQUE
# PRACTICAL GUIDE - CLINICAL EPIDEMIOLOGY

---

## 🚀 Démarrage rapide / Quick Start

Ce guide vous explique comment utiliser immédiatement toutes les ressources de ce projet pour vos analyses épidémiologiques.

---

## 📁 Structure du projet

```
clinical_epidemiology_research/
├── data/                          # Jeux de données
│   ├── raw/                      # Données brutes
│   │   └── sample_clinical_data.csv
│   ├── processed/                # Données traitées
│   └── dictionaries/             # Dictionnaires des variables
├── scripts/                      # Scripts d'analyse
│   ├── descriptive/              # Analyses descriptives
│   ├── bivariate/                # Analyses bivariées
│   └── multivariate/             # Analyses multivariées
│   └── python_analysis.py        # Analyses Python
├── docs/                         # Documentation
│   ├── templates/                # Modèles
│   ├── methods/                  # Guides méthodologiques
│   ├── tools/                    # Guides d'installation
│   └── case_studies/             # Études de cas
├── results/                      # Résultats
│   ├── figures/                  # Graphiques
│   ├── tables/                   # Tableaux
│   └── outputs/                  # Fichiers de sortie
└── index.html                    # Site web principal
```

---

## 🛠️ Installation et configuration

### Option 1: Utiliser directement les scripts R

1. **Installer R et RStudio**
   - Téléchargez R depuis https://cran.r-project.org/
   - Téléchargez RStudio depuis https://posit.co/download/rstudio-desktop/

2. **Ouvrir un script**
   ```r
   # Par exemple, ouvrez scripts/descriptive/descriptive_analysis.R
   # Cliquez sur "Source" ou Ctrl+Enter pour exécuter
   ```

3. **Les packages nécessaires s'installeront automatiquement**

### Option 2: Utiliser Python

1. **Installer Anaconda**
   ```bash
   # Téléchargez depuis https://www.anaconda.com/products/distribution
   # Ou utilisez miniconda pour une installation légère
   ```

2. **Créer un environnement**
   ```bash
   conda create -n epi_env python=3.9
   conda activate epi_env
   pip install -r requirements.txt  # Si créé
   ```

3. **Lancer l'analyse**
   ```bash
   python scripts/python_analysis.py
   ```

---

## 📊 Analyses pas à pas

### Étape 1: Explorer les données

**Avec R:**
```r
# Charger les données
data <- read.csv("data/raw/sample_clinical_data.csv")

# Aperçu rapide
head(data)
summary(data)

# Structure des données
str(data)
```

**Avec Python:**
```python
import pandas as pd

# Charger les données
data = pd.read_csv("data/raw/sample_clinical_data.csv")

# Aperçu rapide
print(data.head())
print(data.describe())
print(data.info())
```

### Étape 2: Analyse descriptive

**Script R automatisé:**
```r
# Ouvrez et exécutez scripts/descriptive/descriptive_analysis.R
source("scripts/descriptive/descriptive_analysis.R")
analyse_complete()
```

**Script Python automatisé:**
```python
# Exécutez scripts/python_analysis.py
# La fonction descriptive_analysis() sera appelée automatiquement
```

### Étape 3: Analyses statistiques

**Analyses bivariées (R):**
```r
source("scripts/bivariate/bivariate_analysis.R")
analyse_bivariee_complete()
```

**Analyses multivariées (R):**
```r
source("scripts/multivariate/multivariate_analysis.R")
# Les fonctions sont disponibles dans le script
```

### Étape 4: Créer des rapports

**Avec R Markdown:**
1. Ouvrez `docs/templates/analysis_report_template.Rmd`
2. Cliquez sur "Knit" dans RStudio
3. Un rapport HTML sera généré

**Avec Jupyter Notebook (Python):**
```bash
jupyter notebook
# Créez un nouveau notebook et importez python_analysis.py
```

---

## 🎯 Études de cas pratiques

### Cas 1: Diabète et risque cardiovasculaire

**Fichiers associés:**
- Données: `data/raw/sample_clinical_data.csv`
- Analyse: `docs/case_studies/case_study_1.md`
- Script: À créer basé sur l'exemple

**Objectif:** Identifier les facteurs de risque CV chez les diabétiques

**Variables clés:**
- Outcome: `evenement_cv` (événements cardiovasculaires)
- Prédicteurs: `hba1c`, `hypertension`, `age`, `fumeur`

**Analyse recommandée:**
```r
# Modèle de régression logistique
model <- glm(evenement_cv ~ hba1c + hypertension + age + fumeur,
             data = data, family = binomial)
summary(model)
```

---

## 📋 Utiliser les templates

### 1. Créer un protocole d'étude

1. Copiez `docs/templates/study_protocol_template.md`
2. Remplacez les sections [entre crochets] par vos informations
3. Sauvegardez sous un nouveau nom

### 2. Créer un CRF (Case Report Form)

1. Utilisez `docs/templates/crf_template_example.md` comme base
2. Adaptez les variables à votre étude
3. Convertissez en Excel pour la saisie des données

### 3. Générer un rapport d'analyse

1. Copiez `docs/templates/analysis_report_template.Rmd`
2. Modifiez les chemins vers vos données
3. Ajustez les analyses selon vos besoins
4. Générez le rapport HTML/PDF

---

## 🔧 Dépannage courant

### Problème: Package R non disponible
```r
# Installer depuis CRAN
install.packages("nom_du_package")

# Ou depuis GitHub si nécessaire
devtools::install_github("username/repo")
```

### Problème: Mémoire insuffisante
```r
# R: Augmenter la mémoire
memory.limit(size = 8000)  # 8GB

# Python: Utiliser des chunks
for chunk in pd.read_csv(file, chunksize=1000):
    # Traiter par morceaux
```

### Problème: Encodage des caractères
```r
# R: Spécifier l'encodage
data <- read.csv("fichier.csv", encoding = "UTF-8")

# Python: Spécifier l'encodage
data = pd.read_csv("fichier.csv", encoding = "utf-8")
```

---

## 📈 Visualisations et graphiques

### Graphiques R (ggplot2)
```r
library(ggplot2)

# Histogramme
ggplot(data, aes(x = age)) +
  geom_histogram(binwidth = 5, fill = "#667eea") +
  labs(title = "Distribution de l'âge")

# Boxplot
ggplot(data, aes(x = groupe_traitement, y = hba1c)) +
  geom_boxplot(fill = "#667eea") +
  labs(title = "HbA1c par groupe")
```

### Graphiques Python (matplotlib/seaborn)
```python
import matplotlib.pyplot as plt
import seaborn as sns

# Histogramme
plt.figure(figsize=(10, 6))
sns.histplot(data=data, x='age', bins=20)
plt.title('Distribution de l\'âge')
plt.show()

# Boxplot
plt.figure(figsize=(10, 6))
sns.boxplot(data=data, x='groupe_traitement', y='hba1c')
plt.title('HbA1c par groupe')
plt.show()
```

---

## 🔗 Intégration avec d'autres outils

### Export vers Excel
```r
# R vers Excel
library(openxlsx)
write.xlsx(data, "resultats.xlsx")

# Python vers Excel
data.to_excel("resultats.xlsx", index=False)
```

### Export vers SPSS
```r
# Depuis R
library(foreign)
write.foreign(data, "data.txt", "data.sps", package="SPSS")
```

### Connexion à des bases de données
```r
# R: Connexion SQL
library(DBI)
library(RSQLite)
conn <- dbConnect(RSQLite::SQLite(), "database.db")

# Python: Connexion SQL
import sqlite3
conn = sqlite3.connect("database.db")
```

---

## 📚 Ressources d'apprentissage

### Cours en ligne gratuits
- [Epidemiology in Public Health Practice](https://www.coursera.org/learn/epidemiology-public-health) - Coursera
- [Biostatistics for Public Health](https://www.edx.org/course/biostatistics-public-health) - edX
- [R for Data Science](https://r4ds.had.co.nz/) - Livre gratuit

### Communautés
- [Stack Overflow](https://stackoverflow.com/questions/tagged/r) - Questions R
- [Cross Validated](https://stats.stackexchange.com/) - Questions statistiques
- [RStudio Community](https://community.rstudio.com/) - Communauté R

---

## 🚨 Bonnes pratiques

### Organisation des fichiers
- Un dossier par projet/étude
- Noms de fichiers explicites (pas "data.csv")
- Versionnage avec Git

### Qualité des données
- Vérifier les valeurs aberrantes
- Traiter les données manquantes
- Documenter les transformations

### Analyses statistiques
- Vérifier les conditions d'application
- Utiliser des tests appropriés
- Interpréter la significativité clinique

### Reproductibilité
- Sauvegarder les scripts utilisés
- Documenter les versions des packages
- Utiliser des graines aléatoires (`set.seed()`)

---

## 📞 Support et contact

Si vous rencontrez des difficultés:

1. **Consultez d'abord la documentation**
   - `docs/methods/statistical_methods_guide.md`
   - `docs/tools/software_installation.md`

2. **Vérifiez les études de cas**
   - `docs/case_studies/case_study_1.md`

3. **Questions spécifiques**
   - Ouvrez une issue sur GitHub
   - Consultez les forums spécialisés

---

*Ce guide évolue constamment. N'hésitez pas à contribuer avec vos retours d'expérience !*