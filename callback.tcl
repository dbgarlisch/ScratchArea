namespace eval CallbackSpec {
  variable objId_ 0

  namespace export new
  proc new {} {
    variable objId_
    variable SpecObjProto_

    # create namespace for new command instance
    set objName "[namespace current]::_::_[incr objId_]"
    namespace eval $objName $SpecObjProto_
    set ${objName}::self_ $objName

    return $objName
  }

  # object methods
  variable SpecObjProto_ {
    variable self_  {}
    variable db_ [dict create]

    namespace export add
    proc add {cbName cbArgs {cbBody __Required__} } {
      variable db_
      dict set db_ $cbName ARGS $cbArgs
      dict set db_ $cbName BODY   $cbBody
    }

    namespace export getBody
    proc getBody { cbName } {
      variable db_
      return [dict get $db_ $cbName BODY]
    }

    namespace export getArgs
    proc getArgs { cbName } {
      variable db_
      return [dict get $db_ $cbName ARGS]
    }

    namespace export hasDefault
    proc hasDefault { cbName } {
      variable db_
      return [expr {"__Required__" != "[getBody]"}]
    }

    namespace export delete
    proc delete {} {
      variable self_
      variable db_
      namespace delete $self_
    }

    namespace export dump
    proc dump {} {
      variable self_
      variable db_
      puts "CallbackSpec($self_)"
      dict for {cbName cbInfo} $db_ {
        puts "  $cbName"
        dict for {key val} $cbInfo {
          puts [format "  %10.10s: %s" $key [list [string trim $val]]]
        }
      }
    }

    namespace ensemble create
    #namespace ensemble create -unknown [namespace current]::unknown_
  }

  namespace ensemble create
}

set cbSpec [CallbackSpec new]
$cbSpec add optionalCB {a1 a2 a3} {
  puts "DEFAULT optionalCB: $a1 $a2 $a3"
}
$cbSpec add requiredCB {a1 a2 a3}
$cbSpec dump

set cbSpec2 [CallbackSpec new]
$cbSpec2 dump

puts [list [namespace children ::CallbackSpec::_]]
puts [list [info commands ::CallbackSpec::_::*]]
$cbSpec delete
puts [list [info commands ::CallbackSpec::_::*]]
$cbSpec2 delete
puts [list [info commands ::CallbackSpec::_::*]]

return 0

namespace eval NSCallbackDefault {
  proc cb3 { args } {
    puts "in [namespace current] cb3 [list $args]"
    return "[namespace current] cb3 \{ $args \}"
  }
  set sc [namespace code {puts "in scCODE"}]
  puts "sc: $sc"
}

namespace eval NSCallback {

  namespace export cb1
  proc cb1 { args } {
    puts "in cb1 [list $args]"
    return "cb1 \{ $args \}"
  }

  namespace export cb2
  proc cb2 { args } {
    puts "in cb2 [list $args]"
    return "cb2 \{ $args \}"
  }

  proc cbUnknown__ { ns cmd args } {
    puts "UNKNOWN $ns $cmd [list $args]"
    if { "" == "[info commands ${ns}::def_$cmd]" } {
      return {}
    }
    return "${ns}::def_$cmd"
  }

  namespace ensemble create -unknown [namespace current]::cbUnknown__
}

proc cbGlobal { args } {
  puts "in cbGlobal [list $args]"
  return "cbGlobal \{ $args \}"
}


proc doCallback { cb args } {
  if { "" != "[info procs $cb]" } {
    set ret [$cb {*}$args]
  } elseif { ![namespace exists $cb] } {
    error "Unknown callback '$cb $args'"
  } elseif { 1 } {
    set ret [$cb {*}$args]
  } else {
    set args [lassign $args cmd]
    if { "" == "[info commands ${cb}::$cmd]" } {
      error "Unknown namespace callback '$cb $cmd $args'"
    }
    set ret [$cb $cmd {*}$args]
  }
}

puts [info commands NSCallback::*]
puts "---------"
puts "--> [doCallback cbGlobal 1 2 3]"
puts "--> [doCallback NSCallback cb1 A1 B1 C1]"
puts "--> [doCallback NSCallback cb2 A2 B2 C2]"

catch {puts "--> [doCallback cb3 A2 B2 C2]"} err ; puts $err
catch {puts "--> [doCallback NSCallback cb3 A2 B2 C2]"} err ; puts $err
