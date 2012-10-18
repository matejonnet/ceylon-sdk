import ceylon.net.httpd { HttpResponse }
import io.undertow.server { HttpServerExchange }
import org.xnio.channels { StreamSinkChannel, ChannelFactory, Channels {chFlushBlocking = flushBlocking}}
import java.nio { JByteBuffer = ByteBuffer {wrapByteBuffer = wrap} }
import java.lang { JString = String }

shared class HttpResponseImpl(HttpServerExchange exchange) satisfies HttpResponse {

	ChannelFactory<StreamSinkChannel>? factory = exchange.responseChannelFactory;
    if (!exists factory) {
        //TODO handle error
    } 
	
	variable StreamSinkChannel? response := null;

	StreamSinkChannel createResponse() {
		if (exists factory) {
	    	return factory.create();
	    } else {
	        //TODO error handle
			process.write("Missing response channel factory.");
	        throw;
	    }
	}
	
    StreamSinkChannel getResponse() {
        if (exists r = response) {
    //        if (!c.closed) {
    //            return c;
    //        }
    		return r;
        }
        response := createResponse();
        if (exists r = response) {
            return r;
        }
        //TODO exception
        throw;
    }

    shared actual void writeString(String string) {
		writeBytes(JString(string).bytes);
    }
    
    shared actual void writeBytes(Array<Integer> bytes) {
        getResponse().write(wrapByteBuffer(bytes));
    }
    
    shared actual void responseDone() {
	    getResponse().shutdownWrites();
	    //TODO always flush blocking ?
	    chFlushBlocking(response);
	    getResponse().close();
	}
    
    shared actual void addHeader(String headerName, String headerValue) {
    	exchange.responseHeaders.add(headerName, headerValue);
	}

	shared actual void responseStatus(Integer responseStatusCode) {
		exchange.responseCode := responseStatusCode;
	}

}