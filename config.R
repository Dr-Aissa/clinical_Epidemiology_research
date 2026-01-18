# =====================================================
# CONFIGURATION GLOBALE - ÉPIDÉMIOLOGIE CLINIQUE
# GLOBAL CONFIGURATION - CLINICAL EPIDEMIOLOGY
# =====================================================

# Configuration des chemins
# Path configuration
PROJECT_ROOT <- getwd()
DATA_DIR <- file.path(PROJECT_ROOT, "data")
SCRIPTS_DIR <- file.path(PROJECT_ROOT, "scripts")
RESULTS_DIR <- file.path(PROJECT_ROOT, "results")
DOCS_DIR <- file.path(PROJECT_ROOT, "docs")

# Créer les dossiers s'ils n'existent pas
# Create directories if they don't exist
dir.create(DATA_DIR, recursive = TRUE, showWarnings = FALSE)
dir.create(file.path(DATA_DIR, "raw"), recursive = TRUE, showWarnings = FALSE)
dir.create(file.path(DATA_DIR, "processed"), recursive = TRUE, showWarnings = FALSE)
dir.create(SCRIPTS_DIR, recursive = TRUE, showWarnings = FALSE)
dir.create(RESULTS_DIR, recursive = TRUE, showWarnings = FALSE)
dir.create(file.path(RESULTS_DIR, "figures"), recursive = TRUE, showWarnings = FALSE)
dir.create(file.path(RESULTS_DIR, "tables"), recursive = TRUE, showWarnings = FALSE)
dir.create(file.path(RESULTS_DIR, "outputs"), recursive = TRUE, showWarnings = FALSE)

# =====================================================
# PACKAGES ET LIBRAIRIES / PACKAGES AND LIBRARIES
# =====================================================

# Liste des packages essentiels
# Essential packages list
essential_packages <- c(
  "tidyverse",    # Manipulation et visualisation
  "dplyr",        # Manipulation des données
  "ggplot2",      # Graphiques
  "readr",        # Lecture de fichiers
  "tibble",       # Data frames améliorés
  "stringr",      # Manipulation de chaînes
  "lubridate",    # Dates
  "forcats"       # Facteurs
)

# Packages pour analyses statistiques
# Statistical analysis packages
stats_packages <- c(
  "survival",     # Analyse de survie
  "epitools",     # Outils épidémiologiques
  "meta",         # Méta-analyses
  "pROC",         # Courbes ROC
  "caret",        # Machine learning
  "rstatix",      # Tests statistiques
  "ggpubr",       # Graphiques publication
  "forestplot",   # Graphiques forest
  "tableone",     # Tableaux descriptifs
  "epiR",         # Épidémiologie
  "psych",        # Analyses psychométriques
  "corrplot"      # Matrices de corrélation
)

# Packages pour rapports
# Reporting packages
report_packages <- c(
  "rmarkdown",    # Rapports R Markdown
  "knitr",        # Intégration LaTeX
  "kableExtra",   # Tableaux améliorés
  "officer",      # Documents Word
  "openxlsx",     # Excel
  "xtable",       # Tableaux LaTeX
  "pander"        # Rapports automatiques
)

# =====================================================
# FONCTIONS UTILITAIRES / UTILITY FUNCTIONS
# =====================================================

# Fonction pour installer les packages
# Function to install packages
install_epidemiology_packages <- function() {
  # Installer les packages essentiels
  # Install essential packages
  for (pkg in essential_packages) {
    if (!require(pkg, character.only = TRUE)) {
      install.packages(pkg, dependencies = TRUE)
      library(pkg, character.only = TRUE)
    }
  }

  # Installer les packages statistiques
  # Install statistical packages
  for (pkg in stats_packages) {
    if (!require(pkg, character.only = TRUE)) {
      install.packages(pkg, dependencies = TRUE)
      library(pkg, character.only = TRUE)
    }
  }

  # Installer les packages de rapport
  # Install reporting packages
  for (pkg in report_packages) {
    if (!require(pkg, character.only = TRUE)) {
      install.packages(pkg, dependencies = TRUE)
      library(pkg, character.only = TRUE)
    }
  }

  message("✅ Tous les packages ont été installés et chargés / All packages have been installed and loaded")
}

# =====================================================
# CONFIGURATION GRAPHIQUE / GRAPHICS CONFIGURATION
# =====================================================

# Thème ggplot2 personnalisé
# Custom ggplot2 theme
theme_epidemiology <- function() {
  theme_minimal(base_size = 12) +
    theme(
      plot.title = element_text(hjust = 0.5, face = "bold", size = 14),
      plot.subtitle = element_text(hjust = 0.5, size = 12),
      axis.title = element_text(face = "bold"),
      legend.position = "bottom",
      panel.grid.minor = element_blank(),
      panel.grid.major = element_line(color = "gray90"),
      strip.background = element_rect(fill = "#667eea", color = NA),
      strip.text = element_text(color = "white", face = "bold")
    )
}

