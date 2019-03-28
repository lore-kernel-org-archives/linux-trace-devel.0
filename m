Return-Path: <SRS0=2HUR=R7=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5946C43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Mar 2019 12:47:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66A99206B8
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Mar 2019 12:47:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="Edhf3eqD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbfC1MrZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Mar 2019 08:47:25 -0400
Received: from mail-eopbgr800053.outbound.protection.outlook.com ([40.107.80.53]:11813
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726173AbfC1MrY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Mar 2019 08:47:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mLYDtx4itRVVBZ1wucNk2y8U1HVfqXrnTKF7ool89GM=;
 b=Edhf3eqD/7LRELZpgLk9CKfGJbMHzG8gii7SKJlTN4eMSwYkru6g/TO3znkFkCkHniqLheV6X6mvuXo10ZDgYGfBn7IFcflVVlyMHQvLBaoFEavRc3/l6rRuPkDQnzgaYZA6cZ4d/HZ6XuO42QpOjbRnZIarF2wGWjHD2i4mUCo=
Received: from MWHPR0501MB3772.namprd05.prod.outlook.com (10.167.163.156) by
 MWHPR0501MB3771.namprd05.prod.outlook.com (10.167.163.155) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1750.13; Thu, 28 Mar 2019 12:47:21 +0000
Received: from MWHPR0501MB3772.namprd05.prod.outlook.com
 ([fe80::b9a6:ba16:fc53:bb41]) by MWHPR0501MB3772.namprd05.prod.outlook.com
 ([fe80::b9a6:ba16:fc53:bb41%5]) with mapi id 15.20.1771.007; Thu, 28 Mar 2019
 12:47:21 +0000
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     Yordan Karadzhov <ykaradzhov@vmware.com>
CC:     Steven Rostedt <rostedt@goodmis.org>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: Re: [RFC 7/7] kernel-shark: Add basic example demonstrating the NumPy
 interface
Thread-Topic: [RFC 7/7] kernel-shark: Add basic example demonstrating the
 NumPy interface
Thread-Index: AQHU5WRZftAUGyN58UyMwSeXlygv5Q==
Date:   Thu, 28 Mar 2019 12:47:21 +0000
Message-ID: <CAE0o1Nuqxs4QarqWnTC_0J2bnR62vSYLMvnSKTxkWGUeZyP3_w@mail.gmail.com>
References: <20190327160323.31654-1-ykaradzhov@vmware.com>
 <20190327160323.31654-8-ykaradzhov@vmware.com>
In-Reply-To: <20190327160323.31654-8-ykaradzhov@vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: YTXPR0101CA0013.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b00::26) To MWHPR0501MB3772.namprd05.prod.outlook.com
 (2603:10b6:301:7a::28)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kaslevs@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: APjAAAXgEL4+oUfoXPw8RhkZL/Dnn6kW2syr4HUwuEC4UJJnScEQS5Ef
        J6W3f0XTZcWP2X2EYnMOoUTs0XoQart85NgB/Q==
x-google-smtp-source: APXvYqyQY+knbdk78PeJpbDrLAyrkD2H6vRru6SBvyS5ZWNyfL/lg6lA59CoqEnhJolsaM5Pcb7Zjj8Qh9sgTeCYqMA=
x-received: by 2002:a5e:9e02:: with SMTP id i2mr31070715ioq.238.1553777237723;
 Thu, 28 Mar 2019 05:47:17 -0700 (PDT)
