from ultralytics import YOLO
import cv2
import requests

# Load YOLO model
model = YOLO("yolov8n.pt")  # Custom model required trained on GTSRB dataset for traffic sign detection & Indian traffic dataset

def detect_signs(frame):

    results = model(frame)

    detected_signs = []

    for r in results:
        for box in r.boxes:
            cls = int(box.cls[0])
            label = model.names[cls]

            detected_signs.append(label)

    return detected_signs

def main():

    cap = cv2.VideoCapture("../videos/traffic_sign_test_video.mp4")

    while cap.isOpened():

        ret, frame = cap.read()

        if not ret:
            break

        signs = detect_signs(frame)

        for sign in signs:
            cv2.putText(frame, sign, (50,100),
                        cv2.FONT_HERSHEY_SIMPLEX, 1, (255,0,0), 2)

        # Example violation logic
        if "stop sign" in signs: # Need to map sign + vehicle behavior for real violation detection
            print("Stop sign detected!")

            try:
                requests.post(
                    "http://localhost:4007/violation/report",
                    json={
                        "driverAddress": "0x70997970C51812dc3A010C7d01b50e0d17dc79C8",
                        "penalty": 10
                    }
                )
            except:
                print("Failed to send violation")

        cv2.imshow("Sign Detection", frame)

        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    cap.release()
    cv2.destroyAllWindows()

if __name__ == "__main__":
    main()