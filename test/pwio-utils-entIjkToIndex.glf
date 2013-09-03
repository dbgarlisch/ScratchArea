package require PWI_Glyph 2.17.0
source [file join [file dirname [info script]] ".." "pwio.glf"]

proc doit { blk ijk } {
    set ijkdim [$blk getDimensions]
    # do a round-trip mapping from ijk to ndx and back to ijk
    set ndx [entIjkToIndex $blk $ijk]
    set ijk2 [entIndexToIjk $blk $ndx]
    puts [format "\{%s\} ::> %3s ::> \{%s\}" $ijk $ndx $ijk2]
}

if { ![getSelection Block blks errMsg] } {
    puts $errMsg
    exit 0
}
foreach blk $blks {
    puts "--- [$blk getName] ($blk) ---"
    set ijkdim [$blk getDimensions]
    lassign $ijkdim imax jmax kmax
    for {set k 1} {$k <= $kmax} {incr k} {
        for {set j 1} {$j <= $jmax} {incr j} {
            for {set i 1} {$i <= $imax} {incr i} {
                doit $blk [list $i $j $k]
            }
        }
    }
    puts ""
}

puts "bad ijk \{[list $i $j $k]\}"
# This will throw a TCL Glyph error after last block
doit $blk [list $i $j $k]

# Output:
# --- blk-5 (::pw::BlockStructured_2) ---
# {1 1 1} ::>   1 ::> {1 1 1}
# {2 1 1} ::>   2 ::> {2 1 1}
# {3 1 1} ::>   3 ::> {3 1 1}
#    ...SNIP...
# {1 4 3} ::>  34 ::> {1 4 3}
# {2 4 3} ::>  35 ::> {2 4 3}
# {3 4 3} ::>  36 ::> {3 4 3}
#
# --- blk-4 (::pw::BlockStructured_1) ---
# {1 1 1} ::>   1 ::> {1 1 1}
# {2 1 1} ::>   2 ::> {2 1 1}
# {3 1 1} ::>   3 ::> {3 1 1}
#    ...SNIP...
# {1 4 3} ::>  34 ::> {1 4 3}
# {2 4 3} ::>  35 ::> {2 4 3}
# {3 4 3} ::>  36 ::> {3 4 3}
#
# bad ijk {4 5 4}
# ----- TCL TRACE -----
# ERROR: value outside the range [(1,1,1),(3,4,3)]
# ERROR: usage (argument 2): ::pw::BlockStructured_1 getLinearIndex ijk_index
