# Releasing litpd

The PyPI distribution is published through GitHub Actions using PyPI trusted
publishing. This avoids storing a long-lived PyPI API token in the repository.

## One-time PyPI setup

Before publishing the first release, create the `litpd` project on PyPI's
trusted-publisher form. Configure it for:

- owner: `abhishekmishra`
- repository: `litpd`
- workflow: `publish-pypi.yml`
- environment: `pypi`

The project must not already exist. A pending publisher does not reserve the
name; PyPI creates the project when this workflow successfully publishes its
first release. If the repository owner differs, use the actual GitHub owner.

## Release checklist

1. Ensure `pyproject.toml`, `src/litpd/__init__.py`, and the version reported
   by `litpd --version` all agree. PyPI uses PEP 440, so the source release
   label `0.3.1-beta.0` is published as `0.3.1b0`.
2. Run `make clean all test package` and `python -m twine check dist/*`.
3. Commit the generated `src/litpd/cli.py` and `src/litpd/litpd_filter.lua`
   alongside their literate source in `litpd.md`.
4. Publish the GitHub release. The `Publish to PyPI` workflow tests, builds,
   validates, and uploads the wheel and source distribution through trusted
   publishing.

PyPI versions are immutable. If a release needs a correction, publish a new
version rather than rebuilding and uploading the same version.
