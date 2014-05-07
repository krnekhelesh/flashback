/*
 * Flashback - Entertainment app for Ubuntu
 * Copyright (C) 2013, 2014 Nekhelesh Ramananthan <nik90@ubuntu.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

var credentials = {
    baseUrl: "http://api.themoviedb.org/3",
    apiKey: "d0a2929acb64b7c203071e87a621dfb3",
    trakt_apiKey: "20a7a6b2d0c3b58acbd81841c40355b04b46c475",
    trakt_baseUrl: "http://api.trakt.tv"
}

/*
  Movies
 */

function nowPlayingMoviesUrl() {
    return credentials.baseUrl + "/movie/now_playing" + "?api_key=" + credentials.apiKey;
}

function trendingMoviesUrl() {
    return credentials.trakt_baseUrl + "/movies/trending.json/" + credentials.trakt_apiKey;
}

function similarMoviesUrl(movie_id) {
    return credentials.baseUrl + "/movie/" + movie_id + "/similar_movies" + "?api_key=" + credentials.apiKey;
}

function upcomingMoviesUrl() {
    return credentials.baseUrl + "/movie/upcoming" + "?api_key=" + credentials.apiKey;
}

function topRatedMoviesUrl() {
    return credentials.baseUrl + "/movie/top_rated" + "?api_key=" + credentials.apiKey;
}

function movieUrl(movie_id, options) {
    options = options || {};
    var base = credentials.baseUrl + "/movie/"+ movie_id + "?api_key=" + credentials.apiKey;
    if ( options.appendToResponse )
        return base + "&append_to_response=" + options.appendToResponse.join(',');
    else
        return base;
}

function traktMovieUrl(movie_id) {
    return credentials.trakt_baseUrl + "/movie/summary.json/" + credentials.trakt_apiKey + "/" + movie_id;
}

function filterByGenreUrl(genre_id) {
    return credentials.baseUrl + "/genre/" + genre_id + "/movies" + "?api_key=" + credentials.apiKey;
}

//Genre
function genreUrl() {
    return credentials.baseUrl + "/genre/list" + "?api_key=" + credentials.apiKey;
}

// Cast
function movieCastUrl(movie_id) {
    return credentials.baseUrl + "/movie/"+ movie_id + "/credits" + "?api_key=" + credentials.apiKey;
}

// Crew
function movieCrewUrl(movie_id) {
    return credentials.baseUrl + "/movie/"+ movie_id + "/credits" + "?api_key=" + credentials.apiKey;
}

function trendingShowsUrl() {
    return credentials.trakt_baseUrl + "/shows/trending.json/" + credentials.trakt_apiKey;
}

/*
  TV Shows
 */

function tvUrl(tv_id) {
    return credentials.trakt_baseUrl + "/show/summary.json/" + credentials.trakt_apiKey + "/" + tv_id;
}

function tvSeasons(tv_id) {
    return credentials.trakt_baseUrl + "/show/seasons.json/" + credentials.trakt_apiKey + "/" + tv_id;
}

function tvSeasonUrl(tv_id, season_number) {
    return credentials.trakt_baseUrl + "/show/season.json/" + credentials.trakt_apiKey + "/" + tv_id + "/" + season_number;
}

function tvEpisodeUrl(tv_id, season_number, episode_number) {
    return credentials.trakt_baseUrl + "/show/episode/summary.json/" + credentials.trakt_apiKey + "/" + tv_id + "/" + season_number + "/" + episode_number;
}

/*
  People
 */

function popularPeopleUrl() {
    return credentials.baseUrl + "/person/popular" + "?api_key=" + credentials.apiKey;
}

function personUrl(person_id, options) {
    options = options || {};
    var base = credentials.baseUrl + "/person/"+ person_id + "?api_key=" + credentials.apiKey;
    if ( options.appendToResponse )
        return base + "&append_to_response=" + options.appendToResponse.join(',');
    else
        return base;
}

/*
  Search - Movies, TV and People
 */

function searchUrl(type, term) {
    if(type === "tv")
        return credentials.trakt_baseUrl + "/search/shows.json/" + credentials.trakt_apiKey + "?query=" + encodeURIComponent(term);
    else
        return credentials.baseUrl + "/search/"+ type + "?api_key=" + credentials.apiKey + "&query=" + encodeURIComponent(term);
}

/*
  Trakt Services - Check-in, comments, user subscribed shows etc
 */

function traktVerifyUrl() {
    return credentials.trakt_baseUrl + "/account/test/" + credentials.trakt_apiKey
}

function traktCreateAccount() {
    return credentials.trakt_baseUrl + "/account/create/" + credentials.trakt_apiKey
}

function traktAccountSettings() {
    return credentials.trakt_baseUrl + "/account/settings/" + credentials.trakt_apiKey
}

function traktAccountProfile(username) {
    return credentials.trakt_baseUrl + "/user/profile.json/" + credentials.trakt_apiKey + "/" + username
}

function userActivity(username) {
    return credentials.trakt_baseUrl + "/user/watching.json/" + credentials.trakt_apiKey + "/" + username
}

function recommendedMoviesUrl() {
    return credentials.trakt_baseUrl + "/recommendations/movies/" + credentials.trakt_apiKey
}

function traktAddRatingUrl(type) {
    return credentials.trakt_baseUrl + "/rate/" + type + "/" + credentials.trakt_apiKey
}

function traktAddCommentUrl(type) {
    return credentials.trakt_baseUrl + "/comment/" + type + "/" + credentials.trakt_apiKey
}

function traktCommentsUrl(type, id) {
    return credentials.trakt_baseUrl + "/" + type + "/comments.json/" + credentials.trakt_apiKey + "/" + id
}

function traktEpisodeCommentsUrl(id, season, episode) {
    return credentials.trakt_baseUrl + "/show/episode/comments.json/" + credentials.trakt_apiKey + "/" + id + "/" + season + "/" + episode
}

function traktCheckInUrl(type) {
    return credentials.trakt_baseUrl + "/" + type + "/checkin/" + credentials.trakt_apiKey
}

function cancelTraktCheckIn(type) {
    return credentials.trakt_baseUrl + "/" + type + "/cancelcheckin/" + credentials.trakt_apiKey
}

function traktSeenUrl(type) {
    return credentials.trakt_baseUrl + "/" + type + "/seen/" + credentials.trakt_apiKey
}

function cancelTraktSeen(type) {
    return credentials.trakt_baseUrl + "/" + type + "/unseen/" + credentials.trakt_apiKey
}

function userShowWatchlist(username) {
    return credentials.trakt_baseUrl + "/user/watchlist/shows.json/" + credentials.trakt_apiKey + "/" + username
}

function userShows(username, startDate, noOfDays) {
    return credentials.trakt_baseUrl + "/user/calendar/shows.json/" + credentials.trakt_apiKey + "/" + username + "/" + startDate + "/" + noOfDays
}

function traktWatchlistUrl(type) {
    return credentials.trakt_baseUrl + "/" + type + "/watchlist/" + credentials.trakt_apiKey
}

function traktUnwatchlistUrl(type) {
    return credentials.trakt_baseUrl + "/" + type + "/unwatchlist/" + credentials.trakt_apiKey
}

function userWatchlistMovies(username) {
    return credentials.trakt_baseUrl + "/user/watchlist/movies.json/" + credentials.trakt_apiKey + "/" + username
}
