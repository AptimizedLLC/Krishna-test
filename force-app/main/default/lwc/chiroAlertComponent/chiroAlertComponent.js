import { api } from 'lwc';
import LightningModal from 'lightning/modal';
export default class ChiroAlertComponent extends LightningModal  {
    @api content1;
    @api headerText1;
    handleOkay() {
        this.close('Cancel');
    }
    handleIgnoreChiro(){
        this.close('IgnoreChiro');
    }
}