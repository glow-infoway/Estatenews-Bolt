/*
  # Create collections table

  1. New Tables
    - `collections`
      - `id` (uuid, primary key)
      - `title` (text, not null) - Collection title
      - `slug` (text, unique, not null) - URL slug
      - `city_id` (uuid, FK to cities) - City reference
      - `collection_type` (text) - Type of collection
      - `intro_content` (text) - SEO intro content
      - `meta_title` (text) - SEO meta title
      - `meta_description` (text) - SEO meta description
      - `created_at` (timestamptz) - Creation timestamp

  2. New Tables
    - `collection_projects`
      - `id` (uuid, primary key)
      - `collection_id` (uuid, FK to collections) - Collection reference
      - `project_id` (uuid, FK to projects) - Project reference

  3. Security
    - Enable RLS on both tables
    - Add read policies for anyone
*/

CREATE TABLE IF NOT EXISTS collections (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  slug text UNIQUE NOT NULL,
  city_id uuid REFERENCES cities(id) ON DELETE SET NULL,
  collection_type text DEFAULT 'general',
  intro_content text DEFAULT '',
  meta_title text DEFAULT '',
  meta_description text DEFAULT '',
  created_at timestamptz DEFAULT now()
);

ALTER TABLE collections ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read collections"
  ON collections FOR SELECT
  TO anon, authenticated
  USING (true);

CREATE TABLE IF NOT EXISTS collection_projects (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  collection_id uuid NOT NULL REFERENCES collections(id) ON DELETE CASCADE,
  project_id uuid NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  UNIQUE(collection_id, project_id)
);

ALTER TABLE collection_projects ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read collection projects"
  ON collection_projects FOR SELECT
  TO anon, authenticated
  USING (true);

CREATE INDEX IF NOT EXISTS idx_collection_projects_collection ON collection_projects(collection_id);
CREATE INDEX IF NOT EXISTS idx_collection_projects_project ON collection_projects(project_id);
