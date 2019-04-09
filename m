Return-Path: <SRS0=eAkL=SL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B06ABC10F0E
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Apr 2019 13:11:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71F6D2084F
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Apr 2019 13:11:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="ZP5OzOCr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727289AbfDINLt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 9 Apr 2019 09:11:49 -0400
Received: from mail-eopbgr710057.outbound.protection.outlook.com ([40.107.71.57]:12249
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727272AbfDINLt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Apr 2019 09:11:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+/m41uQpohaxNfnPJZl2MazH0vuo9+7b4Im9lYpHELI=;
 b=ZP5OzOCrEVBbobQntSkh4hswvQwA+OsOeIwcdrkNedVnouVctJYjmv2mRvt6echusk5sYbFMt6DC5xL+agPXoeOEWziUR/4mujzN8Olu6OpPrWwvaW6/183Zis+H5aDECBqaUcQzm5q5zBezOhqIk+PwjTQ5KgEZZPbEFeByq4Q=
Received: from MWHPR0501MB3772.namprd05.prod.outlook.com (10.167.163.156) by
 MWHPR0501MB3899.namprd05.prod.outlook.com (10.167.173.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1792.8; Tue, 9 Apr 2019 13:11:46 +0000
Received: from MWHPR0501MB3772.namprd05.prod.outlook.com
 ([fe80::b9a6:ba16:fc53:bb41]) by MWHPR0501MB3772.namprd05.prod.outlook.com
 ([fe80::b9a6:ba16:fc53:bb41%5]) with mapi id 15.20.1792.007; Tue, 9 Apr 2019
 13:11:46 +0000
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     "y.karadz@gmail.com" <y.karadz@gmail.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>
CC:     Yordan Karadzhov <ykaradzhov@vmware.com>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 1/4] kernel-shark: Configuration information in
 ${HOME}/.cache/kernelshark
Thread-Topic: [PATCH 1/4] kernel-shark: Configuration information in
 ${HOME}/.cache/kernelshark
Thread-Index: AQHU7h2WcCXQDyjBs0OQUMjYOKqD5aYzwfgAgAANWoA=
Date:   Tue, 9 Apr 2019 13:11:45 +0000
Message-ID: <45b425ac571722464e0602b72afee7ad17592b08.camel@vmware.com>
References: <20190404145603.13592-1-ykaradzhov@vmware.com>
         <20190404145603.13592-2-ykaradzhov@vmware.com> <20190408150102.GA6430@box>
         <20190408111308.301f30c1@gandalf.local.home>
         <0808d774-880a-f232-dda3-cd897120d86d@gmail.com>
In-Reply-To: <0808d774-880a-f232-dda3-cd897120d86d@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kaslevs@vmware.com; 
x-originating-ip: [146.247.46.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bbd59604-1bae-4092-4b68-08d6bceceb02
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600139)(711020)(4605104)(2017052603328)(7193020);SRVR:MWHPR0501MB3899;
x-ms-traffictypediagnostic: MWHPR0501MB3899:
x-microsoft-antispam-prvs: <MWHPR0501MB3899C8C92B7C898357BE87ADDA2D0@MWHPR0501MB3899.namprd05.prod.outlook.com>
x-forefront-prvs: 000227DA0C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(136003)(366004)(39860400002)(376002)(396003)(199004)(189003)(36756003)(106356001)(81166006)(105586002)(476003)(8676002)(26005)(486006)(102836004)(6506007)(66066001)(71190400001)(71200400001)(54906003)(14454004)(316002)(110136005)(14444005)(5660300002)(81156014)(25786009)(256004)(99286004)(478600001)(8936002)(118296001)(186003)(229853002)(6246003)(4326008)(3846002)(305945005)(6512007)(97736004)(6436002)(6116002)(7736002)(2906002)(53936002)(446003)(2501003)(93886005)(86362001)(76176011)(2616005)(11346002)(68736007)(6486002)(228453006);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR0501MB3899;H:MWHPR0501MB3772.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: fDyl8ogS/iazEKGwyS78DLGF1yKUqUs9H8B+dRdskU+g34nqLRgFSOy8TCn4P2ULWNOh2ERzrWg3SEPN+TrdhZKtS3fOkJwcXoXi0nqqUX3m4vWOsZ+FK1r0n69h5LobW6FVik3KA9tYiBQFjo9P6ynYQZLuquiHKpeH1Yr+y0uevDColQitDXQLkYdEk4VnFqTFOW7gfs7y7SBPKPo3NchyNz3PGOU7akK0ixobxgwRcShUm2er+kqOL0sMvE7GOg6+DjD0wH9c/ggwhUFRR+i6nRucdLSUvngiXbyt1f0cSq+RGHCHWJuZ+zjYUdm9PQIxMoEC1dlux92+CeTBYomhROtILMTlQhR9kvMwJRzpgg3hS3+orrsvq0sDL422qOgC4PXjZGcUjbAH4druvnZ0vgGb+wRWjb6Fc+Jl6Bo=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8E60C9F17E4CBA459C4ABEDEEA017FA6@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbd59604-1bae-4092-4b68-08d6bceceb02
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2019 13:11:45.8021
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0501MB3899
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gVHVlLCAyMDE5LTA0LTA5IGF0IDE1OjIzICswMzAwLCBZb3JkYW4gS2FyYWR6aG92IChWTXdh
cmUpIHdyb3RlOg0KPiANCj4gT24gOC4wNC4xOSDQsy4gMTg6MTMg0YcuLCBTdGV2ZW4gUm9zdGVk
dCB3cm90ZToNCj4gPiBPbiBNb24sIDggQXByIDIwMTkgMTg6MDE6MDMgKzAzMDANCj4gPiBTbGF2
b21pciBLYXNsZXYgPGthc2xldnNAdm13YXJlLmNvbT4gd3JvdGU6DQo+ID4gDQo+ID4gPiA+ICsr
KyBiL01ha2VmaWxlDQo+ID4gPiA+IEBAIC0yNTQsNyArMjU0LDEwIEBAIGFsbF9jbWQ6ICQoQ01E
X1RBUkdFVFMpDQo+ID4gPiA+ICAgQ01BS0VfQ09NTUFORCA9IC91c3IvYmluL2NtYWtlDQo+ID4g
PiA+ICAgDQo+ID4gPiA+ICAgJChrc2hhcmstZGlyKS9idWlsZC9NYWtlZmlsZTogJChrc2hhcmst
ZGlyKS9DTWFrZUxpc3RzLnR4dA0KPiA+ID4gPiAtCSQoUSkgY2QgJChrc2hhcmstZGlyKS9idWls
ZCAmJiAkKENNQUtFX0NPTU1BTkQpDQo+ID4gPiA+IC1EX0lOU1RBTExfUFJFRklYPSQocHJlZml4
KSAuLg0KPiA+ID4gPiArDQo+ID4gPiA+ICsJJChRKSBjZCAkKGtzaGFyay1kaXIpL2J1aWxkICYm
ICQoQ01BS0VfQ09NTUFORCkgXA0KPiA+ID4gPiArCQktRF9LU19DQUNIRV9ESVI9JChIT01FKS8u
Y2FjaGUva2VybmVsc2hhcmsgXA0KPiA+ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgXg0KPiA+ID4gV2hpY2ggJEhPTUUgd291bGQgdGhhdCBiZT8gVGhlIG9uZSBmb3IgdGhlIHVz
ZXIgd2hvIGJ1aWx0DQo+ID4gPiBrZXJuZWxzaGFyayBhbmQgbm90IHRoZSB1c2VyIHdobyBydW5z
IGl0Lg0KPiA+ID4gDQo+ID4gPiANCj4gDQo+IEFzIGl0IGlzIHJpZ2h0IG5vdyBDbWFrZSB3aWxs
IGdldCB0aGUgdmFsdWUgb2YgdGhlIC1EX0tTX0NBQ0hFX0RJUiANCj4gYXJndW1lbnQgYW5kIHdp
bGwgdGVsbCB0aGUgR1VJIHRvIHNhdmUgY2FjaGUgZmlsZXMgdGhlcmUuIEFuZCB5ZXMsDQo+IGlu
IA0KPiB0aGlzIGNhc2UgaXQgd2lsbCBiZSBpbiB0aGUgJEhPTUUgb2YgdGhlIHVzZXIgd2hvIGJ1
aWx0IGtlcm5lbHNoYXJrLg0KPiANCj4gSSBjYW4gbWFrZSB0aGUgR1VJIHRvIGNoZWNrIGlmIF9L
U19DQUNIRV9ESVIgaXMgZGVmaW5lZCBhbmQgaWYgaXRzDQo+IHZhbHVlIA0KPiAocGF0aCkgYmVs
b25ncyB0byB0aGUgdXNlciB3aG8gcnVucyB0aGUgR1VJLiBJZiB0aGlzIGlzIG5vdCB0aGUNCj4g
Y2FzZSwgDQo+IFRoZSBHVUkgd2lsbCB1c2UgdGhlIGRlZmF1bHQgbG9jYXRpb24gKH4vY2FjaGUv
a2VybmVsc2hhcmspLg0KDQpUaGlzIHdpbGwgd29yayBidXQgaXQgZG9lc24ndCBzb2x2ZSB0aGUg
YWN0dWFsIHByb2JsZW0uIFRoZSBhY3R1YWwNCnByb2JsZW0gaXMgdGhhdCBLU19DQUNIRV9ESVIg
bXVzdCBiZSBleHBhbmRlZCBydW4gdGltZSwgbm90IGNvbXBpbGUNCnRpbWUuIE90aGVyd2lzZSwg
dGhlcmUgaXMgbm8gc2Vuc2libGUgdmFsdWUgb25lIGNhbiBzZXQgdG8gS1NfQ0FDSEVfRElSDQpi
dWlsZCB0aW1lIHRoYXQgd29ya3MgZm9yIGFsbCB1c2VycyAodW5sZXNzIGl0J3Mgc2hhcmVkLCBz
YXkNCi92YXIvdG1wL2tlcm5lbHNoYXJrKS4NCg0KT25lIGFsdGVybmF0aXZlIGlzIHRvIGRvIHRo
aXMgaW4gdGhlIGFib3ZlIE1ha2VmaWxlOg0KDQoJJChRKSBjZCAkKGtzaGFyay1kaXIpL2J1aWxk
ICYmICQoQ01BS0VfQ09NTUFORCkgXA0KCQktRF9LU19DQUNIRV9ESVI9JyRIT01FLy5jYWNoZS9r
ZXJuZWxzaGFyaycNCg0KdG8gZm9yY2Ugc2hlbGwgbm90IHRvIGV4cGFuZCB2YXJpYWJsZXMgYW5k
IHRoZW4gdXNlIHdvcmRleHAoMykgb3INCnNpbWlsYXIgdG8gZG8gdGhlIGV4cGFuc2lvbiBydW4g
dGltZS4NCg0KQW5vdGhlciBhbHRlcm5hdGl2ZSBpcyB0byBjaGFuZ2UgdGhlIHNlbWFudGljcyBv
ZiBLU19DQUNIRV9ESVIgc28gdGhhdA0KaWYgaXQncyByZWxhdGl2ZSBwYXRoICguY2FjaGUva2Vy
bmVsc2hhcmspIGl0J3MgYWx3YXlzIHJvb3RlZCBhdCB0aGUNCnVzZXIncyAkSE9NRS4gT1RPSCB0
aGF0IGJlaGF2aW9yIG1pZ2h0IG5vdCBiZSB3aGF0IHNvbWUgdXNlcnMgZXhwZWN0Lg0KDQpDaGVl
cnMsDQoNCi0tIFNsYXZpDQo=
