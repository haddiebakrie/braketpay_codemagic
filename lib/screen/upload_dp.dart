import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:vibration/vibration.dart';
import '../brakey.dart';
import '../utils.dart';

class UploadProfilePicture extends StatefulWidget {
  const UploadProfilePicture({Key? key, required this.cameras, this.email=''}) : super(key: key);

  final List<CameraDescription> cameras;
  final String email;

  @override
  _UploadProfilePictureState createState() =>
      _UploadProfilePictureState();
}

class _UploadProfilePictureState
    extends State<UploadProfilePicture> {
    Brakey brakey = Get.put(Brakey());
    String currentObjective = 'Please Smile';
    bool hasSmile = false;
    bool hasBlink = false;
    bool hasTilt = false;
    int timerr = 15;
    bool completed = false;
    List images = [];

  // final FaceDetector faceDetector = FirebaseVision.instance.faceDetector();
  late List<Face> faces;
  late CameraController _camera;
  late Timer timer;

  bool _isDetecting = false;
  CameraLensDirection _direction = CameraLensDirection.back;

  @override
  void dispose() {
    _camera.stopImageStream();
    _camera.dispose();
    timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initializeCamera();
        timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        timerr--;
      });
     });
  }

  void _initializeCamera() async {

    _camera = CameraController(widget.cameras[1], ResolutionPreset.low, enableAudio:false);

      _camera.initialize().then((_) {
      if (!mounted) {
        return;
      }
      _camera.startImageStream((CameraImage image) async {
        if (timerr == 0) {
        _camera.stopImageStream();
        _camera.pausePreview();
          showDialog(context: context, builder: 
          ((context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
                  title: Text('Timeout'),
                  content: Text('Please follow the prompt at the bottom of your screen to verify your Account'),
                  actions: [
                    TextButton(onPressed: () {
                      setState(() {
                        hasSmile = false;
                        hasBlink = false;
                        hasTilt = false;
                        String currentObjective = 'Please Smile';
                        timerr = 15;
                      });
                      Get.close(2);}, child: Text('Try again'))
                  ],
                );
              
            
          })
          );
        }

        final options = FaceDetectorOptions(enableClassification: true, enableLandmarks: true, performanceMode: FaceDetectorMode.accurate);
        final faceDetector = FaceDetector(options: options);
        Face face = await detectFace(faceDetector, getImageData(image, widget.cameras[1]));
        print('Face smiling is: ${isSmiling(face)}');
        // print(hasTiltedHead(face));
        // image
        if (!hasSmile) {
          if (isSmiling(face)) {
            // _camera.pausePreview();
            try {
              // XFile smile = await _camera.takePicture();
              // images.add(smile);

            } catch (CameraException) {

            }
            // _camera.pausePreview();
            setState(() {
              Vibration.vibrate();
              currentObjective = 'Please Blink';
              hasSmile = true;
              timerr = 15;

            });
          }

            // _camera.resumePreview();
        }

        if (hasSmile && !hasBlink) {
          if (hasBlinked(face)) {
            try {
              // _camera.pausePreview();
              // XFile blink = await _camera.takePicture();
              // images.add(blink);
              // _camera.resumePreview();

            } catch (CameraException) {

            }
            setState(() {
              Vibration.vibrate();
              currentObjective = 'Please Turn your head left or right';
              hasBlink = true;
              timerr = 15;

            });
          }
        }
        if (hasSmile && hasBlink && !hasTilt) {
          if (hasTiltedHead(face)) {
            try {
            // _camera.pausePreview();
            //   XFile smile = await _camera.takePicture();
            //   images.add(smile);
            //   _camera.resumePreview();

            } catch (CameraException) {

            }
            setState(() {
              Vibration.vibrate();
              currentObjective = 'Success';
              hasTilt = true;
              timerr = 15;

            });
          }
        }

        if (_camera.value.isTakingPicture) {
          return;
        }

        if (hasSmile && hasBlink && hasTilt && mounted && !completed && !_camera.value.isTakingPicture) {
          // _camera.
            // _camera.pausePreview();
            _camera.stopImageStream();
            
          Future delay = Future.delayed(Duration(milliseconds: 1));
          delay.then((delay) async {
            print('before');
              XFile camImage = await _camera.takePicture();
              images.add(camImage);
            print('after');
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (loading) {
                    return AlertDialog(
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                        title: const Text("Verifying Image"),
                        content: Row(
                          children: const [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: CircularProgressIndicator(),
                            ),
                            Text('Please wait...'),
                          ],
                        ));
                  });
              currentObjective = 'Weldone';
              Future<List> imageLink = uploadToFireStore('userDP/${widget.email}', images);
              imageLink.then((value) {                
                  if (value.length != 1) {
                      showDialog(context: context, builder: 
                      ((context) {
                            
                            return AlertDialog(
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: Text('Can\'t verify Image'),
                              content: Text('Face verification failed, Please check your internet and try again'),
                              actions: [
                                TextButton(onPressed: () {
                                  setState(() {
                                    hasSmile = false;
                                    hasBlink = false;
                                    hasTilt = false;
                                    String currentObjective = 'Please Smile';
                                    timerr = 15;
                                  });
                                  Get.close(2);}, child: Text('Try again'))
                              ],
                            );
                          
                        
                      }));
                  } else {
                    // Get.to(() => PhotoView(imageProvider: FileImage(File(camImage.path))));
                    // print('Taken');
                  //   setState(() {
                  //   hasTilt = true;
                  //   completed = true;
                  // });
                  Get.close(1);
                  print('asjfdalksasdflasdfjlasdfalsdf');
                    Navigator.of(context).pop(imageLink);
                  // return imageLink;

                  }

              });

          });
          // takePicture();
          // XFile camimage = await _camera.takePicture();
          // Get.offUntil(MaterialPageRoute(builder: (context) => Manager(user: brakey.user.value!, pin: brakey.pin.value)), (route) => false);
          // Get.showSnackbar(
          //  GetSnackBar(message: 'You $currentObjective')
          // );
          
        }
              
  });
      // setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print('User denied camera access.');
            break;
          default:
            print('Handle other errors.');
            break;
        }
      }
    });
  
    takePicture() {
      print('taken');
    }

    
  }
  
  @override
  Widget build(BuildContext context) {
    if (!_camera.value.isInitialized) {
      return Container();
    }

    // TODO: implement build
    final mediaSize = MediaQuery.of(context).size;
    final deviceRatio = mediaSize.width / mediaSize.height;
      return Scaffold(
        appBar: AppBar(
          title: Text(''),
          backgroundColor: Colors.black54,
          elevation: 0,
        ),
        backgroundColor: Colors.black,
        bottomNavigationBar: Container(
          height: 120,
          color: Colors.black,
          child: Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Make sure your Face is within the Circle.\n', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
              Text(currentObjective, textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(timerr.toString(),  textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal)),
              ),
            ],
          ))
        ),
