Return-Path: <SRS0=md0U=R5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEE93C43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Mar 2019 17:28:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A892120823
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Mar 2019 17:28:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="HgqjH/6N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbfCZR2L (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 26 Mar 2019 13:28:11 -0400
Received: from mail-eopbgr810072.outbound.protection.outlook.com ([40.107.81.72]:26828
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726111AbfCZR2L (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 26 Mar 2019 13:28:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=efvHynnOWhfdUEXSedxRZ4I0r6VFOBF5h+p4eV25gTk=;
 b=HgqjH/6NkbGBqEHzR+4VuMJwdDk7vGu/pvGvzoQbdZIT2sxFxGU9RnaPDWpeF59geo1W1j+mcQAoOzSS/pOOnbNcVU+Iq9GxX8vBkvrdty5wg5YXYA9shMzjYM7VLOA7mXxOvyh7lFPQc62CiniNjo/T6tdbwkLE0egFMdaPZ+8=
Received: from CY1PR05MB2780.namprd05.prod.outlook.com (10.167.18.26) by
 CY1PR05MB2667.namprd05.prod.outlook.com (10.167.11.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1750.11; Tue, 26 Mar 2019 17:26:29 +0000
Received: from CY1PR05MB2780.namprd05.prod.outlook.com
 ([fe80::4db6:3e20:4b0e:4416]) by CY1PR05MB2780.namprd05.prod.outlook.com
 ([fe80::4db6:3e20:4b0e:4416%10]) with mapi id 15.20.1750.014; Tue, 26 Mar
 2019 17:26:29 +0000
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
CC:     Steven Rostedt <rostedt@goodmis.org>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v10 9/9] trace-cmd [POC]: Implemented timestamps synch
 algorithm, using vsock events.
Thread-Topic: [PATCH v10 9/9] trace-cmd [POC]: Implemented timestamps synch
 algorithm, using vsock events.
Thread-Index: AQHU4/kBY6Kt7G5TeEWH6YRxG2s4cA==
Date:   Tue, 26 Mar 2019 17:26:27 +0000
Message-ID: <CAE0o1NtHiaLLwScUt2M9y+D5Fkyx7jivzC71Xq7o5XFLWLG3ag@mail.gmail.com>
References: <20190326150651.25811-1-tstoyanov@vmware.com>
 <20190326150651.25811-10-tstoyanov@vmware.com>
In-Reply-To: <20190326150651.25811-10-tstoyanov@vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: DM5PR12CA0057.namprd12.prod.outlook.com
 (2603:10b6:3:103::19) To CY1PR05MB2780.namprd05.prod.outlook.com
 (2a01:111:e400:c63a::26)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kaslevs@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: APjAAAVbqVc1C2q5eX47hxecZCPm7ewHxXVKf6cXtexOaj0b0VrxiQMN
        QUI+0b7wa6Z26h62lpoZPfyEREOZXJcs8cbrMw==
x-google-smtp-source: APXvYqx7oEotQn9x4aq2kDtG4RXspsA0KNG93iMYr5BvIeQDpq58t/JBFiYzeRLH08CgOng15sj1vnysErhCqVByKUU=
x-received: by 2002:a02:9f19:: with SMTP id z25mr19582912jal.2.1553621184648;
 Tue, 26 Mar 2019 10:26:24 -0700 (PDT)
x-gmail-original-message-id: <CAE0o1NtHiaLLwScUt2M9y+D5Fkyx7jivzC71Xq7o5XFLWLG3ag@mail.gmail.com>
x-originating-ip: [209.85.166.173]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0fc45bd2-c27b-4690-e457-08d6b2102d7a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600127)(711020)(4605104)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:CY1PR05MB2667;
x-ms-traffictypediagnostic: CY1PR05MB2667:
x-microsoft-antispam-prvs: <CY1PR05MB26678A276094506431913E56DA5F0@CY1PR05MB2667.namprd05.prod.outlook.com>
x-forefront-prvs: 09888BC01D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(366004)(136003)(39860400002)(396003)(199004)(189003)(256004)(81156014)(305945005)(76176011)(86362001)(316002)(105586002)(99286004)(5660300002)(54906003)(106356001)(95326003)(97736004)(476003)(71190400001)(446003)(71200400001)(68736007)(486006)(11346002)(7736002)(53546011)(186003)(6506007)(6512007)(4326008)(66066001)(26005)(6486002)(478600001)(6116002)(55446002)(3846002)(6862004)(6436002)(61266001)(498394004)(6246003)(6636002)(25786009)(229853002)(14454004)(81166006)(53936002)(52116002)(8936002)(9686003)(102836004)(386003)(61726006)(2906002)(8676002)(67856001);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR05MB2667;H:CY1PR05MB2780.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: D8EeAYV0RolWyH/6UESSQj0yWpz3bTwTuSE5Lm8DuDkpJcfqKw52kiw5LhA7BRBC5Hd6niiuD4K+4h/vrLhn3Sraohs63YDK0ehN1hxzAiKZiuHyWHUuzTUqeTz/XipsxV2lFZKDBIaFccKd2SU1H0iLdgxVH2B/Nsu2z7OZmbdFQOb81ThORDtNuomSc7MiTPIKQaDSIuGi8LgxR3cEcHv+FQqLx3Hs5Lhgz8W7kuv8MHFpWVIYFU1kOWfyCF2mGd/4JTCk9PK6RxA2yljjM6D3I0WhlwZjopjvl/AHG47QJ5S7oSFG1ToYfPoVDUJxiLNAR76AnOr2Y4mF+MA28UxGK5OgYau43heYi9EJEUPyHG0j8X/8h10L8f4bEUyU1AYhgD0W7mFvDRIMvWlPqkrKnjH/PJeb9o5uQ82lmPg=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C784787CDE166E4A8031708DB58A1829@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fc45bd2-c27b-4690-e457-08d6b2102d7a
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2019 17:26:27.6457
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR05MB2667
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gVHVlLCBNYXIgMjYsIDIwMTkgYXQgNTowNyBQTSBUenZldG9taXIgU3RveWFub3YgPHRzdG95
YW5vdkB2bXdhcmUuY29tPiB3cm90ZToNCjxzbmlwPg0KPiBAQCAtMTIwLDEwICsxNDYsMTMgQEAg
c3RhdGljIGNvbnN0IGNoYXIgKmNtZF90b19uYW1lKGludCBjbWQpDQo+ICBzdHJ1Y3QgdHJhY2Vj
bWRfbXNnIHsNCj4gICAgICAgICBzdHJ1Y3QgdHJhY2VjbWRfbXNnX2hlYWRlciAgICAgICAgICAg
ICAgaGRyOw0KPiAgICAgICAgIHVuaW9uIHsNCj4gLSAgICAgICAgICAgICAgIHN0cnVjdCB0cmFj
ZWNtZF9tc2dfdGluaXQgICAgICAgdGluaXQ7DQo+IC0gICAgICAgICAgICAgICBzdHJ1Y3QgdHJh
Y2VjbWRfbXNnX3Jpbml0ICAgICAgIHJpbml0Ow0KPiAtICAgICAgICAgICAgICAgc3RydWN0IHRy
YWNlY21kX21zZ190cmFjZV9yZXEgICB0cmFjZV9yZXE7DQo+IC0gICAgICAgICAgICAgICBzdHJ1
Y3QgdHJhY2VjbWRfbXNnX3RyYWNlX3Jlc3AgIHRyYWNlX3Jlc3A7DQo+ICsgICAgICAgICAgICAg
ICBzdHJ1Y3QgdHJhY2VjbWRfbXNnX3Rpbml0ICAgICAgICAgICAgICAgdGluaXQ7DQo+ICsgICAg
ICAgICAgICAgICBzdHJ1Y3QgdHJhY2VjbWRfbXNnX3Jpbml0ICAgICAgICAgICAgICAgcmluaXQ7
DQo+ICsgICAgICAgICAgICAgICBzdHJ1Y3QgdHJhY2VjbWRfbXNnX3RyYWNlX3JlcSAgICAgICAg
ICAgdHJhY2VfcmVxOw0KPiArICAgICAgICAgICAgICAgc3RydWN0IHRyYWNlY21kX21zZ190cmFj
ZV9yZXNwICAgICAgICAgIHRyYWNlX3Jlc3A7DQo+ICsgICAgICAgICAgICAgICBzdHJ1Y3QgdHJh
Y2VjbWRfbXNnX3RzeW5jX3N0b3AgICAgICAgICAgdHNfc3RvcDsNCj4gKyAgICAgICAgICAgICAg
IHN0cnVjdCB0cmFjZWNtZF9tc2dfdHN5bmNfcmVxICAgICAgICAgICB0c19yZXE7DQo+ICsgICAg
ICAgICAgICAgICBzdHJ1Y3QgdHJhY2VjbWRfbXNnX3RzeW5jX3Jlc3AgICAgICAgICAgdHNfcmVz
cDsNCj4gICAgICAgICB9Ow0KPiAgICAgICAgIHVuaW9uIHsNCj4gICAgICAgICAgICAgICAgIHN0
cnVjdCB0cmFjZWNtZF9tc2dfb3B0ICAgICAgICAgKm9wdDsNCj4gQEAgLTE2MSw2ICsxOTAsNyBA
QCBzdGF0aWMgaW50IG1zZ193cml0ZShpbnQgZmQsIHN0cnVjdCB0cmFjZWNtZF9tc2cgKm1zZykN
Cg0KVGhlIHNlY29uZCB1bmlvbiBpbiB0cmFjZWNtZF9tc2cgaXMgYWxyZWFkeSBnb25lIGluIG1h
c3RlciBhbmQgdGhpcw0Kc2VyaWVzIG5lZWRzIHRvIGdldCByZWJhc2VkLg0KDQo8c25pcD4NCg0K
PiBkaWZmIC0tZ2l0IGEvdHJhY2VjbWQvdHJhY2Utb3V0cHV0LmMgYi90cmFjZWNtZC90cmFjZS1v
dXRwdXQuYw0KPiBpbmRleCBkNTc1MzljLi5mYzMzOGNhIDEwMDY0NA0KPiAtLS0gYS90cmFjZWNt
ZC90cmFjZS1vdXRwdXQuYw0KPiArKysgYi90cmFjZWNtZC90cmFjZS1vdXRwdXQuYw0KPiBAQCAt
OTYwLDcgKzk2MCw3IEBAIHRyYWNlY21kX2FkZF9vcHRpb24oc3RydWN0IHRyYWNlY21kX291dHB1
dCAqaGFuZGxlLA0KPiAgew0KPiAgICAgICAgIHN0cnVjdCBpb3ZlYyB2ZWN0Ow0KPg0KPiAtICAg
ICAgIHZlY3QuaW92X2Jhc2UgPSBkYXRhOw0KPiArICAgICAgIHZlY3QuaW92X2Jhc2UgPSAodm9p
ZCAqKWRhdGE7DQo+ICAgICAgICAgdmVjdC5pb3ZfbGVuID0gc2l6ZTsNCj4gICAgICAgICByZXR1
cm4gdHJhY2VjbWRfYWRkX29wdGlvbl92KGhhbmRsZSwgaWQsICZ2ZWN0LCAxKTsNCj4gIH0NCg0K
VGhpcyBmaXggbmVlZHMgdG8gYmUgZm9sZGVkIGluIHBhdGNoIDcgd2hlcmUgdGhpcyBjb2RlIGlz
IGludHJvZHVjZWQNCnJhdGhlciB0aGFuIGhlcmUuDQoNCj4gZGlmZiAtLWdpdCBhL3RyYWNlY21k
L3RyYWNlLXJlY29yZC5jIGIvdHJhY2VjbWQvdHJhY2UtcmVjb3JkLmMNCj4gaW5kZXggNzJhOGVk
My4uMTRmM2NmOSAxMDA2NDQNCj4gLS0tIGEvdHJhY2VjbWQvdHJhY2UtcmVjb3JkLmMNCj4gKysr
IGIvdHJhY2VjbWQvdHJhY2UtcmVjb3JkLmMNCj4gQEAgLTU2MDksNiArNTYzMSw0MiBAQCBzdGF0
aWMgYm9vbCBoYXNfbG9jYWxfaW5zdGFuY2VzKHZvaWQpDQo+ICAgICAgICAgcmV0dXJuIGZhbHNl
Ow0KPiAgfQ0KPg0KPiArLy8jZGVmaW5lIFRTWU5DX0RFQlVHDQoNClJlbW92ZT8gVGhpcyBkZWZp
bmUgY2FuIGJlIHBhc3NlZCBvbiB0aGUgY29tbWFuZCBsaW5lIHRvIG1ha2UuDQoNCj4gK3N0YXRp
YyB2b2lkIHdyaXRlX2d1ZXN0X3RpbWVfc2hpZnQoc3RydWN0IGJ1ZmZlcl9pbnN0YW5jZSAqaW5z
dGFuY2UpDQo+ICt7DQo+ICsgICAgICAgc3RydWN0IHRyYWNlY21kX291dHB1dCAqaGFuZGxlOw0K
PiArICAgICAgIHN0cnVjdCBpb3ZlYyB2ZWN0b3JbM107DQo+ICsgICAgICAgY2hhciAqZmlsZTsN
Cj4gKyAgICAgICBpbnQgZmQ7DQo+ICsNCj4gKyAgICAgICBpZiAoIWluc3RhbmNlLT50aW1lX3N5
bmNfY291bnQpDQo+ICsgICAgICAgICAgICAgICByZXR1cm47DQo+ICsNCj4gKyAgICAgICBmaWxl
ID0gZ2V0X2d1ZXN0X2ZpbGUob3V0cHV0X2ZpbGUsIGluc3RhbmNlLT5uYW1lKTsNCj4gKyAgICAg
ICBmZCA9IG9wZW4oZmlsZSwgT19SRFdSKTsNCj4gKyAgICAgICBpZiAoZmQgPCAwKQ0KPiArICAg
ICAgICAgICAgICAgZGllKCJlcnJvciBvcGVuaW5nICVzIiwgZmlsZSk7DQo+ICsgICAgICAgcHV0
X3RlbXBfZmlsZShmaWxlKTsNCj4gKyAgICAgICBoYW5kbGUgPSB0cmFjZWNtZF9nZXRfb3V0cHV0
X2hhbmRsZV9mZChmZCk7DQo+ICsgICAgICAgdmVjdG9yWzBdLmlvdl9sZW4gPSBzaXplb2YoaW5z
dGFuY2UtPnRpbWVfc3luY19jb3VudCk7DQo+ICsgICAgICAgdmVjdG9yWzBdLmlvdl9iYXNlID0g
Jmluc3RhbmNlLT50aW1lX3N5bmNfY291bnQ7DQo+ICsgICAgICAgdmVjdG9yWzFdLmlvdl9sZW4g
PSBzaXplb2YobG9uZyBsb25nKSAqIGluc3RhbmNlLT50aW1lX3N5bmNfY291bnQ7DQo+ICsgICAg
ICAgdmVjdG9yWzFdLmlvdl9iYXNlID0gaW5zdGFuY2UtPnRpbWVfc3luY190czsNCj4gKyAgICAg
ICB2ZWN0b3JbMl0uaW92X2xlbiA9IHNpemVvZihsb25nIGxvbmcpICogaW5zdGFuY2UtPnRpbWVf
c3luY19jb3VudDsNCj4gKyAgICAgICB2ZWN0b3JbMl0uaW92X2Jhc2UgPSBpbnN0YW5jZS0+dGlt
ZV9zeW5jX29mZnNldHM7DQo+ICsgICAgICAgdHJhY2VjbWRfYWRkX29wdGlvbl92KGhhbmRsZSwg
VFJBQ0VDTURfT1BUSU9OX1RJTUVfU0hJRlQsIHZlY3RvciwgMyk7DQoNClRoaXMgc2VlbXMgdG8g
YmUgdGhlIG9ubHkgdXNlIG9mIHRoZSBuZXdseSBhZGRlZA0KdHJhY2VjbWRfYWRkX29wdGlvbl92
LiBJJ20gbm90IGNvbnZpbmNlZCB0aGF0IGhhdmluZyBzdHJ1Y3QgaW92ZWMNCmludGVyZmFjZSBm
b3IgdHJhY2VjbWQgb3B0aW9ucyBpcyBhIGdvb2QgcGF0dGVybiBzaW5jZQ0KYSkgdGhlIGlvdmVj
IGNvbmNhdGVuYXRpb24gaW4gdHJhY2VjbWRfYWRkX29wdGlvbl92IGFkZHMgYW4gZXh0cmENCmFs
bG9jYXRpb24gZm9yIHRoZSBtb3N0IGNvbW1vbiBjYXNlIHdoZW4gdGhlcmUncyBhIHNpbmdsZSBw
aWVjZSBvZg0KZGF0YSBwYXNzZWQNCmIpIGl0IG5ldmVyIGFjdHVhbGx5IGdldHMgcGFzc2VkIHRv
IHJlYWR2L3dyaXRldg0KYykgdGhlIGFib3ZlIGlzIG5vdCByZWFsbHkgcG9ydGFibGUgc2luY2Ug
dGhlcmUncyBubyBndWFyYW50ZWUgdGhhdA0Kc2l6ZW9mKGludCkgPSA0DQoNCkkgdGhpbmsgZGVm
aW5pbmcgYSBmdW5jdGlvbiBoZXJlIHRoYXQgbWFzc2FnZXMgdGltZSBzeW5jIHNhbXBsZXMgaW50
bw0KVElNRV9TSElGVCBvcHRpb24gZm9ybWF0IChpbiBhIHBvcnRhYmxlIHdheSkgYW5kIGRyb3Bw
aW5nIHRoZSBwYXRjaA0KdGhhdCBhZGRzIHRyYWNlY21kX2FkZF9vcHRpb25fdiBhbHRvZ2V0aGVy
IGlzIGEgYmV0dGVyIHdheSB0byBnby4NCg0KPHNuaXA+DQoNCj4gZGlmZiAtLWdpdCBhL3RyYWNl
Y21kL3RyYWNlLXRpbWVzeW5jLmMgYi90cmFjZWNtZC90cmFjZS10aW1lc3luYy5jDQo+IG5ldyBm
aWxlIG1vZGUgMTAwNjQ0DQo+IGluZGV4IDAwMDAwMDAuLjA3NGM5ZDANCj4gLS0tIC9kZXYvbnVs
bA0KPiArKysgYi90cmFjZWNtZC90cmFjZS10aW1lc3luYy5jDQo+IEBAIC0wLDAgKzEsODA1IEBA
DQo+ICsvLyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMA0KPiArLyoNCj4gKyAqIENv
cHlyaWdodCAoQykgMjAxOSwgVk13YXJlLCBUenZldG9taXIgU3RveWFub3YgPHRzdG95YW5vdkB2
bXdhcmUuY29tPg0KPiArICoNCj4gKyAqLw0KPiArDQo+ICsjaW5jbHVkZSA8ZmNudGwuaD4NCj4g
KyNpbmNsdWRlIDxzdGRsaWIuaD4NCj4gKyNpbmNsdWRlIDx1bmlzdGQuaD4NCj4gKyNpbmNsdWRl
IDxhcnBhL2luZXQuaD4NCj4gKyNpbmNsdWRlIDxsaW51eC92bV9zb2NrZXRzLmg+DQo+ICsjaW5j
bHVkZSAidHJhY2UtbG9jYWwuaCINCg0KPHNuaXA+DQoNCj4gKw0KPiArc3RhdGljIHZvaWQgZ2V0
X3Zzb2NrZXRfcGFyYW1zKGludCBmZCwgdW5zaWduZWQgaW50ICpsY2lkLCB1bnNpZ25lZCBpbnQg
Kmxwb3J0LA0KPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdW5zaWduZWQgaW50ICpy
Y2lkLCB1bnNpZ25lZCBpbnQgKnJwb3J0KQ0KPiArew0KPiArICAgICAgIHN0cnVjdCBzb2NrYWRk
cl92bSBhZGRyOw0KPiArICAgICAgIHNvY2tsZW5fdCBhZGRyX2xlbiA9IHNpemVvZihhZGRyKTsN
Cj4gKw0KPiArICAgICAgIG1lbXNldCgmYWRkciwgMCwgc2l6ZW9mKGFkZHIpKTsNCj4gKyAgICAg
ICBpZiAoZ2V0c29ja25hbWUoZmQsIChzdHJ1Y3Qgc29ja2FkZHIgKikmYWRkciwgJmFkZHJfbGVu
KSkNCj4gKyAgICAgICAgICAgICAgIHJldHVybjsNCj4gKyAgICAgICBpZiAoYWRkci5zdm1fZmFt
aWx5ICE9IEFGX1ZTT0NLKQ0KPiArICAgICAgICAgICAgICAgcmV0dXJuOw0KPiArICAgICAgICps
cG9ydCA9IGFkZHIuc3ZtX3BvcnQ7DQo+ICsgICAgICAgKmxjaWQgPSBhZGRyLnN2bV9jaWQ7DQo+
ICsNCj4gKyAgICAgICBtZW1zZXQoJmFkZHIsIDAsIHNpemVvZihhZGRyKSk7DQo+ICsgICAgICAg
YWRkcl9sZW4gPSBzaXplb2YoYWRkcik7DQo+ICsgICAgICAgaWYgKGdldHBlZXJuYW1lKGZkLCAo
c3RydWN0IHNvY2thZGRyICopJmFkZHIsICZhZGRyX2xlbikpDQo+ICsgICAgICAgICAgICAgICBy
ZXR1cm47DQo+ICsgICAgICAgaWYgKGFkZHIuc3ZtX2ZhbWlseSAhPSBBRl9WU09DSykNCj4gKyAg
ICAgICAgICAgICAgIHJldHVybjsNCj4gKyAgICAgICAqcnBvcnQgPSBhZGRyLnN2bV9wb3J0Ow0K
PiArICAgICAgICpyY2lkID0gYWRkci5zdm1fY2lkOw0KPiArfQ0KDQpUaGlzIGZ1bmN0aW9uIGNh
biBzaWxlbnRseSBpZ25vcmUgZXJyb3JzIGlmIGdldHNvY2tuYW1lL2dldHBlZXJuYW1lDQpmYWls
IG9yIGZpbGUgZGVzY3JpcHRvciBoYXBwZW5zIHRvIG5vdCBiZSBhIHZzb2NrZXQuIENhbiB5b3Ug
Y2hhbmdlIGl0DQpyZXR1cm4gZXJyb3IgYW5kIGhhdmUgY2FsbGVycyBjaGVjayBmb3IgaXQ/DQoN
ClRoYW5rIHlvdSBDZWNvLA0KDQotLSBTbGF2aQ0K
