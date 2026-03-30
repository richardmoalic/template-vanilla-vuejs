import { describe, expect, it } from 'vitest';
import { chunk, unique } from '@/utils/array';

describe('utils/array', () => {
  describe('unique()', () => {
    it('removes duplicate numbers', () => {
      expect(unique([1, 2, 2, 3])).toEqual([1, 2, 3]);
    });

    it('removes duplicate strings', () => {
      expect(unique(['a', 'b', 'a'])).toEqual(['a', 'b']);
    });

    it('returns empty array if input is empty', () => {
      expect(unique([])).toEqual([]);
    });

    it('keeps original order', () => {
      expect(unique([3, 1, 2, 1])).toEqual([3, 1, 2]);
    });
  });

  describe('chunk()', () => {
    it('splits array into chunks of given size', () => {
      expect(chunk([1, 2, 3, 4], 2)).toEqual([
        [1, 2],
        [3, 4],
      ]);
    });

    it('handles uneven chunk sizes', () => {
      expect(chunk([1, 2, 3], 2)).toEqual([[1, 2], [3]]);
    });

    it('returns single chunk if size > array length', () => {
      expect(chunk([1, 2], 5)).toEqual([[1, 2]]);
    });

    it('returns empty array if input is empty', () => {
      expect(chunk([], 2)).toEqual([]);
    });

    it('handles size = 1', () => {
      expect(chunk([1, 2, 3], 1)).toEqual([[1], [2], [3]]);
    });
  });
});
