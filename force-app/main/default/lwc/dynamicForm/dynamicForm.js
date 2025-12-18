import { LightningElement, api, track, wire } from 'lwc';
import { getObjectInfo, getPicklistValues } from 'lightning/uiObjectInfoApi';
import saveNPP from '@salesforce/apex/NPPFormController.saveNPP'; // implement server-side saving or replace with uiRecordApi

const OBJECT_API = 'NPP__c';

export default class DynamicFormBuilder extends LightningElement {
    @api fieldListJson; // the sidebar property where admin pastes final JSON
    @track sections = [];
    @track availableFields = []; // { apiName, label }
    @track valuesMap = {}; // user-entered values

    objectInfo;
    recordTypeId;
    builderDetected = false; // show admin builder only when in site builder
    exportJson = '';
    formTitle = 'NPP Form';

    // get object metadata
    @wire(getObjectInfo, { objectApiName: OBJECT_API })
    wiredObject({ error, data }) {
        if (data) {
            this.objectInfo = data;
            this.recordTypeId = data.defaultRecordTypeId;
            this.buildAvailableFields();
            this.loadFromProperty(); // try load layout from property if present
        } else {
            // ignore errors for now
        }
    }

    // load available fields into array for builder selection list
    buildAvailableFields() {
        if (!this.objectInfo) return;
        this.availableFields = Object.keys(this.objectInfo.fields).map(apiName => ({
            apiName,
            label: this.objectInfo.fields[apiName].label
        })).sort((a,b) => a.label.localeCompare(b.label));
    }

    connectedCallback() {
        // detect Experience Builder editing mode heuristically
        try {
            const href = window.location.href;
            this.builderDetected = href && (href.includes('/builder') || href.includes('experiencebuilder'));
        } catch (e) {
            this.builderDetected = false;
        }
    }

    /* ----------------- Builder actions ----------------- */

    addSection() {
        this.sections = [...this.sections, { title: 'New Section', fields: [] }];
        this.updateExportJson();
    }

    clearSections() {
        this.sections = [];
        this.updateExportJson();
    }

    removeSection(event) {
        const idx = parseInt(event.target.dataset.index, 10);
        const copy = [...this.sections];
        copy.splice(idx,1);
        this.sections = copy;
        this.updateExportJson();
    }

    addFieldToSection(event) {
        const fieldApi = event.currentTarget.dataset.field;
        // if no sections, create one
        if (!this.sections.length) {
            this.sections = [{ title: 'Section 1', fields: [] }];
        }
        // add to last section
        const copy = JSON.parse(JSON.stringify(this.sections));
        copy[copy.length - 1].fields.push(fieldApi);
        this.sections = copy;
        this.updateExportJson();
    }

    removeFieldFromSection(event) {
        const sidx = parseInt(event.target.dataset.secIndex,10);
        const fidx = parseInt(event.target.dataset.fieldIndex,10);
        const copy = JSON.parse(JSON.stringify(this.sections));
        copy[sidx].fields.splice(fidx,1);
        this.sections = copy;
        this.updateExportJson();
    }

    moveSectionUp(event) {
        const idx = parseInt(event.target.dataset.index,10);
        if (idx <= 0) return;
        const copy = [...this.sections];
        const item = copy.splice(idx,1)[0];
        copy.splice(idx-1,0,item);
        this.sections = copy;
        this.updateExportJson();
    }

    moveSectionDown(event) {
        const idx = parseInt(event.target.dataset.index,10);
        if (idx >= this.sections.length - 1) return;
        const copy = [...this.sections];
        const item = copy.splice(idx,1)[0];
        copy.splice(idx+1,0,item);
        this.sections = copy;
        this.updateExportJson();
    }

    moveFieldUp(event) {
        const sidx = parseInt(event.target.dataset.secIndex,10);
        const fidx = parseInt(event.target.dataset.fieldIndex,10);
        if (fidx <= 0) return;
        const copy = JSON.parse(JSON.stringify(this.sections));
        const item = copy[sidx].fields.splice(fidx,1)[0];
        copy[sidx].fields.splice(fidx-1,0,item);
        this.sections = copy;
        this.updateExportJson();
    }

    moveFieldDown(event) {
        const sidx = parseInt(event.target.dataset.secIndex,10);
        const fidx = parseInt(event.target.dataset.fieldIndex,10);
        const copy = JSON.parse(JSON.stringify(this.sections));
        if (fidx >= copy[sidx].fields.length - 1) return;
        const item = copy[sidx].fields.splice(fidx,1)[0];
        copy[sidx].fields.splice(fidx+1,0,item);
        this.sections = copy;
        this.updateExportJson();
    }

