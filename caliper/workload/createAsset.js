'use strict';

const { WorkloadModuleBase } = require('@hyperledger/caliper-core');

class MyWorkload extends WorkloadModuleBase {
    constructor() {
        super();
        this.txIndex = -1;
    }

    /**
    * Initialize the workload module with the given parameters.
    * @param {number} workerIndex The 0-based index of the worker instantiating the workload module.
    * @param {number} totalWorkers The total number of workers participating in the round.
    * @param {number} roundIndex The 0-based index of the currently executing round.
    * @param {Object} roundArguments The user-provided arguments for the round from the benchmark configuration file.
    * @param {ConnectorBase} sutAdapter The adapter of the underlying SUT.
    * @param {Object} sutContext The custom context object provided by the SUT adapter.
    * @async
    */
    async initializeWorkloadModule(workerIndex, totalWorkers, roundIndex, roundArguments, sutAdapter, sutContext) {
        await super.initializeWorkloadModule(workerIndex, totalWorkers, roundIndex, roundArguments, sutAdapter, sutContext);
        
        const tx = []
        for(let i = 1; i <= this.roundArguments.assets; i++) {
            tx.push(i)
        }

        this.pickListID = [...tx];
        this.gtmID = [...tx];
        this.partNumber = [26309588, 26309589, 26309590, 26309591, 26309596, 26309597];
        this.dollieID = [1, 2, 3, 4, 5];
    }
    async submitTransaction() {
        this.txIndex++;

        const assetID = `component_${this.txIndex}_${this.workerIndex}_${this.roundArguments.assets}`;
        const pickListID = this.pickListID[this.txIndex];
        const gtmID = this.gtmID[this.txIndex];
        const dollieIDRandom = Math.floor(Math.random() * (4 - 0 + 1) + 0)
        const dollieID = this.dollieID[dollieIDRandom < 0 ? 0 : dollieIDRandom]
        const partNumberRandom = Math.floor(Math.random() * (5 - 0 + 1) + 0)
        const partNumber = this.partNumber[partNumberRandom < 0 ? 0 : partNumberRandom]
        const dataHoraRecebimento = new Date().toLocaleString()
        const dataHoraSequenciado = ""
        const status = "aguardando"

        const setUser = Math.floor(Math.random() * 1000) % 2 === 0 ? 'User1' : '_SistemistaMSP_User1';

        const request = {
            contractId: this.roundArguments.contractId,
            contractFunction: 'CreateAsset',
            invokerIdentity: setUser,
            contractArguments: [assetID, pickListID, gtmID, dollieID, partNumber, dataHoraRecebimento, dataHoraSequenciado, status],
            readOnly: false
        };
        console.info(`Creating asset: ${assetID}`);
        await this.sutAdapter.sendRequests(request);
    }
}

function createWorkloadModule() {
    return new MyWorkload();
}

module.exports.createWorkloadModule = createWorkloadModule;