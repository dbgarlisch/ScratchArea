| [README.md](README.md) | [pwio-cell.md](pwio-cell.md) |

# glyph-pwio::utils

A collection of utility procs.


##Table Of Contents

* [Namespace pwio::utils](#namespace-pwioutils)
* [Library Reference pwio::utils](#library-reference-pwioutils)
* [Example Usage](#example-usage)
    * [Example 1](#example-1)
* [Disclaimer](#disclaimer)


## Namespace pwio::utils

All of the procs in this collection reside in the **pwio::utils** namespace.

To call a proc in this collection, you must prefix the proc name with a **pwio::utils::** namespace specifier.

For example:
```Tcl
pwio::utils::entBaseType $ent
```


## Library Reference pwio::utils

```Tcl
pwio::utils::assert { cond msg {exitVal -1} }
```
Asserts that `cond` evaluates to **true**. If **false**, `msg` is displayed and the script is terminated returning `exitVal`.
<dl>
  <dt><code>cond</code></dt>
  <dd>The condition to test.</dd>
  <dt><code>msg</code></dt>
  <dd>The message to display if <code>cond</code> evaluates to <b>false</b>.</dd>
  <dt><code>exitVal</code></dt>
  <dd>The fail exit value. If 0, the script will <b>not</b> exit and execution will continue.</dd>
</dl>

**Usage:**
```Tcl
set ndx 5
set ent [pw::Grid getByName "blk-1"]
pwio::utils::assert "$ndx >= 1 && $ndx < [$ent getPointCount]" \
                    "Bad Index $ndx for '[$ent getName]'"

# Output (if assert fails):
# assert failed: ($ndx >= 1 && $ndx < 3)
# message      : Bad Index 5 for 'blk-1'
```


<br/>
```Tcl
pwio::utils::entBaseType { ent {subTypeVarName ""} }
```
Returns `ent`'s base grid entity type.
<dl>
  <dt><code>ent</code></dt>
  <dd>A grid entity.</dd>
  <dt><code>subTypeVarName</code></dt>
  <dd>If provided, <code>ent</code>'s subtype is stored in this variable.</dd>
</dl>

Base grid types are one of **Node**, **Connector**, **Domain**, or **Block**.

For blocks, the subtype will be one of **Structured**, **Unstructured** or **Extruded**.

For domains, the subtype will be one of **Structured** or **Unstructured**.

For connectors, the subtype is set to **Connector**.

For nodes, the subtype is set to **Node**.

**Usage:**
```Tcl
foreach selType {Block Domain Connector} {
    if { ![pwio::utils::getSelection $selType selectedEnts errMsg] } {
        puts $errMsg
        continue;
    }
    puts "$selType selection:"
    foreach ent $selectedEnts {
        set baseType [pwio::utils::entBaseType $ent subType]
        puts "  [$ent getName]($ent) baseType='$baseType' subType='$subType'"
    }
}

# Output:
# Block selection:
#   blk-3(::pw::BlockExtruded_1) baseType='Block' subType='Extruded'
#   blk-1(::pw::BlockUnstructured_1) baseType='Block' subType='Unstructured'
# Domain selection:
#   dom-18(::pw::DomainUnstructured_2) baseType='Domain' subType='Unstructured'
#   dom-26(::pw::DomainStructured_6) baseType='Domain' subType='Structured'
# Connector selection:
#   con-55(::pw::Connector_22) baseType='Connector' subType='Connector'
#   con-37(::pw::Connector_20) baseType='Connector' subType='Connector'
```


<br/>
```Tcl
pwio::utils::getBlockFaces { blk }
```
Returns an list of `blk`'s face entities.
<dl>
  <dt><code>blk</code></dt>
  <dd>A block entity.</dd>
</dl>

The returned list contains [pw::Face][pwFace] entities.

See [Example 2](example-2) for usage.


<br/>
```Tcl
pwio::utils::getBlockDomains { blk }
```
Returns `blk`'s domains as a list of [pw::Domain][pwDomain] entities. It is possible for a domain to appear in the list more than once.
<dl>
  <dt><code>blk</code></dt>
  <dd>A block entity.</dd>
</dl>

See [Example 2](example-2) for usage.


<br/>
```Tcl
pwio::utils::getFaceDomains { face }
```
Returns `face`'s domains as a list of [pw::Domain][pwDomain] entities. It is possible for a domain to appear in the list more than once.
<dl>
  <dt><code>face</code></dt>
  <dd>A face entity.</dd>
</dl>

See [Example 2](example-2) for usage.


<br/>
```Tcl
pwio::utils::getFaceEdges { face }
```
Returns `face`'s edges as a list of [pw::Edge][pwEdge] entities. The first edge is `face`'s outer loop. Any additional edges are inner loops (holes).
<dl>
  <dt><code>face</code></dt>
  <dd>A face entity.</dd>
</dl>

See [Example 2](example-2) for usage.


<br/>
```Tcl
pwio::utils::getEdgeConnectors { edge }
```
Returns `edge`'s connectors as a list of [pw::Connector][pwConnector] entities. It is possible for a connector to appear in the list more than once.
<dl>
  <dt><code>edge</code></dt>
  <dd>An edge entity.</dd>
</dl>

See [Example 2](example-2) for usage.


<br/>
```Tcl
pwio::utils::getFaceEdgeConnectors { face }
```
Returns `face`'s connectors as a list of [pw::Connector][pwConnector] entities. It is possible for a connector to appear in the list more than once.
<dl>
  <dt><code>face</code></dt>
  <dd>A face entity.</dd>
</dl>


<br/>
```Tcl
pwio::utils::getPerimeterPointCount { ent }
```
Returns the number of [grid points][point] on `ent`'s outer perimeter. This count includes any holes or voids. Nodes will always return 0. Connectors will always return 2.
<dl>
  <dt><code>ent</code></dt>
  <dd>A grid entity.</dd>
</dl>

`ent` must be a [pw::Node][pwNode], [pw::Connector][pwConnector], [pw::Domain][pwDomain], [pw::Face][pwFace] or [pw::Block][pwBlock] entity.

See [Example 2](example-2) for usage.


<br/>
```Tcl
pwio::utils::getOwnedPointCount { ent }
```
Returns the number of [grid points][point] on `ent`'s interior (non-perimeter points). Nodes will always return 1.
<dl>
  <dt><code>ent</code></dt>
  <dd>A grid entity.</dd>
</dl>

`ent` must be a [pw::Node][pwNode], [pw::Connector][pwConnector], [pw::Domain][pwDomain], [pw::Face][pwFace] or [pw::Block][pwBlock] entity.

See [Example 2](example-2) for usage.


<br/>
```Tcl
pwio::utils::isBndryEnt { ent allEnts }
```
Returns **true** if `ent` lies on the boundary of `allEnts`.
<dl>
  <dt><code>ent</code></dt>
  <dd>A grid entity.</dd>
  <dt><code>allEnts</code></dt>
  <dd>A list of grid entites.</dd>
</dl>

An error will occur if `ent` is anything other than a [pw::Connector][pwConnector] entity in 2D and anything other than a [pw::Domain][pwDomain] entity in 3D.

See [Example 2](example-2) for usage.


<br/>
```Tcl
pwio::utils::getNodeDbEnt { node dbEntVarName }
```
Returns **true** if `node` is constrained to a DB entity.
<dl>
  <dt><code>node</code></dt>
  <dd>A node entity.</dd>
  <dt><code>dbEntVarName</code></dt>
  <dd>Required. If constrained, the DB entity is stored in this variable.</dd>
</dl>

`node` must be a [pw::Node][pwNode] entity.


<br/>
```Tcl
pwio::utils::entLockInterior { ent }
```
Locks `ent`'s [grid points][point].
<dl>
  <dt><code>ent</code></dt>
  <dd>A grid entity.</dd>
</dl>

A corresponding call to **pwio::utils::entUnlockInterior** must be made when finished.


<br/>
```Tcl
pwio::utils::entUnlockInterior { ent {clearAllLocks 0} }
```
Unlocks `ent`'s [grid points][point].
<dl>
  <dt><code>ent</code></dt>
  <dd>A grid entity previously locked with a call to <b>pwio::utils::entLockInterior</b>.</dd>
  <dt><code>clearAllLocks</code></dt>
  <dd>If 1, all active locks on <code>ent</code> will be released.</dd>
</dl>

Typically, `clearAllLocks` should be 0. You should explicitly lock and unlock entities. There is a logic error if an entity remains locked at script termination.


<br/>
```Tcl
pwio::utils::ijkToIndexStructured { ijk ijkdim }
```
Returns the linear index corresponding to `ijk` within the given `ijkdim` extents.
<dl>
  <dt><code>ijk</code></dt>
  <dd>The ijk index list to convert.</dd>
  <dt><code>ijkdim</code></dt>
  <dd>A list defining the full structured extents used for conversion.</dd>
</dl>

This proc does **not** check if `ijk` lies within the given `ijkdim` extents. If `ijk` is invalid, the returned index is invalid.

The reverse mapping is done with **pwio::utils::indexToIjkStructured**.


<br/>
```Tcl
pwio::utils::indexToIjkStructured { ndx ijkdim }
```
Returns the ijk index corresponding to `ndx` within the given `ijkdim` extents.
<dl>
  <dt><code>ndx</code></dt>
  <dd>The linear index to convert.</dd>
  <dt><code>ijkdim</code></dt>
  <dd>A list defining the full structured extents used for conversion.</dd>
</dl>

The reverse mapping is done with **pwio::utils::ijkToIndexStructured**.


<br/>
```Tcl
pwio::utils::entIjkToIndex { ent ijk }
```
Returns `ent`'s linear index that corresponds to `ijk`.
<dl>
  <dt><code>ent</code></dt>
  <dd>A grid entity.</dd>
  <dt><code>ijk</code></dt>
  <dd>The ijk index list to convert.</dd>
</dl>

The reverse mapping is done with **pwio::utils::entIndexToIjk**.


<br/>
```Tcl
pwio::utils::entIndexToIjk { ent ndx }
```
Returns `ent`'s ijk index that corresponds to `ndx`.
<dl>
  <dt><code>ent</code></dt>
  <dd>A grid entity.</dd>
  <dt><code>ndx</code></dt>
  <dd>The linear index to convert.</dd>
</dl>

The reverse mapping is done with **pwio::utils::entIjkToIndex**.


<br/>
```Tcl
pwio::utils::makeCoord { ent ijk }
```
Returns a [grid coord][coord] for the given `ent` and `ijk`.
<dl>
  <dt><code>ent</code></dt>
  <dd>A grid entity.</dd>
  <dt><code>ijk</code></dt>
  <dd>An ijk index list.</dd>
</dl>


<br/>
```Tcl
pwio::utils::makeCoordFromIjkVals { ent i j k }
```
Returns a [grid coord][coord] for the given `ent` and `i`, `j` and `k` index values.
<dl>
  <dt><code>ent</code></dt>
  <dd>A grid entity.</dd>
  <dt><code>i</code> <code>j</code> <code>k</code></dt>
  <dd>The individual i, j and k index values.</dd>
</dl>


<br/>
```Tcl
pwio::utils::makeCoordFromEntIndex { ent ndx }
```
Returns a [grid coord][coord] for the given `ent` and linear index.
<dl>
  <dt><code>ent</code></dt>
  <dd>A grid entity.</dd>
  <dt><code>ndx</code></dt>
  <dd>A 1-based index relative to <code>ent</code>'s index space.</dd>
</dl>


<br/>
```Tcl
pwio::utils::sortEntsByType { ents }
```
Returns a list containing `ents` in base type sorted order.
<dl>
  <dt><code>ents</code></dt>
  <dd>The list of grid entites to sort.</dd>
</dl>

The returned list will be in **Block**, **Domain**, **Connector**, **Node** order.


<br/>
```Tcl
pwio::utils::pointToString { pt }
```
Returns a string representation of `pt`.
<dl>
  <dt><code>pt</code></dt>
  <dd>A grid point list.</dd>
</dl>

`pt` is a [grid point][point].

The resulting string will be one of *"{x y z}"* or *"{u v dbEnt}"*.


<br/>
```Tcl
pwio::utils::xyzEqual { xyz1 xyz2 {tol 1e-8} }
```
Returns **true** if two xyz points are equal within the given tolerance.
<dl>
  <dt><code>xyz1</code></dt>
  <dd>First point as an <b>{x y z}</b> list.</dd>
  <dt><code>xyz2</code></dt>
  <dd>Second point as an <b>{x y z}</b> list.</dd>
  <dt><code>tol</code></dt>
  <dd>The optional comparison tolerance.</dd>
</dl>


<br/>
```Tcl
pwio::utils::valEqual { val1 val2 {tol 1e-8} }
```
Returns **true** if two values are equal within the given tolerance.
<dl>
  <dt><code>val1</code></dt>
  <dd>First value.</dd>
  <dt><code>val2</code></dt>
  <dd>Second value.</dd>
  <dt><code>tol</code></dt>
  <dd>The optional comparison tolerance.</dd>
</dl>


<br/>
```Tcl
pwio::utils::coordToPtString { coord }
```
Returns a string representation of a [grid coord][coord].
<dl>
  <dt><code>coord</code></dt>
  <dd>The grid coord.</dd>
</dl>


<br/>
```Tcl
pwio::utils::vcToString { vc }
```
Returns a string representation of a [pw::VolumeCondition][pwVolumeCondition].
<dl>
  <dt><code>vc</code></dt>
  <dd>The volume condition.</dd>
</dl>

The resulting string format will be *"vcName vcId vcPhysicalType"*


<br/>
```Tcl
pwio::utils::labelPt { ndx pt }
```
Returns a [pw::Note][pwNote] entity positioned at `pt`.
<dl>
  <dt><code>ndx</code></dt>
  <dd>The note text value.</dd>
  <dt><code>pt</code></dt>
  <dd>The note's position.</dd>
</dl>


<br/>
```Tcl
pwio::utils::printEntInfo { title ents {dim 0} {allEnts {}} }
```
Dumps a table of information about `ents`.
<dl>
  <dt><code>title</code></dt>
  <dd>The dump's title string.</dd>
  <dt><code>ents</code></dt>
  <dd>A list of grid entites to dump.</dd>
  <dt><code>dim</code></dt>
  <dd>The optional dimensionality used for the dump. If specified, it must be 2 or 3.</dd>
  <dt><code>allEnts</code></dt>
  <dd>An optional list of grid entites used to classify the dumped entities as either a boundary or connection.</dd>
</dl>

`allEnts` is ignored if `dim` is 0.


<br/>
```Tcl
pwio::utils::getSelection { selType selectedVarName errMsgVarName }
```
Prompts the user and returns **true** if one or more entities have been selected.
<dl>
  <dt><code>selType</code></dt>
  <dd>The entity base type to select.</dd>
  <dt><code>selectedVarName</code></dt>
  <dd>Required. The selected entities are stored in this variable.</dd>
  <dt><code>errMsgVarName</code></dt>
  <dd>Required. If <b>false</b> is returned, a failure message is stored in this variable.</dd>
</dl>

The valid `selType` values are **Connector**, **Domain**, **Block**, **Database**, **Spacing** or **Boundary**.

Only visible and enabled entities are considered for selection.

If only 1 entity of the the given `selType` is selectable, it is returned **without** prompting the user.

See also, **pwio::getSelectType**.


<br/>
```Tcl
pwio::utils::getSupportEnts { ents supEntsVarName {addEnts false}}
```
Returns **true** if the number of unique support entities stored in `supEntsVarName` is greater than 0.
<dl>
  <dt><code>ents</code></dt>
  <dd>A list of grid entites for which to get support entities.</dd>
  <dt><code>supEntsVarName</code></dt>
  <dd>Required. The lower level support entities are stored in this variable.</dd>
  <dt><code>addEnts</code></dt>
  <dd>If <b>true</b>, <code>ents</code> will also be added to <code>supEntsVarName</code>.</dd>
</dl>

A support entity is any lower level grid entity used to construct a higher level grid entity.

A [pw::Domain][pwDomain]'s support entities are its defining [pw::Connector][pwConnector]s and [pw::Node][pwNode]s.

A [pw::Block][pwBlock]'s support entities are its defining [pw::Domain][pwDomain]s, [pw::Connector][pwConnector]s and [pw::Node][pwNode]s.

Only [pw::Domain][pwDomain]s, [pw::Connector][pwConnector]s and [pw::Node][pwNode]s can be support entities.

Shared support entities are only included in `supEntsVarName` once.


## Example Usage

### Example 1

```Tcl
package require PWI_Glyph 2.17.0
source [file join [file dirname [info script]] ".." "pwio.glf"]

proc nm { ent } {
    if { "" != "$ent" } {
        return [$ent getName]
    }
    return ""
}

proc dumpEnts { title ents } {
    puts ""
    puts "$title"
    while { 0 != [llength $ents] } {
        set ents [lassign $ents ent1 ent2 ent3 ent4 ent5 ent6 ent7 ent8 ent9 ent10]
        puts [format "%8s %8s %8s %8s %8s %8s %8s %8s" \
            [nm $ent1] [nm $ent2] [nm $ent3] [nm $ent4] [nm $ent5] \
            [nm $ent6] [nm $ent7] [nm $ent8] [nm $ent9] [nm $ent10]]
    }
}

set dim [pwio::getCaeDim]
puts "CAE Dimension : $dim"

set selType [pwio::getSelectType]
puts "Selection Type: $selType"

if { ![pwio::utils::getSelection $selType selectedEnts errMsg] } {
    puts $errMsg
} elseif { ![pwio::utils::getSupportEnts $selectedEnts selAndSupEnts true] } {
    puts "pwio::utils::getSupportEnts failed"
} else {
    dumpEnts "UNSORTED:" $selAndSupEnts
    dumpEnts "SORTED:" [pwio::utils::sortEntsByType $selAndSupEnts]
    puts ""
    pwio::utils::printEntInfo "TEST" $selAndSupEnts $dim $selectedEnts
}
```

*Output:*

    CAE Dimension : 3
    Selection Type: Block

    UNSORTED:
       blk-4    blk-5   con-44   con-45   dom-11   dom-28   dom-22   dom-24
      dom-20   con-40   dom-21   con-26   con-49   con-27   con-47   con-28
     Node_24  Node_25  Node_26  Node_27   con-19    dom-1  Node_28   dom-29
      con-41   dom-23  Node_31   dom-27   dom-25  Node_32  Node_33  Node_34
     Node_36   con-42   con-43   con-50   con-51    con-1   con-57   con-54
      con-53

    SORTED:
       blk-4    blk-5   dom-11   dom-28   dom-22   dom-24   dom-26   dom-20
      dom-29   dom-23   dom-27   dom-25   con-44   con-45   con-46   con-40
      con-27   con-47   con-28   con-52   con-19   con-41   con-55   con-42
      con-51    con-1   con-57   con-54   con-48   con-56   con-53  Node_23
     Node_26  Node_27  Node_28  Node_29  Node_30  Node_31  Node_32  Node_33
     Node_36

    TEST
    | Entity                         | Name                 |  NumPts |  DbPts | Dim       | BaseType   | BorC  |
    | ------------------------------ | -------------------- | ------- | ------ | --------- | ---------- | ----- |
    | ::pw::BlockStructured_1        | blk-4                |      36 |        | 3 4 3     | Block      |       |
    | ::pw::BlockStructured_2        | blk-5                |      36 |        | 3 4 3     | Block      |       |
    | ::pw::DomainStructured_25      | dom-11               |      12 |      3 | 3 4       | Domain     | Bndry |
    | ::pw::DomainStructured_26      | dom-28               |      12 |      1 | 4 3       | Domain     | Bndry |
    | ::pw::DomainStructured_27      | dom-22               |       9 |        | 3 3       | Domain     | Bndry |
    | ::pw::DomainStructured_28      | dom-24               |      12 |      1 | 4 3       | Domain     | Bndry |
    | ::pw::DomainStructured_29      | dom-26               |       9 |      3 | 3 3       | Domain     | Bndry |
    | ::pw::DomainStructured_30      | dom-20               |       6 |        | 3 2       | Domain     | Bndry |
    | ::pw::DomainStructured_31      | dom-21               |       9 |        | 3 3       | Domain     | Bndry |
    | ::pw::DomainStructured_47      | dom-1                |      12 |        | 3 4       | Domain     | Cnxn  |
    | ::pw::DomainStructured_48      | dom-29               |      12 |        | 4 3       | Domain     | Bndry |

                                                ...SNIP...

    | ::pw::Connector_176            | con-41               |       3 |        | 3         | Connector  |       |
    | ::pw::Connector_181            | con-55               |       3 |      1 | 3         | Connector  |       |
    | ::pw::Connector_186            | con-42               |       3 |        | 3         | Connector  |       |
    | ::pw::Connector_190            | con-43               |       2 |        | 2         | Connector  |       |
    | ::pw::Connector_200            | con-50               |       3 |        | 3         | Connector  |       |

                                                ...SNIP...

    | ::pw::Node_26                  | Node_26              |       1 |        | 1         | Node       |       |
    | ::pw::Node_27                  | Node_27              |       1 |        | 1         | Node       |       |
    | ::pw::Node_28                  | Node_28              |       1 |        | 1         | Node       |       |
    | ::pw::Node_29                  | Node_29              |       1 |        | 1         | Node       |       |
    | ::pw::Node_30                  | Node_30              |       1 |        | 1         | Node       |       |
    | ::pw::Node_31                  | Node_31              |       1 |        | 1         | Node       |       |
    | ::pw::Node_32                  | Node_32              |       1 |        | 1         | Node       |       |
    | ::pw::Node_33                  | Node_33              |       1 |        | 1         | Node       |       |
    | ::pw::Node_34                  | Node_34              |       1 |        | 1         | Node       |       |
    | ::pw::Node_35                  | Node_35              |       1 |      1 | 1         | Node       |       |
    | ::pw::Node_36                  | Node_36              |       1 |      1 | 1         | Node       |       |


### Example 2

```Tcl
package require PWI_Glyph 2.17.0
source [file join [file dirname [info script]] ".." "pwio.glf"]

if { ![pwio::utils::getSelection Block blks errMsg] } {
    puts $errMsg
    continue
}
foreach blk $blks {
    set perimPtCnt [pwio::utils::getPerimeterPointCount $blk]
    set ownedPtCnt [pwio::utils::getOwnedPointCount $blk]
    puts "--------------------------------------------------------------------"
    puts "BLOCK [$blk getName] ($blk) | perim $perimPtCnt | owned $ownedPtCnt"
    puts "BLOCK DOMAINS"
    set doms [pwio::utils::getBlockDomains $blk]
    foreach dom $doms {
        if { [pwio::utils::isBndryEnt $dom $blks] } {
            set domUsage "Boundary"
        } else {
            set domUsage "Connection"
        }
        set perimPtCnt [pwio::utils::getPerimeterPointCount $dom]
        set ownedPtCnt [pwio::utils::getOwnedPointCount $dom]
        puts "    [$dom getName]($dom) | perim $perimPtCnt | owned $ownedPtCnt | usage $domUsage"
    }

    puts "BLOCK FACES"
    set faces [pwio::utils::getBlockFaces $blk]
    foreach face $faces {
        set perimPtCnt [pwio::utils::getPerimeterPointCount $face]
        set ownedPtCnt [pwio::utils::getOwnedPointCount $face]
        puts "  FACE $face | perim $perimPtCnt | owned $ownedPtCnt"
        puts "    FACE DOMAINS"
        set doms [pwio::utils::getFaceDomains $face]
        foreach dom $doms {
            puts "      DOM [$dom getName] ($dom)"
        }
        puts "    FACE EDGES"
        set edges [pwio::utils::getFaceEdges $face]
        foreach edge $edges {
            puts "      EDGE $edge"
            puts "        EDGE CONNECTORS"
            set cons [pwio::utils::getEdgeConnectors $edge]
            foreach con $cons {
                set perimPtCnt [pwio::utils::getPerimeterPointCount $con]
                set ownedPtCnt [pwio::utils::getOwnedPointCount $con]
                puts "          CON [$con getName] ($con) | perim $perimPtCnt | owned $ownedPtCnt"
            }
        }
    }
}
```

*Output:*

    --------------------------------------------------------------------
    BLOCK blk-5 (::pw::BlockStructured_2) | perim 34 | owned 2
    BLOCK DOMAINS
        dom-1(::pw::DomainStructured_47) | perim 10 | owned 2 | usage Connection
        dom-29(::pw::DomainStructured_48) | perim 10 | owned 2 | usage Boundary
        dom-23(::pw::DomainStructured_49) | perim 8 | owned 1 | usage Boundary
        dom-25(::pw::DomainStructured_51) | perim 10 | owned 2 | usage Boundary
        dom-27(::pw::DomainStructured_50) | perim 8 | owned 1 | usage Boundary
        dom-20(::pw::DomainStructured_30) | perim 6 | owned 0 | usage Boundary
        dom-21(::pw::DomainStructured_31) | perim 8 | owned 1 | usage Boundary
    BLOCK FACES
      FACE ::pw::FaceStructured_17 | perim 10 | owned 0
        FACE DOMAINS
          DOM dom-1 (::pw::DomainStructured_47)
        FACE EDGES
          EDGE ::pw::Edge_98
            EDGE CONNECTORS
              CON con-1 (::pw::Connector_194) | perim 2 | owned 1
          EDGE ::pw::Edge_99
            EDGE CONNECTORS
              CON con-51 (::pw::Connector_193) | perim 2 | owned 2
          EDGE ::pw::Edge_100
            EDGE CONNECTORS
              CON con-54 (::pw::Connector_196) | perim 2 | owned 1
          EDGE ::pw::Edge_101
            EDGE CONNECTORS
              CON con-57 (::pw::Connector_195) | perim 2 | owned 2

                            ...SNIP...

      FACE ::pw::FaceStructured_22 | perim 10 | owned 0
        FACE DOMAINS
          DOM dom-20 (::pw::DomainStructured_30)
          DOM dom-21 (::pw::DomainStructured_31)
        FACE EDGES
          EDGE ::pw::Edge_118
            EDGE CONNECTORS
              CON con-40 (::pw::Connector_158) | perim 2 | owned 1
          EDGE ::pw::Edge_119
            EDGE CONNECTORS
              CON con-45 (::pw::Connector_152) | perim 2 | owned 0
              CON con-46 (::pw::Connector_157) | perim 2 | owned 1
          EDGE ::pw::Edge_120
            EDGE CONNECTORS
              CON con-41 (::pw::Connector_176) | perim 2 | owned 1
          EDGE ::pw::Edge_121
            EDGE CONNECTORS
              CON con-44 (::pw::Connector_148) | perim 2 | owned 1
              CON con-43 (::pw::Connector_190) | perim 2 | owned 0
    --------------------------------------------------------------------
    BLOCK blk-4 (::pw::BlockStructured_1) | perim 34 | owned 2
    BLOCK DOMAINS
        dom-11(::pw::DomainStructured_25) | perim 10 | owned 2 | usage Boundary
        dom-28(::pw::DomainStructured_26) | perim 10 | owned 2 | usage Boundary
        dom-22(::pw::DomainStructured_27) | perim 8 | owned 1 | usage Boundary
        dom-24(::pw::DomainStructured_28) | perim 10 | owned 2 | usage Boundary
        dom-26(::pw::DomainStructured_29) | perim 8 | owned 1 | usage Boundary
        dom-1(::pw::DomainStructured_47) | perim 10 | owned 2 | usage Connection
    BLOCK FACES
      FACE ::pw::FaceStructured_23 | perim 10 | owned 0
        FACE DOMAINS
          DOM dom-11 (::pw::DomainStructured_25)
        FACE EDGES
          EDGE ::pw::Edge_122
            EDGE CONNECTORS
              CON con-19 (::pw::Connector_174) | perim 2 | owned 1
          EDGE ::pw::Edge_123
            EDGE CONNECTORS
              CON con-26 (::pw::Connector_159) | perim 2 | owned 2
          EDGE ::pw::Edge_124
            EDGE CONNECTORS
              CON con-27 (::pw::Connector_163) | perim 2 | owned 1
          EDGE ::pw::Edge_125
            EDGE CONNECTORS
              CON con-28 (::pw::Connector_168) | perim 2 | owned 2

                            ...SNIP...

      FACE ::pw::FaceStructured_28 | perim 10 | owned 0
        FACE DOMAINS
          DOM dom-1 (::pw::DomainStructured_47)
        FACE EDGES
          EDGE ::pw::Edge_142
            EDGE CONNECTORS
              CON con-1 (::pw::Connector_194) | perim 2 | owned 1
          EDGE ::pw::Edge_143
            EDGE CONNECTORS
              CON con-51 (::pw::Connector_193) | perim 2 | owned 2
          EDGE ::pw::Edge_144
            EDGE CONNECTORS
              CON con-54 (::pw::Connector_196) | perim 2 | owned 1
          EDGE ::pw::Edge_145
            EDGE CONNECTORS
              CON con-57 (::pw::Connector_195) | perim 2 | owned 2


### Disclaimer
Scripts are freely provided. They are not supported products of
Pointwise, Inc. Some scripts have been written and contributed by third
parties outside of Pointwise's control.

TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE LAW, POINTWISE DISCLAIMS
ALL WARRANTIES, EITHER EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED
TO, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE, WITH REGARD TO THESE SCRIPTS. TO THE MAXIMUM EXTENT PERMITTED
BY APPLICABLE LAW, IN NO EVENT SHALL POINTWISE BE LIABLE TO ANY PARTY
FOR ANY SPECIAL, INCIDENTAL, INDIRECT, OR CONSEQUENTIAL DAMAGES
WHATSOEVER (INCLUDING, WITHOUT LIMITATION, DAMAGES FOR LOSS OF BUSINESS
INFORMATION, OR ANY OTHER PECUNIARY LOSS) ARISING OUT OF THE USE OF OR
INABILITY TO USE THESE SCRIPTS EVEN IF POINTWISE HAS BEEN ADVISED OF THE
POSSIBILITY OF SUCH DAMAGES AND REGARDLESS OF THE FAULT OR NEGLIGENCE OF
POINTWISE.

[coord]: http://www.pointwise.com/glyph2/files/Glyph/cxx/GgGlyph-cxx.html#coord "What is a grid coord?"

[point]: http://www.pointwise.com/glyph2/files/Glyph/cxx/GgGlyph-cxx.html#point "What is a grid point?"

[pwVolumeCondition]: http://www.pointwise.com/glyph2/files/Glyph/cxx/GlyphVolumeCondition-cxx.html "What is a volume condition?"

[pwBoundaryCondition]: http://www.pointwise.com/glyph2/files/Glyph/cxx/GlyphBoundaryCondition-cxx.html "What is a boundary condition?"

[pwNote]: http://www.pointwise.com/glyph2/files/Glyph/cxx/GlyphNote-cxx.html "What is a pw::Note?"

[pwBlock]: http://www.pointwise.com/glyph2/files/Glyph/cxx/GlyphBlock-cxx.html "What is a pw::Block?"

[pwDomain]: http://www.pointwise.com/glyph2/files/Glyph/cxx/GlyphDomain-cxx.html "What is a pw::Domain?"

[pwConnector]: http://www.pointwise.com/glyph2/files/Glyph/cxx/GlyphConnector-cxx.html "What is a pw::Connector?"

[pwNode]: http://www.pointwise.com/glyph2/files/Glyph/cxx/GlyphNode-cxx.html "What is a pw::Node?"

[pwEdge]: http://www.pointwise.com/glyph2/files/Glyph/cxx/GlyphEdge-cxx.html "What is a pw::Edge?"

[pwFace]: http://www.pointwise.com/glyph2/files/Glyph/cxx/GlyphFace-cxx.html "What is a pw::Face?"