    onSectionTitleChange(event) {
        const idx = parseInt(event.target.dataset.index,10);
        const value = event.target.value;
        const copy = JSON.parse(JSON.stringify(this.sections));
        copy[idx].title = value;
        this.sections = copy;
        this.updateExportJson();
    }

    updateExportJson() {
        const cfg = { sections: this.sections };
        this.exportJson = JSON.stringify(cfg, null, 2);
    }

    copyJson() {
        if (!this.exportJson) this.updateExportJson();
        navigator.clipboard.writeText(this.exportJson).then(() => {
            // small notification feedback
            // in builder you will paste this into sidebar property
            // we use alert to keep simple
            window.alert('Layout JSON copied to clipboard. Paste into component property in Experience Builder sidebar (Layout JSON).');
        }).catch(()=> {
            window.alert('Copy failed. Use the text area to copy manually.');
        });
    }

    loadFromProperty() {
        if (!this.fieldListJson) return;
        try {
            const parsed = JSON.parse(this.fieldListJson);
            if (parsed && parsed.sections) {
                this.sections = parsed.sections;
            }
        } catch (e) {
            // invalid JSON in property — ignore
        }
        this.updateExportJson();
    }

    refreshAvailableFields() {
        this.buildAvailableFields();
    }

    noop() {
        // placeholder for "Add new field" button UI
    }

    getLabelForApiName(apiName) {
        if (!this.objectInfo || !this.objectInfo.fields[apiName]) return apiName;
        return this.objectInfo.fields[apiName].label + ' (' + apiName + ')';
    }

    /* ----------------- Runtime form behavior ----------------- */

    // helper to get metadata about a field (cached simple)
    getFieldMeta(apiName) {
        const meta = this.objectInfo && this.objectInfo.fields[apiName];
        if (!meta) {
            return { label: apiName, isText:true, isPicklist:false, isBoolean:false, isDate:false, isNumber:false, options:[] };
        }
        const dataType = meta.dataType;
        const isPicklist = dataType === 'Picklist';
        const fm = {
            label: meta.label,
            isPicklist,
            isText: dataType === 'String' || dataType === 'TextArea' || dataType === 'LongTextArea',
            isBoolean: dataType === 'Boolean',
            isDate: dataType === 'Date' || dataType === 'DateTime',
            isNumber: ['Double','Integer','Long'].includes(dataType),
            options: []
        };

        // if picklist, load picklist values via dynamic wire - but simpler: use getPicklistValues function
        // We'll call getPicklistValues imperatively via the wire pattern by creating a temporary wire key.
        // For simplicity here, attempt to read picklist values synchronously from objectInfo (if present)
        if (isPicklist && meta && meta.controllerValues) {
            // not reliable cross-org; we leave options empty — actual getPicklistValues is handled via dynamic wire in simpler components
        }

        return fm;
    }

    getFieldValue(apiName) {
        return this.valuesMap[apiName] || '';
    }

    onInputChange(event) {
        const name = event.target.name;
        const value = event.target.type === 'checkbox' ? event.target.checked : event.target.value;
        this.valuesMap = { ...this.valuesMap, [name]: value };
    }

    async saveRecord() {
        // Build a simple map of field values and call Apex to save (server method saveNPP expects issuesValue & signature in previous examples).
        // For generic saving we will collect only fields present in layout and call Apex method that accepts a Map.
        const payload = {};
        this.sections.forEach(sec => {
            sec.fields.forEach(f => {
                if (this.valuesMap[f] !== undefined) payload[f] = this.valuesMap[f];
            });
        });

        try {
            // You must implement an Apex method like:
            // @AuraEnabled public static Id saveNPP(Map<String,Object> fieldMap) { ... }
            // For now we call saveNPP which earlier handled limited fields — replace with your generic save Apex.
            const result = await saveNPP({ issuesValue: payload['HQ_Any_issues_or_concerns_with_immune__c'] || '', signatureData: '' });
            window.alert('Saved (placeholder). Implement server-side save for full generic save. Returned: ' + result);
        } catch (err) {
            console.error(err);
            window.alert('Save error: ' + (err?.body?.message || err?.message || JSON.stringify(err)));
        }
    }
}