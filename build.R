#! /usr/bin/env Rscript
rmarkdown::render(input = "index.Rmd")

# Collect output files
out_docs   <- list.files(path = ".", pattern = "*.html", full.names = T)
out_assets <- c("assets")

# Copy files to btsync directory
if (system(command = "whoami", intern = T) == "Lukas") {
  out_dir <- "~/Sync/public.tadaa-data.de/penis_revival"
} else {
  out_dir <- "~/Dokumente/syncthing/public.tadaa-data.de/penis_revival/"
}

if (!file.exists(out_dir)) {
  dir.create(out_dir)
}

# Move to out_dir
sapply(out_docs,   file.copy, to = out_dir, overwrite = T, recursive = F)
sapply(out_assets, file.copy, to = out_dir, overwrite = T, recursive = T)

