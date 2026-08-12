/*
 * extract_design_tokens.js — pull a design-language fingerprint from a live page.
 * Run via javascript_tool. Returns palette, type scale, spacing, radii, shadows,
 * CSS variables, and the motion vocabulary (transitions + @keyframes/easing).
 * Feeds the COMPANION design-motion deliverable — never the functional analysis.
 */
(function () {
  const els = [...document.querySelectorAll('body *')].slice(0, 4000);
  const tally = (arr) => Object.entries(arr.reduce((m, v) => (v && (m[v] = (m[v] || 0) + 1), m), {}))
    .sort((a, b) => b[1] - a[1]).slice(0, 24).map(([v, n]) => ({ v, n }));

  const colors = [], bgs = [], fonts = [], sizes = [], weights = [],
        radii = [], shadows = [], transitions = [], easings = [];
  for (const el of els) {
    const s = getComputedStyle(el);
    colors.push(s.color); bgs.push(s.backgroundColor);
    fonts.push(s.fontFamily); sizes.push(s.fontSize); weights.push(s.fontWeight);
    if (s.borderRadius && s.borderRadius !== '0px') radii.push(s.borderRadius);
    if (s.boxShadow && s.boxShadow !== 'none') shadows.push(s.boxShadow.slice(0, 60));
    if (s.transition && s.transition !== 'all 0s ease 0s') transitions.push(s.transition.slice(0, 80));
    if (s.transitionTimingFunction && s.transitionTimingFunction !== 'ease') easings.push(s.transitionTimingFunction);
  }

  // CSS custom properties from :root
  const rootStyle = getComputedStyle(document.documentElement);
  const vars = {};
  for (let i = 0; i < rootStyle.length; i++) {
    const p = rootStyle[i];
    if (p.startsWith('--')) vars[p] = rootStyle.getPropertyValue(p).trim().slice(0, 40);
  }

  // @keyframes names from stylesheets (best-effort; cross-origin sheets may throw)
  const keyframes = new Set();
  for (const sheet of document.styleSheets) {
    try { for (const r of sheet.cssRules) if (r.type === CSSRule.KEYFRAMES_RULE) keyframes.add(r.name); }
    catch (e) {}
  }

  return JSON.stringify({
    palette: { text: tally(colors), background: tally(bgs) },
    type: { families: tally(fonts), sizes: tally(sizes), weights: tally(weights) },
    radii: tally(radii), shadows: tally(shadows),
    motion: { transitions: tally(transitions), easings: tally(easings), keyframes: [...keyframes].slice(0, 30) },
    cssVars: vars
  }, null, 1).slice(0, 6000);
})();
