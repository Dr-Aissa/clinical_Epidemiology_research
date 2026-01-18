# =====================================================
# ANALYSE STATISTIQUE PYTHON - ÉPIDÉMIOLOGIE CLINIQUE
# PYTHON STATISTICAL ANALYSIS - CLINICAL EPIDEMIOLOGY
# =====================================================

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from scipy import stats
import statsmodels.api as sm
import statsmodels.formula.api as smf
from statsmodels.stats.multicomp import pairwise_tukeyhsd
import os
from pathlib import Path

# Configuration de l'environnement
plt.style.use('seaborn-v0_8')
sns.set_palette("husl")
plt.rcParams['figure.figsize'] = (10, 6)
plt.rcParams['font.size'] = 12

# =====================================================
# 1. CHARGEMENT DES DONNÉES / DATA LOADING
# =====================================================

def load_clinical_data(file_path="data/raw/sample_clinical_data.csv"):
    """
    Charge les données cliniques depuis un fichier CSV

    Parameters:
    file_path (str): Chemin vers le fichier CSV

    Returns:
    pd.DataFrame: DataFrame contenant les données
    """
    if os.path.exists(file_path):
        try:
            data = pd.read_csv(file_path)
            print("✅ Données chargées avec succès / Data loaded successfully")
            print(f"Dimensions: {data.shape[0]} lignes, {data.shape[1]} colonnes")
            return data
        except Exception as e:
            print(f"❌ Erreur lors du chargement: {e}")
            return None
    else:
        print("⚠️ Fichier non trouvé, création de données d'exemple")
        return create_sample_data()

def create_sample_data(n=500):
    """
    Crée des données d'exemple pour l'analyse

    Parameters:
    n (int): Nombre d'observations à générer

    Returns:
    pd.DataFrame: DataFrame avec données simulées
    """
    np.random.seed(42)  # Pour la reproductibilité

    data = pd.DataFrame({
        'id': range(1, n+1),
        'age': np.random.normal(55, 15, n).clip(18, 90).astype(int),
        'sexe': np.random.choice(['Homme', 'Femme'], n, p=[0.45, 0.55]),
        'poids': np.random.normal(75, 15, n).clip(40, 150),
        'taille': np.random.normal(170, 10, n).clip(140, 200),
        'diabete': np.random.choice(['Oui', 'Non'], n, p=[0.25, 0.75]),
        'hypertension': np.random.choice(['Oui', 'Non'], n, p=[0.35, 0.65]),
        'fumeur': np.random.choice(['Oui', 'Non', 'Ancien'], n, p=[0.15, 0.20, 0.65]),
        'groupe_traitement': np.random.choice(['Traitement_A', 'Traitement_B', 'Placebo'], n),
        'hemoglobine_a1c': np.random.normal(7.2, 1.5, n).clip(4, 15),
        'creatininemie': np.random.normal(85, 25, n).clip(30, 200),
        'cholesterol_total': np.random.normal(200, 40, n).clip(100, 350),
        'suivi_mois': np.random.randint(1, 25, n)
    })

    # Calcul de l'IMC
    data['imc'] = (data['poids'] / ((data['taille']/100)**2)).round(1)

    print(f"📊 Données d'exemple créées: {n} observations")
    return data

# =====================================================
# 2. ANALYSE DESCRIPTIVE / DESCRIPTIVE ANALYSIS
# =====================================================

def descriptive_analysis(data):
    """
    Effectue une analyse descriptive complète des données

    Parameters:
    data (pd.DataFrame): DataFrame contenant les données
    """
    print("\n" + "="*70)
    print("📊 ANALYSE DESCRIPTIVE / DESCRIPTIVE ANALYSIS")
    print("="*70)

    # Variables quantitatives
    quanti_vars = ['age', 'poids', 'taille', 'imc', 'hemoglobine_a1c',
                   'creatininemie', 'cholesterol_total', 'suivi_mois']

    print("\n📈 STATISTIQUES DESCRIPTIVES - VARIABLES QUANTITATIVES")
    print("-"*60)

    desc_stats = data[quanti_vars].describe().round(2)
    print(desc_stats)

    # Analyse par groupe de traitement
    print("\n🏥 STATISTIQUES PAR GROUPE DE TRAITEMENT")
    print("-"*50)

    treatment_stats = data.groupby('groupe_traitement')[quanti_vars].agg(['mean', 'std', 'count']).round(2)
    print(treatment_stats)

    # Variables qualitatives
    quali_vars = ['sexe', 'diabete', 'hypertension', 'fumeur', 'groupe_traitement']

    print("\n📊 FRÉQUENCES - VARIABLES QUALITATIVES")
    print("-"*45)

    for var in quali_vars:
        print(f"\n{var.upper()}:")
        freq = data[var].value_counts()
        prop = data[var].value_counts(normalize=True) * 100
        freq_table = pd.DataFrame({'Effectif': freq, 'Pourcentage': prop.round(1)})
        print(freq_table)

    return desc_stats, treatment_stats

