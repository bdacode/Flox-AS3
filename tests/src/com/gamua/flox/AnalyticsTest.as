package com.gamua.flox
{
    import com.gamua.flox.events.QueueEvent;
    
    import starling.unit.UnitTest;

    public class AnalyticsTest extends UnitTest
    {
        // nothing to actually test here, because the analytics class just uploads the 
        // data and can't retrieve it from the server. This test is solely an easy way to
        // step through the code.
        
        public function testLogTypes(onComplete:Function):void
        {
            var strings:Array = ["hugo", "berti", "sepp"];
            var booleans:Array = [false, true];
            var eventProperties:Object = {
                "int":      int(Math.random() * 20),
                "number":   Math.random() * 1000,
                "string":   strings[int(Math.random() * strings.length)],
                "boolean":  booleans[int(Math.random() * booleans.length)]
            };
            
            Constants.initFlox(true);
            Flox.logInfo("This is the first {0} log", "info");
            Flox.logWarning("This is a {0} log", "warning");
            Flox.logError("Error");
            Flox.logError("AnotherError", "Additional Information");
            Flox.logError(new ArgumentError("ErrorMessage"));
            Flox.logEvent("Event");
            Flox.logEvent("EventWithProperties", eventProperties);
            Flox.logEvent("EventWithSingleStringProperty", eventProperties.string);
            Flox.logEvent("EventWithSingleNumberProperty", eventProperties.number);
            Flox.logEvent("EventWithSingleBooleanProperty", eventProperties.boolean);
            Flox.logInfo("This is the last info log");
            Flox.shutdown();
            
            submitEmptySession(onComplete);
        }
        
        public function testLongLog(onComplete:Function):void
        {
            if (true) // we don't want to spam the server -- activate on demand
            {
                onComplete();
                return;
            }
            
            var count:int = 10000;
            
            Constants.initFlox(true);
            Flox.logInfo("First log line of {0}", count);
            
            for (var i:int=0; i<count; ++i)
                Flox.logInfo("Rnd " + Math.random());
            
            Flox.logInfo("Last log line");
            Flox.shutdown();
            
            submitEmptySession(onComplete);
        }
        
        public function testSendMultipleLogs(onComplete:Function):void
        {
            if (true) // we don't want to spam the server -- activate on demand
            {
                onComplete();
                return;
            }
            
            var sessionCount:int = 10;
            var logCount:int = 10;
            
            for (var s:int=0; s<sessionCount; ++s)
            {
                Constants.initFlox(true);
                Flox.logInfo("Session {0} of {1}", s+1, sessionCount);
                
                for (var l:int=0; l<logCount; ++l)
                    Flox.logInfo("Line {0} of {1}", l+1, logCount);
                
                Flox.shutdown();
            }
            
            submitEmptySession(onComplete);
        }
        
        private static function submitEmptySession(onComplete:Function):void
        {
            Constants.initFlox(true);
            
            Flox.addEventListener(QueueEvent.QUEUE_PROCESSED, function onQueueProcessed():void
            {
                Flox.removeEventListener(QueueEvent.QUEUE_PROCESSED, onQueueProcessed);
                Flox.shutdown();
                onComplete();
            });
        }
    }
}