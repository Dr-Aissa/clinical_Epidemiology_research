# =====================================================
# ANALYSE DESCRIPTIVE - ÉPIDÉMIOLOGIE CLINIQUE
# Descriptive Analysis - Clinical Epidemiology
# =====================================================

# Installation et chargement des packages nécessaires
# Install and load required packages
if (!require(tidyverse)) install.packages("tidyverse")
if (!require(summarytools)) install.packages("summarytools")
if (!require(psych)) install.packages("psych")
if (!require(ggplot2)) install.packages("ggplot2")

library(tidyverse)
library(summarytools)
library(psych)
library(ggplot2)

# =====================================================
# 1. CHARGEMENT DES DONNÉES / DATA LOADING
# =====================================================

# Fonction pour charger les données
# Function to load data
load_clinical_data <- function(file_path = "data/raw/sample_clinical_data.csv") {
  if (file.exists(file_path)) {
    data <- read.csv(file_path, stringsAsFactors = FALSE)
    message("Données chargées avec succès / Data loaded successfully")
    return(data)
  } else {
    message("Fichier de données non trouvé. Création de données d'exemple / Data file not found. Creating sample data")
    return(create_sample_data())
  }
}

# Création de données d'exemple si nécessaire
# Create sample data if needed
create_sample_data <- function(n = 500) {
  set.seed(123)  # Pour la reproductibilité / For reproducibility

  data <- data.frame(
    id = 1:n,
    age = round(rnorm(n, mean = 55, sd = 15), 0),
    sexe = sample(c("Homme", "Femme"), n, replace = TRUE, prob = c(0.45, 0.55)),
    poids = round(rnorm(n, mean = 75, sd = 15), 1),
    taille = round(rnorm(n, mean = 170, sd = 10), 1),
    imc = NA,  # Calculé plus tard / Calculated later
    diabete = sample(c("Oui", "Non"), n, replace = TRUE, prob = c(0.25, 0.75)),
    hypertension = sample(c("Oui", "Non"), n, replace = TRUE, prob = c(0.35, 0.65)),
    fumeur = sample(c("Oui", "Non", "Ancien"), n, replace = TRUE, prob = c(0.15, 0.20, 0.65)),
    groupe_traitement = sample(c("Traitement_A", "Traitement_B", "Placebo"), n, replace = TRUE),
    hemoglobine_a1c = round(rnorm(n, mean = 7.2, sd = 1.5), 1),
    creatininemie = round(rnorm(n, mean = 85, sd = 25), 0),
    cholesterol_total = round(rnorm(n, mean = 200, sd = 40), 0),
    suivi_mois = sample(1:24, n, replace = TRUE)
  )

  # Calcul de l'IMC / Calculate BMI
  data$imc <- round(data$poids / ((data$taille/100)^2), 1)

  # Corriger les valeurs aberrantes / Fix outliers
  data$age <- pmax(pmin(data$age, 90), 18)
  data$imc <- pmax(pmin(data$imc, 50), 15)
  data$hemoglobine_a1c <- pmax(pmin(data$hemoglobine_a1c, 15), 4)

  return(data)
}

# =====================================================
# 2. ANALYSE DESCRIPTIVE DES VARIABLES QUANTITATIVES
# DESCRIPTIVE ANALYSIS OF QUANTITATIVE VARIABLES
# =====================================================

