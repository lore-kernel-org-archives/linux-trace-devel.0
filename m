Return-Path: <SRS0=vzsu=RW=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA2F0C43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Mar 2019 19:32:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83DA120854
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Mar 2019 19:32:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="lTgb8s6I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbfCSTcN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 19 Mar 2019 15:32:13 -0400
Received: from mail-eopbgr820059.outbound.protection.outlook.com ([40.107.82.59]:35738
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726612AbfCSTcN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 19 Mar 2019 15:32:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=by2jQclNYph79KXAjYNi2XKfeynMbJSvj3TL63IrU74=;
 b=lTgb8s6INT8ksvhHq34dAgz6XARS8cadZ0F19/XXiL+VNGZJaFH1lJT0G8NEtJUhhZjiI8Gd4FsYtQSBLoMHdnOXxm5Z5e63/4hyaeuAj3Zi6InL+z/rjerH5vbl1OoZNbvTOBGjo02lRPTbHs1iD0IEA08bkOtADVbNKxPyQpU=
Received: from BYAPR05MB5592.namprd05.prod.outlook.com (20.177.186.153) by
 BYAPR05MB5783.namprd05.prod.outlook.com (20.178.48.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1730.7; Tue, 19 Mar 2019 19:32:09 +0000
Received: from BYAPR05MB5592.namprd05.prod.outlook.com
 ([fe80::c0d4:e960:b51:44cc]) by BYAPR05MB5592.namprd05.prod.outlook.com
 ([fe80::c0d4:e960:b51:44cc%2]) with mapi id 15.20.1709.015; Tue, 19 Mar 2019
 19:32:09 +0000
From:   Matt Helsley <mhelsley@vmware.com>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
CC:     "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [Suspected Spam] [PATCH v4 40/46] tools/lib/traceevent: Man page
 for tep_data_lat_fmt()
Thread-Topic: [Suspected Spam] [PATCH v4 40/46] tools/lib/traceevent: Man page
 for tep_data_lat_fmt()
Thread-Index: AQHU1bQZzMWzwp3VXUif4YOAO7M+N6YTaXkA
Date:   Tue, 19 Mar 2019 19:32:09 +0000
Message-ID: <9598B4C5-CC69-4F51-9C4F-F6E74BCCB9F0@vmware.com>
References: <20190308133654.21264-1-tstoyanov@vmware.com>
 <20190308133654.21264-41-tstoyanov@vmware.com>
In-Reply-To: <20190308133654.21264-41-tstoyanov@vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [73.25.163.201]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 697abece-9820-4a3a-d10f-08d6aca1945f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:BYAPR05MB5783;
x-ms-traffictypediagnostic: BYAPR05MB5783:
x-microsoft-antispam-prvs: <BYAPR05MB5783762567CE639B17453941A0400@BYAPR05MB5783.namprd05.prod.outlook.com>
x-forefront-prvs: 0981815F2F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(136003)(39860400002)(396003)(366004)(189003)(199004)(478600001)(66066001)(6116002)(6506007)(3846002)(53546011)(6436002)(186003)(86362001)(26005)(106356001)(7736002)(305945005)(25786009)(53936002)(6346003)(5660300002)(76176011)(229853002)(102836004)(97736004)(99286004)(4326008)(2906002)(316002)(6862004)(14444005)(8676002)(6512007)(256004)(105586002)(6486002)(6636002)(14454004)(2616005)(446003)(68736007)(11346002)(81156014)(81166006)(36756003)(486006)(476003)(33656002)(6246003)(37006003)(71190400001)(83716004)(54906003)(82746002)(71200400001)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB5783;H:BYAPR05MB5592.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=mhelsley@vmware.com; 
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Ya1Kmw96Ajqq+gI3LmARHrcOnQuIIhE+opbfso8PGKlezsLtysEuNXOXtTDy8Vi7LWE31DIz94ydFBl+jQPQSC4Kk/xfnK9IsfnIezcGg7KTHiOxkJeYbsXEp+n8botYnjdEZ3aog+IasM7XnvydmONgBhTp67ciJCOpkg/lGjKjtRCO2ZSKr7PE3Wn/Cd9klo4v29XAkf58m5LuOGYC7xGmeKNWDKP7RI7CQABZt3XLUl63XWDd1B0kQt8TSmTaDGNVMR+TxFWti0zn6p7keSkX5GykIy//jBdSwNsxPX5wc+Bpa2b29+RvEulblIZWBUpJJ6qjRfq95jqVpOz+Ljy7/8fwMOcCeOU4Yu6AXmkTQi11lIlbyKW6OBiXOoCSrguvVgztCxXVf9JQarYFxVXtFy/NRBLFDzt3inotUps=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3BDC252C39A527459490917A89576542@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 697abece-9820-4a3a-d10f-08d6aca1945f
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Mar 2019 19:32:09.5991
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB5783
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

DQoNCj4gT24gTWFyIDgsIDIwMTksIGF0IDU6MzYgQU0sIFR6dmV0b21pciBTdG95YW5vdiA8dHN0
b3lhbm92QHZtd2FyZS5jb20+IHdyb3RlOg0KPiANCj4gQ3JlYXRlIG1hbiBwYWdlIGZvciB0ZXBf
ZGF0YV9sYXRfZm10KCkNCj4gYXMgcGFydCBvZiB0aGUgbGlidHJhY2VldmVudCBBUElzLg0KPiAN
Cj4gU2lnbmVkLW9mZi1ieTogVHp2ZXRvbWlyIFN0b3lhbm92IDx0c3RveWFub3ZAdm13YXJlLmNv
bT4NCj4gLS0tDQo+IC4uLi9saWJ0cmFjZWV2ZW50LXJlY29yZF9sYXQudHh0ICAgICAgICAgICAg
ICB8IDc3ICsrKysrKysrKysrKysrKysrKysNCj4gMSBmaWxlIGNoYW5nZWQsIDc3IGluc2VydGlv
bnMoKykNCj4gY3JlYXRlIG1vZGUgMTAwNjQ0IHRvb2xzL2xpYi90cmFjZWV2ZW50L0RvY3VtZW50
YXRpb24vbGlidHJhY2VldmVudC1yZWNvcmRfbGF0LnR4dA0KPiANCj4gZGlmZiAtLWdpdCBhL3Rv
b2xzL2xpYi90cmFjZWV2ZW50L0RvY3VtZW50YXRpb24vbGlidHJhY2VldmVudC1yZWNvcmRfbGF0
LnR4dCBiL3Rvb2xzL2xpYi90cmFjZWV2ZW50L0RvY3VtZW50YXRpb24vbGlidHJhY2VldmVudC1y
ZWNvcmRfbGF0LnR4dA0KPiBuZXcgZmlsZSBtb2RlIDEwMDY0NA0KPiBpbmRleCAwMDAwMDAwMDAw
MDAuLmY0ZTM3YjE4NmY2MQ0KPiAtLS0gL2Rldi9udWxsDQo+ICsrKyBiL3Rvb2xzL2xpYi90cmFj
ZWV2ZW50L0RvY3VtZW50YXRpb24vbGlidHJhY2VldmVudC1yZWNvcmRfbGF0LnR4dA0KPiBAQCAt
MCwwICsxLDc3IEBADQo+ICtsaWJ0cmFjZWV2ZW50KDMpDQo+ICs9PT09PT09PT09PT09PT09DQo+
ICsNCj4gK05BTUUNCj4gKy0tLS0NCj4gK3RlcF9kYXRhX2xhdF9mbXQgLSBQYXJzZXMgdGhlIGRh
dGEgZm9yIHRoZSBsYXRlbmN5IGZvcm1hdC4NCg0KSXTigJlzIG5vdCBleGFjdGx5IGFuIGlzc3Vl
IHdpdGggdGhpcyBtYW4gcGFnZSBidXQgSSBub3RpY2UgdGhhdCwgdW5saWtlIGEgc2FtcGxpbmcg
b2YgbGlidHJhY2VldmVudCBBUEkgZnVuY3Rpb24gbmFtZXMgaW4gdGhpcyBzZXJpZXMsIHRoaXMg
b25lIGlzIHF1aXRlIGFiYnJldmlhdGVkLiBJcyBpdCBjYWxsZWQgdmVyeSBvZnRlbj8gV291bGQg
aXQgbWFrZSBzZW5zZSB0byByZW5hbWUgaXQgdG8gYmUgYXMgY2xlYXIgYXMgdGhlIG90aGVyIGZ1
bmN0aW9uIG5hbWVzPw0KDQp0ZXBfZGF0YV9sYXRlbmN5X2Zvcm1hdA0KDQpzZWVtcyBtdWNoIGNs
ZWFyZXIgdG8gbWUuDQoNCj4gKw0KPiArU1lOT1BTSVMNCj4gKy0tLS0tLS0tDQo+ICtbdmVyc2Vd
DQo+ICstLQ0KPiArKiNpbmNsdWRlIDxldmVudC1wYXJzZS5oPioNCj4gKw0KPiArdm9pZCAqdGVw
X2RhdGFfbGF0X2ZtdCooc3RydWN0IHRlcF9oYW5kbGUgcGFzczpbKl1fdGVwXywgc3RydWN0IHRy
YWNlX3NlcSBwYXNzOlsqXV9zXywgc3RydWN0IHRlcF9yZWNvcmQgcGFzczpbKl1fcmVjb3JkXyk7
DQo+ICstLQ0KPiArREVTQ1JJUFRJT04NCj4gKy0tLS0tLS0tLS0tDQo+ICtUaGUgX3RlcF9kYXRh
X2xhdF9mbXQoKV8gZnVuY3Rpb24gcGFyc2VzIG91dCB0aGUgbGF0ZW5jeSBmb3JtYXQgKGludGVy
cnVwdHMNCj4gK2Rpc2FibGVkLCBuZWVkIHJlc2NoZWR1bGluZywgaW4gaGFyZC9zb2Z0IGludGVy
cnVwdCwgcHJlZW1wdCBjb3VudCBhbmQNCj4gK2xvY2sgZGVwdGgpIGZyb20gX3JlY29yZF8gYW5k
IHBsYWNlcyBpdCBpbnRvIHRoZSBfc18uICBUaGUgX3RlcF8gYXJndW1lbnQgaXMNCj4gK3RoZSB0
cmFjZSBldmVudCBwYXJzZXIgY29udGV4dC4NCg0KVGhpcyBvbmUgaXMgbWlzc2luZyB0aGUgUkVU
VVJOIFZBTFVFIHNlY3Rpb24uDQoNCkNoZWVycywNCiAgICAgLU1hdHQ=