# =====================================================
# 3. ANALYSE BIVARIÉE / BIVARIATE ANALYSIS
# =====================================================

def bivariate_analysis(data):
    """
    Effectue des analyses bivariées (comparaisons et associations)

    Parameters:
    data (pd.DataFrame): DataFrame contenant les données
    """
    print("\n" + "="*70)
    print("🔗 ANALYSE BIVARIÉE / BIVARIATE ANALYSIS")
    print("="*70)

    results = {}

    # Tests de comparaison
    print("\n⚖️ TESTS DE COMPARAISON / COMPARISON TESTS")
    print("-"*50)

    # Test t pour âge selon sexe
    print("\n1. Test t - Âge selon le sexe / t-test - Age by sex")
    age_homme = data[data['sexe'] == 'Homme']['age']
    age_femme = data[data['sexe'] == 'Femme']['age']
    ttest_age_sex = stats.ttest_ind(age_homme, age_femme)
    print(".3f")
    results['ttest_age_sex'] = ttest_age_sex

    # Test t pour HbA1c selon diabète
    print("\n2. Test t - HbA1c selon diabète / t-test - HbA1c by diabetes")
    hba1c_diab = data[data['diabete'] == 'Oui']['hemoglobine_a1c']
    hba1c_no_diab = data[data['diabete'] == 'Non']['hemoglobine_a1c']
    ttest_hba1c_diab = stats.ttest_ind(hba1c_diab, hba1c_no_diab)
    print(".3f")
    results['ttest_hba1c_diab'] = ttest_hba1c_diab

    # ANOVA pour IMC selon groupe de traitement
    print("\n3. ANOVA - IMC selon groupe de traitement / ANOVA - BMI by treatment group")
    anova_imc = stats.f_oneway(
        data[data['groupe_traitement'] == 'Traitement_A']['imc'],
        data[data['groupe_traitement'] == 'Traitement_B']['imc'],
        data[data['groupe_traitement'] == 'Placebo']['imc']
    )
    print(".3f")
    results['anova_imc'] = anova_imc

    # Test post-hoc Tukey
    tukey_imc = pairwise_tukeyhsd(data['imc'], data['groupe_traitement'])
    print("\nTest post-hoc Tukey / Tukey post-hoc test:")
    print(tukey_imc)
    results['tukey_imc'] = tukey_imc

    # Tests d'association
    print("\n\n🔗 TESTS D'ASSOCIATION / ASSOCIATION TESTS")
    print("-"*50)

    # Chi-carré : Diabète × Hypertension
    print("\n1. Chi-carré - Diabète × Hypertension / Chi-square - Diabetes × Hypertension")
    contingency_diab_hyper = pd.crosstab(data['diabete'], data['hypertension'])
    print(contingency_diab_hyper)
    chisq_diab_hyper = stats.chi2_contingency(contingency_diab_hyper)
    print(".3f")
    results['chisq_diab_hyper'] = chisq_diab_hyper

    # Rapport de cotes (Odds Ratio)
    from statsmodels.stats.contingency_tables import Table2x2
    table_2x2 = Table2x2(contingency_diab_hyper.values)
    print(".3f")

    # Corrélations
    print("\n\n📈 ANALYSES DE CORRÉLATION / CORRELATION ANALYSES")
    print("-"*55)

    quanti_vars = ['age', 'poids', 'taille', 'imc', 'hemoglobine_a1c',
                   'creatininemie', 'cholesterol_total']

    cor_matrix = data[quanti_vars].corr(method='pearson')
    print("Matrice de corrélation de Pearson / Pearson correlation matrix:")
    print(cor_matrix.round(3))

    # Test de corrélation âge vs IMC
    cor_age_imc = stats.pearsonr(data['age'], data['imc'])
    print(".3f")
    results['cor_age_imc'] = cor_age_imc

    return results

# =====================================================
# 4. ANALYSE MULTIVARIÉE / MULTIVARIATE ANALYSIS
# =====================================================

