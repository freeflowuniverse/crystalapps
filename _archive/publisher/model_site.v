module publisher

import freeflowuniverse.crystallib.texttools
import freeflowuniverse.crystallib.publisher.config
// import path

[heap]
struct Site {
pub mut: // id and index in the Publisher.sites array
	// not in json if we would serialize
	errors        []SiteError
	path          string
	name          string // is the shortname!!!
	pages         map[string]Page
	files         map[string]File
	defs          map[string]Def
	state         SiteState
	config        &config.SiteConfig
	sidebars_last []&Page
}

pub enum SiteErrorCategory {
	duplicatefile
	duplicatepage
	emptypage
	unknown
	sidebar
}

struct SiteError {
pub:
	path  string
	error string
	cat   SiteErrorCategory
}

pub enum SiteState {
	init
	ok
	error
	loaded
}

struct SiteRepoConfig {
	// name of the wiki site
	name string
	// depends on which other wiki sites
	depends      []string
	wordreplace  []string
	filereplace  []string
	sitereplace  []string
	error_ignore []string
}

pub fn (mut site Site) error_ignore_check(name string) bool {
	// for mut item in site.config.error_ignore {
	// 	if texttools.name_fix(name) == texttools.name_fix(item) {
	// 		return true
	// 	}
	// }
	return false
}

fn (mut site Site) error(pathrelative string, errormsg string, cat SiteErrorCategory) {
	site.errors << SiteError{
		path: pathrelative
		error: errormsg
		cat: cat
	}
	println(' - SITE ERROR: $pathrelative -> $errormsg')
}
