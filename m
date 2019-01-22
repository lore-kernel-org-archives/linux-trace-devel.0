Return-Path: <SRS0=3hMC=P6=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F634C282C3
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Jan 2019 13:43:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 642EF20879
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Jan 2019 13:43:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="MzhVZTbt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728463AbfAVNnJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Jan 2019 08:43:09 -0500
Received: from mail-eopbgr810040.outbound.protection.outlook.com ([40.107.81.40]:56451
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728305AbfAVNnJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Jan 2019 08:43:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aoxZmjCIQ/hupyStOQhsSqM76CoqmHcMBPNczl5VfoU=;
 b=MzhVZTbtvMLIwIKPa484/Uqphnw1wXBVCBkAFh2DIFwK1b5BqR8ziS82/82NWbIsGaPdn+RH52UWgHvTx8UEaJfpzY5rhe7ZizWuk55uB9ZrK6pVD+lPigoJ+auia4iFXgVcMvkudIxXGUlWjPwl4VFkGhczxCIRth8hwb+jNbg=
Received: from CY1PR05MB2761.namprd05.prod.outlook.com (10.167.18.19) by
 CY1PR05MB2682.namprd05.prod.outlook.com (10.167.11.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1558.10; Tue, 22 Jan 2019 13:43:03 +0000
Received: from CY1PR05MB2761.namprd05.prod.outlook.com
 ([fe80::a193:f46c:290f:3ca5]) by CY1PR05MB2761.namprd05.prod.outlook.com
 ([fe80::a193:f46c:290f:3ca5%3]) with mapi id 15.20.1558.016; Tue, 22 Jan 2019
 13:43:03 +0000
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 5/7] trace-cmd: Added user configured clock to the record
 context
Thread-Topic: [PATCH 5/7] trace-cmd: Added user configured clock to the record
 context
Thread-Index: AQHUrdBRX14pZvcb/EWvvTXVDdkxo6W5eVWAgAHbwQA=
Date:   Tue, 22 Jan 2019 13:43:03 +0000
Message-ID: <CACqStoezVCpB9n4GvCZ+LW11QPL4oQbLCfJi1HcOndHJ32Fuig@mail.gmail.com>
References: <20190116191838.32127-1-tstoyanov@vmware.com>
 <20190116191838.32127-6-tstoyanov@vmware.com>
 <20190121041959.1de4b1f0@vmware.local.home>
In-Reply-To: <20190121041959.1de4b1f0@vmware.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6P192CA0087.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:209:8d::28) To CY1PR05MB2761.namprd05.prod.outlook.com
 (2a01:111:e400:c63a::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tstoyanov@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: AJcUukexdS4fOP4NN1AV9UQKzuf72eaV38S3iIzjhA6qOCkJOeSp4ypZ
        wEtbXP3Q8IcY3HJUFp4aDAlfhiGUNLYOp30J55E=
x-google-smtp-source: ALg8bN4zAPkVrOtRyrsybKhVP4wXnkHpFN/CtRO9LBA/D5jsQFJ84JIBh7eHkZft+d26oDS/kWbEw4Kwksl8DCzTg90=
x-received: by 2002:a1c:5a42:: with SMTP id o63mr3803993wmb.88.1548164578115;
 Tue, 22 Jan 2019 05:42:58 -0800 (PST)
x-gmail-original-message-id: <CACqStoezVCpB9n4GvCZ+LW11QPL4oQbLCfJi1HcOndHJ32Fuig@mail.gmail.com>
x-originating-ip: [209.85.128.46]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;CY1PR05MB2682;20:rHWxGjYjOAnkTKxNhPkaAmP2ipPw9xXX0O5uRmGiglzs0blKU4x1gCe0eebrkpq5xq2Z3oPgkQw9Zc3Jk5zRhRaG4OtjsIDHUFNyzRLAdBtevVAP+Lptqt0tbS9DCvM85UEmnrXoMbyxHzsHkdXVsdODPrtmIm2QEPz98o7gr+c=
x-ms-office365-filtering-correlation-id: 3dc55bca-b1b7-4a7c-403a-08d6806f87c5
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600109)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:CY1PR05MB2682;
x-ms-traffictypediagnostic: CY1PR05MB2682:
x-microsoft-antispam-prvs: <CY1PR05MB26826541B0733C154AF736ADDC980@CY1PR05MB2682.namprd05.prod.outlook.com>
x-forefront-prvs: 0925081676
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(396003)(346002)(376002)(39860400002)(199004)(189003)(6246003)(53936002)(486006)(68736007)(9686003)(6512007)(99286004)(6436002)(498394004)(6862004)(86362001)(6486002)(229853002)(316002)(4326008)(95326003)(2906002)(106356001)(256004)(105586002)(25786009)(8936002)(76176011)(61266001)(61726006)(81166006)(81156014)(55446002)(52116002)(8676002)(186003)(14454004)(26005)(102836004)(71190400001)(33896004)(3846002)(6116002)(11346002)(476003)(446003)(386003)(53546011)(6506007)(97736004)(478600001)(305945005)(71200400001)(7736002)(66066001)(67856001);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR05MB2682;H:CY1PR05MB2761.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: miBZnG6QcblPw8yFHn9h1Pjt3TJAca6gBtvb5G1N4J/ip/2NtVRq8U8gQWEH97k9EzMb9hMsGI0AIVw6UaUDMIlts7boeLQGDMgyj249ZAlUKcipYnfkUR35dHYtX7oucJfy6FU3mA9gH/fsfTAYMuRgkcm+E3AY5VTxFOE7ImCXE8QpCGkUSFhYIpHf3LIe2akt5OAJxZrhlVWKl5EKJ34maZkmxHpSh7jIjpahvYgP+zaPc+IPYl9dmuXQbfd+npACrA+zuCi4A0a6KAOYhswpSzn1bZuVF+6octg5xc5uTqRWcVJTpAop9+SBAbxRuDl43UJjzmf/lF2N0N04pmM4DSNW4bDl/nEu2ek8PjrmZqIrzo7G6qEIDgC9cgLXOsCZZ3uoDRNGNsss4vCM4XoIhk4WcJU/XO0zYAXGKhI=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <8CB914A9BAE2A045A7AEE9227CA5304E@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3dc55bca-b1b7-4a7c-403a-08d6806f87c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2019 13:43:02.7080
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR05MB2682
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gTW9uLCBKYW4gMjEsIDIwMTkgYXQgMTE6MTkgQU0gU3RldmVuIFJvc3RlZHQgPHJvc3RlZHRA
Z29vZG1pcy5vcmc+IHdyb3RlOg0KPg0KPiBPbiBXZWQsIDE2IEphbiAyMDE5IDIxOjE4OjM2ICsw
MjAwDQo+IFR6dmV0b21pciBTdG95YW5vdiA8dHN0b3lhbm92QHZtd2FyZS5jb20+IHdyb3RlOg0K
Pg0KPiA+IFN0b3JlIHRoZSB1c2VyIGNvbmZpZ3VyZWQgY2xvY2sgKGlmIGFueSkgaW4gdGhlIHJl
Y29yZCBjb250ZXh0LA0KPiA+IHN0cnVjdCBjb21tb25fcmVjb3JkX2NvbnRleHQuIFRoZSBjbG9j
ayBpcyBnb2luZyB0byBiZSB1c2VkIHdoZW4NCj4gPiBzeW5jaHJvbml6aW5nIHRpbWVzdGFtcHMg
d2l0aCByZW1vdGUgdHJhY2luZyBtYWNoaW5lLg0KPiA+IC0tLQ0KPiA+ICB0cmFjZWNtZC90cmFj
ZS1yZWNvcmQuYyB8IDIgKysNCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKQ0K
PiA+DQo+ID4gZGlmZiAtLWdpdCBhL3RyYWNlY21kL3RyYWNlLXJlY29yZC5jIGIvdHJhY2VjbWQv
dHJhY2UtcmVjb3JkLmMNCj4gPiBpbmRleCBmNzM0OWViLi45MDBkMGQ0IDEwMDY0NA0KPiA+IC0t
LSBhL3RyYWNlY21kL3RyYWNlLXJlY29yZC5jDQo+ID4gKysrIGIvdHJhY2VjbWQvdHJhY2UtcmVj
b3JkLmMNCj4gPiBAQCAtMjI3LDYgKzIyNyw3IEBAIHN0cnVjdCBjb21tb25fcmVjb3JkX2NvbnRl
eHQgew0KPiA+ICAgICAgIGludCB0b3B0Ow0KPiA+ICAgICAgIGludCBkb19jaGlsZDsNCj4gPiAg
ICAgICBpbnQgcnVuX2NvbW1hbmQ7DQo+ID4gKyAgICAgY2hhciAqY2xvY2s7DQo+ID4gIH07DQo+
ID4NCj4gPiAgc3RhdGljIHZvaWQgYWRkX3Jlc2V0X2ZpbGUoY29uc3QgY2hhciAqZmlsZSwgY29u
c3QgY2hhciAqdmFsLCBpbnQgcHJpbykNCj4gPiBAQCAtNTE4Myw2ICs1MTg0LDcgQEAgc3RhdGlj
IHZvaWQgcGFyc2VfcmVjb3JkX29wdGlvbnMoaW50IGFyZ2MsDQo+ID4gICAgICAgICAgICAgICAg
ICAgICAgIGJyZWFrOw0KPiA+ICAgICAgICAgICAgICAgY2FzZSAnQyc6DQo+ID4gICAgICAgICAg
ICAgICAgICAgICAgIGN0eC0+aW5zdGFuY2UtPmNsb2NrID0gb3B0YXJnOw0KPiA+ICsgICAgICAg
ICAgICAgICAgICAgICBjdHgtPmNsb2NrID0gb3B0YXJnOw0KPg0KPiBIbW0sIHRoaXMgY2FuIGNh
dXNlIGFuIGlzc3VlLiBUaGUgZmlyc3QgdGhpbmcgSSBoYXZlIHRvIGFzayBpcywgd2h5DQo+IGNh
bid0IHdlIHVzZSBjdHgtPmluc3RhbmNlLT5jbG9jay4gSSdtIHN1cmUgdGhlIGFuc3dlciBpcyB0
aGF0IHdlIGFyZQ0KPiBhZGRpbmcgbW9yZSB0aGFuIG9uZSBjbG9jay4gQnV0IHRoaXMgYmVncyB0
aGUgcXVlc3Rpb24sIHdoaWNoIGNsb2NrDQo+IHNob3VsZCBiZSB1c2UsIGlmIHRoZXJlIGFyZSBt
b3JlIHRoYW4gb25lIGNsb2NrIHRvIGFkZD8NCj4NCj4gSSB0aGluayB0aGlzIHBhdGNoIGlzIG5v
dCBuZWVkZWQuIEluIHRoZSBsYXN0IHBhdGNoLCB0ZXN0IGlmDQo+IGN0eC0+aW5zdGFuY2UtPmNs
b2NrIGV4aXN0cywgYW5kIGlmIG5vdCwgd2Ugc2VhcmNoIHRoZSBvdGhlciBpbnN0YW5jZXMNCj4g
Zm9yIGEgY2xvY2sgdG8gdXNlLiBPciBzb21ldGhpbmcgZWxzZSB0aGF0IGRvZXNuJ3QgbWFrZSB3
aGljaCBjbG9jayB0bw0KPiB1c2UgYW1iaWd1b3VzLg0KDQpPaywgSSdsbCByZW1vdmUgaXQgYW5k
IHdpbGwgc2VhcmNoIGZvciB0aGUgZmlyc3QgY3R4LT5pbnN0YW5jZS0+Y2xvY2sgaW5zdGVhZC4N
CkN1cnJlbnQgYWxnb3JpdGhtIGFzc3VtZXMgdGhhdCBvbmx5IG9uZSBjbG9jayBpcyB1c2VkLCBh
bmQgaXQgaXMgdGhlDQpzYW1lIGluIGJvdGgNCmhvc3QgYW5kIGd1ZXN0IGNvbnRleHRzLiBXZSBz
aG91bGQgdGhpbmsgaG93IHRvIGhhbmRsZSB0aGUgY2FzZSB3aXRoDQptdWx0aXBsZSBpbnN0YW5j
ZXMsDQplYWNoIG9uZSB3aXRoIGRpZmZlcmVudCBjbG9jay4gSSBkbyBub3Qga25vdywgaG93IGlu
c3RhbmNlcyBhcmUNCndyaXR0ZW4gaW4gdGhlIHRyYWNlLmRhdCBmaWxlLA0KaXMgdGhlcmUgYSBk
aWZmZXJlbnQgdGltZSBvZmZzZXQgb3B0aW9uIGluIHRoZSBmaWxlLCBwZXIgaW5zdGFuY2UgPw0K
DQo+DQo+IC0tIFN0ZXZlDQo+DQo+ID4gICAgICAgICAgICAgICAgICAgICAgIGJyZWFrOw0KPiA+
ICAgICAgICAgICAgICAgY2FzZSAndic6DQo+ID4gICAgICAgICAgICAgICAgICAgICAgIG5lZ19l
dmVudCA9IDE7DQo+DQoNCg0KLS0gDQoNClR6dmV0b21pciAoQ2VjbykgU3RveWFub3YNClZNd2Fy
ZSBPcGVuIFNvdXJjZSBUZWNobm9sb2d5IENlbnRlcg0K