def multivariate_analysis(data):
    """
    Effectue des analyses multivariées (régression logistique, etc.)

    Parameters:
    data (pd.DataFrame): DataFrame contenant les données
    """
    print("\n" + "="*70)
    print("🔬 ANALYSE MULTIVARIÉE / MULTIVARIATE ANALYSIS")
    print("="*70)

    results = {}

    # Préparation des données
    data_model = data.copy()

    # Conversion des variables catégorielles
    data_model['sexe'] = data_model['sexe'].map({'Homme': 1, 'Femme': 0})
    data_model['diabete'] = data_model['diabete'].map({'Oui': 1, 'Non': 0})
    data_model['hypertension'] = data_model['hypertension'].map({'Oui': 1, 'Non': 0})

    # Encodage des variables de traitement
    data_model['traitement_A'] = (data_model['groupe_traitement'] == 'Traitement_A').astype(int)
    data_model['traitement_B'] = (data_model['groupe_traitement'] == 'Traitement_B').astype(int)

    # Régression logistique : Diabète en fonction de l'âge, IMC et sexe
    print("\n📊 RÉGRESSION LOGISTIQUE - DIABÈTE")
    print("LOGISTIC REGRESSION - DIABETES")
    print("-"*40)

    formula = "diabete ~ age + imc + sexe + hypertension"
    model_log = smf.logit(formula, data=data_model).fit(disp=False)
    print(model_log.summary())

    # Odds ratios
    print("\nRapports de cotes (Odds Ratios) / Odds Ratios:")
    odds_ratios = pd.DataFrame({
        'OR': np.exp(model_log.params),
        '2.5%': np.exp(model_log.conf_int()[0]),
        '97.5%': np.exp(model_log.conf_int()[1]),
        'p-value': model_log.pvalues
    }).round(3)
    print(odds_ratios)

    results['logistic_diabete'] = model_log

    # Régression linéaire : HbA1c en fonction de l'âge et de l'IMC
    print("\n📈 RÉGRESSION LINÉAIRE - HBA1C")
    print("LINEAR REGRESSION - HBA1C")
    print("-"*30)

    formula_linear = "hemoglobine_a1c ~ age + imc + diabete + traitement_A + traitement_B"
    model_lin = smf.ols(formula_linear, data=data_model).fit()
    print(model_lin.summary())

    results['linear_hba1c'] = model_lin

    return results

# =====================================================
# 5. CRÉATION DE VISUALISATIONS / VISUALIZATIONS
# =====================================================

