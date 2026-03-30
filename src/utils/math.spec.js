import { describe, expect, it } from 'vitest';
import { divide, multiply, subtract, sum } from '@/utils/math';

describe('utils/math', () => {
  // --- sum() ---
  describe('sum()', () => {
    it('adds two positive numbers', () => {
      expect(sum(2, 3)).toBe(5);
    });

    it('adds negative numbers', () => {
      expect(sum(-2, -3)).toBe(-5);
    });

    it('adds mixed numbers', () => {
      expect(sum(-2, 3)).toBe(1);
    });
  });

  // --- subtract() ---
  describe('subtract()', () => {
    it('subtracts two numbers', () => {
      expect(subtract(5, 3)).toBe(2);
    });

    it('subtracts resulting in negative', () => {
      expect(subtract(3, 5)).toBe(-2);
    });
  });

  // --- multiply() ---
  describe('multiply()', () => {
    it('multiplies two positive numbers', () => {
      expect(multiply(2, 3)).toBe(6);
    });

    it('multiplies by zero', () => {
      expect(multiply(5, 0)).toBe(0);
    });

    it('multiplies negative numbers', () => {
      expect(multiply(-2, 3)).toBe(-6);
    });
  });

  // --- divide() ---
  describe('divide()', () => {
    it('divides two numbers', () => {
      expect(divide(6, 3)).toBe(2);
    });

    it('returns null when dividing by zero', () => {
      expect(divide(6, 0)).toBeNull();
    });

    it('divides negative numbers', () => {
      expect(divide(-6, 3)).toBe(-2);
    });
  });
});
