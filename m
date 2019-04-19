Return-Path: <SRS0=h6jj=SV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CBECC282DF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Apr 2019 18:21:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8EAB222AF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Apr 2019 18:21:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="nuVOPNx9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727471AbfDSSVa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 19 Apr 2019 14:21:30 -0400
Received: from mail-eopbgr790074.outbound.protection.outlook.com ([40.107.79.74]:22252
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727571AbfDSSVa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 19 Apr 2019 14:21:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+aXXY63SXjQRfrwqcyjVP5yqHJ4B81OTBM14eNOv8FM=;
 b=nuVOPNx9XAsI70oVi/Bq/M/rEZ1dKl1b4XRIDT6agrZCQghw/R6Nm0lST7bfhh6g47DywsFJ8ithK4so4jbdTK9OwivD0ImOW7oNcaa6SiPCah/j0j+PZvI0TyWf83sz1J2SdXvl3y5FxJclTJZJxbpDwjlCWPoCDY5IfcLR6Sw=
Received: from MWHPR0501MB3772.namprd05.prod.outlook.com (10.167.163.156) by
 MWHPR0501MB3882.namprd05.prod.outlook.com (10.167.173.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.6; Fri, 19 Apr 2019 07:55:58 +0000
Received: from MWHPR0501MB3772.namprd05.prod.outlook.com
 ([fe80::3949:85c0:3b7b:136e]) by MWHPR0501MB3772.namprd05.prod.outlook.com
 ([fe80::3949:85c0:3b7b:136e%5]) with mapi id 15.20.1835.003; Fri, 19 Apr 2019
 07:55:57 +0000
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     Yordan Karadzhov <ykaradzhov@vmware.com>
CC:     "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v2 8/8] kernel-shark: Handle the case when the marker
 points to a filtered entry
Thread-Topic: [PATCH v2 8/8] kernel-shark: Handle the case when the marker
 points to a filtered entry
Thread-Index: AQHU9oVS3jqdyKZSVkKE83v6ZT30tw==
Date:   Fri, 19 Apr 2019 07:55:57 +0000
Message-ID: <ff34ab566d2429281c581f5432eba95d91f99686.camel@vmware.com>
References: <20190418152146.27232-1-ykaradzhov@vmware.com>
         <20190418152146.27232-9-ykaradzhov@vmware.com>
         <CAE0o1NtiXyL9RW2+t6mS2nXkH=ZQz2vukDMz3f4dTiLBxJG+8w@mail.gmail.com>
         <b0021d24-65c0-7e97-6c23-a13732bc7760@vmware.com>
In-Reply-To: <b0021d24-65c0-7e97-6c23-a13732bc7760@vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kaslevs@vmware.com; 
x-originating-ip: [213.145.108.35]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f87af6fc-201d-40f7-4862-08d6c49c7537
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:MWHPR0501MB3882;
x-ms-traffictypediagnostic: MWHPR0501MB3882:
x-microsoft-antispam-prvs: <MWHPR0501MB3882DF26A993F2325F63154FDA270@MWHPR0501MB3882.namprd05.prod.outlook.com>
x-forefront-prvs: 0012E6D357
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(346002)(396003)(366004)(136003)(376002)(189003)(199004)(37006003)(446003)(8676002)(11346002)(86362001)(53936002)(81156014)(81166006)(5660300002)(25786009)(486006)(6506007)(476003)(54906003)(14454004)(7736002)(118296001)(8936002)(186003)(2616005)(66446008)(64756008)(66946007)(91956017)(73956011)(3846002)(99286004)(6116002)(316002)(26005)(14444005)(2906002)(97736004)(305945005)(93886005)(256004)(102836004)(6636002)(68736007)(229853002)(4326008)(6862004)(6486002)(76176011)(6436002)(66066001)(71190400001)(6512007)(478600001)(6246003)(36756003)(71200400001)(66476007)(66556008)(53546011)(76116006);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR0501MB3882;H:MWHPR0501MB3772.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: t9JQij+KOlBleocHM77oMX8qxC3vKyeerQ20qaavS3sDkSzGQYPhSfEQjFNm23+7pBH0V98Zej+7SC1zm68QqyNqseE3DXugR3ZGzOGx6uoQcrZnqynsi8261+zPgw4AL+DiF/NszU5j3qCYwv8azJhfV7UGld60DwwjMHZyQOqDHX/f8boAZT27CTQWReabLtMREtPOV2AGdHJtKXrZnKfjKsLOm4Z5sygJgu+J/8ZdQfnDU4GbESIzQbxWFFmSXgZl6patH3QPO8q9W7odHDOw2UfT4tqDeUb+ElOAdOyEbgZP4yADWzs1ejFoPvdA6373b/nKPBbxpdZwhpbfe3vXY9pM/jMXUfIoIB65JdivNs5dhGG4nHBQtVit+z859YkxPOP7fix047y1gdvaW7qWIAJcHUv/gyBlEUgizf8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E8599704D3F3964BAD88179CA9681981@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f87af6fc-201d-40f7-4862-08d6c49c7537
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2019 07:55:57.8672
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0501MB3882
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gRnJpLCAyMDE5LTA0LTE5IGF0IDA3OjQ2ICswMDAwLCBZb3JkYW4gS2FyYWR6aG92IHdyb3Rl
Og0KPiANCj4gT24gMTkuMDQuMTkg0LMuIDEwOjI5INGHLiwgU2xhdm9taXIgS2FzbGV2IHdyb3Rl
Og0KPiA+IE9uIFRodSwgQXByIDE4LCAyMDE5IGF0IDY6MjMgUE0gWW9yZGFuIEthcmFkemhvdiA8
DQo+ID4geWthcmFkemhvdkB2bXdhcmUuY29tPiB3cm90ZToNCj4gPiA+IE1hcmtlcnMgY2FuIHBv
aW50IHRvIGVudHJpZXMgdGhhdCBhcmUgZmlsdGVyZWQgb3V0LiBXaGVuDQo+ID4gPiBzd2l0Y2hp
bmcNCj4gPiA+IHRoZSBtYXJrZXIgaXQgbWF5IGhhcHBlbiB0aGF0IG5ldyBBY3RpdmUgTWFya2Vy
IHBvaW50cyB0byBhbg0KPiA+ID4gZW50cnkNCj4gPiA+IHRoYXQgaXMgZmlsdGVyZWQuIEluIHRo
aXMgY2FzZSBubyBhY3Rpb25zIG11c3QgYmUgdGFrZW4gYW5kIGENCj4gPiA+IHdhcm5pbmcNCj4g
PiA+IG1lc3NhZ2UgZm9yIHRoZSB1c2VyIG11c3QgYmUgZGlzcGxheWVkLg0KPiA+ID4gDQo+ID4g
PiBTaWduZWQtb2ZmLWJ5OiBZb3JkYW4gS2FyYWR6aG92IDx5a2FyYWR6aG92QHZtd2FyZS5jb20+
DQo+ID4gPiAtLS0NCj4gPiA+ICAga2VybmVsLXNoYXJrL3NyYy9Lc1RyYWNlVmlld2VyLmNwcCB8
IDI3ICsrKysrKysrKysrKysrKysrLS0tLQ0KPiA+ID4gLS0tLS0tDQo+ID4gPiAgIGtlcm5lbC1z
aGFyay9zcmMvS3NUcmFjZVZpZXdlci5ocHAgfCAgMiArKw0KPiA+ID4gICAyIGZpbGVzIGNoYW5n
ZWQsIDE5IGluc2VydGlvbnMoKyksIDEwIGRlbGV0aW9ucygtKQ0KPiA+ID4gDQo+ID4gPiBkaWZm
IC0tZ2l0IGEva2VybmVsLXNoYXJrL3NyYy9Lc1RyYWNlVmlld2VyLmNwcCBiL2tlcm5lbC0NCj4g
PiA+IHNoYXJrL3NyYy9Lc1RyYWNlVmlld2VyLmNwcA0KPiA+ID4gaW5kZXggMDRhMzhiOC4uODVk
YTY0ZiAxMDA2NDQNCj4gPiA+IC0tLSBhL2tlcm5lbC1zaGFyay9zcmMvS3NUcmFjZVZpZXdlci5j
cHANCj4gPiA+ICsrKyBiL2tlcm5lbC1zaGFyay9zcmMvS3NUcmFjZVZpZXdlci5jcHANCj4gPiA+
IEBAIC02MSw3ICs2MSw4IEBAIEtzVHJhY2VWaWV3ZXI6OktzVHJhY2VWaWV3ZXIoUVdpZGdldCAq
cGFyZW50KQ0KPiA+ID4gICAgIF9ncmFwaEZvbGxvd3NDaGVja0JveCh0aGlzKSwNCj4gPiA+ICAg
ICBfZ3JhcGhGb2xsb3dzKHRydWUpLA0KPiA+ID4gICAgIF9tU3RhdGUobnVsbHB0ciksDQo+ID4g
PiAtICBfZGF0YShudWxscHRyKQ0KPiA+ID4gKyAgX2RhdGEobnVsbHB0ciksDQo+ID4gPiArICBf
ZW0odGhpcykNCj4gPiA+ICAgew0KPiA+ID4gICAgICAgICAgdGhpcy0+c2V0U2l6ZVBvbGljeShR
U2l6ZVBvbGljeTo6UHJlZmVycmVkLA0KPiA+ID4gUVNpemVQb2xpY3k6Ok1heGltdW0pOw0KPiA+
ID4gDQo+ID4gPiBAQCAtNDkzLDE1ICs0OTQsMjEgQEAgdm9pZCBLc1RyYWNlVmlld2VyOjptYXJr
U3dpdGNoKCkNCj4gPiA+ICAgICAgICAgICAgICAgICAgUU1vZGVsSW5kZXggaW5kZXggPQ0KPiA+
ID4gICAgICAgICAgICAgICAgICAgICAgICAgIF9wcm94eU1vZGVsLm1hcEZyb21Tb3VyY2UoX21v
ZGVsLmluZGV4KHINCj4gPiA+IG93LCAwKSk7DQo+ID4gPiANCj4gPiA+IC0gICAgICAgICAgICAg
ICAvKg0KPiA+ID4gLSAgICAgICAgICAgICAgICAqIFRoZSByb3cgb2YgdGhlIGFjdGl2ZSBtYXJr
ZXIgd2lsbCBiZSBjb2xvcmVkDQo+ID4gPiBhY2NvcmRpbmcgdG8NCj4gPiA+IC0gICAgICAgICAg
ICAgICAgKiB0aGUgYXNzaWduZWQgcHJvcGVydHkgb2YgdGhlIGN1cnJlbnQgc3RhdGUgb2YNCj4g
PiA+IHRoZSBEdWFsDQo+ID4gPiAtICAgICAgICAgICAgICAgICogbWFya2VyLiBBdXRvLXNjcm9s
bGluZyBpcyB0ZW1wb3JhcmlseSBkaXNhYmxlZA0KPiA+ID4gYmVjYXVzZSB3ZQ0KPiA+ID4gLSAg
ICAgICAgICAgICAgICAqIGRvIG5vdCB3YW50IHRvIHNjcm9sbCB0byB0aGUgcG9zaXRpb24gb2Yg
dGhlDQo+ID4gPiBtYXJrZXIgeWV0Lg0KPiA+ID4gLSAgICAgICAgICAgICAgICAqLw0KPiA+ID4g
LSAgICAgICAgICAgICAgIF92aWV3LnNldEF1dG9TY3JvbGwoZmFsc2UpOw0KPiA+ID4gLSAgICAg
ICAgICAgICAgIF92aWV3LnNlbGVjdFJvdyhpbmRleC5yb3coKSk7DQo+ID4gPiAtICAgICAgICAg
ICAgICAgX3ZpZXcuc2V0QXV0b1Njcm9sbCh0cnVlKTsNCj4gPiA+ICsgICAgICAgICAgICAgICBp
ZiAoaW5kZXguaXNWYWxpZCgpKSB7DQo+ID4gPiArICAgICAgICAgICAgICAgICAgICAgICAvKg0K
PiA+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICogVGhlIHJvdyBvZiB0aGUgYWN0aXZlIG1h
cmtlciB3aWxsIGJlDQo+ID4gPiBjb2xvcmVkIGFjY29yZGluZyB0bw0KPiA+ID4gKyAgICAgICAg
ICAgICAgICAgICAgICAgICogdGhlIGFzc2lnbmVkIHByb3BlcnR5IG9mIHRoZSBjdXJyZW50DQo+
ID4gPiBzdGF0ZSBvZiB0aGUgRHVhbA0KPiA+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICog
bWFya2VyLiBBdXRvLXNjcm9sbGluZyBpcyB0ZW1wb3JhcmlseQ0KPiA+ID4gZGlzYWJsZWQgYmVj
YXVzZSB3ZQ0KPiA+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICogZG8gbm90IHdhbnQgdG8g
c2Nyb2xsIHRvIHRoZSBwb3NpdGlvbg0KPiA+ID4gb2YgdGhlIG1hcmtlciB5ZXQuDQo+ID4gPiAr
ICAgICAgICAgICAgICAgICAgICAgICAgKi8NCj4gPiA+ICsgICAgICAgICAgICAgICAgICAgICAg
IF92aWV3LnNldEF1dG9TY3JvbGwoZmFsc2UpOw0KPiA+ID4gKyAgICAgICAgICAgICAgICAgICAg
ICAgX3ZpZXcuc2VsZWN0Um93KGluZGV4LnJvdygpKTsNCj4gPiA+ICsgICAgICAgICAgICAgICAg
ICAgICAgIF92aWV3LnNldEF1dG9TY3JvbGwodHJ1ZSk7DQo+ID4gPiArICAgICAgICAgICAgICAg
fSBlbHNlIHsNCj4gPiA+ICsgICAgICAgICAgICAgICAgICAgICAgIF92aWV3LmNsZWFyU2VsZWN0
aW9uKCk7DQo+ID4gPiArICAgICAgICAgICAgICAgICAgICAgICBRU3RyaW5nIGVycigiVGhlIG1h
cmtlcidzIGVudHJ5IGlzDQo+ID4gPiBmaWx0ZXJlZCBvdXQuIik7DQo+ID4gPiArICAgICAgICAg
ICAgICAgICAgICAgICBfZW0uc2hvd01lc3NhZ2UoZXJyKTsNCj4gPiANCj4gPiBXaGVuIGlzIHRo
aXMgZXJyb3IgbWVzc2FnZSBnb2luZyB0byBiZSBjbGVhcmVkPyBJIGRvbid0IHRoaW5rIGl0DQo+
ID4gY2hhbmdlcyBhdG0gdW5sZXNzIGEgbmV3IGVycm9yIGNvbWVzIGFsb25nLg0KPiANCj4gVGhl
IG1lc3NhZ2Ugd2lsbCBiZSBkaXNwbGF5ZWQgaW4gYSBzbWFsbCB3aWRnZXQgKFFFcnJvck1lc3Nh
Z2UpLg0KPiBUaGlzIA0KPiB3aWRnZXQgaGFzIGFuICJPSyIgYnV0dG9uIGFuZCBhICJTaG93IHRo
aXMgbWVzc2FnZSBhZ2FpbiIgY2hlY2tib3guDQo+IA0KPiBUbyBjbGVhciB0aGUgbWVzc2FnZSB5
b3UgY2FuIGVpdGhlciBwcmVzcyAiT0siIG9yIGNsb3NlIHRoZSB3aWRnZXQuDQo+IElmIHlvdSB1
bmNoZWNrIHRoZSAiU2hvdyB0aGlzIG1lc3NhZ2UgYWdhaW4iIGNoZWNrYm94LCBubyBtZXNzYWdl
DQo+IHdpbGwgDQo+IGJlIHNob3duIG5leHQgdGltZSB3aGVuIHRoZSBlcnJvciBvY2N1cnMuDQoN
ClRoYXQgbWFrZXMgc2Vuc2UsIGluIHRoYXQgY2FzZSBpdCBsZ3RtDQoNClJldmlld2VkLWJ5OiBT
bGF2b21pciBLYXNsZXYgPGthc2xldnNAdm13YXJlLmNvbT4NCg0KLS0gU2xhdmkNCg==
