package require PWI_Glyph


proc dbCreatePt { xyz } {
  set ret [pw::Point create]
  $ret setPoint $xyz
  return $ret
}


proc dbCreateLine { pt0 pt1 {rgb {}} } {
  set seg [pw::SegmentSpline create]
  $seg addPoint $pt0
  $seg addPoint $pt1
  set ret [pw::Curve create]
  $ret addSegment $seg
  unset seg
  if { {} != $rgb } {
    $ret setRenderAttribute ColorMode Entity
    $ret setColor $rgb
  }
  return $ret
}


proc dbCreateTangentLine { pt dir len } {
  return [dbCreateLine $pt [pwu::Vector3 add $pt [pwu::Vector3 scale $dir $len]] 0x00ffff00]
}


proc dbDecorateCrv { crv segCnt crvPts crvTangents } {
  set len [expr {[$crv getTotalLength] / $segCnt / 2.0}]
  foreach pt $crvPts {
    dbCreatePt $pt
    set crvTangents [lassign $crvTangents tangent]
    if { 3 == [llength $tangent] } {
      dbCreateTangentLine $pt $tangent $len
    }
  }
}


proc genParams { segCnt } {
  set fSegCnt [expr {1.0 * $segCnt}]
  set ret {0.0}
  for {set i 1} {$i < $segCnt} {incr i} {
    lappend ret [expr {$i / $fSegCnt}]
  }
  lappend ret 1.0
  return $ret
}


proc paramsToCurvePoints { params crv } {
  set ret {}
  foreach param $params {
    lappend ret [$crv getXYZ -parameter $param]
  }
  return $ret
}


proc paramToCurveTangent { param crv {dparam 0.01} } {
  # get pts just behind/ahead of param and build a vector from low to high
  set param0 [expr {$param - $dparam}]
  if { $param0 < 0.0 } {
    set param0 0.0
  }
  set param1 [expr {$param + $dparam}]
  if { $param1 > 1.0 } {
    set param1 1.0
  }
  return [pwu::Vector3 normalize [pwu::Vector3 subtract \
    [$crv getXYZ -parameter $param1] [$crv getXYZ -parameter $param0]]]
}


proc paramsToCurveTangents { params crv } {
  set ret {}
  #set du [expr {1.0 / [llength $params2] / 100.0}]
  foreach param $params {
    lappend ret [paramToCurveTangent $param $crv]
  }
  return $ret
}


proc createAxisSystem { anchorPt xPt zVec } {
  # xPt and zVec form the XZ plane
  set zAxis [pwu::Vector3 normalize $zVec]
  set xVec [pwu::Vector3 subtract $xPt $anchorPt]
  set yAxis [pwu::Vector3 normalize [pwu::Vector3 cross $zAxis $xVec]]
  set xAxis [pwu::Vector3 normalize [pwu::Vector3 cross $yAxis $zAxis]]
  return [list $xAxis $yAxis $zAxis]
}


proc clone { ent } {
  set copier [pw::Application begin Copy $ent]
  set theClone [$copier getEntities]
  $copier end
  unset copier
  #puts "$ent / $theClone"
  return $theClone
}


#=============================================================================
#                           MAIN
#=============================================================================

set uSegCnt 15
set uParams [genParams $uSegCnt]

set vSegCnt 20
set vParams [genParams $vSegCnt]

#puts "uParams: [list $uParams]"
#puts "vParams: [list $vParams]"

# init rail data
set railDbCrv [pw::Database getByName {rail}]
set railXPt [[pw::Database getByName {railXPt}] getPoint]
set railPts [paramsToCurvePoints $vParams $railDbCrv]
set railTangents [paramsToCurveTangents $vParams $railDbCrv]
set railAnchorPt [$railDbCrv getXYZ -parameter 0.0]
#dbDecorateCrv $railDbCrv $vSegCnt $railPts $railTangents

# init generatrix data
set gtxXPt [[pw::Database getByName {generatrixXPt}] getPoint]
set gtxDbZAxis [pw::Database getByName {generatrixZAxis}]
set gtxAnchorPt [[pw::Database getByName {generatrixAnchor}] getPoint]
set gtxAxisSys [createAxisSystem $gtxAnchorPt $gtxXPt \
                  [pwu::Vector3 subtract [$gtxDbZAxis getXYZ -parameter 1.0] \
                                         [$gtxDbZAxis getXYZ -parameter 0.0]]]
#puts "gtxAxisSys: [list $gtxAxisSys]"

# These transforms are fixed for a given run.
set xformToOrigin [pwu::Transform translation [pwu::Vector3 subtract {0 0 0} \
  $gtxAnchorPt]]
set xformAlignGlobal [pwu::Transform inverse \
  [pwu::Transform rotation [lindex $gtxAxisSys 0] [lindex $gtxAxisSys 1]]]

foreach pt $railPts {
  # create working copy of generatrix curve
  set crv [clone [pw::Database getByName {generatrix}]]
  # move crv from gtxAnchorPt to origin
  $crv transform $xformToOrigin
  # rotate crv to align its axis system with the global axis system
  $crv transform $xformAlignGlobal
  # get tangent vec at pt
  set railTangents [lassign $railTangents tangent]
  # offset railXPt to vicinity of current pt on rail
  set xform [pwu::Transform translation [pwu::Vector3 subtract $pt $railAnchorPt]]
  set tmpRailXPt [pwu::Transform apply $xform $railXPt]
  # build rail axis system for pt, tmpRailXPt, and tangent
  set railAxisSys [createAxisSystem $pt $tmpRailXPt $tangent]
  # rotate crv to align with the rail axis system at pt
  set xform [pwu::Transform rotation [lindex $railAxisSys 0] [lindex $railAxisSys 1]]
  $crv transform $xform
  # move crv from origin to pt
  set xform [pwu::Transform translation [pwu::Vector3 subtract $pt {0 0 0}]]
  $crv transform $xform
}
