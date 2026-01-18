# =====================================================
# ANALYSE MULTIVARIÉE - ÉPIDÉMIOLOGIE CLINIQUE
# MULTIVARIATE ANALYSIS - CLINICAL EPIDEMIOLOGY
# =====================================================

# Installation et chargement des packages nécessaires
# Install and load required packages
if (!require(tidyverse)) install.packages("tidyverse")
if (!require(survival)) install.packages("survival")
if (!require(survminer)) install.packages("survminer")
if (!require(lme4)) install.packages("lme4")
if (!require(car)) install.packages("car")
if (!require(MASS)) install.packages("MASS")
if (!require(forestplot)) install.packages("forestplot")
if (!require(pROC)) install.packages("pROC")

library(tidyverse)
library(survival)
library(survminer)
library(lme4)
library(car)
library(MASS)
library(forestplot)
library(pROC)

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
# 2. RÉGRESSION LOGISTIQUE / LOGISTIC REGRESSION
# =====================================================

analyse_regression_logistique <- function(data) {
  cat("\n" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "\n")
  cat("RÉGRESSION LOGISTIQUE / LOGISTIC REGRESSION\n")
  cat("=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "\n\n")

  # Préparation des données / Data preparation
  data_log <- data %>%
    mutate(
      diabete_bin = ifelse(diabete == "Oui", 1, 0),
      hypertension_bin = ifelse(hypertension == "Oui", 1, 0),
      sexe_bin = ifelse(sexe == "Homme", 1, 0),
      fumeur_bin = case_when(
        fumeur == "Oui" ~ 1,
        fumeur == "Ancien" ~ 0.5,
        TRUE ~ 0
      )
    ) %>%
    filter(!is.na(diabete_bin) & !is.na(age) & !is.na(imc) & !is.na(sexe_bin))

  # Modèle univarié : Diabète ~ Âge / Univariate model: Diabetes ~ Age
  cat("MODÈLE UNIVARIÉ : DIABÈTE ~ ÂGE / UNIVARIATE MODEL: DIABETES ~ AGE\n")
  cat("-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "\n")

  model_uni <- glm(diabete_bin ~ age, data = data_log, family = binomial)
  print(summary(model_uni))

  # Odds ratio / Odds ratio
  cat("\nRapport de cotes (Odds Ratio) / Odds Ratio:\n")
  or_uni <- exp(cbind(OR = coef(model_uni), confint(model_uni)))
  print(or_uni)

  # Modèle multivarié / Multivariate model
  cat("\nMODÈLE MULTIVARIÉ : DIABÈTE ~ ÂGE + SEXE + IMC / MULTIVARIATE MODEL: DIABETES ~ AGE + SEX + BMI\n")
  cat("-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "\n")

  model_multi <- glm(diabete_bin ~ age + sexe_bin + imc, data = data_log, family = binomial)
  print(summary(model_multi))

  # Odds ratio multivarié / Multivariate odds ratio
  cat("\nRapports de cotes multivariés / Multivariate Odds Ratios:\n")
  or_multi <- exp(cbind(OR = coef(model_multi), confint(model_multi)))
  print(or_multi)

  # Test de colinéarité / Collinearity test
  cat("\nTEST DE COLINÉARITÉ (VIF) / COLLINEARITY TEST (VIF):\n")
  vif_result <- vif(model_multi)
  print(vif_result)

  # Comparaison des modèles / Model comparison
  cat("\nCOMPARAISON DES MODÈLES / MODEL COMPARISON:\n")
  model_comparison <- anova(model_uni, model_multi, test = "Chisq")
  print(model_comparison)

  # Courbe ROC / ROC curve
  cat("\nCOURBE ROC / ROC CURVE:\n")
  prob_multi <- predict(model_multi, type = "response")
  roc_multi <- roc(data_log$diabete_bin, prob_multi)
  print(roc_multi)

  # AUC / AUC
  cat("\nAUC =", auc(roc_multi), "\n")

  # Créer le graphique ROC / Create ROC plot
  if (!dir.exists("results/figures")) {
    dir.create("results/figures", recursive = TRUE)
  }

  png("results/figures/roc_curve.png", width = 600, height = 600)
  plot(roc_multi, main = "Courbe ROC - Modèle de Diabète / ROC Curve - Diabetes Model")
  text(0.6, 0.4, paste("AUC =", round(auc(roc_multi), 3)))
  dev.off()

  # Forest plot / Forest plot
  creer_forest_plot(or_multi, "results/figures/forest_plot_logistic.png")

  return(list(
    model_uni = model_uni,
    model_multi = model_multi,
    or_uni = or_uni,
    or_multi = or_multi,
    vif = vif_result,
    comparison = model_comparison,
    roc = roc_multi
  ))
}

# =====================================================
# 3. ANALYSE DE SURVIE (MODÈLE DE COX) / SURVIVAL ANALYSIS (COX MODEL)
# =====================================================

analyse_survie <- function(data) {
  cat("\n" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "\n")
  cat("ANALYSE DE SURVIE - MODÈLE DE COX / SURVIVAL ANALYSIS - COX MODEL\n")
  cat("=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "\n\n")

  # Simuler des données de survie / Simulate survival data
  set.seed(123)
  data_surv <- data %>%
    mutate(
      temps_suivi = runif(n(), 1, 24),  # Temps de suivi en mois / Follow-up time in months
      evenement = sample(c(0, 1), n(), replace = TRUE, prob = c(0.7, 0.3)),  # Événement (0=censuré, 1=événement) / Event (0=censored, 1=event)
      traitement_bin = ifelse(groupe_traitement == "Traitement_A", 1, 0)
    )

  # Modèle de Cox univarié / Univariate Cox model
  cat("MODÈLE DE COX UNIVARIÉ : SURVIE ~ TRAITEMENT / UNIVARIATE COX MODEL: SURVIVAL ~ TREATMENT\n")
  cat("-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "\n")

  cox_uni <- coxph(Surv(temps_suivi, evenement) ~ traitement_bin, data = data_surv)
  print(summary(cox_uni))

  # Modèle de Cox multivarié / Multivariate Cox model
  cat("\nMODÈLE DE COX MULTIVARIÉ : SURVIE ~ TRAITEMENT + ÂGE + SEXE / MULTIVARIATE COX MODEL: SURVIVAL ~ TREATMENT + AGE + SEX\n")
  cat("-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "-" %+% "\n")

  data_surv$sexe_bin <- ifelse(data_surv$sexe == "Homme", 1, 0)
  cox_multi <- coxph(Surv(temps_suivi, evenement) ~ traitement_bin + age + sexe_bin, data = data_surv)
  print(summary(cox_multi))

  # Test des proportions de risques / Test proportional hazards assumption
  cat("\nTEST DES PROPORTIONS DE RISQUES / PROPORTIONAL HAZARDS TEST:\n")
  ph_test <- cox.zph(cox_multi)
  print(ph_test)

  # Courbes de Kaplan-Meier / Kaplan-Meier curves
  cat("\nCOURBES DE KAPLAN-MEIER / KAPLAN-MEIER CURVES:\n")

  km_fit <- survfit(Surv(temps_suivi, evenement) ~ groupe_traitement, data = data_surv)

  # Créer le graphique Kaplan-Meier / Create Kaplan-Meier plot
  km_plot <- ggsurvplot(
    km_fit,
    data = data_surv,
    pval = TRUE,
    conf.int = TRUE,
    risk.table = TRUE,
    risk.table.col = "strata",
    linetype = "strata",
    surv.median.line = "hv",
    ggtheme = theme_minimal(),
    palette = c("#E7B800", "#2E9FDF", "#FC4E07"),
    title = "Courbes de Survie par Groupe de Traitement / Survival Curves by Treatment Group"
  )

  ggsave("results/figures/kaplan_meier_curves.png", km_plot$plot, width = 10, height = 8)

  # Log-rank test / Log-rank test
  cat("\nTEST DU LOG-RANK / LOG-RANK TEST:\n")
  logrank_test <- survdiff(Surv(temps_suivi, evenement) ~ groupe_traitement, data = data_surv)
  print(logrank_test)

  return(list(
    cox_uni = cox_uni,
    cox_multi = cox_multi,
    ph_test = ph_test,
    km_fit = km_fit,
    logrank_test = logrank_test
  ))
}

# =====================================================
# 4. ANALYSE EN COMPOSANTES PRINCIPALES (ACP) / PRINCIPAL COMPONENT ANALYSIS (PCA)
# =====================================================

analyse_acp <- function(data) {
  cat("\n" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "\n")
  cat("ANALYSE EN COMPOSANTES PRINCIPALES (ACP) / PRINCIPAL COMPONENT ANALYSIS (PCA)\n")
  cat("=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "\n\n")

  # Préparation des données pour ACP / Data preparation for PCA
  data_pca <- data %>%
    select(age, poids, taille, imc, hemoglobine_a1c, creatininemie, cholesterol_total) %>%
    na.omit() %>%
    scale()  # Standardisation / Standardization

  # ACP / PCA
  pca_result <- prcomp(data_pca, scale. = TRUE)

  # Variance expliquée / Explained variance
  cat("VARIANCE EXPLIQUÉE PAR COMPOSANTE / VARIANCE EXPLAINED BY COMPONENT:\n")
  var_explained <- pca_result$sdev^2 / sum(pca_result$sdev^2)
  print(var_explained)

  cat("\nPourcentages cumulés / Cumulative percentages:\n")
  cum_var <- cumsum(var_explained)
  print(cum_var)

  # Contributions des variables / Variable contributions
  cat("\nCONTRIBUTIONS DES VARIABLES (COMPOSANTE 1) / VARIABLE CONTRIBUTIONS (COMPONENT 1):\n")
  loadings_pc1 <- pca_result$rotation[,1]^2
  print(sort(loadings_pc1, decreasing = TRUE))

  # Créer le graphique ACP / Create PCA plot
  pca_scores <- as.data.frame(pca_result$x)

  p_pca <- ggplot(pca_scores, aes(x = PC1, y = PC2)) +
    geom_point(alpha = 0.6, color = "#667eea") +
    labs(title = "Analyse en Composantes Principales / Principal Component Analysis",
         x = paste0("PC1 (", round(var_explained[1]*100, 1), "%)"),
         y = paste0("PC2 (", round(var_explained[2]*100, 1), "%)")) +
    theme_minimal()

  ggsave("results/figures/pca_plot.png", p_pca, width = 8, height = 6)

  # Cercle de corrélation / Correlation circle
  pca_loadings <- as.data.frame(pca_result$rotation[,1:2])
  pca_loadings$variable <- rownames(pca_loadings)

  p_circle <- ggplot(pca_loadings, aes(x = PC1, y = PC2)) +
    geom_segment(aes(x = 0, y = 0, xend = PC1, yend = PC2),
                 arrow = arrow(length = unit(0.3, "cm")),
                 color = "#667eea") +
    geom_text(aes(label = variable), hjust = 1.1, vjust = 1.1) +
    geom_circle(aes(x0 = 0, y0 = 0, r = 1), color = "red", linetype = "dashed") +
    labs(title = "Cercle de Corrélation / Correlation Circle",
         x = "PC1", y = "PC2") +
    xlim(-1, 1) + ylim(-1, 1) +
    theme_minimal() +
    coord_fixed()

  ggsave("results/figures/correlation_circle.png", p_circle, width = 8, height = 8)

  return(list(
    pca_result = pca_result,
    var_explained = var_explained,
    loadings_pc1 = loadings_pc1,
    pca_scores = pca_scores
  ))
}

# =====================================================
# 5. MODÈLES MIXTES (EFFETS FIXES/ALÉATOIRES) / MIXED MODELS
# =====================================================

analyse_modeles_mixtes <- function(data) {
  cat("\n" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "\n")
  cat("MODÈLES MIXTES (EFFETS FIXES/ALÉATOIRES) / MIXED MODELS (FIXED/RANDOM EFFECTS)\n")
  cat("=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "=" %+% "\n\n")

  # Simuler des données longitudinales / Simulate longitudinal data
  set.seed(456)
  n_patients <- 200
  n_visits <- 4

  longitudinal_data <- data.frame(
    patient_id = rep(1:n_patients, each = n_visits),
    visit = rep(1:n_visits, n_patients),
    temps = rep(c(0, 3, 6, 12), n_patients)
  )

  # Ajouter des variables patient / Add patient variables
  patient_vars <- data[sample(1:nrow(data), n_patients, replace = TRUE), ]
  patient_vars$patient_id <- 1:n_patients

  longitudinal_data <- longitudinal_data %>%
    left_join(patient_vars %>% select(patient_id, age, sexe, groupe_traitement), by = "patient_id") %>%
    mutate(
      # Simuler évolution HbA1c / Simulate HbA1c evolution
      hba1c_base = rnorm(n_patients, mean = 8.5, sd = 1.5),
      hba1c = hba1c_base - temps * 0.1 + rnorm(n_patients * n_visits, 0, 0.5),
      traitement_bin = ifelse(groupe_traitement == "Traitement_A", 1, 0)
    )

  # Modèle linéaire simple / Simple linear model
  cat("MODÈLE LINÉAIRE SIMPLE / SIMPLE LINEAR MODEL:\n")
  lm_simple <- lm(hba1c ~ temps, data = longitudinal_data)
  print(summary(lm_simple))

  # Modèle mixte avec intercept aléatoire / Mixed model with random intercept
  cat("\nMODÈLE MIXTE - INTERCEPT ALÉATOIRE / MIXED MODEL - RANDOM INTERCEPT:\n")
  mixed_model <- lmer(hba1c ~ temps + traitement_bin + (1 | patient_id), data = longitudinal_data)
  print(summary(mixed_model))

  # Modèle mixte avec pente aléatoire / Mixed model with random slope
  cat("\nMODÈLE MIXTE - INTERCEPT ET PENTE ALÉATOIRES / MIXED MODEL - RANDOM INTERCEPT AND SLOPE:\n")
  mixed_model_slope <- lmer(hba1c ~ temps + traitement_bin + (temps | patient_id), data = longitudinal_data)
  print(summary(mixed_model_slope))

  # Comparaison des modèles / Model comparison
  cat("\nCOMPARAISON DES MODÈLES / MODEL COMPARISON:\n")
  anova_result <- anova(mixed_model, mixed_model_slope)
  print(anova_result)

  # Créer un graphique des effets individuels / Create individual effects plot
  pred_data <- longitudinal_data %>%
    mutate(pred = predict(mixed_model))

  p_mixed <- ggplot(pred_data, aes(x = temps, y = hba1c, group = patient_id)) +
    geom_line(alpha = 0.3, color = "gray") +
    geom_line(aes(y = pred), color = "#667eea", size = 1) +
    labs(title = "Évolution HbA1c - Modèle Mixte / HbA1c Evolution - Mixed Model",
         x = "Temps (mois) / Time (months)",
         y = "HbA1c (%)") +
    theme_minimal()

  ggsave("results/figures/mixed_model_plot.png", p_mixed, width = 10, height = 8)

  return(list(
    lm_simple = lm_simple,
    mixed_intercept = mixed_model,
    mixed_slope = mixed_model_slope,
    anova_mixed = anova_result
  ))
}

# =====================================================
# 6. FONCTION POUR CRÉER FOREST PLOT / FOREST PLOT FUNCTION
# =====================================================

creer_forest_plot <- function(or_matrix, filename) {
  # Préparer les données pour forest plot / Prepare data for forest plot
  forest_data <- data.frame(
    mean = or_matrix[, "OR"],
    lower = or_matrix[, "2.5 %"],
    upper = or_matrix[, "97.5 %"],
    variable = rownames(or_matrix)
  )

  # Créer le forest plot / Create forest plot
  png(filename, width = 800, height = 400)
  forestplot(
    labeltext = forest_data$variable,
    mean = forest_data$mean,
    lower = forest_data$lower,
    upper = forest_data$upper,
    zero = 1,
    xlog = TRUE,
    title = "Rapports de Cotes / Odds Ratios"
  )
  dev.off()

  message("Forest plot sauvegardé / Forest plot saved")
}

# =====================================================
# 7. FONCTION PRINCIPALE / MAIN FUNCTION
# =====================================================

analyse_multivariee_complete <- function() {
  cat("🔬 ANALYSE MULTIVARIÉE - ÉPIDÉMIOLOGIE CLINIQUE\n")
  cat("🔬 MULTIVARIATE ANALYSIS - CLINICAL EPIDEMIOLOGY\n")
  cat("=" * 60, "\n\n")

  # Charger les données / Load data
  data <- load_data()

  if (is.null(data)) {
    stop("Impossible de charger les données / Cannot load data")
  }

  # Analyses multivariées / Multivariate analyses
  resultats_logistique <- analyse_regression_logistique(data)
  resultats_survie <- analyse_survie(data)
  resultats_acp <- analyse_acp(data)
  resultats_mixtes <- analyse_modeles_mixtes(data)

  # Sauvegarder les résultats / Save results
  saveRDS(list(
    logistique = resultats_logistique,
    survie = resultats_survie,
    acp = resultats_acp,
    mixtes = resultats_mixtes
  ), "results/outputs/multivariate_analysis_results.rds")

  cat("\n✅ Analyse multivariée terminée / Multivariate analysis completed\n")
  cat("📊 Résultats sauvegardés dans results/outputs/ / Results saved in results/outputs/\n")
  cat("📈 Graphiques sauvegardés dans results/figures/ / Charts saved in results/figures/\n")
}

# =====================================================
# EXÉCUTION / EXECUTION
# =====================================================

if (interactive()) {
  analyse_multivariee_complete()
}