---
layout: post
title: Using this site
author: samclifford
tags:
 - jekyll
---

This page is hosted on GitHub Pages, which means if you want to use it you'll need a [GitHub](https://github.com) account. Once you've got one, you can either clone or download [our repository](https://github.com/bragqut/bragqut.github.io) and upload documents written using R Markdown. The easiest way to do this is to use [RStudio](http://rstudio.com) (especially if you're writing R snippets) and go to File \ New File \ R Markdown...

Use the following template as your markdown header and save as an `.Rmd` file with a title of the form `YYYY-MM-DD-title-of-file`.

```
---
title: "your_document_title"
author: "your_name"
output: 
 md_document:
  variant: markdown_github
---
```

Once you've written your markdown file, Knit it to generate the `.md` file which you can copy and paste into the `_posts/` folder in your local git repository. Using either the GitHub desktop app or the command line interface, add the file to your local git repository and commit changes with a meaningful message. If you're already a member of the `bragqut` team and can push directly, do so. If you're not already a contributor to `bragqut/bragqut.github.io` you can submit a pull request and one of us will pull your changes in.

You can also fork the entire project and make your own website, as trying to build everything from the ground up can be time consuming (but it is rewarding).