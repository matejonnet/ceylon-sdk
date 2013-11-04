import ceylon.net.http.server.internal { DefaultServer }
import ceylon.net.http.server.websocket { WebSocketBaseEndpoint }

"Ceylon http server."
by("Matej Lazar")
see(`function createServer`)
shared interface Server {

    "Define endpoint by providing an instance of [[Endpoint]]|[[AsynchronousEndpoint]] class."
    shared formal void addEndpoint(HttpEndpoint endpoint);

    shared formal void addWebSocketEndpoint(WebSocketBaseEndpoint endpoint);

    shared formal void start(Integer port = 8080, //TODO use SocketAddress 
            String host = "127.0.0.1", 
            Options serverOptions = Options());
    
    "Starts httpd in a new thread."
    shared formal void startInBackground(Integer port = 8080, 
        String host = "127.0.0.1", 
        Options serverOptions = Options());
    
    shared formal void stop();
    
    "Registers a status change listener.
     Listeners are called on status changes. 
     Statuses are: [[starting]], [[started]], [[stopping]], [[stopped]]."
    shared formal void addListener(void listener(Status status));
    
    "Removes status change listener."
    shared formal void removeListener(void listener(Status status));
}

shared Server createServer({HttpEndpoint|WebSocketBaseEndpoint*} endpoints) {
    Server server = DefaultServer();
    for (endpoint in endpoints) {
        switch(endpoint)
        case (is WebSocketBaseEndpoint) {
            server.addWebSocketEndpoint(endpoint);
        }
        case (is HttpEndpoint) {
            server.addEndpoint(endpoint);
        }
    }
    return server;
} 