analyse_quantitative <- function(data) {
  cat("\n" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "\n")
  cat("ANALYSE DESCRIPTIVE DES VARIABLES QUANTITATIVES\n")
  cat("DESCRIPTIVE ANALYSIS OF QUANTITATIVE VARIABLES\n")
  cat("=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "\n\n")

  # Variables quantitatives / Quantitative variables
  quanti_vars <- c("age", "poids", "taille", "imc", "hemoglobine_a1c",
                   "creatininemie", "cholesterol_total", "suivi_mois")

  # Statistiques descriptives / Descriptive statistics
  desc_stats <- data %>%
    select(all_of(quanti_vars)) %>%
    summarise(across(everything(), list(
      n = ~sum(!is.na(.)),
      mean = ~round(mean(., na.rm = TRUE), 2),
      sd = ~round(sd(., na.rm = TRUE), 2),
      median = ~round(median(., na.rm = TRUE), 2),
      q25 = ~round(quantile(., 0.25, na.rm = TRUE), 2),
      q75 = ~round(quantile(., 0.75, na.rm = TRUE), 2),
      min = ~round(min(., na.rm = TRUE), 2),
      max = ~round(max(., na.rm = TRUE), 2)
    ), .names = "{.col}_{.fn}"))

  print(desc_stats)

  # Distribution par groupe de traitement / Distribution by treatment group
  cat("\n\nDISTRIBUTION PAR GROUPE DE TRAITEMENT / DISTRIBUTION BY TREATMENT GROUP\n")
  cat("-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "\n")

  treatment_stats <- data %>%
    group_by(groupe_traitement) %>%
    summarise(
      n = n(),
      age_moy = round(mean(age, na.rm = TRUE), 1),
      imc_moy = round(mean(imc, na.rm = TRUE), 1),
      hba1c_moy = round(mean(hemoglobine_a1c, na.rm = TRUE), 1)
    )

  print(treatment_stats)

  return(list(desc_stats = desc_stats, treatment_stats = treatment_stats))
}

# =====================================================
# 3. ANALYSE DESCRIPTIVE DES VARIABLES QUALITATIVES
# DESCRIPTIVE ANALYSIS OF QUALITATIVE VARIABLES
# =====================================================

analyse_qualitative <- function(data) {
  cat("\n" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "\n")
  cat("ANALYSE DESCRIPTIVE DES VARIABLES QUALITATIVES\n")
  cat("DESCRIPTIVE ANALYSIS OF QUALITATIVE VARIABLES\n")
  cat("=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "\n\n")

  # Variables qualitatives / Qualitative variables
  quali_vars <- c("sexe", "diabete", "hypertension", "fumeur", "groupe_traitement")

  for (var in quali_vars) {
    cat("\nVARIABLE :", var, "\n")
    cat("VARIABLE:", var, "\n")
    cat("-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "\n")

    # Fréquences / Frequencies
    freq_table <- table(data[[var]], useNA = "ifany")
    prop_table <- round(prop.table(freq_table) * 100, 1)

    freq_df <- data.frame(
      Categorie = names(freq_table),
      Effectif = as.numeric(freq_table),
      Pourcentage = as.numeric(prop_table)
    )

    print(freq_df)
  }

  # Tableau croisé sexe x diabète / Cross table sex x diabetes
  cat("\n\nTABLEAU CROISÉ : SEXE × DIABÈTE\n")
  cat("CROSS TABLE: SEX × DIABETES\n")
  cat("-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "\n")

  cross_table <- table(data$sexe, data$diabete)
  print(cross_table)
  cat("\nPourcentages par ligne / Row percentages:\n")
  print(round(prop.table(cross_table, 1) * 100, 1))
}

# =====================================================
# 4. CRÉATION DE GRAPHES / GRAPH CREATION
# =====================================================

creer_graphiques <- function(data) {
  cat("\n" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "\n")
  cat("CRÉATION DES GRAPHES / GRAPH CREATION\n")
  cat("=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "\n\n")

  # Créer le dossier results/figures s'il n'existe pas
  # Create results/figures folder if it doesn't exist
  if (!dir.exists("results/figures")) {
    dir.create("results/figures", recursive = TRUE)
  }

  # 1. Histogramme de l'âge / Age histogram
  p1 <- ggplot(data, aes(x = age)) +
    geom_histogram(binwidth = 5, fill = "#667eea", color = "white", alpha = 0.7) +
    labs(title = "Distribution de l'âge / Age Distribution",
         x = "Âge (années) / Age (years)",
         y = "Fréquence / Frequency") +
    theme_minimal()

  ggsave("results/figures/age_distribution.png", p1, width = 8, height = 6)

  # 2. Boxplot IMC par groupe / BMI boxplot by group
  p2 <- ggplot(data, aes(x = groupe_traitement, y = imc, fill = groupe_traitement)) +
    geom_boxplot(alpha = 0.7) +
    labs(title = "IMC par groupe de traitement / BMI by Treatment Group",
         x = "Groupe de traitement / Treatment Group",
         y = "IMC / BMI") +
    theme_minimal() +
    theme(legend.position = "none")

  ggsave("results/figures/bmi_by_treatment.png", p2, width = 8, height = 6)

  # 3. Diagramme en barres pour le diabète / Bar chart for diabetes
  p3 <- ggplot(data, aes(x = diabete, fill = diabete)) +
    geom_bar(alpha = 0.7) +
    labs(title = "Prévalence du diabète / Diabetes Prevalence",
         x = "Diabète / Diabetes",
         y = "Nombre de patients / Number of patients") +
    theme_minimal() +
    theme(legend.position = "none")

  ggsave("results/figures/diabetes_prevalence.png", p3, width = 8, height = 6)

  # 4. Scatter plot âge vs IMC / Age vs BMI scatter plot
  p4 <- ggplot(data, aes(x = age, y = imc, color = sexe)) +
    geom_point(alpha = 0.6) +
    geom_smooth(method = "lm", se = FALSE) +
    labs(title = "Relation âge-IMC / Age-BMI Relationship",
         x = "Âge (années) / Age (years)",
         y = "IMC / BMI",
         color = "Sexe / Sex") +
    theme_minimal()

  ggsave("results/figures/age_bmi_scatter.png", p4, width = 8, height = 6)

  message("Graphiques sauvegardés dans results/figures/ / Charts saved in results/figures/")
}

# =====================================================
# 5. FONCTION PRINCIPALE / MAIN FUNCTION
# =====================================================

analyse_complete <- function() {
  cat("🔬 ANALYSE DESCRIPTIVE - ÉPIDÉMIOLOGIE CLINIQUE\n")
  cat("🔬 DESCRIPTIVE ANALYSIS - CLINICAL EPIDEMIOLOGY\n")
  cat("=" * 60, "\n\n")

  # Charger les données / Load data
  data <- load_clinical_data()

  # Sauvegarder les données d'exemple si elles ont été créées
  # Save sample data if created
  if (!file.exists("data/raw/sample_clinical_data.csv")) {
    write.csv(data, "data/raw/sample_clinical_data.csv", row.names = FALSE)
    message("Données d'exemple sauvegardées / Sample data saved")
  }

  # Analyses descriptives / Descriptive analyses
  resultats_quanti <- analyse_quantitative(data)
  analyse_qualitative(data)
  creer_graphiques(data)

  # Sauvegarder les résultats / Save results
  saveRDS(list(
    data = data,
    stats_quantitatives = resultats_quanti
  ), "results/outputs/descriptive_analysis_results.rds")

  cat("\n✅ Analyse descriptive terminée / Descriptive analysis completed\n")
  cat("📊 Résultats sauvegardés dans results/outputs/ / Results saved in results/outputs/\n")
  cat("📈 Graphiques sauvegardés dans results/figures/ / Charts saved in results/figures/\n")
}

# =====================================================
# EXÉCUTION / EXECUTION
# =====================================================

# Lancer l'analyse complète / Run complete analysis
if (interactive()) {
  analyse_complete()
}

# =====================================================
# FONCTIONS UTILITAIRES / UTILITY FUNCTIONS
# =====================================================

# Fonction pour créer un rapport HTML
# Function to create HTML report
creer_rapport_html <- function(data) {
  if (!require(rmarkdown)) install.packages("rmarkdown")
  library(rmarkdown)

  # Créer un fichier RMarkdown temporaire / Create temporary RMarkdown file
  rmd_content <- '
---
title: "Analyse Descriptive - Épidémiologie Clinique"
author: "Auto-généré / Auto-generated"
date: "`r Sys.Date()`"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = FALSE, warning = FALSE, message = FALSE)
library(tidyverse)
library(ggplot2)
data <- readRDS("results/outputs/descriptive_analysis_results.rds")$data
```

# Analyse Descriptive

## Statistiques Descriptives

```{r}
summary(data)
```

## Graphiques

### Distribution de l\\'âge
![Age Distribution](figures/age_distribution.png)

### IMC par groupe
![BMI by Group](figures/bmi_by_treatment.png)
'

  writeLines(rmd_content, "results/descriptive_report.Rmd")
  render("results/descriptive_report.Rmd", output_file = "descriptive_report.html")
  file.remove("results/descriptive_report.Rmd")

  message("Rapport HTML créé / HTML report created")
}