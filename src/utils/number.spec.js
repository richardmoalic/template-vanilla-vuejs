import { describe, expect, it } from 'vitest';
import { clamp, randomInt } from '@/utils/number';

describe('utils/number', () => {
  // --- clamp() ---
  describe('clamp()', () => {
    it('returns value within min and max', () => {
      expect(clamp(5, 0, 10)).toBe(5);
    });

    it('returns min if value is less than min', () => {
      expect(clamp(-5, 0, 10)).toBe(0);
    });

    it('returns max if value is greater than max', () => {
      expect(clamp(15, 0, 10)).toBe(10);
    });

    it('returns min if value equals min', () => {
      expect(clamp(0, 0, 10)).toBe(0);
    });

    it('returns max if value equals max', () => {
      expect(clamp(10, 0, 10)).toBe(10);
    });
  });

  // --- randomInt() ---
  describe('randomInt()', () => {
    it('generates number within min and max', () => {
      for (let i = 0; i < 100; i++) {
        const val = randomInt(1, 5);
        expect(val).toBeGreaterThanOrEqual(1);
        expect(val).toBeLessThanOrEqual(5);
      }
    });

    it('returns min if min equals max', () => {
      expect(randomInt(3, 3)).toBe(3);
    });
  });
});
