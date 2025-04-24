# Importation des bibliothèques nécessaires
import requests       # Pour effectuer des requêtes HTTP
import sqlite3        # Pour interagir avec une base de données SQLite
from bs4 import BeautifulSoup  # Pour parser le contenu HTML et XML

def get_sitemap_xml(url):
    """
    Récupère le contenu XML du sitemap à partir de l'URL fournie.

    Paramètre:
        url (str): L'URL du sitemap.

    Retourne:
        bytes: Le contenu du sitemap en bytes.
    """
    # Effectue une requête HTTP GET pour obtenir le sitemap
    response = requests.get(url)
    # Vérifie si la requête a réussi (code 200). Si ce n'est pas le cas, lève une exception HTTPError.
    response.raise_for_status()
    # Retourne le contenu du sitemap
    return response.content

def parse_sitemap(sitemap_xml):
    """
    Parse le sitemap XML et extrait toutes les URLs commençant par 'https://readi.fi/asset'.

    Paramètre:
        sitemap_xml (bytes): Le contenu XML du sitemap.

    Retourne:
        list: Une liste d'URLs correspondant aux assets.
    """
    # Parse le contenu XML du sitemap avec BeautifulSoup en utilisant le parseur XML
    soup = BeautifulSoup(sitemap_xml, 'xml')
    # Trouve toutes les balises <loc> qui contiennent les URLs
    loc_tags = soup.find_all('loc')
    # Extrait le texte de chaque balise <loc> et filtre les URLs qui commencent par 'https://readi.fi/asset'
    asset_urls = [loc.text for loc in loc_tags if loc.text.startswith('https://readi.fi/asset')]
    # Retourne la liste des URLs des assets
    return asset_urls

def fetch_page_data(url):
    """
    Récupère le titre et la description meta de la page à l'URL donnée.

    Paramètre:
        url (str): L'URL de la page à scraper.

    Retourne:
        tuple: Un tuple contenant le titre et la description de la page.
    """
    # Effectue une requête HTTP GET pour obtenir le contenu de la page
    response = requests.get(url)
    # Vérifie si la requête a réussi
    response.raise_for_status()
    # Parse le contenu HTML de la page avec BeautifulSoup en utilisant le parseur HTML
    soup = BeautifulSoup(response.content, 'html.parser')

    # Trouve la balise <title> et extrait son texte
    title_tag = soup.find('title')
    # Si la balise <title> existe, extrait et nettoie son texte, sinon utilise une chaîne vide
    title = title_tag.text.strip() if title_tag else ''

    # Trouve la balise <meta name="description"> et extrait son attribut 'content'
    meta_description_tag = soup.find('meta', attrs={'name': 'description'})
    # Si la balise meta description existe, extrait et nettoie son contenu, sinon utilise une chaîne vide
    description = meta_description_tag['content'].strip() if meta_description_tag else ''

    # Retourne le titre et la description de la page
    return title, description

def store_in_db(data_list):
    """
    Stocke les données collectées dans une base de données SQLite.

    Paramètre:
        data_list (list): Une liste de tuples contenant l'URL, le titre et la description de chaque page.
    """
    # Se connecte (ou crée) à la base de données SQLite nommée 'assets.db'
    conn = sqlite3.connect('assets.db')
    # Crée un curseur pour exécuter des commandes SQL
    cursor = conn.cursor()

    # Crée une table 'assets' si elle n'existe pas déjà
    cursor.execute('''
    CREATE TABLE IF NOT EXISTS assets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,  -- Identifiant unique auto-incrémenté
        url TEXT NOT NULL,                     -- URL de la page (non nulle)
        title TEXT,                            -- Titre de la page
        description TEXT                       -- Description meta de la page
    )
    ''')

    # Insère les données dans la table 'assets' en une seule opération
    cursor.executemany(
        'INSERT INTO assets (url, title, description) VALUES (?, ?, ?)', 
        data_list
    )

    # Valide les transactions dans la base de données
    conn.commit()
    # Ferme la connexion à la base de données
    conn.close()

def main():
    """
    Fonction principale qui orchestre le processus de scraping et de stockage des données.
    """
    # URL du sitemap à récupérer
    sitemap_url = 'https://readi.fi/sitemap.xml'

    # Récupère le contenu du sitemap XML
    sitemap_xml = get_sitemap_xml(sitemap_url)

    # Parse le sitemap pour extraire les URLs des assets
    asset_urls = parse_sitemap(sitemap_xml)

    # Affiche le nombre total d'URLs d'assets trouvées
    print(f"Nombre total d'URLs d'assets trouvées : {len(asset_urls)}")

    # Liste pour stocker les données collectées
    data_list = []

    # Pour chaque URL d'asset
    for url in asset_urls:
        try:
            # Récupère le titre et la description de la page
            title, description = fetch_page_data(url)
            # Ajoute les données à la liste sous forme de tuple
            data_list.append((url, title, description))
        except Exception as e:
            # En cas d'erreur, affiche un message d'erreur avec l'URL concernée
            print(f"Erreur lors de la récupération de {url} : {e}")

    # Stocke toutes les données collectées dans la base de données
    store_in_db(data_list)

    # Indique que les données ont été stockées avec succès
    print("Données stockées avec succès.")

# Point d'entrée du script
if __name__ == '__main__':
    main()


# Evitez de commenter chaque ligne, le code doit être clair de lui même
# Concentrez vous sur la documentation des fonctions (avec les docstrings
# comme vous l'avez fait) afin d'expliquer comment se servir de la fonction et non
# ce qu'elle fait (ce qui doit être le plus évident possible dans le code en lui même)