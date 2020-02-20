Return-Path: <SRS0=b+cV=4I=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E74CC11D0C
	for <linux-trace-devel@archiver.kernel.org>; Thu, 20 Feb 2020 18:50:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 360152467A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 20 Feb 2020 18:50:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="0k+EBW9R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728336AbgBTSuj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 20 Feb 2020 13:50:39 -0500
Received: from mail-bn8nam11on2071.outbound.protection.outlook.com ([40.107.236.71]:6203
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727535AbgBTSuj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 20 Feb 2020 13:50:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BiYFDAJKJyntTcy5UmdZsLT20gw9/GAqICwIJ5PXy25+/qWjuP9k4v0Fz5ZmMb6xejjnHMV48DYaJEIjzIBNoAKa/h1CcYmOmNLNgqDxPrdJE4mRTjDWjKZD7LtE+Hx9s53tPMMpDgAD3Ziq6+1WicuLe198D69eUAX/2lnlrXbu6cvCZ/rA97N0QaMWG7sx6x9haC9TJhCIyf2CXVRfjz5n3Ed3pD0qt2dGWZiUhZR7xrJr5BPm0RKNBpuk7F03zNJ48U14NZPiaddfXy0ZsC4fVJpD1IwVTSwUcitbsKBtGVopeNuBm6yQMDtl+E7j3iq0NiAg+RiUESz+s4OPvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hsZzu+q+4wk85rZ9UtjDaWw6nhWA6SNKsoOcciLoMw0=;
 b=eDYKYeIoBpR1RsYNc7BrwN2wNmV11e7X9f8XPjHT7sA1/nTD+KAXNebnaFT6KiYIXMBFCTtF1W/mZHqqwwRORQ0iPJyrUjF9xT+tptYrCHZ4FFmEOpLJUjGM7m80h/I6JB+yxD3IWbetHNrUTX/79TaphH2qTDlTvYn9+IgbWMANxm+lCIbdzmCo2tR0rCQszqCFji3p+bS47EL740GvteNyE2gvVfTeRtY8jgkMfNcgEBUzk2S+d3lkkCQp21RWH/VVime25ILN5Z2vrHb5mBhPNFN3N0SiksQc3BN+vdcOZGhicfgSNc2Yf1dJzSXs7xWxT3K9YqJ7X9DEqmH6AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hsZzu+q+4wk85rZ9UtjDaWw6nhWA6SNKsoOcciLoMw0=;
 b=0k+EBW9Rkw+CSitT5Fqo+HS+YXyHYJzMXNUubllB6qX0tWOpwt/ZvgTwwgt0j9tKDxtS4HqWIynk8kATN2OtcZ+0WTPhmlWxtfIHk5ySPDRpw+5L6UsneZVW5KKazBrhUgdVsA8Qv0GLMoR8XyOQDgVop0p3T3fDfI1VDhXyP7M=
Received: from SN6PR05MB4045.namprd05.prod.outlook.com (52.135.66.139) by
 SN6PR05MB4527.namprd05.prod.outlook.com (52.135.77.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.17; Thu, 20 Feb 2020 18:50:26 +0000
Received: from SN6PR05MB4045.namprd05.prod.outlook.com
 ([fe80::e567:b14d:1dd9:d08f]) by SN6PR05MB4045.namprd05.prod.outlook.com
 ([fe80::e567:b14d:1dd9:d08f%6]) with mapi id 15.20.2750.016; Thu, 20 Feb 2020
 18:50:26 +0000
Received: from mail-wr1-f51.google.com (209.85.221.51) by AM0PR0402CA0014.eurprd04.prod.outlook.com (2603:10a6:208:15::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.17 via Frontend Transport; Thu, 20 Feb 2020 18:50:18 +0000
Received: by mail-wr1-f51.google.com with SMTP id w12so5846382wrt.2        for <linux-trace-devel@vger.kernel.org>; Thu, 20 Feb 2020 10:50:18 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] trace-cmd: Add output to show "make test"
Thread-Topic: [PATCH] trace-cmd: Add output to show "make test"
Thread-Index: AQHV5/sjmt0msNx8d02DpXOsGET9p6gkbSaA
Date:   Thu, 20 Feb 2020 18:50:18 +0000
Message-ID: <CACqStodXiQJogeKn3WKYEbXBAMM6Nx_f_LQgZOdVa5VREQP3Eg@mail.gmail.com>
References: <20200220093622.6df7dafc@gandalf.local.home>
In-Reply-To: <20200220093622.6df7dafc@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR0402CA0014.eurprd04.prod.outlook.com
 (2603:10a6:208:15::27) To SN6PR05MB4045.namprd05.prod.outlook.com
 (2603:10b6:805:26::11)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tstoyanov@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: APjAAAXmR4Uq8VXGDi//Pyp9u/Kuj7Wfn5P/3GETOvcws4D7f0gURoi7
        J1Zvfk3gNLoW2S3cAzSkH4woXpIj8g3RHMT1row=
x-google-smtp-source: APXvYqwZwqe8v1LpWafX6qg0nTsnu5w5cAVb5tqqKRGCvSRjuX5LkztIT4JiyccbKhbpJzLQOnGoDkJgVe5inOLrENc=
x-received: by 2002:adf:ec4c:: with SMTP id
 w12mr45874584wrn.124.1582224612574; Thu, 20 Feb 2020 10:50:12 -0800 (PST)
x-gmail-original-message-id: <CACqStodXiQJogeKn3WKYEbXBAMM6Nx_f_LQgZOdVa5VREQP3Eg@mail.gmail.com>
x-originating-ip: [209.85.221.51]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d7a9c1b6-8e52-44e4-1e50-08d7b635baf7
x-ms-traffictypediagnostic: SN6PR05MB4527:
x-microsoft-antispam-prvs: <SN6PR05MB4527724830B191532D86BE09DC130@SN6PR05MB4527.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1265;
x-forefront-prvs: 031996B7EF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(346002)(366004)(136003)(39850400004)(199004)(189003)(66476007)(478600001)(66556008)(53546011)(86362001)(66946007)(55446002)(64756008)(66446008)(26005)(81156014)(2906002)(5660300002)(4326008)(4744005)(52116002)(42186006)(81166006)(71200400001)(9686003)(8676002)(8936002)(186003)(6862004)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR05MB4527;H:SN6PR05MB4045.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MWzhAAsPLrIl78ZKpOC/zf4QKLgQ+Gle6Qs/8yDe8pw6TnH0QqGB7CAwXX9KLEzAxfvXkFdgyGAQA2ig0YFg0s2jlzjYqd9LyCKzQh+meLVQcqHER2mB4SfWZ8XyGirfbvvDJfymH37FzpaoTdLGQQGzs+ARJyr94zRILcbN63t+vfWz8eprkcDez9MVLRt9kDDySDSqwBGZoX+ln4yK+AkmeNDvueiCPGNO+VuP1d1dGPS3OSXH2HJd7Qq3sLEHOyotdy3v4b1zPJhtM7XyJqKGBqe0TuYMzHN68wIBkYLNzrPLIsCjVSIPHHCQVGrHqm0CvOrSDof9pX5HPbxNYNP45oHHahJ1eHJChfw7QP6xYOjiPyzl/hWqSvVC30gwSBsafd2qGvrqfMg879lXWVI5fjtH8bXNoYPLENBHGVuIDDXiUZodwMS8T2Df2D4L
x-ms-exchange-antispam-messagedata: NaH2LTLorgZDKMWG9633igxNp+OV7PV30x+CFeQFSZoozUcl9A5ywbW9SbznRattg+fOZbtWAke8R7Ky6przhAWV0lkvDAP/Imrmq1qESM+Rm2y/yaR3pwzXVQvcQRs+CN0Q6zlT9EGM7/p3tqhkEw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <F420B6B2D2109848B796F373C5C16EC5@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7a9c1b6-8e52-44e4-1e50-08d7b635baf7
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Feb 2020 18:50:18.5362
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ms2tEQA1YB8ndgNeO5aydUAeOLMmTAKNXQw3d+71TGHULC5Ljl+UUwnPdrxzahN5uXKYV9RC3uje+7ufBIh1OA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR05MB4527
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gVGh1LCBGZWIgMjAsIDIwMjAgYXQgNDozNiBQTSBTdGV2ZW4gUm9zdGVkdCA8cm9zdGVkdEBn
b29kbWlzLm9yZz4gd3JvdGU6DQo+DQo+DQo+IEZyb206ICJTdGV2ZW4gUm9zdGVkdCAoVk13YXJl
KSIgPHJvc3RlZHRAZ29vZG1pcy5vcmc+DQo+DQo+IFRoZSB1bml0IHRlc3RzIGFyZSBtYWRlIHdp
dGggIm1ha2UgdGVzdCIuIEluIG9yZGVyIHRvIGxldCBkZXZlbG9wZXJzIGtub3cgb2YNCj4gdGhp
cyBvcHRpb24sIGhhdmUgaXQgZGlzcGxheWVkIHdoZW4ganVzdCAibWFrZSIgaXMgdXNlZC4NCj4N
Ckxvb2tzIGdvb2QgdG8gbWUsIHRoYW5rcyBTdGV2ZW4hDQoNCkFja2VkLWJ5OiBUenZldG9taXIg
U3RveWFub3YgKFZNd2FyZSkgPHR6LnN0b3lhbm92QGdtYWlsLmNvbT4NCg0KPiBTaWduZWQtb2Zm
LWJ5OiBTdGV2ZW4gUm9zdGVkdCAoVk13YXJlKSA8cm9zdGVkdEBnb29kbWlzLm9yZz4NCj4gLS0t
DQo+ICBNYWtlZmlsZSB8IDEgKw0KPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspDQo+
DQo+IGRpZmYgLS1naXQgYS9NYWtlZmlsZSBiL01ha2VmaWxlDQo+IGluZGV4IDYwY2QxNTcwLi5h
M2ZhY2FhOSAxMDA2NDQNCj4gLS0tIGEvTWFrZWZpbGUNCj4gKysrIGIvTWFrZWZpbGUNCj4gQEAg
LTM2NCw2ICszNjQsNyBAQCAkKG9iaikvbGliL3RyYWNlZXZlbnQvcGx1Z2lucy90cmFjZV9weXRo
b25fZGlyOiBmb3JjZQ0KPiAgc2hvd19ndWlfbWFrZToNCj4gICAgICAgICBAZWNobyAiTm90ZTog
dG8gYnVpbGQgdGhlIGd1aSwgdHlwZSBcIm1ha2UgZ3VpXCIiDQo+ICAgICAgICAgQGVjaG8gIiAg
ICAgIHRvIGJ1aWxkIG1hbiBwYWdlcywgdHlwZSBcIm1ha2UgZG9jXCIiDQo+ICsgICAgICAgQGVj
aG8gIiAgICAgIHRvIGJ1aWxkIHVuaXQgdGVzdHMsIHR5cGUgXCJtYWtlIHRlc3RcIiINCj4NCj4g
IFBIT05ZICs9IHNob3dfZ3VpX21ha2UNCj4NCj4gLS0NCj4gMi4yMC4xDQo+DQoNCg0KLS0gDQpU
enZldG9taXIgKENlY28pIFN0b3lhbm92DQpWTXdhcmUgT3BlbiBTb3VyY2UgVGVjaG5vbG9neSBD
ZW50ZXINCg==
