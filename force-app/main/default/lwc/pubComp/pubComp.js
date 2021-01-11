import { LightningElement, wire, track } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { fireEvent } from 'c/pubsub';

export default class PubComp extends LightningElement {

    @wire(CurrentPageReference) pageRef;

    callevent(event){
        var eventParam = {'firstName' : 'Paras'};
        fireEvent(this.pageRef, 'pubSubEvent', eventParam);

    }
}