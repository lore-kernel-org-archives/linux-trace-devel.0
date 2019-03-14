Return-Path: <SRS0=grb/=RR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62249C43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Mar 2019 13:05:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F5FF20854
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Mar 2019 13:05:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="QUtjaxIe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727173AbfCNNFT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 Mar 2019 09:05:19 -0400
Received: from mail-eopbgr720058.outbound.protection.outlook.com ([40.107.72.58]:60672
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727059AbfCNNFS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 Mar 2019 09:05:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TOC+zTiLLBpB2km8x4U0jA54t9QQ1m8mt3abrCOkOxI=;
 b=QUtjaxIemSd/6ggDXv7ERQd2VRS/r+vWS4SgZhv4EO+8reGgE9G9KkwGqutqoAQmfZHc8b5rhRmfXjIONVybjkcTYIaP4KidY+/ZF6q/WH8GApmZIndpzriDgpzn+dF2XTA9hYhZDLZIWsmh+XykCuSJu5ozDedLO0qeBSo5tBg=
Received: from CY1PR05MB2761.namprd05.prod.outlook.com (10.167.18.19) by
 CY1PR05MB2761.namprd05.prod.outlook.com (10.167.18.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.11; Thu, 14 Mar 2019 13:05:15 +0000
Received: from CY1PR05MB2761.namprd05.prod.outlook.com
 ([fe80::50:9d56:d444:62ec]) by CY1PR05MB2761.namprd05.prod.outlook.com
 ([fe80::50:9d56:d444:62ec%4]) with mapi id 15.20.1709.011; Thu, 14 Mar 2019
 13:05:15 +0000
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v4 19/46] tools/lib/traceevent: Man page for
 tep_list_events()
Thread-Topic: [PATCH v4 19/46] tools/lib/traceevent: Man page for
 tep_list_events()
Thread-Index: AQHU1bQO5msDM0e0o0+EI26u6J/QsKYJ2TyAgAFIZ4A=
Date:   Thu, 14 Mar 2019 13:05:15 +0000
Message-ID: <CACqStoe=hFZ4_bTa0kh=eqsLs8eZKS=9+Ku0EG-sjP3NoHZ6MA@mail.gmail.com>
References: <20190308133654.21264-1-tstoyanov@vmware.com>
 <20190308133654.21264-20-tstoyanov@vmware.com>
 <20190313132933.004e49d2@gandalf.local.home>
In-Reply-To: <20190313132933.004e49d2@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5PR04CA0002.eurprd04.prod.outlook.com
 (2603:10a6:206:1::15) To CY1PR05MB2761.namprd05.prod.outlook.com
 (2a01:111:e400:c63a::19)
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: APjAAAWPp3U/6ykC2aONSc1GLwqPy6X9YW3Ef3zLlcjZA2hpy/xJeip1
        87JL1z5ox9xSKSz9KEOFlYd/StlmJ0mfs/WsS6E=
x-google-smtp-source: APXvYqzoB/IfzXpBKD3fRkUVT2ej21ljSlUnxfzbTNJlUreLQAMajCzrC6/vDVPqY1iqNuxdkGjVKOA6ohWljCqhBkU=
x-received: by 2002:adf:f686:: with SMTP id v6mr14703450wrp.241.1552568708891;
 Thu, 14 Mar 2019 06:05:08 -0700 (PDT)
x-gmail-original-message-id: <CACqStoe=hFZ4_bTa0kh=eqsLs8eZKS=9+Ku0EG-sjP3NoHZ6MA@mail.gmail.com>
x-originating-ip: [209.85.221.50]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2ef6fb6d-69e8-4089-0d87-08d6a87db2ca
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:CY1PR05MB2761;
x-ms-traffictypediagnostic: CY1PR05MB2761:
x-microsoft-antispam-prvs: <CY1PR05MB2761D2517F6FF94BE7D28B09DC4B0@CY1PR05MB2761.namprd05.prod.outlook.com>
x-forefront-prvs: 09760A0505
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(376002)(396003)(366004)(346002)(39860400002)(189003)(199004)(66066001)(2906002)(478600001)(99286004)(95326003)(81156014)(498394004)(6436002)(6246003)(6512007)(53936002)(9686003)(6116002)(98316002)(8936002)(3846002)(6486002)(229853002)(68736007)(61726006)(81166006)(305945005)(7736002)(486006)(446003)(11346002)(476003)(186003)(97736004)(61266001)(6862004)(256004)(71200400001)(106356001)(105586002)(316002)(14444005)(8676002)(76176011)(26005)(55446002)(86362001)(25786009)(5660300002)(4326008)(4744005)(52116002)(6346003)(53546011)(386003)(6506007)(14454004)(102836004)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR05MB2761;H:CY1PR05MB2761.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tstoyanov@vmware.com; 
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: bMXlbZDw6Dtg65V7P5oHzv3p7tX1b+KLLfMGddSKAKBtyIHS2bxAlKDDELbW9tastbut0tl4+SgkEz3SpbYIMBXvapf/GkYkNwTBjeB5t97Nu+p4WDbxwQRDkUgd82OlssAAHVekcxio6IOK6UUZh7jVsz8XhWBH6r2NtYWe5B8NpsYjktXfD/Zv7OOxDpYbE6vbz+5MEgHjcvpWVIJZesm/w9WpmmAyaSz1IKkL+F8y6JQPZAlQbBpkbHkhUuLpFFaC+//I79lU2AWcNxR9J9Xxr5KWNgGNuQTWolsH55uJsXbeDhUKaDRCgo41jc583Zdoyb3+3jaluu6MixCYygTKVZcvQrLAQjF+MDv4Kf47bBIPwj2EPBWv/PJqJRJ7bMDO0gUmMqXAjwep4P8W/QFQdUu1AOjr/anrrd+wT8k=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6C0E64425C6EA0468F7F72079D2E9CB0@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ef6fb6d-69e8-4089-0d87-08d6a87db2ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Mar 2019 13:05:15.2296
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR05MB2761
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gV2VkLCBNYXIgMTMsIDIwMTkgYXQgNzoyOSBQTSBTdGV2ZW4gUm9zdGVkdCA8cm9zdGVkdEBn
b29kbWlzLm9yZz4gd3JvdGU6DQo+DQo+IE9uIEZyaSwgIDggTWFyIDIwMTkgMTU6MzY6MjcgKzAy
MDANCj4gVHp2ZXRvbWlyIFN0b3lhbm92IDx0c3RveWFub3ZAdm13YXJlLmNvbT4gd3JvdGU6DQo+
DQo+ID4gQ3JlYXRlIG1hbiBwYWdlIGZvciB0ZXBfbGlzdF9ldmVudHMoKSBhcyBwYXJ0IG9mIHRo
ZSBsaWJ0cmFjZWV2ZW50IEFQSXMuDQo+ID4NCj4NCj4gV2Ugc2hvdWxkIHByb2JhYmx5IGluY2x1
ZGUgdGVwX2xpc3RfZXZlbnRzX2NvcHkoKSBpbiB0aGlzIG1hbiBwYWdlLg0KPiBXaGVyZSBvbmUg
aXMgbm90IHRvIGJlIGZyZWVkLCBhbmQgdGhlIG90aGVyIGlzLg0KDQpJJ2xsIHVwZGF0ZSB0aGUg
bWFuIHBhZ2Ugb25jZSB3ZSBpbnRyb2R1Y2UgdGVwX2xpc3RfZXZlbnRzX2NvcHkoKSB0bw0KdG9v
bHMvbGliL3RyYWNlZXZlbnQsIGN1cnJlbnRseSB0aGlzIG5ldyBBUEkgaXMgcGFydCBvZiB0cmFj
ZS1jbWQgb25seS4NCg0KPg0KPiAtLSBTdGV2ZQ0KPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFR6dmV0
b21pciBTdG95YW5vdiA8dHN0b3lhbm92QHZtd2FyZS5jb20+DQo+ID4gLS0tDQo+ID4gIC4uLi9s
aWJ0cmFjZWV2ZW50LWV2ZW50X2xpc3QudHh0ICAgICAgICAgICAgICB8IDk0ICsrKysrKysrKysr
KysrKysrKysNCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDk0IGluc2VydGlvbnMoKykNCj4gPiAgY3Jl
YXRlIG1vZGUgMTAwNjQ0IHRvb2xzL2xpYi90cmFjZWV2ZW50L0RvY3VtZW50YXRpb24vbGlidHJh
Y2VldmVudC1ldmVudF9saXN0LnR4dA0KPiA+DQoNCg0KDQotLSANCg0KVHp2ZXRvbWlyIChDZWNv
KSBTdG95YW5vdg0KVk13YXJlIE9wZW4gU291cmNlIFRlY2hub2xvZ3kgQ2VudGVyDQo=
