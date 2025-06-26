import antfu from '@antfu/eslint-config'

export default antfu({
  javascript: true,
  react: true,
  formatters: {
    css: true,
  },
  rules: {
    'react-refresh/only-export-components': 'off',
    'react/no-create-ref': 'off',

    'unicorn/error-message': 'off',

    'unused-imports/no-unused-vars': [
      'warn',
      {
        varsIgnorePattern: '^_',
      },
    ],
    'no-unused-vars': [
      'warn',
      {
        varsIgnorePattern: '^_',
      },
    ],
  },
})
