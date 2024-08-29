exports.handler = async function(event) {
    const connectionId = event.requestContext.connectionId;
    const eventType = event.requestContext.eventType;
  
    if (eventType === 'CONNECT') {
      console.log(`Connection established: ${connectionId}`);
      return { statusCode: 200, body: 'Connected.' };
    } else if (eventType === 'DISCONNECT') {
      console.log(`Connection closed: ${connectionId}`);
      return { statusCode: 200, body: 'Disconnected.' };
    } else {
      const message = JSON.parse(event.body).message;
      console.log(`Received message: ${message} from ${connectionId}`);
      return { statusCode: 200, body: 'Message received.' };
    }
  };
  