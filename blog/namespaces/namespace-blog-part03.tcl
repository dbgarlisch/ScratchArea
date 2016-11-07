puts "\n##########################################################"
package require PWI_Glyph 2.18.0

set dbPt [pw::Point create]
puts "dbPt's object name == '$dbPt'"
$dbPt setPoint {1.0 2.0 3.5}
puts "dbPt getXYZ        == [$dbPt getXYZ]"
puts "dbPt isConstrained == [$dbPt isConstrained]"
$dbPt delete
# $dbPt no longer exists - this will fail
catch {$dbPt isConstrained} msg
puts "dbPt isConstrained == $msg"


puts "\n##########################################################"
# Using non-object oriented RangeInt from Part 2
source "RangeInt-ensemble.tcl"

proc calcProgress { cnt total name } {
  RangeInt set $name [expr {int(100.0 * $cnt / $total)}]
}

RangeInt add percent 0 0 100
calcProgress 12 200 percent
puts "percent: 12 / 200 == [RangeInt get percent]%"

# Output
# percent: 12 / 200 == 6%

namespace delete RangeInt


puts "\n##########################################################"
# If we had an object oriented RangeInt
source "RangeInt-oo.tcl"

proc calcProgressObj { cnt total obj } {
  $obj set [expr {int(100.0 * $cnt / $total)}]
}

set percent [RangeInt create 0 0 100]
#puts "=============== exps:  [namespace eval ${percent} {namespace export}]"
calcProgressObj 12 200 $percent
puts "percent: 12 / 200 == [$percent get]%"
$percent delete

# This works if $other supports "set N" and "get"
#set other [OtherType create]
set other [RangeInt create 0 0 100]
calcProgressObj 20 400 $other
puts "  other: 20 / 400 == [$other get]%"
$other delete

# Output
# percent: 12 / 200 == 6%
#   other: 20 / 400 == 5%


puts "\n##########################################################"

# Usage
set vA [RangeInt create 22 -5 25] ;# range -5 ... 25
puts "vA's object name is '$vA'"
puts "vA == [$vA get]"
puts "vA == [$vA set -3]"
catch {$vA set 99} msg
puts "vA == $msg"
$vA delete
catch {$vA set 0} msg
puts "vA == $msg"
puts {}
set vB [RangeInt create 1 0 5] ;# range 0 ... 5
puts "vB's object name is '$vB'"
puts "vB == [$vB get]"
puts "vB == [$vB set 5]"
catch {$vB set -1} msg
puts "vB == $msg"
$vB delete
catch {$vB set 0} msg
puts "vB == $msg"
