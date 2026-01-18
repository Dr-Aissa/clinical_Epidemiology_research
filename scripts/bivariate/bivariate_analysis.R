# =====================================================
# ANALYSE BIVARIÉE - ÉPIDÉMIOLOGIE CLINIQUE
# BIVARIATE ANALYSIS - CLINICAL EPIDEMIOLOGY
# =====================================================

# Installation et chargement des packages nécessaires
# Install and load required packages
if (!require(tidyverse)) install.packages("tidyverse")
if (!require(rstatix)) install.packages("rstatix")
if (!require(ggpubr)) install.packages("ggpubr")
if (!require(corrplot)) install.packages("corrplot")
if (!require(psych)) install.packages("psych")

library(tidyverse)
library(rstatix)
library(ggpubr)
library(corrplot)
library(psych)

# =====================================================
# 1. CHARGEMENT DES DONNÉES / DATA LOADING
# =====================================================

load_data <- function(file_path = "data/raw/sample_clinical_data.csv") {
  if (file.exists(file_path)) {
    data <- read.csv(file_path, stringsAsFactors = FALSE)
    message("Données chargées avec succès / Data loaded successfully")
    return(data)
  } else {
    message("Fichier de données non trouvé / Data file not found")
    return(NULL)
  }
}

# =====================================================
# 2. TESTS DE COMPARAISON / COMPARISON TESTS
# =====================================================

