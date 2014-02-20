search = (keyword, cb) ->
  host = "http://search.twitter.com/"
  url = "#{host}/search.json?q=#{keyword}&callback=?"
  await $.getJSON url, defer json
  cb json.results

parallelSearch = (keywords, cb) ->
  out = []
  await
    for k,i in keywords
      search k, defer out[i]
  cb out

rankPopularity = (keywords, cb) ->
  await parallelSearch keywords, defer results
  times = for r,i in results
    last = r[r.length - 1]
    [(new Date last.created_at).getTime(), i]
  times = times.sort (a,b) -> b[0] - a[0]
  cb (keywords[tuple[1]] for tuple in times)

w_list = [ "sun", "rain", "snow", "sleet" ]
f_list = [ "tacos", "burritos", "pizza", "shrooms" ]
await
  rankPopularity w_list, defer weather
  rankPopularity f_list, defer food

if weather.length and food.length
  await search "#{weather[0]}+#{food[0]}", defer tweets
  msg = tweets[0]?.text

alert if msg? then msg else "<nothing found>"
