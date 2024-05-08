import dlib
import cv2
import math

# Load the face detector and landmark predictor
detector = dlib.get_frontal_face_detector()
predictor = dlib.shape_predictor("shape_predictor_68_face_landmarks.dat")

# Load the input image
img = cv2.imread("C:/Users/khyat/Pictures/megan-fox-june-2007.jpg")

# Convert the image to grayscale
gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

# Detect faces in the grayscale image
faces = detector(gray)

# Loop over the faces and detect facial landmarks for each face
for face in faces:
    landmarks = predictor(gray, face)
    
    # Extract the relevant facial landmarks for measurements
    nose_tip = landmarks.part(30)
    chin = landmarks.part(8)
    left_eye = landmarks.part(36)
    right_eye = landmarks.part(45)
    mouth_left = landmarks.part(48)
    mouth_right = landmarks.part(54)
    
    # Calculate the measurements based on the facial landmarks
    face_width = math.sqrt((left_eye.x - right_eye.x) ** 2 + (left_eye.y - right_eye.y) ** 2)
    nose_width = nose_tip.x - landmarks.part(31).x
    mouth_width = mouth_right.x - mouth_left.x
    jawline_width = chin.x - landmarks.part(1).x
    face_height = chin.y - nose_tip.y
    
    # Print the measurements
    print("Face width:", face_width)
    print("Nose width:", nose_width)
    print("Mouth width:", mouth_width)
    print("Jawline width:", jawline_width)
    print("Face height:", face_height)
