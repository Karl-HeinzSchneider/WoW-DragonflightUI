import { readFileSync } from "node:fs";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

/** Repository root, relative to this file (src/config.ts). The addon itself lives here, not in a subfolder. */
export const ROOT = resolve(dirname(fileURLToPath(import.meta.url)), "..");

/** `package-as` in .pkgmeta: the addon's folder name in Interface/AddOns (matches DragonflightUI.toc). */
export function packageName(): string {
  const pkgmeta = readFileSync(resolve(ROOT, ".pkgmeta"), "utf-8");
  const name = /^package-as:\s*(\S+)/m.exec(pkgmeta)?.[1];
  if (!name) throw new Error(".pkgmeta has no package-as line");
  return name;
}
