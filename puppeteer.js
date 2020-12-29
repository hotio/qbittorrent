const puppeteer = require('puppeteer');

(async () => {
  const browser = await puppeteer.launch({
    bindAddress: "0.0.0.0",
    args: [
      "--no-sandbox",
      "--headless",
      "--disable-gpu",
      "--disable-dev-shm-usage",
      "--remote-debugging-port=9222",
      "--remote-debugging-address=0.0.0.0"
    ]
  });
  const page = await browser.newPage();
  await page.setViewport({ width: 1920, height: 1080 });
  try {
    await page.goto("http://localhost:8080", { waitUntil: "networkidle2" });
  } catch (e) {
    console.log(e)
    process.exit(1)
  }
  await page.screenshot({ path: "/usr/src/app/src/screenshot.png", fullPage: true });
  await browser.close();
})();
