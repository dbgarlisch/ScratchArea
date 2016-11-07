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
    ${objName}::ctor $val $min $max
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
    proc ctor { val min max } {
      variable min_ $min
      variable max_ $max
      [namespace current]::set $val ;# error if out of range
    }

    # helper - NOT EXPORTED
    proc check { val op lim } {
      return [expr [list "$lim" == "inf" || $val $op $lim]]
    }

    namespace export set
    proc set { val } {
      variable min_
      variable max_
      if { [check $val >= $min_] && [check $val <= $max_] } {
        variable val_ $val
        return $val_
      }
      return -code error "Value $val not in ($min_, $max_)"
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
