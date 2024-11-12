# Helm Starter OCI Plugin

`helm-starter-oci` is a Helm plugin that allows you to manage starter charts hosted in an OCI-based registry. You can pull and update charts to simplify creating charts with common configurations, and also delete charts locally if required.

## Install

```bash
helm plugin install https://github.com/thepaulmacca/helm-starter-oci
```

## Commands

> [!IMPORTANT]
> For the `pull` and `update` commands, a `--version` must be specified.

### pull

Pulls a starter chart from an OCI registry and saves it to your local Helm starters directory (`$(helm env HELM_DATA_HOME)/starters`). This chart can then be used with `helm create`. For example:

```bash
# pull chart
helm starter-oci pull oci://ghcr.io/thepaulmacca/charts/deployment --version 0.1.0

# create chart
helm create demo --starter deployment
```

### update

Updates a starter chart to the specified version from the OCI registry if it already exists locally. Useful for ensuring that your starter charts are up-to-date. For example:

```bash
helm starter-oci update oci://ghcr.io/thepaulmacca/charts/deployment --version 0.2.0
```

### list

List all locally stored starter charts. For example:

```bash
helm starter-oci list
```

### delete

Deletes a locally stored starter chart. For example:

```bash
helm starter-oci delete deployment
```

### help

Displays the help message with usage information for each command.

```bash
helm starter-oci help
```
