/*
 * fetch_interceptor.js — network sensor for functional audits.
 * Paste into the page via javascript_tool BEFORE interacting.
 *
 * Rules that matter:
 *  - ALWAYS read the response via res.clone().text(). NEVER touch res.body /
 *    getReader() on the original response — it consumes the stream and BREAKS
 *    the page render.
 *  - Responses can be huge (catalogs, SSE). Cap what you keep (window.__cap)
 *    and store resLen so you know if you truncated. If you need the full
 *    structured tail, raise __cap and resend a SIMPLE query rather than
 *    fighting a giant response.
 *  - Filters out static assets + analytics noise, keeps first-party API.
 *    Tune the `isApi` test / `keep` substring per site.
 */
(function () {
  window.__chatLog = window.__chatLog || [];
  window.__cap = window.__cap || 30000;
  const keep = null; // e.g. 'cloudfunctions' or '/api/' to hard-filter to one endpoint
  const isStatic = u => /\.(png|jpe?g|webp|svg|gif|css|woff2?|js|ico)(\?|$)/.test(u);
  const isNoise  = u => /google-analytics|googletagmanager|analytics\.tiktok|rudderstack|segment|sentry|statsig/.test(u);

  const of = window.fetch;
  window.fetch = async function (input, init) {
    const url = typeof input === 'string' ? input : (input && input.url) || '';
    const wanted = keep ? url.includes(keep) : (!isStatic(url) && !isNoise(url));
    let entry = null;
    if (wanted) {
      entry = { t: Date.now(), url: url.slice(0, 200), method: (init && init.method) || 'GET',
                reqBody: init && init.body ? String(init.body).slice(0, 4000) : null };
      window.__chatLog.push(entry);
    }
    const res = await of.apply(this, arguments);
    if (entry) {
      entry.status = res.status;
      entry.ctype = res.headers.get('content-type');
      try { res.clone().text().then(t => { entry.resBody = t.slice(0, window.__cap); entry.resLen = t.length; }); } catch (e) {}
    }
    return res;
  };

  // XHR
  const os = XMLHttpRequest.prototype.send, oo = XMLHttpRequest.prototype.open;
  XMLHttpRequest.prototype.open = function (m, u) { this.__u = u; this.__m = m; return oo.apply(this, arguments); };
  XMLHttpRequest.prototype.send = function (b) {
    const u = this.__u || '';
    if (u && (keep ? u.includes(keep) : (!isStatic(u) && !isNoise(u)))) {
      const e = { t: Date.now(), url: String(u).slice(0, 200), method: this.__m, reqBody: b ? String(b).slice(0, 4000) : null, via: 'xhr' };
      window.__chatLog.push(e);
      this.addEventListener('load', () => { e.status = this.status; try { e.resBody = String(this.responseText).slice(0, window.__cap); e.resLen = (this.responseText || '').length; } catch (x) {} });
    }
    return os.apply(this, arguments);
  };

  // WebSocket
  const OW = window.WebSocket; window.__wsLog = window.__wsLog || [];
  window.WebSocket = function (url, proto) { window.__wsLog.push({ url: String(url).slice(0, 150), t: Date.now() }); return new OW(url, proto); };
  window.WebSocket.prototype = OW.prototype;

  return 'interceptor installed (fetch+xhr+ws); read window.__chatLog';
})();
