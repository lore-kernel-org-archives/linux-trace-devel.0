Return-Path: <SRS0=0lml=RS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 316BFC43381
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Mar 2019 10:24:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DCEF1218A5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Mar 2019 10:24:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="AqrLP5Kb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728718AbfCOKYB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 15 Mar 2019 06:24:01 -0400
Received: from mail-eopbgr740080.outbound.protection.outlook.com ([40.107.74.80]:62916
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727428AbfCOKYB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 15 Mar 2019 06:24:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XcABH/ImoKQUlU4RMfgj0vfPPorU1s8+CCbGYIZCk04=;
 b=AqrLP5KbW78FJB7HFcbQOiyYYyW3bXWA7vN36rFaYAJ2FT3hW4V9Q3QGyYCumqSIQB10SxTikuQRwDT/rYucc43IE+3XB8Q8fXSAaOispZvluVuUENz6miCX3ClxY/1HlOlv8vEqi1y7m447d8hG8g7401fC3GNHNndIt7PGfSg=
Received: from CY1PR05MB2780.namprd05.prod.outlook.com (10.167.18.26) by
 CY1PR05MB2700.namprd05.prod.outlook.com (10.167.17.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.11; Fri, 15 Mar 2019 10:23:57 +0000
Received: from CY1PR05MB2780.namprd05.prod.outlook.com
 ([fe80::7cc5:3b5d:2c2c:d84f]) by CY1PR05MB2780.namprd05.prod.outlook.com
 ([fe80::7cc5:3b5d:2c2c:d84f%9]) with mapi id 15.20.1730.003; Fri, 15 Mar 2019
 10:23:57 +0000
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     Yordan Karadzhov <ykaradzhov@vmware.com>
CC:     Steven Rostedt <rostedt@goodmis.org>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 04/12] kernel-shark: Error message if the opening of the
 session file fails
Thread-Topic: [PATCH 04/12] kernel-shark: Error message if the opening of the
 session file fails
Thread-Index: AQHU2xky+5jCJl1iB0qpKlTLNtZIMw==
Date:   Fri, 15 Mar 2019 10:23:57 +0000
Message-ID: <CAE0o1Nt6BCwGSf8pmkZgc1R8Sdf7M+n+MuZ-ArtGt1ZteyJwEw@mail.gmail.com>
References: <20190314151012.905-1-ykaradzhov@vmware.com>
 <20190314151012.905-5-ykaradzhov@vmware.com>
In-Reply-To: <20190314151012.905-5-ykaradzhov@vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: DM5PR04CA0048.namprd04.prod.outlook.com
 (2603:10b6:3:12b::34) To CY1PR05MB2780.namprd05.prod.outlook.com
 (2a01:111:e400:c63a::26)
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: APjAAAV3TzeA/nrgXpZj1tORg3KEe+WMM4pOfqdQ4NRzQqhbKiHc/OOy
        3BKE2CFzUFp1zlKv+GbpYN94DWjXI1rEWezE+w==
x-google-smtp-source: APXvYqyA5bqYQOLbHXRynZBF7rLRD/EO3wSg82unjR543mAPiaR+oNb02V182sI3P+bQ7mqV/v0nUJ4IeL4jhlwowaY=
x-received: by 2002:a5d:878a:: with SMTP id f10mr1797028ion.238.1552645434761;
 Fri, 15 Mar 2019 03:23:54 -0700 (PDT)
x-gmail-original-message-id: <CAE0o1Nt6BCwGSf8pmkZgc1R8Sdf7M+n+MuZ-ArtGt1ZteyJwEw@mail.gmail.com>
x-originating-ip: [209.85.166.49]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fb5c008d-ecc4-48ab-d366-08d6a93054ee
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600127)(711020)(4605104)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:CY1PR05MB2700;
x-ms-traffictypediagnostic: CY1PR05MB2700:
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kaslevs@vmware.com; 
x-microsoft-antispam-prvs: <CY1PR05MB27005D34B17C59839834559CDA440@CY1PR05MB2700.namprd05.prod.outlook.com>
x-forefront-prvs: 09778E995A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(136003)(346002)(396003)(366004)(199004)(189003)(53936002)(446003)(486006)(476003)(5660300002)(97736004)(256004)(11346002)(186003)(26005)(6436002)(68736007)(6636002)(95326003)(2906002)(76176011)(102836004)(99286004)(14444005)(52116002)(9686003)(106356001)(498394004)(105586002)(6512007)(14454004)(86362001)(386003)(6506007)(53546011)(478600001)(55446002)(54906003)(7736002)(6862004)(61726006)(6246003)(61266001)(316002)(71200400001)(71190400001)(305945005)(81166006)(4326008)(6486002)(229853002)(25786009)(81156014)(6116002)(3846002)(8676002)(66066001)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR05MB2700;H:CY1PR05MB2780.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: TF8j4jMR3c6H2kNHXUZIXwVnIJRoEpLIi7HrufDApa7hIt1vg6LlMb0XLE99yI5SxYz2ARVwsEwHHPvhoAojDWjtmqAr+al+brc/M7DLPm9OoK55/16gXXmgcToubQIpRGIbx4gcEfTB3O43ThCNMsdaqSKZYi2afsC/7q5PGKfN/3UIXFynCeGRmAQKrPrPgbBWEJAsUWU5N4Eqsq6apfe942Gc5Udobcw2FBGHkfqfilUJIyzQmwvX4W5VSc9FZs0tQ5nDohv34EBOQyAmfUfITfn+TZmjtiLMcAISDvB8hHxF6lU2+PZxwbUGUJP74qG0Tu8ZgLlRIvj63828+M+uZ+hSnu+uckTQg8Rij3s29ygJ5O+kEPvI5cmaThBoKn3l3D1i3wFSToPY6rga9LoTbKhffqIxoOKVGQmdvtk=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D101DF801C13264EB168AAB1FC8D9862@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb5c008d-ecc4-48ab-d366-08d6a93054ee
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2019 10:23:57.8464
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR05MB2700
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gVGh1LCBNYXIgMTQsIDIwMTkgYXQgNToxMSBQTSBZb3JkYW4gS2FyYWR6aG92IDx5a2FyYWR6
aG92QHZtd2FyZS5jb20+IHdyb3RlOg0KPg0KPiBIZXJlIHdlIGFkZCBwcm9wZXIgaGFuZGxpbmcg
b2YgdGhlIGNhc2Ugd2hlbiB0aGUgbG9hZGluZyBvZiB0aGUNCj4gc2Vzc2lvbiBkZXNjcmlwdGlv
biBmaWxlIGZhaWxzLg0KPg0KPiBTaWduZWQtb2ZmLWJ5OiBZb3JkYW4gS2FyYWR6aG92IDx5a2Fy
YWR6aG92QHZtd2FyZS5jb20+DQo+IC0tLQ0KPiAga2VybmVsLXNoYXJrL3NyYy9Lc01haW5XaW5k
b3cuY3BwIHwgMTEgKysrKysrKysrKy0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAxMCBpbnNlcnRpb25z
KCspLCAxIGRlbGV0aW9uKC0pDQo+DQo+IGRpZmYgLS1naXQgYS9rZXJuZWwtc2hhcmsvc3JjL0tz
TWFpbldpbmRvdy5jcHAgYi9rZXJuZWwtc2hhcmsvc3JjL0tzTWFpbldpbmRvdy5jcHANCj4gaW5k
ZXggOTFlMGM5Zi4uNDQyMjFmNiAxMDA2NDQNCj4gLS0tIGEva2VybmVsLXNoYXJrL3NyYy9Lc01h
aW5XaW5kb3cuY3BwDQo+ICsrKyBiL2tlcm5lbC1zaGFyay9zcmMvS3NNYWluV2luZG93LmNwcA0K
PiBAQCAtMTAxMCw3ICsxMDEwLDE2IEBAIHZvaWQgS3NNYWluV2luZG93Ojpsb2FkU2Vzc2lvbihj
b25zdCBRU3RyaW5nICZmaWxlTmFtZSkNCj4gICAgICAgICAgICAgICAgIHJldHVybjsNCj4gICAg
ICAgICB9DQo+DQo+IC0gICAgICAgX3Nlc3Npb24uaW1wb3J0RnJvbUZpbGUoZmlsZU5hbWUpOw0K
PiArICAgICAgIGlmICghX3Nlc3Npb24uaW1wb3J0RnJvbUZpbGUoZmlsZU5hbWUpKSB7DQo+ICsg
ICAgICAgICAgICAgICBRU3RyaW5nIHRleHQoIlVuYWJsZSB0byBvcGVuIHNlc3Npb24gZGVzY3Jp
cHRpb24gZmlsZSAiKTsNCj4gKw0KPiArICAgICAgICAgICAgICAgdGV4dC5hcHBlbmQoZmlsZU5h
bWUpOw0KPiArICAgICAgICAgICAgICAgdGV4dC5hcHBlbmQoIi5cbiIpOw0KDQpJbW8gdGhpcyBp
cyBjbGVhbmVyIHdpdGggc3RyaW5nIGludGVycG9sYXRpb24sIGUuZy4NCg0KICAgICAgICBRU3Ry
aW5nIHRleHQgPSBRU3RyaW5nKCJVbmFibGUgdG8gb3BlbiBzZXNzaW9uIGRlc2NyaXB0aW9uDQpm
aWxlICUxLlxuIikuYXJnKGZpbGVOYW1lKTsNCg0KLS0gU2xhdmkNCg0KPiArICAgICAgICAgICAg
ICAgX2Vycm9yKHRleHQsICJsb2FkU2Vzc0VycjEiLCB0cnVlLCB0cnVlKTsNCj4gKw0KPiArICAg
ICAgICAgICAgICAgcmV0dXJuOw0KPiArICAgICAgIH0NCj4gKw0KPiAgICAgICAgIF9zZXNzaW9u
LmxvYWRQbHVnaW5zKGtzaGFya19jdHgsICZfcGx1Z2lucyk7DQo+DQo+ICAgICAgICAgUVN0cmlu
ZyBkYXRhRmlsZShfc2Vzc2lvbi5nZXREYXRhRmlsZShrc2hhcmtfY3R4KSk7DQo+IC0tDQo+IDIu
MTkuMQ0KPg0K
