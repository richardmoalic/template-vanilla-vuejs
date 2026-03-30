import { describe, expect, it } from 'vitest';
import { capitalize, toKebabCase } from '@/utils/string';

describe('utils/string', () => {
  // --- capitalize() ---
  describe('capitalize()', () => {
    it('capitalizes the first letter of a string', () => {
      expect(capitalize('hello')).toBe('Hello');
    });

    it('leaves first letter capitalized if already capitalized', () => {
      expect(capitalize('Hello')).toBe('Hello');
    });

    it('returns empty string if input is empty', () => {
      expect(capitalize('')).toBe('');
    });

    it('does not change the rest of the string', () => {
      expect(capitalize('hELLO')).toBe('HELLO');
    });
  });

  // --- toKebabCase() ---
  describe('toKebabCase()', () => {
    it('converts spaces to dashes', () => {
      expect(toKebabCase('hello world')).toBe('hello-world');
    });

    it('removes special characters', () => {
      expect(toKebabCase('hello@world!')).toBe('helloworld');
    });

    it('converts uppercase letters to lowercase', () => {
      expect(toKebabCase('Hello World')).toBe('hello-world');
    });

    it('handles multiple spaces', () => {
      expect(toKebabCase('hello   world')).toBe('hello-world');
    });

    it('returns empty string if input is empty', () => {
      expect(toKebabCase('')).toBe('');
    });
  });
});
