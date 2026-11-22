# Dry box clip

One-piece snap clip for a filament dry box. No screws.
Source: `dry_box_clamp.scad` (OpenSCAD, Customizer).

The clip is a C-spring. The gap between its two contact ridges is a little
smaller than the lid + rim stack. Push the clip on from the side. The clip
opens a little and presses the lid down on the box.

## Parameters

| Parameter      | Meaning                                                           | Default |
| -------------- | ----------------------------------------------------------------- | ------- |
| `stack`        | Lid top to the underside of the box rim (caliper measurement)     | 27 mm   |
| `preload`      | The ridge gap is this much smaller than `stack`. More = tighter.  | 0.8 mm  |
| `top_reach`    | Distance the top ridge reaches in over the lid                    | 12 mm   |
| `bottom_reach` | Distance the bottom ridge reaches in under the rim                | 4 mm    |
| `spine_t`      | Spine thickness. Thinner = softer spring.                         | 3.2 mm  |

## Files

- `stl/clip.stl`: one clip, 15 mm wide, preload 0.8 mm.
- `stl/test_set.stl`: three narrow clips (8 mm), preload 0.4 / 0.8 / 1.2 mm from left to right.
  Print this set first. Then set `preload` to the best value.

## Print

- Print the clip on its side, as exported. Layers then follow the spring.
- PETG is better than PLA. PLA can crack or lose tension over time.
- 4 walls or more, 100 % infill is OK for a small part.
