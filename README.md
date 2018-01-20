# Virtual Tourist

The Virtual Tourist app downloads and stores images from Flickr. The app allows users to drop pins on a map, as if they were stops on a tour. Users will then be able to download pictures for the location and persist both the pictures, and the association of the pictures with the pin.

Objectives learned:
- Utilising NSURLSessions to interact with a public restful API
- Creating a user interface that intuitively communicates network activity and download progress
- Using Core Data for local persistence of an object structure

The app has two view controller scenes.

- Travel Locations Map View: Allows the user to drop pins around the world
- Photo Album View: Allows the users to download and edit an album for a location


##### Travel Locations Map

Tapping and holding the map drops a new pin. Users can place any number of pins on the map.
When a pin is tapped, the app will navigate to the Photo Album view associated with the pin.
Users can zoom and scroll around the map using standard pinch and drag gestures.
If the app is turned off, the map should return to the same state when it is turned on again.
The pins can be deleted.

&nbsp;![img1](https://media.giphy.com/media/l49JVIp6RzvtZongk/giphy.gif)


##### Photo Album

If the user taps a pin that does not yet have a photo album, the app will download Flickr images associated with the latitude and longitude of the pin and they will be displayed in a collection view.
If no images are found a “No Images” label will be displayed.

Tapping the New Collection button at the bottom of the page empties the photo album and fetches a new set of images.

Users can remove photos from an album by tapping them. All changes to the photo album are made persistent.

&nbsp;![Imgur](https://i.imgur.com/LIJUJKY.png)


### License
This project is licensed under the MIT License - see the [MIT](https://choosealicense.com/licenses/mit/) for details











