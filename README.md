# Nextro Template

Gem fournissant le template admin **Nextro** (Bootstrap 4) pour applications Rails : layout, concerns CRUD, helpers, générateurs et assets.

**Source :** [github.com/itw-liege/nextro-template](https://github.com/itw-liege/nextro-template)

---

## Installation

### 1. Ajouter la gem au Gemfile

```ruby
# Depuis GitHub
gem "nextro_template", github: "itw-liege/nextro-template"

# Ou depuis un dépôt Git (branche/tag)
# gem "nextro_template", git: "https://github.com/VOTRE_ORG/nextro_template.git"
# gem "nextro_template", git: "https://github.com/VOTRE_ORG/nextro_template.git", branch: "main"
# gem "nextro_template", git: "https://github.com/VOTRE_ORG/nextro_template.git", tag: "v1.0.0"

# Ou en local pour le développement
# gem "nextro_template", path: "gems/nextro_template"
```

### 2. Dépendances requises

```ruby
gem "devise"
gem "breadcrumbs_on_rails"
gem "bootstrap", "~> 4.0"
gem "bootstrap_form", "~> 4.0"
gem "jquery-rails"  # requis par nextro.js (Bootstrap, DataTables)
```

### 3. Installer

```bash
bundle install
rails generate nextro_template:install
```

La commande `rails generate nextro_template:install` :

- copie les assets (stylesheets, javascripts) dans votre projet
- crée le contrôleur admin et le dashboard
- ajoute les routes
- crée un initializer pour la précompilation des assets
- crée le partial du menu (sidebar) à personnaliser

---

## Configuration manuelle (si vous n'utilisez pas le générateur)

### Gemfile

```ruby
gem "nextro_template", github: "itw-liege/nextro-template"
gem "devise"
gem "breadcrumbs_on_rails"
gem "bootstrap", "~> 4.0"
gem "bootstrap_form", "~> 4.0"
gem "jquery-rails"
```

### Routes – `config/routes.rb`

```ruby
namespace :admin do
  root to: "dashboard#index"
  resources :admin, only: [], controller: "admin" do
    get :set_language, on: :collection
  end
  # Vos ressources (users, categories, etc.)
end
```

### Assets – `config/initializers/assets.rb` ou `config/initializers/nextro_template_assets.rb`

```ruby
Rails.application.config.assets.precompile += %w[nextro_template.css nextro.js nextro-datatables.js]
```

### Layout – `app/views/layouts/admin.html.erb`

Le layout `admin` est fourni par la gem. Assurez-vous que votre `Admin::AdminController` utilise `layout "admin"`.

### Controller Admin – `app/controllers/admin/admin_controller.rb`

```ruby
require "nextro_template"

class Admin::AdminController < ApplicationController
  include Nextro::PageTitleConcern
  include Nextro::CurrentControllerConcern

  before_action :authenticate_user!

  add_breadcrumb I18n.t("nextro.breadcrumbs.dashboard"), [:admin, :root]

  layout "admin"

  helper "admin/table"
  helper "admin/menu"
  helper "application/bootstrap"

  def set_language
    current_user.update(language: params[:language]) if params[:language].present?
    I18n.locale = params[:language] || I18n.default_locale
    redirect_back(fallback_location: root_path)
  end
end
```

### Application CSS – inclure les styles Nextro

Dans `app/assets/stylesheets/application.scss` (ou équivalent) :

```scss
@import "nextro_template";
```

Ou dans le layout admin, la gem charge automatiquement `nextro_template.css` si vous utilisez `stylesheet_link_tag "nextro_template"`.

---

## Page de connexion (Devise)

Le layout `devise` applique le design Nextro (fond sombre, carte centrée) aux pages Devise (login, mot de passe oublié, etc.). Le générateur configure automatiquement `ApplicationController` pour utiliser ce layout. Personnalisez les vues si besoin :

```bash
rails g devise:views
```

---

## Menu (sidebar)

Le partial `admin/admin/_sidebar_left.html.erb` peut être personnalisé. Exemple :

```erb
<div class="navbar-content ps">
  <ul class="pc-navbar">
    <%= menu_title("Menu", "Sous-titre") %>
    <%= menu_link("Dashboard", [:admin, :root], "dashboard", "fa-home") %>
    <%= menu_link("Utilisateurs", [:admin, :users], "users", "fa-user-friends") %>
    <%# Menu déroulant : %>
    <%#= drop_menu "Configuration", "fa-cog", [
    <%#   menu_link("Catégories", [:admin, :categories], "categories", "fa-th-large"),
    <%#   menu_link("Sections", [:admin, :sections], "sections", "fa-th"),
    <%# ], ["category", "section"] %>
  </ul>
</div>
```

---

## Générateur CRUD

Générer un CRUD complet :

```bash
rails generate nextro_template:admin:crud category name:string description:text
```

Puis ajouter l’entrée dans le menu `_sidebar_left.html.erb` :

```erb
<%= menu_link(t('admin.categories.sidebar_left_title'), [:admin, :categories], "categories", "fa-th-large") %>
```

---

## Modèles avec breadcrumb

Pour les breadcrumbs dynamiques, inclure `BreadcrumbdableConcern` :

```ruby
class Category < ApplicationRecord
  include BreadcrumbdableConcern
end
```

---

## Publier la gem sur Git

### Créer le dépôt et pousser

```bash
cd gems/nextro_template
git init
git add .
git commit -m "Initial commit - Nextro Template v1.0.0"
git remote add origin https://github.com/VOTRE_ORG/nextro_template.git
git branch -M main
git push -u origin main
```

### Créer un tag (version stable)

```bash
git tag v1.0.0
git push origin v1.0.0
```

### Utiliser la gem depuis Git

```ruby
# Gemfile
gem "nextro_template", git: "https://github.com/VOTRE_ORG/nextro_template.git"
gem "nextro_template", git: "https://github.com/VOTRE_ORG/nextro_template.git", tag: "v1.0.0"
```

---

## JavaScript et design

La gem charge automatiquement :
- **DataTables** (recherche, tri, pagination) pour les tableaux avec la classe `.nextro-datatable`
- **Font Awesome** pour les icônes (boutons edit/delete, menu)
- **Dashboard** avec une carte statistique Utilisateurs (couleur primaire)

---

## Personnalisation (couleurs, polices, boutons)

### Fichier personnalisé : `app/assets/stylesheets/nextro_template/_custom.scss`

Ce fichier est créé automatiquement lors de l'installation. Il est chargé en dernier et permet de surcharger les styles sans modifier les fichiers de la gem.

### Couleurs

Les couleurs sont définies dans `_variables.scss`. Pour les modifier, surchargez ou éditez `_variables.scss` :

```scss
// app/assets/stylesheets/nextro_template/_variables.scss
:root {
  --primary-color: #14566b;        // Couleur principale (boutons, liens actifs)
  --primary-color-hover: #0d3d4d;
  --login-bg: #0f0e18;
  --sidebar-color-bg: #0f0e18;
  --nav-top-color: #16161e;
}
```

Ou dans `_custom.scss` :

```scss
:root {
  --primary-color: #14566b;
  --primary-color-hover: #0d3d4d;
}
```

### Couleurs des boutons

```scss
// Dans _custom.scss
.btn-primary {
  background-color: var(--primary-color);
  border-color: var(--primary-color);
  &:hover {
    background-color: var(--primary-color-hover);
    border-color: var(--primary-color-hover);
  }
}

.btn-success { background-color: #28a745; border-color: #28a745; }
.btn-danger { background-color: #dc3545; border-color: #dc3545; }
```

### Police

1. Ajoutez la police dans `app/views/layouts/admin.html.erb` (dans `<head>`) :

```html
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
```

2. Surchargez dans `_custom.scss` :

```scss
body {
  font-family: "Inter", "Segoe UI", sans-serif;
}
```

### Ajouter des cartes au dashboard

Éditez `app/views/admin/dashboard/index.html.erb` pour ajouter vos statistiques (ex. : Items, Catégories, Sections) en copiant le bloc de la carte Utilisateurs.

---

## Structure fournie par la gem

| Élément | Description |
|--------|-------------|
| `layouts/admin` | Layout principal admin |
| `admin/admin/_sidebar_left` | Menu latéral (à personnaliser) |
| `admin/admin/_breadcrumb` | Fil d'Ariane |
| `admin/admin/_account_item` | Menu utilisateur (Devise) |
| Helpers | BootstraptHelper, TableHelper, MenuHelper |
| Concerns | CrudableConcern, PageTitleConcern, CurrentControllerConcern |
| Locales | fr, en (`nextro.*`) |
| Assets | SCSS layout, JS DataTables |

---

## Documentation complémentaire

- [Guide Git et publication](doc/UTILISATION.md) – Mise en ligne sur Git, tags, mise à jour

## Licence

MIT
