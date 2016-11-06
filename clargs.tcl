# optionlist ?valspec ?valspec?... ?default defval? ?usage text? ?
#
# where,
#
#   optionlist
#     List of option aliases. Example, {-l --long}
#
#   valspec
#     list of option argument value specs of the form:
#       valtype?*count??:range?
#
#   valtype
#     Value validation type. One of: int, real, string, file, dir, enum. You
#     can register custom value validation types using the "CLArgs vtype"
#     command.
#
#   range
#     The valid, valtype-dependent value range:
#       int    = min,max
#       float  = min,max
#       string = pattern
#       file   = absolute or relative file name.
#       dir    = absolute or relative file name.
#       enum   = delimited list of valid tokens.
#
#   count
#     The number of values expected after the option. May be a single value to
#     specify an exact count (e.g. 3), or two dash-delimited values to specify
#     a min-max count (e.g. 3-5), or a comma-delimited list of explicit or
#     min-max counts (e.g. 1,3,5-8; same as 1,3,5,6,7,8).
#
# Examples,
#
#

namespace eval CmdLineArgs {
}
