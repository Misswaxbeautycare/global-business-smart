-- ============================================================
-- GLOBAL BUSINESS SMART — Script de configuration Supabase
-- À copier-coller UNE SEULE FOIS dans Supabase → SQL Editor → Run
-- ============================================================

-- 1) Table des sociétés (une ligne = une société inscrite)
create table if not exists gbs_companies (
  id uuid primary key references auth.users(id) on delete cascade,
  nom_societe text,
  email text,
  plan text default '1',                 -- '1' = 75€, '2' = 150€, '5' = 210€
  statut_abonnement text default 'essai', -- essai / actif / impaye / annule
  date_creation timestamptz default now()
);

-- 2) Sécurité : chaque société ne voit et ne modifie que sa propre ligne
alter table gbs_companies enable row level security;

create policy "voir sa propre societe"
on gbs_companies for select
using (auth.uid() = id);

create policy "modifier sa propre societe"
on gbs_companies for update
using (auth.uid() = id);

create policy "creer sa propre societe"
on gbs_companies for insert
with check (auth.uid() = id);

-- 3) Accès Admin : remplace l'email ci-dessous par le TIEN
--    (le même email doit aussi être mis dans index.html, variable ADMIN_EMAIL)
create policy "admin voit toutes les societes"
on gbs_companies for select
using (auth.jwt() ->> 'email' = 'missnyunge@gmail.com');

create policy "admin modifie toutes les societes"
on gbs_companies for update
using (auth.jwt() ->> 'email' = 'missnyunge@gmail.com');

-- ============================================================
-- FIN — après avoir exécuté ce script, remplace aussi
-- ADMIN_EMAIL dans index.html par ce même email.
-- ============================================================
