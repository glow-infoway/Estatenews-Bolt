export async function GET() {
  const robotsTxt = `User-agent: *
Allow: /

Sitemap: https://propdiscover.com/sitemap-index.xml
`;
  return new Response(robotsTxt, {
    headers: { 'Content-Type': 'text/plain' },
  });
}
