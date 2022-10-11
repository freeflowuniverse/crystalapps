module planner

import freeflowuniverse.crystallib.redisclient
import freeflowuniverse.crystallib.redisclientcore

[heap]
struct Planner {
mut:
	gitlevel int
	redis    &redisclient.Redis
}

fn init_single_planner() Planner {
	return Planner{
		redis: redisclientcore.get()
	}
}

const planner = init_single_planner()

// init instance of planner
pub fn new() Planner {
	// reuse single object
	return planner.planner
}

// add story to planner starting from text
pub fn (mut planner Planner) story_new(text string) ?&Story {
	return &Story{}
}

// get story from the planner
pub fn (mut planner Planner) story_get(id int) ?&Story {
	return &Story{}
}
