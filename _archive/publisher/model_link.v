module publisher

enum LinkType {
	file
	page
	unknown
	html
	data
	email
	anchor
	code
}

enum LinkState {
	ok
	missing
	error
}

struct Link {
	// original string //how link was put in the document
	original_descr string // when we want to replace
mut:
	original_link string
pub mut:
	isexternal  bool
	include     bool = true // means we will not link to the remote location, will always keep on local sidebar
	newtab      bool
	moresites   bool // this means we can look for the content on multiple source sites
	cat         LinkType
	isimage     bool // means started with !
	description string
	url         string
	// identification of link:
	filename string // is the name of the page/file where the link points too
	site     string // is the sitename where the link points too
	extra    string // e.g. ':size=800x900'
	// internal
	state       LinkState
	error_msg   string
	page_source &Page     [str: skip]
}

// add link to the page
fn (mut page Page) link_new(original_descr string, original_link string, isimage bool) ?Link {
	mut link := Link{
		original_descr: original_descr.trim(' ')
		original_link: original_link.trim(' ')
		isimage: isimage
		page: &page
	}

	return link
}

fn (mut link Link) error(msg string) {
	link.state = LinkState.error
	link.error_msg = msg
}

fn (mut link Link) site_source_get() ?&Site {
	page := link.page_source_get(mut publisher)?
	return page.site_get(mut publisher)
}

fn (mut link Link) site_dest_get() ?&Site {
	page := link.page_dest_get(mut publisher)?
	mut site := page.site_get(mut publisher)?
	if link.site != site.name {
		panic('BUG site name needs to be same as linked site')
	}
	return site
}

// get the page where is linked too
pub fn (mut link Link) page_dest_get() ?&Page {
	if link.page_id_dest == 999999 {
		return error('destpage id cannot be 999999./n$link')
	}
	if link.cat == LinkType.page {
		return page_get_by_id(link.page_id_dest)
	}
	return error('can only return Page.\n$link')
}

// get the page which has the link
pub fn (mut link Link) page_source_get() ?&Page {
	if link.page_id_source == 999999 {
		return error('sourcepage id cannot be 999999./n$link')
	}
	return page_get_by_id(link.page_id_source)
}

fn (mut link Link) file_get() ?&File {
	if link.page_id_dest == 999999 {
		return error('file id cannot be 999999./n$link')
	}
	if link.cat == LinkType.file {
		return file_get_by_id(link.page_id_dest)
	}
	return error('can only return File')
}
