-- ============================================================
-- GLOBAL BUSINESS SMART — Script de configuration Supabase
-- Version complète (sociétés + tous les modules de gestion)
-- À copier-coller UNE SEULE FOIS dans Supabase → SQL Editor → Run
-- ============================================================

-- Si tu avais déjà exécuté une ancienne version du script, tu peux
-- décommenter les lignes suivantes pour repartir propre (⚠️ efface tout) :
-- drop table if exists gbs_companies, gbs_produits, gbs_ventes, gbs_depenses,
--   gbs_employes, gbs_presences, gbs_clients, gbs_factures, gbs_mobilemoney,
--   gbs_carte, gbs_paiements_salaires cascade;

-- 1) Sociétés (accès par email, sans mot de passe)
create table if not exists gbs_companies (
  id text primary key,
  nom_societe text,
  email text unique,
  plan text default '1',
  statut_abonnement text default 'essai',
  date_creation timestamptz default now()
);

-- 2) Catalogue produits / services
create table if not exists gbs_produits (
  id text primary key,
  company_id text references gbs_companies(id) on delete cascade,
  categorie text,
  nom text,
  prix numeric default 0,
  prix_achat numeric default 0,
  unite text,
  stock numeric default 0,
  stock_min numeric default 0,
  notes text,
  created_at timestamptz default now()
);

-- 3) Ventes
create table if not exists gbs_ventes (
  id text primary key,
  company_id text references gbs_companies(id) on delete cascade,
  date date,
  categorie text,
  produit text,
  qte numeric,
  prix numeric,
  total numeric,
  client text,
  client_num text,
  mode text,
  statut text,
  created_at timestamptz default now()
);

-- 4) Dépenses
create table if not exists gbs_depenses (
  id text primary key,
  company_id text references gbs_companies(id) on delete cascade,
  date date,
  categorie text,
  description text,
  montant numeric,
  created_at timestamptz default now()
);

-- 5) Employés
create table if not exists gbs_employes (
  id text primary key,
  company_id text references gbs_companies(id) on delete cascade,
  nom text,
  poste text,
  telephone text,
  salaire numeric default 0,
  mode_salaire text,
  date_embauche date,
  contrat text,
  created_at timestamptz default now()
);

-- 6) Présences
create table if not exists gbs_presences (
  id text primary key,
  company_id text references gbs_companies(id) on delete cascade,
  date date,
  emp_id text,
  statut text,
  created_at timestamptz default now()
);

-- 7) Clients
create table if not exists gbs_clients (
  id text primary key,
  company_id text references gbs_companies(id) on delete cascade,
  nom text,
  telephone text,
  email text,
  ville text,
  notes text,
  total_achete numeric default 0,
  nb_achats numeric default 0,
  created_at timestamptz default now()
);

-- 8) Factures
create table if not exists gbs_factures (
  id text primary key,
  company_id text references gbs_companies(id) on delete cascade,
  num text,
  client text,
  produit text,
  qte text,
  total numeric,
  date_facture timestamptz default now(),
  created_at timestamptz default now()
);

-- 9) Mobile Money
create table if not exists gbs_mobilemoney (
  id text primary key,
  company_id text references gbs_companies(id) on delete cascade,
  date date,
  operateur text,
  numero text,
  montant numeric,
  client text,
  ref text,
  created_at timestamptz default now()
);

-- 10) Carte bancaire
create table if not exists gbs_carte (
  id text primary key,
  company_id text references gbs_companies(id) on delete cascade,
  date date,
  type text,
  montant numeric,
  client text,
  ref text,
  banque text,
  created_at timestamptz default now()
);

-- 11) Paiements de salaires
create table if not exists gbs_paiements_salaires (
  id text primary key,
  company_id text references gbs_companies(id) on delete cascade,
  emp_id text,
  nom text,
  montant numeric,
  date_paiement timestamptz default now(),
  created_at timestamptz default now()
);

-- Pas de mot de passe, pas de RLS complexe : chaque société ne charge que
-- ses propres données car l'application filtre toujours par company_id.
alter table gbs_companies disable row level security;
alter table gbs_produits disable row level security;
alter table gbs_ventes disable row level security;
alter table gbs_depenses disable row level security;
alter table gbs_employes disable row level security;
alter table gbs_presences disable row level security;
alter table gbs_clients disable row level security;
alter table gbs_factures disable row level security;
alter table gbs_mobilemoney disable row level security;
alter table gbs_carte disable row level security;
alter table gbs_paiements_salaires disable row level security;

-- ============================================================
-- FIN. Une fois exécuté, l'application est prête : chaque société
-- créée aura son propre espace isolé avec tous les modules.
-- ============================================================
