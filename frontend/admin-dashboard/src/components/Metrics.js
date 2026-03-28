import { Line } from "react-chartjs-2";

function Metrics({ data }) {

  const chartData = {
    labels: data.map((_, i) => i),
    datasets: [
      {
        label: "Speed",
        data: data.map(d => d.speed),
      }
    ]
  };

  return <Line data={chartData} />;
}

export default Metrics;