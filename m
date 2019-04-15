Return-Path: <SRS0=14DL=SR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A6CBC282DA
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Apr 2019 15:20:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 046A12147C
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Apr 2019 15:20:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="Zf/kTUeW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727692AbfDOPU4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Apr 2019 11:20:56 -0400
Received: from mail-eopbgr800055.outbound.protection.outlook.com ([40.107.80.55]:52127
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727499AbfDOPU4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Apr 2019 11:20:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ra+8jztIdVYAVIQIRGZn6NPs7LtMl0YLMrdyIzogSJw=;
 b=Zf/kTUeWFZMiXKSwqRe/1Fva6FaF0YigmrSr4pbBGGnaBeJRPGQllzBN3x4bCkeXZbRMR+daRdIQjSePHduFOgcgIEPZXWfhWsEt++WSfqyepgpXWh/XjN9QPtqNIjEhABwEhOg0r2rHkbfnTgchG/HuPo+LWiRHSl65uSEBx54=
Received: from MWHPR0501MB3772.namprd05.prod.outlook.com (10.167.163.156) by
 MWHPR0501MB3740.namprd05.prod.outlook.com (10.167.163.148) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1813.8; Mon, 15 Apr 2019 15:20:53 +0000
Received: from MWHPR0501MB3772.namprd05.prod.outlook.com
 ([fe80::3949:85c0:3b7b:136e]) by MWHPR0501MB3772.namprd05.prod.outlook.com
 ([fe80::3949:85c0:3b7b:136e%5]) with mapi id 15.20.1813.009; Mon, 15 Apr 2019
 15:20:53 +0000
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>,
        "pauld@redhat.com" <pauld@redhat.com>,
        Yordan Karadzhov <ykaradzhov@vmware.com>,
        "jbacik@fb.com" <jbacik@fb.com>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>
Subject: Re: [PATCH 1/2] trace-cmd: Optimize how pid filters are expressed
Thread-Topic: [PATCH 1/2] trace-cmd: Optimize how pid filters are expressed
Thread-Index: AQHU852540PvyPUfdkKFujmy7POQ2Q==
Date:   Mon, 15 Apr 2019 15:20:53 +0000
Message-ID: <CAE0o1NvteO9GP15qdy9BWqUu8LFBvNEKsz4fP5qmDPLcmPcf5g@mail.gmail.com>
References: <20190415104343.31113-1-kaslevs@vmware.com>
 <20190415104343.31113-2-kaslevs@vmware.com>
In-Reply-To: <20190415104343.31113-2-kaslevs@vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: DM6PR06CA0019.namprd06.prod.outlook.com
 (2603:10b6:5:120::32) To MWHPR0501MB3772.namprd05.prod.outlook.com
 (2603:10b6:301:7a::28)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kaslevs@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: APjAAAXhbkGXyg9KcNUjdb5vpMgH37VJ62h6wqPlxcw3IfaXpAtNMV1M
        7SD5/CntrkoIlPO8aeKOWc0AlEVweSpHVbOReA==
x-google-smtp-source: APXvYqyObF6lw42j+vS0r+638xGtIyHGw1LQjrL2A5sig2lAwu69mu1NRNbT7U0axh2I2AQZS6dxQw+KO1n/oSJ57NU=
x-received: by 2002:a5e:a51a:: with SMTP id 26mr13475158iog.254.1555341245236;
 Mon, 15 Apr 2019 08:14:05 -0700 (PDT)
x-gmail-original-message-id: <CAE0o1NvteO9GP15qdy9BWqUu8LFBvNEKsz4fP5qmDPLcmPcf5g@mail.gmail.com>
x-originating-ip: [209.85.166.45]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: edbc6e1e-bd02-4f0d-c664-08d6c1b5f35f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600140)(711020)(4605104)(2017052603328)(7193020);SRVR:MWHPR0501MB3740;
x-ms-traffictypediagnostic: MWHPR0501MB3740:
x-microsoft-antispam-prvs: <MWHPR0501MB3740FA404276BD4BDC0D53D9DA2B0@MWHPR0501MB3740.namprd05.prod.outlook.com>
x-forefront-prvs: 000800954F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(39860400002)(136003)(396003)(346002)(376002)(189003)(199004)(52116002)(5660300002)(68736007)(6246003)(66066001)(229853002)(54206008)(476003)(81166006)(81156014)(55446002)(4744005)(256004)(9686003)(6512007)(478600001)(107886003)(71200400001)(53936002)(71190400001)(498394004)(4326008)(305945005)(14444005)(6436002)(61266001)(6862004)(186003)(86362001)(6486002)(76176011)(99286004)(54906003)(61726006)(316002)(486006)(6116002)(3846002)(26005)(25786009)(7736002)(8936002)(8676002)(446003)(11346002)(386003)(6506007)(95326003)(14454004)(53546011)(102836004)(97736004)(106356001)(105586002)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR0501MB3740;H:MWHPR0501MB3772.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: NDbtaAZEeesehKQ1syyBob06ilpyGM/M18MB+kbLyD+np6G4NMw7VsUOA4Rh8UMMr60GqapVgP6yTNzlJu82HY1DGMnxldqEBfSTbizwJ5MhHlZuG3Vab/t+oZYCBR2F2nCnUDgZCCwWsgKiIGii6MqWvgtzNQOwVgqEoBoorgcO7pkTlc/+9XqQthyFZVTpjSaZQ95A0PPJszXK+dpvs033fATtjXYBIy269rdIkc5UKbKAsdsipP/Q+LreNVznrtYgndpEWFTjHEJf/FNfVPELzvtuzngOhwJagxAQzNeDmCr2NfoRzTYW+DCxcRmQQ1DqLtsPp3L3kvX6oZJZxLHNbU3Lzd2jn0NfwoNUYwPJKAKlUQzzABn7vtqRnv5U/o1mZmTXhNMj2MBokIF88p4VJaWdghah6ywXaaJkPnw=
Content-Type: text/plain; charset="utf-8"
Content-ID: <13429B8EFA817E4AA8F2769723E33ACE@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edbc6e1e-bd02-4f0d-c664-08d6c1b5f35f
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2019 15:20:53.7906
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0501MB3740
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gTW9uLCBBcHIgMTUsIDIwMTkgYXQgMTo0MyBQTSBTbGF2b21pciBLYXNsZXYgPGthc2xldnNA
dm13YXJlLmNvbT4gd3JvdGU6DQo+DQo+IEV4cHJlc3MgcGlkIGZpbHRlcnMgYXMgYWxsb3dlZC9k
aXNhbGxvd2VkIGZpbHRlciByYW5nZXMNCj4NCj4gICAocGlkPj0xMDAmJnBpZDw9MTAzKQ0KPg0K
PiBpbnN0ZWFkIG9mIHNwZWNpZnlpbmcgdGhlbSBwZXIgcGlkDQo+DQo+ICAgKHBpZD09MTAwfHxw
aWQ9PTEwMXx8cGlkPT0xMDJ8fHBpZD09MTAzKQ0KPg0KPiBUaGlzIG1ha2VzIHRoZSBzaXplIG9m
IHRoZSByZXN1bHRpbmcgZmlsdGVyIHNtYWxsZXIgKGFuZCBmYXN0ZXIpIGFuZCBhdm9pZHMNCj4g
b3ZlcmZsb3dpbmcgdGhlIGZpbHRlciBzaXplIGxpbWl0IG9mIG9uZSBwYWdlIHdoaWNoIHdlIGNh
biBoaXQgb24gYmlnZ2VyDQo+IG1hY2hpbmVzIChzYXkgPjE2MCBDUFVzKS4NCj4NCj4gU2lnbmVk
LW9mZi1ieTogU2xhdm9taXIgS2FzbGV2IDxrYXNsZXZzQHZtd2FyZS5jb20+DQoNCkkgbWlzc2Vk
IHRvIGFkZCBzb21lIHRhZ3M6DQoNClJlcG9ydGVkLWJ5OiBQaGlsIEF1bGQgPHBhdWxkQHJlZGhh
dC5jb20+DQpTdWdnZXN0ZWQtYnk6IFN0ZXZlbiBSb3N0ZWR0IChWTXdhcmUpIDxyb3N0ZWR0QGdv
b2RtaXMub3JnPg0KDQotLSBTbGF2aQ0K
