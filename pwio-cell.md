| [README.md](README.md) | [pwio-utils.md](pwio-utils.md) |

# glyph-pwio::cell
A sub-collection of procs supporting the manipulation of cells.


##Table Of Contents

* [Namespace pwio::cell](#namespace-pwiocell)
* [Library Reference pwio::cell](#library-reference-pwiocell)
* [Disclaimer](#disclaimer)


## Namespace pwio::cell

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
