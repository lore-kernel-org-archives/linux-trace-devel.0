Return-Path: <SRS0=W4op=VX=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B8CBC7618B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Jul 2019 08:26:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE749216C8
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Jul 2019 08:26:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="0Gd5f6fR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726001AbfGZI0A (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 26 Jul 2019 04:26:00 -0400
Received: from mail-eopbgr780055.outbound.protection.outlook.com ([40.107.78.55]:18688
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725815AbfGZI0A (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 26 Jul 2019 04:26:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m64IL3+kgaI39X3Zu4qVJP/AQo9pR2l4dHzX2BMtqiWTFFFf7W77JXe2HmBaHwDFuc1jTRF5F2Wzn3LHLgxp1gHLckqGh6YxceNTGXpea0e3BKBdvMW4TSDGth4nPFyo6sC9Fnl6U8mvCFBVmE7w4riAipTdIeKPDKYxLdEtyBMaMi/DdZx2O4z3ilqSoc8kbTV5e855D7rVgQZzhHojFwYdxmwOS8ClYIHH1ewrKsRdagjWKsSzhoN+EeVPy8eyZptX8bOnhVVhaNInMIfkjQB65upnp5gxkTSjhqU47gNGCeP7dqFnH0TjZoYyzWgqLo2cAsfxqW29xSNdYQLkAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B38oYWoUZd4KSiIUkB/tPR1uQFiV5yehAFPWO3Um9GQ=;
 b=K3tz92q52YOJTd9fHfJ1+7WT1wsMUy0jhkzNbiCPizCGE2711YOUhP0iLWzBOXRpKZXB9x8Saw/Yd1QMI4OqnkdUgNrLNLjgl3zxzJvrZOsIlmfAhu+/c0fcK4/c9ZDqS/TiJy9ubknV1Puv/nx3JzcD4QF5lou4reSuy9SlWDeWEVuf2KXymFzRLD8by8PrxxIszgkTAvZ73V6RRHgHtBsBJJ3wbRP+LJyNvFZ2gA0rSnUWXcOV4S/zrhmpqvRIr+BKvdVkb5FwGhpsmfKP/SeYmmFhgEs7/kbiFC7ayCXM2vuc1efWEAmQHTo09wqnhV2dhpZPF4n2pY9tjcctoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=vmware.com;dmarc=pass action=none
 header.from=vmware.com;dkim=pass header.d=vmware.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B38oYWoUZd4KSiIUkB/tPR1uQFiV5yehAFPWO3Um9GQ=;
 b=0Gd5f6fRv3xtMMeTB+HfpuCoaDjQf6dKXmThNVyZiR61GyJZeltkvNTxEP6plHe1gfsEshGp1WeY8CHFS8Dg1jXlk+AhvW2u+5OzZP/JFiH+ILtqRzJtKREMa7u/xDnHM4b9WqepnCPl2ZxXxfcfvIQrxlqDwbxAVAQGMPW0fxE=
Received: from DM6PR05MB4044.namprd05.prod.outlook.com (20.176.71.154) by
 DM6PR05MB4681.namprd05.prod.outlook.com (20.176.109.206) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.10; Fri, 26 Jul 2019 08:25:56 +0000
Received: from DM6PR05MB4044.namprd05.prod.outlook.com
 ([fe80::544c:4d1c:aefd:5de5]) by DM6PR05MB4044.namprd05.prod.outlook.com
 ([fe80::544c:4d1c:aefd:5de5%7]) with mapi id 15.20.2115.005; Fri, 26 Jul 2019
 08:25:56 +0000
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     Andres Freund <andres@anarazel.de>
CC:     Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH] tools/lib/traceevent, tools/perf: Move struct tep_handler
 definition in a local header file
Thread-Topic: [PATCH] tools/lib/traceevent, tools/perf: Move struct
 tep_handler definition in a local header file
Thread-Index: AQHUXMee7rLvaF870E+qQ+NonXpGNKbeEzWAgABKoQA=
Date:   Fri, 26 Jul 2019 08:25:53 +0000
Message-ID: <CACqStocyU4TEwqBnCOgjaG6MsCaxi1+ZQgJFACNPxw7DBBSsyw@mail.gmail.com>
References: <20181005122225.522155df@gandalf.local.home>
 <20190726035829.4xcw5k2exx4omlvg@alap3.anarazel.de>
In-Reply-To: <20190726035829.4xcw5k2exx4omlvg@alap3.anarazel.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR06CA0103.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::44) To DM6PR05MB4044.namprd05.prod.outlook.com
 (2603:10b6:5:8f::26)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tstoyanov@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: APjAAAVBRpQLrPAn4ha+s0wDjaegnCL3kACEZS8DxUeJgWUk0HdQd0tT
        iZz/jF86VP/Ukjq5lF3M0Fs7mwys4gHKaixxtJE=
