Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EB56C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 Jan 2022 04:47:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbiAJErr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 9 Jan 2022 23:47:47 -0500
Received: from mga04.intel.com ([192.55.52.120]:14767 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229841AbiAJErr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 9 Jan 2022 23:47:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641790067; x=1673326067;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=O9xYx0AVm1X4xHCK1ZHNbMongvbWyP1u97qnt7devfI=;
  b=JrNTwjQO06NJeIQSNt5G/v4+A8hJw5uQpZ+AiUEPsdrlMy/+d20T63aJ
   qUMStfzmfEVytsPMdQ45VebzsJHZf5dAVcV1tIRP0zpeebFLVCa9ZZU1F
   fEij5g3hckz+gWNc3qzJHMPdJiPTXkci+ASzXdQ9tnK7m7aMj1AGI8LFe
   JW0AICslFFEgfYxMEiFqGUJKJQOVJZqhlGTPLyjWJs/EVkxOcp8zEI6Bm
   A+bJ4tr8/A11mFj1nfuOSPgw/nmzarWyHUOx/mQCnszJWiAU8i9AG8BrL
   NKoszZODlbTf5zkbm1ypj4kiBwppVHa2SHAbjJAipxymQHb24r7hajapl
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10222"; a="241964119"
X-IronPort-AV: E=Sophos;i="5.88,276,1635231600"; 
   d="scan'208";a="241964119"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2022 20:47:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,276,1635231600"; 
   d="scan'208";a="471953889"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP; 09 Jan 2022 20:47:46 -0800
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sun, 9 Jan 2022 20:47:46 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Sun, 9 Jan 2022 20:47:46 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Sun, 9 Jan 2022 20:47:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CPwmYMySgiJUteajuhdGVRYzo2XLr7TUtls4S644H3xV7zALep608HqlqQYspCr+Y1mGA3tcNVI7OGgZA1vVlscyrTS5DYg8p4DoWknrPWi1cnKlj3pEGedzCLzlY5BZK4tPkGe0VvwLyNplo6nSAh8eibtSf3Ztlk1YSJVKgUNBqTHE5ZIhJPwqBmiyvRNsKKzHNMxfzY4uwT6pPPGw+jGHW8HodH3geSRQIiASPq+I8IvX5u12+b5WJFO9AOEUVIvM6KxlmRTLAd/HG7ZQ9oEoB9/yOISvCqyz9gUOFtMTsq4cI7p93djYH9jOHgxDWV9cYyc1Ang7bNvIV/cNDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O9xYx0AVm1X4xHCK1ZHNbMongvbWyP1u97qnt7devfI=;
 b=Wwi01823d7Bu1se0lLjb7SCtKcV/2lYTJQHxpVl30G3MVaqxNTrqsVzhvpEtltcYd68FXEw3mjMbZ1YcN+y+zhtoT38Gp5dl4F0ed6UmnhQRp/QD7+qBOHoBZUGAYdc+hcCE0ancr1I6Y3ZvoeD4q9kkto3CRUhKd8+PBuYypJfm4661CKc2lFEG2XTgf28IIySRHVE6jZfMOumwBxwpVIbAXJoe7oszJE8i3f9mUo8awdXW58Swmg3efTWtHfUGBCRANYW5WAYdRqTiGB9NGOLzJeXuHSJVFCxBRDE/RMFEDnMEYRRdflzcDLMyt5vHTECp9YCJhoy0gfw2beqFqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB4285.namprd11.prod.outlook.com (2603:10b6:208:191::32)
 by BL1PR11MB5429.namprd11.prod.outlook.com (2603:10b6:208:30b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Mon, 10 Jan
 2022 04:47:39 +0000
Received: from MN2PR11MB4285.namprd11.prod.outlook.com
 ([fe80::38b5:756e:417:6409]) by MN2PR11MB4285.namprd11.prod.outlook.com
 ([fe80::38b5:756e:417:6409%5]) with mapi id 15.20.4867.011; Mon, 10 Jan 2022
 04:47:39 +0000
From:   "Chen, Hongzhan" <hongzhan.chen@intel.com>
To:     Yordan Karadzhov <y.karadz@gmail.com>,
        "Kiszka, Jan" <jan.kiszka@siemens.com>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: RE: [PATCH 2/2] kernel-shark: Add plugin for handling Xenomai
 cobalt_context_switch
Thread-Topic: [PATCH 2/2] kernel-shark: Add plugin for handling Xenomai
 cobalt_context_switch
Thread-Index: AQHYA2+Tti3GjiAQKUCxLB/cjMiojqxXZ5wAgAAM+ICAAAd5AIAAARSAgAAA1ICABDNVQA==
Date:   Mon, 10 Jan 2022 04:47:39 +0000
Message-ID: <MN2PR11MB428519E3A6B34D58DD722EC2F2509@MN2PR11MB4285.namprd11.prod.outlook.com>
References: <20220107021846.893-1-hongzhan.chen@intel.com>
 <20220107021846.893-2-hongzhan.chen@intel.com>
 <9e84f570-f9f0-fcdb-e6e8-7b08fcb2932c@gmail.com>
 <059411fb-b691-7bb1-9acb-7d4b005f1bc0@siemens.com>
 <50c5932c-d35b-3739-0277-508c69be9a7d@gmail.com>
 <1e49fdf9-5720-7703-778c-625a010700e8@siemens.com>
 <2698d05c-786c-ab37-2637-8dabdcf3a52d@gmail.com>
In-Reply-To: <2698d05c-786c-ab37-2637-8dabdcf3a52d@gmail.com>
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
x-ms-office365-filtering-correlation-id: 2a40d132-bc76-44fe-8f10-08d9d3f454c1
x-ms-traffictypediagnostic: BL1PR11MB5429:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BL1PR11MB542989C80F48BA9DEE6EA8BAF2509@BL1PR11MB5429.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zoZoXbEmno+h1PftWqQjhommCKwQrgWZQHuohQpLAgPVAWPQ4KzzRd7xb6X84U8JRN4LraCZOF1HcwQNmiYO53faw09uqkvO1EmfsnG+VOFe6Rh75mZvqY9CAmTfhMpKaEg/gB0lSq1eyQpzR5TfDo+4nnMsQleWIM5M5XSeBAzWznveNeLiS7j72PT7xvpyAh0ahcMahtXTx7SY9g9/Mchj5XeohqpKG1XJkvRW9PxutHAkgPvnRiV48tVFY0uISNuJHbTHylGzmtnW4HCoMYPXEnVP3mUomFYIma4dXWMU4NlmOBxBe7faS59KyOUBZPxxzbXO5gC/iJ5j3dGrCkTccNQfhyCThP4JSUMXOmC2iSS9JYZPRgNeKBFGl+7A1Kne8E9K/Z9Y0xquSPzencUUmGreTM0f4S5vkHKjnPX4LScJNX5pD5ehjmytwaaqeKHk/Nr5aXx0nY2m1kT5mkjT0Dls8uRqfMApmb937sFK7EyGm3lvQI4PcBcrni1MSNZj4/50+FW5t5P8hBK/YAAUBPq9lE+vvEc81igOt5t2j+Flt+rFm0K/a+zc3hJF6OKIVfTMxP/mbtpUM4dUrfypKI9CSoV7v3zwbX1QTWPyF5ddilhNF9QA+VyjoNGJu+OWzh/cUDjrazXgMxYBm2e02wHdRcyaugivaF5krDcK58yJpOVgW/uokGnRC3WHyDJvhYp1+Zl9drouUF1pew==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4285.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(122000001)(316002)(71200400001)(38100700002)(9686003)(66946007)(76116006)(83380400001)(38070700005)(33656002)(5660300002)(82960400001)(4744005)(186003)(55016003)(26005)(6506007)(8936002)(110136005)(2906002)(8676002)(86362001)(7696005)(508600001)(52536014)(66476007)(64756008)(66556008)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WUFVVXpkRm5BdmxKOEx3Q0RYQ1JzTWhCSnY1azByR1RnSFVTTjNncmdlRTBp?=
 =?utf-8?B?TWJrandpa3J2cG80bU5hQ21nQkxuWTBwVWNhcVg1ak9WdTVwckJrcjZtZTBR?=
 =?utf-8?B?U1gyVzJ0SkpBekxyOEY4MHIrOElsd2R3K1Y2ajFTMDRaQ2pvUTREN2dQcTZX?=
 =?utf-8?B?dmNzZlVBaURzRkhTemE1RFh0TzVBVnUzcTZYWSs3TjJKLzI1cDJXRlNDNGRu?=
 =?utf-8?B?Z2tpU0RnZ0ZqaGFtbzM3ZFdKaE5TOUtQcXVKa1plOGpmU0FPU25hbFVDM29k?=
 =?utf-8?B?OFd1cXB0M1FzM09iakZHZXAyT3ZTR01RbURQYmNxbDhzSWRETlBpdUNZczBF?=
 =?utf-8?B?ZDdVSFJmOWJqMDlDWFdXYy9La0k3QVQ5VFU2RDFjRlNvUHFPNG1mUWxlcmV0?=
 =?utf-8?B?dkNwNVNnWmQ2cVRKanVmenhxYmNqMENnb01FcDlNWUJHWi91eERSZ1Zpb0ZK?=
 =?utf-8?B?TnNnMWU5MWQzRjMyK2NHVWZKL05GM04yUVVkaWtweTVSVHVQUFZLMmtsN0lO?=
 =?utf-8?B?Rit2OXdudXpRclRDbUU5dDBBWExMSzRJRk1nYVhzUlNhWE1OdGJ2NXB3YUQ3?=
 =?utf-8?B?b25uMlNHVUpRN0p5MlZqc3pRN2RJNGQ5SkVYRXA2QkhMSUtiV3hhQWlIbncx?=
 =?utf-8?B?RzBEVjhKdndqOXpHMmtVU0JxMDFiN2ZFVkN1YysrMGZPWXZKUmVxc3NCMUNu?=
 =?utf-8?B?V1Z3bExVOE1ReWJHUG15UHBsOWtCa2ZYNDlTOVc2aVJ1dG1rTXdwb2VxWE12?=
 =?utf-8?B?UkVJWTlQMmVxVFp3dHhvSWw5OUR6dDdmTDd2d2x3bGsvMEhSRTFlNzRvUlpD?=
 =?utf-8?B?b3lzQTBrQ1ZQbVYrMGczRWpyaHl5cHh0SkhrM3YvN1RMUUovMUQxbGI1clA2?=
 =?utf-8?B?YTdXaWN6VFo2RG5OTnA0VXRvQjJzclhyelpjMWU3ZVZFbElYV2xMcDY3OWMw?=
 =?utf-8?B?aGtUUkFXNlB2U3ZXYW03QmhGM1p2TUxRZDVMZ2RzbmdZdHUvQjNzbUlpV2l4?=
 =?utf-8?B?cWt0WVFLalozbGRRemFlREx2alpjWGJGY2Q2TlhvL0Z1S1BHaU81RVZkNkZw?=
 =?utf-8?B?Y2NQZzZvWFllM2IrQy90SGpYOFRoeUdPYzc4OFFOZHBWcExDRlpLZlpUQk9s?=
 =?utf-8?B?eHJxOUlxWmFDV1VQVjAzSGpKbFNMdkcwTERsalFEdEhUVXpCcDFFU09vRmJ3?=
 =?utf-8?B?Q2JNN2gxc1NkbWtZd2NROTh1RTBGczNwa1huSXZDY2xueDF1Z0d4ZVNQaFRH?=
 =?utf-8?B?N1JucThJWjRFQnd2cWU5dGNEY2NkRXB3UGc2Z2pPMlZHalNpSkkyMjZkempK?=
 =?utf-8?B?TmhpUk9XU2hkUU1zSmwzR2xxaDdrNUJxWEtGOEdpS0k5Wnd5T1EzMk5JdGRm?=
 =?utf-8?B?cFkwaGdWWEpNOEkzaVRYemFkanVSbjFFbkdmSTltTEdoVHlkS0QxY0tNcURN?=
 =?utf-8?B?WTFVMC9vQ2pEOFlhU0Z4UitBb0Z3ZHUxLzVtMzZtWXlyeldDYXB2UllRSS9D?=
 =?utf-8?B?NXd6MTlpUHBySjFBdkpqWkgxS0ZxaS95eTZZUnEvdTBaTHY2dml1UStjTHVl?=
 =?utf-8?B?UWFBQmpuOC9zVUoyZEg1bXBCVldCTFB5OG9YNkNNUlp5SUZvanVNMnVCamM0?=
 =?utf-8?B?Z00vdWJnNWhLSTlBa3E3SjQvMCtPSFFqSk5qbVM0MytGTkFCVERCM21VRmMy?=
 =?utf-8?B?RGRwMkxETGE4WU1JeVQzZlppK1NNb2I5K2dGMnY5dnhYb0NtblV4UUtsQXdy?=
 =?utf-8?B?bi83REFVTjVJRGVUc1ZHdHRBNGgxQ09ZalBRZ0RTdFZEME1OdHVpZWpxSkxU?=
 =?utf-8?B?eERjVGp0MzF3SEJyTTZvUnpoWE5lQ1g5T0psaEJNWjZxZXZGWEduT0U1M0ZI?=
 =?utf-8?B?YklBT3ZLSGluT1ltWXRDci9LZ1UvSUdiVndjTkxCODEwQXR1blNqaEQ3Tlly?=
 =?utf-8?B?dTVCcmEycHJBSU8yOGJnbTJzSU83ZHNyUENmSnZsblNUWGFJc0o0V1BpZmFs?=
 =?utf-8?B?cGhXc2NCOHU4eHlSOGRHQUwyWHZVbERPRk5CQm5xZHB1YUc5VWxBblJUVHgx?=
 =?utf-8?B?eHBLMDRqN244ZDJNREEwSnM4S3N2dVRuNnlkaC9mUmlLR3AvMEpQN215NmNs?=
 =?utf-8?B?MlgzTHpMVitiS001NXdvekt2MUdvazRNUWMrOHhGNnVYYnlvVzlFc2tQTHcw?=
 =?utf-8?Q?i3p6sJMY7O3LchS3ytBYFdc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB4285.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a40d132-bc76-44fe-8f10-08d9d3f454c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2022 04:47:39.6619
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KKR0fSgQuDIzxRhLIB5A/Ny3yPcVtp+/R7zDuJJ+7MDRlzkvfMZ6S3Wlqiz7W5n/hzLjXQRGwfaQCHsriAuv7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5429
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

DQo+LS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj5Gcm9tOiBZb3JkYW4gS2FyYWR6aG92IDx5
LmthcmFkekBnbWFpbC5jb20+IA0KPlNlbnQ6IEZyaWRheSwgSmFudWFyeSA3LCAyMDIyIDg6MzEg
UE0NCj5UbzogS2lzemthLCBKYW4gPGphbi5raXN6a2FAc2llbWVucy5jb20+OyBDaGVuLCBIb25n
emhhbiA8aG9uZ3poYW4uY2hlbkBpbnRlbC5jb20+OyBsaW51eC10cmFjZS1kZXZlbEB2Z2VyLmtl
cm5lbC5vcmcNCj5TdWJqZWN0OiBSZTogW1BBVENIIDIvMl0ga2VybmVsLXNoYXJrOiBBZGQgcGx1
Z2luIGZvciBoYW5kbGluZyBYZW5vbWFpIGNvYmFsdF9jb250ZXh0X3N3aXRjaA0KPg0KPg0KPg0K
Pk9uIDcuMDEuMjIgPy4gMTQ6MjcgPy4sIEphbiBLaXN6a2Egd3JvdGU6DQo+Pj4gVGhlIHdob2xl
IGlkZWEgYmVoaW5kIHRoZSBkZXNpZ24gb2YgdGhpcyBpbnRlcmZhY2UgaXMgdG8gYmUgZnJpZW5k
bHkgZm9yDQo+Pj4gZXh0ZXJuYWwgcGx1Z2lucy4NCj4+Pg0KPj4gT0ssIHRoYXQgc291bmQgbW90
aXZhdGluZyB0byBsb29rIGludG8gdGhlIGV4dGVybmFsIHBhdGguIEkgc3VwcG9zZSBvbmx5DQo+
PiB0aGUgYXV0by1sb2FkaW5nIHRvcGljIHNob3VsZCBiZSBpbXByb3ZlZCB0aGVuLg0KPj4gDQo+
DQo+U291bmRzIGxpa2UgYSBwbGFuLg0KDQpUaGFua3MgZm9yIGFsbCB5b3VyIGNvbW1lbnRzIHRv
IG1ha2UgdGhlIHRoaW5nIGNsZWFyIGZvciBtZS4gUGxlYXNlIHJldmlldyBteSBWNCBwYXRjaHNl
dC4NCg0KUmVnYXJkcw0KDQpIb25nemhhbiBDaGVuDQoNCj5ZLg0KPg0K
