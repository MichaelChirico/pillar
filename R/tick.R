format_title <- function(x, width) {
  out <- align(str_trunc(x, width))

  # HACK: Abbreviating text inbetween ticks
  ticked <- grepl("^`", x)
  if (!any(ticked)) {
    return(out)
  }

  ticked[which(get_extent(x[ticked]) <= width)] <- FALSE
  if (!any(ticked)) {
    return(out)
  }

  x_ticked <- x[ticked]
  rx <- "^`(.*)(`[^`]*)$"
  match <- gsub(rx, "\\1", x[ticked])
  rest <- gsub(rx, "\\2", x[ticked])

  short <- str_trunc(match, width + get_extent(match) - get_extent(x_ticked))
  out[ticked] <- align(paste0("`", short, rest))
  out
}

tick_names_if_needed <- function(x) {
  names(x) <- tick_if_needed(names(x))
  x
}

tick_if_needed <- function(x) {
  # Compatibility with R 3.4
  if (is.null(x)) {
    return(NULL)
  }
  needs_ticks <- !is_syntactic(x)
  x[needs_ticks] <- tick(x[needs_ticks])
  x
}

is_syntactic <- function(x) {
  # Compatibility with R 3.4
  if (is.null(x)) {
    return(logical())
  }
  ret <- make.names(x) == x
  ret[is.na(x)] <- FALSE
  ret
}

is_ambiguous_string <- function(x) {
  !is.na(x) & grepl("^$|^ | $|\\\\|\"", x)
}

tick <- function(x) {
  ifelse(is.na(x), "NA", encodeString(x, quote = "`"))
}
