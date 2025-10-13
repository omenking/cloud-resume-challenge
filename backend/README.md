## Render Project Emulate Markdown

For our project page we want to be able to render markdown.
We know we should render markdown serverside because client side
markdown rendering is difficult to implement and provides inconsistent results.

our `render_projects.py` will render our json with the markdown into html.
Eventually we'll rework this code into our serverless functions.

## Render Items with Frontmatter

Both my projects and blog posts rely on markdown.
It would probably be better to collect markdown files with front matter and turn those into json objects.
Maybe everything contained within a directory for data.

eg. `/projects/:handle.markdown`
eg. `/blog/:handle.markdown`

## Tasks runner with invoke

I am using the task runner invoke and refactor the render_projects into render_items
so it can render the projects and tbe blog.

```sh
invoke --list
invoke render-blog
invoke render-projects
```

## Pygments

For our synytax highlighting for our markdown we need to gererate the css.
pip install Pygments
pygmentize -S monokai -f html -a .codehilite > pygments.css