def create_visualizations(data):
    """
    Crée des visualisations pour l'analyse épidémiologique

    Parameters:
    data (pd.DataFrame): DataFrame contenant les données
    """
    print("\n" + "="*70)
    print("📊 CRÉATION DES VISUALISATIONS / CREATING VISUALIZATIONS")
    print("="*70)

    # Créer le dossier results/figures s'il n'existe pas
    figures_dir = Path("results/figures")
    figures_dir.mkdir(parents=True, exist_ok=True)

    # 1. Distribution de l'âge
    plt.figure(figsize=(10, 6))
    sns.histplot(data=data, x='age', bins=20, kde=True, color='#667eea')
    plt.title('Distribution de l\'âge / Age Distribution')
    plt.xlabel('Âge (années) / Age (years)')
    plt.ylabel('Fréquence / Frequency')
    plt.savefig(figures_dir / 'age_distribution_py.png', dpi=300, bbox_inches='tight')
    plt.close()

    # 2. IMC par groupe de traitement (boxplot)
    plt.figure(figsize=(10, 6))
    sns.boxplot(data=data, x='groupe_traitement', y='imc', palette='Set2')
    plt.title('IMC par groupe de traitement / BMI by Treatment Group')
    plt.xlabel('Groupe de traitement / Treatment Group')
    plt.ylabel('IMC / BMI')
    plt.xticks(rotation=45)
    plt.savefig(figures_dir / 'bmi_by_treatment_py.png', dpi=300, bbox_inches='tight')
    plt.close()

    # 3. Scatter plot âge vs IMC avec régression
    plt.figure(figsize=(10, 6))
    sns.regplot(data=data, x='age', y='imc', scatter_kws={'alpha':0.6}, color='#667eea')
    plt.title('Relation âge-IMC / Age-BMI Relationship')
    plt.xlabel('Âge (années) / Age (years)')
    plt.ylabel('IMC / BMI')
    plt.savefig(figures_dir / 'age_bmi_regression_py.png', dpi=300, bbox_inches='tight')
    plt.close()

    # 4. Prévalence du diabète par sexe
    plt.figure(figsize=(10, 6))
    diabete_by_sex = pd.crosstab(data['sexe'], data['diabete'], normalize='index') * 100
    diabete_by_sex.plot(kind='bar', stacked=True, color=['#ff9999', '#66b3ff'])
    plt.title('Prévalence du diabète par sexe / Diabetes Prevalence by Sex')
    plt.xlabel('Sexe / Sex')
    plt.ylabel('Pourcentage / Percentage')
    plt.legend(title='Diabète / Diabetes')
    plt.xticks(rotation=0)
    plt.savefig(figures_dir / 'diabetes_by_sex_py.png', dpi=300, bbox_inches='tight')
    plt.close()

    # 5. Matrice de corrélation
    quanti_vars = ['age', 'poids', 'taille', 'imc', 'hemoglobine_a1c',
                   'creatininemie', 'cholesterol_total']

    plt.figure(figsize=(10, 8))
    corr_matrix = data[quanti_vars].corr()
    mask = np.triu(np.ones_like(corr_matrix, dtype=bool))
    sns.heatmap(corr_matrix, mask=mask, annot=True, cmap='coolwarm', center=0,
                square=True, linewidths=.5, cbar_kws={"shrink": .5})
    plt.title('Matrice de corrélation / Correlation Matrix')
    plt.tight_layout()
    plt.savefig(figures_dir / 'correlation_matrix_py.png', dpi=300, bbox_inches='tight')
    plt.close()

    # 6. Evolution de l'HbA1c par groupe de traitement (violin plot)
    plt.figure(figsize=(10, 6))
    sns.violinplot(data=data, x='groupe_traitement', y='hemoglobine_a1c', palette='Set2')
    plt.title('HbA1c par groupe de traitement / HbA1c by Treatment Group')
    plt.xlabel('Groupe de traitement / Treatment Group')
    plt.ylabel('HbA1c (%)')
    plt.xticks(rotation=45)
    plt.savefig(figures_dir / 'hba1c_violin_py.png', dpi=300, bbox_inches='tight')
    plt.close()

    print("✅ Visualisations créées et sauvegardées / Visualizations created and saved")
    print(f"📁 Dossier: {figures_dir}")

# =====================================================
# 6. FONCTION PRINCIPALE / MAIN FUNCTION
# =====================================================

def run_complete_analysis():
    """
    Lance l'analyse complète des données épidémiologiques
    """
    print("🔬 ANALYSE STATISTIQUE PYTHON - ÉPIDÉMIOLOGIE CLINIQUE")
    print("🔬 PYTHON STATISTICAL ANALYSIS - CLINICAL EPIDEMIOLOGY")
    print("="*70)

    # Charger les données
    data = load_clinical_data()

    if data is None:
        print("❌ Impossible de charger les données")
        return

    # Analyses descriptives
    desc_stats, treatment_stats = descriptive_analysis(data)

    # Analyses bivariées
    bivariate_results = bivariate_analysis(data)

    # Analyses multivariées
    multivariate_results = multivariate_analysis(data)

    # Création des visualisations
    create_visualizations(data)

    # Sauvegarder les résultats
    results_dir = Path("results/outputs")
    results_dir.mkdir(parents=True, exist_ok=True)

    results = {
        'descriptive': {
            'stats': desc_stats.to_dict(),
            'treatment_stats': treatment_stats.to_dict()
        },
        'bivariate': bivariate_results,
        'multivariate': {
            'logistic_model': str(multivariate_results['logistic_diabete'].summary()),
            'linear_model': str(multivariate_results['linear_hba1c'].summary())
        }
    }

    # Sauvegarder en JSON (facilite la lecture)
    import json
    with open(results_dir / 'python_analysis_results.json', 'w', encoding='utf-8') as f:
        # Convertir les objets numpy/scipy en types sérialisables
        json_results = {}
        for key, value in results.items():
            if hasattr(value, 'to_dict'):
                json_results[key] = value.to_dict()
            else:
                json_results[key] = str(value)
        json.dump(json_results, f, indent=2, ensure_ascii=False)

    print("\n✅ Analyse complète terminée / Complete analysis finished")
    print("📊 Résultats sauvegardés dans results/outputs/ / Results saved in results/outputs/")
    print("📈 Graphiques sauvegardés dans results/figures/ / Charts saved in results/figures/")

    return results

# =====================================================
# EXÉCUTION / EXECUTION
# =====================================================

if __name__ == "__main__":
    # Lancer l'analyse complète
    results = run_complete_analysis()