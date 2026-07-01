-- ============================================================
-- GLOBAL BUSINESS SMART — Script de configuration Supabase
-- Version simplifiée SANS mot de passe (accès par email uniquement)
-- À copier-coller UNE SEULE FOIS dans Supabase → SQL Editor → Run
-- ============================================================

-- Si tu as déjà exécuté une ancienne version du script, supprime d'abord
-- l'ancienne table (décommente la ligne suivante si besoin) :
-- drop table if exists gbs_companies;

create table if not exists gbs_companies (
  id text primary key,
  nom_societe text,
  email text unique,
  plan text default '1',                 -- '1' = 75€, '2' = 150€, '5' = 210€
  statut_abonnement text default 'essai', -- essai / actif / impaye / annule
  date_creation timestamptz default now()
);

-- Pas de mot de passe : l'accès se fait par email uniquement.
-- La table reste ouverte en lecture/écriture avec la clé publique de l'app.
alter table gbs_companies disable row level security;

-- ============================================================
-- FIN. Une fois exécuté, l'application peut créer et retrouver
-- des espaces sans aucune configuration supplémentaire.
-- ============================================================
