import { chromium } from 'playwright';

async function check(name, width, height) {
  const browser = await chromium.launch({ headless: true });
  const page = await browser.newPage({ viewport: { width, height } });
  const errors = [];
  page.on('pageerror', (e) => errors.push(String(e)));
  page.on('console', (msg) => {
    if (msg.type() === 'error') {
      const t = msg.text();
      if (t.includes('Google Fonts') || t.includes('fonts.gstatic')) return;
      errors.push(t);
    }
  });

  await page.goto('http://127.0.0.1:8765/life-paths', {
    waitUntil: 'networkidle',
    timeout: 120000,
  });
  await page.waitForSelector('flutter-view, flt-glass-pane, canvas', {
    timeout: 120000,
  });
  await page.waitForTimeout(4000);

  const overflow = await page.evaluate(() => {
    const doc = document.documentElement;
    return doc.scrollWidth > doc.clientWidth + 2;
  });

  await page.goto('http://127.0.0.1:8765/life-paths/freelancer', {
    waitUntil: 'networkidle',
    timeout: 120000,
  });
  await page.waitForTimeout(3500);
  const detailOk = await page.evaluate(() =>
    Boolean(document.querySelector('flutter-view, flt-glass-pane, canvas')),
  );

  await page.goto('http://127.0.0.1:8765/mind-lounge', {
    waitUntil: 'networkidle',
    timeout: 120000,
  });
  await page.waitForTimeout(3500);
  const mindOk = await page.evaluate(() =>
    Boolean(document.querySelector('flutter-view, flt-glass-pane, canvas')),
  );

  const title = await page.title();
  await browser.close();
  return {
    name,
    title,
    detailOk,
    mindOk,
    hasHorizontal: overflow,
    hasFiveLivesLabel: title.includes('다섯'),
    errors: errors.slice(0, 5),
  };
}

const results = [];
for (const v of [
  ['mobile', 390, 844],
  ['tablet', 768, 1024],
  ['desktop', 1440, 900],
]) {
  results.push(await check(...v));
}
console.log(JSON.stringify(results, null, 2));
process.exit(
  results.some(
    (r) =>
      !r.detailOk ||
      !r.mindOk ||
      r.hasHorizontal ||
      r.hasFiveLivesLabel ||
      r.errors.length > 0,
  )
    ? 1
    : 0,
);
