/* eslint-env node */
module.exports = {
  root: true,
  parser: '@typescript-eslint/parser',
  parserOptions: {
    project: ['tsconfig.json', 'tsconfig.dev.json'],
    sourceType: 'module',
  },
  plugins: ['@typescript-eslint'],
  extends: [
    'eslint:recommended',
    'plugin:@typescript-eslint/recommended',
  ],
  rules: {
    // Stop failing on spacing inside { ... }
    'object-curly-spacing': 'off',

    // Stop failing on 80-char lines
    'max-len': 'off',

    // We sometimes use 'any' in Cloud Functions data payloads
    '@typescript-eslint/no-explicit-any': 'off',

    // Keep a trailing newline at EOF
    'eol-last': ['error', 'always'],
  },
};