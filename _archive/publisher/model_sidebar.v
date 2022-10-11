module publisher

// import path
import os

pub enum SideBarStatus {
	unknown
	ok
	error
}

[heap]
struct SideBar {
pub:
	name string // is the name of the subdir (after namefix) which contains the sidebar
	page &Page  [str: skip]
	site &Site  [str: skip]
pub mut: // results in a new site
	state SideBarStatus
}
