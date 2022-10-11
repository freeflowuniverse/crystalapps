module publisher

import freeflowuniverse.crystallib.texttools
import freeflowuniverse.crystallib.publisher.config

[heap]
struct Publisher {
pub:
	name string
mut:
	gitlevel int
pub mut:
	sites      []Site
	site_names map[string]int
	// maps definition name to page id
	def_names map[string]int
	develop   bool
	replacer  ReplacerInstructions
	config    config.ConfigRoot
	init      bool
}

struct ReplacerInstructions {
pub mut:
	site texttools.ReplaceInstructions
	file texttools.ReplaceInstructions
	word texttools.ReplaceInstructions
	defs texttools.ReplaceInstructions
}

// pub fn (mut publisher Publisher) site_get_by_id(id int) ?&Site {
// 	if id > publisher.sites.len {
// 		return error('cannot get site with id: $id because not enough sites in the list')
// 	}
// 	return &publisher.sites[id]
// }

// pub fn (mut publisher Publisher) def_get_by_id(id int) ?&Def {
// 	if id > publisher.defs.len {
// 		return error('cannot get def with id: $id because not enough defs in the list')
// 	}
// 	return &publisher.defs[id]
// }

// pub fn (mut publisher Publisher) page_get_by_id(id int) ?&Page {
// 	// println("page get by id: '$id'")
// 	if id > publisher.pages.len {
// 		return error('cannot get page with id: $id because not enough pages in the list')
// 	}
// 	// println(publisher.pages[id])
// 	return &publisher.pages[id]
// }

// pub fn (mut publisher Publisher) file_get_by_id(id int) ?&File {
// 	if id > publisher.files.len {
// 		return error('cannot get file with id: $id because not enough files in the list')
// 	}
// 	return &publisher.files[id]
// }

////////////////////////////////////////////////////////////////

pub fn (mut publisher Publisher) site_exists(name string) bool {
	name2 := texttools.name_fix(name)
	return name2 in publisher.site_names
}

pub fn (mut publisher Publisher) def_exists(name string) bool {
	name2 := texttools.name_fix_no_underscore(name)
	return name2 in publisher.def_names
}

pub fn (mut publisher Publisher) file_exists(name string) bool {
	sitename, itemname := name_split(name) or { panic(err) }
	if sitename == '' {
		for site in publisher.sites {
			if itemname in site.files {
				return true
			}
		}
		return false
	} else {
		site := publisher.site_get(sitename) or { return false }
		return itemname in site.files
	}
}

pub fn (mut publisher Publisher) page_exists(name string) bool {
	mut sitename, itemname := name_split(name) or { panic(err) }
	if sitename == '' {
		for site in publisher.sites {
			if itemname in site.pages {
				return true
			}
		}
		return false
	} else {
		site := publisher.site_get(sitename) or { return false }
		return itemname in site.pages
	}
}

////////////// GET BY NAME

pub fn (mut publisher Publisher) site_get(namefull string) ?&Site {
	sitename := texttools.name_fix(namefull)
	if sitename in publisher.site_names {
		mut site := publisher.site_get_by_id(publisher.site_names[sitename]) or {
			// println(publisher.site_names)
			return error('cannot find site: $sitename')
		}
		return site
	}
	return error('cannot find site: $sitename')
}

pub fn (mut publisher Publisher) def_get(namefull string) ?&Def {
	mut defname := texttools.name_fix_no_underscore(namefull)
	if defname.ends_with('.md') {
		defname = defname[0..(defname.len - 3)]
	}
	// println(" >>> defget: $defname")
	if defname in publisher.def_names {
		mut def := publisher.def_get_by_id(publisher.def_names[defname]) or {
			// println(publisher.def_names)
			return error('cannot find def: $defname')
		}
		return def
	}
	return error('cannot find def: $defname')
}

