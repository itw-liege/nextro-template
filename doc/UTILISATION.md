# Guide d'utilisation - Nextro Template

> Voir le [README](../README.md) pour la documentation complète (routes, assets, configuration).

## 1. Utiliser la gem dans un autre projet

### Option A : Depuis un chemin local (développement)

```ruby
# Gemfile
gem "nextro_template", path: "../ruby-on-rails-mega/gems/nextro_template"
```

### Option B : Depuis un dépôt Git (recommandé)

```ruby
# Gemfile
gem "nextro_template", git: "https://github.com/VOTRE_ORG/nextro_template.git"
# gem "nextro_template", git: "...", branch: "main"
# gem "nextro_template", git: "...", tag: "v1.0.0"
```

```bash
bundle install
rails generate nextro_template:install
```

La commande `install` copie les assets, crée les contrôleurs et configure les routes.

---

## 2. Publier la gem sur Git

### Étape 1 : Créer un dépôt Git

1. Créez un dépôt sur GitHub (ou GitLab, Bitbucket)
2. Copiez l’URL du repo (ex. `https://github.com/VOTRE_ORG/nextro_template.git`)

### Étape 2 : Initialiser et pousser la gem

```bash
cd gems/nextro_template

# Initialiser Git si pas déjà fait
git init

# Ajouter tous les fichiers
git add .

# Premier commit
git commit -m "Initial commit - Nextro Template v1.0.0"

# Ajouter le remote (remplacez par votre URL)
git remote add origin https://github.com/VOTRE_ORG/nextro_template.git

# Pousser sur la branche main
git branch -M main
git push -u origin main
```

### Étape 3 : Créer une version (tag)

Pour figer une version et l’utiliser dans le Gemfile :

```bash
git tag v1.0.0
git push origin v1.0.0
```

### Étape 4 : Fichier .gitignore

Assurez-vous d’avoir un `.gitignore` pour exclure :

```
*.gem
*.rbc
.bundle
.config
coverage
log/
tmp/
```

---

## 3. Installation complète dans un nouveau projet

### Prérequis

- Rails 6+
- MySQL/PostgreSQL (ou autre)

### 1. Ajouter la gem

```ruby
# Gemfile
gem "nextro_template", git: "https://github.com/VOTRE_ORG/nextro_template.git"

# Dépendances requises (si pas déjà présentes)
gem "devise"
gem "breadcrumbs_on_rails"
gem "bootstrap", "~> 4.0"
gem "bootstrap_form", "~> 4.0"
```

```bash
bundle install
```

### 2. Controller Admin de base

Créez ou adaptez `app/controllers/admin/admin_controller.rb` :

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
end
```

### 3. Routes

```ruby
# config/routes.rb
namespace :admin do
  root to: "dashboard#index"
  resources :admin do
    get :set_language, on: :collection
  end
  # vos ressources...
end
```

### 4. Assets

```ruby
# config/initializers/assets.rb
Rails.application.config.assets.precompile += %w[nextro_template.css nextro.js nextro-datatables.js]
```

Dans votre layout ou `application.html.erb`, la gem injecte automatiquement ses assets via le layout `admin`.

### 5. Personnaliser le menu

Surchargez le partial dans votre app :

```erb
<!-- app/views/admin/admin/_sidebar_left.html.erb -->
<div class="navbar-content ps">
  <ul class="pc-navbar">
    <%= menu_title("Menu", "Sous-titre") %>
    <%= menu_link("Dashboard", [:admin, :root], "dashboard", "fa-home") %>
    <%= menu_link("Utilisateurs", [:admin, :users], "users", "fa-user-friends") %>
    <!-- vos entrées de menu -->
  </ul>
</div>
```

### 6. Générer un CRUD

```bash
rails generate nextro_template:admin:crud category name:string description:text
```

---

## 4. Mise à jour depuis Git

Pour récupérer la dernière version depuis le dépôt :

```bash
bundle update nextro_template
```

Avec un tag :

```ruby
# Gemfile - pour une version figée
gem "nextro_template", git: "https://github.com/VOTRE_ORG/nextro_template.git", tag: "v1.0.0"
```

---

## 5. Structure des fichiers fournis par la gem

| Chemin | Description |
|--------|-------------|
| `layouts/admin` | Layout principal admin |
| `admin/admin/_sidebar_left` | Menu latéral (à surcharger) |
| `admin/admin/_breadcrumb` | Fil d'Ariane |
| `admin/admin/_account_item` | Menu utilisateur (Devise) |
| Helpers | BootstraptHelper, TableHelper, MenuHelper |
| Concerns | CrudableConcern, PageTitleConcern, etc. |
| Locales | fr, en (nextro.*) |
