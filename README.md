# wlrix-protocols

The Wayland protocols wlRIX defines for itself: what the compositor offers that no standard
protocol does.

It is data. It builds nothing, installs nothing, and has no code of its own; each consumer
generates its bindings from these files at build time.

## What is in it

| Protocol                 | Global                          | For                                                                                                                                                     |
|--------------------------|---------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------|
| `wlrix-desks.xml`        | `wlrix_desks_manager_v1`        | Desks (virtual desktops) and their windows, with live window geometry. The standard alternatives carry no geometry, which the Desks Overview draws.    |
| `wlrix-output-color.xml` | `wlrix_output_color_manager_v1` | HDR and adaptive sync capability for `wlr-output-management` heads, and HDR changes staged into its configurations. That protocol has no HDR at all. |

`wlrix-output-color` extends `wlr-output-management-unstable-v1` and names its interfaces, so
a consumer needs that protocol's bindings too.

## Who uses it

Each consumer carries this repo as a git submodule, so it still builds from a fresh clone
(`git clone --recurse-submodules`, or `git submodule update --init` afterwards):

| Consumer           | Submodule path               | Generates                                                        |
|--------------------|------------------------------|------------------------------------------------------------------|
| `wlrix-compositor` | `protocols/`                 | server code, with `wayland-scanner`'s proc-macros                |
| `NWayland`         | `external/wlrix-protocols/`  | C# client code, through the fork's source generator, for `wlrix-apps` |

Before this repo the compositor and the NWayland fork each kept a copy, kept identical by hand.

## Changing a protocol

A client binds at *its* version, not the one advertised, so a change that existing clients
could see is a version bump:

- New requests and events go at the end of their interface, with `since="N"`, and the
  interface's `version` goes up. The compositor must guard every newer event at the point it
  sends it.
- Nothing is removed or reordered, and no argument changes type. That is a new `_v2` interface.
- Description fixes need no bump.

Then move the submodule pin in both consumers. `just check` validates every file against the
Wayland DTD and `wayland-scanner --strict`.

## License

MIT; see `LICENSE`. Each protocol also carries the usual Wayland permission notice in its
`<copyright>` block, so it can be copied into another project on its own.
