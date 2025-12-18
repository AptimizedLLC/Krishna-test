import LightningDatatable from 'lightning/datatable';
import customPicklist from "./customPicklist.html";
import customPicklistEdit from "./customPicklistEdit.html";

export default class CustomDataType extends LightningDatatable {
    static customTypes = {
        picklist: {
            template: customPicklist,
            editTemplate: customPicklistEdit,
            standardCellLayout: true,
            typeAttributes: ['options', 'value', 'context']
        }
    };
}