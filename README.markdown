# supX: whatsapp extractor
Browse your whatsapp conversations.

## Supported platforms
At the moment I've tested supx only with a rooted android on a galaxy nexus

## Usage
Build and install the gem

```sh
$ gem build supx.gemspec
$ gem install ./supx-0.0.2.gem
```

run the supx dumper (you need `adb` running)
```sh
$ supx_dumper
```

and launch the sinatra web server on the same directory

```sh
$ supx
```

then go to [http://localhost:4567](http://localhost:4567) and browse your conversations

