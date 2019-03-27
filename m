Return-Path: <SRS0=8Y6V=R6=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45082C43381
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Mar 2019 23:41:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 087892075E
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Mar 2019 23:41:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="EIkUqG/o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731274AbfC0XlS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 27 Mar 2019 19:41:18 -0400
Received: from mail-eopbgr720086.outbound.protection.outlook.com ([40.107.72.86]:44295
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725601AbfC0XlS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 27 Mar 2019 19:41:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yM6l/ttZ8f3lCPM7eDatiyWEJy7+Lyqx/HOblsUkvb0=;
 b=EIkUqG/o8WOQSd763SnOkObi0hkzH2Pp2IjXhJvnU77bFiU1IOF09pMTUmEQpduUX71/rNaJ5bGaCvx5d6F/BuHx+0e65pTekkmveeg33LvMIz5HmSYYhxvW/n9kO/+RlR+b9HvQvhG53ASu7OKO8EYcXV5ylvKyh/QHyzinCxY=
Received: from MWHPR0501MB3772.namprd05.prod.outlook.com (10.167.163.156) by
 MWHPR0501MB3689.namprd05.prod.outlook.com (10.167.163.35) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1771.6; Wed, 27 Mar 2019 23:41:13 +0000
Received: from MWHPR0501MB3772.namprd05.prod.outlook.com
 ([fe80::b9a6:ba16:fc53:bb41]) by MWHPR0501MB3772.namprd05.prod.outlook.com
 ([fe80::b9a6:ba16:fc53:bb41%5]) with mapi id 15.20.1750.010; Wed, 27 Mar 2019
 23:41:13 +0000
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     Yordan Karadzhov <ykaradzhov@vmware.com>
CC:     Steven Rostedt <rostedt@goodmis.org>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: Re: [RFC 2/7] kernel-shark: Add new dataloading method to be used by
 the NumPu interface
Thread-Topic: [RFC 2/7] kernel-shark: Add new dataloading method to be used by
 the NumPu interface
Thread-Index: AQHU5PZuJG14FfPUT0eOsoi1XHGl5g==
Date:   Wed, 27 Mar 2019 23:41:13 +0000
Message-ID: <CAE0o1NsYsBkHbapChkA_CjB__Qn4V_K-2FD23-H9jYbVsiPQgw@mail.gmail.com>
References: <20190327160323.31654-1-ykaradzhov@vmware.com>
 <20190327160323.31654-3-ykaradzhov@vmware.com>
In-Reply-To: <20190327160323.31654-3-ykaradzhov@vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: DM5PR0102CA0015.prod.exchangelabs.com (2603:10b6:4:9c::28)
 To MWHPR0501MB3772.namprd05.prod.outlook.com (2603:10b6:301:7a::28)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kaslevs@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: APjAAAUrQpS9yJhj/ORZGYc26TV4/3bAhNaLO2zcmVTQfMS/AUN1S4/s
        6ZcZU9r0YxZkGmtNiKVS3vPtU+rDlneOq5I7ew==
x-google-smtp-source: APXvYqxghTkP+98g1kuJhwvikMw2YyzBx9aTW5Krd4RUpkwreHfMeZQHzC28wfLDTzNIlgi3zjBXqCEeqtxAgG70P+E=
x-received: by 2002:a24:7d04:: with SMTP id b4mr5617749itc.73.1553730028039;
 Wed, 27 Mar 2019 16:40:28 -0700 (PDT)
x-gmail-original-message-id: <CAE0o1NsYsBkHbapChkA_CjB__Qn4V_K-2FD23-H9jYbVsiPQgw@mail.gmail.com>
x-originating-ip: [209.85.166.170]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 44bcdf92-c681-4325-fe8c-08d6b30db25d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:MWHPR0501MB3689;
x-ms-traffictypediagnostic: MWHPR0501MB3689:
x-microsoft-antispam-prvs: <MWHPR0501MB3689A4D97D9960BBC9A88BBDDA580@MWHPR0501MB3689.namprd05.prod.outlook.com>
x-forefront-prvs: 0989A7979C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(366004)(346002)(376002)(136003)(39850400004)(189003)(199004)(229853002)(6246003)(6512007)(6486002)(6436002)(53936002)(25786009)(106356001)(316002)(5660300002)(8676002)(6862004)(4326008)(107886003)(8936002)(7736002)(81166006)(305945005)(81156014)(61726006)(9686003)(55446002)(6636002)(105586002)(61266001)(498394004)(66066001)(68736007)(80366005)(478600001)(6116002)(3846002)(6506007)(386003)(26005)(53546011)(52116002)(186003)(2906002)(76176011)(102836004)(97736004)(95326003)(86362001)(14454004)(99286004)(71190400001)(256004)(54906003)(14444005)(71200400001)(4744005)(11346002)(486006)(476003)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR0501MB3689;H:MWHPR0501MB3772.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: HwgOGFngALLTrql6QwI4ECPmWVsyqqBiR+/kja8r2u2AecHFjuTlyffBf8QK7N+la+MgmS5Qui4OTrnJX2Siz+3kijROSD1GEPOIqUZP1aZ6y3uBZWXF0NVmo9jf/tVvw6mUYW6d5jaKCJ5rclX1KuGTuWGgvYdAZJyZlHvl/FXoiZivCTgOAExrAe7/Mxkld6WWdkHMpgXmj/PFhHblV2jsj0VNBOqAPN8/TFAWZg36x2ZzY1+2zaG/GCZTsUbDT5r8ONW0+cR3GzIKcR7P8d5qSr5zDFA112SHSE+rsXWRz80FSi2IHEhZOhkXfLsTyY2CjxF6fZqfNXTzj0VsHTnZYXmbkBp+TNd/Gf6vMwIsItMUkBsHQbkUALq/nsuyg0suCwgMiRcCrIl8wDSECfehRTeUZb/ujHNYCTQHve8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <92350B9E1D1CC342901FEC0DEE9CDED6@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44bcdf92-c681-4325-fe8c-08d6b30db25d
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Mar 2019 23:41:13.0897
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0501MB3689
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gV2VkLCBNYXIgMjcsIDIwMTkgYXQgNjowNCBQTSBZb3JkYW4gS2FyYWR6aG92IDx5a2FyYWR6
aG92QHZtd2FyZS5jb20+IHdyb3RlOg0KPHNuaXA+DQo+ICsgICAgICAgaWYgKG9mZnNldF9hcnJh
eSkNCj4gKyAgICAgICAgICAgICAgIGZyZWUob2Zmc2V0X2FycmF5KTsNCg0KVGhpcyBzaG91bGQg
YmUNCiAgICBmcmVlKCpvZmZzZXRfYXJyYXkpOw0KYW5kIGRpdHRvIGZvciB0aGUgcmVzdC4NCg0K
QWxzbyBpbiB0aGUgdmVyeSB1bmxpa2VseSBldmVudCBvZiBtYWxsb2MoKSBmYWlsaW5nLCBpZiB0
aGUgY2FsbGVyDQpkaWRuJ3QgaW5pdGlhbGl6ZSB0aGUgYXJndW1lbnRzIGJlZm9yZSBjYWxsaW5n
LCB0aGlzIHdpbGwgYmUgY2FsbGluZw0KZnJlZSgpIHdpdGggZ2FyYmFnZS4gSWYgd2UncmUgcGFy
YW5vaWQgZm9yIHRoaXMgY2FzZSwgd2UgY2FuIGVpdGhlcg0KMSkgaGF2ZSBOVUxMIGluaXRpYWxp
emVkIGxvY2FsIHZhcmlhYmxlcyB3aGVyZSB3ZSBtYWxsb2MoKSBhbmQgb24NCmZhaWx1cmUgZnJl
ZSgpLCBvciBvbiBzdWNjZXNzIGFzc2lnbiB0byB0aGUgb3V0cHV0IGFyZ3VtZW50cw0KMikgaGF2
ZSBhIHNlcGFyYXRlIGxhYmVsIGZvciBlYWNoIG1hbGxvYygpIGZhaWx1cmUgY2FzZSBhbmQganVt
cCB0bw0KdGhlIGNvcnJlY3QgbGFiZWwgd2hlbiBtYWxsb2MoKSBmYWlscw0KDQotLSBTbGF2aQ0K
