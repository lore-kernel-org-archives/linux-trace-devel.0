Return-Path: <SRS0=0lml=RS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D861C43381
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Mar 2019 12:26:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B39C21871
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Mar 2019 12:26:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="Z1AcqdsJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727515AbfCOM0j (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 15 Mar 2019 08:26:39 -0400
Received: from mail-eopbgr800059.outbound.protection.outlook.com ([40.107.80.59]:35136
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726996AbfCOM0i (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 15 Mar 2019 08:26:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4zcGhpAJoOXXelt+pX/T5DM1FLxYoxAjKCjn+D+kCD4=;
 b=Z1AcqdsJjire59Z0uVLn0UjHVWikWXgHqVby/RnkWzS27XX3U0NpUgqS5eI+BhAJZpbAfaGmeaIJem9G+1qc1yUDt8M1ibKuH/54vH91klenFeWQHwnGebcjNGC54KLJBHbCh4yJZRlmucUVPlqz++nFg9nr6+HlQhCq4qtBNKU=
Received: from CY1PR05MB2761.namprd05.prod.outlook.com (10.167.18.19) by
 CY1PR05MB2427.namprd05.prod.outlook.com (10.167.10.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.11; Fri, 15 Mar 2019 12:26:36 +0000
Received: from CY1PR05MB2761.namprd05.prod.outlook.com
 ([fe80::50:9d56:d444:62ec]) by CY1PR05MB2761.namprd05.prod.outlook.com
 ([fe80::50:9d56:d444:62ec%4]) with mapi id 15.20.1709.011; Fri, 15 Mar 2019
 12:26:36 +0000
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v4 34/46] tools/lib/traceevent: Man pages for
 tep_filter_event_has_trivial(), tep_update_trivial() and
 tep_filter_clear_trivial()
Thread-Topic: [PATCH v4 34/46] tools/lib/traceevent: Man pages for
 tep_filter_event_has_trivial(), tep_update_trivial() and
 tep_filter_clear_trivial()
Thread-Index: AQHU1bQWQ/q/x+AhX0qM3CvA2m+5zqYKBHOAgAKktgA=
Date:   Fri, 15 Mar 2019 12:26:34 +0000
Message-ID: <CACqStofeeDATd1XMEds2G6jfw9Uh3KO89SO6xg4GMkPM+Q9CXA@mail.gmail.com>
References: <20190308133654.21264-1-tstoyanov@vmware.com>
 <20190308133654.21264-35-tstoyanov@vmware.com>
 <20190313160413.7ccf9453@gandalf.local.home>
In-Reply-To: <20190313160413.7ccf9453@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR0502CA0014.eurprd05.prod.outlook.com
 (2603:10a6:209:1::27) To CY1PR05MB2761.namprd05.prod.outlook.com
 (2a01:111:e400:c63a::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tstoyanov@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: APjAAAXVMNhYdF9YFTXTi05YmLKOOeZPu4ZldjVyb1MM6E6RQTBCtooW
        Qak5ey/L87GebyLoi0JO0HCUdsNeqDSv8FcMWjo=
x-google-smtp-source: APXvYqy2cxkr0dwVwYDAYRRNxMj08m5+hF45AdmKB9WEeBRmuBwwR6EFaGkxGzuP8Xf2VZudxVU1gyrAHbfWuWGmqWQ=
x-received: by 2002:a1c:48f:: with SMTP id 137mr1882037wme.21.1552652787665;
 Fri, 15 Mar 2019 05:26:27 -0700 (PDT)
x-gmail-original-message-id: <CACqStofeeDATd1XMEds2G6jfw9Uh3KO89SO6xg4GMkPM+Q9CXA@mail.gmail.com>
x-originating-ip: [209.85.128.52]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1ac2906d-2b7d-44a7-eeed-08d6a94175fb
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:CY1PR05MB2427;
x-ms-traffictypediagnostic: CY1PR05MB2427:
x-microsoft-antispam-prvs: <CY1PR05MB242709E30F536611450E9DD6DC440@CY1PR05MB2427.namprd05.prod.outlook.com>
x-forefront-prvs: 09778E995A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(376002)(136003)(346002)(366004)(39860400002)(199004)(189003)(53936002)(6246003)(6436002)(102836004)(476003)(95326003)(486006)(106356001)(105586002)(478600001)(6116002)(61726006)(8676002)(6486002)(446003)(3846002)(11346002)(68736007)(53546011)(52116002)(386003)(2906002)(498394004)(99286004)(26005)(305945005)(6506007)(14454004)(97736004)(186003)(9686003)(25786009)(229853002)(8936002)(4326008)(6512007)(76176011)(256004)(14444005)(71200400001)(6862004)(86362001)(71190400001)(55446002)(316002)(5660300002)(61266001)(66066001)(7736002)(81156014)(81166006)(4744005)(67856001);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR05MB2427;H:CY1PR05MB2761.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 56RGSPr9c83W7QJwcTUSWUunn0JvrpBTTcJpFj+6oG4UlXcdK6t0enEfMXDM8F4TbCiAZdSHgr1rB20kd/uvOpVyKgQL8XPHOukNU+yUa9CjqYSPNy81BDVxq86z0zCTdiVr9YBpAMxaH8BfyWkNgOtbsvWcf+ZC73Z3/IsPVFaKsCdvFxw6ivtsuXAxWQL7Ub0UHelQQqKtxg02mBQyq7+6r2yikS0T1RCSHkBM5BIM1zPLIGDdP75/4pSu00I28VrlDdzrGhd7Lp6kJNeVzMNgjIeQaMlhBu8HVACvhqK16zVzAZtvBuA6bATawVsIfPH/iow2/97fXW0bO2aVqtVF9Qe232ORh2IQ0BTZByrMxk6OQS4NUZryC6N5/IhICeNpBIyTUM0J/GDJ/+quOMh+JcphioDp3yy8tzhN94M=
Content-Type: text/plain; charset="utf-8"
Content-ID: <231E51653FDA39418A4580FFF1AC1F95@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ac2906d-2b7d-44a7-eeed-08d6a94175fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2019 12:26:34.7085
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR05MB2427
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gV2VkLCBNYXIgMTMsIDIwMTkgYXQgMTA6MDQgUE0gU3RldmVuIFJvc3RlZHQgPHJvc3RlZHRA
Z29vZG1pcy5vcmc+IHdyb3RlOg0KPg0KPiBPbiBGcmksICA4IE1hciAyMDE5IDE1OjM2OjQyICsw
MjAwDQo+IFR6dmV0b21pciBTdG95YW5vdiA8dHN0b3lhbm92QHZtd2FyZS5jb20+IHdyb3RlOg0K
Pg0KPiA+IENyZWF0ZSBtYW4gcGFnZXMgZm9yIHRlcF9maWx0ZXJfZXZlbnRfaGFzX3RyaXZpYWwo
KSwNCj4gPiB0ZXBfdXBkYXRlX3RyaXZpYWwoKSBhbmQgdGVwX2ZpbHRlcl9jbGVhcl90cml2aWFs
KCkNCj4gPiBhcyBwYXJ0IG9mIHRoZSBsaWJ0cmFjZWV2ZW50IEFQSXMuDQo+DQo+IEhtbSwgdGhl
IHRyaXZpYWwgZmlsdGVyIGxvZ2ljIHdhcyBhbiBvcHRpbWl6YXRpb24gb2YgdGhlIG9sZA0KPiBr
ZXJuZWxzaGFyayBhbmQgaXNuJ3QgdXNlZCB0b2RheS4gSSB0aGluayB0aGUgYmVzdCBjb3Vyc2Ug
b2YgYWN0aW9uIGlzDQo+IHRvIGRlbGV0ZSB0aGUgdHJpdmlhbCBmaWx0ZXIgQVBJcy4NCj4NCkkn
bGwgcmVtb3ZlIG1hbiBwYWdlcyByZWxhdGVkIHRvIHRoZSB0cml2aWFsIGZpbHRlciBBUEkgZnJv
bSB0aGUgcGF0Y2hzZXQuDQoNCj4gLS0gU3RldmUNCg0KDQoNCi0tIA0KDQpUenZldG9taXIgKENl
Y28pIFN0b3lhbm92DQpWTXdhcmUgT3BlbiBTb3VyY2UgVGVjaG5vbG9neSBDZW50ZXINCg==
