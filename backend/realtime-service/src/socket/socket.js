let io;

function initSocket(server) {

  const { Server } = require("socket.io");

  io = new Server(server, {
    cors: {
      origin: "*"
    }
  });

  io.on("connection", (socket) => {
    console.log("Client connected:", socket.id);
  });
}

function getIO() {
  return io;
}

module.exports = { initSocket, getIO };