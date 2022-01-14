Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2F8AC433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 Jan 2022 04:48:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231983AbiANEsJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 13 Jan 2022 23:48:09 -0500
Received: from mga17.intel.com ([192.55.52.151]:38327 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229884AbiANEsI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 13 Jan 2022 23:48:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642135688; x=1673671688;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JtjuQAzuvKVnflw6uKslgWLTBj5DlBrTRHSlyce712w=;
  b=hgYP6Y1Lg0v39/vt+NMrJVkKPH11FVM2FV4RGVdtu+6m3qqTQsX9mSgq
   8ohXsaPMhqsgMRfIKGedi0b1zJXkz4aPwM63kZwu+nOLC5/a2FY4xF+fU
   pC5y/RHBdC2YGYoxrOWUmuXA2/OCqDY31nK6tNrmWXYTeqKfnYnL3a5Cd
   vltOe+F78a2dDOPVoRsA1/99DrnEDyG8ZMCPowyCE2pi5dOZg/DOlaZzD
   C8bQFWN3XwF2l1OJUHHErUdXzBIN3Eo5ZCuvMl7KkzvVf78BkoS5oPdlp
   qQS1VZdzel5qnk5UJxJ4Xll7BLbB0MBNjP29jEkN5rKiR2Mg2phIP3AVQ
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10226"; a="224871336"
X-IronPort-AV: E=Sophos;i="5.88,287,1635231600"; 
   d="scan'208";a="224871336"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2022 20:48:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,287,1635231600"; 
   d="scan'208";a="614210304"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by FMSMGA003.fm.intel.com with ESMTP; 13 Jan 2022 20:48:08 -0800
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 13 Jan 2022 20:48:08 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 13 Jan 2022 20:48:07 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Thu, 13 Jan 2022 20:48:08 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.44) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Thu, 13 Jan 2022 20:48:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P6Er24PKYhgxO8xf/Rh2ABg5cP9oJMVKvOdDUKCZbk0eGbogDxpDyoNV2E/5W95jAbaSJNL4dxaydln0JnYnI5EbLGTIRE1GvU9CXCgm+0jE6yrdRgEkxasYg6xcBLKnfez0yTzPM+MUc49p10HHdbrXXNscXp7mkfeK8z+2UJxnBLqFP8SovhnvwZR4DcSWl4wvv1StLYcPk0fzII/s7n9Lcoi3Ktgm2ZEQY5nxrpqKqgwg+ZBk3FOnXGVQXI02AQZASncM/hYw8NwNsLihWgBTBMi8wTODMt3QFhj2hszGgSuHewstkx/7fEtktBp+hZowF7+WAOyf2RUqyiX62A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JtjuQAzuvKVnflw6uKslgWLTBj5DlBrTRHSlyce712w=;
 b=Pg7yvU+nbnqmVZb4OFNOQtZgniHmbPOZc82ioRvZVBKiCPDVDiYJ6zQdBtF9feoIrZTu1Bdbg7a6MMlWA/UzSY55wR8Fn2q2PD5rUMxoKJ+UZ09Or4MVuhc452pdBuR/HRMO63u+bgTvnMlD2KIUsF38NE9l4lTu1sJ9a1qmTvLzBhDmr2IojUVvcXLio61IhZyZoZngbJPHPz+KpC8RP0KCVIre3/SVaJa7DbArDO85gDKQoz1VJN39Ws/qs4Xc5WIhVtl+purx8tzpXBmgkWDVhXX88abAAopJwGrnfravkU7C/zPr1WyvDSPSFZnI/mjm4rAYsIw7JulqTC7wHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB4285.namprd11.prod.outlook.com (2603:10b6:208:191::32)
 by MW5PR11MB5763.namprd11.prod.outlook.com (2603:10b6:303:190::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Fri, 14 Jan
 2022 04:48:06 +0000
Received: from MN2PR11MB4285.namprd11.prod.outlook.com
 ([fe80::38b5:756e:417:6409]) by MN2PR11MB4285.namprd11.prod.outlook.com
 ([fe80::38b5:756e:417:6409%5]) with mapi id 15.20.4888.011; Fri, 14 Jan 2022
 04:48:05 +0000
From:   "Chen, Hongzhan" <hongzhan.chen@intel.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     "linux-trace-devel@vger.kernel.org>, Kiszka" 
        <linux-trace-devel@vger.kernel.org>,
        "Kiszka, Jan" <jan.kiszka@siemens.com>
Subject: RE: [Questions][trace-cmd/libtraceevent] how to correctly  parse info
 out from specifial format of event?
Thread-Topic: [Questions][trace-cmd/libtraceevent] how to correctly  parse
 info out from specifial format of event?
Thread-Index: AdgIVSD6mVFfD1+OR1i6bZGO+fUq5wAXANkAAA1PiLAAAT2cgAAClL8QAAGDG4AAAWSkYA==
Date:   Fri, 14 Jan 2022 04:48:05 +0000
Message-ID: <MN2PR11MB428526FC2EF6B9F01B7E23C8F2549@MN2PR11MB4285.namprd11.prod.outlook.com>
References: <MN2PR11MB428586156443A851B879867BF2539@MN2PR11MB4285.namprd11.prod.outlook.com>
        <20220113140952.34d0f937@gandalf.local.home>
        <MN2PR11MB428554E66740ACBEE4B29D74F2549@MN2PR11MB4285.namprd11.prod.outlook.com>
        <20220113210631.5b07cf47@gandalf.local.home>
        <MN2PR11MB4285DF10ED4F820D69303162F2549@MN2PR11MB4285.namprd11.prod.outlook.com>
 <20220113230343.24e9d63e@rorschach.local.home>
In-Reply-To: <20220113230343.24e9d63e@rorschach.local.home>
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
x-ms-office365-filtering-correlation-id: b68f233c-077e-43e2-d96b-08d9d7190e05
x-ms-traffictypediagnostic: MW5PR11MB5763:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <MW5PR11MB5763CAAE06FAA531FC7170CCF2549@MW5PR11MB5763.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4MqACczA5EZyNmS6zsdFCixkkHtxcFcZ8HT1zvZmXFt9UKbzC+BX3/28itpDR20LInBxT7EDrB/TZNNz5dFb0gO9AqmRgbr+sJRAFGLSQsrpT+fuGzMJagYix9uVhLydexi4VbPFIJYQReUCT2F+Yi0yDRku2ubuvsSZs8gMWvJZJ65/vDDuN7hHr5jWKjWGloDBEyprCOJfz2tmBdoOAzfAz0uvIqOVi/X6MvQLJwdz65WQKzSWCxOsWiYyzsydWWG0xt8mCB9CNhogar31L3l9d1kTR2yoyCFpqcjbJU4cD9jJ3RAkvgnD3aTiZAevs07eq+0igZkD/bWU+Cg9xD393FSL6rE2erFMjmsFvvKxxvn/0oKBcEKCaCGnYoXM3+JKLvcIx7Ue52xyUSq7W+mVX7Fy6MGDGa4s/RRLV95wmyRp6m2NI15k/2sg0Nl3ERrU33KBfPQx0K4FLCmV1dctCwtBoLCs2b4Z3CUMsqTT6lQYkWrTBHOvzaVi7L7N1bjWtBKiM3uM1J/VRi5YhFNIpZDEwz8xmVDvBQG9zGFVWhUgVsDVfDbP/aZwkg+7FMF5h++10ZYfaHNW70vHimcZVbZ0HWc7tVWOAIBZu+HS+2mXlSIDWGauLZrO5rSIXrtjuIvYDASkBX5d239RtRSqBk35zfNvh6hsQ13cI8TD6lsAaZlxMj4rCa4elHURQbKkrWu/X9SFRSiapF1Uhqfryn2x0tSZqmzsKwoZdEgS2vVbPkCJ6ORvhn9UYCdcgWkz1xrB0+6nZDu1bqbSO4zyZIWO6ksSJg7jDkQV7ys8Ar6YGXoYdmLKRAL55MTn
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4285.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38070700005)(83380400001)(82960400001)(54906003)(64756008)(71200400001)(8936002)(52536014)(4326008)(33656002)(6916009)(86362001)(2906002)(55016003)(316002)(38100700002)(66446008)(9686003)(508600001)(26005)(66556008)(76116006)(122000001)(7696005)(66946007)(966005)(6506007)(8676002)(5660300002)(66476007)(186003)(505234007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R0pMTGEwQUhsZitkYnprVFFIMHVKY2ExdDZmcG5EVVZiS2JqRTJaQlIvb3cv?=
 =?utf-8?B?djUyN3ZNbjc0ZGJhTFhwZEdmWWREN2xWRzIxTUVXUjNKR3ZEbjVLZ3lGa2Qw?=
 =?utf-8?B?eEJzdDJjdUpGU0p0Z1NhNVhNMHpkdjdzRjZ0WVd3VHU1VGJlRit4R1RCNURl?=
 =?utf-8?B?Y3FmMHBlMG1RODhmb3hiek1HTmhjQ2RkbkxDMC9rYWdJYlRFMFdNQjNYV1Fh?=
 =?utf-8?B?MXU4a1lNZ2t1SUprMzJUQlQ1Z3hLbnNkdm9wbm9UYnUrRUI4d1d0enlucSt0?=
 =?utf-8?B?MG50TnRNaW4wTU5YSTJod0Zxb1Z5MWZOaEtiTXp2M3FYckE2aFRhb1J6SDFN?=
 =?utf-8?B?M3pGV1Q5SjZNb1o3ZTh0WWVncjd6enliZnY3QnJJZVdWNlZaL3I2QmVMTHdk?=
 =?utf-8?B?bG94TmNNdjBTVmtKbjJtNHZaVlhyb3dQeTNJRG94MHF5cGs1MW5EbzdiNW56?=
 =?utf-8?B?Y21KN0k2blVrZ3RuemhFVHlSOGFrZ0FhYU5yQmZGazRpNWZsZ2pNQUhMMVJS?=
 =?utf-8?B?eWZ1QldhQzY3U2VRM3ExNXI0bFA4MDh4cXhZVHp2ZXZWMWUwWWgrMDlFTmNM?=
 =?utf-8?B?SHNDNmlLd0g2RERYWTVIYUNsMWQwVzcwbWgxcHNzeDlrVXZ5bnNOcGZtdFBi?=
 =?utf-8?B?UkpWc2J4clhrTjRZQjJVVHZkRWlVOGNQYjJwT3k1WnF0a0IwdUhPZzFNZmdF?=
 =?utf-8?B?N3JReWw3SHRZdklXR1NmditVTmx4aHlrc3pKMmVaay9yeGpLWVhWTmV0Tklp?=
 =?utf-8?B?L002RzdJaUV5Q05xVUxnM2tzQ1FnbkowNHJxYmZZNlZLd04vcmRxc0FNVTVR?=
 =?utf-8?B?N3dTdnJVR2tEUEdST3JkazFETEltVHppVFlzRHF1dXdnUS80Q1hTQmJ2Mitr?=
 =?utf-8?B?bU9MNnVqSUlHYXh0RmZmSmJDNFJQQzJzM000akJTUFE0bkVEWitmeExLaE9S?=
 =?utf-8?B?V1NkMHpNaDd0bDdlbllhblQ2bHlTcVdtRzBXZmRDakpYNGpPKzhFdHVRZ0lM?=
 =?utf-8?B?TTBQYk1iMGszTjZPclkrVlJEQlliSmtHVzBVUU5NRE9FVFV4emVHbHZoSG5K?=
 =?utf-8?B?VStvbktmUTlzeUhvTDZ5Y3JXOHE5bkdGdUJSU1JSSmd4YllDbFVNVmc3MUVC?=
 =?utf-8?B?UU9USG1rZFgvMnFKWXpDcEFac0hlTXhvLzR4d0NCVzJkTjdHUmQzWHhFWms0?=
 =?utf-8?B?TEwrdzdjT0ZjQTUvS2NLZW1HZmdEWDhFLzVoNnI0bVR5c3VWYWlwV3B1dlFJ?=
 =?utf-8?B?UldMdXJKNnZlVHpMSzZFdEpja0VLL3pxQ3V0cUFZbEZFdGdaKzlHbTNXN3p4?=
 =?utf-8?B?bWhFSEpBczhQVHltd25SWU9tcHBiTWFRbFZ2NnZNZWhhcU5tem5VbWR0amhr?=
 =?utf-8?B?SlRuM1MvSXFhbmU1YS9FdjUzZnpGVzNrWktyYkJ0ME5tM2tvZkx3UkNKYVly?=
 =?utf-8?B?UXlldjlSeGZvRW1ESVFwdGMyU0JZMHIvMFRxa1plZ1VINnBuVSs3Yi9Ja3Zu?=
 =?utf-8?B?U1RVajM2bW9VMTgxdDZXSkE1YkxUT25obzBXUmpFVkVYNjdzM0NIUEp2ZVVW?=
 =?utf-8?B?UUxaN3BlVWo2VmMySHMxelJRUEFQdnJhdUxTdmpsZ0lQTjF6dXEzZGs3WTBT?=
 =?utf-8?B?UndjelFPSXVYc2pnOGZFcjgyK1kzWURIbzFqZktLdWNQbXZNNFJsNXlaU0kw?=
 =?utf-8?B?WjV4TlM4Y2xrUG4yZ1g1RmE5Q2pPSURJaUw1TVNHVjF0azhDYldUZ3Npb3Fu?=
 =?utf-8?B?czdPajRZTWljbnQ4N2NLcDJtemNZZmNmRGNKM09DVmlZS3MyLzJxeEVsRllU?=
 =?utf-8?B?RWViVlZmcnI4akdkRlBpU0dBbWF2ekxiZjVoaWNIODVnNFpKdndFTFNBbTVW?=
 =?utf-8?B?M256dUZHQUxIb3IxSjd5UFFDK1lXVXcyamhyQi8vQ2cyVFppRlcxWHRwSWhz?=
 =?utf-8?B?V29odHFJNytKZVZHYzB5UGI0bmhVaElrQk9PTm8wMkQ2bGtzcG9kNTJaQ0Fa?=
 =?utf-8?B?enlaZ0xpaUxzQmJzOE4yZnIrb1RyVjZHM3kxK2F1OEVYTnUzUldWUnVvZzdN?=
 =?utf-8?B?YnBjcU9CQmcrb0lsamtsYU80ZnpWaFBscWJ6TFJMNU1sZzM0M05BOXYzTDlN?=
 =?utf-8?B?RHNxbGNJZDk1VUVuaUwyNGJxaUluMG9ueHNoUU9lVTRWbHZDZFNndFJhMWNX?=
 =?utf-8?Q?Pb1N6Bq40rjr89ttetzxO88=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB4285.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b68f233c-077e-43e2-d96b-08d9d7190e05
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2022 04:48:05.7804
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Vm29hkB3VKT/G8IyOBCiZTikEDm4pZg95qRFvpW5vNaEzVCDUSULWqXFQ/wWMKgf98Kz9laALq1ffaqvNOPxAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5763
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

DQo+DQo+LS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj5Gcm9tOiBTdGV2ZW4gUm9zdGVkdCA8
cm9zdGVkdEBnb29kbWlzLm9yZz4gDQo+U2VudDogRnJpZGF5LCBKYW51YXJ5IDE0LCAyMDIyIDEy
OjA0IFBNDQo+VG86IENoZW4sIEhvbmd6aGFuIDxob25nemhhbi5jaGVuQGludGVsLmNvbT4NCj5D
YzogbGludXgtdHJhY2UtZGV2ZWxAdmdlci5rZXJuZWwub3JnPiwgS2lzemthIDxsaW51eC10cmFj
ZS1kZXZlbEB2Z2VyLmtlcm5lbC5vcmc+OyBLaXN6a2EsIEphbiA8amFuLmtpc3prYUBzaWVtZW5z
LmNvbT4NCj5TdWJqZWN0OiBSZTogW1F1ZXN0aW9uc11bdHJhY2UtY21kL2xpYnRyYWNlZXZlbnRd
IGhvdyB0byBjb3JyZWN0bHkgcGFyc2UgaW5mbyBvdXQgZnJvbSBzcGVjaWZpYWwgZm9ybWF0IG9m
IGV2ZW50Pw0KPg0KPk9uIEZyaSwgMTQgSmFuIDIwMjIgMDM6Mjg6MzcgKzAwMDANCj4iQ2hlbiwg
SG9uZ3poYW4iIDxob25nemhhbi5jaGVuQGludGVsLmNvbT4gd3JvdGU6DQo+PiA+PiBGb2xsb3dp
bmcgaXMgdHdvIGR1bXBzLCBwbGVhc2UgY2hlY2s6DQo+PiA+PiANCj4+ID4+ICAgICAgICAgICBz
bW9rZXktNDQ3ICAgWzAwMF0gICAzMjAuMTkzMTU2OiBjb2JhbHRfcHRocmVhZF9jcmVhdGU6IDc0
IDAyIDAwIDAwIGJmIDAxIDAwIDAwICA0MCAzNyA0YiBhYSBhYiA3ZiAwMCAwMCAgMDAgMDAgMDAg
MDAgMTggMDAgMzggMDAgIDAwIDAwIDAwIDAwIGZlIDdmIDAwIDAwICA2MCBjMyAyNCA5MCBmZiBm
ZiBmZiBmZiAgNWMgODEgMjEgOTAgZmYgZmYgZmYgZmYgIGQ4IGJkIDhjIDgwIDkwIGMxIGZmIGZm
ICAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgIDAwIDAw
IDAwIDAwIDAwIDAwIDAwIDAwICANCj4+ID4NCj4+ID5jb21tb25fdHlwZToJCTB4MDI3NCA9IDYy
OCAobWF0Y2hlcyB0aGUgSUQpDQo+PiA+Y29tbW9uX2ZsYWdzOgkJMDANCj4+ID5jb21tb25fcHJl
ZW1wdF9jb3VudDoJMDANCj4+ID5jb21tb25fcGlkOgkJMHgwMDAwMDFiZiA6IDQ0Nw0KPj4gPg0K
Pj4gPnB0aDoJCQkweDAwMDA3ZmFiYWE0YjNmNDAgKHdoYXRldmVyIHRoYXQgaXMpDQo+PiA+cG9s
aWN5OgkJCTB4MDAwMDAwMDANCj4+ID5wYXJhbV9leDoJCTB4MDAxODAwMzggKG9mZnNldCA9IDB4
MzggKDU2KSBsZW49MHgxOCAoMjQpICANCj4+IA0KPj4gVGhhbmtzIGZvciB5b3VyIHF1aWNrIHJl
cGx5LiA/Pw0KPj4gDQo+PiBPbiBteSBYODYgcGxhdGZvcm0gLCBpdCBpcyBwcmludGVkIGFzICAw
eDM4MDAxOChvZmZzZXQgc2hvdWxkIGJlIDB4MTgNCj4+IGxlbiA9IDB4MzgpLiAgSXQgc2hvdWxk
IHBvaW50IHRvIHRoZSBlbmQgb2YgZmllbGQgcGFyYW1fZXgNCj4NCj5Ib3cgZGlkIHlvdSBnZXQg
dGhhdD8gVGhlIGFib3ZlIHNob3dzIHRoZSA0IGJ5dGVzIGFyZToNCj4NCj4NCj4gZmllbGQ6X19k
YXRhX2xvYyBjaGFyW10gcGFyYW1fZXg7ICAgICAgIG9mZnNldDoyMDsgICAgICBzaXplOjQ7IHNp
Z25lZDoxOw0KPg0KPkFuZCBpZiB5b3UgdGFrZSB0aGUgNCBieXRlcyBhdCBvZmZzZXQgMjAgZnJv
bSBhYm92ZSB3ZSBnZXQ6DQo+DQo+ICAxOCAwMCAzOCAwMA0KPg0KPkFuZCBzaW5jZSB0aGlzIGlz
IGxpdHRsZSBlbmRpYW4sIHRoYXQgdHVybnMgaW50bzoNCj4NCj4gIDB4MDAzODAwMTgNCj4NCj4g
IA0KPj4gKGZpZWxkOl9fZGF0YV9sb2MgY2hhcltdIHBhcmFtX2V4OyAgICAgICBvZmZzZXQ6MjA7
ICAgICAgc2l6ZTo0Ow0KPj4gc2lnbmVkOjEpIHdoZXJlIHN0b3JlIGl0cyBkYXRhIHBlciBteSB1
bmRlcnN0YW5kaW5nLiBQbGVhc2UgY29ycmVjdA0KPj4gbWUgaWYgSSBhbSB3cm9uZy4NCj4+IA0K
Pj4gDQo+DQo+DQo+PiA+DQo+PiA+SG1tLCB0aGUgb2Zmc2V0IHBvaW50cyB0byB0aGF0IHNldCBv
ZiB6ZXJvcyBhdCB0aGUgZW5kLg0KPj4gPg0KPj4gPkhvdyB3YXMgdGhpcyBldmVudCBjcmVhdGVk
PyAgDQo+PiANCj4+IFRoZSBldmVudCBkZWZpbml0aW9uIHBsZWFzZSByZWZlciB0byBodHRwczov
L2dpdGxhYi5jb20vWGVub21haS94ZW5vbWFpLWhhY2tlci1zcGFjZS8tL2Jsb2IvbWFzdGVyL2tl
cm5lbC9jb2JhbHQvdHJhY2UvY29iYWx0LXBvc2l4LmgNCj4+IA0KPg0KPlRoYXQgcmVmZXJlbmNl
cyBvdGhlciBmaWxlcy4gQXJlIHRob3NlIG90aGVyIGZpbGVzIHRha2VuIGZyb20gdGhlIExpbnV4
IGtlcm5lbD8NCg0KWWVzLCB0YWtlbiBmcm9tIExpbnV4IGtlcm5lbCBhbmQgYnVpbHQgdG9nZXRo
ZXIgd2l0aCBMaW51eCBrZXJuZWwuDQoNClJlZ2FyZHMNCg0KSG9uZ3poYW4gQ2hlbg0KPg0KPlNw
ZWNpZmljYWxseToNCj4NCj4jaW5jbHVkZSA8bGludXgvdHJhY2Vwb2ludC5oPg0KPiNpbmNsdWRl
IDxsaW51eC90cmFjZV9zZXEuaD4NCiNpbmNsdWRlIDx0cmFjZS9kZWZpbmVfdHJhY2UuaD4NCg0K
LS0gU3RldmUNCg0K
