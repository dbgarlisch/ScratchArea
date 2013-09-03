package require PWI_Glyph 2.17.0
source [file join [file dirname [info script]] ".." "pwio.glf"]

if { ![getSelection Block blks errMsg] } {
    puts $errMsg
    exit 0
}
foreach blk $blks {
    set perimPtCnt [getPerimeterPointCount $blk]
    set ownedPtCnt [getOwnedPointCount $blk]
    puts "--------------------------------------------------------------------"
    puts "BLOCK [$blk getName] ($blk) | perim $perimPtCnt | owned $ownedPtCnt"
    set doms [getBlockDomains $blk]
    foreach dom $doms {
        if { [isBndryEnt $dom $blks] } {
            set domUsage "Boundary"
        } else {
            set domUsage "Connection"
        }
        set perimPtCnt [getPerimeterPointCount $dom]
        set ownedPtCnt [getOwnedPointCount $dom]
        puts "  BLOCK DOM [$dom getName]($dom) | perim $perimPtCnt | owned $ownedPtCnt | usage $domUsage"
    }

    set faces [getBlockFaces $blk]
    foreach face $faces {
        set perimPtCnt [getPerimeterPointCount $face]
        set ownedPtCnt [getOwnedPointCount $face]
        puts "  BLOCK FACE $face | perim $perimPtCnt | owned $ownedPtCnt"
        set doms [getFaceDomains $face]
        foreach dom $doms {
            puts "    FACE DOM [$dom getName] ($dom)"
        }
        set edges [getFaceEdges $face]
        foreach edge $edges {
            puts "    FACE EDGE $edge"
            set cons [getEdgeConnectors $edge]
            foreach con $cons {
                set perimPtCnt [getPerimeterPointCount $con]
                set ownedPtCnt [getOwnedPointCount $con]
                puts "      EDGE CON [$con getName] ($con) | perim $perimPtCnt | owned $ownedPtCnt"
            }
        }
    }
}
