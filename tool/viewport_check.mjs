import { chromium } from 'playwright';

async function checkViewport(name, width, height) {
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

  await page.goto('http://127.0.0.1:8765/', {
    waitUntil: 'networkidle',
    timeout: 120000,
  });
  await page.waitForSelector('flutter-view, flt-glass-pane, canvas', {
    timeout: 120000,
  });
  await page.waitForTimeout(5000);

  const overflow = await page.evaluate(() => {
    const doc = document.documentElement;
    const body = document.body;
    return {
      hasHorizontal:
        doc.scrollWidth > doc.clientWidth + 2 ||
        body.scrollWidth > body.clientWidth + 2,
    };
  });

  const title = await page.title();
  const hasOldCrisisTitle = title.includes('생명구조');

  await page.goto('http://127.0.0.1:8765/five-lives', {
    waitUntil: 'networkidle',
    timeout: 120000,
  });
  await page.waitForTimeout(4000);
  const refreshOk = await page.evaluate(() =>
    Boolean(
      document.querySelector('flutter-view') ||
        document.querySelector('flt-glass-pane') ||
        document.querySelector('canvas'),
    ),
  );

  await browser.close();
  return {
    name,
    width,
    height,
    title,
    hasOldCrisisTitle,
    refreshOk,
    hasHorizontal: overflow.hasHorizontal,
    errors: errors.slice(0, 8),
  };
}

const results = [];
for (const v of [
  ['mobile', 390, 844],
  ['tablet', 768, 1024],
  ['desktop', 1440, 900],
]) {
  results.push(await checkViewport(...v));
}
console.log(JSON.stringify(results, null, 2));
const failed = results.some(
  (r) =>
    !r.refreshOk ||
    r.hasHorizontal ||
    r.hasOldCrisisTitle ||
    !r.title.includes('SotongSaveLive') ||
    r.errors.length > 0,
);
process.exit(failed ? 1 : 0);
