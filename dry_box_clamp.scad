// Snap clip for a filament dry box (no screws, one printed part)
//
// The clip is a C-spring. The gap between the two contact ridges is a little
// smaller than the lid + rim stack. You push the clip on from the side. The
// C-frame opens a little and then presses the lid down on the box.
//
// Measure the stack: lid top to the underside of the box rim (the same
// position as the caliper jaws). Put this value in `stack`.
//
// Coordinates (use position):
//   x = into the box. x = 0 is the outermost point of lid / rim.
//   y = along the box edge (clip width)
//   z = up. z = 0 is the underside of the box rim.

/* [Part] */
part = "assembly"; // [assembly:Assembly preview, clip:Clip (print orientation), test_set:Test set - 3 clips with different preload]

/* [Box measurements] */
// Lid top to the underside of the box rim (mm)
stack = 23;
// Distance the top ridge reaches in over the lid, measured from x = 0 (mm)
top_reach = 22;
// Distance the bottom ridge reaches in under the rim, measured from x = 0 (mm)
bottom_reach = 4;

/* [Fit] */
// Interference: the ridge gap is this much smaller than the stack (mm). More = tighter.
preload = 0.8;
// Height of the contact ridges (mm)
ridge_h = 1.0;
// Air between the spine and the outermost point of lid / rim (mm)
spine_clear = 1.5;

/* [Frame] */
// Clip width along the box edge (mm)
width = 15;
// Spine thickness (mm). Thinner = softer spring.
spine_t = 3.2;
// Jaw thickness (mm)
jaw_t = 3.5;
// Inner fillet radius (mm). It also gives space for a round lid edge.
fillet_r = 2.5;
// Outer edge radius (mm)
edge_r = 1;

/* [Hidden] */
$fn = 64;
ridge_r = 1.6;

// ---------------------------------------------------------------------------

if (part == "assembly")
  assembly();
else if (part == "clip")
  print_pose() clip(preload);
else if (part == "test_set")
  for (i = [0:2])
    translate([i * (top_reach + spine_clear + spine_t + 8), 0, 0])
      print_pose() clip([0.4, 0.8, 1.2][i], 8);

// ---------------------------------------------------------------------------

function contact_gap(p) = stack - p;
function face_gap(p) = contact_gap(p) + 2 * ridge_h;

echo(str("CLIP: stack ", stack, " mm, ridge gap ", contact_gap(preload), " mm, preload ", preload, " mm"));

// Ridge: round bump along y, protrudes `ridge_h` out of the jaw face.
// `up` = 1 for the bottom jaw (bump points up), -1 for the top jaw.
module ridge2d(x, face_z, up) {
  translate([x - ridge_r, face_z + up * (ridge_h - ridge_r)]) circle(r=ridge_r);
}

module profile2d(p) {
  H = face_gap(p);
  xs = -spine_clear - spine_t; // outer face of the spine
  // bottom jaw: top face at z = -ridge_h, so the ridge top is at z = 0
  bz = -ridge_h;
  // top jaw: underside at z = bz + H, so the ridge bottom is at contact_gap
  tz = bz + H;

  offset(r=edge_r) offset(delta=-edge_r)
      offset(r=-fillet_r) offset(delta=fillet_r)
          union() {
            translate([xs, bz - jaw_t]) square([spine_t, H + 2 * jaw_t]); // spine
            translate([xs, bz - jaw_t]) square([bottom_reach - xs, jaw_t]); // bottom jaw
            translate([xs, tz]) square([top_reach - xs, jaw_t]); // top jaw
          }
  ridge2d(bottom_reach, bz, 1);
  ridge2d(top_reach, tz, -1);
}

module clip(p, w = width) {
  translate([0, w, 0]) rotate([90, 0, 0]) linear_extrude(w) profile2d(p);
}

// Lay the clip on its side: the C-profile is flat on the bed.
// Layers then follow the spring, which is the strongest direction.
module print_pose() {
  rotate([90, 0, 0]) children();
}

module assembly() {
  color("orange") clip(preload);
  // ghost of lid and box rim (simplified)
  %translate([0, -20, 0]) cube([60, width + 40, stack]);
  %translate([bottom_reach + 0.5, -20, -40]) cube([2, width + 40, 40]);
}
