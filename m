Return-Path: <SRS0=Le/E=UM=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A1C0C31E49
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 Jun 2019 15:00:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4E0F2175B
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 Jun 2019 15:00:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="tbGkR+He"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732967AbfFMPAz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 13 Jun 2019 11:00:55 -0400
Received: from mail-eopbgr730047.outbound.protection.outlook.com ([40.107.73.47]:3124
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732570AbfFMOk7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 13 Jun 2019 10:40:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mw9yFhsTW9IYtZDas22eoYeWuXoHlY+8umVVRMvdnBQ=;
 b=tbGkR+HeeM8tlrC0jc7JwvxKkCEyduJOoRmV7rcPdA4StNaSD0D5/byN+vqadS6x3dRkNXogtaSIrX1bxuFqam3ic5QA95aXKCbVagRDHZGThq3JG2befenaeo/UJ9VSwSzmKMAL6+/YVHYyKUEgrU10jHXZ7mWf/LLy0qutoDc=
Received: from DM6PR05MB4044.namprd05.prod.outlook.com (20.176.71.154) by
 DM6PR05MB5004.namprd05.prod.outlook.com (20.177.223.79) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.5; Thu, 13 Jun 2019 14:40:55 +0000
Received: from DM6PR05MB4044.namprd05.prod.outlook.com
 ([fe80::c5ce:1ccd:9894:2181]) by DM6PR05MB4044.namprd05.prod.outlook.com
 ([fe80::c5ce:1ccd:9894:2181%7]) with mapi id 15.20.1987.010; Thu, 13 Jun 2019
 14:40:55 +0000
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 1/3] trace-cmd: Fix typo in Makefile bidr to bdir
Thread-Topic: [PATCH 1/3] trace-cmd: Fix typo in Makefile bidr to bdir
Thread-Index: AQHVIUuBXSF7Vhyp00SlcmU9Das0k6aZqVaA
Date:   Thu, 13 Jun 2019 14:40:55 +0000
Message-ID: <CACqStocAop3kN18o3+eqx-64uem8dhj-+ewuJ3z9oOxMsZ9rZw@mail.gmail.com>
References: <20190612181927.608151291@goodmis.org>
 <20190612182018.861661984@goodmis.org>
In-Reply-To: <20190612182018.861661984@goodmis.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM4PR0501CA0065.eurprd05.prod.outlook.com
 (2603:10a6:200:68::33) To DM6PR05MB4044.namprd05.prod.outlook.com
 (2603:10b6:5:8f::26)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tstoyanov@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: APjAAAXkhM5EOYLM2n4Y8W7/6+UeoYgFyypS9okLX1Vdlui9JRHtOpih
        dpssS36JAN7r96V5xOjlf7VGe++x3vpIYQHumv8=
x-google-smtp-source: APXvYqzsiLHelUlhrQ5QieYHCFbl9q2GHSDtCJrIT6pvmERgi/rIBAvsYMGLNi0tOfyM4R0V9DzfSsmrlP4SrdX15Mg=
x-received: by 2002:a5d:65c5:: with SMTP id e5mr1897667wrw.266.1560436849133;
 Thu, 13 Jun 2019 07:40:49 -0700 (PDT)
