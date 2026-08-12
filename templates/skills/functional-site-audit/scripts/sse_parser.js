/*
 * sse_parser.js — parse a captured text/event-stream body into typed frames.
 * Run after a chat/streaming turn. Pass the response string (e.g. the last
 * __chatLog entry's resBody). Handles both `data: {...}` frames and a trailing
 * structured JSON object (some backends emit {"result":{...}} after the stream).
 */
function parseSSE(raw) {
  const frames = [];
  for (const line of raw.split('\n\n')) {
    if (!line.startsWith('data: ')) continue;
    const payload = line.slice(6);
    try { frames.push(JSON.parse(payload).message ?? JSON.parse(payload)); }
    catch (e) { frames.push({ _raw: payload.slice(0, 120) }); }
  }
  // typed-frame rollup
  const counts = {};
  frames.forEach(f => { const t = (f && f.type) || '_'; counts[t] = (counts[t] || 0) + 1; });
  // structured tail, if any
  let structured = null;
  const idx = raw.indexOf('{"result"');
  if (idx > -1) { try { structured = JSON.parse(raw.slice(idx)).result; } catch (e) {} }
  // concatenated text (the narration)
  const text = frames.filter(f => f && f.type === 'text').map(f => f.content || '').join('');
  return { typeCounts: counts, text, structuredKeys: structured ? Object.keys(structured) : null, structured };
}
// Usage in javascript_tool: parseSSE(window.__chatLog.at(-1).resBody)
