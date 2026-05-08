/*
  # Create projects table

  1. New Tables
    - `projects`
      - `id` (uuid, primary key)
      - `city_id` (uuid, FK to cities) - City reference
      - `project_type` (text) - 'residential' or 'commercial'
      - `title` (text, not null) - Project title
      - `slug` (text, not null) - URL slug
      - `builder_name` (text) - Builder/developer name
      - `builder_phone` (text) - Builder contact
      - `location` (text) - Locality/area
      - `short_description` (text) - Brief description
      - `full_description` (text) - Detailed description
      - `featured_image` (text) - Main image URL
      - `gallery_images` (text[]) - Gallery image URLs
      - `amenities` (text[]) - List of amenities
      - `highlights` (text[]) - Project highlights
      - `price_range` (text) - Price range string
      - `possession_date` (text) - Expected possession
      - `project_status` (text) - 'new-launch', 'under-construction', 'ready-to-move'
      - `floor_plans` (jsonb) - Floor plan data
      - `brochure_url` (text) - Brochure download URL
      - `rera_number` (text) - RERA registration
      - `latitude` (numeric) - GPS latitude
      - `longitude` (numeric) - GPS longitude
      - `meta_title` (text) - SEO meta title
      - `meta_description` (text) - SEO meta description
      - `published_at` (timestamptz) - Publish date
      - `created_at` (timestamptz) - Creation timestamp

  2. Security
    - Enable RLS on `projects` table
    - Add policy for anyone to read published projects
*/

CREATE TABLE IF NOT EXISTS projects (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  city_id uuid NOT NULL REFERENCES cities(id) ON DELETE CASCADE,
  project_type text NOT NULL DEFAULT 'residential' CHECK (project_type IN ('residential', 'commercial')),
  title text NOT NULL,
  slug text NOT NULL,
  builder_name text DEFAULT '',
  builder_phone text DEFAULT '',
  location text DEFAULT '',
  short_description text DEFAULT '',
  full_description text DEFAULT '',
  featured_image text DEFAULT '',
  gallery_images text[] DEFAULT '{}',
  amenities text[] DEFAULT '{}',
  highlights text[] DEFAULT '{}',
  price_range text DEFAULT '',
  possession_date text DEFAULT '',
  project_status text DEFAULT 'under-construction' CHECK (project_status IN ('new-launch', 'under-construction', 'ready-to-move')),
  floor_plans jsonb DEFAULT '[]',
  brochure_url text DEFAULT '',
  rera_number text DEFAULT '',
  latitude numeric DEFAULT 0,
  longitude numeric DEFAULT 0,
  meta_title text DEFAULT '',
  meta_description text DEFAULT '',
  published_at timestamptz DEFAULT now(),
  created_at timestamptz DEFAULT now(),
  UNIQUE(city_id, slug)
);

ALTER TABLE projects ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read published projects"
  ON projects FOR SELECT
  TO anon, authenticated
  USING (true);

CREATE INDEX IF NOT EXISTS idx_projects_city_id ON projects(city_id);
CREATE INDEX IF NOT EXISTS idx_projects_type ON projects(project_type);
CREATE INDEX IF NOT EXISTS idx_projects_status ON projects(project_status);
CREATE INDEX IF NOT EXISTS idx_projects_slug ON projects(slug);
