proc main {} {
  set cbGrp1 [CallbackGroup new]
  $cbGrp1 add cb1 {a1 a2 a3} {
    puts "cb1: $a1 $a2 $a3"
    return "cb1"
  }
  $cbGrp1 add cb2 {a1 a2 a3} {
    puts "cb2: $a1 $a2 $a3"
    return "cb2"
  }

  set cbGrp2 [CallbackGroup new]
  $cbGrp2 add cb1 {a1 a2} {
    puts "cb1: $a1 $a2"
    return "cb1"
  }
  $cbGrp2 add cb1 {a1 a2 a3} {
    puts "cb1: $a1 $a2 $a3"
    return "cb1"
  }

  foreach grp [CallbackGroup groups] {
    puts "\n$grp ([$grp callbacks 1])"
    $grp dump 1
    if { [$grp exists cb1] } {
      puts "call cb1: [$grp cb1 1 2 3]"
    }
    if { [$grp exists cb2] } {
      puts "call cb2: [$grp cb2 A B C]"
    }
  }
}


#=========================================================
#=========================================================
#=========================================================

namespace eval CallbackGroup {
  variable objId_ 0

  namespace export new
  proc new {} {
    variable objId_
    variable CallbackGroupProto_

    # create namespace for new command instance
    set objName "[namespace current]::cbgrp_[incr objId_]"
    namespace eval $objName $CallbackGroupProto_
    namespace eval ${objName}::cb [list namespace ensemble create]
    return [set ${objName}::self_ $objName]
  }

  namespace export groups
  proc groups {} {
    return [namespace children [namespace current] cbgrp_*]
  }

  #=========================================================
  # object methods
  variable CallbackGroupProto_ {
    variable self_  {}

    namespace export add
    proc add { cbName cbArgs cbBody } {
      namespace eval [namespace current]::cb [list proc $cbName $cbArgs $cbBody]
      namespace eval [namespace current]::cb [list namespace export $cbName]
      namespace eval [namespace current]::cb [list namespace ensemble create]
    }

    namespace export exists
    proc exists { cbName } {
      set key [namespace current]::cb::$cbName
      return [expr {"[info procs $key]" == "$key"}]
    }

    namespace export callbacks
    proc callbacks { {fullNames 0} } {
      set ret [info procs [namespace current]::cb::*]
      if { !$fullNames } {
        foreach cb $ret {
          lappend ret2 [namespace tail $cb]
        }
        set ret $ret2
      }
      return $ret
    }

    namespace export call
    proc call { cbName args } {
      return [[namespace current]::cb $cbName {*}$args]
    }

    namespace export delete
    proc delete {} {
      variable self_
      namespace delete $self_
    }

    namespace export dump
    proc dump { {indent 0} } {
      set s [string repeat {  } $indent]
      foreach cb [info commands [namespace current]::cb::*] {
        puts "$s[namespace tail $cb] \{ [info args $cb] \} \{"
        set lines [lrange [split [info body $cb] "\n"] 1 end-1]
        foreach line $lines {
          puts "$s    [string range $line 4 end]"
        }
        puts "$s  \}"
      }
    }

    proc unknown_ { args } {
      if { [exists [lindex $args 1]] } {
        return "[namespace current]::cb [lindex $args 1]"
      }
      return {}
    }

    #namespace ensemble create
    namespace ensemble create -unknown [namespace current]::unknown_
  }

  namespace ensemble create
}

main
