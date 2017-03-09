# FourSquareSample
### Sample app

> This is a sample app which perform following operations:
* Fetch near by venues using FourSquare "venues/search" rest api.
* Show list of venues with distance from current location inside a table view.
* On tap/select any venue show a detail page with venue name and address.

#### Dependency for network connections
```
"Alamofire/Alamofire" ~> 4.4 using Carthage 
```

#### Framework used for Location Service
```
CoreLocation
```

#### TODO
- [ ] Add check for no data condition
- [ ] Handle service failure
- [ ] Handle location failure/permission cases
