# Monorepo Structure Policy

> Project layout rules for backend/frontend monorepos | **Last Updated**: 2026-02-27

## Directory Structure

| Path | Type | Purpose |
| ---- | ---- | ------- |
| `apps/` | deployable | Applications and services (each has own `package.json`) |
| `apps/web/` | frontend | React / Next.js app |
| `apps/api/` | backend | NestJS / Express service |
| `apps/admin/` | frontend | Admin dashboard (optional) |
| `packages/` | shared | Internal reusable libraries |
| `packages/types/` | shared | TypeScript interfaces — framework-agnostic |
| `packages/utils/` | shared | Pure utility functions — framework-agnostic |
| `packages/ui/` | frontend | Shared React components |
| `packages/api-client/` | frontend | HTTP client for API |
| `packages/typescript-config/` | tooling | Shared `tsconfig` base files |
| `tooling/` | tooling | Shared ESLint, Prettier configs |

## Isolation Rules

| Rule | Detail |
| ---- | ------ |
| `apps/*` cannot import `apps/*` | No cross-app source imports |
| `packages/types`, `packages/utils` must be framework-agnostic | No NestJS decorators, no React hooks |
| `packages/ui` is frontend-only | Backend cannot depend on `ui` |
| All cross-app sharing via `packages/*` | Install as workspace dependency |
| `packages/*` cannot nest packages | Flat only: `packages/ui-core` not `packages/ui/core` |

## Dependency Graph

```
apps/web  ──> packages/ui
apps/web  ──> packages/types
apps/web  ──> packages/utils
apps/web  ──> packages/api-client
apps/api  ──> packages/types
apps/api  ──> packages/utils
packages/ui         ──> packages/types
packages/api-client ──> packages/types
```

`apps/*` → `packages/*` only. Never reverse. Never cross `apps/*`.

## Package Naming

| Pattern | Example | Rule |
| ------- | ------- | ---- |
| Internal tooling | `@repo/typescript-config` | Use `@repo/` scope |
| Shared business packages | `@myorg/types` | Use org scope |
| Folder = package name (no scope) | `packages/ui/` → `@repo/ui` | Match folder to package |
| Style | kebab-case only | No camelCase, no underscores |

## Workspace Config

```yaml
# pnpm-workspace.yaml
packages:
  - "apps/*"
  - "packages/*"
  - "tooling/*"
```

```json
// package.json (root)
{
  "packageManager": "pnpm@9.15.0",
  "scripts": {
    "build": "turbo build",
    "dev": "turbo dev",
    "test": "turbo test",
    "lint": "turbo lint",
    "check-types": "turbo check-types"
  }
}
```

Internal dependency reference:
```json
{ "dependencies": { "@repo/types": "workspace:*" } }
```

## TypeScript Config Pattern

| File | Extends | Used by |
| ---- | ------- | ------- |
| `typescript-config/base.json` | — | All packages |
| `typescript-config/backend.json` | `base.json` | `apps/api` |
| `typescript-config/nextjs.json` | `base.json` | `apps/web` |
| `typescript-config/react-library.json` | `base.json` | `packages/ui` |

```json
// apps/api/tsconfig.json
{
  "extends": "@repo/typescript-config/backend.json",
  "compilerOptions": { "outDir": "./dist", "rootDir": "./src" },
  "include": ["src"],
  "exclude": ["node_modules", "dist"]
}
```

Key settings by target:

| Target | `module` | `moduleResolution` | Extra |
| ------ | -------- | ------------------ | ----- |
| backend | `NodeNext` | `NodeNext` | `experimentalDecorators: true` |
| nextjs | `ESNext` | `Bundler` | `jsx: preserve` |
| react-lib | `ESNext` | `Bundler` | `jsx: react-jsx` |

## Build Tooling

**Stack**: pnpm + Turborepo 2.7+

```json
// turbo.json
{
  "tasks": {
    "build": { "dependsOn": ["^build"], "outputs": ["dist/**", ".next/**"] },
    "dev": { "cache": false, "persistent": true },
    "test": { "dependsOn": ["^build"], "outputs": ["coverage/**"] },
    "lint": {},
    "check-types": { "dependsOn": ["topo"] }
  }
}
```

| Scenario | Tool choice |
| -------- | ----------- |
| Small team, speed priority | Turborepo |
| Enterprise, governance required | Nx |
| 2-4 packages, no complex CI | pnpm workspaces only |

## Shared Package Build (Dual Format)

`packages/types`, `packages/utils` must output both ESM (frontend) and CJS (backend):

```typescript
// packages/types/tsup.config.ts
import { defineConfig } from 'tsup';

export default defineConfig({
  entry: ['src/index.ts'],
  format: ['esm', 'cjs'],
  dts: true,
  clean: true,
});
```

```json
// packages/types/package.json exports field
{
  "exports": {
    ".": {
      "import": "./dist/index.mjs",
      "require": "./dist/index.js",
      "types": "./dist/index.d.ts"
    }
  }
}
```

## Import Conventions

| Use case | Pattern |
| -------- | ------- |
| Cross-package | `import { User } from '@repo/types'` |
| Intra-app alias | `import { Button } from '@/components/Button'` (via tsconfig `paths`) |
| Never | `import { X } from '../../packages/types/src/user'` |

`paths` in tsconfig is for intra-app only (`@/*` → `./src/*`). Cross-package = workspace package name.

## CI Optimization

| Rule | Detail |
| ---- | ------ |
| `fetch-depth: 0` required | Shallow clone breaks `--affected` detection |
| Cache key on `hashFiles('**/src/**')` | Not on `github.sha` (changes every commit) |
| `turbo build --affected` | Builds only changed packages and dependents |
| Remote cache | Turborepo remote cache cuts CI time 60-80% |

## Monorepo vs Split Repo

| Keep monorepo | Split to separate repo |
| ------------- | ---------------------- |
| Frontend/backend share types | Different teams, no shared code |
| Atomic API + UI commits needed | Radically different release cycles |
| Team < 50 engineers | Security/access isolation required |
| AI-assisted development | External consumers of a package |

## When to Add a New Package

| Add `packages/X` when | Keep in `apps/Y/src/` when |
| ---------------------- | -------------------------- |
| Used by 2+ apps | Used by exactly 1 app |
| Independently versioned | No versioning needed |
| Framework-agnostic logic | App-specific logic |

## References

- CDD Policy: `docs/llm/policies/cdd.md`
- SDD Policy: `docs/llm/policies/sdd.md`
- Token Optimization: `docs/llm/policies/token-optimization.md`
- Methodology: `docs/llm/policies/development-methodology.md`
