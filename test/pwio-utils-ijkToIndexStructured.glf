package require PWI_Glyph 2.17.0
source [file join [file dirname [info script]] ".." "pwio.glf"]

proc doit { ijk ijkdim } {
    # do a round-trip mapping from ijk to ndx and back to ijk
    set ndx [ijkToIndexStructured $ijk $ijkdim]
    set ijk2 [indexToIjkStructured $ndx $ijkdim]
    puts [format "\{%s\} ::> %3s ::> \{%s\}" $ijk $ndx $ijk2]
}

# Define the ijkdim index space (indices 1..max)
set ijkdim [list 5 4 3]
lassign $ijkdim imax jmax kmax
for {set k 1} {$k <= $kmax} {incr k} {
    for {set j 1} {$j <= $jmax} {incr j} {
        for {set i 1} {$i <= $imax} {incr i} {
            doit [list $i $j $k] $ijkdim
        }
    }
}
# this will fail
puts "bad ijk \{[list $i $j $k]\}"
doit [list $i $j $k] $ijkdim

# Output:
# {1 1 1} ::>   1 ::> {1 1 1}
# {2 1 1} ::>   2 ::> {2 1 1}
# {3 1 1} ::>   3 ::> {3 1 1}
#    ...SNIP...
# {3 4 3} ::>  58 ::> {3 4 3}
# {4 4 3} ::>  59 ::> {4 4 3}
# {5 4 3} ::>  60 ::> {5 4 3}
# bad ijk {6 5 4}
# assert failed: (86 > 0 && 86 <= (5 * 4 * 3))
# message      : indexToIjkStructured: Invalid ndx (86)
