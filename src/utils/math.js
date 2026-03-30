/**
 * @module utils/math
 */

/**
 * Add two numbers.
 * @param {number} a - First number
 * @param {number} b - Second number
 * @returns {number} Sum of a and b
 */
export function sum(a, b) {
  return a + b;
}

/**
 * Subtract two numbers.
 * @param {number} a - First number
 * @param {number} b - Second number
 * @returns {number} Result of a - b
 */
export function subtract(a, b) {
  return a - b;
}

/**
 * Multiply two numbers.
 * @param {number} a - First number
 * @param {number} b - Second number
 * @returns {number} Product of a and b
 */
export function multiply(a, b) {
  return a * b;
}

/**
 * Divide two numbers.
 * @param {number} a - Numerator
 * @param {number} b - Denominator
 * @returns {number|null} Result or null if division by zero
 */
export function divide(a, b) {
  if (b === 0) return null;
  return a / b;
}
