import { LightningElement } from 'lwc';
import { subscribe } from 'lightning/empApi';
import { RefreshEvent } from 'lightning/refresh'; // ✅ Correct usage

export default class RefreshUiPageComponent extends LightningElement {
    channelName = '/event/RefreshComponentEvent__e';
    subscription = null;

    connectedCallback() {
        this.subscribeToPlatformEvent();
    }

    subscribeToPlatformEvent() {
        subscribe(this.channelName, -1, (event) => {
            console.log('📡 Event received:', event);
            this.refreshPage();
        }).then((response) => {
            console.log('✅ Subscribed to', response.channel);
        });
    }

    refreshPage() {
        this.dispatchEvent(new RefreshEvent()); // ✅ Dispatch refresh event
    }
}