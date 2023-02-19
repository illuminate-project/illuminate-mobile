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

## DPT Model

This is a DPT model called DenseDepth and it's already hosted on RunwayML. Can use this as backup in case we can't get Omnidata setup*

### Query the Model
```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

final inputs = {
  "image": <base 64 image>
};

final url = 'https://densedepth-1e8c4305.hosted-models.runwayml.cloud/v1/query';
final token = 'Bearer X/yZ/TJhio305LHtIg80Cg==';

final response = await http.post(url, headers: {
  "Accept": "application/json",
  "Authorization": token,
  "Content-Type": "application/json",
}, body: json.encode(inputs));

final outputs = json.decode(response.body);
final depthImage = outputs['depth_image'];
// use the outputs in your project
```

### get input/output specs

```dart
final response = await http.get(url, headers: {
  "Accept": "application/json",
  "Authorization": token,
  "Content-Type": "application/json",
});

final info = json.decode(response.body);
final description = info['description'];
final name = info['name'];
final inputs = info['inputs'];
final outputs = info['outputs'];
// use the info in your project
```

### Get Metadata + Status

```dart
fetch("https://densedepth-1e8c4305.hosted-models.runwayml.cloud/v1/", {
  method: "GET",
  headers: {
    "Accept": "application/json",
    "Authorization": "Bearer X/yZ/TJhio305LHtIg80Cg==",
    "Content-Type": "application/json",
  }
})
.then(response => response.json())
.then(metadata => {
  const { status, queryRoute, dataRoute, errorRoute } = metadata;
  // use the metadata + status in your project
});
```


# 3D Stuff
Might be helpful: https://www.reddit.com/r/flutterhelp/comments/wb6sep/flutter_threejs/

# Javascript 3D Model Development
https://huggingface.co/spaces/johnrobinsn/MidasDepthEstimation
