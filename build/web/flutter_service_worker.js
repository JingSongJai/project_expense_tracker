'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "7c7caf439deb6bf372d9fdb48d3974e2",
"assets/AssetManifest.bin.json": "3c8e184e17b8e1367131adf64d00f7d5",
"assets/AssetManifest.json": "36c9f5708b5725b16f3aeb0a548071f0",
"assets/assets/fonts/KantumruyPro.ttf": "afdec6174b53939a16c687cea251757d",
"assets/assets/gif/Empty%2520Gif.gif": "b294da205e33eb009b829027ce91149b",
"assets/assets/ico/app_icon.ico": "d65c487a48d60f5c3f066dbbf57576f3",
"assets/assets/json/Empty%2520Icon.json": "266a45b2876e36ce808ee89385263feb",
"assets/assets/png/App%2520Icon.png": "da415b244d63407120f398bc3d7319fd",
"assets/assets/png/moon-fill.png": "e14adea32abb0439d59ede03390d701f",
"assets/assets/png/ri--money-dollar-circle-fill.png": "5e12a504aaf53f1615fe075061cb1b34",
"assets/assets/png/sun-fill.png": "bd0d30bd6c938d8ded41d0c5f18537c6",
"assets/assets/svg/Budgets%2520Icon.svg": "f23f3e5932aabe06450ac3363e1f4dec",
"assets/assets/svg/Category%2520Icon.svg": "a6d95c26e5cb56fe82e5df4039c7e470",
"assets/assets/svg/Check%2520Icon.svg": "b3706ded835e41bee7591c32173f93c8",
"assets/assets/svg/Empty%2520Data%2520Icon.svg": "42aac48c6d650c54532f82fd873b0a46",
"assets/assets/svg/Empty%2520Icon.svg": "34ed28e0eb957c63eabec659f85be214",
"assets/assets/svg/Graph%2520Icon.svg": "2ac0484ad2e4a77a1b385333df2158b4",
"assets/assets/svg/Group%2520Icon.svg": "b831c8831df7af9a13a3b0eaf6b60362",
"assets/assets/svg/Home%2520Icon.svg": "62c16e6d30f9b3445efaec220a91e401",
"assets/assets/svg/Language%2520Icon.svg": "6a11eec56b3b87767c23493dc485f8ea",
"assets/assets/svg/Logo%2520Icon.svg": "01b5c62f7ca689e2740a3b79e163aa69",
"assets/assets/svg/Menu%2520Icon.svg": "fb56f9a49eaa552f504479defdfe5b06",
"assets/assets/svg/Notification%2520Icon.svg": "bd72bd25c4be163756f293dbca846af2",
"assets/assets/svg/Recurring%2520Payment%2520Icon.svg": "12f372795a0e3e5624cb3aaaddaea4fe",
"assets/assets/svg/Search%2520Icon.svg": "f552e3ab7c60217d5571b1f26ed20fc3",
"assets/assets/svg/Setting%2520Icon.svg": "70f31ccfdd0f26796fee0a8f572068ca",
"assets/assets/svg/Sort%2520Icon.svg": "e9b3f05ef24cf7a78eda1153ccb8e647",
"assets/assets/svg/Theme%2520Icon.svg": "f06b24743b3e99f3aa16717ab0ee107b",
"assets/assets/svg/Transaction%2520Icon.svg": "9e2f744dea40e342a86cd9d770d14559",
"assets/FontManifest.json": "745704b130e5c07f24e2a1ee82f13940",
"assets/fonts/MaterialIcons-Regular.otf": "e7069dfd19b331be16bed984668fe080",
"assets/NOTICES": "a5ce43ed5ac68c75117f8986d227419e",
"assets/packages/flex_color_picker/assets/opacity.png": "49c4f3bcb1b25364bb4c255edcaaf5b2",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/splash_logo.gif": "262145f40a0584ac6edcbfd931e4e799",
"canvaskit/canvaskit.js": "6cfe36b4647fbfa15683e09e7dd366bc",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/chromium/canvaskit.js": "ba4a8ae1a65ff3ad81c6818fd47e348b",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"favicon.png": "892576ed27349b5e603fd51f98fa2745",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"flutter_bootstrap.js": "8cbbaa78be8050a256d22c80bd01038f",
"icons/Icon-192.png": "7a62f58657267b26f90f09fd1441c5ce",
"icons/Icon-512.png": "b978d72abf38702ef8e59adbc576b381",
"icons/Icon-maskable-192.png": "7a62f58657267b26f90f09fd1441c5ce",
"icons/Icon-maskable-512.png": "b978d72abf38702ef8e59adbc576b381",
"index.html": "5131eb90091cec786803d03e160e24b7",
"/": "5131eb90091cec786803d03e160e24b7",
"main.dart.js": "feeccb14864dad82e5380bb17e2c05f4",
"manifest.json": "d41d8cd98f00b204e9800998ecf8427e",
"version.json": "1afeb0fbdecc78fed116d8a55f9af328"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
