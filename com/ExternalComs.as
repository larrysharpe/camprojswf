package com {
    import flash.external.ExternalInterface;
    import flash.events.EventDispatcher;
    import flash.events.Event;

    public class ExternalComs extends EventDispatcher {

        function ExternalComs (){
            if (ExternalInterface.available) {
                ExternalInterface.call('console.log','swfConnected');
                ExternalInterface.addCallback("callGoLive", callGoLive);
                ExternalInterface.addCallback("callGoAway", callGoAway);
                ExternalInterface.addCallback("callGoOffline", callGoOffline);
            }
        }

        function setStatus (status){
            ExternalInterface.call('setStatus',status);
            ExternalInterface.call('console.log','set status ' + status);
        }

        function callGoLive (){
            ExternalInterface.call('console.log','Start Connect');
            dispatchEvent(new ConnectorEvent('onCallGoLive'));
        }


        function callGoAway (){
            ExternalInterface.call('console.log','Start Away');
            dispatchEvent(new ConnectorEvent('onCallGoAway'));
        }


        function callGoOffline (){
            ExternalInterface.call('console.log','Start Disconnect');
            dispatchEvent(new ConnectorEvent('onCallGoOffline'));
        }

        function disconnected (){
            this.setStatus('Offline');
            ExternalInterface.call('console.log','Disconnect Complete');
        }

    }
}