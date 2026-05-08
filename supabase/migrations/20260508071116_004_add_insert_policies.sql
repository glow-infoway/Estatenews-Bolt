/*
  # Add insert policies for seeding data

  1. Security Changes
    - Add INSERT policy on `projects` for anon and authenticated users
    - Add INSERT policy on `collections` for anon and authenticated users
    - Add INSERT policy on `collection_projects` for anon and authenticated users

  Note: These policies allow inserts which is needed for data seeding.
  In production, you may want to restrict these to service role only.
*/

CREATE POLICY "Anyone can insert projects"
  ON projects FOR INSERT
  TO anon, authenticated
  WITH CHECK (true);

CREATE POLICY "Anyone can insert collections"
  ON collections FOR INSERT
  TO anon, authenticated
  WITH CHECK (true);

CREATE POLICY "Anyone can insert collection projects"
  ON collection_projects FOR INSERT
  TO anon, authenticated
  WITH CHECK (true);
