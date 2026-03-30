/**
 * @module utils/string
 */

/**
 * Capitalize the first letter of a string.
 * @param {string} str - Input string
 * @returns {string} Capitalized string
 */
export function capitalize(str) {
  if (!str) return '';
  return str.charAt(0).toUpperCase() + str.slice(1);
}

/**
 * Convert a string to kebab-case.
 * @param {string} str - Input string
 * @returns {string} Kebab-cased string
 */
export function toKebabCase(str) {
  return str
    .toLowerCase()
    .replace(/\s+/g, '-')
    .replace(/[^\w-]+/g, '');
}
