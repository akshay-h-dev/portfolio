# Akshay H - Flutter Web Portfolio

> A fast, responsive developer portfolio built with Flutter Web, Riverpod,
> and a public Google Sheet as its content source.

This is the source code for [akshayh.dev](https://akshayh.dev), a single-page
portfolio for showcasing mobile applications, backend systems, machine
learning projects, technical skills, education, and certifications.

The experience is designed to feel like a focused developer workspace: dark
surfaces, high-contrast typography, outline cards, subtle motion, and a live
accent-color selector that updates the interface without a page reload.

## Highlights

- Responsive Flutter Web experience for mobile, tablet, and desktop.
- Hero section with animated role text and direct contact actions.
- About and education timeline sections.
- Skill categories with Flutter and Font Awesome icons.
- Project cards with descriptions, features, technologies, links, and full
  project images loaded from Google Sheets.
- Certifications with verification links.
- Contact form that validates input and opens a pre-filled email.
- Riverpod providers for asynchronous content loading and error states.
- Public Google Sheets integration with no API keys or credentials in the app.
- Static and dynamic SEO metadata, Open Graph tags, sitemap, robots file, and
  JSON-LD structured data.
- Release-ready deployment configuration for Vercel and other static hosts.

## Tech Stack

| Area | Technology |
| --- | --- |
| UI | Flutter Web, Material 3 |
| State | Riverpod |
| Motion | flutter_animate, visibility_detector |
| Responsive layout | responsive_framework |
| Typography | Google Fonts |
| Icons | Font Awesome Flutter, Material Icons |
| Content | Google Sheets Visualization API endpoint |
| Links | url_launcher |
| Hosting | Vercel, Firebase Hosting, Netlify, GitHub Pages |

## Project Structure

```text
lib/
├── config/          SEO and Google Sheets configuration
├── core/            Theme, colors, and application constants
├── features/
│   ├── contact/     Contact form
│   └── home/        Hero, about, skills, projects, certifications
├── models/          Project, skill, certification, and timeline models
├── repositories/    Google Sheets loader and Riverpod providers
├── services/        Web SEO metadata integration
├── state/           Global accent-color state
├── utils/           Responsive helpers and resume launcher
└── widgets/         Shared cards, navigation, buttons, and animations

web/
├── index.html       Static SEO shell and loading screen
├── manifest.json    PWA metadata
├── robots.txt       Crawler rules
└── sitemap.xml      Sitemap for the public site
```

## Run Locally

### Requirements

- Flutter 3.29 or newer recommended
- Dart SDK compatible with `pubspec.yaml`
- Chrome or another Flutter Web browser target

### Setup

```bash
flutter pub get
flutter run -d chrome
```

For a production build:

```bash
flutter build web --release
```

The generated static site is written to `build/web`.

## Google Sheets Content

The portfolio content is loaded from three public tabs configured in
[`lib/config/google_sheets_config.dart`](lib/config/google_sheets_config.dart):

- `projects`
- `education`
- `certifications`

The spreadsheet must be published to the web. The app uses Google's public
Visualization endpoint, so it does not require an API key, service account, or
other credential.

Keep the first row of every tab as its header row. Header matching is
case-insensitive and ignores spaces and punctuation.

### Projects tab

| Column | Required | Description |
| --- | --- | --- |
| `slug` | Yes | Stable project identifier |
| `title` | Yes | Project name |
| `description` | Yes | Short project summary |
| `contribution` | Yes | Your role or contribution |
| `features` | No | Feature list |
| `technologies` | No | Technology list |
| `architecture` | Yes | Technical architecture summary |
| `imageUrl` | No | Public image URL displayed in the card |
| `githubUrl` | No | Source code link |
| `liveDemoUrl` | No | Live project link |
| `videoUrl` | No | Accepted as a fallback for `liveDemoUrl` |
| `datasetUrl` | No | Dataset link |

List cells support JSON arrays, commas, pipes, or line breaks. For example:

```text
JSON: ["Flutter", "Firebase"]
Simple: Flutter | Firebase
```

Education uses `period`, `title`, and `subtitle`. Certifications use `title`,
`provider`, and `verifyUrl`. Empty optional cells are handled safely.

## Customization

Most personal content is intentionally centralized:

1. Update the public spreadsheet ID and tab names in
   [`google_sheets_config.dart`](lib/config/google_sheets_config.dart).
2. Update personal details, social links, resume URL, and breakpoints in
   [`app_constants.dart`](lib/core/constants/app_constants.dart).
3. Update page title, descriptions, canonical URL, and social preview data in
   [`web/index.html`](web/index.html) and [`seo_config.dart`](lib/config/seo_config.dart).
4. Add or replace image and resume assets under `assets/` when needed.
5. Keep project image URLs publicly reachable over HTTPS. The card displays
   the complete image without cropping and shows a fallback if it cannot load.

The footer accent selector updates the theme at runtime. The core UI remains
unchanged when content is edited in the spreadsheet.

## Deployment

This project produces a static Flutter Web build and can be deployed to any
static host.

### Vercel

The repository includes [`vercel.json`](vercel.json) for SPA rewrites.

- Build command: `flutter build web --release`
- Output directory: `build/web`

### Firebase Hosting or Netlify

Build the project and publish `build/web`:

```bash
flutter build web --release
```

### GitHub Pages

Publish the contents of `build/web` from a deployment workflow or the
`gh-pages` branch. Update the Flutter base path if the site is hosted below a
repository subpath rather than at a custom domain.

## SEO Notes

The static HTML shell contains the browser title, description, canonical URL,
Open Graph and Twitter metadata, sitemap, robots rules, and fallback content.
The Flutter app also injects project JSON-LD after project data loads.

Flutter Web renders the application UI through a canvas, so the static shell
is important for crawlers and link previews. Keep `web/index.html` aligned with
the deployed domain and update `web/og-image.png` if a custom social preview is
added.

## Contact Behavior

The contact form validates name, email, and message fields, then opens a
pre-filled `mailto:` link. It does not send data to a server. To collect
submissions without requiring the visitor to have a configured email client,
replace the submit implementation in
[`contact_form.dart`](lib/features/contact/contact_form.dart) with a trusted
form service or serverless endpoint.

## Quality Checks

```bash
flutter analyze
flutter test
git diff --check
```

## Content Notice

This repository is a personal portfolio. The source is public for reference
and learning; project content, personal information, branding, and media may
not be reused without permission.
