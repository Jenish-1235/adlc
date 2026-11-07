skill_dirs := ".agents/skills .claude/skills"
pointer := "Follow the team rules in `.adlc/AGENTS.md`."

_default:
    @just --list

# Create a project from a template and install ADLC into it
new template project:
    #!/usr/bin/env bash
    set -euo pipefail
    cd "{{ invocation_directory() }}"
    mkdir "{{ project }}"
    cp -R "{{ justfile_directory() }}/templates/{{ template }}/." "{{ project }}"
    git -C "{{ project }}" init -q
    just --justfile "{{ justfile() }}" install "$(cd "{{ project }}" && pwd)"

# Link ADLC policies and skills into a project
install project:
    #!/usr/bin/env bash
    set -euo pipefail
    cd "{{ invocation_directory() }}"
    cd "{{ project }}"
    exclude=$(git rev-parse --git-path info/exclude)
    add_exclude() { grep -qxF "$1" "$exclude" 2>/dev/null || echo "$1" >> "$exclude"; }
    ln -sfn "{{ justfile_directory() }}" .adlc
    add_exclude .adlc
    for dir in {{ skill_dirs }}; do
      mkdir -p "$dir"
      for skill in .adlc/skills/*/; do
        name=$(basename "$skill")
        ln -sfn "../../.adlc/skills/$name" "$dir/$name"
        add_exclude "$dir/$name"
      done
    done
    grep -qxF '{{ pointer }}' AGENTS.md 2>/dev/null || echo '{{ pointer }}' >> AGENTS.md
    [ -e CLAUDE.md ] || ln -s AGENTS.md CLAUDE.md

# Remove ADLC links from a project
uninstall project:
    #!/usr/bin/env bash
    set -euo pipefail
    cd "{{ invocation_directory() }}"
    cd "{{ project }}"
    exclude=$(git rev-parse --git-path info/exclude)
    remove_line() {
      if [ -f "$2" ]; then
        grep -vxF "$1" "$2" > "$2.tmp" || true
        mv "$2.tmp" "$2"
      fi
    }
    for skill in .adlc/skills/*/; do
      name=$(basename "$skill")
      for dir in {{ skill_dirs }}; do
        rm -f "$dir/$name"
        remove_line "$dir/$name" "$exclude"
      done
    done
    rm -f .adlc
    remove_line .adlc "$exclude"
    remove_line '{{ pointer }}' AGENTS.md

# Check every skill has a valid name and description
validate:
    #!/usr/bin/env bash
    set -uo pipefail
    status=0
    for file in skills/*/SKILL.md; do
      folder=$(basename "$(dirname "$file")")
      name=$(sed -n 's/^name: *//p' "$file" | head -1)
      description=$(sed -n 's/^description: *//p' "$file" | head -1)
      [[ "$name" == "$folder" ]] || { echo "$file: name '$name' must match folder '$folder'"; status=1; }
      [[ "$name" =~ ^[a-z0-9-]{1,64}$ ]] || { echo "$file: name must be lowercase letters, numbers, hyphens, max 64 chars"; status=1; }
      (( ${#description} > 0 && ${#description} <= 1024 )) || { echo "$file: description must be 1-1024 chars"; status=1; }
    done
    exit $status
