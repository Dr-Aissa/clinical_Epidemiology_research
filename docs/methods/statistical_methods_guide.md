# GUIDE DES MÉTHODES STATISTIQUES
# STATISTICAL METHODS GUIDE

## Épidémiologie Clinique - Analyses Statistiques

---

## 1. ANALYSE DESCRIPTIVE

### 1.1 Variables Quantitatives Continues

#### Statistiques de base
- **Moyenne** (± écart-type): `mean ± sd`
- **Médiane** (Q1 - Q3): tendance centrale robuste
- **Mode**: valeur la plus fréquente
- **Étendue**: min - max
- **Coefficient de variation**: (sd/mean) × 100

#### Tests de normalité
- **Test de Shapiro-Wilk**: `p > 0.05` → distribution normale
- **Test de Kolmogorov-Smirnov**: comparaison avec distribution normale
- **Graphiques**: histogramme, Q-Q plot, boxplot

#### Exemple R:
```r
# Test de normalité
shapiro.test(data$variable)

# Statistiques descriptives
data %>%
  summarise(
    moyenne = mean(variable, na.rm = TRUE),
    ecart_type = sd(variable, na.rm = TRUE),
    mediane = median(variable, na.rm = TRUE),
    q25 = quantile(variable, 0.25, na.rm = TRUE),
    q75 = quantile(variable, 0.75, na.rm = TRUE)
  )
```

### 1.2 Variables Qualitatives

#### Fréquences et pourcentages
- **Effectifs** (n) et **pourcentages** (%)
- **Tableaux de contingence**
- **Graphiques**: diagrammes en barres, camemberts

#### Exemple R:
```r
# Tableau de fréquences
table(data$variable)
prop.table(table(data$variable)) * 100

# Avec tidyverse
data %>%
  count(variable) %>%
  mutate(pourcentage = n / sum(n) * 100)
```

---

## 2. ANALYSE BIVARIÉE

### 2.1 Comparaison de Moyennes

#### Test t de Student
- **Conditions**: normalité, homoscédasticité, indépendance
- **Hypothèses**: H0: μ1 = μ2 vs H1: μ1 ≠ μ2
- **Interprétation**: p < 0.05 → différence significative

```r
# Test t bilatéral
t.test(variable ~ groupe, data = data)

# Test t unilatéral
t.test(variable ~ groupe, data = data, alternative = "greater")
```

#### ANOVA (Analyse de Variance)
- **Plus de 2 groupes**: comparaison globale
- **Post-hoc**: Tukey, Bonferroni, Holm
- **Conditions**: normalité, homoscédasticité

```r
# ANOVA
anova_result <- aov(variable ~ groupe, data = data)
summary(anova_result)

# Test post-hoc Tukey
TukeyHSD(anova_result)
```

#### Tests Non-Paramétriques
- **Mann-Whitney**: comparaison de 2 groupes indépendants
- **Kruskal-Wallis**: comparaison de k groupes indépendants
- **Wilcoxon**: groupes appariés

```r
# Mann-Whitney
wilcox.test(variable ~ groupe, data = data)

# Kruskal-Wallis
kruskal.test(variable ~ groupe, data = data)
```

### 2.2 Comparaison de Proportions

#### Test du Chi-carré
- **Conditions**: effectifs ≥ 5 dans chaque cellule
- **Khi-carré corrigé de Yates** pour petits effectifs
- **Test exact de Fisher** pour très petits effectifs

```r
# Chi-carré
chisq.test(table(variable1, variable2))

# Test exact de Fisher
fisher.test(table(variable1, variable2))
```

#### Rapport de Cotes (Odds Ratio)
```r
# Calcul de l'OR
odds_ratio <- fisher.test(table(variable1, variable2))
odds_ratio$estimate  # OR
odds_ratio$conf.int  # IC 95%
```

### 2.3 Corrélations

#### Coefficient de Pearson
- **Conditions**: normalité, relation linéaire
- **Interprétation**: |r| < 0.3 faible, 0.3-0.5 modérée, >0.5 forte

```r
# Corrélation de Pearson
cor.test(data$var1, data$var2, method = "pearson")
```

#### Coefficient de Spearman
- **Données ordinales** ou **non normales**
- **Robust** aux valeurs extrêmes

```r
# Corrélation de Spearman
cor.test(data$var1, data$var2, method = "spearman")
```

#### Matrice de corrélation
```r
# Matrice complète
cor(data[, c("var1", "var2", "var3")], use = "complete.obs")

# Graphique
library(corrplot)
corrplot(cor_matrix, method = "circle")
```

---

## 3. ANALYSE MULTIVARIÉE

### 3.1 Régression Linéaire

#### Modèle simple
```
Y = β₀ + β₁X₁ + ε
```

#### Conditions d'application
- **Linéarité**: relation linéaire entre X et Y
- **Indépendance**: résidus indépendants
- **Homoscedasticité**: variance constante des résidus
- **Normalité**: résidus suivent loi normale

```r
# Régression linéaire simple
model <- lm(y ~ x, data = data)
summary(model)

# Régression linéaire multiple
model <- lm(y ~ x1 + x2 + x3, data = data)
summary(model)

# Diagnostics
plot(model)  # Graphiques de diagnostic
```

#### Interprétation des coefficients
- **β₀**: ordonnée à l'origine
- **β₁**: variation de Y pour +1 de X₁
- **R²**: proportion de variance expliquée
- **p-value**: significativité du coefficient

