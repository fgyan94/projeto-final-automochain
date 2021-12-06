/*
 * Copyright IBM Corp. All Rights Reserved.
 *
 * SPDX-License-Identifier: Apache-2.0
 */

"use strict";

const { Contract } = require("fabric-contract-api");

class JIS extends Contract {
  async InitLedger(ctx) {
    const assets = [
      {
        id: "component1",
        pickListID: 0,
        gtmID: 0,
        dollieID: 0,
        partNumber: 26309588,
        dataHoraRecebimento: "2021-10-08 08:00:23",
        dataHoraSequenciado: "",
        status: "aguardando"
      },
      {
        id: "component2",
        pickListID: 0,
        gtmID: 0,
        dollieID: 0,
        partNumber: 26309589,
        dataHoraRecebimento: "2021-10-08 08:00:23",
        dataHoraSequenciado: "",
        status: "aguardando"
      },
      {
        id: "component3",
        pickListID: 0,
        gtmID: 0,
        dollieID: 0,
        partNumber: 26309596,
        dataHoraRecebimento: "2021-10-08 08:01:30",
        dataHoraSequenciado: "",
        status: "aguardando"
      },
      {
        id: "component4",
        pickListID: 0,
        gtmID: 0,
        dollieID: 0,
        partNumber: 26309597,
        dataHoraRecebimento: "2021-10-08 08:01:30",
        dataHoraSequenciado: "",
        status: "aguardando"
      },
      {
        id: "component5",
        pickListID: 0,
        gtmID: 0,
        dollieID: 0,
        partNumber: 26309590,
        dataHoraRecebimento: "2021-10-08 08:02:27",
        dataHoraSequenciado: "",
        status: "aguardando"
      },
      {
        id: "component6",
        pickListID: 0,
        gtmID: 0,
        dollieID: 0,
        partNumber: 26309591,
        dataHoraRecebimento: "2021-10-08 08:02:27",
        dataHoraSequenciado: "",
        status: "aguardando"
      },
    ];

    for (const asset of assets) {
      asset.docType = "asset";
      await ctx.stub.putState(asset.id, Buffer.from(JSON.stringify(asset)));
      console.info(`Asset ${asset.id} initialized`);
    }
  }

  // CreateAsset issues a new asset to the world state with given details.
  async CreateAsset(ctx, id, pickListID, gtmID, dollieID, partNumber, dataHoraRecebimento, dataHoraSequenciado, status) {
    const asset = {
      id: id,
      pickListID: pickListID,
      gtmID: gtmID,
      dollieID: dollieID,
      partNumber: partNumber,
      dataHoraRecebimento: dataHoraRecebimento,
      dataHoraSequenciado: dataHoraSequenciado,
      status: status
    };
    await ctx.stub.putState(id, Buffer.from(JSON.stringify(asset)));
    return JSON.stringify(asset);
  }

  // ReadAsset returns the asset stored in the world state with given id.
  async ReadAsset(ctx, id) {
    const assetJSON = await ctx.stub.getState(id); // get the asset from chaincode state
    if (!assetJSON || assetJSON.length === 0) {
      throw new Error(`The asset ${id} does not exist`);
    }
    return assetJSON.toString();
  }

  async SetAssetInProduction(ctx, id) {
    const exists = await this.AssetExists(ctx, id);
    if (!exists) {
      throw new Error(`The asset ${id} does not exist`);
    }

    const asset = await this.GetAssetById(ctx, id)
    if(asset.status === "em produção") {
      throw new Error(`O componente já está em produção. Componente ID: ${id}`)
    } else if (asset.status === "sequenciado") {
      throw new Error(`Componente já sequenciado. Componente ID: ${id}`)
    }

    const updatedAsset = {
      id: id,
      pickListID: asset.pickListID,
      gtmID: asset.gtmID,
      dollieID: asset.dollieID,
      partNumber: asset.partNumber,
      dataHoraRecebimento: asset.dataHoraRecebimento,
      dataHoraSequenciado: asset.dataHoraSequenciado,
      status: "em produção"
    };

    return await ctx.stub.putState(id, Buffer.from(JSON.stringify(updatedAsset)));
  }

  async SetAssetAsSequenced(ctx, id) {
    const exists = await this.AssetExists(ctx, id);
    if (!exists) {
      throw new Error(`O componente informado não existe. Componente ID: ${id}`);
    }

    const asset = await this.GetAssetById(ctx, id)
    if(asset.status === "em produção") {
      throw new Error(`O componente deve estar em produção para ser sequenciado. Componente ID: ${id}`)
    } else if (asset.status === "sequenciado") {
      throw new Error(`Componente já sequenciado. Componente ID: ${id}`)
    }

    // overwriting original asset with new asset
    const updatedAsset = {
      id: id,
      pickListID: asset.pickListID,
      gtmID: asset.gtmID,
      dollieID: asset.dollieID,
      partNumber: asset.partNumber,
      dataHoraRecebimento: asset.dataHoraRecebimento,
      dataHoraSequenciado: new Date().toLocaleString(),
      status: "sequenciado"
    };
    
    return await ctx.stub.putState(id, Buffer.from(JSON.stringify(updatedAsset)));
  }

  // AssetExists returns true when asset with given id exists in world state.
  async AssetExists(ctx, id) {
    const assetJSON = await ctx.stub.getState(id);
    return assetJSON && assetJSON.length > 0;
  }

  // GetAllAssets returns all assets found in the world state.
  async GetAllAssets(ctx) {
    const allResults = [];
    // range query with empty string for startKey and endKey does an open-ended query of all assets in the chaincode namespace.
    const iterator = await ctx.stub.getStateByRange("", "");
    let result = await iterator.next();
    while (!result.done) {
      const strValue = Buffer.from(result.value.value.toString()).toString(
        "utf8"
      );
      let record;
      try {
        record = JSON.parse(strValue);
      } catch (err) {
        console.log(err);
        record = strValue;
      }
      allResults.push({ Key: result.value.key, Record: record });
      result = await iterator.next();
    }
    return JSON.stringify(allResults);
  }

  async GetAllAssetsParsed(ctx) {
    const parsed = await this.GetAllAssets(ctx).then((data) => JSON.parse(data))

    return parsed
  }

  async GetAssetById(ctx, id) {
    const getAllAssets = await this.GetAllAssetsParsed(ctx)
    const assetsMapped = getAllAssets.map((asset) => ({ id: asset.Key, ...asset.Record }))
    const asset = assetsMapped.find((asset) => asset.id === id)

    return asset
  }
}



module.exports = JIS;
