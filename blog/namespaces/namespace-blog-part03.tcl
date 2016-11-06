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
namespace eval RangeInt {
  variable cnt_ 0 ;# used to create unique object names

  namespace export create
  proc create { {val 0} {min inf} {max inf} } {
    set ns [namespace current]
    # Build unique object name == "${ns}::_N"
    set objName "${ns}::_[incr ${ns}::cnt_]"
    # Create the object command ensemble
    eval "namespace eval $objName \$${ns}::proto_"
    # Init the object - error if $val is out of range
    ${objName}::ctor $min $max $val
    return $objName
  }
  namespace ensemble create ;# create the RangeInt ensemble

  #----------------------------------------------------------
  # RangeInt object ensembles support these subcommands
  variable proto_ {
    variable min_   inf  ;# object's range min
    variable max_   inf  ;# object's range max
    variable val_   0    ;# object's current value

    # constructor - NOT EXPORTED
    proc ctor { min max val } {
      variable min_ $min
      variable max_ $max
      [namespace current]::set $val ;# error if out of range
    }

    # helper - NOT EXPORTED
    proc check { val op limit } {
      return [expr [list "$limit" == "inf" || $val $op $limit]]
    }

    namespace export set
    proc set { val } {
      variable min_
      variable max_
      if { [check $val >= $min_] && [check $val <= $max_] } {
        variable val_ $val
        return $val_
      }
      return -code error "Invalid value: $min_ <= $val <= $max_"
    }

    namespace export get
    proc get {} {
      variable val_
      return $val_
    }

    namespace export delete
    proc delete {} {
      namespace delete [namespace current]
    }

    namespace ensemble create ;# create the object ensemble
  } ;# end proto_
}

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
