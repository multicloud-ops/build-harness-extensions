# Build Harness Extensions

Extensions to CloudPosse Build Harness

Based on Build Harness Extensions work done by @schmidtd and others

The build harness extensions have the following focus areas

## Deterministic auto-versioning and release stream handling

The module in [modules/semver](modules/semver) does not introduce any new make targets, but instead makes a number of environment variables available for other parts of the build harness.
The environment variables are calculated using `git describe` and  assume a `<major>.<minor>` based release branch strategy, with annotated git `<major>.<minor>` tags on a unique commit on each branch.
The following variables are populated and made available

```bash
SEMVERSION_MAJOR_MINOR   = <annotated tag>  i.e. 1.0
SEMVERSION_GIT_CANONICAL = <annotated tag>-<no. of commits since tag>-g<first 10 chars of commit hash>. i.e. 1.0-18-g351fcf626a
                           -- if not detected to run in a CI environment a dirty hash will also be added when working with dirty git state
```

These are utilised by some of the docker targets that the extensions introduce

```bash
docker/image/push/release-latest            Retags the current image build to conventions and pushes to the target Docker registry
docker/arch/manifest/push/release-latest    Retags the current "fat" (multi-platform) Docker manifest to conventions and pushes to the target Docker registry
```

These targets will retag the currently built tag to a release-stream specific tag (i.e. `1.0-latest`, `1.1-latest`, etc) depending on which release branch the build is triggered from

## Architecture specific docker builds

The extensions also inctroduce architecture awareness to docker builds

The following targets are made available

```bash
docker/arch/build                   Builds an architecture-specific Docker image
docker/arch/image/push              Pushes a architecture-specific Docker image
docker/arch/manifest/build          Builds a "fat" (multi-platform) Docker manifest
docker/arch/manifest/push           Pushes a "fat" (multi-platform) Docker manifest
```

## Docker private registry handling

```bash
docker/registry/login               Logs in to a private container registry $(TARGET_DOCKER_REGISTRY) as $(DOCKER_USERNAME) $(DOCKER_PASSWORD)
```
