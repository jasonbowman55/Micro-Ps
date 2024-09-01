if {[catch {

# define run engine funtion
source [file join {C:/lscc/radiant/2024.1} scripts tcl flow run_engine.tcl]
# define global variables
global para
set para(gui_mode) "1"
set para(prj_dir) "C:/Users/jbowman/Desktop/jason_lattice_radiant/iCE40_demo"
# synthesize IPs
# synthesize VMs
# synthesize top design
file delete -force -- iCE40_demo_impl_1.vm iCE40_demo_impl_1.ldc
::radiant::runengine::run_engine_newmsg synthesis -f "iCE40_demo_impl_1_lattice.synproj" -logfile "iCE40_demo_impl_1_lattice.srp"
::radiant::runengine::run_postsyn [list -a iCE40UP -p iCE40UP5K -t SG48 -sp High-Performance_1.2V -oc Industrial -top -w -o iCE40_demo_impl_1_syn.udb iCE40_demo_impl_1.vm] [list C:/Users/jbowman/Desktop/jason_lattice_radiant/iCE40_demo/impl_1/iCE40_demo_impl_1.ldc]

} out]} {
   ::radiant::runengine::runtime_log $out
   exit 1
}
