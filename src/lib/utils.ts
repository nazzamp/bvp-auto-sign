import { clsx, type ClassValue } from "clsx";
import { twMerge } from "tailwind-merge";

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}

export function compareVersions(version1: string, version2: string) {
  const v1Parts = version1.split(".").map(Number);
  const v2Parts = version2.split(".").map(Number);

  for (let i = 0; i < Math.max(v1Parts.length, v2Parts.length); i++) {
    const num1 = v1Parts[i] || 0; // Default to 0 if undefined
    const num2 = v2Parts[i] || 0; // Default to 0 if undefined

    if (num1 < num2) {
      return -1; // version1 is less than version2
    }
    if (num1 > num2) {
      return 1; // version1 is greater than version2
    }
  }

  return 0; // versions are equal
}
