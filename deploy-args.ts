if (!process.env.SOCKET_REGISTRY) {
  throw new Error("SOCKET_REGISTRY env variable must be specified.");
}

const socketRegistry = process.env.SOCKET_REGISTRY;

const data = [socketRegistry];

export { data };
