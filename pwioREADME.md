# glyph-pwio
A Glyph library that helps with the exporting of 2D or 3D unstructured grids.

Exporting unstructured grids requires the serial enumeration (1 to N) of all unique grid points. However, Pointwise `pw::Block` objects share grid points with the `pw::Domain` objects on their boundary. Likewise, `pw::Domain` objects share points with the `pw::Connector` objects on their boundary. Finally, `pw::Connector` objects share their end points with two `pw::Node` objects. Because of this sharing, additional data management is needed to properly enumerate the grid points. The `pwio` library provides the required data management.

<a id="Limitations" />
### Limitations
* Support for 2D boundaries needs work (see comments in the [Access Cell Connectivity (Entity By Entity)](#AccessCellConnectivityEntityByEntity) section).

<hr style='display: block; height: 1px; border: 0; border-top: 5px solid #aaa; margin: 3em 0 0.5em 0; padding: 0;' />

#Table Of Contents

* [Namespace pwio](#NamespacePwio)
   * [Library Reference pwio](#LibraryReferencePwio)
   * [The Export Sequence](#TheExportSequence)
   * [Example Usage](#ExampleUsage)
      * [Access Grid Points](#AccessGridPoints)
      * [Access Cell Connectivity (Entity By Entity)](#AccessCellConnectivityEntityByEntity)
      * [Access Cell Connectivity (Globally)](#AccessCellConnectivityGlobally)
* [Namespace pwio::utils](#NamespacePwioUtils)
   * [Library Reference pwio::utils](#LibraryReferencePwioUtils)
* [Namespace pwio::cell](#NamespacePwioCell)
   * [Library Reference pwio::cell](#LibraryReferencePwioCell)
* [Disclaimer](#Disclaimer)

<!-- [local](local.md) -->
<hr style='display: block; height: 1px; border: 0; border-top: 5px solid #aaa; margin: 3em 0 0.5em 0; padding: 0;' />

<a id="NamespacePwio" />
# Namespace pwio

All of the procs in this collection reside in the `pwio` namespace.

To call a proc in this collection, you must prefix the proc name with a `pwio::` namespace specifier. For example, `pwio::beginIO $ents`.

<a id="LibraryReferencePwio" />
## Library Reference pwio

### proc pwio::beginIO { ents }
Prepare a list of grid entities for export. Must be called once at the beginning of an export. For 2D, ents should contain `pw::Domain` entities. For 3D, ents should contain `pw::Block` entities.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>ents</dt>
  <dd>The entities to export (entity list).</dd>
</dl>

### proc pwio::endIO { {clearAllLocks 0} }
Cleans up after an export. Must be called once at the end of an export.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>clearAllLocks</dt>
  <dd>If 1, all locks will be released even if pwio did not make them (bool).</dd>
</dl>

### proc pwio::getCoordCount {}
Returns the number of unique grid points in this export.

### proc pwio::getCoord { enumNdx } {
Get an export grid coord.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>enumNdx</dt>
  <dd>The grid coord index from 1 to getCoordCount (integer).</dd>
</dl>

### proc pwio::getCoordIndex { coord {mapCoordToOwner 1} }
Returns the index corresponding to an export grid coord.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>coord</dt>
  <dd>The grid coord.</dd>
  <dt>mapCoordToOwner</dt>
  <dd>If 1, coord is be mapped to its owning entity before mapping (bool).</dd>
</dl>

If you know that the coord's entity is already the owner, this call is faster if you set this argument to 0.

### proc pwio::getCellCount {}
Returns the number of unique, top-level pw::Domain (2D) or a pw::Block (3D) volume cells grid cells in this export.

### proc pwio::getCell { enumNdx {vcVarName ""} }
Returns an export grid cell as a list of global pwio indices.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>enumNdx</dt>
  <dd>The grid cell index from 1 to getCellCount (integer).</dd>
  <dt>vcVarName</dt>
  <dd>If provided, the cell's pw::VolumeCondition is stored in this variable.</dd>
</dl>

### proc pwio::getCellIndex { ent entNdx }
Returns the global, export cell index corresponding to an entity's local cell index.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>ent</dt>
  <dd>The grid entity.</dd>
  <dt>entNdx</dt>
  <dd>The cell index in <b>ent</b>'s local index space.</dd>
</dl>

### proc pwio::getCellEdges { enumNdx {cellVarName ""} {minFirstOrder 0} {revVarName ""} }
Returns an export cell's edges as a list of global pwio indices.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>enumNdx</dt>
  <dd>The grid cell index from 1 to getCellCount (integer).</dd>
  <dt>cellVarName</dt>
  <dd>If provided, this var receives the cell's indices. See pwio::getCell.</dd>
  <dt>minFirstOrder</dt>
  <dd>If 1, edge indices are rearranged with the minimum index first.</dd>
  <dt>revVarName</dt>
  <dd>If provided, this var receives a list of reverse flags. A flag is set
      to 1 if the edge was min first reversed.</dd>
</dl>

### proc pwio::getMinFirstCellEdges { enumNdx {cellVarName ""} {revVarName ""} }
Returns an export cell's edges as a list of global pwio indices in min first order.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>enumNdx</dt>
  <dd>The grid cell index from 1 to getCellCount (integer).</dd>
  <dt>cellVarName</dt>
  <dd>If provided, this var receives the cell's indices. See pwio::getCell.</dd>
  <dt>revVarName</dt>
  <dd>If provided, this var receives a list of reverse flags. A flag is set
      to 1 if the edge was min first reversed.</dd>
</dl>

### proc getFaceEdges { face {cellVarName ""} {minFirstOrder 0} {revVarName ""} } {
Returns a list of face's edges. Each edge is a list of global pwio indices (a list of lists).
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>face</dt>
  <dd>A face as a list of global pwio indices. See pwio::getCellFaces.</dd>
  <dt>cellVarName</dt>
  <dd>If provided, this var receives a copy of face.</dd>
  <dt>minFirstOrder</dt>
  <dd>If 1, edge indices are rearranged with the minimum index first.</dd>
  <dt>revVarName</dt>
  <dd>If provided, this var receives a list of reverse flags. A flag is set
      to 1 if the edge was min first reversed.</dd>
</dl>

### proc getMinFirstFaceEdges { face {cellVarName ""} {revVarName ""} } {
Returns face's edges as a list of global pwio indices in min first order.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>face</dt>
  <dd>A face as a list of global pwio indices. See pwio::getCellFaces.</dd>
  <dt>cellVarName</dt>
  <dd>If provided, this var receives a copy of face.</dd>
  <dt>revVarName</dt>
  <dd>If provided, this var receives a list of reverse flags. A flag is set
      to 1 if the edge was min first reversed.</dd>
</dl>

### proc getCellFaces { enumNdx {cellVarName ""} {minFirstOrder 0} } {
Returns a list of a grid cell's faces. Each face is a list of global pwio indices (a list of lists).
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>enumNdx</dt>
  <dd>The grid cell index from 1 to getCellCount (integer).</dd>
  <dt>cellVarName</dt>
  <dd>If provided, this var receives the cell's unmodified indices. See pwio::getCell.</dd>
  <dt>minFirstOrder</dt>
  <dd>If 1, the face indices are *rotated* such that the minimum index is
      first. The relative ordering of the vertices is not changed (the face
      normal is *not* flipped).</dd>
</dl>

### proc getMinFirstCellFaces { enumNdx {cellVarName ""} } {
Returns a list of a grid cell's faces in min first order. Each face is a list of global pwio indices (a list of lists).
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>enumNdx</dt>
  <dd>The grid cell index from 1 to getCellCount (integer).</dd>
  <dt>cellVarName</dt>
  <dd>If provided, this var receives the cell's unmodified indices. See pwio::getCell.</dd>
</dl>

### proc getCellType { enumNdx } {
Returns the grid cell's type. One of 2D(*tri* or *quad*) or 3D(*tet*, *pyramid*, *prism*, or *hex*).
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>enumNdx</dt>
  <dd>The grid cell index from 1 to getCellCount (integer).</dd>
</dl>

### proc getFaceType { face }
Returns the face type. One of 2D(*bar*) or 3D(*tri* or *quad*).
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>face</dt>
  <dd>A face as a list of global pwio indices. See pwio::getCellFaces.</dd>
</dl>

### proc pwio::getEntityCell { ent ndx {localCellVarName ""} }
Returns an entity cell as a list of global pwio indices. These indices are only valid for calls to pwio::getCoord.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>ent</dt>
  <dd>The grid entity.</dd>
  <dt>ndx</dt>
  <dd>The cell index in <b>ent</b>'s local index space.</dd>
  <dt>localCellVarName</dt>
  <dd>If provided, this var receives the cell's local indices.</dd>
</dl>

### proc pwio::getEntityCellEdges { ent ndx {cellVarName ""} {minFirstOrder 0} {revVarName ""} }
Returns an entity cell's edges as a list of global pwio indices. These indices are only valid for calls to pwio::getCoord.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>ent</dt>
  <dd>The grid entity.</dd>
  <dt>ndx</dt>
  <dd>The cell index in <b>ent</b>'s local index space.</dd>
  <dt>cellVarName</dt>
  <dd>If provided, this var receives the cell's indices. See pwio::getCell.</dd>
  <dt>minFirstOrder</dt>
  <dd>If 1, edge indices are rearranged with the minimum index first.</dd>
  <dt>revVarName</dt>
  <dd>If provided, this var receives a list of reverse flags. A flag is set to 1 if the edge was min first reversed.</dd>
</dl>

### proc pwio::getMinFirstEntityCellEdges { ent ndx {cellVarName ""} {revVarName ""} }
Returns an entity cell's edges as a list of global pwio indices in min first order. These indices are only valid for calls to pwio::getCoord.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>ent</dt>
  <dd>The grid entity.</dd>
  <dt>ndx</dt>
  <dd>The cell index in <b>ent</b>'s local index space.</dd>
  <dt>cellVarName</dt>
  <dd>If provided, this var receives the cell's indices. See pwio::getCell.</dd>
  <dt>revVarName</dt>
  <dd>If provided, this var receives a list of reverse flags. A flag is set to 1 if the edge was min first reversed.</dd>
</dl>

### proc pwio::getCaeDim {}
Returns 2 if the grid dimensionality is 2D or 3 if 3D.

### proc pwio::getSelectType {}
Returns *Domain* if the grid dimensionality is 2D or *Block* if 3D. See `getSelection` in `utils.glf`.

### proc pwio::fixCoord { coordVarName }
Returns the grid coord corrected to use proper indexing form.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>coordVarName</dt>
  <dd>The grid coord to be modifed if needed. Required.</dd>
</dl>

### proc pwio::coordMapLower { coord }
Returns the grid coord mapped to its next lower level entity.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>coord</dt>
  <dd>The grid coord to be mapped.</dd>
</dl>

### proc pwio::mapToOwner { coord {trace 0} }
Returns the grid coord mapped to its owning entity.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>coord</dt>
  <dd>The grid coord to be mapped.</dd>
  <dt>trace</dt>
  <dd>For debugging only. If 1, the mapping sequence is dumped to stdout.</dd>
</dl>

### proc pwio::coordGetEntity { coord }
Returns the entity of the grid coord.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>coord</dt>
  <dd>The grid coord.</dd>
</dl>

### proc pwio::coordGetIjk { coord }
Returns the ijk index of the grid coord.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>coord</dt>
  <dd>The grid coord.</dd>
</dl>

### pwio::Level
Enumerated entity level values accessed as:

* `pwio::Level::Block`
* `pwio::Level::Domain`
* `pwio::Level::Connector`
* `pwio::Level::Node`

See also `coordMapToLevel`, and `entGetLevel`.

### proc pwio::entGetLevel { entOrBaseType }
Returns an entity level value.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>entOrBaseType</dt>
  <dd>A grid entity or one of `Block`, `Domain`, `Connector`, or `Node`.</dd>
</dl>

### proc pwio::coordGetLevel { coord }
Returns an entity level value for the entity in coord.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>coord</dt>
  <dd>The grid coord.</dd>
</dl>

### proc pwio::coordMapToEntity { fromCoord toEnt coordsVarName }
Returns non-zero if fromCoord can be mapped to a grid coord in toEnt.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>fromCoord</dt>
  <dd>The starting grid coord.</dd>
  <dt>toEnt</dt>
  <dd>The target grid entity.</dd>
  <dt>coordsVarName</dt>
  <dd>Receives the list of mapped grid coords. Required.</dd>
</dl>

### proc pwio::coordMapToLevel { coord toLevel coordsVarName }
Returns non-zero if coord can be mapped to a specific grid level.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>coord</dt>
  <dd>The starting grid coord.</dd>
  <dt>toLevel</dt>
  <dd>The target grid level.</dd>
  <dt>coordsVarName</dt>
  <dd>Receives the list of mapped grid coords. Required.</dd>
</dl>


<a id="TheExportSequence" />
## The Export Sequence

Exporting a grid using `pwio` requires the same basic sequence:

* Call `pwio::beginIO` with a list of entites to export.
  * A list of `pw::Domain` entites for a 2D export.
  * A list of `pw::Block` entites for a 3D export.
* Access the grid data using `pwio` and Glyph procs.
  * See the ![Example Usage](#ExampleUsage) section.
* Call `pwio::endIO` when finished.


<a id="ExampleUsage" />
## Example Usage
The following section show how to use `pwio` in conjuction with the standard Glyph calls.

While many formats have a lot in common, each export format will have differing needs. The usage examples given below will not be needed by every exporter.

<a id="AccessGridPoints" />
### Access Grid Points

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


<a id="AccessCellConnectivityEntityByEntity" />
### Access Cell Connectivity (Entity By Entity)
Accessing interior and boundary cell connectivity is done on an entity by entity
basis.

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


<a id="AccessCellConnectivityGlobally" />
### Access Cell Connectivity (Globally)
Like grid points, some export formats require the serial enumeration (1 to N) of
all unique cells.

    pwio::beginIO $gridEntsToExport

    # Get the number of cells in $gridEntsToExport.
    set cellCnt [pwio::getCellCount]
    for {set ii 1} {$ii <= $cellCnt} {incr ii} {
      # Get grid cell $ii. cell is a list of grid coord indices.
      # These indices correspond to the coords returned by [pwio::getCoord $ii]
      set cell [pwio::getCell $ii vc]
    }

    pwio::endIO


<hr style='display: block; height: 1px; border: 0; border-top: 5px solid #aaa; margin: 3em 0 0.5em 0; padding: 0;' />

<a id="NamespacePwioUtils" />
# Namespace pwio::utils
A sub-collection of utility procs.

All of the procs in this collection reside in the `pwio::utils` namespace.

To call a proc in this collection, you must prefix the proc name with a `pwio::utils::` namespace specifier. For example, `pwio::utils::entBaseType $ent`.


<a id="LibraryReferencePwioUtils" />
## Library Reference pwio::utils

### proc assert { cond msg {exitVal -1} }
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>arg</dt>
  <dd>arg description.</dd>
</dl>

### proc entBaseType { ent {subTypeVarName ""} }
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>arg</dt>
  <dd>arg description.</dd>
</dl>

### proc getBlockFaces { blk }
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>arg</dt>
  <dd>arg description.</dd>
</dl>

### proc getBlockDomains { blk }
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>arg</dt>
  <dd>arg description.</dd>
</dl>

### proc getFaceDomains { face }
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>arg</dt>
  <dd>arg description.</dd>
</dl>

### proc getFaceEdges { face }
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>arg</dt>
  <dd>arg description.</dd>
</dl>

### proc getEdgeConnectors { edge }
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>arg</dt>
  <dd>arg description.</dd>
</dl>

### proc getFaceEdgeConnectors { face }
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>arg</dt>
  <dd>arg description.</dd>
</dl>

### proc getPerimeterPointCount { ent }
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>arg</dt>
  <dd>arg description.</dd>
</dl>

### proc getOwnedPointCount { ent }
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>arg</dt>
  <dd>arg description.</dd>
</dl>

### proc isBndryEnt { ent allEnts }
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>arg</dt>
  <dd>arg description.</dd>
</dl>

### proc getNodeDbEnt { node dbEntVarName }
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>arg</dt>
  <dd>arg description.</dd>
</dl>

### proc entLockInterior { ent }
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>arg</dt>
  <dd>arg description.</dd>
</dl>

### proc entUnlockInterior { ent {clearAllLocks 0} }
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>arg</dt>
  <dd>arg description.</dd>
</dl>

### proc entGetName { ent }
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>arg</dt>
  <dd>arg description.</dd>
</dl>

### proc entGetDimensions { ent }
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>arg</dt>
  <dd>arg description.</dd>
</dl>

### proc entIjkToIndex { ent ijk }
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>arg</dt>
  <dd>arg description.</dd>
</dl>

### proc ijkToIndexStructured { ijk ijkdim }
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>arg</dt>
  <dd>arg description.</dd>
</dl>

### proc indexToIjkStructured { ndx ijkdim }
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>arg</dt>
  <dd>arg description.</dd>
</dl>

### proc entIndexToIjk { ent entNdx1 }
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>arg</dt>
  <dd>arg description.</dd>
</dl>

### proc makeCoord { ent ijk }
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>arg</dt>
  <dd>arg description.</dd>
</dl>

### proc makeCoordFromIjkVals { ent i j k }
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>arg</dt>
  <dd>arg description.</dd>
</dl>

### proc makeCoordFromEntIndex { ent ndx }
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>ndx</dt>
  <dd>1-based and relative to <b>ent</b>'s pt space.</dd>
</dl>

### proc sortEntsByType { ents }
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>arg</dt>
  <dd>arg description.</dd>
</dl>

### proc pointToString { pt }
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>arg</dt>
  <dd>arg description.</dd>
</dl>

### proc xyzEqual { xyz1 xyz2 {tol 1.0e-8} }
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>arg</dt>
  <dd>arg description.</dd>
</dl>

### proc valEqual { val1 val2 {tol 1.0e-8} }
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>arg</dt>
  <dd>arg description.</dd>
</dl>

### proc coordToPtString { coord }
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>arg</dt>
  <dd>arg description.</dd>
</dl>

### proc vcToString { vc }
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>arg</dt>
  <dd>arg description.</dd>
</dl>

### proc labelPt { ndx pt }
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>arg</dt>
  <dd>arg description.</dd>
</dl>

### proc printEntInfo { title ents {dim 0} {allEnts {}} }
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>arg</dt>
  <dd>arg description.</dd>
</dl>

### proc getSelection { selType selectedVarName errMsgVarName }
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>arg</dt>
  <dd>arg description.</dd>
</dl>

### proc getSupportEnts { ents supEntsVarName {addEnts false}}
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>arg</dt>
  <dd>arg description.</dd>
</dl>

<hr style='display: block; height: 1px; border: 0; border-top: 5px solid #aaa; margin: 3em 0 0.5em 0; padding: 0;' />

<a id="NamespacePwioCell" />
# Namespace pwio::cell
A sub-collection of procs supporting the manipulation of cells.

All of the procs in this collection reside in the `pwio::cell` namespace.

To call a proc in this collection, you must prefix the proc name with a `pwio::cell::` namespace specifier. For example, `pwio::cell::getEdges $cell`.


<a id="LibraryReferencePwioCell" />
## Library Reference pwio::cell

### proc getEdges { cell {minFirstOrder 0} {revVarName ""} }
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>arg</dt>
  <dd>arg description.</dd>
</dl>

### proc getFaces { cell {minFirstOrder 0} }
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>arg</dt>
  <dd>arg description.</dd>
</dl>

### proc getFaceEdges { face {minFirstOrder 0} {revVarName ""} }
Proc description.
<dl style='padding-left: 1em; margin: 0 2em; border: 1px solid #eee;'>
  <dt>arg</dt>
  <dd>arg description.</dd>
</dl>


<hr style='display: block; height: 1px; border: 0; border-top: 5px solid #aaa; margin: 3em 0 0.5em 0; padding: 0;' />


<a id="Disclaimer" />
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
