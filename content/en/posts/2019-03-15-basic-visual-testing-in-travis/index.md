---
pinned: true
title: Basic Visual Testing Automated in Travis
slug: basic-visual-testing-in-travis
date: "2019-03-15T06:00:00"
categories: testing
tags:
- travis
- javascript
- html
- regression
- testing
- guide
- puppeteer
- firefox
- chrome

resources:
- name: firefox-before
  src: firefox-before.jpg
- name: chrome-before
  src: chrome-before.jpg
---

Ever since I have worked on websites I always hated the proces to testing pages in different browsers. And since I created the [Scarecrow][scarecrow] theme for [Hugo][hugo] and am actually using it on this website I've put off testing for as long as possible. But I noticed the other day the the homepage in chrome, chrome of all browsers, was all messed up.

<!--more-->

Since I moved away from developing websites a few years ago I have had a blissful development life, without IE and all of it's problems.  I've also picked up a habit called Test Driven Development (TDD) and I wasn't about to let some browser browser stop me from automating this proces.

So the question became, how do you manually test for differences in different browsers. Well, most of it is just opening a page, the homepage for example, in multiple browsers and then comparing the difference rendered by the engine.

{{< columns >}}
	{{< resources/image "firefox-before" "Homepage rendered in firefox" >}}
	{{< resources/image "chrome-before" "Homepage rendered in chrome" >}}
{{</ columns >}}

Getting these screenshots is the tricky part. But most major browsers these days have a headless mode. This allows you to launch the browser from the command line. For this, I used a library called [Puppeteer][puppeteer]. This is, in essence, just a wrapper around the cli of the browser. But neatly packaged as a node package. This removed the need to manually spawn processes from within nodejs.

I used the following code in my tests to spawn the browsers. Before the test suite is started I create all the browsers I need. This saves a huge deal in an automated test, not having the start new browsers every tests. As of this writing I'm only testing in firefox and chrome, since I haven't figured out yet how to launch IE in headless mode.

```typescript
// Before hook for test suite
before(async function() {
	this.timeout(0);
	server = spawn('pnpm', ['run', 'serve'], { detached: true, shell: true });
	browsers.push(await LaunchFirefox({ headless: true }));
	browsers.push(await LaunchChrome({ headless: true, args:[ '--no-sandbox', '--disable-setuid-sandbox' ]}));
});

// Capture a screenshot in a browser
async function capture(browser: Browser, viewport: Viewport, url: string, path: string): Promise<Buffer> {
	const page = await browser.newPage();
	await page.setViewport(viewport);

	await page.goto(`http://localhost:1313${url}`);
	return await page.screenshot({ fullPage: true, path: path });
}
```

The capture method is passed on of the browsers, the viewport width and height to run the page and the path to open in the browsers.
With all those arguments puppeteer is able to open a new page, resize it to the specified dimensions, nagivate to the page and take a screenshot.

The tests themselfs become very easy now. It's just a matter of comparing two screenshots from different browsers and making sure they match. Enter the world of javascript image comparison libraries. There are a lot of tools out there but I found that [ResembleJS][resemblejs], one of the more known and popular libraries in this field, meets all of my needs. [ResembleJS][resemblejs] is fairly simple in it's workings. It just takes the two images you provide it and does a pixel compare, allowing you to ignore certain things, like colors or antialiasing.

```typescript
// Run this method for each page / resolution
async function run(url: string, res: Resolution, threshold: number, browsers: Browser[]): Promise<void> {
	const safeUrl = url.replace(/\//g, '_');

	const firstBrowser = browsers[0];
	const firstPath = join(__dirname, `browser[0]-[${safeUrl}]-${res}.jpg`);
	await capture(firstBrowser, resolutions[res], url, firstPath);

	for(let i = 1; i < browsers.length; i++) {
		const browser = browsers[i];
		const path = join(__dirname, `browser[${i}]-[${safeUrl}]-${res}.jpg`);

		await capture(browser, resolutions[res], url, path);

		const results = ResembleJS(firstPath)
			.compareTo(path)
			.ignoreAntialiasing();

		results.onComplete(res => {
			const ratio = parseFloat(`${res.misMatchPercentage}`);

			console.log(`expecting <${ratio}> <= <${threshold}>`);
			expect(ratio).to.be.lessThan(threshold + 0.1)
		});
	}
}
```

Bringing this all together on a development machine is one thing, but these tests should be run on every pull request. And since [Travis][travis] has great support for running mocha tests we will use that as our build agent.

```yml
language: node_js
node_js: node

addons:
  firefox: latest
  chrome: stable

cache: npm

branches:
  only:
  - master

install:
- npm i

script:
- npm run test
```

Note the addons used in this file. We use the latest version of firefox and the stable version of chrome in order to ensure we run on the latest version of both.
This enabled github to make sure a pull request can only pass if the page looks the same on chrome and firefox. removing my burden to test these to browsers myself.


For the complete test file, please checkout my github repository of the [Scarecrow][scarecrow] theme.


[scarecrow]: https://github.com/strootje/hugo-scarecrow-theme/
[hugo]: https://gohugo.io/
[puppeteer]: https://github.com/GoogleChrome/puppeteer
[resemblejs]: https://github.com/rsmbl/Resemble.js
[travis]: https://travis-ci.org/
