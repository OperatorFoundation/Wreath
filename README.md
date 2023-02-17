# Wreath

Part of the Discovery Service.

### To generate new client / server configs ###

Wreath uses the 'ArgumentParser' library to parse and execute command line arguments.

From the Wreath directory in your macOS / Linux command line terminal;

• To see what subcommands you have available to you:

$ swift run

```
example print out
USAGE: WreathServer <subcommand>

OPTIONS:
  -h, --help              Show help information.

SUBCOMMANDS:
  new
  run

  See 'WreathServer help <subcommand>' for detailed help.
```
===

• To create new client / server configs:

$ swift run WreathServer new <exampleConfigName> <port>

```
Wrote config to ~/wreath-server.json
Wrote config to ~/wreath-client.json
```
===

• To run the server:

$ swift run WreathServer run

```
...
Server started 🚀
Server listening 🪐
...
```