analyse_comparaisons <- function(data) {
  cat("\n" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "\n")
  cat("ANALYSES DE COMPARAISON / COMPARISON ANALYSES\n")
  cat("=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "\n\n")

  # 1. Test t pour âge selon le sexe / t-test for age by sex
  cat("1. TEST T - ÂGE SELON LE SEXE / T-TEST - AGE BY SEX\n")
  cat("-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "\n")

  ttest_age_sex <- t.test(age ~ sexe, data = data)
  print(ttest_age_sex)

  # 2. Test t pour HbA1c selon le diabète / t-test for HbA1c by diabetes
  cat("\n2. TEST T - HBA1C SELON LE DIABÈTE / T-TEST - HBA1C BY DIABETES\n")
  cat("-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "\n")

  ttest_hba1c_diab <- t.test(hemoglobine_a1c ~ diabete, data = data)
  print(ttest_hba1c_diab)

  # 3. ANOVA pour IMC selon le groupe de traitement / ANOVA for BMI by treatment group
  cat("\n3. ANOVA - IMC SELON LE GROUPE DE TRAITEMENT / ANOVA - BMI BY TREATMENT GROUP\n")
  cat("-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "\n")

  anova_imc <- aov(imc ~ groupe_traitement, data = data)
  print(summary(anova_imc))

  # Test post-hoc Tukey / Tukey post-hoc test
  cat("\nTest post-hoc Tukey / Tukey post-hoc test:\n")
  tukey_result <- TukeyHSD(anova_imc)
  print(tukey_result)

  # 4. Test de Mann-Whitney pour cholestérol selon hypertension
  # Mann-Whitney test for cholesterol by hypertension
  cat("\n4. TEST DE MANN-WHITNEY - CHOLESTÉROL SELON HYPERTENSION\n")
  cat("MANN-WHITNEY TEST - CHOLESTEROL BY HYPERTENSION\n")
  cat("-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "\n")

  wilcox_chol_hyper <- wilcox.test(cholesterol_total ~ hypertension, data = data)
  print(wilcox_chol_hyper)

  return(list(
    ttest_age_sex = ttest_age_sex,
    ttest_hba1c_diab = ttest_hba1c_diab,
    anova_imc = anova_imc,
    tukey_imc = tukey_result,
    wilcox_chol_hyper = wilcox_chol_hyper
  ))
}

# =====================================================
# 3. TESTS D'ASSOCIATION / ASSOCIATION TESTS
# =====================================================

analyse_associations <- function(data) {
  cat("\n" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "\n")
  cat("ANALYSES D'ASSOCIATION / ASSOCIATION ANALYSES\n")
  cat("=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "\n\n")

  # 1. Chi-carré : Diabète × Hypertension / Chi-square: Diabetes × Hypertension
  cat("1. CHI-CARRÉ - DIABÈTE × HYPERTENSION / CHI-SQUARE - DIABETES × HYPERTENSION\n")
  cat("-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "\n")

  contingency_table <- table(data$diabete, data$hypertension)
  print(contingency_table)
  cat("\n")

  chisq_test <- chisq.test(contingency_table)
  print(chisq_test)

  # Calcul des odds ratio / Calculate odds ratio
  cat("\nRapport de cotes (Odds Ratio) / Odds Ratio:\n")
  or_result <- fisher.test(contingency_table)
  print(or_result)

  # 2. Chi-carré : Sexe × Fumeur / Chi-square: Sex × Smoker
  cat("\n2. CHI-CARRÉ - SEXE × FUMEUR / CHI-SQUARE - SEX × SMOKER\n")
  cat("-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "\n")

  contingency_sex_smoke <- table(data$sexe, data$fumeur)
  print(contingency_sex_smoke)
  cat("\n")

  chisq_sex_smoke <- chisq.test(contingency_sex_smoke)
  print(chisq_sex_smoke)

  return(list(
    contingency_diab_hyper = contingency_table,
    chisq_diab_hyper = chisq_test,
    fisher_diab_hyper = or_result,
    contingency_sex_smoke = contingency_sex_smoke,
    chisq_sex_smoke = chisq_sex_smoke
  ))
}

# =====================================================
# 4. ANALYSES DE CORRÉLATION / CORRELATION ANALYSES
# =====================================================

analyse_correlations <- function(data) {
  cat("\n" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "\n")
  cat("ANALYSES DE CORRÉLATION / CORRELATION ANALYSES\n")
  cat("=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "\n\n")

  # Variables quantitatives pour corrélation / Quantitative variables for correlation
  quanti_vars <- c("age", "poids", "taille", "imc", "hemoglobine_a1c",
                   "creatininemie", "cholesterol_total")

  data_quanti <- data %>% select(all_of(quanti_vars))

  # Matrice de corrélation / Correlation matrix
  cat("MATRICE DE CORRÉLATION DE PEARSON / PEARSON CORRELATION MATRIX\n")
  cat("-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "\n")

  cor_matrix <- cor(data_quanti, use = "complete.obs", method = "pearson")
  print(round(cor_matrix, 3))

  # Test de significativité des corrélations / Test correlation significance
  cat("\nTESTS DE SIGNIFICATIVITÉ DES CORRÉLATIONS / CORRELATION SIGNIFICANCE TESTS\n")
  cat("-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "\n")

  cor_tests <- list()
  pairs <- combn(names(data_quanti), 2, simplify = FALSE)

  for (pair in pairs) {
    var1 <- pair[1]
    var2 <- pair[2]
    test_result <- cor.test(data_quanti[[var1]], data_quanti[[var2]], method = "pearson")
    cor_tests[[paste(var1, var2, sep = "_")]] <- test_result

    if (abs(test_result$estimate) > 0.3 && test_result$p.value < 0.05) {
      cat(sprintf("%s vs %s: r = %.3f, p = %.4f\n",
                  var1, var2, test_result$estimate, test_result$p.value))
    }
  }

  # Corrélation de Spearman pour variables ordinales / Spearman correlation for ordinal variables
  cat("\nCORRÉLATION DE SPEARMAN (ÂGE × HBA1C) / SPEARMAN CORRELATION (AGE × HBA1C)\n")
  cat("-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "\n")

  spearman_age_hba1c <- cor.test(data$age, data$hemoglobine_a1c, method = "spearman")
  print(spearman_age_hba1c)

  # Créer le graphique de corrélation / Create correlation plot
  if (!dir.exists("results/figures")) {
    dir.create("results/figures", recursive = TRUE)
  }

  png("results/figures/correlation_plot.png", width = 800, height = 600)
  corrplot(cor_matrix, method = "circle", type = "upper", order = "hclust",
           tl.col = "black", tl.srt = 45, addCoef.col = "black",
           title = "Matrice de Corrélation / Correlation Matrix")
  dev.off()

  message("Graphique de corrélation sauvegardé / Correlation plot saved")

  return(list(
    cor_matrix = cor_matrix,
    cor_tests = cor_tests,
    spearman_age_hba1c = spearman_age_hba1c
  ))
}

# =====================================================
# 5. CRÉATION DE GRAPHES BIVARIÉS / BIVARIATE PLOTS
# =====================================================

creer_graphiques_bivaries <- function(data) {
  cat("\n" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "\n")
  cat("CRÉATION DE GRAPHES BIVARIÉS / BIVARIATE PLOTS CREATION\n")
  cat("=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "\n\n")

  # Créer le dossier si nécessaire / Create folder if needed
  if (!dir.exists("results/figures")) {
    dir.create("results/figures", recursive = TRUE)
  }

  # 1. Boxplot âge par sexe / Age boxplot by sex
  p1 <- ggplot(data, aes(x = sexe, y = age, fill = sexe)) +
    geom_boxplot(alpha = 0.7) +
    labs(title = "Âge selon le sexe / Age by Sex",
         x = "Sexe / Sex", y = "Âge (années) / Age (years)") +
    theme_minimal() +
    theme(legend.position = "none")

  ggsave("results/figures/age_by_sex.png", p1, width = 6, height = 6)

  # 2. Scatter plot âge vs IMC avec régression / Age vs BMI scatter with regression
  p2 <- ggplot(data, aes(x = age, y = imc)) +
    geom_point(alpha = 0.6, color = "#667eea") +
    geom_smooth(method = "lm", color = "#764ba2", se = TRUE) +
    labs(title = "Relation âge-IMC / Age-BMI Relationship",
         x = "Âge (années) / Age (years)",
         y = "IMC / BMI") +
    theme_minimal()

  ggsave("results/figures/age_bmi_regression.png", p2, width = 8, height = 6)

  # 3. Barplot avec test de chi-carré / Bar plot with chi-square test
  p3 <- ggplot(data, aes(x = diabete, fill = hypertension)) +
    geom_bar(position = "fill") +
    labs(title = "Association Diabète-Hypertension / Diabetes-Hypertension Association",
         x = "Diabète / Diabetes", y = "Proportion / Proportion",
         fill = "Hypertension") +
    theme_minimal()

  ggsave("results/figures/diabetes_hypertension_assoc.png", p3, width = 8, height = 6)

  # 4. Violin plot pour groupes de traitement / Violin plot for treatment groups
  p4 <- ggplot(data, aes(x = groupe_traitement, y = hemoglobine_a1c, fill = groupe_traitement)) +
    geom_violin(alpha = 0.7) +
    geom_boxplot(width = 0.1, fill = "white", alpha = 0.7) +
    labs(title = "HbA1c par groupe de traitement / HbA1c by Treatment Group",
         x = "Groupe de traitement / Treatment Group",
         y = "HbA1c (%)") +
    theme_minimal() +
    theme(legend.position = "none")

  ggsave("results/figures/hba1c_by_treatment_violin.png", p4, width = 8, height = 6)

  message("Graphiques bivariés sauvegardés / Bivariate plots saved")
}

# =====================================================
# 6. FONCTION PRINCIPALE / MAIN FUNCTION
# =====================================================

analyse_bivariee_complete <- function() {
  cat("🔬 ANALYSE BIVARIÉE - ÉPIDÉMIOLOGIE CLINIQUE\n")
  cat("🔬 BIVARIATE ANALYSIS - CLINICAL EPIDEMIOLOGY\n")
  cat("=" * 60, "\n\n")

  # Charger les données / Load data
  data <- load_data()

  if (is.null(data)) {
    stop("Impossible de charger les données / Cannot load data")
  }

  # Analyses bivariées / Bivariate analyses
  resultats_comparaisons <- analyse_comparaisons(data)
  resultats_associations <- analyse_associations(data)
  resultats_correlations <- analyse_correlations(data)
  creer_graphiques_bivaries(data)

  # Sauvegarder les résultats / Save results
  saveRDS(list(
    comparaisons = resultats_comparaisons,
    associations = resultats_associations,
    correlations = resultats_correlations
  ), "results/outputs/bivariate_analysis_results.rds")

  cat("\n✅ Analyse bivariée terminée / Bivariate analysis completed\n")
  cat("📊 Résultats sauvegardés dans results/outputs/ / Results saved in results/outputs/\n")
  cat("📈 Graphiques sauvegardés dans results/figures/ / Charts saved in results/figures/\n")
}

# =====================================================
# EXÉCUTION / EXECUTION
# =====================================================

if (interactive()) {
  analyse_bivariee_complete()
}