x-google-smtp-source: APXvYqzk8Xe9Znp/lYzufdK4L/s/IS0eVPwEDIZs+fqPYWwHCJEkkhgTOT5ptDy1T+mgpYfEvRmizKtwICJFsTKslV8=
x-received: by 2002:adf:de10:: with SMTP id
 b16mr66123855wrm.296.1564129547509; Fri, 26 Jul 2019 01:25:47 -0700 (PDT)
x-gmail-original-message-id: <CACqStocyU4TEwqBnCOgjaG6MsCaxi1+ZQgJFACNPxw7DBBSsyw@mail.gmail.com>
x-originating-ip: [209.85.221.53]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4b33949d-4385-4bb2-ba31-08d711a2dfdc
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DM6PR05MB4681;
x-ms-traffictypediagnostic: DM6PR05MB4681:
x-microsoft-antispam-prvs: <DM6PR05MB46817BA84EA41804EE3EBDF0DCC00@DM6PR05MB4681.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01106E96F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(396003)(366004)(39860400002)(346002)(199004)(189003)(8936002)(81166006)(64756008)(52116002)(81156014)(66446008)(61726006)(102836004)(6666004)(14454004)(6506007)(25786009)(66556008)(76176011)(6436002)(386003)(71200400001)(66946007)(71190400001)(9686003)(6512007)(66476007)(476003)(6486002)(5660300002)(498394004)(229853002)(26005)(61266001)(446003)(53546011)(316002)(86362001)(95326003)(4326008)(6862004)(53936002)(54906003)(186003)(450100002)(99286004)(256004)(6246003)(486006)(2906002)(3846002)(8676002)(7736002)(6116002)(55446002)(305945005)(478600001)(66066001)(68736007)(11346002)(67856001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR05MB4681;H:DM6PR05MB4044.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: mJbWwFkZtduM3SUhYzjlvqK2BxyC2Kz+Y1XhO+siYxVsWsj/T1gBHl2rLBfIKaMLdzQscE4mSEegs59Q2uVyYre9rGtghOcIVpxyiMTz3i5nsjhOq6Ci15bfwOb5iTPVPFyFbhoheop40cu+8EuO7KmDeX327s2QW85YgMY0MdZ3Bllimp7CdmDMyXF5WHQaotTr4a36aP+0MCFbt/+RsQzCF6FvMdIw+XlTyeK4eZs0Ch4HdDyJ9LJkd3hDyEcIuK1D/uhsnfBfAo67/1XS6CK7y68IaOGqZp44sHQ90wsnzLtwaYfoiM3iK8nqb/+epSNSxgnDTt6vm6wF+mb5klnnBcQUSEtyJkwoCIz0OcNFyRmeZK654lJ6APNTXwxv/kdmuIOd7DW1UJokzq9GsiH2aFvcinKz+iX5wE/T7Q4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7F7D128FB0AFD449ACFE8A14147C2A4C@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b33949d-4385-4bb2-ba31-08d711a2dfdc
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2019 08:25:53.6062
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tstoyanov@vmware.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR05MB4681
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

SGkgQW5kcmVzLA0KDQpPbiBGcmksIEp1bCAyNiwgMjAxOSBhdCA2OjU4IEFNIEFuZHJlcyBGcmV1
bmQgPGFuZHJlc0BhbmFyYXplbC5kZT4gd3JvdGU6DQo+DQo+IEhpLA0KPg0KLi4uDQo+DQo+IElz
IGp1c3QgcGxhaW4gd3JvbmcsIGFzOg0KPg0KPiA+IC0gICAgICAgICAgICAgcmV0dXJuIHBldmVu
dC0+ZXZlbnRzW2lkeF07DQo+ID4gKyAgICAgICAgICAgICByZXR1cm4gKGFsbF9ldmVudHMgKyBp
ZHgpOw0KPg0KPiB0aGF0J3Mgbm90IGEgdmFsaWQgY29udmVyc2lvbi4gLT5ldmVudHMgaXNuJ3Qg
YW4gYXJyYXkgb2YgdGVwX2hhbmRsZSwNCj4gaXQncyBhbiBhcnJheSBvZiB0ZXBfaGFuZGxlKiAo
YW5kIGV2ZW4gaWYgaXQgd2VyZSwgdGhlIHByZXZpb3VzIG5vdGF0aW9uDQo+IHdvdWxkIGhhdmUg
bmVlZGVkIHRvIGRlcmVmZXJlbmNlIHRoZSB2YWx1ZSB0byBtYWtlIGl0IGNvbXBhcmFibGUpLiBX
aGF0DQo+IHRoaXMgZG9lcyBpcyBsb29rIGlkeCBiZWhpbmQgdGhlIGluZGl2aWR1YWxseSBhbGxv
Y2F0ZWQgZXZlbnQuIFdoaWNoIGlzDQo+IGluY29ycmVjdC4NCj4NCllvdSBhcmUgcmlnaHQsIGl0
IGlzIGEgYnVnLg0KPg0KLi4uDQo+DQo+IFRoZSBmb2xsb3dpbmcgcGF0Y2ggZml4ZXMgdGhpcyBm
b3IgbWUuIEkgY2FuIHBvbGlzaCBpdCB1cCwgYnV0IEknbQ0KPiB3b25kZXJpbmcgaWYgSSdtIG1p
c3Npbmcgc29tZXRoaW5nIGhlcmU/DQo+DQo+IGRpZmYgLS1naXQgaS90b29scy9saWIvdHJhY2Vl
dmVudC9ldmVudC1wYXJzZS5oIHcvdG9vbHMvbGliL3RyYWNlZXZlbnQvZXZlbnQtcGFyc2UuaA0K
PiBpbmRleCA2NDJmNjhhYjVmYjIuLjdlYmM5YjUzMDhkNCAxMDA2NDQNCj4gLS0tIGkvdG9vbHMv
bGliL3RyYWNlZXZlbnQvZXZlbnQtcGFyc2UuaA0KPiArKysgdy90b29scy9saWIvdHJhY2VldmVu
dC9ldmVudC1wYXJzZS5oDQo+IEBAIC01MTcsNiArNTE3LDcgQEAgaW50IHRlcF9yZWFkX251bWJl
cl9maWVsZChzdHJ1Y3QgdGVwX2Zvcm1hdF9maWVsZCAqZmllbGQsIGNvbnN0IHZvaWQgKmRhdGEs
DQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgdW5zaWduZWQgbG9uZyBsb25nICp2YWx1ZSk7
DQo+DQo+ICBzdHJ1Y3QgdGVwX2V2ZW50ICp0ZXBfZ2V0X2ZpcnN0X2V2ZW50KHN0cnVjdCB0ZXBf
aGFuZGxlICp0ZXApOw0KPiArc3RydWN0IHRlcF9ldmVudCAqdGVwX2dldF9ldmVudChzdHJ1Y3Qg
dGVwX2hhbmRsZSAqdGVwLCBpbnQgaW5kZXgpOw0KPiAgaW50IHRlcF9nZXRfZXZlbnRzX2NvdW50
KHN0cnVjdCB0ZXBfaGFuZGxlICp0ZXApOw0KPiAgc3RydWN0IHRlcF9ldmVudCAqdGVwX2ZpbmRf
ZXZlbnQoc3RydWN0IHRlcF9oYW5kbGUgKnRlcCwgaW50IGlkKTsNCj4NCj4gZGlmZiAtLWdpdCBp
L3Rvb2xzL3BlcmYvdXRpbC90cmFjZS1ldmVudC1wYXJzZS5jIHcvdG9vbHMvcGVyZi91dGlsL3Ry
YWNlLWV2ZW50LXBhcnNlLmMNCj4gaW5kZXggNjJiYzYxMTU1ZGQxLi42YTAzNWZmZDU4YWMgMTAw
NjQ0DQo+IC0tLSBpL3Rvb2xzL3BlcmYvdXRpbC90cmFjZS1ldmVudC1wYXJzZS5jDQo+ICsrKyB3
L3Rvb2xzL3BlcmYvdXRpbC90cmFjZS1ldmVudC1wYXJzZS5jDQo+IEBAIC0xNzksMjggKzE3OSwy
NiBAQCBzdHJ1Y3QgdGVwX2V2ZW50ICp0cmFjZV9maW5kX25leHRfZXZlbnQoc3RydWN0IHRlcF9o
YW5kbGUgKnBldmVudCwNCj4gIHsNCj4gICAgICAgICBzdGF0aWMgaW50IGlkeDsNCj4gICAgICAg
ICBpbnQgZXZlbnRzX2NvdW50Ow0KPiAtICAgICAgIHN0cnVjdCB0ZXBfZXZlbnQgKmFsbF9ldmVu
dHM7DQo+DQo+IC0gICAgICAgYWxsX2V2ZW50cyA9IHRlcF9nZXRfZmlyc3RfZXZlbnQocGV2ZW50
KTsNCj4gICAgICAgICBldmVudHNfY291bnQgPSB0ZXBfZ2V0X2V2ZW50c19jb3VudChwZXZlbnQp
Ow0KPiAtICAgICAgIGlmICghcGV2ZW50IHx8ICFhbGxfZXZlbnRzIHx8IGV2ZW50c19jb3VudCA8
IDEpDQo+ICsgICAgICAgaWYgKCFwZXZlbnQgfHwgZXZlbnRzX2NvdW50IDwgMSkNCj4gICAgICAg
ICAgICAgICAgIHJldHVybiBOVUxMOw0KPg0KPiAgICAgICAgIGlmICghZXZlbnQpIHsNCj4gICAg
ICAgICAgICAgICAgIGlkeCA9IDA7DQo+IC0gICAgICAgICAgICAgICByZXR1cm4gYWxsX2V2ZW50
czsNCj4gKyAgICAgICAgICAgICAgIHJldHVybiB0ZXBfZ2V0X2V2ZW50KHBldmVudCwgMCk7DQo+
ICAgICAgICAgfQ0KPg0KPiAtICAgICAgIGlmIChpZHggPCBldmVudHNfY291bnQgJiYgZXZlbnQg
PT0gKGFsbF9ldmVudHMgKyBpZHgpKSB7DQo+ICsgICAgICAgaWYgKGlkeCA8IGV2ZW50c19jb3Vu
dCAmJiBldmVudCA9PSB0ZXBfZ2V0X2V2ZW50KHBldmVudCwgaWR4KSkgew0KPiAgICAgICAgICAg
ICAgICAgaWR4Kys7DQo+ICAgICAgICAgICAgICAgICBpZiAoaWR4ID09IGV2ZW50c19jb3VudCkN
Cj4gICAgICAgICAgICAgICAgICAgICAgICAgcmV0dXJuIE5VTEw7DQo+IC0gICAgICAgICAgICAg
ICByZXR1cm4gKGFsbF9ldmVudHMgKyBpZHgpOw0KPiArICAgICAgICAgICAgICAgcmV0dXJuIHRl
cF9nZXRfZXZlbnQocGV2ZW50LCBpZHgpOw0KPiAgICAgICAgIH0NCj4NCj4gICAgICAgICBmb3Ig
KGlkeCA9IDE7IGlkeCA8IGV2ZW50c19jb3VudDsgaWR4KyspIHsNCj4gLSAgICAgICAgICAgICAg
IGlmIChldmVudCA9PSAoYWxsX2V2ZW50cyArIChpZHggLSAxKSkpDQo+IC0gICAgICAgICAgICAg
ICAgICAgICAgIHJldHVybiAoYWxsX2V2ZW50cyArIGlkeCk7DQo+ICsgICAgICAgICAgICAgICBp
ZiAoZXZlbnQgPT0gdGVwX2dldF9ldmVudChwZXZlbnQsIGlkeCAtIDEpKQ0KPiArICAgICAgICAg
ICAgICAgICAgICAgICByZXR1cm4gdGVwX2dldF9ldmVudChwZXZlbnQsIGlkeCk7DQo+ICAgICAg
ICAgfQ0KPiAgICAgICAgIHJldHVybiBOVUxMOw0KPiAgfQ0KPg0KPg0KDQpJJ20gT0sgd2l0aCB0
aGUgZmlyc3QgcGFydCBvZiB0aGUgcGF0Y2gsIHRoZSBjaGFuZ2VzIGluDQp0b29scy9saWIvdHJh
Y2VldmVudC9ldmVudC1wYXJzZS5oLg0KdGVwX2dldF9ldmVudCgpIGlzIGFuIEFQSSBhbmQgaXMg
b21pdHRlZCBpbiB0aGUgaGVhZGVyIGJ5IG1pc3Rha2UsIGl0DQpzaG91bGQgYmUgdGhlcmUuDQoN
CkFzIGZvciB0aGUgZml4IGZvciB0aGUgY3Jhc2ggaXRzZWxmLCBJIHRoaW5rIGl0IHdvdWxkIGJl
IGJldHRlciB0bw0KaW1wbGVtZW50IHlvdXIgc3VnZ2VzdGlvbiAtDQpyZW1vdmluZyB0cmFjZV9m
aW5kX25leHRfZXZlbnQoKSBhdCBhbGwgYW5kIHJlcGxhY2luZyBpdCB3aXRoDQp0ZXBfZ2V0X2V2
ZW50c19jb3VudCgpIGFuZA0KdGVwX2dldF9ldmVudCgpIGxvb3AuDQoNCj4NCj4NCj4gTm90IHJl
bGF0ZWQgdG8gdGhpcyBjcmFzaCwgYnV0IGl0IGFsc28gc2VlbXMgdGhhdCB0aGUgd2hvbGUNCj4g
dHJhY2VfZmluZF9uZXh0X2V2ZW50KCkgQVBJIG91Z2h0IHRvIGJlIHJlbW92ZWQuIEJhY2sgd2hl
biBpdCB3YXMNCj4NCj4gLXN0cnVjdCBldmVudCAqdHJhY2VfZmluZF9uZXh0X2V2ZW50KHN0cnVj
dCBldmVudCAqZXZlbnQpDQo+IC17DQo+IC0gICAgICAgaWYgKCFldmVudCkNCj4gLSAgICAgICAg
ICAgICAgIHJldHVybiBldmVudF9saXN0Ow0KPiAtDQo+IC0gICAgICAgcmV0dXJuIGV2ZW50LT5u
ZXh0Ow0KPiAtfQ0KPg0KPiBpdCBtYWRlIHNvbWUgc2Vuc2UsIGJ1dCB0aGUgY2hhbmdlcyBpbg0K
Pg0KPiBjb21taXQgYWFmMDQ1ZjcyMzM1NjUzYjI0Nzg0ZDYwNDJiZThlNGFlZTExNDQwMw0KPiBB
dXRob3I6IFN0ZXZlbiBSb3N0ZWR0IDxzcm9zdGVkdEByZWRoYXQuY29tPg0KPiBEYXRlOiAgIDIw
MTItMDQtMDYgMDA6NDc6NTYgKzAyMDANCj4NCj4gICAgIHBlcmY6IEhhdmUgcGVyZiB1c2UgdGhl
IG5ldyBsaWJ0cmFjZWV2ZW50LmEgbGlicmFyeQ0KPg0KPiBzZWVtIHRvIG1ha2UgdGhlIGN1cnJl
bnQgQVBJIHNvbWV3aGF0IGFic3VyZCwgYXMgZXZpZGVuY2VkIGJ5IHRoZQ0KPiBjb21wbGV4aXR5
IGluIHRyYWNlX2ZpbmRfbmV4dF9ldmVudCgpLiBJIG1lYW4gZXZlbiBqdXN0IHJlbW92aW5nIHRo
YXQNCj4gZnVuY3Rpb24gYW5kIGNoYW5naW5nIHRoZSB0d28gY2FsbHNpdGVzIHRvIHNpbXBsZSBm
b3IgbG9vcHMgd2l0aA0KPiB0ZXBfZ2V0X2V2ZW50c19jb3VudCgpICYgdGVwX2dldF9ldmVudCgp
IG91Z2h0IHRvIGJlIGEgbG90IGJldHRlci4NCj4NCj4gR3JlZXRpbmdzLA0KPg0KPiBBbmRyZXMg
RnJldW5kDQoNClRoYW5rcyENCg0KLS0gDQpUenZldG9taXIgKENlY28pIFN0b3lhbm92DQpWTXdh
cmUgT3BlbiBTb3VyY2UgVGVjaG5vbG9neSBDZW50ZXINCg==
