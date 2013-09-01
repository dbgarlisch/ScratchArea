| [README.md](README.md) | [pwio-cell.md](pwio-cell.md) |

# glyph-pwio::utils

A collection of utility procs.


##Table Of Contents

* [Namespace pwio::utils](#namespace-pwioutils)
* [Library Reference pwio::utils](#library-reference-pwioutils)
* [Disclaimer](#disclaimer)


## Namespace pwio::utils

All of the procs in this collection reside in the `pwio::utils` namespace.

To call a proc in this collection, you must prefix the proc name with a `pwio::utils::` namespace specifier.

For example:
```Tcl
pwio::utils::entBaseType $ent
```


## Library Reference pwio::utils

```Tcl
pwio::utils::assert { cond msg {exitVal -1} }
```
Asserts that `cond` is true. If false, `msg` is displayed and the script is terminated returning `exitVal`.
<dl>
  <dt><code>cond</code></dt>
  <dd>The condition to test.</dd>
  <dt><code>msg</code></dt>
  <dd>The message to display if <code>cond</code> evaluates to false.</dd>
  <dt><code>exitVal</code></dt>
  <dd>The fail exit value. If 0, the script will **not** exit and execution will continue.</dd>
</dl>

**Usage:**
```Tcl
set ndx 5
set ent [pw::Grid getByName "blk-1"]
assert "$ndx >= 1 && $ndx < [$ent getPointCount]" "Bad Index $ndx for '[$ent getName]'"

# The output if assert fails:
# assert failed: ($ndx >= 1 && $ndx < 3)
# message      : Bad Index 5 for 'blk-1'
```

<br/>
```Tcl
pwio::utils::entBaseType { ent {subTypeVarName ""} }
```
Returns `ent`'s base grid entity type. One of `Node`, `Connector`, `Domain`, or `Block`.
<dl>
  <dt><code>ent</code></dt>
  <dd>A grid entity.</dd>
  <dt><code>subTypeVarName</code></dt>
  <dd>If provided, <code>ent</code>'s subtype is stored in this variable.</dd>
</dl>

For blocks, the subtype will be one of `Structured`, `Unstructured` or `Extruded`.
For domains, the subtype will be one of `Structured` or `Unstructured`.
For connectors, the subtype is set to Connector.
For nodes, the subtype is set to Node.


<br/>
```Tcl
pwio::utils::getBlockFaces { blk }
```
Returns `blk`'s faces as a list of `pw::FaceUnstructured` and/or `pw::FaceStructured` entities.
<dl>
  <dt><code>blk</code></dt>
  <dd>A block entity.</dd>
</dl>


<br/>
```Tcl
pwio::utils::getBlockDomains { blk }
```
Returns `blk`'s domains as a list of `pw::DomainUnstructured` and/or `pw::DomainStructured` entities. It is possible for a domain to appear in the list more than once.
<dl>
  <dt><code>blk</code></dt>
  <dd>A block entity.</dd>
</dl>


<br/>
```Tcl
pwio::utils::getFaceDomains { face }
```
Returns `face`'s domains as a list of `pw::DomainUnstructured` and/or `pw::DomainStructured` entities. It is possible for a domain to appear in the list more than once.
<dl>
  <dt><code>face</code></dt>
  <dd>A face entity.</dd>
</dl>


<br/>
```Tcl
pwio::utils::getFaceEdges { face }
```
Returns `face`'s edges as a list of `pw::Edge` entities. The first edge is `face`'s outer loop. Any additional edges are inner loops (holes).
<dl>
  <dt><code>face</code></dt>
  <dd>A face entity.</dd>
</dl>


<br/>
```Tcl
pwio::utils::getEdgeConnectors { edge }
```
Returns `edge`'s connectors as a list of `pw::Connector` entities. It is possible for a connector to appear in the list more than once.
<dl>
  <dt><code>edge</code></dt>
  <dd>An edge entity.</dd>
</dl>


<br/>
```Tcl
pwio::utils::getFaceEdgeConnectors { face }
```
Returns `face`'s connectors as a list of `pw::Connector` entities. It is possible for a connector to appear in the list more than once.
<dl>
  <dt><code>face</code></dt>
  <dd>A face entity.</dd>
</dl>


<br/>
```Tcl
pwio::utils::getPerimeterPointCount { ent }
```
Returns the number of grid points on `ent`'s outer perimeter. This count includes any holes or voids. Nodes will always return 0. Connectors will always return 2.
<dl>
  <dt><code>ent</code></dt>
  <dd>A Node, Connector, Domain, Face or Block entity.</dd>
</dl>


<br/>
```Tcl
pwio::utils::getOwnedPointCount { ent }
```
Returns the number of grid points on `ent`'s interior (non-perimeter points). Nodes will always return 1.
<dl>
  <dt><code>ent</code></dt>
  <dd>A Node, Connector, Domain, Face or Block entity.</dd>
</dl>

<br/>
```Tcl
pwio::utils::isBndryEnt { ent allEnts }
```
Returns true if `ent` lies on the boundary of `allEnts`.
<dl>
  <dt><code>ent</code></dt>
  <dd>A Connector or Domain entity.</dd>
</dl>

An error will occur if this is called for anything other than a `pw::Connector` object in 2D mode and anything other than a `pw::Domain` object in 3D mode.


<br/>
```Tcl
pwio::utils::getNodeDbEnt { node dbEntVarName }
```
Returns true if `node` is DB constrained.
<dl>
  <dt><code>node</code></dt>
  <dd>A `pw::Node` entity.</dd>
  <dt><code>dbEntVarName</code></dt>
  <dd>Required. If constrained, the DB entity is stored in this variable.</dd>
</dl>


<br/>
```Tcl
pwio::utils::entLockInterior { ent }
```
Locks `ent`'s grid points.
<dl>
  <dt><code>ent</code></dt>
  <dd>A grid entity.</dd>
</dl>

A corresponding call to `pwio::utils::entUnlockInterior` must be made when finished.


<br/>
```Tcl
pwio::utils::entUnlockInterior { ent {clearAllLocks 0} }
```
Proc description.
<dl>
  <dt><code>ent</code></dt>
  <dd>A grid entity previously locked with a call to `pwio::utils::entLockInterior`.</dd>
  <dt><code>clearAllLocks</code></dt>
  <dd>If 1, all active locks on <code>ent</code> will be released.</dd>
</dl>

Typically, `clearAllLocks` should be 0. You should explicitly lock and unlock entities. A logic error has occurred if an entity remains locked at script termination.


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

This proc does **not** check if `ijk` lies within the given `ijkdim` extents.
If `ijk` is invalid, the returned index is invalid.
The reverse mapping is done with `pwio::utils::indexToIjkStructured`.


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

The reverse mapping is done with `pwio::utils::ijkToIndexStructured`.


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

The reverse mapping is done with `pwio::utils::entIndexToIjk`.


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

The reverse mapping is done with `pwio::utils::entIjkToIndex`.


<br/>
```Tcl
pwio::utils::makeCoord { ent ijk }
```
Returns a [grid coord][gridCoord] for the given `ent` and `ijk`.
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
Returns a [grid coord][gridCoord] for the given `ent` and `i`, `j` and `k` indices.
<dl>
  <dt><code>ent</code></dt>
  <dd>A grid entity.</dd>
  <dt><code>i</code> <code>j</code> <code>k</code></dt>
  <dd>The individual i, j and k indices.</dd>
</dl>


<br/>
```Tcl
pwio::utils::makeCoordFromEntIndex { ent ndx }
```
Returns a [grid coord][gridCoord] for the given `ent` and linear index.
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

The list will be in Block, Domain, Connector, Node order.


<br/>
```Tcl
pwio::utils::pointToString { pt }
```
Returns a string representation of `pt`.
<dl>
  <dt><code>pt</code></dt>
  <dd>A point as an {x y z} or {u v dbent} list.</dd>
</dl>

The resulting string will be one of "{u v dbEnt}" or "{x y z}".


<br/>
```Tcl
pwio::utils::xyzEqual { xyz1 xyz2 {tol 1.0e-8} }
```
Returns true if two xyz points are equal within the given tolerance.
<dl>
  <dt><code>xyz1</code></dt>
  <dd>First point as an {x y z} list.</dd>
  <dt><code>xyz2</code></dt>
  <dd>Second point as an {x y z} list.</dd>
  <dt><code>tol</code></dt>
  <dd>The optional comparison tolerance.</dd>
</dl>


<br/>
```Tcl
pwio::utils::valEqual { val1 val2 {tol 1.0e-8} }
```
Returns true if two values are equal within the given tolerance.
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
Returns a string representation of a [grid coord][gridCoord].
<dl>
  <dt><code>coord</code></dt>
  <dd>The [grid coord][gridCoord].</dd>
</dl>


<br/>
```Tcl
pwio::utils::vcToString { vc }
```
Returns a string representation of a [volume condition][volCond].
<dl>
  <dt><code>vc</code></dt>
  <dd>The [volume condition][volCond].</dd>
</dl>

The resulting string format will be "vcName vcId vcPhysicalType"


<br/>
```Tcl
pwio::utils::labelPt { ndx pt }
```
Returns a [`pw::Note`][pwNote] entity positioned at `pt`.
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
Dumps a table of entity information.
<dl>
  <dt><code>arg</code></dt>
  <dd>arg description.</dd>
</dl>


<br/>
```Tcl
pwio::utils::getSelection { selType selectedVarName errMsgVarName }
```
Proc description.
<dl>
  <dt><code>arg</code></dt>
  <dd>arg description.</dd>
</dl>


<br/>
```Tcl
pwio::utils::getSupportEnts { ents supEntsVarName {addEnts false}}
```
Proc description.
<dl>
  <dt><code>arg</code></dt>
  <dd>arg description.</dd>
</dl>



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

[gridCoord]: http://www.pointwise.com/glyph2/files/Glyph/cxx/GgGlyph-cxx.html#coord "What is a grid coord?"

[volCond]: http://www.pointwise.com/glyph2/files/Glyph/cxx/GlyphVolumeCondition-cxx.html "What is a volume condition?"

[bndryCond]: http://www.pointwise.com/glyph2/files/Glyph/cxx/GlyphBoundaryCondition-cxx.html "What is a boundary condition?"

[pwNote]: http://www.pointwise.com/glyph2/files/Glyph/cxx/GlyphNote-cxx.html "What is a pw::Note?"