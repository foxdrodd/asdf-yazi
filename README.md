<div align="center">

# asdf-yazi [![Build](https://github.com/anrub/asdf-yazi/actions/workflows/build.yml/badge.svg)](https://github.com/anrub/asdf-yazi/actions/workflows/build.yml) [![Lint](https://github.com/anrub/asdf-yazi/actions/workflows/lint.yml/badge.svg)](https://github.com/anrub/asdf-yazi/actions/workflows/lint.yml)

[yazi](https://yazi-rs.github.io/) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

**TODO: adapt this section**

- `bash`, `curl`, `tar`, and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html).
- `SOME_ENV_VAR`: set this environment variable in your shell config to load the correct version of tool x.

# Install

Plugin:

```shell
asdf plugin add yazi
# or
asdf plugin add yazi https://github.com/anrub/asdf-yazi.git
```

yazi:

```shell
# Show all installable versions
asdf list-all yazi

# Install specific version
asdf install yazi latest

# Set a version globally (on your ~/.tool-versions file)
asdf global yazi latest

# Now yazi commands are available
yazi --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/anrub/asdf-yazi/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [flo](https://github.com/anrub/)