// return Stack(
//             children: <Widget>[
//               Center(
//                 child:Transform.scale(
//                       scale: controller.value.aspectRatio/deviceRatio,
//                       child: new AspectRatio(
//                        aspectRatio: controller.value.aspectRatio,
//                        child: new CameraPreview(controller),
//                        ),
//                    ),),);
        body: Stack(
          children: [
            // Transform.scale(scale: 1 /(_camera.value.aspectRatio  * mediaSize.aspectRatio),
            Center(
                child:Transform.scale(scale: .6 /(_camera.value.aspectRatio * mediaSize.aspectRatio),
                      child: new CameraPreview(_camera),
                   ),),
            CustomPaint(
              size: MediaQuery.of(context).size,
              painter: OverlayWithHolePainter()
            ),
            // Center(child: DashedCircularProgressBar( progress: 50, corners: StrokeCap.square, backgroundGapSize: 15, backgroundDashSize: .04, foregroundGapSize: 10, foregroundStrokeWidth: 20, backgroundStrokeWidth: 20, width: (mediaSize.width)-90, height: (mediaSize.width)-60,))
          ],
        ),
      );
        }

  }


getImageData(CameraImage cameraImage, CameraDescription camera)  {
  final WriteBuffer allBytes = WriteBuffer();
  for (final Plane plane in cameraImage.planes) {
    allBytes.putUint8List(plane.bytes);
  }
  final bytes = allBytes.done().buffer.asUint8List();

  final Size imageSize = Size(cameraImage.width.toDouble(), cameraImage.height.toDouble());

  final InputImageRotation imageRotation = InputImageRotationValue.fromRawValue(camera.sensorOrientation)!;

  final InputImageFormat inputImageFormat = InputImageFormatValue.fromRawValue(cameraImage.format.raw)!;

  final List<InputImagePlaneMetadata> planeData = cameraImage.planes.map(
    (Plane plane) {
      return InputImagePlaneMetadata(
        bytesPerRow: plane.bytesPerRow,
        height: plane.height,
        width: plane.width,
      );
    },
  ).toList();

  final inputImageData = InputImageData(
    size: imageSize,
    imageRotation: imageRotation,
    inputImageFormat: inputImageFormat,
    planeData: planeData,
  );

    final inputImage = InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);
    return inputImage;
}

Future<Face> detectFace(faceDetector, inputImage) async {
  final List<Face> faces = await faceDetector.processImage(inputImage);

  print('found ${faces.length} number of faces');

  if (faces.length < 1) {
    throw 'No face detected';
  }

  // for (Face face in faces) {
    Face face = faces[0];
    // final Rect boundingBox = face.boundingBox;

    // final double? rotX = face.headEulerAngleX; // Head is tilted up and down rotX degrees
    // final double? rotY = face.headEulerAngleY; // Head is rotated to the right rotY degrees
    // final double? rotZ = face.headEulerAngleZ; // Head is tilted sideways rotZ degrees

    // // If landmark detection was enabled with FaceDetectorOptions (mouth, ears,
    // // eyes, cheeks, and nose available):
    // final FaceLandmark leftEar = face.landmarks[FaceLandmarkType.leftEar]!;
    // if (leftEar != null) {
    //   final Point<int> leftEarPos = leftEar.position;
    // }


  // }
  
  return face;
} 

bool isSmiling(Face face) {
  double? smiling = face.smilingProbability;

  if (smiling != null) {

    if (smiling > 0.8) {
      return true;
    } else {
      return false;
    }

  } else {
    return false;
  }
}

bool hasBlinked(Face face) {
  double? leye = face.leftEyeOpenProbability;
  double? reye = face.leftEyeOpenProbability;

  if (leye == null || reye == null) {
    return false;
  }
  if (leye < .1 && reye < .1) {
    return true;
  } else {
    return false;
  }
}

hasTiltedHead(Face face) {
  double? rotY = face.headEulerAngleY;

  if (rotY == null) {
    return false;
  }
  if (rotY > 30 || rotY < -30) {
    return true;
  } else {
    return false;
  }
}

class OverlayWithHolePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black;

    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(
          Rect.fromLTWH(0, 0, size.width, size.height)
        ),
        Path()
          ..addOval(Rect.fromCircle(center: Offset(size.width/2, size.height/2), radius: (size.width/2)-20,))
          // ..addRect(Rect.fromCircle(center: Offset(size.width/2, size.height/2), width: (size.width)-90, height: (size.width)-60,))
          ..close(),
      ),
      paint
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}