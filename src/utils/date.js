/**
 * @module utils/date
 */

/**
 * Format a date as YYYY-MM-DD.
 * @param {Date} date - Date object
 * @returns {string} Formatted date
 */
export function formatDate(date) {
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const day = String(date.getDate()).padStart(2, '0');

  return `${year}-${month}-${day}`;
}

/**
 * Check if a date is in the past.
 * @param {Date} date - Date to check
 * @returns {boolean} True if past
 */
export function isPast(date) {
  return date.getTime() < Date.now();
}
