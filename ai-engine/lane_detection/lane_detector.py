import cv2
import numpy as np
import requests

def region_of_interest(img):

    height = img.shape[0]

    polygons = np.array([
        [(0, height), (img.shape[1], height), (img.shape[1], int(height*0.6)), (0, int(height*0.6))]
    ])

    mask = np.zeros_like(img)
    cv2.fillPoly(mask, polygons, 255)

    return cv2.bitwise_and(img, mask)

def detect_lanes(frame):

    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)

    blur = cv2.GaussianBlur(gray, (5,5), 0)

    edges = cv2.Canny(blur, 50, 150)

    cropped = region_of_interest(edges)

    lines = cv2.HoughLinesP(
        cropped,
        2,
        np.pi/180,
        100,
        np.array([]),
        minLineLength=40,
        maxLineGap=5
    )

    return lines, frame

def avg_x(lines):
    xs = []
    for x1, x2 in lines:
        xs.append((x1 + x2) // 2)
    return int(np.mean(xs)) if xs else None

def detect_lane_violation(lines, frame_width):

    if lines is None:
        return False

    center_x = frame_width // 2

    left_lines = []
    right_lines = []

    for line in lines:
        x1, y1, x2, y2 = line[0]

        slope = (y2 - y1) / (x2 - x1 + 1e-6)

        # ❗ Ignore horizontal / noisy lines
        if abs(slope) < 0.5:
            continue

        if slope < 0:
            left_lines.append((x1, x2))
        else:
            right_lines.append((x1, x2))

    if not left_lines or not right_lines:
        return False

    left_avg = avg_x(left_lines)
    right_avg = avg_x(right_lines)

    if left_avg is None or right_avg is None:
        return False

    lane_center = (left_avg + right_avg) // 2
    center_x = frame_width // 2

    deviation = center_x - lane_center


    # Threshold (tune this later)
    if abs(deviation) > 200:
        return True

    return False

def main():

    cap = cv2.VideoCapture("../videos/test_video.mp4")

    while cap.isOpened():

        ret, frame = cap.read()

        if not ret:
            break

        lines, output = detect_lanes(frame)

        if lines is not None:
            for line in lines:
                x1, y1, x2, y2 = line[0]
                cv2.line(output, (x1,y1), (x2,y2), (0,255,0), 5)

        violation = detect_lane_violation(lines, frame.shape[1])
        if violation:
            cv2.putText(output, "LANE VIOLATION!", (50,50), cv2.FONT_HERSHEY_SIMPLEX, 1, (0,0,255), 3)
            print("Violation detected!")
            try:
                requests.post(
                    "http://localhost:4007/violation/report",
                    json={
                        "driverAddress": "0x70997970C51812dc3A010C7d01b50e0d17dc79C8",
                        "penalty": 5
                    }
                )
            except:
                print("Failed to send violation")

        cv2.imshow("Lane Detection", output)

        if cv2.waitKey(1) & 0xFF == ord('q'):
            break


    cap.release()
    cv2.destroyAllWindows()

if __name__ == "__main__":
    main()