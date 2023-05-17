#!/bin/tclsh
proc draw_arrow {mol start end material color} {
    # draw an arrow from start to end
    # mol: molecule id
    # start: starting point of the arrow {x y z}
    # end: ending point of the arrow {x y z}
    # material: material name, e.g. "AOShiny"
    # color: color name, e.g. "red"
    # an arrow is made of a cylinder and a cone
    set middle [vecadd $start [vecscale 0.8 [vecsub $end $start]]]
    graphics $mol materials on
    graphics $mol material $material
    graphics $mol color $color
    graphics $mol cylinder $start $middle radius 0.15 resolution 20
    graphics $mol cone $middle $end radius 0.25 resolution 20
}