# Palette de couleurs pour épidémiologie
# Color palette for epidemiology
epidemiology_colors <- c(
  "#667eea",  # Bleu principal / Main blue
  "#764ba2",  # Violet / Purple
  "#f093fb",  # Rose / Pink
  "#4facfe",  # Bleu clair / Light blue
  "#43e97b",  # Vert / Green
  "#38f9d7",  # Turquoise
  "#fa709a",  # Rose foncé / Dark pink
  "#fee140"   # Jaune / Yellow
)

# Fonction pour définir la palette
# Function to set the palette
set_epidemiology_palette <- function() {
  scale_color_manual(values = epidemiology_colors)
}

# =====================================================
# PARAMÈTRES STATISTIQUES / STATISTICAL PARAMETERS
# =====================================================

# Niveau de significativité par défaut
# Default significance level
ALPHA <- 0.05

# Nombre de décimales pour l'affichage
# Number of decimals for display
DECIMALS <- 2

# Taille d'échantillon minimale pour les tests
# Minimum sample size for tests
MIN_SAMPLE_SIZE <- 30

# =====================================================
# FONCTIONS DE CHARGEMENT DES DONNÉES
# DATA LOADING FUNCTIONS
# =====================================================

# Fonction pour charger les données cliniques
# Function to load clinical data
load_clinical_data <- function(file_path = file.path(DATA_DIR, "raw", "sample_clinical_data.csv")) {
  if (file.exists(file_path)) {
    tryCatch({
      data <- read.csv(file_path, stringsAsFactors = FALSE, na.strings = c("", "NA", "N/A"))
      message("✅ Données chargées depuis: ", file_path)
      message("📊 Dimensions: ", nrow(data), " lignes × ", ncol(data), " colonnes")

      # Vérifier les valeurs manquantes
      # Check for missing values
      na_counts <- colSums(is.na(data))
      if (any(na_counts > 0)) {
        message("⚠️ Valeurs manquantes détectées / Missing values detected:")
        for (i in which(na_counts > 0)) {
          message("  - ", names(data)[i], ": ", na_counts[i], " (", round(na_counts[i]/nrow(data)*100, 1), "%)")
        }
      }

      return(data)
    }, error = function(e) {
      message("❌ Erreur lors du chargement: ", e$message)
      return(NULL)
    })
  } else {
    message("⚠️ Fichier non trouvé: ", file_path)
    message("💡 Utilisez create_sample_data() pour créer des données d'exemple")
    return(NULL)
  }
}

# Fonction pour créer des données d'exemple
# Function to create sample data
create_sample_data <- function(n = 200, seed = 123) {
  set.seed(seed)

  data <- data.frame(
    id = 1:n,
    age = round(rnorm(n, 60, 15), 0) %>% pmax(18) %>% pmin(90),
    sexe = sample(c("Homme", "Femme"), n, replace = TRUE, prob = c(0.45, 0.55)),
    poids = round(rnorm(n, 75, 15), 1) %>% pmax(40) %>% pmin(150),
    taille = round(rnorm(n, 170, 10), 1) %>% pmax(140) %>% pmin(200),
    diabete = sample(c("Oui", "Non"), n, replace = TRUE, prob = c(0.25, 0.75)),
    hypertension = sample(c("Oui", "Non"), n, replace = TRUE, prob = c(0.35, 0.65)),
    fumeur = sample(c("Oui", "Non", "Ancien"), n, replace = TRUE, prob = c(0.15, 0.20, 0.65)),
    groupe_traitement = sample(c("Traitement_A", "Traitement_B", "Placebo"), n, replace = TRUE),
    hba1c = round(rnorm(n, 7.0, 1.8), 1) %>% pmax(4) %>% pmin(15),
    cholesterol_total = round(rnorm(n, 200, 40), 0) %>% pmax(100) %>% pmin(350),
    creatininemie = round(rnorm(n, 85, 25), 0) %>% pmax(30) %>% pmin(200),
    suivi_mois = sample(12:36, n, replace = TRUE)
  )

  # Calcul de l'IMC
  data$imc <- round(data$poids / ((data$taille/100)^2), 1)

  # Création d'un outcome (événements CV)
  prob_cv <- plogis(-3 +
    0.02 * data$age +
    0.3 * (data$diabete == "Oui") +
    0.4 * (data$hypertension == "Oui") +
    0.3 * (data$fumeur == "Oui") +
    0.1 * data$hba1c
  )

  data$evenement_cv <- rbinom(n, 1, prob_cv)
  data$evenement_cv <- ifelse(data$evenement_cv == 1, "Oui", "Non")

  # Délai des événements pour analyse de survie
  data$delai_evenement <- ifelse(data$evenement_cv == "Oui",
    round(runif(sum(data$evenement_cv == "Oui"), 1, data$suivi_mois[data$evenement_cv == "Oui"])),
    NA
  )

  message("📊 Données d'exemple créées: ", n, " observations")
  return(data)
}

