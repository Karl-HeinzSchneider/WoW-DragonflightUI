import { existsSync, lstatSync, realpathSync, symlinkSync } from "node:fs";
import { resolve } from "node:path";
import { ROOT, packageName } from "./config.js";

const destination = process.argv[2] ?? process.env.WOW_ADDONS_DIR;
if (!destination) {
  console.error('usage: npm run dev:link -- "<World of Warcraft>/<flavor>/Interface/AddOns"\nOr set WOW_ADDONS_DIR.');
  process.exit(2);
}

const addonsDir = resolve(destination);
if (!existsSync(addonsDir) || !lstatSync(addonsDir).isDirectory()) {
  console.error(`addon directory does not exist: ${addonsDir}`);
  process.exit(2);
}

// The repository root is the addon, so it is linked under its addon name rather than the repo folder name.
const name = packageName();
if (!existsSync(resolve(ROOT, `${name}.toc`))) {
  console.error(`${name}.toc not found in ${ROOT}`);
  process.exit(2);
}

const target = resolve(addonsDir, name);
if (existsSync(target)) {
  // .native resolves to the canonical path, so a drive-letter case difference (e: vs E:) still matches.
  if (realpathSync.native(target) === realpathSync.native(ROOT)) {
    console.log(`linked: ${name}`);
  } else {
    console.error(`refusing to replace existing path: ${target}`);
    process.exitCode = 1;
  }
} else {
  symlinkSync(ROOT, target, process.platform === "win32" ? "junction" : "dir");
  console.log(`linked ${target} -> ${ROOT}`);
}
