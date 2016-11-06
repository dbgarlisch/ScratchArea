package require PWI_Glyph 2.17.0

#----------------------------------------------------------------------------
proc __PROC__ { } {
  return [dict get [info frame -1] proc]
}

#----------------------------------------------------------------------------
proc nc { ns {lvl 0} } {
  set indent [expr $lvl * 2]
  puts [format "%*.*s%s" $indent $indent " " $ns]

  incr lvl
  set children [namespace children $ns]
  foreach child $children {
    nc $child $lvl
  }
}






namespace eval pw::Thicken2D {
  variable var 1

  namespace export func1
  namespace export func2
}


#----------------------------------------------------------------------------
proc pw::Thicken2D::func1 { } {
  variable var
  puts "[__PROC__] [namespace which -variable var]=[incr var]"
}

#----------------------------------------------------------------------------
proc pw::Thicken2D::func2 { } {
  variable var
  puts "[__PROC__] [namespace which -variable var]=[incr var]"
}


##############

namespace eval pw::Thicken2D::gui {
  variable var 0
  namespace import ::pw::Thicken2D::*
}


#----------------------------------------------------------------------------
proc pw::Thicken2D::gui::okAction { } {
  variable var
  puts "#########################"
  puts "[__PROC__] [namespace which -variable var]=[incr var]"
  func1
  func2
}


#----------------------------------------------------------------------------
proc pw::Thicken2D::gui::run { } {
  variable var
  puts "#########################"
  puts "[__PROC__] [namespace which -variable var]=[incr var]"
  okAction
}


##############

set asLib 0

if { !$asLib } {
  nc ::pw::Thicken2D
  pw::Thicken2D::gui::run
  pw::Thicken2D::gui::run
}
