---
layout: post
title: Using this site
author: samclifford
tags:
 - jekyll
---

This page is hosted on GitHub Pages, which means if you want to contribute to it you'll need a [GitHub](https://github.com) account. Once you've got one, you can either clone or download [our repository](https://github.com/bragqut/bragqut.github.io) add write new posts with R Markdown. The easiest way to do this is to use [RStudio](http://rstudio.com) (especially if you're writing R snippets) and go to File \ New File \ R Markdown...

Use the following template as your markdown header and save as an `.Rmd` file with a title of the form `YYYY-MM-DD-username-filename.Rmd`; this will ensure that even if two people write the same file on the same day that they do not overwrite each other's posts on committing.
<!---excerpt-break-->

    ---
	title: "your_document_title"
	author: "your_name"
	output: 
     md_document:
      variant: markdown_github  
    ---


Once you've written your markdown file, Knit it to generate the `.md` file which you can copy and paste into the `_posts/` folder in your local git repository. You can add tags as follows:

    tags:
     - ggplot2
     - visualisation
 
to help categorise your posts for easier searching. To ensure there's a page that lists all the posts with this tag, you need to run the bash script `_tools/createTag tagname` from a command line terminal (e.g. Terminal.app in OS X or Cywgin/MinGW32 in Windows), replacing `tagname` with the name of the tag you want to create. This will generate an .md file in `tag` and some extra lines in `_data/tags.yml`.

Copy the folder of generated pictures to be `/assets/YYYY-MM-DD-username-filename_files/figure-markdown_github` and edit your picture references in the `.md` file you knitted to include `/assets/` at the front. This is so no one overwrites anyone else's images and we keep all the images in a folder separate to the posts (although it may be prudent to do away with this, we'll think about it).

You can also add your own author details in `_config.yml` so that when you list yourself under that author name, e.g. `samclifford` in your post's YAML header it pulls the relevant info to add to the post's header. Copy and paste your Gravatar ID in and you'll get a nice little picture associated with you for each of your posts.

Using either the GitHub desktop app or the command line interface, add the created files (the post's .md, tags' .md files and any generated images) to your local git repository and commit changes with a meaningful message. If you're already a member of the `bragqut` team on GitHub you will be able to push directly to the repository. If you're not already a contributor to `bragqut/bragqut.github.io` you can submit a pull request and one of us will pull your changes in, or pester Sam to add you to the GitHub team.

You could also fork the entire project and make your own website, as trying to build everything from the ground up can be time consuming (but it is rewarding).

NB: a lot of tutorials for Jekyll usage may give you the impression that to use GitHub pages you need to install Jekyll (and therefore Ruby and a bunch of other stuff) on your local computer. All you need to be able to do is write `.md` files (or convert from `.Rmd` to `.md`) and push them to GitHub. Installing Jekyll is great for testing whether or not your changes will break the GitHub page, but it isn't always a painless process.

For more help with GitHub Markdown, check out [GitHub's guide](https://guides.github.com/features/mastering-markdown/). For help with R Markdown, check out [RStudio's guide](http://rmarkdown.rstudio.com/).