### 3.2 Régression Logistique

#### Modèle pour variable binaire
```
log(p/1-p) = β₀ + β₁X₁ + β₂X₂ + ...
```

#### Odds Ratio (OR)
- **OR = exp(β)**: rapport de cotes
- **OR > 1**: facteur de risque
- **OR < 1**: facteur protecteur

```r
# Régression logistique
model <- glm(y ~ x1 + x2, data = data, family = binomial)
summary(model)

# Odds ratios
exp(coef(model))
exp(confint(model))  # IC 95%
```

#### Tests associés
- **Hosmer-Lemeshow**: adéquation du modèle
- **AUC/ROC**: discrimination du modèle

```r
# Courbe ROC
library(pROC)
roc_curve <- roc(data$y, predict(model, type = "response"))
auc(roc_curve)
plot(roc_curve)
```

### 3.3 Analyse de Survie

#### Concepts de base
- **Temps jusqu'à l'événement**
- **Censure**: observation incomplète
- **Fonction de survie**: S(t) = P(T > t)

#### Kaplan-Meier
```r
library(survival)

# Estimateur de Kaplan-Meier
km_fit <- survfit(Surv(time, event) ~ groupe, data = data)
plot(km_fit)

# Test du log-rank
survdiff(Surv(time, event) ~ groupe, data = data)
```

#### Modèle de Cox
```
h(t) = h₀(t) × exp(β₁X₁ + β₂X₂ + ...)
```

```r
# Modèle de Cox
cox_model <- coxph(Surv(time, event) ~ x1 + x2, data = data)
summary(cox_model)

# Hazard ratios
exp(coef(cox_model))
```

---

## 4. ANALYSES AVANCÉES

### 4.1 Analyse en Composantes Principales (ACP)

#### Objectif
- **Réduction de dimensionnalité**
- **Identification de patterns**
- **Variables corrélées → nouvelles variables**

```r
library(FactoMineR)

# ACP
pca_result <- PCA(data[, quanti_vars], graph = FALSE)
plot(pca_result, choix = "var")  # Cercle des corrélations
```

### 4.2 Analyse Factorielle

#### Différents types
- **ACP**: composantes principales
- **AFDM**: facteurs discriminants
- **AFC**: correspondances

### 4.3 Modèles Mixtes

#### Pour données longitudinales
```
Yᵢⱼ = β₀ + β₁X₁ᵢⱼ + b₀ᵢ + b₁ᵢX₁ᵢⱼ + εᵢⱼ
```

```r
library(lme4)

# Modèle mixte linéaire
mixed_model <- lmer(y ~ x1 + x2 + (1 + x1 | subject), data = data)
summary(mixed_model)
```

---

## 5. PUISSANCE STATISTIQUE ET TAILLE D'ÉCHANTILLON

### 5.1 Calcul de puissance
```r
library(pwr)

# Test t bilatéral
pwr.t.test(d = 0.5, power = 0.8, sig.level = 0.05)

# Test de proportion
pwr.2p.test(h = 0.3, power = 0.8, sig.level = 0.05)
```

### 5.2 Calcul taille échantillon
```r
# Pour moyenne
power.t.test(delta = 2, sd = 3, power = 0.8, sig.level = 0.05)

# Pour proportion
power.prop.test(p1 = 0.3, p2 = 0.5, power = 0.8, sig.level = 0.05)
```

---

## 6. GESTION DES DONNÉES MANQUANTES

### 6.1 Mécanismes de données manquantes
- **MCAR**: Missing Completely At Random
- **MAR**: Missing At Random
- **MNAR**: Missing Not At Random

### 6.2 Méthodes de gestion
```r
# Imputation par la moyenne
data$variable[is.na(data$variable)] <- mean(data$variable, na.rm = TRUE)

# Imputation multiple
library(mice)
imputed_data <- mice(data, m = 5)
```

---

## 7. VALIDATION DES MODÈLES

### 7.1 Validation croisée
```r
library(caret)

# Validation croisée k-fold
train_control <- trainControl(method = "cv", number = 10)
model <- train(y ~ ., data = data, method = "glm", trControl = train_control)
```

### 7.2 Métriques de performance
- **R², RMSE** pour régression
- **AUC, sensibilité, spécificité** pour classification
- **C-statistique** pour modèles de survie

---

## 8. BONNES PRATIQUES

### 8.1 Rapport des analyses
1. **Décrire les méthodes** utilisées
2. **Justifier les choix** statistiques
3. **Présenter les résultats** clairement
4. **Discuter les limites** des analyses

### 8.2 Interprétation
- **Significativité ≠ importance clinique**
- **Intervalle de confiance** plus informatif que p-value
- **Effet size** pour mesurer l'importance pratique

### 8.3 Outils recommandés
- **R**: analyses statistiques complètes
- **Python**: automatisation et machine learning
- **SAS/SPSS**: interfaces utilisateurs
- **Stata**: données longitudinales

---

## RÉFÉRENCES

1. Katz MH. Multivariable Analysis: A Practical Guide for Clinicians. Cambridge University Press, 2006.
2. Hosmer DW, Lemeshow S. Applied Logistic Regression. Wiley, 2000.
3. Kleinbaum DG, Klein M. Survival Analysis: A Self-Learning Text. Springer, 2012.
4. Field A. Discovering Statistics Using R. Sage Publications, 2012.