Return-Path: <SRS0=vzsu=RW=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 769E3C43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Mar 2019 17:59:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 24A68206B7
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Mar 2019 17:59:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="m3uZJOPz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbfCSR7B (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 19 Mar 2019 13:59:01 -0400
Received: from mail-eopbgr820045.outbound.protection.outlook.com ([40.107.82.45]:15975
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727154AbfCSR7B (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 19 Mar 2019 13:59:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RTRPvTX9Ha79+MRHBs4e1zz2K7vwG5zbVY6JXs3YLxM=;
 b=m3uZJOPzaRXzkrrQFwmwEksfKiQ4tNtaKRmSOECsh1hAhh9zy21YiYWpKkwOijMwlj2xXX84l/riqqTYF3SS+m5svo3bGOP92/wACQiJRizAgvl5zD5zLzlHd5eDVkg4qW0SqI9M55EG5hraXOplzJ2qCw93blPidkq5Obbzepc=
Received: from CY1PR05MB2780.namprd05.prod.outlook.com (10.167.18.26) by
 CY1PR05MB2747.namprd05.prod.outlook.com (10.167.18.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.16; Tue, 19 Mar 2019 17:58:57 +0000
Received: from CY1PR05MB2780.namprd05.prod.outlook.com
 ([fe80::7cc5:3b5d:2c2c:d84f]) by CY1PR05MB2780.namprd05.prod.outlook.com
 ([fe80::7cc5:3b5d:2c2c:d84f%9]) with mapi id 15.20.1730.003; Tue, 19 Mar 2019
 17:58:57 +0000
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
CC:     Steven Rostedt <rostedt@goodmis.org>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v7 8/9] trace-cmd: Implemented new option in trace.dat
 file: TRACECMD_OPTION_TIME_SHIFT
Thread-Topic: [PATCH v7 8/9] trace-cmd: Implemented new option in trace.dat
 file: TRACECMD_OPTION_TIME_SHIFT
Thread-Index: AQHU3n1hRor0llK3QEma5p5smYUNLA==
Date:   Tue, 19 Mar 2019 17:58:57 +0000
Message-ID: <CAE0o1Nv1COcadtf2roP1aVDSE-ABCeiYiS6-1U3dXycHBrUytQ@mail.gmail.com>
References: <20190319155536.19381-1-tstoyanov@vmware.com>
 <20190319155536.19381-9-tstoyanov@vmware.com>
In-Reply-To: <20190319155536.19381-9-tstoyanov@vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: YQXPR0101CA0030.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c00:15::43) To CY1PR05MB2780.namprd05.prod.outlook.com
 (2a01:111:e400:c63a::26)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kaslevs@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: APjAAAULUPr8wEzBAqqGdGQUj+/bthfdCFBaqmXYaV1GkkDchnD/Fpnp
        Fd3wSxwQfBbXK7sBtVFu2qJMkPnfS3kfN4s8gw==
x-google-smtp-source: APXvYqw47eK1jmcwinZfvWBaBuUeLsFcvN0U9WkcaUdjA3NKyZB13fusD9uV9Ib64vdKckweveZX1KQeh2EMNhehgds=
x-received: by 2002:a5e:9e02:: with SMTP id i2mr2537743ioq.238.1553018332732;
 Tue, 19 Mar 2019 10:58:52 -0700 (PDT)
x-gmail-original-message-id: <CAE0o1Nv1COcadtf2roP1aVDSE-ABCeiYiS6-1U3dXycHBrUytQ@mail.gmail.com>
x-originating-ip: [209.85.166.50]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 093a1bf9-9533-41ff-c65b-08d6ac948ecd
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:CY1PR05MB2747;
x-ms-traffictypediagnostic: CY1PR05MB2747:
x-microsoft-antispam-prvs: <CY1PR05MB2747D156BB62A2DF00EF5E5CDA400@CY1PR05MB2747.namprd05.prod.outlook.com>
x-forefront-prvs: 0981815F2F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(136003)(346002)(376002)(366004)(396003)(199004)(189003)(305945005)(256004)(229853002)(86362001)(14444005)(71200400001)(6246003)(106356001)(68736007)(25786009)(105586002)(6512007)(7736002)(8676002)(498394004)(53936002)(9686003)(81156014)(5660300002)(81166006)(71190400001)(6486002)(6436002)(2906002)(66066001)(3846002)(11346002)(54906003)(97736004)(476003)(76176011)(8936002)(61266001)(52116002)(99286004)(486006)(6116002)(6636002)(386003)(14454004)(53546011)(102836004)(446003)(55446002)(478600001)(6506007)(4326008)(6862004)(95326003)(186003)(61726006)(26005)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR05MB2747;H:CY1PR05MB2780.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: jikhbmxqZ5X1LNghx+hbUb+2vASFLJr642NXrma/uICr1Ua7tClSkQPJeLrMPK7S/5tOYzN2qwouIIaU8YwJV65uzPfEM9AaffPUVQqNmvAl6ZZw3gfj/D4PFPuDlTKRPZueqFz6W9R9WxGxcrMbZhnO8K0Kco61FnHXj8dcptR2TO/WH2piSGr5L2a397LnKrYNe8n91Ll0IS+t/xKHoG8Zga6pgzgoqHcuJ7f0ZekAFqB5CSMmj33ohlcjg5ykbMdgPvuMZHJPB2w/4ThmIvxXcS3N41A4fECPWkLypCpTnX9Ezxe+pBPjOTa6L8miKIOXD1R8PilIjpfGSE213LucHPeXAkLgELxoR6zHGODB148rTR5LFXDzEbO6MK9umb8AmtXHf8SObRlq1Fx241I+ySdOObyJjwApRHr7dRw=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9D3402216B094E418A6E94308A18D92C@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 093a1bf9-9533-41ff-c65b-08d6ac948ecd
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Mar 2019 17:58:57.2793
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR05MB2747
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gVHVlLCBNYXIgMTksIDIwMTkgYXQgNTo1NiBQTSBUenZldG9taXIgU3RveWFub3YgPHRzdG95
YW5vdkB2bXdhcmUuY29tPiB3cm90ZToNCj4gK3N0YXRpYyB1bnNpZ25lZCBsb25nIGxvbmcgdGlt
ZXN0YW1wX2NvcnJlY3QodW5zaWduZWQgbG9uZyBsb25nIHRzLA0KPiArICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIHN0cnVjdCB0cmFjZWNtZF9pbnB1dCAqaGFuZGxl
KQ0KPiArew0KPiArICAgICAgIGludCBtaW4sIG1pZCwgbWF4Ow0KPiArDQo+ICsgICAgICAgaWYg
KGhhbmRsZS0+dHNfb2Zmc2V0KQ0KPiArICAgICAgICAgICAgICAgcmV0dXJuIHRzICsgaGFuZGxl
LT50c19vZmZzZXQ7DQo+ICsgICAgICAgaWYgKCFoYW5kbGUtPnRzX2NvcnJfY291bnQgfHwgIWhh
bmRsZS0+dHNfY29ycikNCj4gKyAgICAgICAgICAgICAgIHJldHVybiB0czsNCj4gKw0KPiArICAg
ICAgIC8qIFdlIGhhdmUgb25lIHNhbXBsZSwgbm90aGluZyB0byBjYWxjIGhlcmUgKi8NCj4gKyAg
ICAgICBpZiAoaGFuZGxlLT50c19jb3JyX2NvdW50ID09IDEpDQo+ICsgICAgICAgICAgICAgICBy
ZXR1cm4gdHMgKyBoYW5kbGUtPnRzX2NvcnJbMF0ub2Zmc2V0Ow0KPiArDQo+ICsgICAgICAgLyog
V2UgaGF2ZSB0d28gc2FtcGxlcywgbm90aGluZyB0byBzZWFyY2ggaGVyZSAqLw0KPiArICAgICAg
IGlmIChoYW5kbGUtPnRzX2NvcnJfY291bnQgPT0gMikNCj4gKyAgICAgICAgICAgICAgIHJldHVy
biB0aW1lc3RhbXBfY29ycmVjdGlvbl9jYWxjKHRzLCAmaGFuZGxlLT50c19jb3JyWzBdLA0KPiAr
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgJmhhbmRsZS0+
dHNfY29yclsxXSk7DQo+ICsNCj4gKyAgICAgICAvKiBXZSBoYXZlIG1vcmUgdGhhbiB0d28gc2Ft
cGxlcyAqLw0KPiArICAgICAgIG1pbiA9IDA7DQo+ICsgICAgICAgbWF4ID0gaGFuZGxlLT50c19j
b3JyX2NvdW50LTE7DQo+ICsgICAgICAgbWlkID0gKG1pbiArIG1heCkvMjsNCj4gKyAgICAgICB3
aGlsZSAobWluIDw9IG1heCkgew0KPiArICAgICAgICAgICAgICAgaWYgKHRzID49IGhhbmRsZS0+
dHNfY29yclttaWRdLnRpbWUgJiYNCj4gKyAgICAgICAgICAgICAgICAgICAobWlkID09IGhhbmRs
ZS0+dHNfY29ycl9jb3VudC0xIHx8DQo+ICsgICAgICAgICAgICAgICAgICAgIHRzIDwgaGFuZGxl
LT50c19jb3JyW21pZCsxXS50aW1lKSkNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgYnJlYWs7
DQo+ICsgICAgICAgICAgICAgICBpZiAodHMgPCBoYW5kbGUtPnRzX2NvcnJbbWlkXS50aW1lKSB7
DQo+ICsgICAgICAgICAgICAgICAgICAgICAgIGlmIChtaWQgPT0gMCkNCj4gKyAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICBicmVhazsNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgbWlu
ID0gbWlkLTE7DQo+ICsgICAgICAgICAgICAgICB9IGVsc2UgaWYgKHRzID49IGhhbmRsZS0+dHNf
Y29yclttaWQrMV0udGltZSkNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgbWF4ID0gbWlkICsg
MTsNCj4gKyAgICAgICAgICAgICAgIG1pZCA9IChtaW4gKyBtYXgpLzI7DQo+ICsgICAgICAgfQ0K
PiArDQo+ICsgICAgICAgaWYgKG1pZCA+PSBoYW5kbGUtPnRzX2NvcnJfY291bnQtMikNCj4gKyAg
ICAgICAgICAgICAgIHJldHVybiB0aW1lc3RhbXBfY29ycmVjdGlvbl9jYWxjKHRzLCAmaGFuZGxl
LT50c19jb3JyW2hhbmRsZS0+dHNfY29ycl9jb3VudC0yXSwNCj4gKyAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICZoYW5kbGUtPnRzX2NvcnJbaGFuZGxlLT50
c19jb3JyX2NvdW50LTFdKTsNCj4gKw0KPiArICAgICAgIHJldHVybiB0aW1lc3RhbXBfY29ycmVj
dGlvbl9jYWxjKHRzLCAmaGFuZGxlLT50c19jb3JyW21pZF0sDQo+ICsgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgJmhhbmRsZS0+dHNfY29yclttaWQrMV0pOw0KDQpXZSBj
YW4gaGFuZGxlIHRoZSBlZGdlIGNhc2VzIGZpcnN0ICh0cyBpcyBvdXQgb2YgcmFuZ2UpIHdoaWNo
IHdvdWxkDQpzaW1wbGlmeSB0aGUgc2VhcmNoLiBTb21ldGhpbmcgbGlrZSAodW50ZXN0ZWQpOg0K
DQogICAgaWYgKHRzIDw9IGhhbmRsZS0+dHNfY29yclswXSkgew0KICAgICAgICAgICAgICAgICAg
IHJldHVybiB0aW1lc3RhbXBfY29ycmVjdGlvbl9jYWxjKHRzLA0KJmhhbmRsZS0+dHNfY29yclsw
XSwgJmhhbmRsZS0+dHNfY29yclsxXSk7DQogICAgfSBlbHNlIGlmICh0cyA+PSBoYW5kbGUtPnRz
X2NvcnJbaGFuZGxlLT50c19jb3JyX2NvdW50LTFdKSB7DQogICAgICAgICAgICAgICAgICAgcmV0
dXJuIHRpbWVzdGFtcF9jb3JyZWN0aW9uX2NhbGModHMsDQomaGFuZGxlLT50c19jb3JyW2hhbmRs
ZS0+dHNfY29ycl9jb3VudC0yXSwNCiZoYW5kbGUtPnRzX2NvcnJbaGFuZGxlLT50c19jb3JyX2Nv
dW50LTFdKTsNCiAgICB9DQoNCiAgICBtaW4gPSAwOw0KICAgIG1heCA9IGhhbmRsZS0+dHNfY29y
cl9jb3VudC0xOw0KICAgIG1pZCA9IChtaW4gKyBtYXgpIC8gMjsNCiAgICB3aGlsZSAobWluIDw9
IG1heCkgew0KICAgICAgICAgICAgIGlmICh0cyA8IGhhbmRsZS0+dHNfY29yclttaWRdLnRpbWUp
DQogICAgICAgICAgICAgICAgICAgIG1pbiA9IG1pZCAtIDE7DQogICAgICAgICAgICAgZWxzZSBp
ZiAodHMgPiBoYW5kbGUtPnRzX2NvcnJbbWlkXS50aW1lKQ0KICAgICAgICAgICAgICAgICAgIG1h
eCA9IG1pZCArIDE7DQogICAgICAgICAgICAgZWxzZQ0KICAgICAgICAgICAgICAgICAgIGJyZWFr
Ow0KICAgICAgICAgICAgIG1pZCA9IChtaW4gKyBtYXgpIC8gMjsNCiAgICAgIH0NCiAgICAgIHJl
dHVybiB0aW1lc3RhbXBfY29ycmVjdGlvbl9jYWxjKHRzLCAmaGFuZGxlLT50c19jb3JyW21pZF0s
DQomaGFuZGxlLT50c19jb3JyW21pZCsxXSk7DQoNClRvbyBiYWQgdGhlcmUncyBubyBsb3dlcl9i
b3VuZCgpIGluIGxpYmMgYW5kIGJzZWFyY2goKSBkb2Vzbid0IHF1aXRlDQpjdXQgaXQgaGVyZS4N
Cg0KPiArfQ0KPiArDQo+ICAvKg0KPiAgICogUGFnZSBpcyBtYXBwZWQsIG5vdyByZWFkIGluIHRo
ZSBwYWdlIGhlYWRlciBpbmZvLg0KPiAgICovDQo+IEBAIC0xMDQ5LDcgKzExMTYsNyBAQCBzdGF0
aWMgaW50IHVwZGF0ZV9wYWdlX2luZm8oc3RydWN0IHRyYWNlY21kX2lucHV0ICpoYW5kbGUsIGlu
dCBjcHUpDQo+ICAgICAgICAgICAgICAgICAgICAga2J1ZmZlcl9zdWJidWZmZXJfc2l6ZShrYnVm
KSk7DQo+ICAgICAgICAgICAgICAgICByZXR1cm4gLTE7DQo+ICAgICAgICAgfQ0KPiAtICAgICAg
IGhhbmRsZS0+Y3B1X2RhdGFbY3B1XS50aW1lc3RhbXAgPSBrYnVmZmVyX3RpbWVzdGFtcChrYnVm
KSArIGhhbmRsZS0+dHNfb2Zmc2V0Ow0KPiArICAgICAgIGhhbmRsZS0+Y3B1X2RhdGFbY3B1XS50
aW1lc3RhbXAgPSB0aW1lc3RhbXBfY29ycmVjdChrYnVmZmVyX3RpbWVzdGFtcChrYnVmKSwgaGFu
ZGxlKTsNCj4NCj4gICAgICAgICBpZiAoaGFuZGxlLT50czJzZWNzKQ0KPiAgICAgICAgICAgICAg
ICAgaGFuZGxlLT5jcHVfZGF0YVtjcHVdLnRpbWVzdGFtcCAqPSBoYW5kbGUtPnRzMnNlY3M7DQo+
IEBAIC0xNzc2LDcgKzE4NDMsNyBAQCByZWFkX2FnYWluOg0KPiAgICAgICAgICAgICAgICAgZ290
byByZWFkX2FnYWluOw0KPiAgICAgICAgIH0NCj4NCj4gLSAgICAgICBoYW5kbGUtPmNwdV9kYXRh
W2NwdV0udGltZXN0YW1wID0gdHMgKyBoYW5kbGUtPnRzX29mZnNldDsNCj4gKyAgICAgICBoYW5k
bGUtPmNwdV9kYXRhW2NwdV0udGltZXN0YW1wID0gdGltZXN0YW1wX2NvcnJlY3QodHMsIGhhbmRs
ZSk7DQo+DQo+ICAgICAgICAgaWYgKGhhbmRsZS0+dHMyc2Vjcykgew0KPiAgICAgICAgICAgICAg
ICAgaGFuZGxlLT5jcHVfZGF0YVtjcHVdLnRpbWVzdGFtcCAqPSBoYW5kbGUtPnRzMnNlY3M7DQo+
IEBAIC0yMTAxLDYgKzIxNjgsNDIgQEAgdm9pZCB0cmFjZWNtZF9zZXRfdHMyc2VjcyhzdHJ1Y3Qg
dHJhY2VjbWRfaW5wdXQgKmhhbmRsZSwNCj4gICAgICAgICBoYW5kbGUtPnVzZV90cmFjZV9jbG9j
ayA9IGZhbHNlOw0KPiAgfQ0KPg0KPiArc3RhdGljIGludCB0c3luY19vZmZzZXRfY21wKGNvbnN0
IHZvaWQgKmEsIGNvbnN0IHZvaWQgKmIpDQo+ICt7DQo+ICsgICAgICAgc3RydWN0IHRzX29mZnNl
dF9zYW1wbGUgKnRzX2EgPSAoc3RydWN0IHRzX29mZnNldF9zYW1wbGUgKilhOw0KPiArICAgICAg
IHN0cnVjdCB0c19vZmZzZXRfc2FtcGxlICp0c19iID0gKHN0cnVjdCB0c19vZmZzZXRfc2FtcGxl
ICopYjsNCj4gKw0KPiArICAgICAgIGlmICh0c19hLT50aW1lID4gdHNfYi0+dGltZSkNCj4gKyAg
ICAgICAgICAgICAgIHJldHVybiAxOw0KPiArICAgICAgIGlmICh0c19hLT50aW1lIDwgdHNfYi0+
dGltZSkNCj4gKyAgICAgICAgICAgICAgIHJldHVybiAtMTsNCj4gKyAgICAgICByZXR1cm4gMDsN
Cj4gK30NCj4gKw0KPiArc3RhdGljIHZvaWQgdHN5bmNfb2Zmc2V0X2xvYWQoc3RydWN0IHRyYWNl
Y21kX2lucHV0ICpoYW5kbGUsIGNoYXIgKmJ1ZikNCj4gK3sNCj4gKyAgICAgICBpbnQgaSwgajsN
Cj4gKyAgICAgICBsb25nIGxvbmcgKmJ1ZjggPSAobG9uZyBsb25nICopYnVmOw0KPiArDQo+ICsg
ICAgICAgZm9yIChpID0gMDsgaSA8IGhhbmRsZS0+dHNfY29ycl9jb3VudDsgaSsrKSB7DQo+ICsg
ICAgICAgICAgICAgICBoYW5kbGUtPnRzX2NvcnJbaV0udGltZSA9IHRlcF9yZWFkX251bWJlciho
YW5kbGUtPnBldmVudCwNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIGJ1ZjgraSwgOCk7DQo+ICsgICAgICAgICAgICAgICBoYW5kbGUt
PnRzX2NvcnJbaV0ub2Zmc2V0ID0gdGVwX3JlYWRfbnVtYmVyKGhhbmRsZS0+cGV2ZW50LA0KPiAr
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBidWY4K2hhbmRs
ZS0+dHNfY29ycl9jb3VudCtpLCA4KTsNCj4gKyAgICAgICB9DQo+ICsgICAgICAgcXNvcnQoaGFu
ZGxlLT50c19jb3JyLA0KPiArICAgICAgICAgICAgIGhhbmRsZS0+dHNfY29ycl9jb3VudCwgc2l6
ZW9mKHN0cnVjdCB0c19vZmZzZXRfc2FtcGxlKSwNCj4gKyAgICAgICAgICAgICB0c3luY19vZmZz
ZXRfY21wKTsNCj4gKyAgICAgICAvKiBGaWx0ZXIgcG9zc2libGUgc2FtcGxlcyB3aXRoIGVxdWFs
IHRpbWUgKi8NCj4gKyAgICAgICBmb3IgKGkgPSAwLCBqID0gMDsgaSA8IGhhbmRsZS0+dHNfY29y
cl9jb3VudDsgaSsrKSB7DQo+ICsgICAgICAgICAgICAgICBpZiAoaSA9PSAwIHx8DQo+ICsgICAg
ICAgICAgICAgICAgICAgaGFuZGxlLT50c19jb3JyW2ldLnRpbWUgIT0gaGFuZGxlLT50c19jb3Jy
W2ktMV0udGltZSkgew0KPiArICAgICAgICAgICAgICAgICAgICAgICBoYW5kbGUtPnRzX2NvcnJb
aisrXS50aW1lID0gaGFuZGxlLT50c19jb3JyW2ldLnRpbWU7DQo+ICsgICAgICAgICAgICAgICAg
ICAgICAgIGhhbmRsZS0+dHNfY29ycltqKytdLm9mZnNldCA9IGhhbmRsZS0+dHNfY29ycltpXS5v
ZmZzZXQ7DQoNCmBqYCBuZWVkcyB0byBiZSBpbmNyZW1lbnQgb25seSBvbmNlIGhlcmUuIEhvdyBh
Ym91dDoNCg0KICAgICAgICAgICAgICBpZiAoaSA9PSAwIHx8IGhhbmRsZS0+dHNfY29ycltpXS50
aW1lICE9DQpoYW5kbGUtPnRzX2NvcnJbaS0xXS50aW1lKQ0KICAgICAgICAgICAgICAgICAgICBo
YW5kbGUtPnRzX2NvcnJbaisrXSA9IGhhbmRsZS0+dHNfY29ycltpXTsNCg0KVGhhbmtzIQ0KDQot
LSBTbGF2aQ0K
