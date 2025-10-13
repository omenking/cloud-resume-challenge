---
name: I Broke Into Tech by Building the Wrong Thing
handle: i-broke-into-tech-by-building-the-wrong-thing
date: '2025-10-12'
---

When I graduated from college in 2007, I moved in with my Nan (Grandmother). She'd been living alone ever since someone had broken into her house, and I could tell the incident had shaken her. 

It seemed like a natural arrangement—I'd keep her company, she'd give me a place to stay rent-free while I figured out my next move.

For income, I built small-business websites through eLance, a gig platform. But what I really wanted was to work for tech startups in Toronto. 

The problem? No one was conducting remote interviews back then. So with little money I had, I took an overnight Greyhound bus, showed up bleary-eyed for in-person interviews, and quickly learned a harsh truth: without a Computer Science degree, no one would hire me.

After two years of building forgettable small-business sites, I had the realization that if I couldn't get hired by a tech startup, I'd build my own startup. and I already had idea with traction.

Back in college, we'd used Blackboard LMS, and I'd found it was greatly disliked my both students and instructors. So I'd built TeacherSeat, my own Learning Management System, as an early MVP. A couple of instructors had actually adopted it, which felt like validation enough to keep going.

As I countinued development on this old project, I found myself stuck. I wasn't sure which features to build next, and some days I didn't touch the code at all. 

I needed something to shake me out of this paralysis. That's when Rails Rumble came around—an annual 48-hour online Ruby on Rails hackathon where friends formed teams and race to build something.

I teamed up with my online friend named Tyler Bird, and we brainstormed what to create. 

I'd recently watched a video about Jerry Seinfeld's productivity method: to become a better comedian, he told one joke every day and marked it off on a big calendar with a red X. The visual chain of X's became its own motivation—you didn't want to break the streak.

We decided to build that: a motivation calendar app.

The hackathon itself didn't go as planned, but I couldn't let the idea go. By myself I kept developing it, made it free to sign up, and then something unexpected happened. A couple of large Japanese websites discovered it and featured the app. Within a month, I had 100,000 signups.

Suddenly, I was scrambling to translate the entire web app into Japanese. Scaling issues multiplied overnight. My inbox flooded with bug reports and feature requests faster than I could triage them.

Yet despite the chaos, I didn't see this as success. In my mind, the motivation calendar was just a required detour from my real goal of completing TeacherSeat. I was still fixated on building that LMS, still convinced that was my path forward.

But the app had other plans. Career coaches started reaching out, asking if they could use the motivation calendar to track their clients' goals. Here was an actual market, people willing to pay for what I'd built. I attempted to implement a payment gateway to accept credit cards online, but hit an immediate wall: as a Canadian, the only option required both capital I didn't have and an incorporated business I hadn't formed. 

Still, even without a way to monetize the calendar app itself, I'd stumbled into something valuable—a steady stream of small-business website projects from career coaches.

Months later, it would be this unlikely combination of my motivation calendar Markadee, my incomplete LMS TeacherSeat, and my connection with a tech career coach named Mary that would finally break me into tech. My first real startup job was just around the corner, though I had no idea it was coming.

## The remnants of what was

I still have the codebase in a private Github repo dated from 2009-2010,
and the ony proof this app ever existed is a single screenshot from a Japanese website.

![](/assets/markadee-jp-website.png)

## Code artifact from +15 years ago

Looking through the codebase here we can see what it looks liked to write interactive javascript without modern javascript frameworks using a JS Utility library like `Prototype.js`:

`markadee/app/javascripts/searchable.js`

Today we are spoiled.

```js
Event.addBehavior({
  'input#search:focus': function(e) {
    $$('.messaging')[0].removeClassName('popup')
    $$('.accounting')[0].removeClassName('popup')
    if ($('search_results_wrapper').hasClassName('results'))
      $('search_results_wrapper').addClassName('active')
  },
  'input#search:keyup': function(e) {
    Searchable.search(this.getValue())
  },
  '.searchable_result:click': function(e) {
    location.href = this.readAttribute('url')
  },
  'a.searchable_filter_link:click': function(e) {
    if (this.hasClassName('has_results')) {
      type = this.readAttribute('type')
      $$('.searchable_filter_link').invoke('removeClassName','active')
      this.addClassName('active')
      $$('.searchable_result').invoke('show')
      if (type != 'all')
        $$('.searchable_result:not(.search_'+type+')').invoke('hide')
    }
  }
})
```