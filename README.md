# Project 1 - Rotten Tomatoes Wannabe

Rotten Tomatoes Wannabe is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: 15 hours spent in total (5 hours for the required functionality)

## User Stories

The following **required** functionality is completed:

- [x] User can view a list of movies currently playing in theaters. Poster images load asynchronously.
- [x] User can view movie details by tapping on a cell.
- [x] User sees loading state while waiting for the API.
- [x] User sees an error message when there is a network error.
- [x] User can pull to refresh the movie list.

The following **optional** features are implemented:

- [x] Add a tab bar for **Now Playing** and **Top Rated** movies.
- [ ] Implement segmented control to switch between list view and grid view.
- [x] Add a search bar.
- [x] All images fade in.
- [x] For the large poster, load the low-res image first, switch to high-res when complete.
- [x] Customize the highlight and selection effect of the cell.
- [x] Customize the navigation bar.

The following **additional** features are implemented:

- [x] Launch screen with image and title
- [x] Added additional movie details on the individual movie pages (i.e., Rating, Release Date)
- [x] Zoomable photo view (Lab 1) - open movie poster in the full screen as a modal
- [x] Added Upcoming movies tab
- [x] Added titles to the movie list pages
- [x] Customized the tab bar colours and icons
- [x] Infinite scrolling (Lab 1) - load more movies when scrolling past the last visible cell

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='http://i.imgur.com/hrFUOpI.gif' title='Rotten Tomatoes Wannabe Video Walkthrough' width='' alt='Rotten Tomatoes Wannabe Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

- I faced some UI challenges when running the app on devices of difference sizes. For example, sometimes the images were too small and left white space to the right and bottom of the image, and other times the images were stretched too large and became distorted or the aspect ratio was off. Per the instructions, eventually just focused on improving the UI for the 6S experience primarily.
- I originally implemented 3D touch to preview the movie details screen from the list screen, but there were some alignment and data issues such that the wrong movie would be displayed. Prior to that, the cells were returning errors or nil values since the movie data was not yet passed to the details view controller (because the prepareForSegue method wasn't activated)
- Issues with re-formatting the release date string for movies into long date format while still fitting into the UI. When expanding the date into a text format, it didn't look very visually appealing. The current solution to keep it as yyyy-mm-dd numerical format works fine for the UI, but is not necessarily the usual date format for many countries if this app were to be expanded internationally.
- There are many ways I think this app can be improved or expanded on, such as using a CocoaPod solution to parse the JSON data (the current way is sufficient for now since we only dig shallowly into the json data, but can get complicated quickly as more objects/dictionaries are introduced) and adding more movie data and features.

## License

    Copyright 2016 Bianca Curutan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