# =====================================================
# FONCTIONS DE SAUVEGARDE / SAVE FUNCTIONS
# =====================================================

# Fonction pour sauvegarder les résultats
# Function to save results
save_analysis_results <- function(results, filename, format = "rds") {
  output_dir <- file.path(RESULTS_DIR, "outputs")
  dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

  if (format == "rds") {
    saveRDS(results, file.path(output_dir, paste0(filename, ".rds")))
  } else if (format == "rda") {
    save(results, file = file.path(output_dir, paste0(filename, ".rda")))
  }

  message("💾 Résultats sauvegardés dans: ", file.path(output_dir, paste0(filename, ".", format)))
}

# Fonction pour sauvegarder les graphiques
# Function to save plots
save_epidemiology_plot <- function(plot, filename, width = 8, height = 6, dpi = 300) {
  figures_dir <- file.path(RESULTS_DIR, "figures")
  dir.create(figures_dir, recursive = TRUE, showWarnings = FALSE)

  ggsave(
    filename = file.path(figures_dir, paste0(filename, ".png")),
    plot = plot,
    width = width,
    height = height,
    dpi = dpi
  )

  message("📊 Graphique sauvegardé dans: ", file.path(figures_dir, paste0(filename, ".png")))
}

# =====================================================
# FONCTIONS DE VALIDATION / VALIDATION FUNCTIONS
# =====================================================

# Fonction pour valider les données
# Function to validate data
validate_clinical_data <- function(data) {
  issues <- list()

  # Vérifier les colonnes requises
  # Check required columns
  required_cols <- c("id", "age", "sexe", "diabete", "hypertension")
  missing_cols <- setdiff(required_cols, names(data))
  if (length(missing_cols) > 0) {
    issues <- c(issues, paste("Colonnes manquantes / Missing columns:", paste(missing_cols, collapse = ", ")))
  }

  # Vérifier les valeurs aberrantes
  # Check outliers
  if ("age" %in% names(data)) {
    invalid_age <- sum(data$age < 0 | data$age > 120, na.rm = TRUE)
    if (invalid_age > 0) {
      issues <- c(issues, paste(invalid_age, "valeurs d'âge invalides / invalid age values"))
    }
  }

  if ("imc" %in% names(data)) {
    invalid_imc <- sum(data$imc < 10 | data$imc > 70, na.rm = TRUE)
    if (invalid_imc > 0) {
      issues <- c(issues, paste(invalid_imc, "valeurs d'IMC invalides / invalid BMI values"))
    }
  }

  # Vérifier les types de données
  # Check data types
  if ("sexe" %in% names(data)) {
    invalid_sex <- sum(!data$sexe %in% c("Homme", "Femme", NA))
    if (invalid_sex > 0) {
      issues <- c(issues, paste(invalid_sex, "valeurs de sexe invalides / invalid sex values"))
    }
  }

  # Résumé des problèmes
  # Issues summary
  if (length(issues) == 0) {
    message("✅ Validation réussie / Validation successful")
    return(TRUE)
  } else {
    message("⚠️ Problèmes détectés / Issues detected:")
    for (issue in issues) {
      message("  - ", issue)
    }
    return(FALSE)
  }
}

# =====================================================
# INITIALISATION / INITIALIZATION
# =====================================================

# Message de bienvenue
# Welcome message
message("🔬 Configuration chargée - Épidémiologie Clinique")
message("🔬 Configuration loaded - Clinical Epidemiology")
message("📁 Répertoire de travail / Working directory: ", PROJECT_ROOT)

# Appliquer la configuration graphique
# Apply graphics configuration
if (require(ggplot2)) {
  theme_set(theme_epidemiology())
}

# Vérifier si les packages essentiels sont disponibles
# Check if essential packages are available
essential_available <- sapply(essential_packages, require, character.only = TRUE, quietly = TRUE)
if (!all(essential_available)) {
  message("💡 Certains packages essentiels ne sont pas installés.")
  message("💡 Some essential packages are not installed.")
  message("🔧 Exécutez: install_epidemiology_packages()")
}

message("🚀 Prêt pour l'analyse / Ready for analysis!")
message("📖 Pour commencer: source('scripts/descriptive/descriptive_analysis.R')")