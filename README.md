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

## In order to get changed files you can use GitHub API

```yaml
- name: Get all changed .swift files
    id: changed-files
    run: |
      api_url="https://api.github.com/repos/${{github.repository}}/pulls/${{github.event.pull_request.number}}/files"
      response=$(curl -s -H "Authorization: token ${{ secrets.GITHUB_TOKEN }}" "$api_url")
      filenames=$(echo "$response" | jq -r '.[].filename')
      swift_files=$(echo $filenames | tr ' ' '\n' | grep '\.swift$')
      echo "files_to_lint="${swift_files}"" >> "$GITHUB_OUTPUT"
  - name: SwiftLint
    uses: kamwysoc/swiftlint-ghaction@main
    env:
      CHANGED_FILES: "${{ steps.changed-files.outputs.files_to_lint }}"
      LINT_PARAMETERS: "lint --strict --config .swiftlint_ci_rules.yml"
```