x-gmail-original-message-id: <CACqStocAop3kN18o3+eqx-64uem8dhj-+ewuJ3z9oOxMsZ9rZw@mail.gmail.com>
x-originating-ip: [209.85.221.51]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 21751ecb-7f30-4005-651f-08d6f00d23da
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DM6PR05MB5004;
x-ms-traffictypediagnostic: DM6PR05MB5004:
x-microsoft-antispam-prvs: <DM6PR05MB500473745133A11B2A2D80EFDCEF0@DM6PR05MB5004.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:590;
x-forefront-prvs: 0067A8BA2A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(366004)(396003)(346002)(376002)(136003)(189003)(199004)(4326008)(305945005)(73956011)(66446008)(64756008)(66556008)(66476007)(66946007)(6862004)(9686003)(5660300002)(6512007)(53936002)(25786009)(8676002)(81166006)(81156014)(99286004)(256004)(61726006)(14444005)(95326003)(7736002)(6246003)(61266001)(446003)(102836004)(8936002)(52116002)(66066001)(316002)(6506007)(386003)(76176011)(476003)(11346002)(53546011)(86362001)(26005)(486006)(71200400001)(71190400001)(186003)(68736007)(2906002)(14454004)(6116002)(3846002)(55446002)(6436002)(4744005)(6486002)(229853002)(498394004)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR05MB5004;H:DM6PR05MB4044.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 4SMkCBWhOvMaCsvv+ArvZKRCGpHV3LzTIR8Uq17ZHcBwqKv4RUTBy6NttnVV1d6S9JzE9TALnbHKZyawyuT4NKy6+T2IlbKCoLzeOnjmH4/Sq74k4NhobdNmBG75zSVAVZsIyFPYKc3QBdZKgz0S17sHWCm0nvIlxkYZ8yWFw4EyAn48nR6WuXeADD76jFVnNtV4YwbImh5Nt4IVVaDkKPZc7/UREmutt5IBwhmM7sX4JM+r7h/rNy+9JBHR8dl2xkQxZJZXKj6C9QH8BUidJWLY7XgD4JiSVAdx1k+h8AT9sGm2aMN2J7GEWekfrrGWSRH5PL9WUEWN1TClHsdvwTVPN0865UyTnu2moIG+oOnKP+8cWuY7VnLFa4PbA+xbbbhONn0RwEFwoS54ZmfkSTRPjm5f2b2aOBEEgCRNkJ8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <96FAE6B73F78814FAA33E0C5FD18DDAD@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21751ecb-7f30-4005-651f-08d6f00d23da
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2019 14:40:55.5275
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tstoyanov@vmware.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR05MB5004
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gV2VkLCBKdW4gMTIsIDIwMTkgYXQgOToxOSBQTSBTdGV2ZW4gUm9zdGVkdCA8cm9zdGVkdEBn
b29kbWlzLm9yZz4gd3JvdGU6DQo+DQo+IEZyb206ICJTdGV2ZW4gUm9zdGVkdCAoVk13YXJlKSIg
PHJvc3RlZHRAZ29vZG1pcy5vcmc+DQo+DQo+IFRoZSBvcmRlci1vbmx5IHByZXJlcXVpc2l0IHRv
ICQoYmRpcikvaW5jbHVkZSBoYXMgYSB0eXBvIG9mICIkKGJpZHIpIg0KPiBpbnN0ZWFkIG9mIGJl
aW5nICIkKGJkaXIpIg0KPg0KPiBTaWduZWQtb2ZmLWJ5OiBTdGV2ZW4gUm9zdGVkdCAoVk13YXJl
KSA8cm9zdGVkdEBnb29kbWlzLm9yZz4NCj4gLS0tDQoNCkxvb2tzIE9LIHRvIG1lDQpSZXZpZXdl
ZC1ieTogVHp2ZXRvbWlyIFN0b3lhbm92IDx0c3RveWFub3ZAdm13YXJlLmNvbT4NCg0KDQo+ICB0
cmFjZWNtZC9NYWtlZmlsZSB8IDIgKy0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigr
KSwgMSBkZWxldGlvbigtKQ0KPg0KPiBkaWZmIC0tZ2l0IGEvdHJhY2VjbWQvTWFrZWZpbGUgYi90
cmFjZWNtZC9NYWtlZmlsZQ0KPiBpbmRleCA5M2IzNzNkNTgxNTUuLmJjZDQzN2EyNmI5OCAxMDA2
NDQNCj4gLS0tIGEvdHJhY2VjbWQvTWFrZWZpbGUNCj4gKysrIGIvdHJhY2VjbWQvTWFrZWZpbGUN
Cj4gQEAgLTQ3LDcgKzQ3LDcgQEAgYWxsOiAkKFRBUkdFVFMpDQo+ICAkKGJkaXIpOg0KPiAgICAg
ICAgIEBta2RpciAtcCAkKGJkaXIpDQo+DQo+IC0kKGJkaXIpL2luY2x1ZGU6IHwgJChiaWRyKQ0K
PiArJChiZGlyKS9pbmNsdWRlOiB8ICQoYmRpcikNCj4gICAgICAgICBAbWtkaXIgLXAgJChiZGly
KS9pbmNsdWRlDQo+DQo+ICAkKFRDX1ZFUlNJT04pOiBmb3JjZSB8ICQoYmRpcikvaW5jbHVkZQ0K
PiAtLQ0KPiAyLjIwLjENCj4NCj4NCg0KDQotLQ0KDQpUenZldG9taXIgKENlY28pIFN0b3lhbm92
DQpWTXdhcmUgT3BlbiBTb3VyY2UgVGVjaG5vbG9neSBDZW50ZXINCg==
