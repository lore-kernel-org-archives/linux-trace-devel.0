Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7EBDC433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Feb 2022 01:19:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbiBNBTv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 13 Feb 2022 20:19:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbiBNBTv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 13 Feb 2022 20:19:51 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACE46527E8
        for <linux-trace-devel@vger.kernel.org>; Sun, 13 Feb 2022 17:19:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644801584; x=1676337584;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=FPur5qyW4kmaIjwwEDVCXpxkOk6wXnZ+1fMZ+sbIpEY=;
  b=hKYUrlZtB00k7Wysnqw7FwoCTPxCJOGCiTPsg9OxMJNezEWIijKeu9sS
   1hYpthx2R+hColNcfN22Y/rthVGZzDllQO4wN0M68DrPijHHCaTUAJ+0q
   /VBnBj4bzCfUUJdGMio6W4IUzqWMCfPMnqU5VCkMr2eUqjRRe1Kr57LHu
   QUNQ1Rf4lNZTPwgFiEmnMbsT5OXPfiksAcyPR+8sAq+aHoJPkhSr9Fglf
   5YgMo9jAu73FbwtXi8Thpb2bm/VkwAkhCashpu0vfUIUnIYDmhEEPcwlb
   /U1ToSvEyIgoiRY3Z100zh1JwQK5fq+jeZHNKyd3pDgz1kDnUH0dJ7Odd
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10257"; a="248820526"
X-IronPort-AV: E=Sophos;i="5.88,366,1635231600"; 
   d="scan'208";a="248820526"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 17:19:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,366,1635231600"; 
   d="scan'208";a="501474548"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP; 13 Feb 2022 17:19:44 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sun, 13 Feb 2022 17:19:43 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sun, 13 Feb 2022 17:19:43 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Sun, 13 Feb 2022 17:19:43 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Sun, 13 Feb 2022 17:19:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HIDv+WTJ5FdZQusxhFQH8msbNr/SkFoPNPtXhaFTd7Z23OXHqd7FW/OsPHOsuXq+PIJAfUOw3T2wnNRtenijsURCsZC0tpSmgD9P5rOWL1rvdgsCJmml94e6kCY27FASfjDAhM2bBN3fZTgk8TU8ddFQtOK5lkO+VKfETVIc5x7Oi4mjloGTC9ppBRuSiEA6NVQEasJM/x5jTpS2FuxnWojtkyyu0KdK/d08bHRQIC0WG7euhqwVdG5kYg5KxmxQ/Wb+R8cQUHyOxI19kd2AE6BVvZMnOrHQzZiHXFuB9g7UEjRiIInH6w1CtUXUO2KymF/7r9gljkIlwOYuZO0xTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FPur5qyW4kmaIjwwEDVCXpxkOk6wXnZ+1fMZ+sbIpEY=;
 b=Y8igaSz12yCw7clcZ+s8KSbiiMW6yAMj3fEwZWqxhvfE1mLwZrzznqmxWpgGSK1OOWJpAS8iyZPqlUJaZMqDTW8j4PU332at2x13ITwunO5E4Lvmi6Ht7OiDJFDxOAvYaFszMu0otK+pb35c/dDy4bDqLANeYVCb2w6i1Mjhi9L4JItTQcxoV7l4at5d3WtHsoFiRlazSaflxvqVhXTbpUYeLtwCBnm9nO3OyO9r7rIkms/dqX3tJSY1MTRdubR67OvwtEhs/5UbrvkAJ1tcuw2NndTid7y5IdK0QllHpbXndV86XEm0ndlIDc2tbqbhY+sHURejdLSNFuiJgVMQhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from MN2PR11MB4285.namprd11.prod.outlook.com (2603:10b6:208:191::32)
 by BL0PR11MB2914.namprd11.prod.outlook.com (2603:10b6:208:77::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Mon, 14 Feb
 2022 01:19:41 +0000
Received: from MN2PR11MB4285.namprd11.prod.outlook.com
 ([fe80::38b5:756e:417:6409]) by MN2PR11MB4285.namprd11.prod.outlook.com
 ([fe80::38b5:756e:417:6409%5]) with mapi id 15.20.4951.019; Mon, 14 Feb 2022
 01:19:41 +0000
From:   "Chen, Hongzhan" <hongzhan.chen@intel.com>
To:     Yordan Karadzhov <y.karadz@gmail.com>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>,
        "Kiszka, Jan" <jan.kiszka@siemens.com>
Subject: RE: [RFC PATCH 0/2] Allow GUI plugins to build standalone
Thread-Topic: [RFC PATCH 0/2] Allow GUI plugins to build standalone
Thread-Index: AQHYDSyOuCzFNfwE1EGKD9t8AhVaFqxqQKiAgCOZvHCAAJGGAIAD+QMw
Date:   Mon, 14 Feb 2022 01:19:41 +0000
Message-ID: <MN2PR11MB4285A932A043CE389BD7EABCF2339@MN2PR11MB4285.namprd11.prod.outlook.com>
References: <20220119120229.68627-1-y.karadz@gmail.com>
 <27543723-5970-a968-30ab-e30e5731e53a@gmail.com>
 <MN2PR11MB4285CF1156C93679DFDAA5F7F2309@MN2PR11MB4285.namprd11.prod.outlook.com>
 <5c472cb1-c599-dafd-eee5-26a0fca53b3a@gmail.com>
In-Reply-To: <5c472cb1-c599-dafd-eee5-26a0fca53b3a@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0af185e7-70b2-4c27-5073-08d9ef5813a1
x-ms-traffictypediagnostic: BL0PR11MB2914:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BL0PR11MB2914C7CF03022A9298E2ECBDF2339@BL0PR11MB2914.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /7apsShq53UfNnItIrgO1OOr7HP69MroLJmO8Vo64RejUid0nXZl191tIXpXMcVk/JzFoYFJ0GwkgHWG9MSGiHcBXmvSoRWxc5U1SPJ7BYtyY1kSuDUHAf0c0Wp6ZvrkRLYDLjpFzSdJdtZKsWpJQJBYxKU+IzqIz9NJgONDCQ2vwXb431uStEj+qHrdsUsuheSYy536gSY648oPZ/hbmIPpmK/by6frZbzaV0B+uRtclGIV4m/inJyCmq+VbSSjpgoFUjSDlYf6dr2t9QGSho1vCqfZnRZVE8As00YOeLkqFtLNOTkuzCiFOlGIajzMmgHZb4NaQvmjnsqD7Cu4sHAkIw943qKcvd7nldcxm6laIT+EsggZUvN5tYxvvgx7eN0VuBXOjckfCguxH3VpeBx4EDsxHA25vblcVVy1qjxjfaMmxFahQvBOPcpy3hH2231LlLbhow/CoWwtTkh2Ve/kTy2eC+r7x4ZyQqOaIBkDCAqzSt9dwkxaBQ3XmONml4gdq5m++lTGAcRa5er591kwMDMNwQEaylqVyPYj4TRA2/tn/wy6EeQ+aVfwgnK2pyvKm/CRAtjm1coy+jsa6qXeAwJdiWisTIKIixyakmB+oZZLqWLBMSe2sxFoSut7jDrhymhKIbAwD2U6NG4U4Sr9b2FvF6Lgw4OrRrUX746gJppLzGphk58ihuYkbrYdTmDO0M/0g3kY1aFRm8nL5g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4285.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(76116006)(38070700005)(66946007)(66476007)(64756008)(8676002)(8936002)(7696005)(66446008)(19627235002)(9686003)(66556008)(33656002)(316002)(110136005)(82960400001)(508600001)(86362001)(71200400001)(26005)(186003)(5660300002)(38100700002)(2906002)(83380400001)(55016003)(122000001)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aHE0aXdDTEw3TjR3L3VwZzNFdVRHS0F4eHhYY2JKWHlCb3RVdGJmVWFOaFpB?=
 =?utf-8?B?bW1SSnE3cW5TT1o1WnZzeFRFcW95NlJqV3d2MHgxVTVJbStyS203UTdrMlF5?=
 =?utf-8?B?VmI4Qy9DaDVJNlpiSGFVQmxnL0tNTkxsZzBKNGMrVXJ1QTFzZnNkUFM5czNo?=
 =?utf-8?B?bzVrVDMvRmtwWUZOWEwrU2MyRlJPUWhKczdwNTdXelNqd0NDdDl0cndiSU53?=
 =?utf-8?B?NUh2NWRRVVNMVTZtRWx4YmtPdzFtb0dFSXZ6OGpVbWdjYUVLTDZYcHNUQjlG?=
 =?utf-8?B?emp2eEVsSHRPZ3RoYUt4UDMzU25KUEorZGFEelVvTXhEN2Q3NlRIWnYwWHdB?=
 =?utf-8?B?My9wSVByaVdtZnBjUmhXK25WYVU4QVRtbjlCZWRzZ09ObEE0YzNuZ3FDUnBv?=
 =?utf-8?B?dDh3YUNUSjFvazRCUG1sUG5LMCsvWUNEWk1oNVBQdG1JU3NtcUxUN04vMzJr?=
 =?utf-8?B?MmswK0ZDc0l6UmRqY1REQ2FmY1ZPaVFKcWU4cG5Tam92VXBJSDM3ZEdMdlEx?=
 =?utf-8?B?cjZ2VTVtM3V2ajRRMFVYRlhmVjVrallCRFR1c2VFSi8zSGMzdzdPSFlCLzBv?=
 =?utf-8?B?L2xaNHhmRmRyU215aDJ1Tno4K0h5MkNYbkFIZWRGcW1OcDJDZjROZFo5cjVR?=
 =?utf-8?B?Z2g0WHJmVkdUWm5yN0FVa2lReFBwOWpLYnEwVGlVM3BKbHlaZ090T092ZVNY?=
 =?utf-8?B?bnVlNElWWWdEOHhqMloybWVSSFlETEM1S3ROOTN1cjZUZ2RWS2x6RnBVdVBT?=
 =?utf-8?B?TlVMbkUzaEhwS3VMZ2lpd2pxSXJrako0N2U1ZUp3RnFyaVdjQ1ZKY21xekNF?=
 =?utf-8?B?VDZMc3JGaEphT0Z3ODFMMFZOcndmV3kyL2c4UHBpMkh3Z1ZyZzQvdFQzN0g4?=
 =?utf-8?B?dVB0V3JrMzBEN2tYTDVueVBSL05Sb1ViTHZ5d1l3NXFyK3dNRWdFK2t2ZUMy?=
 =?utf-8?B?VlB3L2o5NFNYRlJCQmFjS09lTmh1TjI1Ym03QnhXV2ZrQlZkYjVHOXRubnlF?=
 =?utf-8?B?VlZhTHFRU0hhMHRiUG45WEwycU82R0ZWaEdYWktsQll6TUMySk41RUtmd0ov?=
 =?utf-8?B?UFZvQ0RwSWpZajAwOVZjTTVhME5YdEZHLzRTYTMwUE5WZG1zYllvQUFJNDVZ?=
 =?utf-8?B?aGpkb1FobkJPeFN3RVVhZStkclBxTzZtUmxKWVFXckt1WFI2cDdHb3Y1Qjcz?=
 =?utf-8?B?dm9hdmsvYlNaVTY2RlVHUVpYZkxMMjJZbVZxWUUrZVJ0TndGalVGbW9LRUtL?=
 =?utf-8?B?elROOWhQRWRHTkVQTy95NTFzNG1BMVNWaDI3N0NpVHJRbGNJN3M0aEtmN1Fp?=
 =?utf-8?B?TUFwOEZteXcyaGxwS29LLzVHSzFFajBCeXFyMThpVnRwT0xFWlB4RXNGQnQr?=
 =?utf-8?B?VEM2eXVpZWxOQ2czTldSbjV0RlN5VFVFUWNoYUc0bVBuTWhBTU9LR2ZvRzF2?=
 =?utf-8?B?Qm56OTEzdVhEdDgzSzdLNTZoRmFlODB6c0ZQMEtaaGpHdmpjNE1FRnd0cDB5?=
 =?utf-8?B?M0tycmhRRW9uNG9QamVsMnNySHVleXM3T2Rkd2tOUC9xeWt1Kzk3QXlKUEtF?=
 =?utf-8?B?bXVndTZ5akRmMDlKTHZhZUdaTDN3amE2WjA5d0FJZ2VPZThxczJHcnpTUEFY?=
 =?utf-8?B?bXdqUGZhUnhaS01DelZINEQ0NHV0MGtDWVVXbnQzLytGaXkzZEN6OUw2ZXEx?=
 =?utf-8?B?NDFjbTB5bFFZbWJGelowWndmN1IwL2dURHhsTU1XT3grRVFuenRXUGRSbXJI?=
 =?utf-8?B?c3d0YXhEbVNQWlg3TTZxRG1zOEtNVkM2ZytvaGc5TEQ5QzAySmhkUkpkcGxl?=
 =?utf-8?B?cDVhTDlvQzh2WGNnKzAwZ3RpMVZJWktYbm1wbHlJZkZWYlRJK1JzbXQ0K0p0?=
 =?utf-8?B?dVc4eTdsUnFoQ3FnYkZ4RTkvUWlpcDVhS3NPN08zVkxxeHV3bVh3NjA5VmJr?=
 =?utf-8?B?N1ZIcW1oRUo2dG01dktScnVQcXNmeC8yQUJvd0I2cDJid0ROV1k4cHZ1UnF2?=
 =?utf-8?B?bThXU3IrczlScjAva1BldG1jSldkVEptWUtoRTd2OURUc3Y4Q2xxZmFRTmQv?=
 =?utf-8?B?Mi8wL2ZYTk9LVU5TL293ZzVyZXA1cEI2UVVNNThJenVHbk1ISXlxVjE3SDQx?=
 =?utf-8?B?U1A4N0RsazlnZFM5WWdCMjdsdDF0MkFpV3BRN0YyNjlMSVFHS3BiR1J3bWY5?=
 =?utf-8?Q?wOdjSjBuDov8luhqEyCz92M=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB4285.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0af185e7-70b2-4c27-5073-08d9ef5813a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2022 01:19:41.4354
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zqVih08tXelOPT4O0v7fPAgUVTHfiwgmlh52NH4FjH3Txlv4/mo/o/Z4kEjKWIlNDbcYwCTEL3+lQC3PdnsQ6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB2914
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Pg0KPg0KPi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+RnJvbTogWW9yZGFuIEthcmFkemhv
diA8eS5rYXJhZHpAZ21haWwuY29tPiANCj5TZW50OiBGcmlkYXksIEZlYnJ1YXJ5IDExLCAyMDIy
IDg6MzAgUE0NCj5UbzogQ2hlbiwgSG9uZ3poYW4gPGhvbmd6aGFuLmNoZW5AaW50ZWwuY29tPjsg
bGludXgtdHJhY2UtZGV2ZWxAdmdlci5rZXJuZWwub3JnOyBLaXN6a2EsIEphbiA8amFuLmtpc3pr
YUBzaWVtZW5zLmNvbT4NCj5TdWJqZWN0OiBSZTogW1JGQyBQQVRDSCAwLzJdIEFsbG93IEdVSSBw
bHVnaW5zIHRvIGJ1aWxkIHN0YW5kYWxvbmUNCj4NCj4NCj4NCj5PbiAxMS4wMi4yMiA/LiA3OjAz
ID8uLCBDaGVuLCBIb25nemhhbiB3cm90ZToNCj4+IEJ1dCB3aGVuIEkgZG91YmxlIGNsaWNrIHRo
ZSBib3ggLCBrZXJuZWwtc2hhcmsgcXVpdCBhYm5vcm1hbGx5IHdpdGggc2VnbWVudGF0aW9uIGZh
dWx0Lg0KPj4gDQo+PiBGb2xsb3dpbmcgaXMgYmFja3RyYWNlIGluZm86DQo+PiANCj4+IFtUaHJl
YWQgMHg3ZmZmYzA4NGQ3MDAgKExXUCAyMDY0KSBleGl0ZWRdDQo+PiANCj4+IFRocmVhZCAxICJr
ZXJuZWxzaGFyayIgcmVjZWl2ZWQgc2lnbmFsIFNJR1NFR1YsIFNlZ21lbnRhdGlvbiBmYXVsdC4N
Cj4+IEtzTWFpbldpbmRvdzo6bWFya0VudHJ5ICh0aGlzPTB4MCwgZT0weDdmZmZhZGY5MGY2MCwg
c3Q9RHVhbE1hcmtlclN0YXRlOjpCKSBhdCAvaG9tZS9pbnRlbC9pb3RnL2RvdmV0YWlsL2tlcm5l
bHNoYXJrL2tlcm5lbC1zaGFyay9zcmMvS3NVdGlscy5ocHA6MjI5DQo+PiAyMjkgICAgICAgICAg
ICAgc3NpemVfdCBzaXplKCkgY29uc3Qge3JldHVybiBfZGF0YVNpemU7fQ0KPj4gKGdkYikgYmFj
a3RyYWNlDQo+PiAjMCAgMHgwMDAwN2ZmZmY3YjkxNDQyIGluIEtzTWFpbldpbmRvdzo6bWFya0Vu
dHJ5KGtzaGFya19lbnRyeSBjb25zdCosIER1YWxNYXJrZXJTdGF0ZSkgKHRoaXM9MHgwLCBlPTB4
N2ZmZmFkZjkwZjYwLCBzdD1EdWFsTWFya2VyU3RhdGU6OkIpDQo+PiAgICAgIGF0IC9ob21lL2lu
dGVsL2lvdGcvZG92ZXRhaWwva2VybmVsc2hhcmsva2VybmVsLXNoYXJrL3NyYy9Lc1V0aWxzLmhw
cDoyMjkNCj4+ICMxICAweDAwMDA3ZmZmYzA4NzYzMjkgaW4gWGVub21haVN3aXRjaEJveDo6X2Rv
dWJsZUNsaWNrKCkgY29uc3QgKHRoaXM9MHgxYzdlYmMwKSBhdCBDb2JhbHRTd2l0Y2hFdmVudHMu
Y3BwOjQzDQo+PiAjMiAgMHgwMDAwN2ZmZmY1YTI1OTRmIGluIFFXaWRnZXQ6OmV2ZW50KFFFdmVu
dCopICgpIGF0IC91c3IvbGliL3g4Nl82NC1saW51eC1nbnUvbGliUXQ1V2lkZ2V0cy5zby41DQo+
PiAjMyAgMHgwMDAwN2ZmZmY1OWU2ODNjIGluIFFBcHBsaWNhdGlvblByaXZhdGU6Om5vdGlmeV9o
ZWxwZXIoUU9iamVjdCosIFFFdmVudCopICgpIGF0IC91c3IvbGliL3g4Nl82NC1saW51eC1nbnUv
bGliUXQ1V2lkZ2V0cy5zby41DQo+PiAjNCAgMHgwMDAwN2ZmZmY1OWVlNjVmIGluIFFBcHBsaWNh
dGlvbjo6bm90aWZ5KFFPYmplY3QqLCBRRXZlbnQqKSAoKSBhdCAvdXNyL2xpYi94ODZfNjQtbGlu
dXgtZ251L2xpYlF0NVdpZGdldHMuc28uNQ0KPj4gIzUgIDB4MDAwMDdmZmZmNDhkYzhhOCBpbiBR
Q29yZUFwcGxpY2F0aW9uOjpub3RpZnlJbnRlcm5hbDIoUU9iamVjdCosIFFFdmVudCopICgpIGF0
IC91c3IvbGliL3g4Nl82NC1saW51eC1nbnUvbGliUXQ1Q29yZS5zby41DQo+PiAjNiAgMHgwMDAw
N2ZmZmY1OWVkNjMyIGluIFFBcHBsaWNhdGlvblByaXZhdGU6OnNlbmRNb3VzZUV2ZW50KFFXaWRn
ZXQqLCBRTW91c2VFdmVudCosIFFXaWRnZXQqLCBRV2lkZ2V0KiwgUVdpZGdldCoqLCBRUG9pbnRl
cjxRV2lkZ2V0PiYsIGJvb2wpICgpDQo+PiAgICAgIGF0IC91c3IvbGliL3g4Nl82NC1saW51eC1n
bnUvbGliUXQ1V2lkZ2V0cy5zby41DQo+PiAjNyAgMHgwMDAwN2ZmZmY1YTQwMTViIGluICAoKSBh
dCAvdXNyL2xpYi94ODZfNjQtbGludXgtZ251L2xpYlF0NVdpZGdldHMuc28uNQ0KPj4gIzggIDB4
MDAwMDdmZmZmNWE0MjdjYSBpbiAgKCkgYXQgL3Vzci9saWIveDg2XzY0LWxpbnV4LWdudS9saWJR
dDVXaWRnZXRzLnNvLjUNCj4+ICM5ICAweDAwMDA3ZmZmZjU5ZTY4M2MgaW4gUUFwcGxpY2F0aW9u
UHJpdmF0ZTo6bm90aWZ5X2hlbHBlcihRT2JqZWN0KiwgUUV2ZW50KikgKCkgYXQgL3Vzci9saWIv
eDg2XzY0LWxpbnV4LWdudS9saWJRdDVXaWRnZXRzLnNvLjUNCj4+ICMxMCAweDAwMDA3ZmZmZjU5
ZWUxMDQgaW4gUUFwcGxpY2F0aW9uOjpub3RpZnkoUU9iamVjdCosIFFFdmVudCopICgpIGF0IC91
c3IvbGliL3g4Nl82NC1saW51eC1nbnUvbGliUXQ1V2lkZ2V0cy5zby41DQo+PiAjMTEgMHgwMDAw
N2ZmZmY0OGRjOGE4IGluIFFDb3JlQXBwbGljYXRpb246Om5vdGlmeUludGVybmFsMihRT2JqZWN0
KiwgUUV2ZW50KikgKCkgYXQgL3Vzci9saWIveDg2XzY0LWxpbnV4LWdudS9saWJRdDVDb3JlLnNv
LjUNCj4+ICMxMiAweDAwMDA3ZmZmZjUyMmE3ODAgaW4gUUd1aUFwcGxpY2F0aW9uUHJpdmF0ZTo6
cHJvY2Vzc01vdXNlRXZlbnQoUVdpbmRvd1N5c3RlbUludGVyZmFjZVByaXZhdGU6Ok1vdXNlRXZl
bnQqKSAoKSBhdCAvdXNyL2xpYi94ODZfNjQtbGludXgtZ251L2xpYlF0NUd1aS5zby41DQo+PiAj
MTMgMHgwMDAwN2ZmZmY1MjJjMGI1IGluIFFHdWlBcHBsaWNhdGlvblByaXZhdGU6OnByb2Nlc3NX
aW5kb3dTeXN0ZW1FdmVudChRV2luZG93U3lzdGVtSW50ZXJmYWNlUHJpdmF0ZTo6V2luZG93U3lz
dGVtRXZlbnQqKSAoKSBhdCAvdXNyL2xpYi94ODZfNjQtbGludXgtZ251L2xpYlF0NUd1aS5zby41
DQo+PiAjMTQgMHgwMDAwN2ZmZmY1MjAzMzNiIGluIFFXaW5kb3dTeXN0ZW1JbnRlcmZhY2U6OnNl
bmRXaW5kb3dTeXN0ZW1FdmVudHMoUUZsYWdzPFFFdmVudExvb3A6OlByb2Nlc3NFdmVudHNGbGFn
PikgKCkgYXQgL3Vzci9saWIveDg2XzY0LWxpbnV4LWdudS9saWJRdDVHdWkuc28uNQ0KPj4gIzE1
IDB4MDAwMDdmZmZlZDhhZTI2MCBpbiAgKCkgYXQgL3Vzci9saWIveDg2XzY0LWxpbnV4LWdudS9s
aWJRdDVYY2JRcGEuc28uNQ0KPj4gIzE2IDB4MDAwMDdmZmZmMTNiNzUzNyBpbiBnX21haW5fY29u
dGV4dF9kaXNwYXRjaCAoKSBhdCAvdXNyL2xpYi94ODZfNjQtbGludXgtZ251L2xpYmdsaWItMi4w
LnNvLjANCj4+ICMxNyAweDAwMDA3ZmZmZjEzYjc3NzAgaW4gICgpIGF0IC91c3IvbGliL3g4Nl82
NC1saW51eC1nbnUvbGliZ2xpYi0yLjAuc28uMA0KPj4gIzE4IDB4MDAwMDdmZmZmMTNiNzdmYyBp
biBnX21haW5fY29udGV4dF9pdGVyYXRpb24gKCkgYXQgL3Vzci9saWIveDg2XzY0LWxpbnV4LWdu
dS9saWJnbGliLTIuMC5zby4wDQo+PiAjMTkgMHgwMDAwN2ZmZmY0OTM1ODVmIGluIFFFdmVudERp
c3BhdGNoZXJHbGliOjpwcm9jZXNzRXZlbnRzKFFGbGFnczxRRXZlbnRMb29wOjpQcm9jZXNzRXZl
bnRzRmxhZz4pICgpIGF0IC91c3IvbGliL3g4Nl82NC1saW51eC1nbnUvbGliUXQ1Q29yZS5zby41
DQo+PiAjMjAgMHgwMDAwN2ZmZmY0OGRhOGRhIGluIFFFdmVudExvb3A6OmV4ZWMoUUZsYWdzPFFF
dmVudExvb3A6OlByb2Nlc3NFdmVudHNGbGFnPikgKCkgYXQgL3Vzci9saWIveDg2XzY0LWxpbnV4
LWdudS9saWJRdDVDb3JlLnNvLjUNCj4+ICMyMSAweDAwMDA3ZmZmZjQ4ZTM5ODQgaW4gUUNvcmVB
cHBsaWNhdGlvbjo6ZXhlYygpICgpIGF0IC91c3IvbGliL3g4Nl82NC1saW51eC1nbnUvbGliUXQ1
Q29yZS5zby41DQo+PiAjMjIgMHgwMDAwMDAwMDAwNDAyYWY1IGluIG1haW4gKGFyZ2M9PG9wdGlt
aXplZCBvdXQ+LCBhcmd2PTxvcHRpbWl6ZWQgb3V0PikgYXQgL2hvbWUvaW50ZWwvaW90Zy9kb3Zl
dGFpbC9rZXJuZWxzaGFyay9rZXJuZWwtc2hhcmsvc3JjL2tlcm5lbHNoYXJrLmNwcDoxNTQNCj4+
ICMyMyAweDAwMDA3ZmZmZjM2OWFiZjcgaW4gX19saWJjX3N0YXJ0X21haW4gKG1haW49DQo+PiAg
ICAgIDB4NDAyNDgwIDxtYWluPiwgYXJnYz0xLCBhcmd2PTB4N2ZmZmZmZmZkZDE4LCBpbml0PTxv
cHRpbWl6ZWQgb3V0PiwgZmluaT08b3B0aW1pemVkIG91dD4sIHJ0bGRfZmluaT08b3B0aW1pemVk
IG91dD4sIHN0YWNrX2VuZD0weDdmZmZmZmZmZGQwOCkgYXQgLi4vY3N1L2xpYmMtc3RhcnQuYzoz
MTANCj4+ICMyNCAweDAwMDAwMDAwMDA0MDJjZmEgaW4gX3N0YXJ0ICgpIGF0IC9ob21lL2ludGVs
L2lvdGcvZG92ZXRhaWwva2VybmVsc2hhcmsva2VybmVsLXNoYXJrL3NyYy9rZXJuZWxzaGFyay5j
cHA6MTI5DQo+PiAoZ2RiKQ0KPj4gDQo+DQo+SGkgSG9uZ3poYW4sDQo+DQo+SSBoYXZlIGFuIGlk
ZWEgd2hhdCBjYW4gYmUgdGhlIHByb2JsZW0gaGVyZS4NCj5QbGVhc2UgdHJ5IGFwcGx5aW5nIHRo
ZSBhdHRhY2hlZCBwYXRjaCBhbmQgbGV0IG1lIGtub3cgaWYgdGhlIGRvdWJsZSBjbGljayB3b3Jr
cy4NCg0KVGhlIGRvdWJsZSBjbGljayB3b3JrcyBhZnRlciBwYXRjaGluZy4gIEFwcHJlY2lhdGUg
eW91ciBoZWxwLiAgV291bGQgeW91IG1lcmdlIGFsbCB0aGUgcGF0Y2hlcyBpbmNsdWRpbmcgdGhl
IGxhc3QgcGF0Y2hzZXQgDQoiQWxsb3cgR1VJIHBsdWdpbnMgdG8gYnVpbGQgc3RhbmRhbG9uZSIg
dGhhdCB5b3UgYWxyZWFkeSBtZXJnZWQgaXQgcGFydGlhbGx5Pw0KDQpSZWdhcmRzDQoNCkhvbmd6
aGFuIENoZW4NCg0KPg0KPlRoYW5rcyENCj5Zb3JkYW4NCj4NCj4NCj4+IFJlZ2FyZHMNCj4+IA0K
Pj4gSG9uZ3poYW4gQ2hlbg0K
