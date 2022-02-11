Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2FE6C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Feb 2022 05:03:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbiBKFD3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Feb 2022 00:03:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiBKFD2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Feb 2022 00:03:28 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1892A1105
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Feb 2022 21:03:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644555807; x=1676091807;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=3sKL9axdnTcQj0sQ9ibhIoZ1ONBA/DiRL53ff/wP8ew=;
  b=aKNMMW2FmLZEMt31ItNIWeWkMpHEt2NUtTe/nJ9p3z/1MxKfJE5BfmkK
   owX6CsHHkqRnRDxx+t1i3AA1fnay4MbYurP6FqiGPdKgo986+qDTjXIXb
   go+C5f0Aw7B+O5Gv4TvE2mEV6nWUWYpHTz8mqB7cclH0Ts45BoGHNjjfz
   1R5tdpbZ8GF4/gOZLSO2F2yVeMuyg6tvrwcsfJLfaywPFEt/8Lk8s30Wi
   nG0c3NS+I6QLUP+tVaY8PsPrixbotPoveRFI0BTR8REpoiq+apvA2ktnG
   S3yV4L+Z7BZ/U0qCzOrJGCkCAJ2krbxB8hER1B4BiJvJwYCobMHBiRo2e
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10254"; a="247252570"
X-IronPort-AV: E=Sophos;i="5.88,359,1635231600"; 
   d="scan'208";a="247252570"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 21:03:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,359,1635231600"; 
   d="scan'208";a="633957262"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga004.jf.intel.com with ESMTP; 10 Feb 2022 21:03:26 -0800
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 10 Feb 2022 21:03:26 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Thu, 10 Feb 2022 21:03:26 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Thu, 10 Feb 2022 21:03:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nHoWpuBYbPE3SNvVTFOCagqwcH5BsxrfL4u1kNFtRPlUYg+qk1bxPtIEzEvOg6EFCJIHwEPNLyUDdhUWPA04eosNKs/ospZswgXQNpu3UXu/lu4o1Vd9/7JhE3U78gMQHPAA9UI0yaC94IduGzyls+D58skyjsZqycPhhkJnHZg0xT9V5AQfeK3b/CvWj8bA0mDME6dxgxZ8gU5u09GtUxWdqzy5V/YFHUtDVIhZBjT6P7KssolunWsBlWinX8smySCicdEAgylK7PNnx+ar/xrfz7ao6pTHrEeO1JRCQAy7EU6dpG9vEFu+J2iAdW7H2k12txLeAYHm4ijSfXWRRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3sKL9axdnTcQj0sQ9ibhIoZ1ONBA/DiRL53ff/wP8ew=;
 b=TuavfiJAr4JG63JLavg45DL0vbJyLfO9JjwBXo/+YL/rQLfSEq6al1ZHCRKmGB0A2BcIYP3xfUiexbsckudB9Kf2NZI/3L/P0g5UrBzJtHL11XcrHptwUOi8cRPvZTAqAKruerxQ8eOD9d1i0eRgP6ayjzPJObGKdqCluWBUYWYTX172hFgCtGDRKSoaEGaqIcDxsyJvr7YlLFq7Q0yrtG9MyCEjDveFwE/0v+SvXylTy/8UlIoGy6Cj9YgBmm/0gkCr4Rhhmw5j219FTObgpGF2i7PfYjIkgBeyX9Fck2gMIBiHJf3pOro9RHiEQIlPkYGNXbR6CEF9GTyz3fCbbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from MN2PR11MB4285.namprd11.prod.outlook.com (2603:10b6:208:191::32)
 by BY5PR11MB4101.namprd11.prod.outlook.com (2603:10b6:a03:18e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.14; Fri, 11 Feb
 2022 05:03:24 +0000
Received: from MN2PR11MB4285.namprd11.prod.outlook.com
 ([fe80::38b5:756e:417:6409]) by MN2PR11MB4285.namprd11.prod.outlook.com
 ([fe80::38b5:756e:417:6409%5]) with mapi id 15.20.4951.019; Fri, 11 Feb 2022
 05:03:24 +0000
From:   "Chen, Hongzhan" <hongzhan.chen@intel.com>
To:     Yordan Karadzhov <y.karadz@gmail.com>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>,
        "Kiszka, Jan" <jan.kiszka@siemens.com>
Subject: RE: [RFC PATCH 0/2] Allow GUI plugins to build standalone
Thread-Topic: [RFC PATCH 0/2] Allow GUI plugins to build standalone
Thread-Index: AQHYDSyOuCzFNfwE1EGKD9t8AhVaFqxqQKiAgCOZvHA=
Date:   Fri, 11 Feb 2022 05:03:23 +0000
Message-ID: <MN2PR11MB4285CF1156C93679DFDAA5F7F2309@MN2PR11MB4285.namprd11.prod.outlook.com>
References: <20220119120229.68627-1-y.karadz@gmail.com>
 <27543723-5970-a968-30ab-e30e5731e53a@gmail.com>
In-Reply-To: <27543723-5970-a968-30ab-e30e5731e53a@gmail.com>
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
x-ms-office365-filtering-correlation-id: 1899c6ed-b40c-4f60-95b5-08d9ed1bd4d6
x-ms-traffictypediagnostic: BY5PR11MB4101:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BY5PR11MB4101B6B24796282A7A78D0EAF2309@BY5PR11MB4101.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /HTiS2RJGnCfh2UuhJGGYjzUArD++gx8/7QGA9rvxZJMuq2+2MsHeY7vG5mbUMzctQaUEwBFiEpAAXx4dBzY3vDiaE7mbXA/MBOxBd8ev05oyxbiUkgPQhWY0SyWHrd9nhcU05wGGrAeGOR4qZxVk3rPou893sSD9dS8AOHWgf4LMyx0opYBkIpN0reudHPncMoiQdHeAbs1v08/TMBnvA6Jss0Z3kuu7MYkYoaH2PmZDOK/P4BfD+tkWnktsS5HxMXrWCwjiemENnrG68fno2MYrMumPpzLuBeqQyHxESYFlUUhCEsJWCzkEiPJ/fby5348KQYX21cT+APC0jurhmQ8TZRMFCx5v4gm4q7HtmFMGc1lkxErIWLZFWWrcBOjdokDbbvNuqBfxk25oOqinQFca5eBvi6IxTLLEXZjtAGloUOqSRrCiQpVt/WTSowhZmNudKMEPcK5oVINypbukdjQ3ms0ENNYAeY29BcVG1dzoGlkTV0wm4IqJbYN8ypCikLAOrjk6A7we2Egq0FJCi2LRj6dFL5xN1/SZM/g+csQk7/dfnLr7nIqO5qEME66gDzjTQpnVdwM0ir3UgrxGpTFmjkylODbcW9cg+JqvHjZSgWo0wfh7iePHyfz0A1SLpJf0k9q74UCr72uTe5ypfTZTtN1rTJDF94b9rRw8wW+6bHn9OLz5ST54lsQ5pGZLGc6r1SI1QnpgN1Nws8JNA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4285.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(82960400001)(316002)(64756008)(9686003)(8676002)(7696005)(52536014)(122000001)(33656002)(38100700002)(38070700005)(8936002)(26005)(83380400001)(6506007)(186003)(66446008)(66476007)(76116006)(86362001)(508600001)(55016003)(66556008)(19627235002)(2906002)(5660300002)(110136005)(66946007)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Uk5GOE9ZTkw3ZlBJVHExWTZHZFBPeTAxRDRhSlZkWE9IOVBheXg4SWlieG4z?=
 =?utf-8?B?VE41cDNDRnFuY1M4SnBFTy9iQTFsU2tvcktuM2c3TExZakRZWDVmdWcwM2JW?=
 =?utf-8?B?T0lXUldxMDZKUTY2bm9mUnZvV3NqbVIrRVRwY1gySWNJS2FGcW0vVGxDemFV?=
 =?utf-8?B?b2lmZm9zMHpvV2U5bjRLYlUzdUpsNnJQOEt5SzVsZHNLbExodmRWU3M5VFRz?=
 =?utf-8?B?dEc2d0V2N2dSQ2pXVTVqZEtRU3huTnJyU3hBQ2IwMVlwL2hEUldoVVpjWXRD?=
 =?utf-8?B?cDE1bWNQVk9QYnpUenpMYVlNR292cGJRL3planArekV0bGF3elJPK0lBS1lC?=
 =?utf-8?B?SXVBOHo4NnAwekNNTzhmc1hhNWJzVDNMcVZ1dW8vM3k4K1pyYSswWC9jOUN1?=
 =?utf-8?B?N2IvbCthR05oakFTN3ZHbFdKVXVGaS9RYkJqc2FlQ2NSanNnYkd0MThXaGk5?=
 =?utf-8?B?TkVCang3dGhUKzMySkN3YVk3amN6WEU1aDJpUVJoK1U3MWZlQ2lGS0RqSFVH?=
 =?utf-8?B?Zjh0UUpxaXZHTWg3d29Ba2xsS21BVFk3bXpYM2gxTUI1QUdNQWFrMmRCMk94?=
 =?utf-8?B?ZUFpU1JBOXFITFBCUklyTitTU1Z6U09MbFJSM0ZjZXl1b3dnRHF0eEJNZEdw?=
 =?utf-8?B?a0ZjeXZQRFZ2T3dhNnNDZ29CR2lEaXpVOG9HSXV4ajNmR2oxSEdGTndkM3VE?=
 =?utf-8?B?STJFM1RFRUpkNTZkSmRHc3Q5WlYwTDBudGk3ZG9kU2h0allUay9sV1RwQWI1?=
 =?utf-8?B?emlmVWwxNXdxeHJQb0tOdEk4NlhSTWMwTlNJVXlmVUlTdzRVQXFzVEpKMmJT?=
 =?utf-8?B?aHhWVGpLMFNhOFpjRkNhK3NpRmxZR1JEUzN6bkhER3dFVFBaZVpraEZuZkdj?=
 =?utf-8?B?UlBhUkNkZlRMV2JFeDM2anlJeVNLY3cvVDhhdXliMU9VbHVUUnRYd2JhYndG?=
 =?utf-8?B?bmpFSWJaN2tiM1BML0wxRXZ1V3ZGU01hN1lIR043M3hNWmV5djBHbm1MN2o5?=
 =?utf-8?B?ZlB1MHdHOFNONEFNQStZd2M5Y0dtRW94Ulh5bklxNjhJUzNQc2lUZm1KRm9C?=
 =?utf-8?B?ZmYreEtqUFBTT1d1dEI4c2lucEtwbWxWT0dmcGZrMFdUYkM5elpjU0g3NGxz?=
 =?utf-8?B?L3BjcWJIVkpkTEtHbnVQd3prUmV2bDJtUVJmM2VNblMxYjNiKzU4Q3pPUFdU?=
 =?utf-8?B?c1B0eUJFSmhWU012eVlncWYrOHYyZ0toUGRFSHFuYTByNE0zNjUwNUNRaE1l?=
 =?utf-8?B?OHpjTFhKeDRBVE5xVnMwcVhPaENLR0NBYzh5Vkl3UFl5V1ZVRENibkJFRFpV?=
 =?utf-8?B?SE04TTRyTVN6UHA5RVhqZUZOUXdjOWpBVGM3SjFwSys3TmpIS09ObnZyRHJs?=
 =?utf-8?B?ZVVRU2J3VFNJTFh5K09DWXlxWkk0U2NBM0Q2WWlwcUN5NWtBbElQMFAvV1Rp?=
 =?utf-8?B?K3ZmWXliL0VJM2FEVEhvaldyOC9ZUEhSdk0yUXgrbFZ4M29VM0tqRjhDRHJy?=
 =?utf-8?B?T2xqYjM5N1FGUTR0ZWlETVEvRFpUZUJPaHpHcWhlNWZPRGMveU1pWU43bjE3?=
 =?utf-8?B?ZllIdzhXcnhOUWtDQ1FHditUcXppWUVXU2M3d3g1aVRmNkM0YTN3STZWaWVt?=
 =?utf-8?B?RlpITnFUdHo1bSsvMEkrbno2TlVFbzVzdTZMYW9QUFAwMlIvUVBXN2NBcmpR?=
 =?utf-8?B?THoxeXVIcDF1bTh4Wk9LQzRzWFViYWlaYlY1TmdnU3NyR0dNNXl6V3FvZXNQ?=
 =?utf-8?B?VFkxT1JnYWFQT2krKy9aOE1VdG84eThZUk9KZkVDOFNDWHV5YW85QWdwS0Js?=
 =?utf-8?B?YnpQNmJFTU5CenpER1ZLcW9vN1lZRHd2RWJTam5JYXZBTGdlZy9tWkxNUTNn?=
 =?utf-8?B?aWh5ZVU4WUZCeVNmejdUU2JhWVNIYnhSWkU3RVJ6Q2RNZUVUODFtNGFLNkM2?=
 =?utf-8?B?WG9Ub0ozNnNKbmFyR3lwczNQY2FmU1FUWTJSR0wyMVg5eG5mWmdzcEM4alVs?=
 =?utf-8?B?QkNPV2NwZ044K3AyaVorV0Rqcmo2dFR0N1NxVmkwVzhqMlpyejRMbzNqV2dX?=
 =?utf-8?B?NzEralBuWW9CSVRmUjN1cmluL21SeXVlbWljNlNnWHJuYlZkVjBBdTRFWFJ3?=
 =?utf-8?B?VjNhME1rbnRObzJVWlExRGNPYzFSeEV3RTJUUG1ENHcwNVMxSjR5SnR5ajd0?=
 =?utf-8?Q?c27W3EqbTnVGikrEbR9CI5g=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB4285.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1899c6ed-b40c-4f60-95b5-08d9ed1bd4d6
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Feb 2022 05:03:23.9587
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mZUw51XDUnHsz8UT/HUFfQpq4kNwAOdhPJ27G6Nws2wW/u5TbH0IRu5aTzBCjLuW+bCHqCkjNuS73krqdTEKVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4101
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

DQoNCj4tLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPkZyb206IFlvcmRhbiBLYXJhZHpob3Yg
PHkua2FyYWR6QGdtYWlsLmNvbT4gDQo+U2VudDogV2VkbmVzZGF5LCBKYW51YXJ5IDE5LCAyMDIy
IDg6MTAgUE0NCj5UbzogbGludXgtdHJhY2UtZGV2ZWxAdmdlci5rZXJuZWwub3JnOyBDaGVuLCBI
b25nemhhbiA8aG9uZ3poYW4uY2hlbkBpbnRlbC5jb20+OyBLaXN6a2EsIEphbiA8amFuLmtpc3pr
YUBzaWVtZW5zLmNvbT4NCj5TdWJqZWN0OiBSZTogW1JGQyBQQVRDSCAwLzJdIEFsbG93IEdVSSBw
bHVnaW5zIHRvIGJ1aWxkIHN0YW5kYWxvbmUNCj4NCj5BbmQgaGVyZSBpcyB0aGUgdmVyc2lvbiBv
ZiB0aGUgcGx1Z2luIHRoYXQgY2FuIGJ1aWxkIHN0YW5kYWxvbmUuIEluIG9yZGVyIHRvIGxvYWQg
aXQganVzdCBkbzoNCj4NCj5rZXJuZWxzaGFyayAtcCBwYXRoL3RvL3hlbm9tYWlfY29iYWx0X3Bs
dWdpbi9wbHVnaW4teGVub21haV9jb2JhbHRfc3dpdGNoX2V2ZW50cy5zbw0KPg0KPllvdSBjYW4g
YWxzbyBsb2FkIGl0IGZyb20gdGhlIG1lbnVzLg0KPk5vdGUgdGhhdCBJIG9ubHkgdGVzdGVkIHRo
YXQgaXQgYnVpbGRzIGFuZCBsb2FkcyBzdWNjZXNzZnVsbHkgYnV0IEkgaGF2ZSBubyBkYXRhIGZp
bGUgdGhhdCBjb250YWlucyAnY29iYWx0JyBldmVudHMuDQoNClNvcnJ5IGZvciBsYXRlIHJlc3Bv
bnNlLiBJdCBidWlsZHMgYW5kIGxvYWRzIHN1Y2Nlc3NmdWxseSBiYXNlZCBvbiB5b3VyIHBhdGNo
c2V0IGFjY29yZGluZyB0byBteSB0ZXN0LiBJdCBpcyByZWFsbHkgZ3JlYXQNCnRoYXQgd2UgY2Fu
IGJ1aWxkIGl0IHN0YW5kYWxvbmUuIEl0IGFsc28gdmlzdWFsaXplIGNvYmFsdCBibHVlIGhvbGxv
dyBib3ggZm9yIHhlbm9tYWkgT09CIHN0YXRlIGNvcnJlY3RseSBhZnRlciBydW4uDQpJdCBpcyB2
ZXJ5IHVzZWZ1bC4NCg0KQnV0IHdoZW4gSSBkb3VibGUgY2xpY2sgdGhlIGJveCAsIGtlcm5lbC1z
aGFyayBxdWl0IGFibm9ybWFsbHkgd2l0aCBzZWdtZW50YXRpb24gZmF1bHQuDQoNCkZvbGxvd2lu
ZyBpcyBiYWNrdHJhY2UgaW5mbzoNCg0KW1RocmVhZCAweDdmZmZjMDg0ZDcwMCAoTFdQIDIwNjQp
IGV4aXRlZF0NCg0KVGhyZWFkIDEgImtlcm5lbHNoYXJrIiByZWNlaXZlZCBzaWduYWwgU0lHU0VH
ViwgU2VnbWVudGF0aW9uIGZhdWx0Lg0KS3NNYWluV2luZG93OjptYXJrRW50cnkgKHRoaXM9MHgw
LCBlPTB4N2ZmZmFkZjkwZjYwLCBzdD1EdWFsTWFya2VyU3RhdGU6OkIpIGF0IC9ob21lL2ludGVs
L2lvdGcvZG92ZXRhaWwva2VybmVsc2hhcmsva2VybmVsLXNoYXJrL3NyYy9Lc1V0aWxzLmhwcDoy
MjkNCjIyOSAgICAgICAgICAgICBzc2l6ZV90IHNpemUoKSBjb25zdCB7cmV0dXJuIF9kYXRhU2l6
ZTt9DQooZ2RiKSBiYWNrdHJhY2UNCiMwICAweDAwMDA3ZmZmZjdiOTE0NDIgaW4gS3NNYWluV2lu
ZG93OjptYXJrRW50cnkoa3NoYXJrX2VudHJ5IGNvbnN0KiwgRHVhbE1hcmtlclN0YXRlKSAodGhp
cz0weDAsIGU9MHg3ZmZmYWRmOTBmNjAsIHN0PUR1YWxNYXJrZXJTdGF0ZTo6QikNCiAgICBhdCAv
aG9tZS9pbnRlbC9pb3RnL2RvdmV0YWlsL2tlcm5lbHNoYXJrL2tlcm5lbC1zaGFyay9zcmMvS3NV
dGlscy5ocHA6MjI5DQojMSAgMHgwMDAwN2ZmZmMwODc2MzI5IGluIFhlbm9tYWlTd2l0Y2hCb3g6
Ol9kb3VibGVDbGljaygpIGNvbnN0ICh0aGlzPTB4MWM3ZWJjMCkgYXQgQ29iYWx0U3dpdGNoRXZl
bnRzLmNwcDo0Mw0KIzIgIDB4MDAwMDdmZmZmNWEyNTk0ZiBpbiBRV2lkZ2V0OjpldmVudChRRXZl
bnQqKSAoKSBhdCAvdXNyL2xpYi94ODZfNjQtbGludXgtZ251L2xpYlF0NVdpZGdldHMuc28uNQ0K
IzMgIDB4MDAwMDdmZmZmNTllNjgzYyBpbiBRQXBwbGljYXRpb25Qcml2YXRlOjpub3RpZnlfaGVs
cGVyKFFPYmplY3QqLCBRRXZlbnQqKSAoKSBhdCAvdXNyL2xpYi94ODZfNjQtbGludXgtZ251L2xp
YlF0NVdpZGdldHMuc28uNQ0KIzQgIDB4MDAwMDdmZmZmNTllZTY1ZiBpbiBRQXBwbGljYXRpb246
Om5vdGlmeShRT2JqZWN0KiwgUUV2ZW50KikgKCkgYXQgL3Vzci9saWIveDg2XzY0LWxpbnV4LWdu
dS9saWJRdDVXaWRnZXRzLnNvLjUNCiM1ICAweDAwMDA3ZmZmZjQ4ZGM4YTggaW4gUUNvcmVBcHBs
aWNhdGlvbjo6bm90aWZ5SW50ZXJuYWwyKFFPYmplY3QqLCBRRXZlbnQqKSAoKSBhdCAvdXNyL2xp
Yi94ODZfNjQtbGludXgtZ251L2xpYlF0NUNvcmUuc28uNQ0KIzYgIDB4MDAwMDdmZmZmNTllZDYz
MiBpbiBRQXBwbGljYXRpb25Qcml2YXRlOjpzZW5kTW91c2VFdmVudChRV2lkZ2V0KiwgUU1vdXNl
RXZlbnQqLCBRV2lkZ2V0KiwgUVdpZGdldCosIFFXaWRnZXQqKiwgUVBvaW50ZXI8UVdpZGdldD4m
LCBib29sKSAoKQ0KICAgIGF0IC91c3IvbGliL3g4Nl82NC1saW51eC1nbnUvbGliUXQ1V2lkZ2V0
cy5zby41DQojNyAgMHgwMDAwN2ZmZmY1YTQwMTViIGluICAoKSBhdCAvdXNyL2xpYi94ODZfNjQt
bGludXgtZ251L2xpYlF0NVdpZGdldHMuc28uNQ0KIzggIDB4MDAwMDdmZmZmNWE0MjdjYSBpbiAg
KCkgYXQgL3Vzci9saWIveDg2XzY0LWxpbnV4LWdudS9saWJRdDVXaWRnZXRzLnNvLjUNCiM5ICAw
eDAwMDA3ZmZmZjU5ZTY4M2MgaW4gUUFwcGxpY2F0aW9uUHJpdmF0ZTo6bm90aWZ5X2hlbHBlcihR
T2JqZWN0KiwgUUV2ZW50KikgKCkgYXQgL3Vzci9saWIveDg2XzY0LWxpbnV4LWdudS9saWJRdDVX
aWRnZXRzLnNvLjUNCiMxMCAweDAwMDA3ZmZmZjU5ZWUxMDQgaW4gUUFwcGxpY2F0aW9uOjpub3Rp
ZnkoUU9iamVjdCosIFFFdmVudCopICgpIGF0IC91c3IvbGliL3g4Nl82NC1saW51eC1nbnUvbGli
UXQ1V2lkZ2V0cy5zby41DQojMTEgMHgwMDAwN2ZmZmY0OGRjOGE4IGluIFFDb3JlQXBwbGljYXRp
b246Om5vdGlmeUludGVybmFsMihRT2JqZWN0KiwgUUV2ZW50KikgKCkgYXQgL3Vzci9saWIveDg2
XzY0LWxpbnV4LWdudS9saWJRdDVDb3JlLnNvLjUNCiMxMiAweDAwMDA3ZmZmZjUyMmE3ODAgaW4g
UUd1aUFwcGxpY2F0aW9uUHJpdmF0ZTo6cHJvY2Vzc01vdXNlRXZlbnQoUVdpbmRvd1N5c3RlbUlu
dGVyZmFjZVByaXZhdGU6Ok1vdXNlRXZlbnQqKSAoKSBhdCAvdXNyL2xpYi94ODZfNjQtbGludXgt
Z251L2xpYlF0NUd1aS5zby41DQojMTMgMHgwMDAwN2ZmZmY1MjJjMGI1IGluIFFHdWlBcHBsaWNh
dGlvblByaXZhdGU6OnByb2Nlc3NXaW5kb3dTeXN0ZW1FdmVudChRV2luZG93U3lzdGVtSW50ZXJm
YWNlUHJpdmF0ZTo6V2luZG93U3lzdGVtRXZlbnQqKSAoKSBhdCAvdXNyL2xpYi94ODZfNjQtbGlu
dXgtZ251L2xpYlF0NUd1aS5zby41DQojMTQgMHgwMDAwN2ZmZmY1MjAzMzNiIGluIFFXaW5kb3dT
eXN0ZW1JbnRlcmZhY2U6OnNlbmRXaW5kb3dTeXN0ZW1FdmVudHMoUUZsYWdzPFFFdmVudExvb3A6
OlByb2Nlc3NFdmVudHNGbGFnPikgKCkgYXQgL3Vzci9saWIveDg2XzY0LWxpbnV4LWdudS9saWJR
dDVHdWkuc28uNQ0KIzE1IDB4MDAwMDdmZmZlZDhhZTI2MCBpbiAgKCkgYXQgL3Vzci9saWIveDg2
XzY0LWxpbnV4LWdudS9saWJRdDVYY2JRcGEuc28uNQ0KIzE2IDB4MDAwMDdmZmZmMTNiNzUzNyBp
biBnX21haW5fY29udGV4dF9kaXNwYXRjaCAoKSBhdCAvdXNyL2xpYi94ODZfNjQtbGludXgtZ251
L2xpYmdsaWItMi4wLnNvLjANCiMxNyAweDAwMDA3ZmZmZjEzYjc3NzAgaW4gICgpIGF0IC91c3Iv
bGliL3g4Nl82NC1saW51eC1nbnUvbGliZ2xpYi0yLjAuc28uMA0KIzE4IDB4MDAwMDdmZmZmMTNi
NzdmYyBpbiBnX21haW5fY29udGV4dF9pdGVyYXRpb24gKCkgYXQgL3Vzci9saWIveDg2XzY0LWxp
bnV4LWdudS9saWJnbGliLTIuMC5zby4wDQojMTkgMHgwMDAwN2ZmZmY0OTM1ODVmIGluIFFFdmVu
dERpc3BhdGNoZXJHbGliOjpwcm9jZXNzRXZlbnRzKFFGbGFnczxRRXZlbnRMb29wOjpQcm9jZXNz
RXZlbnRzRmxhZz4pICgpIGF0IC91c3IvbGliL3g4Nl82NC1saW51eC1nbnUvbGliUXQ1Q29yZS5z
by41DQojMjAgMHgwMDAwN2ZmZmY0OGRhOGRhIGluIFFFdmVudExvb3A6OmV4ZWMoUUZsYWdzPFFF
dmVudExvb3A6OlByb2Nlc3NFdmVudHNGbGFnPikgKCkgYXQgL3Vzci9saWIveDg2XzY0LWxpbnV4
LWdudS9saWJRdDVDb3JlLnNvLjUNCiMyMSAweDAwMDA3ZmZmZjQ4ZTM5ODQgaW4gUUNvcmVBcHBs
aWNhdGlvbjo6ZXhlYygpICgpIGF0IC91c3IvbGliL3g4Nl82NC1saW51eC1nbnUvbGliUXQ1Q29y
ZS5zby41DQojMjIgMHgwMDAwMDAwMDAwNDAyYWY1IGluIG1haW4gKGFyZ2M9PG9wdGltaXplZCBv
dXQ+LCBhcmd2PTxvcHRpbWl6ZWQgb3V0PikgYXQgL2hvbWUvaW50ZWwvaW90Zy9kb3ZldGFpbC9r
ZXJuZWxzaGFyay9rZXJuZWwtc2hhcmsvc3JjL2tlcm5lbHNoYXJrLmNwcDoxNTQNCiMyMyAweDAw
MDA3ZmZmZjM2OWFiZjcgaW4gX19saWJjX3N0YXJ0X21haW4gKG1haW49DQogICAgMHg0MDI0ODAg
PG1haW4+LCBhcmdjPTEsIGFyZ3Y9MHg3ZmZmZmZmZmRkMTgsIGluaXQ9PG9wdGltaXplZCBvdXQ+
LCBmaW5pPTxvcHRpbWl6ZWQgb3V0PiwgcnRsZF9maW5pPTxvcHRpbWl6ZWQgb3V0Piwgc3RhY2tf
ZW5kPTB4N2ZmZmZmZmZkZDA4KSBhdCAuLi9jc3UvbGliYy1zdGFydC5jOjMxMA0KIzI0IDB4MDAw
MDAwMDAwMDQwMmNmYSBpbiBfc3RhcnQgKCkgYXQgL2hvbWUvaW50ZWwvaW90Zy9kb3ZldGFpbC9r
ZXJuZWxzaGFyay9rZXJuZWwtc2hhcmsvc3JjL2tlcm5lbHNoYXJrLmNwcDoxMjkNCihnZGIpDQoN
ClJlZ2FyZHMNCg0KSG9uZ3poYW4gQ2hlbg0KPg0KPkNoZWVycywNCj5Zb3JkYW4NCj4NCj4NCj5P
biAxOS4wMS4yMiA/LiAxNDowMiA/LiwgWW9yZGFuIEthcmFkemhvdiAoVk13YXJlKSB3cm90ZToN
Cj4+IEhpIEhvbmd6aGFuIGFuZCBKYW4sDQo+PiANCj4+IEkgdHJpZWQgdG8gYnVpbGQgeW91ciBw
bHVnaW4gc3RhbmRhbG9uZSBhbmQgSSByZWFsaXplZCB0aGF0IHRoaXMgaXMNCj4+IGluIGZhY3Qg
bm90IHBvc3NpYmxlIGR1ZSB0byBzb21lIG1pc3NpbmcgaGVhZGVyIGZpbGVzLiBUaGlzIGdldHMg
Zml4ZWQNCj4+IGluIHRoZSBmb2xsb3dpbmcgcGF0Y2gtc2V0LiBJIGFsc28gbWFkZSBzb21lIG1p
bm9yIG1vZGlmaWNhdGlvbnMgaW4NCj4+IHRoZSBjb2RlIG9mIHlvdXIgcGx1Z2luIGFuZCB3aWxs
IHNlbmQgeW91IHRoaXMgbW9kaWZpZWQgdmVyc2lvbiBvZg0KPj4gdGhlIHBsdWdpbiBpbiBhIHNl
cGFyYXRlIGVtYWlsLg0KPj4gDQo+PiBQbGVhc2UgbGV0IG1lIGtub3cgaWYgeW91IGZpbmQgdGhp
cyBtb2RpZmljYXRpb25zIHVzZWZ1bCBvciBub3Q/DQo+PiANCj4+IENoZWVycywNCj4+IFlvcmRh
bg0KPj4gDQo+PiBZb3JkYW4gS2FyYWR6aG92IChWTXdhcmUpICgyKToNCj4+ICAgIGtlcm5lbC1z
aGFyazogQWRkIEtzUGx1Z2luc0dVSS5ocHAvLmNwcA0KPj4gICAga2VybmVsLXNoYXJrOiBJbnN0
YWxsIG1pc3NpbmcgaGVhZGVycw0KPj4gDQo+PiAgIHNyYy9DTWFrZUxpc3RzLnR4dCAgICAgICAg
IHwgMTIgKysrKysrKysrKysrDQo+PiAgIHNyYy9Lc1BsdWdpbnNHVUkuY3BwICAgICAgIHwgMjcg
KysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+PiAgIHNyYy9Lc1BsdWdpbnNHVUkuaHBwICAg
ICAgIHwgMjIgKysrKysrKysrKysrKysrKysrKysrKw0KPj4gICBzcmMvcGx1Z2lucy9DTWFrZUxp
c3RzLnR4dCB8ICA0ICsrKysNCj4+ICAgNCBmaWxlcyBjaGFuZ2VkLCA2NSBpbnNlcnRpb25zKCsp
DQo+PiAgIGNyZWF0ZSBtb2RlIDEwMDY0NCBzcmMvS3NQbHVnaW5zR1VJLmNwcA0KPj4gICBjcmVh
dGUgbW9kZSAxMDA2NDQgc3JjL0tzUGx1Z2luc0dVSS5ocHANCj4+ICANCg==
