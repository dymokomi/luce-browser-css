# luce-browser-css

CSS Syntax Level 3 below the object model (tokenizer, tokens, component values) and the generated CSS data tables, from Ladybird's LibWeb, in luce-base.

Part of the luce-browser family, a faithful port of Ladybird's LibWeb to luce-base; the design every
porter follows is [DESIGN.md](../luce-browser-engine/docs/DESIGN.md).

| Module | Contents |
| --- | --- |
| `css_syntax` | CSS tokenizer, tokens, component values |
| `css_data` | generated CSS data |

Depends on: luce-std, luce-browser-foundation.

## Status

Skeleton: every type of the phase-1 closure is declared and every function has its generated
signature and a `trap("unported: ...")` body, grouped by region (`docs/regions.tsv`). Regions
replace their stub fragments with ported code (DESIGN.md §4.5). `docs/namemap.tsv` maps every C++
name to its Luce name; `docs/gc_fields.tsv` lists the GC pointer fields each cell must visit.

The skeleton is generated from Ladybird at `47c82b38d0` (see `PIN`) by a local tool that is not part
of this repository.

## Testing

`./test.sh` type-checks every module.

## License

BSD-2-Clause, as Ladybird; see `LICENSE`.
