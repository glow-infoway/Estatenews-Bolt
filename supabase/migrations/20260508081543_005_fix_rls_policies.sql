/*
  # Fix RLS Policies - Remove overly permissive INSERT policies

  1. Security Changes
    - Drop "Anyone can insert projects" policy (anon should NOT insert)
    - Drop "Anyone can insert collections" policy (anon should NOT insert)
    - Drop "Anyone can insert collection projects" policy (anon should NOT insert)
    - Keep authenticated INSERT policies
    - Keep SELECT policies for anon+authenticated (read-only for anon)
    - Keep authenticated UPDATE/DELETE policies
*/

-- Remove overly permissive INSERT policies
DROP POLICY IF EXISTS "Anyone can insert projects" ON projects;
DROP POLICY IF EXISTS "Anyone can insert collections" ON collections;
DROP POLICY IF EXISTS "Anyone can insert collection projects" ON collection_projects;
