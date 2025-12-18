import { LightningElement } from 'lwc';

export default class FlowWrapper extends LightningElement {

    flowName = 'experience_builder';  // hardcode

    renderedCallback() {
        if (this.hasRendered) {
            return;
        }
        this.hasRendered = true;

        const flow = this.template.querySelector("lightning-flow");
        if (flow) {
            flow.startFlow(this.flowName);
        }
    }
}