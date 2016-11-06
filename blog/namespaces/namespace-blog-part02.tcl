package require PWI_Glyph 2.18.0

puts "\n##########################################################"
set s1 "Hello World!"
set s2 "hello world!"
set fromToPairs {Hello Goodbye World Birdie}
puts "string"
puts "  equal          => [string equal $s1 $s2]"
puts "  equal -nocase  => [string equal -nocase $s1 $s2]"
puts "  map            => '[string map $fromToPairs $s1]'"
puts "  range          => '[string range $s2 6 end-1]'"
puts "pw::Application"
puts "  getVersion     => '[pw::Application getVersion]'"
puts "  getCAESolver   => '[pw::Application getCAESolver]'"

puts "\n##########################################################"

namespace eval RangeInt {
  variable params_ [dict create]

  proc add { name {val 0} {min inf} {max inf} } {
    variable params_
    dict set params_ $name MIN $min
    dict set params_ $name MAX $max
    RangeInt::set $name $val
  }

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

  proc get { name {defaultVal 0} } {
    variable params_
    return [expr {[dict exists $params_ $name VAL] ? \
                  [dict get $params_ $name VAL] : $defaultVal}]
  }

  proc check { name val op key } {
    variable params_
    ::set limit [dict get $params_ $name $key]
    return [expr [list "$limit" == "inf" || $val $op $limit]]
  }
}

RangeInt::add i1  888       ;# range -infinity ... +infinity
RangeInt::add i2  5   0 20  ;# range         0 ... 20
RangeInt::add i3 -3 -10     ;# range       -10 ... +infinity
RangeInt::add i4 -5 inf -5  ;# range -infinity ... -5
puts "i1  == [RangeInt::get i1]"
puts "i2  == [RangeInt::get i2]"
puts "i3  == [RangeInt::get i3]"
puts "i4  == [RangeInt::get i4]"
puts {}
RangeInt::set i1 500
puts "i1  == [RangeInt::get i1]"
puts {}
catch {RangeInt::set i2 21} msg
puts "error '$msg'"
puts "i2  == [RangeInt::get i2]"

namespace delete RangeInt

puts "\n##########################################################"

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

RangeInt add i1  888       ;# range -infinity ... +infinity
RangeInt add i2  5   0 20  ;# range         0 ... 20
RangeInt add i3 -3 -10     ;# range       -10 ... +infinity
RangeInt add i4 -5 inf -5  ;# range -infinity ... -5
puts "i1  == [RangeInt get i1]"
puts "i2  == [RangeInt get i2]"
puts "i3  == [RangeInt get i3]"
puts "i4  == [RangeInt get i4]"
puts {}
RangeInt set i1 500
puts "i1  == [RangeInt get i1]"
puts {}
catch {RangeInt set i2 21} msg
puts "error '$msg'"
puts "i2  == [RangeInt get i2]"
puts {}
puts "check == [RangeInt::check i2 5 <= MAX]" ;# direct call ok
catch {RangeInt check i2 5 <= MAX} msg
puts "error '$msg'"

puts "\n##########################################################"

namespace eval pw {

  # The pw::Grid command ensemble
  namespace eval Grid {

    namespace export getAll
    proc getAll { args } {
      ...SNIP...
    }

    namespace export getCount
    proc getCount { args } {
      ...SNIP...
    }

    namespace ensemble create
  }

  # The pw::Database command ensemble
  namespace eval Database {

    namespace export getAll
    proc getAll { args } {
      ...SNIP...
    }

    namespace export getCount
    proc getCount { args } {
      ...SNIP...
    }

    namespace ensemble create
  }
}
