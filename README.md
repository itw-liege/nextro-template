# Nextro Template

Gem complète fournissant le template admin **Nextro** (Bootstrap 4) pour applications Rails : layout, concerns CRUD, helpers, générateurs et assets.

## Installation

Ajoutez dans votre `Gemfile` :

```ruby
gem "nextro_template", path: "gems/nextro_template"
# ou depuis RubyGems :
# gem "nextro_template"
```

Puis :

```bash
bundle install
```

### Prérequis

- Rails 6+
- Bootstrap 4
- Devise (pour l'authentification et le menu utilisateur)
- breadcrumbs_on_rails
- bootstrap_form

## Utilisation

### 1. Controller Admin de base

Créez un `Admin::AdminController` incluant les concerns Nextro :

```ruby
# app/controllers/admin/admin_controller.rb
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

### 2. Layout et assets

Le layout `admin` et les partials (`_sidebar_left`, `_breadcrumb`, `_account_item`) sont fournis par la gem.

Dans votre `config/initializers/assets.rb` :

```ruby
Rails.application.config.assets.precompile += %w[nextro_template.css nextro.js nextro-datatables.js]
```

Dans le layout principal ou votre `application.html.erb`, incluez les assets fournis par la gem.

### 3. Générateur CRUD

Générez un CRUD admin complet :

```bash
rails generate nextro_template:admin:crud product name:string description:text price:decimal
```

### 4. Personnaliser le menu

Surchargez le partial `admin/admin/_sidebar_left.html.erb` dans votre app pour personnaliser le menu.

### 5. Modèles avec breadcrumb

Pour les breadcrumbs dynamiques, incluez `BreadcrumbdableConcern` dans vos modèles :

```ruby
class Category < ApplicationRecord
  include BreadcrumbdableConcern
end
```

## Structure fournie

- **Layout** : `admin.html.erb` (sidebar, header, breadcrumb)
- **Concerns** : `CrudableConcern`, `PageTitleConcern`, `CurrentControllerConcern`
- **Helpers** : `Admin::BootstraptHelper`, `Admin::TableHelper`, `Admin::MenuHelper`, `Application::BootstrapHelper`
- **Assets** : SCSS de base, JS DataTables
- **Locales** : fr, en

## Design complet Nextro

Pour le design complet du template Nextro (Phoenixcoded), ajoutez les assets Nextro dans votre application. La gem fournit une structure de base compatible.

## Documentation

- [Guide d'utilisation et publication Git](doc/UTILISATION.md) – Utilisation dans un autre projet et mise en ligne sur Git

## Licence

MIT
