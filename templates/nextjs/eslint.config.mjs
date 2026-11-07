import { defineConfig, globalIgnores } from 'eslint/config'
import nextVitals from 'eslint-config-next/core-web-vitals'
import boundaries from 'eslint-plugin-boundaries'
import tseslint from 'typescript-eslint'

export default defineConfig([
  ...nextVitals,
  globalIgnores(['coverage']),
  {
    files: ['**/*.{ts,tsx}'],
    extends: [tseslint.configs.strictTypeChecked],
    languageOptions: {
      parserOptions: {
        projectService: true,
        tsconfigRootDir: import.meta.dirname,
      },
    },
    rules: {
      '@typescript-eslint/ban-ts-comment': ['error', { 'ts-expect-error': true }],
      '@typescript-eslint/consistent-type-assertions': ['error', { assertionStyle: 'never' }],
      '@typescript-eslint/switch-exhaustiveness-check': 'error',
      'react-hooks/exhaustive-deps': 'error',
    },
  },
  {
    linterOptions: { noInlineConfig: true },
    plugins: { boundaries },
    settings: {
      'boundaries/elements': [
        { type: 'app', pattern: 'src/app' },
        { type: 'components', pattern: 'src/components' },
        { type: 'lib', pattern: 'src/lib' },
      ],
    },
    rules: {
      'boundaries/dependencies': ['error', {
        policies: [
          { from: { element: { type: 'app' } }, allow: { to: { element: { types: ['components', 'lib'] } } } },
          { from: { element: { type: 'components' } }, allow: { to: { element: { type: 'lib' } } } },
        ],
      }],
    },
  },
])
