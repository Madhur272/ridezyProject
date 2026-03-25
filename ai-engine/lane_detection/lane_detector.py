import cv2
import numpy as np

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

        cv2.imshow("Lane Detection", output)

        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    cap.release()
    cv2.destroyAllWindows()

if __name__ == "__main__":
    main()