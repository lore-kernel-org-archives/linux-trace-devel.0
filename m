Return-Path: <SRS0=0SC1=RX=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23CD3C43381
	for <linux-trace-devel@archiver.kernel.org>; Wed, 20 Mar 2019 14:39:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE2A82184E
	for <linux-trace-devel@archiver.kernel.org>; Wed, 20 Mar 2019 14:39:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="gvMk9Ave"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726644AbfCTOjS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 20 Mar 2019 10:39:18 -0400
Received: from mail-eopbgr760088.outbound.protection.outlook.com ([40.107.76.88]:21634
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726686AbfCTOjS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 20 Mar 2019 10:39:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NgIclr3eOTOpWi28j0OxqmPIrASsiNiLcGPGMkV4UHc=;
 b=gvMk9AvelpqRpQskoBYl2cU1WEpK7Rv8f46ZKFpRTqKv65sHr2PVwgM2QBwdoqD2P33Niya6h68MCisjFRPkbQEZX7ko5o3OsscgEghbsZzyj79zFZ/Hn0cg0CZxQUB8Zyop26lyb90TJCsgWwj3p1QhAWqpf/JIcnZ6i/FzAUA=
Received: from CY1PR05MB2761.namprd05.prod.outlook.com (10.167.18.19) by
 CY1PR05MB2428.namprd05.prod.outlook.com (10.167.10.9) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.15; Wed, 20 Mar 2019 14:39:12 +0000
Received: from CY1PR05MB2761.namprd05.prod.outlook.com
 ([fe80::50:9d56:d444:62ec]) by CY1PR05MB2761.namprd05.prod.outlook.com
 ([fe80::50:9d56:d444:62ec%4]) with mapi id 15.20.1730.013; Wed, 20 Mar 2019
 14:39:12 +0000
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     Slavomir Kaslev <kaslevs@vmware.com>
CC:     Steven Rostedt <rostedt@goodmis.org>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v7 8/9] trace-cmd: Implemented new option in trace.dat
 file: TRACECMD_OPTION_TIME_SHIFT
Thread-Topic: [PATCH v7 8/9] trace-cmd: Implemented new option in trace.dat
 file: TRACECMD_OPTION_TIME_SHIFT
Thread-Index: AQHU3mw7MTxXBKpDFUCsvBrno3gsy6YTPmUAgAFaDQA=
Date:   Wed, 20 Mar 2019 14:39:12 +0000
Message-ID: <CACqStocM8Z914mB4iTeZz310mtEcyxpoC6r3zvY1DZxKx+3R_Q@mail.gmail.com>
References: <20190319155536.19381-1-tstoyanov@vmware.com>
 <20190319155536.19381-9-tstoyanov@vmware.com>
 <CAE0o1NvnEv=z88gFST7+hrb-345CS7rjop+tU561j=CsYju00A@mail.gmail.com>
