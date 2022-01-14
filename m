Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F13C7C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 Jan 2022 03:28:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239030AbiAND2m (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 13 Jan 2022 22:28:42 -0500
Received: from mga03.intel.com ([134.134.136.65]:9694 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239029AbiAND2l (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 13 Jan 2022 22:28:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642130921; x=1673666921;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Uh14cUAuAfyyyqaqgcXm7M5U110xo5XSbMk+nGDdnkM=;
  b=iicnPuJJvhvNLognqa4A4UI7CN6aCgJn68ERWeARZrkw1Phg91YqiEIO
   VGpfivj4zU2MIeWdLVZ4kIWJJmaR470jIsAG8zlG+UMg0kTmpFsH0npDX
   4We0yMaMWLaTrGlPe3MlS1Wm2V3d6CNQ0GsABbIfoTKs6iahNmk62r9zr
   qZWuUZeRa2CpcbTTnKPVWY18hJldyp/BaR2DDL1T5FgWuFXmpDmQ/kqT4
   L3ztXnkrCv9bT6fT2+nS12zdvzzp8VE5uZ9MmhPNZn+b+9k/OWwIY5QwH
   TG2jSrP110eeSIJ4pNy/S0gdU8kKcfOsDbE3U1mkiYxdfEUlDO6WIldPj
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10226"; a="244130381"
X-IronPort-AV: E=Sophos;i="5.88,287,1635231600"; 
   d="scan'208";a="244130381"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2022 19:28:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,287,1635231600"; 
   d="scan'208";a="516204539"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga007.jf.intel.com with ESMTP; 13 Jan 2022 19:28:41 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 13 Jan 2022 19:28:40 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Thu, 13 Jan 2022 19:28:40 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Thu, 13 Jan 2022 19:28:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UFmDMb1Nl28EFNwrESR+s//KiMPXKsGGMyE1OKZWvdBgdWhQNcaSqSOvvdThCRzm2imaiPboarXK2jS4rorjKvVb+Dz1TIqSk/4jxa/6AQpspwyFswK8Osp3fMLMrVPSW1LtOZsftF77a4vEqtdzzgXMZiCvwOlqq0qjNfgNiyqrA3a0MbewnuQ6ISIQq4yC9IMiEu+PrMp7Y5EPoerOGP1TVP1AyMgi8FTjABZ5wz+U5TV7xJYFgsh/6a2FRHBqvAtrp68opeIkuLAv/0WSEEGsUW+Hmrm8Cuowns3QJzbmtwxd95NLdVtntlJa8dX7P43E9ziBSqAebaD9VpWPzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uh14cUAuAfyyyqaqgcXm7M5U110xo5XSbMk+nGDdnkM=;
 b=HtRiDafrdvf/lXrRfMzYnbRjlZ204oQdPbOJDeiFoQXV3Sl+O29WxbuO9vux4nINZn/fCyuQCyovC21l8epk0k7kEhE77d2HQRl0kw4QnTbJElsv2lS9uwomX8/doiLSCLIJjfvyQDtvBXCeWvnMJ7O7R8OKXou/ehi8y4hfaqONw0siRfp9thAGG985/yV3tpKUdlDoFuPJmVnggABVX49fFtRiW2ORJN2ASjqPp+P4KNHi9gS5IYyrksPYR+DkzOFXV5RDqkCP6fCmMXNhi8F90LGUb2LGehhqiuXKMTSmrz2ganTqH+hXR21vFwGn6EV39c8FkDUKrOPvnU/2Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB4285.namprd11.prod.outlook.com (2603:10b6:208:191::32)
 by PH0PR11MB5176.namprd11.prod.outlook.com (2603:10b6:510:3f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Fri, 14 Jan
 2022 03:28:38 +0000
Received: from MN2PR11MB4285.namprd11.prod.outlook.com
 ([fe80::38b5:756e:417:6409]) by MN2PR11MB4285.namprd11.prod.outlook.com
 ([fe80::38b5:756e:417:6409%5]) with mapi id 15.20.4888.011; Fri, 14 Jan 2022
 03:28:37 +0000
From:   "Chen, Hongzhan" <hongzhan.chen@intel.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     "linux-trace-devel@vger.kernel.org>, Kiszka" 
        <linux-trace-devel@vger.kernel.org>,
        "Kiszka, Jan" <jan.kiszka@siemens.com>
Subject: RE: [Questions][trace-cmd/libtraceevent] how to correctly  parse info
 out from specifial format of event?
Thread-Topic: [Questions][trace-cmd/libtraceevent] how to correctly  parse
 info out from specifial format of event?
Thread-Index: AdgIVSD6mVFfD1+OR1i6bZGO+fUq5wAXANkAAA1PiLAAAT2cgAAClL8Q
Date:   Fri, 14 Jan 2022 03:28:37 +0000
Message-ID: <MN2PR11MB4285DF10ED4F820D69303162F2549@MN2PR11MB4285.namprd11.prod.outlook.com>
References: <MN2PR11MB428586156443A851B879867BF2539@MN2PR11MB4285.namprd11.prod.outlook.com>
        <20220113140952.34d0f937@gandalf.local.home>
        <MN2PR11MB428554E66740ACBEE4B29D74F2549@MN2PR11MB4285.namprd11.prod.outlook.com>
 <20220113210631.5b07cf47@gandalf.local.home>
In-Reply-To: <20220113210631.5b07cf47@gandalf.local.home>
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
x-ms-office365-filtering-correlation-id: a65419e6-400c-4f3d-d6ad-08d9d70df404
x-ms-traffictypediagnostic: PH0PR11MB5176:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <PH0PR11MB5176EE89FC9C882EC3E24EDAF2549@PH0PR11MB5176.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2331;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hk4ZUXj7eucFcHW1GZpPRg0TcPNMUZEeW4SNEn3Y1CZXrsTc83Rpar64q7+bX1UYZAplwm527tAHAp/k9D7RKYKMcyGN0IgBEmAW7ovIOjlIWswuAWUYzGlAIGxt5bhCVQRPdFUP6Gac9d8TbWz7ucHboQD6JS2wPKm4/htZ3rExNaPMXn0vqFE1qSTLZ8OP59lyPJGxhhYjbmVGMN30qvIV8JKzkV7/jbHKUcsv2KC3tMPghKOdKuiKOImZLRRnu2Fq+G/YRHxFNSVYJiQG0sxQT6LaSxwGXONOFOXgC41p6ibAnp9P9VdMWuFFCamAphlGQZyFfiNIUf9NbOjquHMcvJKjpYkcgrb7IMDKcJtDQD09rp41fnW6AQOM9ovKS1P6VjPv5Cf1WsjTK0WTwhIloyEHPkzG4HAgiaqCfSqc7C+oJlFYduSEqKgtv3QJ4QeNFdgIkiYjalZXAj785d2G6f1viYKWplpPDOvbEXEdn7LrCEqfEx01mxzIaA+5qDkaslqzO0WjoekZEPyQL5ME3BAgtKjAc1sLU3j1qlbq2qBJo1NPiyP0FcQ7i7/qs7voiwzaQtHzEHjwZ2z7x89jeTDUrsxnvDWmhsW6t0nlrUagBszu3LvcXwnMg2khc9c0ylC5agZljBSwL3Csi4pgHEDnBdffnPZ6BrsxeL6ZX5tYG+19fzPV5qNVRCGyCDSbiW4jEo+1egvUAiNLstDyhn3nzsfQO0LlaXON/pshFz8S984O2mz8NhNbr5SQFLGe4ggoOK1qtaAPct1nUbpe0mzzdblw6PItL4vAfKn8lXdKnewO7qqARK+8+1rG
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4285.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(966005)(86362001)(40140700001)(8676002)(26005)(508600001)(6506007)(316002)(186003)(54906003)(2906002)(52536014)(5660300002)(6916009)(38100700002)(122000001)(33656002)(55016003)(38070700005)(64756008)(66446008)(76116006)(9686003)(71200400001)(66946007)(82960400001)(66476007)(66556008)(7696005)(83380400001)(4326008)(505234007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a0x2cGFoTThIQlgreGdHWmEzSDJqVVFEem5FT0lkTTMrLzVVMXErMkVRK3Rl?=
 =?utf-8?B?bVQvaDZvZmFhL3R2RHdxNi9MMWlWV0hUdzdPU0xvQkJpYzdZUGM2bGFsWmND?=
 =?utf-8?B?MDlzUElCTXlHVnlyVERsUXQ2dWVONnVBS3VxNzVIamNwOTA1THBtQ1d1SUtx?=
 =?utf-8?B?S21IR2haK1phOU9mS0YwNFpsNjBPM09VYzN2b0J0cTlURm4zbmRsaU9QSzVt?=
 =?utf-8?B?RUdzL1BnUTh2RmdwQUFhTGdOQlZwem5kZTRJaE1YZ0dWMWZZMTJWcmxMeGs3?=
 =?utf-8?B?R0FSY2Z4a0paeEw1YmkvWnE4U3ptdzJVT3hWVWNxbVhLa1lpdEpDUS9tdG10?=
 =?utf-8?B?akpUTzdUZVVCTmlPQnorc2VveTFRSXRDc3Nyb3M4UTBUM01HSVpPRVhiSjN6?=
 =?utf-8?B?U0xuS2RZMmx4MEJydWZzRGExaVA3K0ZuakZtUUNNMkpSUUFCbU1DOEViU2ZR?=
 =?utf-8?B?N1VrWVpCL2ZiM3VZYkJkWStKNUJ1YmVpbEVLVkQzSkVKdlkyUGZ3RUNrRnVT?=
 =?utf-8?B?V2tGZ1dUUVpUZHFvSE4xTERGaStoV09pSjFMWDVyY2R6OEwyWlgrOFdiRE1Z?=
 =?utf-8?B?Wm1saTJWTkRFRlFYeGg5cldzaWp4ZEJ5M1k3eTREYlBFMGhuWStYek5mbWxh?=
 =?utf-8?B?T21tNmtzVUxmNVdDM1BSVEZCMEkzNk45a214bUpTanBpWDkzM1FrWXZIaGFX?=
 =?utf-8?B?R1FVdlV2SENKZWdVODBKY1VDUWxsd1NHb2RvNWxNNGJObkxZZktjQlN2REtG?=
 =?utf-8?B?VjB1SitjTm1NODJDZ0wvYm9zcHdpeHd4eWtsZk1WbzlKUGllUGJwTS94cnlI?=
 =?utf-8?B?cStKdm1YT2JpbTdycEtsczBrY0RWWXdRdGRTT2xkZHpqbmRWeGI1OE9KUmR2?=
 =?utf-8?B?TE1rNVk2Ynp0Z1hpeXpXWG9FSGtDTk91YzJzNllvRVdibkFCQUV3TlZybFpZ?=
 =?utf-8?B?dDNFM0JzZXIzdFN6WUgwY0NneXREYWdHVGQ3YkhhTE9JcWlwaE1rck5oU1RI?=
 =?utf-8?B?VjBUWWNidWF4bktPMmUzUFBNZDNyRnNUSUNwZGVZSkc1em9zcGxPd3BLT3Rq?=
 =?utf-8?B?dFEzay9MMkdXVTJ1N0gwcitGdDduM0FEdFZ3Zy80a0JyejBzeWNTSW5WSlY1?=
 =?utf-8?B?eVk4R0I5djNnVWs4SEt0bXFqU0NRRVB0c1J3ZGovOWpYT1cvNCtLS0J2YXNy?=
 =?utf-8?B?cFNDeUxTSFhEd2hwbUdiYS80TmxZdjQyTUVNd0REZUE0aFQxa2MwT0VGK0pJ?=
 =?utf-8?B?V1Ivb1FpZmZQaHdFbmVWWTFFN3JUeFRDN21YVUVGZS92VGZEU0J1OFFXTzdv?=
 =?utf-8?B?Z3c2TWFGUEJNdCtyK2JsdDVCcUlVRXhEckRoTTh5cGhoVSsvNUR4YlI1cTVu?=
 =?utf-8?B?ZXVUNmgzYnVOU0xtWnBVUnVqWlRvcEg0by9mK2pBNzhlOE9aTWMyNFF5NW9K?=
 =?utf-8?B?YmhCRFNiTzVSbmVFK0I2eC9ZS3Fhc3g3dXpCMGV6WFJnNWNQK0plVlVkNUhm?=
 =?utf-8?B?dTBXcVU3czliS0VBRnpPOGpkeVk4cXZ0OFhWSFJzZHZLNDZUeFFiUzdxTUc5?=
 =?utf-8?B?ZnJNR2RGeWxkVjEzQ2pubzcxTm5LRXdCYXFBSWRZN2lEb2ZMRGNSOGJVZmtY?=
 =?utf-8?B?aGNaYTc3dDZVbEkvL2lqRDQyWG9UUXdEamlBOFd4L3FtWnhmdEtBRXQ5ZllX?=
 =?utf-8?B?TzBxL0J6UWZGVjZ0U3gvUHBCSnhSNTE0WkxlUmpYR3lXc05Ba294dTIrZ1FB?=
 =?utf-8?B?RC94TloydUZ2Wk5VZ1J4em81TTlVVWNoZnVVOHQ2NmdBTGFEa2lTR3B0c2U4?=
 =?utf-8?B?bEQ1RW9ySzdhQ2laOERxeWlqOWFzK1A3WUxVMzhHWmNBakhUcjh4ZGIzT1JH?=
 =?utf-8?B?OGF2elVRaHNwd3dXWTdzeWk3am9QclZHNHRnejE0YlJwT2NhcVBSQ0FDNDMr?=
 =?utf-8?B?MGhFbTczTDlleXZ2SHlaTDlYSmZsY3JLbVVTYUZ6RVYwQW03NWVhNUFPT0FK?=
 =?utf-8?B?UDJrUWo1UStQWE5zN3ZuY05GRFJMVFBObjVwZHJ4YTF3RnIwbm1hcmdEMUV5?=
 =?utf-8?B?L2pya052by9wcWFhbU1OZmhtVTkxeFVOajB2aVpKbTdpQ3JuRDlmNXVZbVYz?=
 =?utf-8?B?R1FsaUVLSURXTVVOTzFkOUZpeVJ4STdoRzNjM3FBMVR3d0hBVkR3bFQ3b1pq?=
 =?utf-8?Q?wMMbGcWMVBQ2iAert3VXrPk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB4285.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a65419e6-400c-4f3d-d6ad-08d9d70df404
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2022 03:28:37.7046
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ajUlt5ruc929wqTJpKXHEibsah7hGLWkaoyrtmbz6jhnMCPepyLT2Jrtbk2sdBy35tci0lsiYNmlft6S9ozp6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5176
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

DQoNCj4tLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPkZyb206IFN0ZXZlbiBSb3N0ZWR0IDxy
b3N0ZWR0QGdvb2RtaXMub3JnPiANCj5TZW50OiBGcmlkYXksIEphbnVhcnkgMTQsIDIwMjIgMTA6
MDcgQU0NCj5UbzogQ2hlbiwgSG9uZ3poYW4gPGhvbmd6aGFuLmNoZW5AaW50ZWwuY29tPg0KPkNj
OiBsaW51eC10cmFjZS1kZXZlbEB2Z2VyLmtlcm5lbC5vcmc+LCBLaXN6a2EgPGxpbnV4LXRyYWNl
LWRldmVsQHZnZXIua2VybmVsLm9yZz47IEtpc3prYSwgSmFuIDxqYW4ua2lzemthQHNpZW1lbnMu
Y29tPg0KPlN1YmplY3Q6IFJlOiBbUXVlc3Rpb25zXVt0cmFjZS1jbWQvbGlidHJhY2VldmVudF0g
aG93IHRvIGNvcnJlY3RseSBwYXJzZSBpbmZvIG91dCBmcm9tIHNwZWNpZmlhbCBmb3JtYXQgb2Yg
ZXZlbnQ/DQo+DQo+DQo+T24gRnJpLCAxNCBKYW4gMjAyMiAwMTozNzowOCArMDAwMA0KPiJDaGVu
LCBIb25nemhhbiIgPGhvbmd6aGFuLmNoZW5AaW50ZWwuY29tPiB3cm90ZToNCj4NCj5Gcm9tIHlv
dXIgb3RoZXIgZW1haWw6DQo+DQo+PiByb290QGVjcy14ZW5vbWFpLWlzYXI6fiMgY2F0IC9zeXMv
a2VybmVsL2RlYnVnL3RyYWNpbmcvZXZlbnRzL2NvYmFsdF9wb3NpeC9jb2JhbHRfcHRocmVhZF9j
cmVhdGUvZm9ybWF0DQo+PiBuYW1lOiBjb2JhbHRfcHRocmVhZF9jcmVhdGUNCj4+IElEOiA2MjgN
Cj4+IGZvcm1hdDoNCj4+ICAgICAgICAgZmllbGQ6dW5zaWduZWQgc2hvcnQgY29tbW9uX3R5cGU7
ICAgICAgIG9mZnNldDowOyAgICAgICBzaXplOjI7IHNpZ25lZDowOw0KPj4gICAgICAgICBmaWVs
ZDp1bnNpZ25lZCBjaGFyIGNvbW1vbl9mbGFnczsgICAgICAgb2Zmc2V0OjI7ICAgICAgIHNpemU6
MTsgc2lnbmVkOjA7DQo+PiAgICAgICAgIGZpZWxkOnVuc2lnbmVkIGNoYXIgY29tbW9uX3ByZWVt
cHRfY291bnQ7ICAgICAgIG9mZnNldDozOyAgICAgICBzaXplOjE7IHNpZ25lZDowOw0KPj4gICAg
ICAgICBmaWVsZDppbnQgY29tbW9uX3BpZDsgICBvZmZzZXQ6NDsgICAgICAgc2l6ZTo0OyBzaWdu
ZWQ6MTsNCj4+IA0KPj4gICAgICAgICBmaWVsZDp1bnNpZ25lZCBsb25nIHB0aDsgICAgICAgIG9m
ZnNldDo4OyAgICAgICBzaXplOjg7IHNpZ25lZDowOw0KPj4gICAgICAgICBmaWVsZDppbnQgcG9s
aWN5OyAgICAgICBvZmZzZXQ6MTY7ICAgICAgc2l6ZTo0OyBzaWduZWQ6MTsNCj4+ICAgICAgICAg
ZmllbGQ6X19kYXRhX2xvYyBjaGFyW10gcGFyYW1fZXg7ICAgICAgIG9mZnNldDoyMDsgICAgICBz
aXplOjQ7IHNpZ25lZDoxOw0KPj4gDQo+PiBwcmludCBmbXQ6ICJwdGg9JXAgcG9saWN5PSVzIHBh
cmFtPScgJXMgJyIsICh2b2lkICopUkVDLT5wdGgsIF9fcHJpbnRfc3ltYm9saWMoUkVDLT5wb2xp
Y3ksIA0KPj4gezAsICJub3JtYWwifSwgezEsICJmaWZvIn0sIHsyLCAicnIifSwgezExLCAidHAi
fSwgezEyLCAicXVvdGEifSwgezEwLCAic3BvcmFkaWMifSwgezQyLCAiY29iYWx0In0sIA0KPj4g
ezQzLCAid2VhayJ9KSwgY29iYWx0X3RyYWNlX3BhcnNlX3NjaGVkX3BhcmFtcyhwLCBSRUMtPnBv
bGljeSwgKHN0cnVjdCBzY2hlZF9wYXJhbV9leCAqKShfX2dldF9keW5hbWljX2FycmF5KHBhcmFt
X2V4KSkpDQo+PiANCj4+IFsyXToNCj4+ICBzbW9rZXktNzUyICAgICBbMDAwXSBkLn4yICA3OTcw
LjcyNzQ2NjogY29iYWx0X3B0aHJlYWRfZ2V0c2NoZWRwYXJhbTogcHRoPTAwMDAwMDAwOWJiYzdm
ZTAgcG9saWN5PWZpZm8gcGFyYW09eyBwcmlvcml0eT01MCB9DQo+PiAgc21va2V5LTc2MiAgICAg
WzAwMF0gLi4uLiAgNzk3MC43Mjc0OTI6IGNvYmFsdF9wdGhyZWFkX2NyZWF0ZTogcHRoPTAwMDAw
MDAwOTgzNDY4YTUgcG9saWN5PXF1b3RhIHBhcmFtPXsgcHJpb3JpdHk9MSwgZ3JvdXA9MCB9DQo+
DQo+DQo+DQo+PiBGb2xsb3dpbmcgaXMgdHdvIGR1bXBzLCBwbGVhc2UgY2hlY2s6DQo+PiANCj4+
ICAgICAgICAgICBzbW9rZXktNDQ3ICAgWzAwMF0gICAzMjAuMTkzMTU2OiBjb2JhbHRfcHRocmVh
ZF9jcmVhdGU6IDc0IDAyIDAwIDAwIGJmIDAxIDAwIDAwICA0MCAzNyA0YiBhYSBhYiA3ZiAwMCAw
MCAgMDAgMDAgMDAgMDAgMTggMDAgMzggMDAgIDAwIDAwIDAwIDAwIGZlIDdmIDAwIDAwICA2MCBj
MyAyNCA5MCBmZiBmZiBmZiBmZiAgNWMgODEgMjEgOTAgZmYgZmYgZmYgZmYgIGQ4IGJkIDhjIDgw
IDkwIGMxIGZmIGZmICAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAgMDAgMDAgMDAgMDAgMDAgMDAg
MDAgMDAgIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwDQo+DQo+Y29tbW9uX3R5cGU6CQkweDAyNzQg
PSA2MjggKG1hdGNoZXMgdGhlIElEKQ0KPmNvbW1vbl9mbGFnczoJCTAwDQo+Y29tbW9uX3ByZWVt
cHRfY291bnQ6CTAwDQo+Y29tbW9uX3BpZDoJCTB4MDAwMDAxYmYgOiA0NDcNCj4NCj5wdGg6CQkJ
MHgwMDAwN2ZhYmFhNGIzZjQwICh3aGF0ZXZlciB0aGF0IGlzKQ0KPnBvbGljeToJCQkweDAwMDAw
MDAwDQo+cGFyYW1fZXg6CQkweDAwMTgwMDM4IChvZmZzZXQgPSAweDM4ICg1NikgbGVuPTB4MTgg
KDI0KQ0KDQpUaGFua3MgZm9yIHlvdXIgcXVpY2sgcmVwbHkuIPCfmIoNCg0KT24gbXkgWDg2IHBs
YXRmb3JtICwgaXQgaXMgcHJpbnRlZCBhcyAgMHgzODAwMTgob2Zmc2V0IHNob3VsZCBiZSAweDE4
IGxlbiA9IDB4MzgpLiAgSXQgc2hvdWxkIHBvaW50IHRvIHRoZSBlbmQgb2YgZmllbGQgcGFyYW1f
ZXggKGZpZWxkOl9fZGF0YV9sb2MgY2hhcltdIHBhcmFtX2V4OyAgICAgICBvZmZzZXQ6MjA7ICAg
ICAgc2l6ZTo0OyBzaWduZWQ6MSkgd2hlcmUgc3RvcmUgaXRzIGRhdGEgcGVyIG15IHVuZGVyc3Rh
bmRpbmcuIFBsZWFzZSBjb3JyZWN0IG1lIGlmIEkgYW0gd3JvbmcuDQoNCg0KPg0KPkhtbSwgdGhl
IG9mZnNldCBwb2ludHMgdG8gdGhhdCBzZXQgb2YgemVyb3MgYXQgdGhlIGVuZC4NCj4NCj5Ib3cg
d2FzIHRoaXMgZXZlbnQgY3JlYXRlZD8NCg0KVGhlIGV2ZW50IGRlZmluaXRpb24gcGxlYXNlIHJl
ZmVyIHRvIGh0dHBzOi8vZ2l0bGFiLmNvbS9YZW5vbWFpL3hlbm9tYWktaGFja2VyLXNwYWNlLy0v
YmxvYi9tYXN0ZXIva2VybmVsL2NvYmFsdC90cmFjZS9jb2JhbHQtcG9zaXguaA0KDQpSZWdhcmRz
DQoNCkhvbmd6aGFuIENoZW4NCg0KPg0KPj4gICAgICAgICAgIHNtb2tleS00NDkgICBbMDAwXSAg
IDMyMC4xOTY2MjM6IGNvYmFsdF9wdGhyZWFkX2NyZWF0ZTogNzQgMDIgMDAgMDAgYzEgMDEgMDAg
MDAgIDAwIGU3IDZlIGE5IGFiIDdmIDAwIDAwICAwMSAwMCAwMCAwMCAxOCAwMCAzOCAwMCAgMDEg
MDAgMDAgMDAgMzAgMDAgMDAgMDAgIDIwIDdjIDgyIDc3IGZlIDdmIDAwIDAwICA2MCA3YiA4MiA3
NyBmZSA3ZiAwMCAwMCAgMDAgMmIgODkgMTggNTUgYTYgZmEgYmEgIDQwIDM3IDRiIGFhIGFiIDdm
IDAwIDAwICAzZSAzZCBlMiAwMCA3ZiA1NSAwMCAwMCAgZDAgN2IgODIgNzcgZmUgN2YgMDAgMDAN
Cj4NCj5BbHRob3VnaCB0aGUgYWJvdmUgaGFzIGNvbnRlbnQgZm9yIHRoYXQ6DQo+DQo+ICAgIjQw
IDM3IDRiIGFhIGFiIDdmIDAwIDAwICAzZSAzZCBlMiAwMCA3ZiA1NSAwMCAwMCAgZDAgN2IgODIg
NzcgZmUgN2YgMDAgMDAiDQo+DQo+LS0gU3RldmUNCj4NCj4NCj4NCg==
