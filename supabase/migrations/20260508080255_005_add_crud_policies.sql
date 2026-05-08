/*
  # Add CRUD policies for authenticated users

  1. Security Changes
    - Add INSERT, UPDATE, DELETE policies on `cities` for authenticated users
    - Add INSERT, UPDATE, DELETE policies on `projects` for authenticated users
    - Add INSERT, UPDATE, DELETE policies on `collections` for authenticated users
    - Add INSERT, UPDATE, DELETE policies on `collection_projects` for authenticated users

  These policies allow authenticated admin users to manage all data.
  Unauthenticated users can only read (existing SELECT policies remain).
*/

-- Cities CRUD
CREATE POLICY "Authenticated can insert cities"
  ON cities FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Authenticated can update cities"
  ON cities FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Authenticated can delete cities"
  ON cities FOR DELETE
  TO authenticated
  USING (true);

-- Projects CRUD
CREATE POLICY "Authenticated can insert projects"
  ON projects FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Authenticated can update projects"
  ON projects FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Authenticated can delete projects"
  ON projects FOR DELETE
  TO authenticated
  USING (true);

-- Collections CRUD
CREATE POLICY "Authenticated can insert collections"
  ON collections FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Authenticated can update collections"
  ON collections FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Authenticated can delete collections"
  ON collections FOR DELETE
  TO authenticated
  USING (true);

-- Collection Projects CRUD
CREATE POLICY "Authenticated can insert collection projects"
  ON collection_projects FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Authenticated can update collection projects"
  ON collection_projects FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Authenticated can delete collection projects"
  ON collection_projects FOR DELETE
  TO authenticated
  USING (true);
