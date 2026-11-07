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

# Install ADLC into an existing project and report what doesn't match the structure
onboard project: (install project) (verify project)

# Check a project's layout, recipes, and CI stages against the ADLC structure
verify project:
    #!/usr/bin/env bash
    set -uo pipefail
    cd "{{ invocation_directory() }}" && cd "{{ project }}" || exit 1
    gaps=0
    gap() { echo "$1"; gaps=1; }
    for path in .gitlab-ci.yml .gitlab/ci.yml .gitlab/ct.yml .gitlab/cd.yml .gitlab/qa.yml .gitlab/loadtest.yml \
                .gitlab/CODEOWNERS deploy/Dockerfile deploy/local/docker-compose.yml \
                deploy/k8s/staging deploy/k8s/prod deploy/terraform/staging deploy/terraform/prod justfile; do
      [ -e "$path" ] || gap "missing: $path"
    done
    [ ! -d migrations ] || [ -e deploy/Dockerfile.db.migrate ] || gap "missing: deploy/Dockerfile.db.migrate"
    packages=$( { find cmd internal -name '*.go' -exec dirname {} \; ; find src deploy -mindepth 1 -maxdepth 1 -type d; } 2>/dev/null | sort -u)
    for dir in $packages; do
      for doc in README.md CHANGELOG.md; do
        [ -e "$dir/$doc" ] || gap "missing: $dir/$doc"
      done
    done
    if [ -f justfile ]; then
      recipes=" $(just --summary 2>/dev/null) "
      for recipe in setup dev test lint up down; do
        [[ "$recipes" == *" $recipe "* ]] || gap "missing: just recipe '$recipe'"
      done
    fi
    if [ -f .gitlab-ci.yml ]; then
      previous=0
      for stage in lint-and-test coverage-and-sast security-and-sbom push sign; do
        line=$(grep -nE "^[[:space:]]*-[[:space:]]*${stage}[[:space:]]*$" .gitlab-ci.yml | head -1 | cut -d: -f1)
        if [ -z "$line" ]; then gap "missing: CI stage '$stage'"
        elif [ "$line" -lt "$previous" ]; then gap "out of order: CI stage '$stage'"
        else previous=$line; fi
      done
    fi
    if [ $gaps -eq 0 ]; then echo "Matches the ADLC structure."; else echo "Ask your agent to run the onboard-project skill."; fi
    exit $gaps

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
    for file in skills/*/SKILL.md templates/*/.agents/skills/*/SKILL.md; do
      folder=$(basename "$(dirname "$file")")
      name=$(sed -n 's/^name: *//p' "$file" | head -1)
      description=$(sed -n 's/^description: *//p' "$file" | head -1)
      [[ "$name" == "$folder" ]] || { echo "$file: name '$name' must match folder '$folder'"; status=1; }
      [[ "$name" =~ ^[a-z0-9-]{1,64}$ ]] || { echo "$file: name must be lowercase letters, numbers, hyphens, max 64 chars"; status=1; }
      (( ${#description} > 0 && ${#description} <= 1024 )) || { echo "$file: description must be 1-1024 chars"; status=1; }
    done
    exit $status
