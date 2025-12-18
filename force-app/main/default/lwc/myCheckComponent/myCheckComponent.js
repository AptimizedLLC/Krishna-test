import { api } from 'lwc';
import LightningModal from 'lightning/modal';
export default class MyCheckComponent extends LightningModal {

    @api content;
    @api headerText;
    handleOkay() {
        this.close('Cancel');
    }
    handleNotOkay() {
        this.close('Yes, begin a new set of flowsheet entries for this patient');
    }
}