In-Reply-To: <CAE0o1NvnEv=z88gFST7+hrb-345CS7rjop+tU561j=CsYju00A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5PR0502CA0019.eurprd05.prod.outlook.com
 (2603:10a6:203:91::29) To CY1PR05MB2761.namprd05.prod.outlook.com
 (2a01:111:e400:c63a::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tstoyanov@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: APjAAAVT734Fg5SXFg65LzsxPT8kFLsMcD/ao6NhG8UcbHF9VzYPV1u6
        ysO50gmkNdeq0qCfwtQYFvV/KniMlffgIKqIOOw=
x-google-smtp-source: APXvYqwIymjD+0vS+ihIKm8xBftwd8CQyUcaDKsMGBOr7Q1q9lRr62MhiwBMixIyWdmFyg2yoZtITIHJfodhSNUhnIk=
x-received: by 2002:a1c:cb0f:: with SMTP id b15mr6501191wmg.88.1553092747409;
 Wed, 20 Mar 2019 07:39:07 -0700 (PDT)
x-gmail-original-message-id: <CACqStocM8Z914mB4iTeZz310mtEcyxpoC6r3zvY1DZxKx+3R_Q@mail.gmail.com>
x-originating-ip: [209.85.128.42]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9aedeb5f-1107-46b2-720e-08d6ad41d16f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:CY1PR05MB2428;
x-ms-traffictypediagnostic: CY1PR05MB2428:
x-microsoft-antispam-prvs: <CY1PR05MB24285C925B6DD8707F50E95EDC410@CY1PR05MB2428.namprd05.prod.outlook.com>
x-forefront-prvs: 098291215C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(39860400002)(366004)(346002)(376002)(189003)(199004)(486006)(25786009)(53936002)(102836004)(76176011)(99286004)(71200400001)(71190400001)(476003)(66066001)(52116002)(26005)(11346002)(446003)(6246003)(61726006)(53546011)(386003)(6506007)(7736002)(186003)(61266001)(6862004)(106356001)(305945005)(105586002)(4326008)(5660300002)(9686003)(6512007)(54906003)(498394004)(478600001)(6436002)(14454004)(97736004)(68736007)(8936002)(3846002)(95326003)(86362001)(81166006)(6116002)(8676002)(6636002)(229853002)(55446002)(2906002)(256004)(6486002)(81156014)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR05MB2428;H:CY1PR05MB2761.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: D+DWyMtwJD+LvGXx4u4nmMFK4kuPt4n5W1o4DDweUvNZJ2vs9144gFoALdqYUcUmrHaQY0E/we2HVR/LPb2GnHuxpj5DTQcnnZuFN54ZQJlH0FJdDXnwUpnIdqhIgxrQTCzCTr1IZU/6UuXckJmLIZgQRi4nPF8650H6+M5XXY5JekUKN3bsdfebHOoVaQsSw2n1JUGXG02fMaXJHxGaTtIqQfxAW4Nzi3CMJUI+9anMtKFeJeZ5OTmj65CG3lLdGX//Wr4j/cvOVJnC8PB583kx8MfJi+At/NPs3At2dO/s+FiH5rDfJtGOB5HLs+piBbDh3mZ3rbyIQltiadQcWmUKWmOpwTwcN4nBagAbOTqKhKQ47cRnxHV8twQer3zKmHICCrLK+/Eqkm+5Vjy7dMkghrWcABvDXcaDP/klrMU=
Content-Type: text/plain; charset="utf-8"
Content-ID: <484E67DEEE57544E88BB3CB499B6D680@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9aedeb5f-1107-46b2-720e-08d6ad41d16f
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2019 14:39:12.2359
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR05MB2428
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gVHVlLCBNYXIgMTksIDIwMTkgYXQgODowMCBQTSBTbGF2b21pciBLYXNsZXYgPGthc2xldnNA
dm13YXJlLmNvbT4gd3JvdGU6DQo+DQo+IE9uIFR1ZSwgTWFyIDE5LCAyMDE5IGF0IDU6NTYgUE0g
VHp2ZXRvbWlyIFN0b3lhbm92IDx0c3RveWFub3ZAdm13YXJlLmNvbT4gd3JvdGU6DQo+ID4NCj4g
PiBUaGUgVFJBQ0VDTURfT1BUSU9OX1RJTUVfU0hJRlQgaXMgdXNlZCB3aGVuIHN5bmNocm9uaXpp
bmcgdHJhY2UgdGltZSBzdGFtcHMgYmV0d2Vlbg0KPiA+IHR3byB0cmFjZS5kYXQgZmlsZXMuIEl0
IGNvbnRhaW5zIG11bHRpcGxlIGxvbmcgbG9uZyAodGltZSwgb2Zmc2V0KSBwYWlycywgZGVzY3Jp
YmluZw0KPiA+IHRpbWUgc3RhbXBzIF9vZmZzZXRfLCBtZWFzdXJlZCBpbiB0aGUgZ2l2ZW4gbG9j
YWwgX3RpbWVfLiBUaGUgY29udGVudCBvZiB0aGUgb3B0aW9uDQo+ID4gYnVmZmVyIGlzOg0KPiA+
ICBmaXJzdCA0IGJ5dGVzIC0gaW50ZWdlciwgY291bnQgb2YgdGltZXN0YW1wIG9mZnNldHMNCj4g
PiAgbG9uZyBsb25nIGFycmF5IG9mIHNpemUgX2NvdW50XywgbG9jYWwgdGltZSBpbiB3aGljaCB0
aGUgb2Zmc2V0IGlzIG1lYXN1cmVkDQo+ID4gIGxvbmcgbG9uZyBhcnJheSBvZiBzaXplIF9jb3Vu
dF8sIG9mZnNldCBvZiB0aGUgdGltZSBzdGFtcHMNCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFR6
dmV0b21pciBTdG95YW5vdiA8dHN0b3lhbm92QHZtd2FyZS5jb20+DQo+ID4gLS0tDQo+ID4gIGlu
Y2x1ZGUvdHJhY2UtY21kL3RyYWNlLWNtZC5oIHwgICAxICsNCj4gPiAgbGliL3RyYWNlLWNtZC90
cmFjZS1pbnB1dC5jICAgfCAxMjcgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLQ0K
PiA+ICAyIGZpbGVzIGNoYW5nZWQsIDEyNiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0K
PiA+DQo+ID4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvdHJhY2UtY21kL3RyYWNlLWNtZC5oIGIvaW5j
bHVkZS90cmFjZS1jbWQvdHJhY2UtY21kLmgNCj4gPiBpbmRleCBmN2MwNDNhLi41NTUyMzk2IDEw
MDY0NA0KPiA+IC0tLSBhL2luY2x1ZGUvdHJhY2UtY21kL3RyYWNlLWNtZC5oDQo+ID4gKysrIGIv
aW5jbHVkZS90cmFjZS1jbWQvdHJhY2UtY21kLmgNCj4gPiBAQCAtODIsNiArODIsNyBAQCBlbnVt
IHsNCj4gPiAgICAgICAgIFRSQUNFQ01EX09QVElPTl9IT09LLA0KPiA+ICAgICAgICAgVFJBQ0VD
TURfT1BUSU9OX09GRlNFVCwNCj4gPiAgICAgICAgIFRSQUNFQ01EX09QVElPTl9DUFVDT1VOVCwN
Cj4gPiArICAgICAgIFRSQUNFQ01EX09QVElPTl9USU1FX1NISUZULA0KPiA+ICB9Ow0KPiA+DQo+
ID4gIGVudW0gew0KPiA+IGRpZmYgLS1naXQgYS9saWIvdHJhY2UtY21kL3RyYWNlLWlucHV0LmMg
Yi9saWIvdHJhY2UtY21kL3RyYWNlLWlucHV0LmMNCj4gPiBpbmRleCAwYTZlODIwLi4wNGYyMjJk
IDEwMDY0NA0KPiA+IC0tLSBhL2xpYi90cmFjZS1jbWQvdHJhY2UtaW5wdXQuYw0KPiA+ICsrKyBi
L2xpYi90cmFjZS1jbWQvdHJhY2UtaW5wdXQuYw0KPiA+IEBAIC03NSw2ICs3NSwxMSBAQCBzdHJ1
Y3QgaW5wdXRfYnVmZmVyX2luc3RhbmNlIHsNCj4gPiAgICAgICAgIHNpemVfdCAgICAgICAgICAg
ICAgICAgIG9mZnNldDsNCj4gPiAgfTsNCj4gPg0KPiA+ICtzdHJ1Y3QgdHNfb2Zmc2V0X3NhbXBs
ZSB7DQo+ID4gKyAgICAgICBsb25nIGxvbmcgICAgICAgdGltZTsNCj4gPiArICAgICAgIGxvbmcg
bG9uZyAgICAgICBvZmZzZXQ7DQo+ID4gK307DQo+ID4gKw0KPiA+ICBzdHJ1Y3QgdHJhY2VjbWRf
aW5wdXQgew0KPiA+ICAgICAgICAgc3RydWN0IHRlcF9oYW5kbGUgICAgICAgKnBldmVudDsNCj4g
PiAgICAgICAgIHN0cnVjdCB0ZXBfcGx1Z2luX2xpc3QgICpwbHVnaW5fbGlzdDsNCj4gPiBAQCAt
OTIsNiArOTcsOCBAQCBzdHJ1Y3QgdHJhY2VjbWRfaW5wdXQgew0KPiA+ICAgICAgICAgYm9vbCAg
ICAgICAgICAgICAgICAgICAgdXNlX3BpcGU7DQo+ID4gICAgICAgICBzdHJ1Y3QgY3B1X2RhdGEg
ICAgICAgICAqY3B1X2RhdGE7DQo+ID4gICAgICAgICBsb25nIGxvbmcgICAgICAgICAgICAgICB0
c19vZmZzZXQ7DQo+ID4gKyAgICAgICBpbnQgICAgICAgICAgICAgICAgICAgICB0c19jb3JyX2Nv
dW50Ow0KPiA+ICsgICAgICAgc3RydWN0IHRzX29mZnNldF9zYW1wbGUgKnRzX2NvcnI7DQo+DQo+
IE5pdDoNCj4gdHNfY29ycl9jb3VudCAtPiB0c19zYW1wbGVzX2NvdW50DQo+IHRzX2NvcnIgLT4g
dHNfc2FtcGxlcw0KDQpUaGFua3MgU2xhdmkNCg0KLS0gDQoNClR6dmV0b21pciAoQ2VjbykgU3Rv
eWFub3YNClZNd2FyZSBPcGVuIFNvdXJjZSBUZWNobm9sb2d5IENlbnRlcg0K
