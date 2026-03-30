/**
 * @module utils/array
 */

/**
 * Get unique values from an array.
 * @template T
 * @param {T[]} arr - Input array
 * @returns {T[]} Array with unique values
 */
export function unique(arr) {
  return [...new Set(arr)];
}

/**
 * Chunk an array into smaller arrays.
 * @template T
 * @param {T[]} arr - Input array
 * @param {number} size - Chunk size
 * @returns {T[][]} Chunked array
 */
export function chunk(arr, size) {
  const result = [];
  for (let i = 0; i < arr.length; i += size) {
    result.push(arr.slice(i, i + size));
  }
  return result;
}
