import { defineConfig, globalIgnores } from 'eslint/config'
import boundaries from 'eslint-plugin-boundaries'
import reactHooks from 'eslint-plugin-react-hooks'
import tseslint from 'typescript-eslint'

export default defineConfig([
  globalIgnores(['coverage', 'dist']),
  {
    files: ['**/*.{ts,tsx}'],
    extends: [tseslint.configs.strictTypeChecked, reactHooks.configs.flat.recommended],
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
      'import/resolver': { typescript: true },
      'boundaries/elements': [
        { type: 'components', pattern: 'src/components' },
        { type: 'hooks', pattern: 'src/hooks' },
        { type: 'lib', pattern: 'src/lib' },
      ],
      'boundaries/files': [{ category: 'entry', pattern: 'src/{main,App}.tsx' }],
    },
    rules: {
      'boundaries/dependencies': ['error', {
        policies: [
          { from: { file: { categories: 'entry' } }, allow: { to: [{ file: { categories: 'entry' } }, { element: { types: ['components', 'hooks', 'lib'] } }] } },
          { from: { element: { type: 'components' } }, allow: { to: { element: { types: ['hooks', 'lib'] } } } },
          { from: { element: { type: 'hooks' } }, allow: { to: { element: { type: 'lib' } } } },
        ],
      }],
    },
  },
])