// namefull is name with : if needed
pub fn (mut publisher Publisher) files_get(namefull string) ?[]&File {
	sitename, itemname := name_split(namefull)?

	// get name without extension and trailing _
	filename_2 := texttools.name_fix_no_underscore_no_ext(itemname)?

	site_id := publisher.site_names[sitename]
	mut res := []&File{}
	for x in 0 .. publisher.files.len {
		mut file := publisher.files[x]
		if sitename != '' && file.site_id != site_id {
			// no need to check more, check next file
			continue
		}
		// check if we can find _png
		name_fixed := file.name_fixed(mut publisher)?
		if name_fixed == filename_2 {
			file_found := publisher.file_get_by_id(x)?
			if file_found !in res {
				res << file_found
			}
		}
	}
	return res
}

// namefull is name with : if needed
pub fn (mut publisher Publisher) pages_find(namefull string) ?[]&Page {
	sitename, itemname := name_split(namefull)?
	site_id := publisher.site_names[sitename]
	mut res := []&Page{}
	for x in 0 .. publisher.pages.len {
		page := publisher.pages[x]
		if sitename != '' && page.site_id != site_id {
			// no need to check more, check next page
			continue
		}
		if page.name == itemname {
			page_found := publisher.page_get_by_id(x)?
			if page_found !in res {
				res << page_found
			}
		}
	}
	return res
}

pub fn (mut publisher Publisher) pages_find_name(namefull string) ?[]string {
	mut res := []string{}
	pages := publisher.pages_find(namefull)?
	for page in pages {
		res << page.name
	}
	return res
}

// name in form: 'sitename:filename' or 'filename'
pub fn (mut publisher Publisher) file_get(namefull string) ?&File {
	sitename, itemname := publisher.name_split_alias(namefull)?
	// println(" >> file_get:'$sitename':'$itemname'")
	if sitename != '' {
		site := publisher.site_get(sitename)?
		return site.file_get(itemname, mut publisher)
	}
	res := publisher.files_get(namefull)?
	if res.len == 0 {
		return error("Could not find file: '$namefull'")
	} else if res.len > 1 {
		return error("Found more than 1 file with name: '$namefull'")
	} else {
		return res[0]
	}
}

// name in form: 'sitename:pagename' or 'pagename'
pub fn (mut publisher Publisher) page_get(namefull string) ?&Page {
	sitename, itemname := publisher.name_split_alias(namefull)?
	// println(" >> page_get:'$sitename':'$itemname'")
	if sitename != '' {
		site := publisher.site_get(sitename)?
		return site.page_get(itemname, mut publisher)
	}
	res := publisher.pages_find(namefull)?
	if res.len == 0 {
		return error("Could not find page: '$namefull'")
	} else if res.len > 1 {
		return error("Found more than 1 page with name: '$namefull'")
	} else {
		return res[0]
	}
}

enum ExistState {
	ok
	double
	notfound
	namespliterror
	error
}

// try and get if page exists and return state of how it did exist
pub fn (mut publisher Publisher) page_exists_state(name string) ExistState {
	_ := publisher.page_get(name) or {
		if err.msg().contains('not find page') {
			return ExistState.notfound
		} else if err.msg().contains('site not found') {
			return ExistState.notfound
		} else if err.msg().contains('more than 1 page') {
			return ExistState.double
		} else if err.msg().contains('namesplit issue') {
			return ExistState.namespliterror
		}
		return ExistState.error
	}
	return ExistState.ok
}

pub fn (mut publisher Publisher) def_add(def Def) ?int {
	publisher.defs << def
	name := def.name_fixed()?
	publisher.def_names[name] = publisher.defs.len - 1
	return publisher.def_names[name]
}

// try and get if file exists and return state of how it did exist
pub fn (mut publisher Publisher) file_exists_state(name string) ExistState {
	_ := publisher.file_get(name) or {
		if err.msg().contains('not find file') {
			return ExistState.notfound
		} else if err.msg().contains('site not found') {
			return ExistState.notfound
		} else if err.msg().contains('more than 1 file') {
			return ExistState.double
		} else if err.msg().contains('namesplit issue') {
			return ExistState.namespliterror
		}
		return ExistState.error
	}
	return ExistState.ok
}

// try and get if page or file exists and return state of how it did exist
pub fn (mut publisher Publisher) page_file_exists_state(name string, ispage bool) ExistState {
	if ispage {
		return publisher.page_exists_state(name)
	} else {
		return publisher.file_exists_state(name)
	}
}