x-gmail-original-message-id: <CAE0o1Nuqxs4QarqWnTC_0J2bnR62vSYLMvnSKTxkWGUeZyP3_w@mail.gmail.com>
x-originating-ip: [209.85.166.45]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9816f82b-fe69-4d86-8e4b-08d6b37b84d9
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:MWHPR0501MB3771;
x-ms-traffictypediagnostic: MWHPR0501MB3771:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MWHPR0501MB3771313CBD910579EDD6A940DA590@MWHPR0501MB3771.namprd05.prod.outlook.com>
x-forefront-prvs: 0990C54589
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(366004)(39860400002)(136003)(396003)(199004)(189003)(99286004)(106356001)(305945005)(6436002)(6636002)(8936002)(6862004)(25786009)(107886003)(55446002)(9686003)(86362001)(54906003)(6512007)(61726006)(26005)(6506007)(486006)(11346002)(6246003)(478600001)(81156014)(81166006)(95326003)(316002)(105586002)(476003)(966005)(446003)(7736002)(8676002)(6306002)(14454004)(4326008)(53936002)(6116002)(66066001)(3846002)(229853002)(14444005)(2906002)(498394004)(68736007)(256004)(386003)(5660300002)(52116002)(6486002)(4744005)(97736004)(53546011)(71200400001)(71190400001)(61266001)(76176011)(102836004)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR0501MB3771;H:MWHPR0501MB3772.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ImbJIwy/JrqAfxwP6/OdTgmwHZtAeOvPrUfZtTetbG59hdqkh/2VNkT2ERdB9vAvvy8LvhgPd530dA64c3wT6w+iOB1zVJPQwZYVChJL15V64pvcybv8+GO4ASCKEHjWrsI+L1tMhH00qYkxx/+6oC/lN6A1S2uVWnNaYSKnMa42kRbe29M/+IuzZr3xKWvRyzg3fs/zGxcKdfiVVrvQ3rNqEvDTnTonE+cBMn+CA+zvSxPxfM/w5t2sJ9U4AkExhsS+tSXVUR9awopZvqObW66ows/PYzB4JJo0Y5S/w4wHJkTSEZEJY/jBRNsONFV6tlblhDD8zrxhyi/v1MQQGysW5ohJ7hSPVTWzF0WNy5sF+ZVz8FNrAvQ0cpMhrpBRclDyV8ZSiBenClMv8oQisUm+VN1/f5+AfohIzvU7RZE=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7BF473F7D8DD22488D216AE10220E4F2@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9816f82b-fe69-4d86-8e4b-08d6b37b84d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2019 12:47:21.4516
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0501MB3771
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gV2VkLCBNYXIgMjcsIDIwMTkgYXQgNjowNCBQTSBZb3JkYW4gS2FyYWR6aG92IDx5a2FyYWR6
aG92QHZtd2FyZS5jb20+IHdyb3RlOg0KWy4uLl0NCj4gZGlmZiAtLWdpdCBhL2tlcm5lbC1zaGFy
ay9iaW4vc2NoZWRfd2FrZXVwLnB5IGIva2VybmVsLXNoYXJrL2Jpbi9zY2hlZF93YWtldXAucHkN
Cg0KWy4uLl0NCg0KPiAra3Mub3Blbl9maWxlKGZuYW1lKQ0KPiArb2ZzdCwgY3B1LCBldnQsIHBp
ZCwgdHMgPSBrcy5sb2FkX2RhdGEoKQ0KDQpSZXR1cm5pbmcgYSB0dXBsZSBvZiA1IG51bXB5IGFy
cmF5cyBhcyBBUEkgd2lsbCBiZSBpbXBvc3NpYmxlIHRvDQpleHRlbmQgaW4gdGhlIGZ1dHVyZSB3
aXRob3V0IGJyZWFraW5nIGV4aXN0aW5nIGNvZGUuIEl0J3MgYWxzbyBlYXN5DQpmb3IgdXNlcnMg
dG8gZ2V0IHRoZSBvcmRlciBvZiB0aGUgcmV0dXJuIHZhbHVlcyB3cm9uZy4gSGF2ZSB5b3UNCnRo
b3VnaHQgb2YgcmV0dXJuaW5nIGEgY29udGFpbmVyIG9iamVjdCB0aGF0J3MgaG9sZGluZyB0aGUg
bnVtcHkNCmFycmF5cz8gUGFuZGFzIERhdGFGcmFtZVsxXSBjb21lcyB0byBtaW5kIGFsdGhvdWdo
IEkgZG9uJ3Qga25vdyBpZg0KaXQncyB3b3J0aCB0byB0YWtlIFBhbmRhcyBhcyBkZXBlbmRlbmN5
IGZvciB0aGlzLg0KDQpbMV0gaHR0cHM6Ly9wYW5kYXMucHlkYXRhLm9yZy9wYW5kYXMtZG9jcy92
ZXJzaW9uLzAuMjMuNC9nZW5lcmF0ZWQvcGFuZGFzLkRhdGFGcmFtZS5odG1sDQoNCi0tIFNsYXZp
DQo=
