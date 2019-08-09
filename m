Return-Path: <SRS0=Xrzw=WF=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EBF2C31E40
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Aug 2019 13:22:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 408E621783
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Aug 2019 13:22:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="xiX83Ape"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406924AbfHINWe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 9 Aug 2019 09:22:34 -0400
Received: from mail-eopbgr710061.outbound.protection.outlook.com ([40.107.71.61]:58080
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2406273AbfHINWe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Aug 2019 09:22:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SGtuSbX1EAH4UwERTi1Vuzyr/LeyqPGm0pp3xWborIr+ZNDTBZmI2hJb214aA7jK6vJJUqqB0FHHOW51xRLMqAeHmTnjs/i2Yw7mx5GDg/p1ZlI1qTll5nHM4ogUukzX5BUhCsNlreKPcxZ2dYjkgCGdsizVism1jmx5/3scGR2THBLJbN4I8lF5sNHgxXYU1AoUs0S4j9KZkQPfyY121+3LlVqDDlobUtiYv2QqM63BiXNoh5o2QPGBNC7l6seVi0dCmnS0FkYUkn5h7WeDZapB6UpCIMdUeufEy8UR6M31KGzEfncw5NxB+G5nMQHqvrr4hqOTq1Lcl8tRo7q1ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OHNartIMJuE1JopEV8Oq7pEMYtwizY3DgQyfbhojsJ8=;
 b=Gos/7eguPzmriAe5LUizH6vhxh6HRyWrEkOB+Bv475OqMAgPUVm1hyrXNUeWiUodbyA1DztXlDVSKSZ1LfOf7Vu+AWs8Bi9conHHYTTvY7a+Sw1nU7rfD/SUqAdeUt+qO0J5ILZ6CIt/7cnQ+oec+PaB8Bz/m4MJ93UAkT8npQ7TwzNmtx2oC98T6mAxEmKDhvA07ndnfoYVpL7LyUEj5pT/a10Nfr1GtXYAbcDRrSmmD+3tlQnI7EE3+OSg8DZx1wtzaWheSMm6ihJVf/WIxYza4ufLs7FxFFQNi9r/OzMkyEBc9Q+7t4QKFsGUWyMck5LBT+kkjuFgAgQRDjPEyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OHNartIMJuE1JopEV8Oq7pEMYtwizY3DgQyfbhojsJ8=;
 b=xiX83ApeidApI0sKO1Kp9SnmjlxpCm89KG0ei4OXvDAaPc3ccDvwxri5IDQ29mS2zboSxBjoYwQ+p6xYJ3adcdCaYLdBn70xBblo6znca7e3qh+1vV27iWBNF+GZvLkCOKsRtCJiQB0sY6UXovUDi7eDPzGTcgxNPwM8GshAlyc=
Received: from DM6PR05MB4044.namprd05.prod.outlook.com (20.176.71.154) by
 DM6PR05MB3947.namprd05.prod.outlook.com (20.176.65.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.11; Fri, 9 Aug 2019 13:22:30 +0000
Received: from DM6PR05MB4044.namprd05.prod.outlook.com
 ([fe80::544c:4d1c:aefd:5de5]) by DM6PR05MB4044.namprd05.prod.outlook.com
 ([fe80::544c:4d1c:aefd:5de5%7]) with mapi id 15.20.2157.020; Fri, 9 Aug 2019
 13:22:30 +0000
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 1/7] trace-cmd: Move trace-output.c into the library code
Thread-Topic: [PATCH 1/7] trace-cmd: Move trace-output.c into the library code
Thread-Index: AQHVN+kCMl4Oo5fdeEO4R0r0wRA46qbyFMiAgADmT4A=
Date:   Fri, 9 Aug 2019 13:22:30 +0000
Message-ID: <CACqStocrJeq70HKFbb_epyQMV1xdtaJ2ywm77uf5ht22KAp0cw@mail.gmail.com>
References: <20190711130307.25041-1-tz.stoyanov@gmail.com>
 <20190711130307.25041-2-tz.stoyanov@gmail.com>
 <20190808193755.346da18f@gandalf.local.home>
In-Reply-To: <20190808193755.346da18f@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM4PR0501CA0059.eurprd05.prod.outlook.com
 (2603:10a6:200:68::27) To DM6PR05MB4044.namprd05.prod.outlook.com
 (2603:10b6:5:8f::26)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tstoyanov@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: APjAAAUmynJrPSguVboi7M3v+xOVX5ZHR81iUcjPzZUrdN1Lh32Tg8lU
        UhVYwshpTWZFQrdvIDCxwTLh1pyLpCt0qFf2eXU=
x-google-smtp-source: APXvYqyZyyX/cOHYp4WYStqhrtQvcuSkr17pYiqVBdL3OZRacpdpWOoIDsTpP0oLmeRLwqjW5EQJfXfZ0sM85tp9WUA=
x-received: by 2002:a5d:4946:: with SMTP id r6mr15097282wrs.266.1565356944522;
 Fri, 09 Aug 2019 06:22:24 -0700 (PDT)
x-gmail-original-message-id: <CACqStocrJeq70HKFbb_epyQMV1xdtaJ2ywm77uf5ht22KAp0cw@mail.gmail.com>
x-originating-ip: [209.85.221.53]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 503fcbb0-723b-4ddd-8f56-08d71ccca185
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DM6PR05MB3947;
x-ms-traffictypediagnostic: DM6PR05MB3947:
x-microsoft-antispam-prvs: <DM6PR05MB39475B654341CC0FB243B6B7DCD60@DM6PR05MB3947.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 01244308DF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(396003)(39860400002)(136003)(366004)(199004)(189003)(54534003)(61726006)(81156014)(14444005)(8936002)(81166006)(478600001)(6246003)(8676002)(4326008)(256004)(55446002)(76176011)(66946007)(25786009)(102836004)(61266001)(66066001)(53936002)(9686003)(7736002)(6512007)(386003)(6506007)(53546011)(64756008)(66476007)(66556008)(498394004)(66446008)(5660300002)(305945005)(99286004)(52116002)(229853002)(2906002)(95326003)(6116002)(6486002)(3846002)(11346002)(6862004)(14454004)(316002)(71190400001)(71200400001)(6436002)(86362001)(186003)(476003)(26005)(446003)(486006)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR05MB3947;H:DM6PR05MB4044.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: oer9LrkikixMmzW0DyVn/rCtLR0hhKNrTiqYtSm7SiTUM5+G7ecpQbCxual4fdGy3wfrtV7EICqVCbAYsWIwzqN7ErWSftBRccDIH8WuiXsYSzKjDqI9Ho3bGPpuVofVlQp1GQ5a4VbKucGlpXnn5w5EyuRfnwXtCGJ9jGz2raUqIFcRHhgzoZNOd0wtResNH4k3BqA+DNfQ99JcwMJq9RcF0fWzgoToWIy6rq76zGbgpQJ4x9uumTQNeTcvH8pzEJhc97SI+97ACx/CVnTmVq55cLmM6vTfjkDpHMG0RZ8PIeicVOSxeBKFW7B+kIpAX0BvBd1A/mdH8ip9xIXmtMuRI5BbtzjNqZ1PkHkZPmvDbqegpVTJnDY6OatFGIQ4Tu5JVZ49Co1dlherCSPmYZEhKoI9mkd6hUbJntHtE6A=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <64EDF36DB63DDE4DA58063911C8CAD1C@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 503fcbb0-723b-4ddd-8f56-08d71ccca185
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2019 13:22:30.6164
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qazJc+E06kXvI9CtyAt2mafbU+uPefG5dsEVK84Im7hUzMWj8kIt3UMDwnlVsyPAxKp2JHeoLKqmauQFqfrI0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR05MB3947
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gRnJpLCBBdWcgOSwgMjAxOSBhdCAyOjM3IEFNIFN0ZXZlbiBSb3N0ZWR0IDxyb3N0ZWR0QGdv
b2RtaXMub3JnPiB3cm90ZToNCj4NCj4gT24gVGh1LCAxMSBKdWwgMjAxOSAxNjowMzowMSArMDMw
MA0KPiAiVHp2ZXRvbWlyIFN0b3lhbm92IChWTXdhcmUpIiA8dHouc3RveWFub3ZAZ21haWwuY29t
PiB3cm90ZToNCj4NCj4gPiBGdW5jdGlvbnMsIGltcGxlbWVudGVkIGluIHRyYWNlLW91dHB1dC5j
IGZpbGUsIGRvIG5vdCBkZXBlbmQgb24NCj4gPiB0cmFjZS1jbWQgYXBwbGljYXRpb24gY29udGV4
dCBhbmQgY2FuIGJlIHVzZWQgc3RhbmRhbG9uZS4gVGhlIGZpbGUNCj4gPiBpcyBtb3ZlZCBmcm9t
IHRyYWNlLWNtZCB0byBsaWJ0cmFjZWNtZC4gSXQgYWxzbyBmaXhlcyBhIHdhcm5pbmcNCj4gPiB3
aGlsZSBsb2FkaW5nIHB5dGhvbiBtb2R1bGVzIGZyb20ga2VybmVsc2hhcms6DQo+ID4gSW1wb3J0
RXJyb3I6IGN0cmFjZWNtZC5zbzogdW5kZWZpbmVkIHN5bWJvbDogdHJhY2VjbWRfYXBwZW5kX2Nw
dV9kYXRhDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBUenZldG9taXIgU3RveWFub3YgKFZNd2Fy
ZSkgPHR6LnN0b3lhbm92QGdtYWlsLmNvbT4NCj4gPiAtLS0NCj4gPiAgbGliL3RyYWNlLWNtZC9N
YWtlZmlsZSAgICAgICAgICAgICAgICAgICAgIHwgMTEgKysrKysrKysrKy0NCj4gPiAge3RyYWNl
Y21kID0+IGxpYi90cmFjZS1jbWR9L3RyYWNlLW91dHB1dC5jIHwgIDANCj4gPiAgdHJhY2VjbWQv
TWFrZWZpbGUgICAgICAgICAgICAgICAgICAgICAgICAgIHwgIDEgLQ0KPiA+ICAzIGZpbGVzIGNo
YW5nZWQsIDEwIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+ID4gIHJlbmFtZSB7dHJh
Y2VjbWQgPT4gbGliL3RyYWNlLWNtZH0vdHJhY2Utb3V0cHV0LmMgKDEwMCUpDQo+ID4NCj4gPiBk
aWZmIC0tZ2l0IGEvbGliL3RyYWNlLWNtZC9NYWtlZmlsZSBiL2xpYi90cmFjZS1jbWQvTWFrZWZp
bGUNCj4gPiBpbmRleCA0NGMxMzMyLi45MDg2ZWI2IDEwMDY0NA0KPiA+IC0tLSBhL2xpYi90cmFj
ZS1jbWQvTWFrZWZpbGUNCj4gPiArKysgYi9saWIvdHJhY2UtY21kL01ha2VmaWxlDQo+ID4gQEAg
LTQsMTIgKzQsMTUgQEAgaW5jbHVkZSAkKHNyYykvc2NyaXB0cy91dGlscy5taw0KPiA+DQo+ID4g
IGJkaXI6PSQob2JqKS9saWIvdHJhY2UtY21kDQo+ID4NCj4gPiAtREVGQVVMVF9UQVJHRVQgPSAk
KGJkaXIpL2xpYnRyYWNlY21kLmENCj4gPiArVENfVkVSU0lPTiA6PSAkKGJkaXIpL2luY2x1ZGUv
dGNfdmVyc2lvbi5oDQo+ID4gKw0KPiA+ICtERUZBVUxUX1RBUkdFVCA9ICQoYmRpcikvbGlidHJh
Y2VjbWQuYSAkKFRDX1ZFUlNJT04pDQo+ID4NCj4gPiAgT0JKUyA9DQo+ID4gIE9CSlMgKz0gdHJh
Y2UtaGFzaC5vDQo+ID4gIE9CSlMgKz0gdHJhY2UtaG9va3Mubw0KPiA+ICBPQkpTICs9IHRyYWNl
LWlucHV0Lm8NCj4gPiArT0JKUyArPSB0cmFjZS1vdXRwdXQubw0KPiA+ICBPQkpTICs9IHRyYWNl
LXJlY29yZGVyLm8NCj4gPiAgT0JKUyArPSB0cmFjZS11dGlsLm8NCj4gPiAgT0JKUyArPSB0cmFj
ZS1maWx0ZXItaGFzaC5vDQo+ID4gQEAgLTI5LDYgKzMyLDkgQEAgJChiZGlyKToNCj4gPiAgJChP
QkpTKTogfCAkKGJkaXIpDQo+ID4gICQoREVQUyk6IHwgJChiZGlyKQ0KPiA+DQo+ID4gKyQoVENf
VkVSU0lPTik6IGZvcmNlIHwgJChiZGlyKS9pbmNsdWRlDQo+ID4gKyAgICAgJChRKSQoY2FsbCB1
cGRhdGVfdmVyc2lvbi5oKQ0KPiA+ICsNCj4NCj4gSGkgQ2VjbywNCj4NCj4gV2h5IHRoZSBhZGRp
dGlvbiBvZiBUQ19WRVJJU09OIGhlcmU/IEl0J3Mgbm90IHN0YXRlZCBpbiB0aGUgY2hhbmdlIGxv
Zw0KPiB0byB3aHkgdGhpcyB3YXMgY29waWVkIG92ZXIuIEkgZXZlciByZW1vdmVkIGFsbCByZWZl
cmVuY2VzIGZyb20NCj4gVENfVkVSU0lPTiBhbmQgaXQgc3RpbGwgYnVpbGRzIGZpbmUuDQo+DQo+
IC0tIFN0ZXZlDQo+DQpUaGVyZSBpcyBhIGRlcGVuZGVuY3k6IHRyYWNlLW91dHB1dC5jIGluY2x1
ZGVzIHZlcnNpb24uaCwgd2hpY2gNCmluY2x1ZGVzIHRjX3ZlcnNpb24uaC4NCldoZW4gdHJhY2Ut
b3V0cHV0LmMgaXMgbW92ZWQgdG8gdGhlIGxpYi90cmFjZS1jbWQgZGlyZWN0b3J5LCBpdA0KaW5j
bHVkZXMgdGNfdmVyc2lvbi5oIGZyb20NCmxpYi90cmFjZS1jbWQvaW5jbHVkZS4gSXQgbWFrZXMg
c2Vuc2UsIG90aGVyd2lzZSB0aGUgbGlidHJhY2VjbWQgd2lsbA0KZGVwZW5kIG9uIHRoZSB0cmFj
ZS1jbWQNCmFwcGxpY2F0aW9uLiBUaGF0J3Mgd2h5IEkgZHVwbGljYXRlZCB0aGF0IFRDX1ZFUklT
T04gbG9naWMgaW4NCmxpYi90cmFjZS1jbWQvTWFrZWZpbGUuIEl0DQpmb3JjZXMgbGliL3RyYWNl
LWNtZC9pbmNsdWRlL3RjX3ZlcnNpb24uaCB0byBiZSBnZW5lcmF0ZWQgb24gZXZlcnkNCmxpYnRy
YWNlY21kIGJ1aWxkLg0KTm93IHdlIGhhdmUgdHdvIGF1dG8gZ2VuZXJhdGVkIGZpbGVzOg0KICAg
IGxpYi90cmFjZS1jbWQvaW5jbHVkZS90Y192ZXJzaW9uLmgNCiAgICB0cmFjZWNtZC9pbmNsdWRl
L3RjX3ZlcnNpb24uaA0KDQpNYXkgYmUgd2Ugc2hvdWxkIG1vdmUgdGNfdmVyc2lvbi5oIHRvIGJl
IGdlbmVyYXRlZCBpbiBpbmNsdWRlLywgc28gd2UNCmNhbiB1c2UgdGhlIHNhbWUgZmlsZSBmcm9t
DQpib3RoIHRoZSBhcHBsaWNhdGlvbiBhbmQgdGhlIGxpYnJhcnkgPw0KDQo+DQo+ID4gICQoYmRp
cikvbGlidHJhY2VjbWQuYTogJChPQkpTKQ0KPiA+ICAgICAgICQoUSkkKGNhbGwgZG9fYnVpbGRf
c3RhdGljX2xpYikNCj4gPg0KPiA+IEBAIC00Myw2ICs0OSw4IEBAICQoYmRpcikvdHJhY2UtdXRp
bC5vOiAkKG9iaikvcGx1Z2lucy90cmFjZV9wbHVnaW5fZGlyDQo+ID4gICQoREVQUyk6ICQoYmRp
cikvLiUuZDogJS5jDQo+ID4gICAgICAgJChRKSQoQ0MpIC1NICQoQ1BQRkxBR1MpICQoQ0ZMQUdT
KSAkPCA+ICRADQo+ID4NCj4gPiArJChERVBTKTogJChUQ19WRVJTSU9OKQ0KPiA+ICsNCj4gPiAg
JChPQkpTKTogJChiZGlyKS8lLm8gOiAkKGJkaXIpLy4lLmQNCj4gPg0KPiA+ICBkZXBfaW5jbHVk
ZXMgOj0gJCh3aWxkY2FyZCAkKERFUFMpKQ0KPiA+IEBAIC01NCw0ICs2Miw1IEBAIGVuZGlmDQo+
ID4gIGNsZWFuOg0KPiA+ICAgICAgICQoUk0pICQoYmRpcikvKi5hICQoYmRpcikvKi5zbyAkKGJk
aXIpLyoubyAkKGJkaXIpLy4qLmQNCj4gPg0KPiA+ICtmb3JjZToNCj4gPiAgLlBIT05ZOiBjbGVh
bg0KPiA+IGRpZmYgLS1naXQgYS90cmFjZWNtZC90cmFjZS1vdXRwdXQuYyBiL2xpYi90cmFjZS1j
bWQvdHJhY2Utb3V0cHV0LmMNCj4gPiBzaW1pbGFyaXR5IGluZGV4IDEwMCUNCj4gPiByZW5hbWUg
ZnJvbSB0cmFjZWNtZC90cmFjZS1vdXRwdXQuYw0KPiA+IHJlbmFtZSB0byBsaWIvdHJhY2UtY21k
L3RyYWNlLW91dHB1dC5jDQo+ID4gZGlmZiAtLWdpdCBhL3RyYWNlY21kL01ha2VmaWxlIGIvdHJh
Y2VjbWQvTWFrZWZpbGUNCj4gPiBpbmRleCBiY2Q0MzdhLi42OTY4ZjgzIDEwMDY0NA0KPiA+IC0t
LSBhL3RyYWNlY21kL01ha2VmaWxlDQo+ID4gKysrIGIvdHJhY2VjbWQvTWFrZWZpbGUNCj4gPiBA
QCAtMjksNyArMjksNiBAQCBUUkFDRV9DTURfT0JKUyArPSB0cmFjZS1yZXN0b3JlLm8NCj4gPiAg
VFJBQ0VfQ01EX09CSlMgKz0gdHJhY2UtY2hlY2stZXZlbnRzLm8NCj4gPiAgVFJBQ0VfQ01EX09C
SlMgKz0gdHJhY2Utc2hvdy5vDQo+ID4gIFRSQUNFX0NNRF9PQkpTICs9IHRyYWNlLWxpc3Qubw0K
PiA+IC1UUkFDRV9DTURfT0JKUyArPSB0cmFjZS1vdXRwdXQubw0KPiA+ICBUUkFDRV9DTURfT0JK
UyArPSB0cmFjZS11c2FnZS5vDQo+ID4gIFRSQUNFX0NNRF9PQkpTICs9IHRyYWNlLW1zZy5vDQo+
ID4NCj4NCg0KDQotLSANClR6dmV0b21pciAoQ2VjbykgU3RveWFub3YNClZNd2FyZSBPcGVuIFNv
dXJjZSBUZWNobm9sb2d5IENlbnRlcg0K
