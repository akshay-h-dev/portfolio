# Akshay H — Flutter Web Portfolio

A single-page, black-and-outline Flutter Web portfolio for **Akshay H**
(Flutter / Backend), built with Riverpod
and flutter_animate. Everything — hero, about, skills, projects,
certifications, contact — lives on one page as scroll-anchored sections.

---

## ⚠️ Read this first: the SEO reality check

Flutter Web (since 3.29) renders everything — your bio, project
descriptions, all of it — onto an HTML `<canvas>` via CanvasKit/Skwasm.
There's no real text in the DOM for Google to read the way there would be
on a normal HTML site.

- What **does** still work, because it lives in the static `web/index.html`
  shell rather than the canvas: `<title>`, meta description, Open Graph
  tags, Twitter cards, canonical URL, and JSON-LD structured data (Person,
  Website, and one `CreativeWork` entry per project — see
  `lib/services/seo_service.dart` and `home_page.dart`). Link previews on
  LinkedIn/WhatsApp/Twitter and the browser tab title will look correct.
- What **won't** happen: Google indexing the actual paragraph text of your
  project write-ups. Lighthouse's SEO audit mostly checks the technical
  things above, so a 90+ score is achievable without meaning Google can
  read your content.

In practice this matters less for a single-page portfolio than it sounds —
most recruiters arrive via a direct link (resume, LinkedIn, GitHub), not by
Googling and finding you organically.

---

## Design rationale

- **Theme**: pure black background everywhere, no glassmorphism. Cards, the
  nav bar, and dividers are solid black with a white outline at rest; the
  outline switches to the live **global accent color** on hover.
