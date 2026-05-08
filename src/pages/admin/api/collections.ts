import type { APIRoute } from 'astro';
import { createClient } from '@supabase/supabase-js';

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL;
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY;

function getAuthClient(authToken: string) {
  return createClient(supabaseUrl, supabaseAnonKey, {
    global: { headers: { Authorization: `Bearer ${authToken}` } },
  });
}

export const GET: APIRoute = async ({ request, url }) => {
  const authToken = request.headers.get('Authorization')?.replace('Bearer ', '');
  if (!authToken) return new Response(JSON.stringify({ error: 'Unauthorized' }), { status: 401 });

  const collectionId = url.searchParams.get('collection_id');
  if (!collectionId) return new Response(JSON.stringify({ error: 'Missing collection_id' }), { status: 400 });

  const client = getAuthClient(authToken);
  const { data } = await client.from('collection_projects').select('project_id').eq('collection_id', collectionId);
  const ids = (data || []).map((r: any) => r.project_id);

  return new Response(JSON.stringify(ids), { headers: { 'Content-Type': 'application/json' } });
};

export const POST: APIRoute = async ({ request }) => {
  const authToken = request.headers.get('Authorization')?.replace('Bearer ', '');
  if (!authToken) return new Response(JSON.stringify({ error: 'Unauthorized' }), { status: 401 });

  const body = await request.json();
  const projectIds: string[] = body.project_ids;
  delete body.project_ids;

  const client = getAuthClient(authToken);
  const { data, error } = await client.from('collections').insert(body).select().single();

  if (error) return new Response(JSON.stringify({ error: error.message }), { status: 400 });

  if (projectIds?.length && data) {
    await client.from('collection_projects').insert(projectIds.map((pid: string) => ({ collection_id: data.id, project_id: pid })));
  }

  return new Response(JSON.stringify(data), { headers: { 'Content-Type': 'application/json' } });
};

export const PUT: APIRoute = async ({ request, url }) => {
  const authToken = request.headers.get('Authorization')?.replace('Bearer ', '');
  if (!authToken) return new Response(JSON.stringify({ error: 'Unauthorized' }), { status: 401 });

  const id = url.searchParams.get('id');
  if (!id) return new Response(JSON.stringify({ error: 'Missing id' }), { status: 400 });

  const body = await request.json();
  const projectIds: string[] = body.project_ids;
  delete body.project_ids;

  const client = getAuthClient(authToken);
  const { data, error } = await client.from('collections').update(body).eq('id', id).select().single();

  if (error) return new Response(JSON.stringify({ error: error.message }), { status: 400 });

  // Update collection_projects
  if (projectIds !== undefined) {
    await client.from('collection_projects').delete().eq('collection_id', id);
    if (projectIds.length > 0) {
      await client.from('collection_projects').insert(projectIds.map((pid: string) => ({ collection_id: id, project_id: pid })));
    }
  }

  return new Response(JSON.stringify(data), { headers: { 'Content-Type': 'application/json' } });
};

export const DELETE: APIRoute = async ({ request, url }) => {
  const authToken = request.headers.get('Authorization')?.replace('Bearer ', '');
  if (!authToken) return new Response(JSON.stringify({ error: 'Unauthorized' }), { status: 401 });

  const id = url.searchParams.get('id');
  if (!id) return new Response(JSON.stringify({ error: 'Missing id' }), { status: 400 });

  const client = getAuthClient(authToken);
  await client.from('collection_projects').delete().eq('collection_id', id);
  const { error } = await client.from('collections').delete().eq('id', id);

  if (error) return new Response(JSON.stringify({ error: error.message }), { status: 400 });
  return new Response(JSON.stringify({ success: true }), { headers: { 'Content-Type': 'application/json' } });
};
