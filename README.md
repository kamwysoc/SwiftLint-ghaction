# SwiftLint Action

Action that runs SwiftLint using [docker](https://github.com/realm/SwiftLint#docker)

## Usage

`CHANGED_FILES` - pass here all the files that you would like to lint, separated by space.
`LINT_PARAMETERS` - pass here all the parameters for `swiftlint` command. For example `lint --strict`

```yaml
- name: SwiftLint
    uses: kamwysoc/swiftlint-ghaction@main
    env:
      CHANGED_FILES: "/Path/To/file_to_lint.swift /Path/To/file_to_lint2.swift"
      LINT_PARAMETERS: "lint --strict --config .swiftlint_ci_rules.yml"
```

## In order to get changed files you can use checkout action

```yaml
  - uses: actions/checkout@v3
    with:
      fetch-depth: 0 # just to fetch all branches and tags
  - name: Changed files
    id: changed-files
    run: |
      RESULT=$(git diff --name-only origin/${{ github.head_ref }} $(git merge-base origin/${{github.head_ref}} origin/${{github.base_ref}}) | grep '\.swift$' | tr '\n' ' ')
      echo $RESULT
      echo "files_to_lint="${RESULT:-''}"" >> "$GITHUB_OUTPUT"
  - name: SwiftLint
    uses: kamwysoc/swiftlint-ghaction@main
    env:
      CHANGED_FILES: "${{ steps.changed-files.outputs.files_to_lint }}"
      LINT_PARAMETERS: "lint --strict --config .swiftlint_ci_rules.yml"
```
