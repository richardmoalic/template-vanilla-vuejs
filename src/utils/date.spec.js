import { describe, expect, it, vi } from 'vitest';
import { formatDate, isPast } from '@/utils/date';

describe('utils/date', () => {
  // --- Tests for formatDate() ---
  describe('formatDate()', () => {
    it('formats date as YYYY-MM-DD', () => {
      const date = new Date(2026, 2, 29); // March 29, 2026 (month is 0-indexed)
      expect(formatDate(date)).toBe('2026-03-29');
    });

    it('pads single digit month and day with 0', () => {
      const date = new Date(2026, 0, 5); // Jan 5, 2026
      expect(formatDate(date)).toBe('2026-01-05');
    });
  });

  // --- Tests for isPast() ---
  describe('isPast()', () => {
    const now = new Date(2026, 2, 29, 12, 0, 0); // fixed "now"

    beforeAll(() => {
      vi.useFakeTimers();
      vi.setSystemTime(now);
    });

    afterAll(() => {
      vi.useRealTimers();
    });

    it('returns true for a past date', () => {
      const past = new Date(2026, 2, 28);
      expect(isPast(past)).toBe(true);
    });

    it('returns false for the current date/time', () => {
      const present = new Date(2026, 2, 29, 12, 0, 0);
      expect(isPast(present)).toBe(false);
    });

    it('returns false for a future date', () => {
      const future = new Date(2026, 2, 30);
      expect(isPast(future)).toBe(false);
    });
  });
});
