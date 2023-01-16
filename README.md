# illuminate-mobile

## figma link
https://www.figma.com/file/qTJbMs4MEuwNJipERp1LYw/Illuminate-Designs?node-id=0%3A1&t=4czgF3KX5HmDXGwF-1

## clipdrop api's

* Depth Map: https://clipdrop.co/apis/docs/portrait-depth-estimation
* Normal Map: https://clipdrop.co/apis/docs/portrait-surface-normals

API Key (totally very secure!!)

> 53fd1fc49499393e445be00fb7c55a5608112b1b61973e8dd14691937af92f22d988ca52c7ae9599d023a906d59315bc

### Depth Estimation
```dart

import 'package:http/http.dart' as http;

Future<void> postData() async {
  var form = new FormData();
  form.files.add(MapEntry("image_file", photo));

  var response = await http.post(
      'https://clipdrop-api.co/portrait-depth-estimation/v1',
      headers: {'x-api-key': YOUR_API_KEY},
      body: form);

  if (response.statusCode == 200) {
    var buffer = response.bodyBytes;
    // buffer here is a binary representation of the returned image
  }
}
```
### Normal Map

```dart
import 'package:http/http.dart' as http;

Future<void> postData() async {
  var form = new FormData();
  form.files.add(MapEntry("image_file", photo));

  var response = await http.post(
    'https://clipdrop-api.co/portrait-surface-normals/v1',
    headers: {'x-api-key': YOUR_API_KEY},
    body: form);

  if (response.statusCode == 200) {
    var buffer = response.bodyBytes;
    // buffer here is a binary representation of the returned image
  }
}
```
