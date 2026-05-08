export interface City {
  id: string;
  name: string;
  slug: string;
  state: string;
  hero_image: string;
  overview: string;
  meta_title: string;
  meta_description: string;
  created_at: string;
}

export interface Project {
  id: string;
  city_id: string;
  project_type: 'residential' | 'commercial';
  title: string;
  slug: string;
  builder_name: string;
  builder_phone: string;
  location: string;
  short_description: string;
  full_description: string;
  featured_image: string;
  gallery_images: string[];
  amenities: string[];
  highlights: string[];
  price_range: string;
  possession_date: string;
  project_status: 'new-launch' | 'under-construction' | 'ready-to-move';
  floor_plans: FloorPlan[];
  brochure_url: string;
  rera_number: string;
  latitude: number;
  longitude: number;
  meta_title: string;
  meta_description: string;
  published_at: string;
  created_at: string;
  city?: City;
}

export interface FloorPlan {
  name: string;
  size: string;
  price: string;
}

export interface Collection {
  id: string;
  title: string;
  slug: string;
  city_id: string | null;
  collection_type: string;
  intro_content: string;
  meta_title: string;
  meta_description: string;
  created_at: string;
  city?: City;
  projects?: Project[];
}

export interface Database {
  public: {
    Tables: {
      cities: {
        Row: City;
        Insert: Omit<City, 'id' | 'created_at'>;
        Update: Partial<Omit<City, 'id' | 'created_at'>>;
      };
      projects: {
        Row: Project;
        Insert: Omit<Project, 'id' | 'created_at'>;
        Update: Partial<Omit<Project, 'id' | 'created_at'>>;
      };
      collections: {
        Row: Collection;
        Insert: Omit<Collection, 'id' | 'created_at'>;
        Update: Partial<Omit<Collection, 'id' | 'created_at'>>;
      };
      collection_projects: {
        Row: {
          id: string;
          collection_id: string;
          project_id: string;
        };
        Insert: {
          collection_id: string;
          project_id: string;
        };
        Update: Partial<{
          collection_id: string;
          project_id: string;
        }>;
      };
    };
  };
}
