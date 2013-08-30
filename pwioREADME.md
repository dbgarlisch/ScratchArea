# glyph-pwio
A Glyph library that helps with the exporting of 2D or 3D unstructured grids.

Exporting unstructured grids requires the serial enumeration (1 to N) of all unique grid points. However, Pointwise `pw::Block` objects share grid points with the `pw::Domain` objects on their boundary. Likewise, `pw::Domain` objects share points with the `pw::Connector` objects on their boundary. Finally, `pw::Connector` objects share their end points with two `pw::Node` objects. Because of this sharing, additional data management is needed to properly enumerate the grid points. The `pwio` library provides the required data management.

### Limitations
* Support for 2D boundaries needs work (see comments in the [Access Cell Connectivity (Entity By Entity)](#AccessCellConnectivityEntityByEntity) section).


<hr/>


#Table Of Contents

* [Namespace pwio](#namespace-pwio)
    * [Library Reference pwio](#library-reference-pwio)
    * [The Export Sequence](#the-export-sequence)
    * [Example Usage](#example-usage)
        * [Access Grid Points](#access-grid-points)
        * [Access Cell Connectivity](#access-cell-connectivity)
            * [Entity By Entity Access](#entity-by-entity-access)
            * [Global Access](#global-access)
* [Namespace pwio::utils](#namespace-pwioutils)
    * [Library Reference pwio::utils](#library-reference-pwioutils)
* [Namespace pwio::cell](#namespace-pwiocell)
    * [Library Reference pwio::cell](#library-reference-pwiocell)
* [Disclaimer](#disclaimer)


<hr/>


# Namespace pwio

All of the procs in this collection reside in the `pwio` namespace.

To call a proc in this collection, you must prefix the proc name with a `pwio::` namespace specifier.

For example:
```Tcl
pwio::beginIO $ents
```


## Library Reference pwio

```Tcl
pwio::beginIO { ents }
```
Prepare a list of grid entities for export. Must be called once at the beginning of an export.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>ents</code></dt>
  <dd>The entities to export (entity list). For 2D, ents should contain <code>pw::Domain</code> entities. For 3D, ents should contain <code>pw::Block</code> entities.</dd>
</dl>

<br/>
```Tcl
pwio::endIO { {clearAllLocks 0} }
```
Cleans up after an export. Must be called once at the end of an export.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>clearAllLocks</code></dt>
  <dd>If 1, all locks will be released even if pwio did not make them.</dd>
</dl>

<br/>
```Tcl
pwio::getCoordCount {}
```
Returns the number of unique grid points in this export.

<br/>
```Tcl
pwio::getCoord { enumNdx }
```
Get an export grid coord.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>enumNdx</code></dt>
  <dd>The grid coord index from 1 to getCoordCount.</dd>
</dl>

<br/>
```Tcl
pwio::getCoordIndex { coord {mapCoordToOwner 1} }
```
Returns the index corresponding to an export grid coord.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>coord</code></dt>
  <dd>The grid coord.</dd>
  <dt><code>mapCoordToOwner</code></dt>
  <dd>If 1, coord is be mapped to its owning entity before mapping.</dd>
</dl>

If you know that the coord's entity is already the owner, this call is faster if you set this argument to 0.

<br/>
```Tcl
pwio::getCellCount {}
```
Returns the number of unique, top-level <code>pw::Domain</code> (2D) or a <code>pw::Block</code> (3D) volume cells grid cells in this export.

<br/>
```Tcl
pwio::getCell { enumNdx {vcVarName ""} }
```
Returns an export grid cell as a list of global pwio indices.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>enumNdx</code></dt>
  <dd>The grid cell index from 1 to getCellCount.</dd>
  <dt><code>vcVarName</code></dt>
  <dd>If provided, the cell's <code>pw::VolumeCondition</code> is stored in this variable.</dd>
</dl>

<br/>
```Tcl
pwio::getCellIndex { ent entNdx }
```
Returns the global, export cell index corresponding to an entity's local cell index.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>ent</code></dt>
  <dd>The grid entity.</dd>
  <dt><code>entNdx</code></dt>
  <dd>The cell index in <code>ent</code>'s local index space.</dd>
</dl>

<br/>
```Tcl
pwio::getCellEdges { enumNdx {cellVarName ""} {minFirstOrder 0} {revVarName ""} }
```
Returns an export cell's edges as a list of global pwio indices.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>enumNdx</code></dt>
  <dd>The grid cell index from 1 to getCellCount.</dd>
  <dt><code>cellVarName</code></dt>
  <dd>If provided, this var receives the cell's indices.
      See <code>pwio::getCell</code>.</dd>
  <dt><code>minFirstOrder</code></dt>
  <dd>If 1, edge indices are rearranged with the minimum index first.</dd>
  <dt><code>revVarName</code></dt>
  <dd>If provided, this var receives a list of flags. A flag is set to 1 if the
	  edge was min first reversed.</dd>
</dl>

<br/>
```Tcl
pwio::getMinFirstCellEdges { enumNdx {cellVarName ""} {revVarName ""} }
```
Returns an export cell's edges as a list of global pwio indices in min first order.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>enumNdx</code></dt>
  <dd>The grid cell index from 1 to getCellCount.</dd>
  <dt><code>cellVarName</code></dt>
  <dd>If provided, this var receives the cell's indices.
	  See <code>pwio::getCell</code>.</dd>
  <dt><code>revVarName</code></dt>
  <dd>If provided, this var receives a list of flags. A flag is set to 1 if the
      edge was min first reversed.</dd>
</dl>

<br/>
```Tcl
pwio::getFaceEdges { face {cellVarName ""} {minFirstOrder 0} {revVarName ""} }
```
Returns a list of face's edges. Each edge is a list of global pwio indices (a list of lists).
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>face</code></dt>
  <dd>A face as a list of global pwio indices.
      See <code>pwio::getCellFaces</code>.</dd>
  <dt><code>cellVarName</code></dt>
  <dd>If provided, this var receives a copy of face.</dd>
  <dt><code>minFirstOrder</code></dt>
  <dd>If 1, edge indices are rearranged with the minimum index first.</dd>
  <dt><code>revVarName</code></dt>
  <dd>If provided, this var receives a list of flags. A flag is set to 1 if the
      edge was min first reversed.</dd>
</dl>

<br/>
```Tcl
pwio::getMinFirstFaceEdges { face {cellVarName ""} {revVarName ""} }
```
Returns face's edges as a list of global pwio indices in min first order.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>face</code></dt>
  <dd>A face as a list of global pwio indices.
      See <code>pwio::getCellFaces</code>.</dd>
  <dt><code>cellVarName</code></dt>
  <dd>If provided, this var receives a copy of face.</dd>
  <dt><code>revVarName</code></dt>
  <dd>If provided, this var receives a list of flags. A flag is set to 1 if the
      edge was min first reversed.</dd>
</dl>

<br/>
```Tcl
pwio::getCellFaces { enumNdx {cellVarName ""} {minFirstOrder 0} }
```
Returns a list of a grid cell's faces. Each face is a list of global pwio indices (a list of lists).
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>enumNdx</code></dt>
  <dd>The grid cell index from 1 to getCellCount.</dd>
  <dt><code>cellVarName</code></dt>
  <dd>If provided, this var receives the cell's unmodified indices.
      See <code>pwio::getCell</code>.</dd>
  <dt><code>minFirstOrder</code></dt>
  <dd>If 1, the face indices are *rotated* such that the minimum index is
      first. The relative ordering of the vertices is not changed (the face
      normal is *not* flipped).</dd>
</dl>

<br/>
```Tcl
pwio::getMinFirstCellFaces { enumNdx {cellVarName ""} }
```
Returns a list of a grid cell's faces in min first order. Each face is a list of global pwio indices (a list of lists).
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>enumNdx</code></dt>
  <dd>The grid cell index from 1 to getCellCount.</dd>
  <dt><code>cellVarName</code></dt>
  <dd>If provided, this var receives the cell's unmodified indices.
      See <code>pwio::getCell</code>.</dd>
</dl>

<br/>
```Tcl
pwio::getCellType { enumNdx }
```
Returns the grid cell's type. One of 2D(*tri* or *quad*) or 3D(*tet*, *pyramid*, *prism*, or *hex*).
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>enumNdx</code></dt>
  <dd>The grid cell index from 1 to getCellCount.</dd>
</dl>

<br/>
```Tcl
pwio::getFaceType { face }
```
Returns the face type. One of 2D(*bar*) or 3D(*tri* or *quad*).
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>face</code></dt>
  <dd>A face as a list of global pwio indices.
      See <code>pwio::getCellFaces</code>.</dd>
</dl>

<br/>
```Tcl
pwio::getEntityCell { ent ndx {localCellVarName ""} }
```
Returns an entity cell as a list of global pwio indices. These indices are only valid for calls to <code>pwio::getCoord</code>.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>ent</code></dt>
  <dd>The grid entity.</dd>
  <dt><code>ndx</code></dt>
  <dd>The cell index in <code>ent</code>'s local index space.</dd>
  <dt><code>localCellVarName</code></dt>
  <dd>If provided, this var receives the cell's local indices.</dd>
</dl>

<br/>
```Tcl
pwio::getEntityCellEdges { ent ndx {cellVarName ""} {minFirstOrder 0} {revVarName ""} }
```
Returns an entity cell's edges as a list of global pwio indices. These indices are only valid for calls to <code>pwio::getCoord</code>.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>ent</code></dt>
  <dd>The grid entity.</dd>
  <dt><code>ndx</code></dt>
  <dd>The cell index in <code>ent</code>'s local index space.</dd>
  <dt><code>cellVarName</code></dt>
  <dd>If provided, this var receives the cell's indices.
      See <code>pwio::getCell</code>.</dd>
  <dt><code>minFirstOrder</code></dt>
  <dd>If 1, edge indices are rearranged with the minimum index first.</dd>
  <dt><code>revVarName</code></dt>
  <dd>If provided, this var receives a list of flags. A flag is set to 1 if the
      edge was min first reversed.</dd>
</dl>

<br/>
```Tcl
pwio::getMinFirstEntityCellEdges { ent ndx {cellVarName ""} {revVarName ""} }
```
Returns an entity cell's edges as a list of global pwio indices in min first order. These indices are only valid for calls to <code>pwio::getCoord</code>.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>ent</code></dt>
  <dd>The grid entity.</dd>
  <dt><code>ndx</code></dt>
  <dd>The cell index in <code>ent</code>'s local index space.</dd>
  <dt><code>cellVarName</code></dt>
  <dd>If provided, this var receives the cell's indices.
      See <code>pwio::getCell</code>.</dd>
  <dt><code>revVarName</code></dt>
  <dd>If provided, this var receives a list of flags. A flag is set to 1 if the
      edge was min first reversed.</dd>
</dl>

<br/>
```Tcl
pwio::getCaeDim {}
```
Returns 2 if the grid dimensionality is 2D or 3 if 3D.

<br/>
```Tcl
pwio::getSelectType {}
```
Returns `pw::Domain`'s if the grid dimensionality is 2D or `pw::Block`'s if 3D. See `pwio::utils::getSelection`.

<br/>
```Tcl
pwio::fixCoord { coordVarName }
```
Returns the grid coord corrected to use proper indexing form.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>coordVarName</code></dt>
  <dd>The grid coord to be modifed if needed. Required.</dd>
</dl>

<br/>
```Tcl
pwio::coordMapLower { coord }
```
Returns the grid coord mapped to its next lower level entity.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>coord</code></dt>
  <dd>The grid coord to be mapped.</dd>
</dl>

<br/>
```Tcl
pwio::mapToOwner { coord {trace 0} }
```
Returns the grid coord mapped to its owning entity.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>coord</code></dt>
  <dd>The grid coord to be mapped.</dd>
  <dt><code>trace</code></dt>
  <dd>For debugging only. If 1, the mapping sequence is dumped to stdout.</dd>
</dl>

<br/>
```Tcl
pwio::coordGetEntity { coord }
```
Returns the entity of the grid coord.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>coord</code></dt>
  <dd>The grid coord.</dd>
</dl>

<br/>
```Tcl
pwio::coordGetIjk { coord }
```
Returns the ijk index of the grid coord.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>coord</code></dt>
  <dd>The grid coord.</dd>
</dl>

### pwio::Level
Enumerated entity level values accessed as:

* `pwio::Level::Block`
* `pwio::Level::Domain`
* `pwio::Level::Connector`
* `pwio::Level::Node`

See also `coordMapToLevel`, and `entGetLevel`.

<br/>
```Tcl
pwio::entGetLevel { entOrBaseType }
```
Returns an entity level value.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>entOrBaseType</code></dt>
  <dd>A grid entity or one of `Block`, `Domain`, `Connector`, or `Node`.</dd>
</dl>

<br/>
```Tcl
pwio::coordGetLevel { coord }
```
Returns an entity level value for the entity in coord.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>coord</code></dt>
  <dd>The grid coord.</dd>
</dl>

<br/>
```Tcl
pwio::coordMapToEntity { fromCoord toEnt coordsVarName }
```
Returns non-zero if fromCoord can be mapped to a grid coord in toEnt.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>fromCoord</code></dt>
  <dd>The starting grid coord.</dd>
  <dt><code>toEnt</code></dt>
  <dd>The target grid entity.</dd>
  <dt><code>coordsVarName</code></dt>
  <dd>Receives the list of mapped grid coords. Required.</dd>
</dl>

<br/>
```Tcl
pwio::coordMapToLevel { coord toLevel coordsVarName }
```
Returns non-zero if coord can be mapped to a specific grid level.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>coord</code></dt>
  <dd>The starting grid coord.</dd>
  <dt><code>toLevel</code></dt>
  <dd>The target grid level.</dd>
  <dt><code>coordsVarName</code></dt>
  <dd>Receives the list of mapped grid coords. Required.</dd>
</dl>


## The Export Sequence

Exporting a grid using `pwio` requires the same basic sequence:

* Call `pwio::beginIO` with a list of entites to export.
  * A list of `pw::Domain` entites for a 2D export.
  * A list of `pw::Block` entites for a 3D export.
* Access the grid data using `pwio` and Glyph procs.
  * See the ![Example Usage](#ExampleUsage) section.
* Call `pwio::endIO` when finished.


## Example Usage
The following section show how to use `pwio` in conjuction with the standard Glyph calls.

While many formats have a lot in common, each export format will have differing needs. The usage examples given below will not be needed by every exporter.

### Access Grid Points

```Tcl
pwio::beginIO $gridEntsToExport

# Get the number of unique grid points in $gridEntsToExport.
set coordCnt [pwio::getCoordCount]
for {set ii 1} {$ii <= $coordCnt} {incr ii} {
  # Get the grid coord for grid point $ii.
  set coord [pwio::getCoord $ii]

  # Get the physical xyz location of coord. The returned xyz is always in the
  # form {x y z}
  set xyz [pw::Grid getXYZ $coord]

  # Get the location of coord. If coord is database constrained, pt will be in
  # the form {u v dbentity}. If *not* database constrained, pt will be in the
  # form {x y z}.
  set pt [pw::Grid getPoint $coord]

  # Get grid entity that owns this coord.
  set ownerEnt [pw::Grid getEntity $coord]
}

pwio::endIO
```

### Access Cell Connectivity

#### Entity By Entity Access

Accessing interior and boundary cell connectivity is done on an entity by entity
basis.

```Tcl
pwio::beginIO $gridEntsToExport

# Access the top-level pw::Domain (2D) or a pw::Block (3D) volume cells.
foreach ent $gridEntsToExport {
  # Get vc asigned to $ent
  set vc [$ent getVolumeCondition]
  # Get the number of cells in $ent.
  set cellCnt [$ent getCellCount]
  for {set ii 1} {$ii <= $cellCnt} {incr ii} {
    # Get $ent cell $ii as a list of global pwio indices. These indices are only
    # valid for calls to pwio::getCoord.
    set cell [pwio::getEntityCell $ent $ii]
  }
}

# Access the top-level pw::Domain (2D) or a pw::Block (3D) volume cells.
bcNames [pw::BoundaryCondition getNames]
foreach bcName $bcNames {
  set bc [pw::BoundaryCondition getByName $bcName]
  # Get the boundary grid entites using $bc. $bcEnts will contain pw::Connector
  # (2D) or a pw::Domain (3D) entities.
  set bcEnts [$bc getEntities]
  # See notes below about handling the boundary entities.
}

pwio::endIO
```

Properly handling the boundary entities is beyond the scope of this example.

Things to consider:

* Only items in `$bcEnts` that are used by `$gridEntsToExport` entities should
  be exported (connectors used by domains, domains used by blocks).
* When exporting 2D boundaries:
   * The `getCellCount` and `getCell` procs are **not** defined for `pw::Connector` entities.
   * The `pw::Connector` (linear) cells are defined as two consecutive local connector points *{0 1}, {1 2}*, etc.
   * The local cell indices must be mapped to global `pwio` indices using `pwio::getCoordIndex`.
* When exporting 3D boundaries:
   * The `getCellCount` and `getCell` procs **are** defined for `pw::Domain` entities.
   * The `pw::Domain` boundary cells can be enumerated in a manner similar to the volume cells example.


#### Global Access
Like grid points, some export formats require the serial enumeration (1 to N) of
all unique cells.

```Tcl
pwio::beginIO $gridEntsToExport

# Get the number of cells in $gridEntsToExport.
set cellCnt [pwio::getCellCount]
for {set ii 1} {$ii <= $cellCnt} {incr ii} {
  # Get grid cell $ii. cell is a list of grid coord indices.
  # These indices correspond to the coords returned by [pwio::getCoord $ii]
  set cell [pwio::getCell $ii vc]
}

pwio::endIO
```


<hr/>


# Namespace pwio::utils
A sub-collection of utility procs.

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
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>arg</code></dt>
  <dd>arg description.</dd>
</dl>

<br/>
```Tcl
pwio::utils::entBaseType { ent {subTypeVarName ""} }
```
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>arg</code></dt>
  <dd>arg description.</dd>
</dl>

<br/>
```Tcl
pwio::utils::getBlockFaces { blk }
```
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>arg</code></dt>
  <dd>arg description.</dd>
</dl>

<br/>
```Tcl
pwio::utils::getBlockDomains { blk }
```
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>arg</code></dt>
  <dd>arg description.</dd>
</dl>

<br/>
```Tcl
pwio::utils::getFaceDomains { face }
```
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>arg</code></dt>
  <dd>arg description.</dd>
</dl>

<br/>
```Tcl
pwio::utils::getFaceEdges { face }
```
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>arg</code></dt>
  <dd>arg description.</dd>
</dl>

<br/>
```Tcl
pwio::utils::getEdgeConnectors { edge }
```
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>arg</code></dt>
  <dd>arg description.</dd>
</dl>

<br/>
```Tcl
pwio::utils::getFaceEdgeConnectors { face }
```
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>arg</code></dt>
  <dd>arg description.</dd>
</dl>

<br/>
```Tcl
pwio::utils::getPerimeterPointCount { ent }
```
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>arg</code></dt>
  <dd>arg description.</dd>
</dl>

<br/>
```Tcl
pwio::utils::getOwnedPointCount { ent }
```
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>arg</code></dt>
  <dd>arg description.</dd>
</dl>

<br/>
```Tcl
pwio::utils::isBndryEnt { ent allEnts }
```
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>arg</code></dt>
  <dd>arg description.</dd>
</dl>

<br/>
```Tcl
pwio::utils::getNodeDbEnt { node dbEntVarName }
```
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>arg</code></dt>
  <dd>arg description.</dd>
</dl>

<br/>
```Tcl
pwio::utils::entLockInterior { ent }
```
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>arg</code></dt>
  <dd>arg description.</dd>
</dl>

<br/>
```Tcl
pwio::utils::entUnlockInterior { ent {clearAllLocks 0} }
```
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>arg</code></dt>
  <dd>arg description.</dd>
</dl>

<br/>
```Tcl
pwio::utils::entGetName { ent }
```
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>arg</code></dt>
  <dd>arg description.</dd>
</dl>

<br/>
```Tcl
pwio::utils::entGetDimensions { ent }
```
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>arg</code></dt>
  <dd>arg description.</dd>
</dl>

<br/>
```Tcl
pwio::utils::entIjkToIndex { ent ijk }
```
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>arg</code></dt>
  <dd>arg description.</dd>
</dl>

<br/>
```Tcl
pwio::utils::ijkToIndexStructured { ijk ijkdim }
```
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>arg</code></dt>
  <dd>arg description.</dd>
</dl>

<br/>
```Tcl
pwio::utils::indexToIjkStructured { ndx ijkdim }
```
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>arg</code></dt>
  <dd>arg description.</dd>
</dl>

<br/>
```Tcl
pwio::utils::entIndexToIjk { ent entNdx1 }
```
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>arg</code></dt>
  <dd>arg description.</dd>
</dl>

<br/>
```Tcl
pwio::utils::makeCoord { ent ijk }
```
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>arg</code></dt>
  <dd>arg description.</dd>
</dl>

<br/>
```Tcl
pwio::utils::makeCoordFromIjkVals { ent i j k }
```
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>arg</code></dt>
  <dd>arg description.</dd>
</dl>

<br/>
```Tcl
pwio::utils::makeCoordFromEntIndex { ent ndx }
```
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>ndx</code></dt>
  <dd>1-based and relative to <code>ent</code>'s pt space.</dd>
</dl>

<br/>
```Tcl
pwio::utils::sortEntsByType { ents }
```
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>arg</code></dt>
  <dd>arg description.</dd>
</dl>

<br/>
```Tcl
pwio::utils::pointToString { pt }
```
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>arg</code></dt>
  <dd>arg description.</dd>
</dl>

<br/>
```Tcl
pwio::utils::xyzEqual { xyz1 xyz2 {tol 1.0e-8} }
```
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>arg</code></dt>
  <dd>arg description.</dd>
</dl>

<br/>
```Tcl
pwio::utils::valEqual { val1 val2 {tol 1.0e-8} }
```
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>arg</code></dt>
  <dd>arg description.</dd>
</dl>

<br/>
```Tcl
pwio::utils::coordToPtString { coord }
```
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>arg</code></dt>
  <dd>arg description.</dd>
</dl>

<br/>
```Tcl
pwio::utils::vcToString { vc }
```
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>arg</code></dt>
  <dd>arg description.</dd>
</dl>

<br/>
```Tcl
pwio::utils::labelPt { ndx pt }
```
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>arg</code></dt>
  <dd>arg description.</dd>
</dl>

<br/>
```Tcl
pwio::utils::printEntInfo { title ents {dim 0} {allEnts {}} }
```
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>arg</code></dt>
  <dd>arg description.</dd>
</dl>

<br/>
```Tcl
pwio::utils::getSelection { selType selectedVarName errMsgVarName }
```
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>arg</code></dt>
  <dd>arg description.</dd>
</dl>

<br/>
```Tcl
pwio::utils::getSupportEnts { ents supEntsVarName {addEnts false}}
```
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>arg</code></dt>
  <dd>arg description.</dd>
</dl>


<hr/>


# Namespace pwio::cell
A sub-collection of procs supporting the manipulation of cells.

All of the procs in this collection reside in the `pwio::cell` namespace.

To call a proc in this collection, you must prefix the proc name with a `pwio::cell::` namespace specifier.

For example:
```Tcl
pwio::cell::getEdges $cell
```


## Library Reference pwio::cell

```Tcl
pwio::cell::getEdges { cell {minFirstOrder 0} {revVarName ""} }
```
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>arg</code></dt>
  <dd>arg description.</dd>
</dl>

<br/>
```Tcl
pwio::cell::getFaces { cell {minFirstOrder 0} }
```
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>arg</code></dt>
  <dd>arg description.</dd>
</dl>

<br/>
```Tcl
pwio::cell::getFaceEdges { face {minFirstOrder 0} {revVarName ""} }
```
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt><code>arg</code></dt>
  <dd>arg description.</dd>
</dl>


<hr/>


## Disclaimer
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
