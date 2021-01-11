import { LightningElement,wire,track } from 'lwc';
import { registerListener, unregisterAllListener} from 'c/pubsub';
import { CurrentPageReference } from 'lightning/navigation';

export default class SubComp extends LightningElement {

    @wire(CurrentPageReference) pageRef;

    connectedCallback(){
        registerListener('pubSubEvent',this.handleCallback,this);
    }
    disconnectedCallback(){
        unregisterAllListeners(this);
    }
    handleCallback(detail){

        alert('parameter from pub component'+ detail.firstName);
    }
}