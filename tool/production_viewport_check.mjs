import { chromium } from 'playwright';

const BASE = process.env.BASE_URL || 'https://sotong-save-live.web.app';

const ROUTES = [
  { path: '/', label: 'home' },
  { path: '/life-paths', label: 'life-paths' },
  {
    path: '/life-paths/childfree-couple-retirement',
    label: 'childfree-couple',
  },
  { path: '/roadmap', label: 'roadmap' },
  { path: '/money-work', label: 'money-work' },
  { path: '/health-life', label: 'health-life' },
  { path: '/rural', label: 'rural' },
  { path: '/housing-care', label: 'housing-care' },
  { path: '/mind-lounge', label: 'mind-lounge' },
  { path: '/mind-lounge/today-remains', label: 'mind-essay' },
  { path: '/legacy', label: 'legacy' },
  { path: '/life-paths/no-such-type', label: 'invalid-slug' },
];

async function checkViewport(name, width, height) {
  const browser = await chromium.launch({ headless: true });
  const page = await browser.newPage({ viewport: { width, height } });
  const errors = [];
  const networkFails = [];

  page.on('pageerror', (e) => errors.push(String(e)));
  page.on('console', (msg) => {
    if (msg.type() === 'error') {
      const t = msg.text();
      if (t.includes('Google Fonts') || t.includes('fonts.gstatic')) return;
      errors.push(t);
    }
  });
  page.on('requestfailed', (req) => {
    const url = req.url();
    if (url.includes('fonts.gstatic') || url.includes('fonts.googleapis')) return;
    networkFails.push(`${req.failure()?.errorText || 'failed'} ${url}`);
  });

  const routeResults = [];
  for (const route of ROUTES) {
    const res = await page.goto(`${BASE}${route.path}`, {
      waitUntil: 'networkidle',
      timeout: 120000,
    });
    await page.waitForSelector('flutter-view, flt-glass-pane, canvas', {
      timeout: 120000,
    });
    await page.waitForTimeout(2500);
    const title = await page.title();
    const ok = res?.ok() ?? false;
    routeResults.push({
      path: route.path,
      label: route.label,
      status: res?.status() ?? 0,
      ok,
      title,
    });
  }

  await page.goto(`${BASE}/`, { waitUntil: 'networkidle', timeout: 120000 });
  await page.waitForTimeout(2000);
  const overflow = await page.evaluate(() => {
    const doc = document.documentElement;
    return doc.scrollWidth > doc.clientWidth + 2;
  });

  const faviconRes = await page.goto(`${BASE}/favicon.png?v=1.2.0`, {
    timeout: 60000,
  });
  const manifestRes = await page.goto(`${BASE}/manifest.json?v=1.2.0`, {
    timeout: 60000,
  });
  const mainJsRes = await page.goto(`${BASE}/main.dart.js`, {
    timeout: 60000,
  });

  await browser.close();

  return {
    name,
    width,
    height,
    routeResults,
    hasHorizontal: overflow,
    faviconOk: faviconRes?.ok() ?? false,
    manifestOk: manifestRes?.ok() ?? false,
    mainJsOk: mainJsRes?.ok() ?? false,
    errors: errors.slice(0, 8),
    networkFails: networkFails.slice(0, 8),
  };
}

const results = [];
for (const [name, w, h] of [
  ['mobile', 390, 844],
  ['tablet', 768, 1024],
  ['desktop', 1440, 900],
]) {
  results.push(await checkViewport(name, w, h));
}

console.log(JSON.stringify({ base: BASE, results }, null, 2));

const failed = results.some(
  (r) =>
    r.hasHorizontal ||
    r.errors.length > 0 ||
    r.networkFails.length > 0 ||
    !r.faviconOk ||
    !r.manifestOk ||
    !r.mainJsOk ||
    r.routeResults.some((x) => !x.ok),
);

process.exit(failed ? 1 : 0);
