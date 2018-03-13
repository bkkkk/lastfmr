process_tracks <- function(x) {
  select(
    x,
    played_on = `date.#text`,
    artist_name = `artist.#text`,
    song_name = name,
    album_name = `album.#text`
  )
}
