from ultralytics import YOLO
import cv2
import requests
import sys
import os
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
from core.violation_engine import ViolationEngine
import threading
import time

# Load YOLO model
model = YOLO("../runs/detect/train3/weights/best.pt")  # Custom model required trained on GTSRB dataset for traffic sign detection & Indian traffic dataset

def detect_signs(frame):

    results = model(frame)

    detected_signs = []

    for r in results:
        for box in r.boxes:
            cls = int(box.cls[0])
            label = model.names[cls]

            confidence = float(box.conf[0])

            # 🔥 filter low confidence
            if confidence > 0.5:
                detected_signs.append(label)

                x1, y1, x2, y2 = map(int, box.xyxy[0])

                cv2.rectangle(frame, (x1,y1), (x2,y2), (0,255,0), 2)
                cv2.putText(frame, f"{label} {confidence:.2f}",
                            (x1, y1-10),
                            cv2.FONT_HERSHEY_SIMPLEX,
                            0.7,
                            (0,255,0),
                            2)

    return detected_signs

def main():
    engine = ViolationEngine()
    cap = cv2.VideoCapture("../videos/traffic_sign_test_video.mp4")

    last_violation_time = 0
    cooldown = 2  # seconds
    threading.Thread(target=engine.run, daemon=True).start()

    while cap.isOpened():

        ret, frame = cap.read()

        if not ret:
            break

        signs = detect_signs(frame)

        for sign in signs:
            cv2.putText(frame, sign, (50,100), cv2.FONT_HERSHEY_SIMPLEX, 1, (255,0,0), 2)

        # Example violation logic
        if "stop sign" in signs: # Need to map sign + vehicle behavior for real violation detection
            current_time = time.time()
            if current_time - last_violation_time > cooldown:
                print("Stop sign detected!")
                try:
                    # requests.post(
                    #     "http://localhost:4007/violation/report",
                    #     json={
                    #         "driverAddress": "0x70997970C51812dc3A010C7d01b50e0d17dc79C8",
                    #         "penalty": 10
                    #     }
                    # )
                    engine.add_violation("0x70997970C51812dc3A010C7d01b50e0d17dc79C8", "stop_sign", 10)    
                    last_violation_time = current_time
                except:
                    print("Failed to send violation")
                

        cv2.imshow("Sign Detection", frame)

        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    cap.release()
    cv2.destroyAllWindows()

if __name__ == "__main__":
    main()