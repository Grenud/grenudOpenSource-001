import { LightningElement, track } from 'lwc';

export default class TestTable extends LightningElement {
        @track items = [];
        nextId = 0;

        handleAddItem() {
            this.items.push({ id: this.nextId, quantity: 0, rate: 0, total: 0 });
            this.nextId++;
        }

        handleQuantityChange(event) {
            const itemId = event.target.dataset.id;
            const item = this.items.find(item => item.id == itemId);
            item.quantity = event.target.value;
            item.total = item.quantity * item.rate;
        }

        handleRateChange(event) {
            const itemId = event.target.dataset.id;
            const item = this.items.find(item => item.id == itemId);
            item.rate = event.target.value;
            item.total = item.quantity * item.rate;
        }
    }