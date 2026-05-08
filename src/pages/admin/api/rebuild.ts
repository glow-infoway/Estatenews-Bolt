import type { APIRoute } from 'astro';
import { createClient } from '@supabase/supabase-js';

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL;
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY;

export const POST: APIRoute = async ({ request }) => {
  const authToken = request.headers.get('Authorization')?.replace('Bearer ', '');
  if (!authToken) return new Response(JSON.stringify({ error: 'Unauthorized' }), { status: 401 });

  // Verify the user is authenticated
  const supabase = createClient(supabaseUrl, supabaseAnonKey);
  const { data: { user }, error } = await supabase.auth.getUser(authToken);

  if (error || !user) {
    return new Response(JSON.stringify({ error: 'Invalid session' }), { status: 401 });
  }

  // Trigger the rebuild edge function
  try {
    const rebuildUrl = `${supabaseUrl}/functions/v1/rebuild-site`;
    const res = await fetch(rebuildUrl, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${authToken}`,
        'Content-Type': 'application/json',
      },
    });

    if (!res.ok) {
      const data = await res.json();
      return new Response(JSON.stringify({ error: data.error || 'Rebuild failed' }), { status: 500 });
    }

    return new Response(JSON.stringify({ success: true, message: 'Deploy triggered. Commit pushed to GitHub.' }), {
      headers: { 'Content-Type': 'application/json' },
    });
  } catch (err: any) {
    return new Response(JSON.stringify({ error: err.message }), { status: 500 });
  }
};
