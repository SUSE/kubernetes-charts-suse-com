#!/bin/bash
set -euo pipefail

# run the entire script and exit with 1, when an error occured
EXIT_CODE=0

# List of directories which contains modified helm charts.
DIRS=($(git diff --dirstat=files,1 origin/master -- stable/ | sed 's/^[ 0-9.]\+% //g' | cut -f1,2 -d'/'))

if [ "${#DIRS[@]}" -eq 0 ]; then
    echo "No charts were modified."
    exit 0
fi

# helm package test
for dir in "${DIRS[@]}"; do
  pushd "${dir}"
  echo "Packaging chart ${dir}..."
  helm package . ||  EXIT_CODE=$?
  popd
done

set_helm_args() {
    helm_args=""
    case "${1}" in
        stable/cf)
            helm_args=(
                "--values=$(realpath .ci/scf-config-values.yaml)"
            )
            ;;
        stable/kubecf)
            helm_args=(
                "--values=$(realpath .ci/kubecf-config-values.yaml)"
            )
            ;;
    esac
}

# helm lint test
for dir in "${DIRS[@]}"; do
  [[ "$dir"  == "stable/rook-ceph" ]] && continue
  echo "Linting chart ${dir}..."
  set_helm_args "${dir}"
  pushd "${dir}"
  helm lint "${helm_args[@]}" . || EXIT_CODE=$?
  popd
done

exit ${EXIT_CODE}
