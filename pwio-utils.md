| [README.md](README.md) | [pwio-cell.md](pwio-cell.md) |

# glyph-pwio::utils

A sub-collection of utility procs.



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
