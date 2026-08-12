/*
 * extract_geo_schema.js — capture the machine-presentation / GEO surface.
 * Run via javascript_tool. Returns JSON-LD blocks, meta/OG tags, heading
 * outline, and hints. Pair with manual checks of /robots.txt, /sitemap.xml,
 * /llms.txt (fetch those separately).
 */
(function () {
  const jsonld = [...document.querySelectorAll('script[type="application/ld+json"]')]
    .map(s => { try { return JSON.parse(s.textContent); } catch (e) { return { _parseError: s.textContent.slice(0, 80) }; } });
  const ldTypes = jsonld.flatMap(o => Array.isArray(o) ? o.map(x => x['@type']) : [o['@type']]).filter(Boolean);

  const metas = {};
  document.querySelectorAll('meta[property], meta[name]').forEach(m => {
    const k = m.getAttribute('property') || m.getAttribute('name');
    if (/^(og:|twitter:|description|robots|author|keywords)/.test(k)) metas[k] = (m.getAttribute('content') || '').slice(0, 120);
  });

  const outline = [...document.querySelectorAll('h1,h2,h3')].slice(0, 40)
    .map(h => `${h.tagName} ${h.textContent.trim().slice(0, 60)}`);

  const links = {};
  ['canonical', 'alternate'].forEach(rel => {
    const l = document.querySelector(`link[rel="${rel}"]`);
    if (l) links[rel] = l.href;
  });

  return JSON.stringify({
    jsonldCount: jsonld.length, ldTypes,
    jsonldSample: jsonld[0] || null,
    meta: metas, links,
    headingOutline: outline,
    hint: 'Also fetch /robots.txt (GPTBot/Google-Extended/PerplexityBot), /sitemap.xml, /llms.txt separately'
  }, null, 1).slice(0, 6000);
})();
