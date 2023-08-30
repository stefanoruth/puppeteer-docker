import puppeteer from 'puppeteer'

async function run() {
    const browser = await puppeteer.launch({ headless: 'new' })
    const page = await browser.newPage()

    await page.goto('https://icanhazip.com')

    await page.screenshot({
        path: 'files/screenshot.jpg',
    })

    await browser.close()

    console.log('Finished')
}

run().catch(console.error)
