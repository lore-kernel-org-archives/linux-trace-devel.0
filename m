Return-Path: <SRS0=h6jj=SV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC4E0C282DF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Apr 2019 18:16:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9AF89222E9
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Apr 2019 18:16:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="DWlPDdNd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726807AbfDSSQi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 19 Apr 2019 14:16:38 -0400
Received: from mail-eopbgr790049.outbound.protection.outlook.com ([40.107.79.49]:23933
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725821AbfDSSQh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 19 Apr 2019 14:16:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o/kOr/5KPi3PuQAGXTILPTUJXR0CI/xnl0UvZNgpIpc=;
 b=DWlPDdNdeRkfJrs/5IPgYZNdYPkr5EcUHGuqTk9gw3uma2Mqti7shym/dR6AfSBNFd0z7E36ksPowjnthp3BvHj41bWMraZ2DO98v3D/q4OR72BCRcnVrefQlMWjCU5RWtXqVOTG+Al2/d3XPu5PEdl7q3bYTLGas1/vdrs9bXY=
Received: from SN4PR0501MB3903.namprd05.prod.outlook.com (10.167.142.151) by
 SN4PR0501MB3742.namprd05.prod.outlook.com (10.167.151.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.7; Fri, 19 Apr 2019 07:46:10 +0000
Received: from SN4PR0501MB3903.namprd05.prod.outlook.com
 ([fe80::9863:fa92:a642:b111]) by SN4PR0501MB3903.namprd05.prod.outlook.com
 ([fe80::9863:fa92:a642:b111%2]) with mapi id 15.20.1813.009; Fri, 19 Apr 2019
 07:46:10 +0000
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     Slavomir Kaslev <slavomir.kaslev@gmail.com>,
        Yordan Karadzhov <ykaradzhov@vmware.com>
CC:     Steven Rostedt <rostedt@goodmis.org>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v2 8/8] kernel-shark: Handle the case when the marker
 points to a filtered entry
Thread-Topic: [PATCH v2 8/8] kernel-shark: Handle the case when the marker
 points to a filtered entry
Thread-Index: AQHU9fqc/zAk1ydEbkyIxxKybQ2inKZDF0eAgAAEogA=
Date:   Fri, 19 Apr 2019 07:46:10 +0000
Message-ID: <b0021d24-65c0-7e97-6c23-a13732bc7760@vmware.com>
References: <20190418152146.27232-1-ykaradzhov@vmware.com>
 <20190418152146.27232-9-ykaradzhov@vmware.com>
 <CAE0o1NtiXyL9RW2+t6mS2nXkH=ZQz2vukDMz3f4dTiLBxJG+8w@mail.gmail.com>
In-Reply-To: <CAE0o1NtiXyL9RW2+t6mS2nXkH=ZQz2vukDMz3f4dTiLBxJG+8w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: DB6PR05CA0027.eurprd05.prod.outlook.com
 (2603:10a6:6:14::40) To SN4PR0501MB3903.namprd05.prod.outlook.com
 (2603:10b6:803:4d::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ykaradzhov@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [146.247.46.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fafd5e32-cf33-432c-4a3e-08d6c49b16ce
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:SN4PR0501MB3742;
x-ms-traffictypediagnostic: SN4PR0501MB3742:
x-microsoft-antispam-prvs: <SN4PR0501MB374257A4C8253CDF722907C6A0270@SN4PR0501MB3742.namprd05.prod.outlook.com>
x-forefront-prvs: 0012E6D357
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(136003)(376002)(39860400002)(366004)(396003)(199004)(189003)(66066001)(7736002)(99286004)(102836004)(5660300002)(52116002)(36756003)(31696002)(86362001)(305945005)(229853002)(25786009)(110136005)(97736004)(316002)(54906003)(14454004)(6436002)(14444005)(71200400001)(478600001)(71190400001)(256004)(6486002)(66556008)(8676002)(81166006)(81156014)(8936002)(6512007)(476003)(53936002)(446003)(2616005)(2906002)(11346002)(3846002)(6116002)(73956011)(31686004)(4326008)(68736007)(6246003)(76176011)(186003)(66446008)(53546011)(486006)(386003)(6506007)(66476007)(26005)(66946007)(64756008);DIR:OUT;SFP:1101;SCL:1;SRVR:SN4PR0501MB3742;H:SN4PR0501MB3903.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: qbNthetNMXv1tAx7JHO1N7k97/FyFNa4X+ku6kMNW49VTmGvot9xaEc8qVTRRt/Nv2hP1rzjYSq++NPKv565Uuj8i+fRX1/Rmks0emNy/MLqhp7O+DzykbcFvSIdfIDpCyC3oLON6mXyvtZv4wnKW8f6d9rbZ1Ie5kXnt4gm2UD9P89Ob1epsXo3hZEpS3sozgR/nzdCIptnVBCy1Pala92hOe4J7/lj6cRlJpFJORFYh5OoQYVPMUCGW8lL0qcQEBcOGwtrpOFAXXOunj8q697hgWIhodJZt1u1QO8kCd6A0pR9ioBHszLpI/9Ps+XdSofHtzEg+4qcrBG1Vi/s4+8aGPwVOrS/0HHXFBRdFdYBIkTV8eCwGRPUzDosXPTCyo9wlOPZiNV1qbfkHrsbOy17A4cIFI8D15nnUeR3QL4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <11A6B7B143833B4D9912721492EFACCA@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fafd5e32-cf33-432c-4a3e-08d6c49b16ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2019 07:46:10.5590
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0501MB3742
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

DQoNCk9uIDE5LjA0LjE5INCzLiAxMDoyOSDRhy4sIFNsYXZvbWlyIEthc2xldiB3cm90ZToNCj4g
T24gVGh1LCBBcHIgMTgsIDIwMTkgYXQgNjoyMyBQTSBZb3JkYW4gS2FyYWR6aG92IDx5a2FyYWR6
aG92QHZtd2FyZS5jb20+IHdyb3RlOg0KPj4NCj4+IE1hcmtlcnMgY2FuIHBvaW50IHRvIGVudHJp
ZXMgdGhhdCBhcmUgZmlsdGVyZWQgb3V0LiBXaGVuIHN3aXRjaGluZw0KPj4gdGhlIG1hcmtlciBp
dCBtYXkgaGFwcGVuIHRoYXQgbmV3IEFjdGl2ZSBNYXJrZXIgcG9pbnRzIHRvIGFuIGVudHJ5DQo+
PiB0aGF0IGlzIGZpbHRlcmVkLiBJbiB0aGlzIGNhc2Ugbm8gYWN0aW9ucyBtdXN0IGJlIHRha2Vu
IGFuZCBhIHdhcm5pbmcNCj4+IG1lc3NhZ2UgZm9yIHRoZSB1c2VyIG11c3QgYmUgZGlzcGxheWVk
Lg0KPj4NCj4+IFNpZ25lZC1vZmYtYnk6IFlvcmRhbiBLYXJhZHpob3YgPHlrYXJhZHpob3ZAdm13
YXJlLmNvbT4NCj4+IC0tLQ0KPj4gICBrZXJuZWwtc2hhcmsvc3JjL0tzVHJhY2VWaWV3ZXIuY3Bw
IHwgMjcgKysrKysrKysrKysrKysrKystLS0tLS0tLS0tDQo+PiAgIGtlcm5lbC1zaGFyay9zcmMv
S3NUcmFjZVZpZXdlci5ocHAgfCAgMiArKw0KPj4gICAyIGZpbGVzIGNoYW5nZWQsIDE5IGluc2Vy
dGlvbnMoKyksIDEwIGRlbGV0aW9ucygtKQ0KPj4NCj4+IGRpZmYgLS1naXQgYS9rZXJuZWwtc2hh
cmsvc3JjL0tzVHJhY2VWaWV3ZXIuY3BwIGIva2VybmVsLXNoYXJrL3NyYy9Lc1RyYWNlVmlld2Vy
LmNwcA0KPj4gaW5kZXggMDRhMzhiOC4uODVkYTY0ZiAxMDA2NDQNCj4+IC0tLSBhL2tlcm5lbC1z
aGFyay9zcmMvS3NUcmFjZVZpZXdlci5jcHANCj4+ICsrKyBiL2tlcm5lbC1zaGFyay9zcmMvS3NU
cmFjZVZpZXdlci5jcHANCj4+IEBAIC02MSw3ICs2MSw4IEBAIEtzVHJhY2VWaWV3ZXI6OktzVHJh
Y2VWaWV3ZXIoUVdpZGdldCAqcGFyZW50KQ0KPj4gICAgIF9ncmFwaEZvbGxvd3NDaGVja0JveCh0
aGlzKSwNCj4+ICAgICBfZ3JhcGhGb2xsb3dzKHRydWUpLA0KPj4gICAgIF9tU3RhdGUobnVsbHB0
ciksDQo+PiAtICBfZGF0YShudWxscHRyKQ0KPj4gKyAgX2RhdGEobnVsbHB0ciksDQo+PiArICBf
ZW0odGhpcykNCj4+ICAgew0KPj4gICAgICAgICAgdGhpcy0+c2V0U2l6ZVBvbGljeShRU2l6ZVBv
bGljeTo6UHJlZmVycmVkLCBRU2l6ZVBvbGljeTo6TWF4aW11bSk7DQo+Pg0KPj4gQEAgLTQ5Mywx
NSArNDk0LDIxIEBAIHZvaWQgS3NUcmFjZVZpZXdlcjo6bWFya1N3aXRjaCgpDQo+PiAgICAgICAg
ICAgICAgICAgIFFNb2RlbEluZGV4IGluZGV4ID0NCj4+ICAgICAgICAgICAgICAgICAgICAgICAg
ICBfcHJveHlNb2RlbC5tYXBGcm9tU291cmNlKF9tb2RlbC5pbmRleChyb3csIDApKTsNCj4+DQo+
PiAtICAgICAgICAgICAgICAgLyoNCj4+IC0gICAgICAgICAgICAgICAgKiBUaGUgcm93IG9mIHRo
ZSBhY3RpdmUgbWFya2VyIHdpbGwgYmUgY29sb3JlZCBhY2NvcmRpbmcgdG8NCj4+IC0gICAgICAg
ICAgICAgICAgKiB0aGUgYXNzaWduZWQgcHJvcGVydHkgb2YgdGhlIGN1cnJlbnQgc3RhdGUgb2Yg
dGhlIER1YWwNCj4+IC0gICAgICAgICAgICAgICAgKiBtYXJrZXIuIEF1dG8tc2Nyb2xsaW5nIGlz
IHRlbXBvcmFyaWx5IGRpc2FibGVkIGJlY2F1c2Ugd2UNCj4+IC0gICAgICAgICAgICAgICAgKiBk
byBub3Qgd2FudCB0byBzY3JvbGwgdG8gdGhlIHBvc2l0aW9uIG9mIHRoZSBtYXJrZXIgeWV0Lg0K
Pj4gLSAgICAgICAgICAgICAgICAqLw0KPj4gLSAgICAgICAgICAgICAgIF92aWV3LnNldEF1dG9T
Y3JvbGwoZmFsc2UpOw0KPj4gLSAgICAgICAgICAgICAgIF92aWV3LnNlbGVjdFJvdyhpbmRleC5y
b3coKSk7DQo+PiAtICAgICAgICAgICAgICAgX3ZpZXcuc2V0QXV0b1Njcm9sbCh0cnVlKTsNCj4+
ICsgICAgICAgICAgICAgICBpZiAoaW5kZXguaXNWYWxpZCgpKSB7DQo+PiArICAgICAgICAgICAg
ICAgICAgICAgICAvKg0KPj4gKyAgICAgICAgICAgICAgICAgICAgICAgICogVGhlIHJvdyBvZiB0
aGUgYWN0aXZlIG1hcmtlciB3aWxsIGJlIGNvbG9yZWQgYWNjb3JkaW5nIHRvDQo+PiArICAgICAg
ICAgICAgICAgICAgICAgICAgKiB0aGUgYXNzaWduZWQgcHJvcGVydHkgb2YgdGhlIGN1cnJlbnQg
c3RhdGUgb2YgdGhlIER1YWwNCj4+ICsgICAgICAgICAgICAgICAgICAgICAgICAqIG1hcmtlci4g
QXV0by1zY3JvbGxpbmcgaXMgdGVtcG9yYXJpbHkgZGlzYWJsZWQgYmVjYXVzZSB3ZQ0KPj4gKyAg
ICAgICAgICAgICAgICAgICAgICAgICogZG8gbm90IHdhbnQgdG8gc2Nyb2xsIHRvIHRoZSBwb3Np
dGlvbiBvZiB0aGUgbWFya2VyIHlldC4NCj4+ICsgICAgICAgICAgICAgICAgICAgICAgICAqLw0K
Pj4gKyAgICAgICAgICAgICAgICAgICAgICAgX3ZpZXcuc2V0QXV0b1Njcm9sbChmYWxzZSk7DQo+
PiArICAgICAgICAgICAgICAgICAgICAgICBfdmlldy5zZWxlY3RSb3coaW5kZXgucm93KCkpOw0K
Pj4gKyAgICAgICAgICAgICAgICAgICAgICAgX3ZpZXcuc2V0QXV0b1Njcm9sbCh0cnVlKTsNCj4+
ICsgICAgICAgICAgICAgICB9IGVsc2Ugew0KPj4gKyAgICAgICAgICAgICAgICAgICAgICAgX3Zp
ZXcuY2xlYXJTZWxlY3Rpb24oKTsNCj4+ICsgICAgICAgICAgICAgICAgICAgICAgIFFTdHJpbmcg
ZXJyKCJUaGUgbWFya2VyJ3MgZW50cnkgaXMgZmlsdGVyZWQgb3V0LiIpOw0KPj4gKyAgICAgICAg
ICAgICAgICAgICAgICAgX2VtLnNob3dNZXNzYWdlKGVycik7DQo+IA0KPiBXaGVuIGlzIHRoaXMg
ZXJyb3IgbWVzc2FnZSBnb2luZyB0byBiZSBjbGVhcmVkPyBJIGRvbid0IHRoaW5rIGl0DQo+IGNo
YW5nZXMgYXRtIHVubGVzcyBhIG5ldyBlcnJvciBjb21lcyBhbG9uZy4NCg0KVGhlIG1lc3NhZ2Ug
d2lsbCBiZSBkaXNwbGF5ZWQgaW4gYSBzbWFsbCB3aWRnZXQgKFFFcnJvck1lc3NhZ2UpLiBUaGlz
IA0Kd2lkZ2V0IGhhcyBhbiAiT0siIGJ1dHRvbiBhbmQgYSAiU2hvdyB0aGlzIG1lc3NhZ2UgYWdh
aW4iIGNoZWNrYm94Lg0KDQpUbyBjbGVhciB0aGUgbWVzc2FnZSB5b3UgY2FuIGVpdGhlciBwcmVz
cyAiT0siIG9yIGNsb3NlIHRoZSB3aWRnZXQuDQpJZiB5b3UgdW5jaGVjayB0aGUgIlNob3cgdGhp
cyBtZXNzYWdlIGFnYWluIiBjaGVja2JveCwgbm8gbWVzc2FnZSB3aWxsIA0KYmUgc2hvd24gbmV4
dCB0aW1lIHdoZW4gdGhlIGVycm9yIG9jY3Vycy4NCg0KVGhhbmtzIQ0KWW9yZGFuDQoNCj4gDQo+
IC0tIFNsYXZpDQo+IA0K
