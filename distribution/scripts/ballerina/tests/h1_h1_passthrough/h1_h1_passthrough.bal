import ballerina/http;
import ballerina/log;
import ballerina/config;
http:ListenerConfiguration serviceConfig = {
    secureSocket: {
        keyStore: {
            path: "/usr/lib/ballerina/distributions/ballerina-slp7/bre/security/ballerinaKeystore.p12",
            password: "ballerina"
        }
    }
};

http:ClientConfiguration clientConfig = {
    secureSocket: {
        trustStore: {
            path: "/usr/lib/ballerina/distributions/ballerina-slp7/bre/security/ballerinaTruststore.p12",
            password: "ballerina"
        },
        verifyHostname: false
    }
};

http:Client nettyEP = new("https://" + config:getAsString("b7a.netty")+ ":8688");
@http:ServiceConfig { basePath: "/passthrough" }
service passthroughService on new http:Listener(9090, serviceConfig) {

    @http:ResourceConfig {
        methods: ["POST"],
        path: "/"
    }
    resource function passthrough(http:Caller caller, http:Request clientRequest) {
        var response = nettyEP->forward("/service/EchoService", clientRequest);
        if (response is http:Response) {
            var result = caller->respond(<@untainted>response);
        } else {
            log:printError("Error at h1_h1_passthrough", <error>response);
            http:Response res = new;
            res.statusCode = 500;
            res.setPayload((<@untainted error>response).message());
            var result = caller->respond(res);
        }
    }
}
