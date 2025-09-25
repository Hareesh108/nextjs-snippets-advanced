# ⚡ New Next.js 15 Snippets

Supercharge your productivity when building **Next.js 15** apps using these clean, modern code snippets for **App Router**, **Client & Server Components**, **Server Actions**, **API Handlers**, and more.

---

## 📸 Demo

![Demo GIF](images/nextjs-snippets-demo.gif)

---

## 💡 Snippet Cheat Sheet

Snippets are grouped for clarity:

### 📦 Component Snippets

| Prefix          | Description                                          |
|-----------------|------------------------------------------------------|
| `next-client`   | Create a Client Component with `'use client'`        |
| `next-server`   | Create a Server Component (async/await)              |
| `next-page`     | Generate a basic `page.tsx` component                |
| `next-layout`   | Generate a basic `layout.tsx` root layout            |
| `next-loading`  | Create a `loading.tsx` file for suspense fallback    |
| `next-error`    | Create an `error.tsx` file for client error handling |
| `next-notfound` | Create a `not-found.tsx` page                        |

---

### 🔁 Server Logic Snippets

| Prefix          | Description                                          |
|-----------------|------------------------------------------------------|
| `next-action`   | Create a Server Action (`'use server'`)              |
| `next-handler`  | Create Route Handlers (`GET`, `POST`) for API routes |
| `next-middleware` | Create Middleware with route matchers              |
| `next-metadata` | Export `metadata` for pages/layouts (TS)             |
| `next-revalidate` | Export `revalidate` for ISR                        |
| `next-redirect` | Utilities for `redirect()` / `notFound()`            |
| `next-segment`  | Export `dynamic`, `revalidate`, `fetchCache`, etc.   |
| `next-generate-metadata` | `generateMetadata()` function               |
| `next-generate-params`   | `generateStaticParams()` for dynamic routes |
| `next-server-utils`      | `revalidatePath/Tag`, `cookies`, `headers`  |

---

### 🌐 Navigation Hooks (Client Only)

| Prefix               | Description                                       |
|----------------------|---------------------------------------------------|
| `next-router`        | Use `useRouter()` for navigation                  |
| `next-pathname`      | Use `usePathname()` to get current path           |
| `next-searchparams`  | Use `useSearchParams()` to read query parameters  |
| `next-params`        | Use `useParams()` to read dynamic route params    |
| `next-layoutsegments`| Use `useSelectedLayoutSegments()` for nesting     |
| `next-layoutsegment` | Use `useSelectedLayoutSegment()` for one segment  |

#### Import-only and Use-only Variants

- `next-router-import` / `next-router-use`
- `next-pathname-import` / `next-pathname-use`
- `next-searchparams-import` / `next-searchparams-use`
- `next-params-import` / `next-params-use`
- `next-layoutsegments-import` / `next-layoutsegments-use`
- `next-layoutsegment-import` / `next-layoutsegment-use`

Guidance: add imports at the very top of the file, keep usages inline where needed. If your file already contains many imports, the import-only snippets help you avoid duplications and keep ordering clean.

---

### 🧩 UI Components

| Prefix         | Description                                |
|----------------|--------------------------------------------|
| `next-link`    | Import and use Next.js `Link`               |
| `next-image`   | Import and use optimized `Image`            |
| `next-dynamic` | Use `dynamic()` for client-only components  |
| `next-script`  | Use `Script` with loading strategies        |
| `next-og-image`| Create an OG image route (edge)            |

---

---

## 🚀 Features

- ✨ Built specifically for **Next.js 15 App Router**
- 💡 Covers both **Client** and **Server** Components
- 🧠 Helpers for routing, metadata, ISR, and middleware
- 🔁 Snippets include correct imports and `'use client'` where needed
- ✅ Supports both **TypeScript** and **JavaScript** (React/TSX/JSX/TS/JS)
- ⚡ Minimal, fast, and dev-friendly

---

## 🔮 About the Creator

Made with ❤️ by [Hareesh Bhittam](https://github.com/Hareesh108)  
Follow for more dev wizardry 🧙‍♂️✨

---

## 📜 License

MIT License

⭐ If you love this extension, please give it a **star** and share it with your fellow React & Next.js developers!

---

## 🛠️ Developer Guide (Beginner Friendly)

### Prerequisites

- Node.js 18+ and npm
- VSCE (VS Code Marketplace) and OVSX (Open VSX) publishing access
  - You need a Microsoft account with a Personal Access Token (PAT) for VS Code Marketplace
  - You need an Open VSX account with a PAT for Open VSX

### Install local deps

```bash
npm install
```

### Scripts and what they do

- `npm run test`: Validates `package.json` contributions and `snippets/nextjs.json` structure
- `npm run package`: Builds a `.vsix` package using `vsce`
- `npm run publish:vscode`: Publishes to the VS Code Marketplace (requires login or PAT)
- `npm run publish:ovsx`: Publishes the latest built `.vsix` to Open VSX (requires PAT)
- `npm run deploy`: One-shot script that validates, packages, and publishes to both registries if tokens are set

### Log in / authenticate (VS Code Marketplace)

Option A: Login (stores token locally)

```bash
npx vsce login <your-publisher-name>
# Paste your Personal Access Token when prompted
```

Option B: Use a PAT for one command

```bash
VSCE_PAT='your-marketplace-pat' npm run publish:vscode
```

How to create a VS Code PAT: Create it from your Microsoft account with Marketplace scopes (Acquire, Manage) and copy the token.

### Publish flow (step-by-step)

1. Bump the version in `package.json` (Marketplace requires a new version each publish)

1. Validate locally

```bash
npm test
```

1. Build the package

```bash
npm run package
# Produces a file like: Nextjs-Snippets-Advanced-x.y.z.vsix
```

1. Publish to VS Code Marketplace (after login)

```bash
npm run publish:vscode
```

1. Publish to Open VSX (with PAT)

```bash
OVSX_PAT='your-ovsx-pat' npm run publish:ovsx
```

### One-shot deploy (both registries if tokens provided)

```bash
VSCE_PAT='your-marketplace-pat' \
OVSX_PAT='your-ovsx-pat' \
npm run deploy
```

The script will:

- Run validation
- Build the `.vsix`
- Publish to VS Code Marketplace if `VSCE_PAT` (or `VSCE_TOKEN`) is set
- Publish to Open VSX if `OVSX_PAT` (or `OVSX_TOKEN`) is set

### Troubleshooting

- 401 when publishing: Not logged in or invalid PAT. Re-run `npx vsce login <publisher>` or set `VSCE_PAT`.
- Request timeout: Retry later or ensure network access. You can run `npm run package` offline and publish when online.
- Version already exists: Bump the version in `package.json` and try again.
