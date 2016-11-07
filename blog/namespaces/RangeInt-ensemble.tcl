namespace eval RangeInt {
  variable params_ [dict create]

  namespace export add
  proc add { name {val 0} {min inf} {max inf} } {
    variable params_
    dict set params_ $name MIN $min
    dict set params_ $name MAX $max
    RangeInt set $name $val
  }

  namespace export set
  proc set { name val } {
    variable params_
    if { [check $name $val >= MIN] && [check $name $val <= MAX] } {
      dict set params_ $name VAL $val
      return
    }
    ::set min [dict get $params_ $name MIN]
    ::set max [dict get $params_ $name MAX]
    return -code error "Invalid value: $min <= $val <= $max"
  }

  namespace export get
  proc get { name {defaultVal 0} } {
    variable params_
    return [expr {[dict exists $params_ $name VAL] ? \
                  [dict get $params_ $name VAL] : $defaultVal}]
  }

  # do not export this proc - it is for internal use only
  proc check { name val op key } {
    variable params_
    ::set limit [dict get $params_ $name $key]
    return [expr [list "$limit" == "inf" || $val $op $limit]]
  }

  # If you prefer, you could also export all three procs with one
  # call using "namespace export add set get".
  namespace ensemble create
}