- **Global accent color**: a single color, changeable from the swatch picker
  in the footer (`GlobalColorChanger` — the footer's *only* content),
  recolors every hover outline, button, and accent label across the whole
  site **instantly, with no reload**. Mechanically: `accentColorProvider`
  (Riverpod `StateProvider<Color>`) is watched once, at the app root in
  `main.dart`, to rebuild `ThemeData` via `AppTheme.themeFor(accent)`. Every
  widget then just reads `Theme.of(context).colorScheme.secondary` (via the
  `context.accent` extension in `app_theme.dart`) — a standard Flutter
  `InheritedWidget` rebuild, no per-widget Riverpod wiring needed. Every
  accent-colored element in the app is its **own** widget with its own
  `BuildContext` (never read from inside a parent's inline closure) —
  that's what guarantees each one independently rebuilds on an accent
  change.
- **Type system**: Space Grotesk (display/headings) + Inter (body) +
  JetBrains Mono (eyebrows, tags, the terminal-style hero typing animation).
- **Signature element**: the hero's typewriter line (`Flutter Developer_`)
  styled like a terminal prompt, with its cursor tinted the live accent
  color.
- **Surface language**: one outline component (`OutlineCard`) reused for
  skill cards, project cards, timeline entries, certification cards, and the
  contact form.

## Folder structure

```
lib/
├── core/            # theme (colors/typography as a function of accent), app-wide constants
├── config/          # SEO metadata for the page
├── state/           # accentColorProvider + presets (the global color changer's state)
├── services/        # SeoService (title/meta/JSON-LD DOM updates)
├── models/          # Project, Skill, Certification, TimelineEntry
├── repositories/     # static content + Riverpod providers (swap for a CMS later)
├── widgets/         # shared UI: OutlineCard, AccentButton, NavBar, GlobalColorChanger...
└── features/
    ├── home/        # hero, about, skills, projects, certifications, contact — the whole page
    └── contact/     # contact form
web/
├── index.html       # static meta/OG/Twitter/JSON-LD shell + percentage loading splash
├── robots.txt
├── sitemap.xml
└── manifest.json
```

There's a single screen (`HomePage`) — no router. The nav bar and hero
buttons scroll to sections with `GlobalKey`s + `Scrollable.ensureVisible`
rather than navigating anywhere.

---

## Getting started

This repo ships only the **Dart source and web assets** — not the generated
platform scaffolding (`android/`, `ios/`, `windows/`, etc.), since that's
machine-generated and this environment couldn't run the Flutter SDK to
produce it. To get a runnable project on your machine:

```bash
# 1. Scaffold a fresh Flutter project for web only
flutter create --platforms=web --org dev.akshayh akshay_portfolio_scaffold
cd akshay_portfolio_scaffold

# 2. Replace its lib/, web/, pubspec.yaml, analysis_options.yaml with
#    the ones from this delivered project (keep the scaffold's other
#    generated files, e.g. .metadata).

# 3. Install dependencies
flutter pub get

# 4. Run locally
flutter run -d chrome
```

> Because this was written without access to `pub.dev` or the Flutter SDK in
> the authoring environment, package versions in `pubspec.yaml` are pinned to
> versions known-good as of writing but not `flutter pub get`-verified here.
> If `flutter pub get` reports a version conflict, run
> `flutter pub upgrade --major-versions` and re-test.

### Before your first real deploy

1. **Resume link**: set `AppConstants.resumeUrl` in
   `lib/core/constants/app_constants.dart` to your real Google Drive share
   link, and make sure sharing is set to "Anyone with the link can view" —
   otherwise visitors hit a permission-denied screen. The Download Resume
   button opens it directly in a new tab.
2. **Certification verify links**: set `verifyUrl` on each `Certification`
   entry in `lib/repositories/portfolio_repository.dart`. Until you do, the
   Verify button shows a reminder snackbar instead of a broken link.
3. **Project repo links** (optional): set `githubUrl`/`liveDemoUrl` on any
   `Project` entry in the same file to get a "View Code"/"Live Demo" button
   on that project's card — commented-out examples are already in place.
4. Add real project screenshots to `assets/images/` (WebP, per the
   performance goals) and swap the icon placeholder blocks in `ProjectCard`
   for `Image.asset(...)`.
5. Add real PWA icons to `web/icons/` and an `og-image.png` (1200×630) to
   `web/` for link previews (referenced in `web/index.html`).
6. Wire the contact form to something that actually delivers messages
   without opening the visitor's email client — see the comment at the top
   of `lib/features/contact/contact_form.dart` (Formspree, EmailJS, or your
   own FastAPI/Node endpoint all drop in without changing the form UI).
7. Update `https://akshayh.dev` in `web/index.html`, `web/sitemap.xml`,
   `web/robots.txt`, and `AppConstants.siteUrl` if you deploy to a different
   domain.

---

## Performance notes

- Section widgets are wrapped in `ScrollReveal` (built on
  `visibility_detector`), so off-screen sections don't animate until
  scrolled into view.
- Riverpod providers (`lib/repositories/portfolio_repository.dart`) keep all
  content data outside the widget tree so section rebuilds stay narrow.
- Build for production with tree-shaken icons and (optionally) WebAssembly:
  `flutter build web --release --wasm` (or plain `flutter build web --release`
  if any plugin isn't wasm-ready yet).
- Run Lighthouse against the **release** build (served via e.g.
  `python3 -m http.server` in `build/web`), not `flutter run` in debug mode —
  debug builds are unoptimized and will tank every score.

---

## Deployment

Any static host works since `flutter build web` outputs plain HTML/JS/Wasm
into `build/web/`. Being a single page now, there's no SPA-routing/rewrite
configuration to worry about — GitHub Pages, Firebase Hosting, Vercel, and
Netlify all work with zero extra config.

**Firebase Hosting** (recommended): `firebase init hosting` (public
directory: `build/web`), `flutter build web --release`, `firebase deploy`.

**Vercel / Netlify**: build command `flutter build web --release`, publish
directory `build/web`.

**GitHub Pages**: publish `build/web/` to the `gh-pages` branch (or the
repo's Pages source directory) — works out of the box for a single page.

## GitHub setup

Run these from the project root once you've scaffolded it locally (see
"Getting started" above):

- `git init`
- Add a `.gitignore` covering `build/`, `.dart_tool/`, `.packages`,
  `.pub-cache/`, `.pub/`, `*.iml`, `.idea/`
- `git add .`
- `git commit -m "Initial commit: Akshay H Flutter Web portfolio"`
- `git branch -M main`
- `git remote add origin https://github.com/akshay-h-dev/portfolio.git`
- `git push -u origin main`

Optional: add a GitHub Actions workflow that runs
`flutter build web --release --wasm` and deploys to Firebase Hosting on
every push to `main` (`firebase init hosting:github` scaffolds this).

---

## What's implemented vs. left as a next step

**Implemented**: single-page layout (hero, about, skills, projects,
certifications, contact) with scroll-anchored nav; black/outline theme with
a live, footer-driven global accent color; hero with typing animation,
floating tech badges, and a GitHub button; projects section with inline
contribution/features/tech stack and optional View Code/Live Demo buttons;
certifications with a Verify button; contact form + direct links; percentage
loading splash; static + dynamic SEO metadata and JSON-LD; robots.txt,
sitemap.xml.

**Left for you**: your real resume link, certification verify links, project
repo links, screenshots, PWA icons/og-image, and a real backend for the
contact form (see "Before your first real deploy" above).
