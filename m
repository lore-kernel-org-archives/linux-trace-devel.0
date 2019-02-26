Return-Path: <SRS0=LjSD=RB=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E2C6C43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Feb 2019 18:02:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 017B421850
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Feb 2019 18:02:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="Pm0qqC9u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728456AbfBZSCw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 26 Feb 2019 13:02:52 -0500
Received: from mail-eopbgr680058.outbound.protection.outlook.com ([40.107.68.58]:17408
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727801AbfBZSCw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 26 Feb 2019 13:02:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EWEhxvc5Y66tYwhSkAwzDBKdZL3DeXgne5BORwrih0A=;
 b=Pm0qqC9uS7JYVW22/rAnx7to9qBzOpxYcTCCtUTjuKq+b1+A8U+iE5Q0aZ6PwzT4TbX+Sr6+3JgexdGdpK5op7o+1nlD8ZcU/rrDOQE9BuUI7s4QRWRW9HWbgkEtVPpQtYg4sqf+2B/7GQl1eupeO34bdkPa4B0G+mMha+k2zNU=
Received: from CY1PR05MB2761.namprd05.prod.outlook.com (10.167.18.19) by
 CY1PR05MB2651.namprd05.prod.outlook.com (10.167.10.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1665.6; Tue, 26 Feb 2019 18:02:48 +0000
Received: from CY1PR05MB2761.namprd05.prod.outlook.com
 ([fe80::50:9d56:d444:62ec]) by CY1PR05MB2761.namprd05.prod.outlook.com
 ([fe80::50:9d56:d444:62ec%4]) with mapi id 15.20.1665.012; Tue, 26 Feb 2019
 18:02:48 +0000
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>,
        Yordan Karadzhov <ykaradzhov@vmware.com>,
        Slavomir Kaslev <kaslevs@vmware.com>
Subject: Re: Can't use kvm_exit for the host side time stamp
Thread-Topic: Can't use kvm_exit for the host side time stamp
Thread-Index: AQHUze+1TvGa+2SoKkOpwa4eL67JqKXyXwCA
Date:   Tue, 26 Feb 2019 18:02:48 +0000
Message-ID: <CACqStoe6XzreeB=19AmvcwGUmCs351vk+shMAm95PYnj5e8vWA@mail.gmail.com>
References: <20190226112406.7abab75a@vmware.local.home>
In-Reply-To: <20190226112406.7abab75a@vmware.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5PR0502CA0018.eurprd05.prod.outlook.com
 (2603:10a6:203:91::28) To CY1PR05MB2761.namprd05.prod.outlook.com
 (2a01:111:e400:c63a::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tstoyanov@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: AHQUAub6j4kLAb0ppE3mpnxxnaibhHwJcvFfbKPOkP7ADyAaZJ3kET5N
        PSWwccMB03xKLp6BjDnULJSQAiHjpfU1O0VVECc=
x-google-smtp-source: AHgI3IbSf3/djH7MmmqguisdXNqbAs6KfKoCvyf3vpI1jnS5VXliJRO0bE63hmc86qsOGgYXSuMqgQYxuBSio6td2uQ=
x-received: by 2002:adf:e48a:: with SMTP id
 i10mr18407670wrm.257.1551204162493; Tue, 26 Feb 2019 10:02:42 -0800 (PST)
x-gmail-original-message-id: <CACqStoe6XzreeB=19AmvcwGUmCs351vk+shMAm95PYnj5e8vWA@mail.gmail.com>
x-originating-ip: [209.85.221.54]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 99ed0ab8-b89e-494c-265a-08d69c149d58
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:CY1PR05MB2651;
x-ms-traffictypediagnostic: CY1PR05MB2651:
x-microsoft-exchange-diagnostics: 1;CY1PR05MB2651;20:VHOa+tvlLYVjCz8tyHSmsCTtTLeHkv+azXmOBfzSPjjhyGJ1fz2/4Pqsef8+j/7pxXrUfRAg/tOXnr/6GCN2ZdD6LlLvFnI8ctBJ5DnoPPz7VRdLzCrVgjRQMIqXV92xiP3Xcn8KCaBJpW1NIBFtA6bu+wtwAH5KYFjZ6JYFIq8=
x-microsoft-antispam-prvs: <CY1PR05MB265107A6BA34D826C1186421DC7B0@CY1PR05MB2651.namprd05.prod.outlook.com>
x-forefront-prvs: 096029FF66
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(376002)(396003)(136003)(39860400002)(346002)(199004)(189003)(53546011)(97736004)(11346002)(54906003)(386003)(6506007)(53936002)(446003)(316002)(61266001)(52116002)(6246003)(98316002)(95326003)(61726006)(107886003)(6436002)(6486002)(3846002)(6116002)(105586002)(498394004)(66066001)(106356001)(99286004)(6512007)(9686003)(68736007)(486006)(305945005)(478600001)(229853002)(25786009)(8676002)(5660300002)(81166006)(81156014)(8936002)(7736002)(71200400001)(71190400001)(186003)(86362001)(476003)(14444005)(102836004)(76176011)(6862004)(256004)(4326008)(55446002)(26005)(14454004)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR05MB2651;H:CY1PR05MB2761.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: FAzY+myYinUSxlgEc8J7ZcAOjSlS/xx2B/mFhvfykGh50fS7YFUejkZ2DW/wfyQmgrOGOEV1jVuE3u4OEofbOXulZp/K4Z87TDJAfdmdBsE0aVAMbkBL+FBWeqXN3usilstqW3atyZ1TWoNbpa3JulWDMUPOYEa/q0Co+GFX+oiJUaQ6bYPsDy5y9gcG8tqqWzJAAtbCbKLxgy+wLVkQreVLy9CgGoIuic3kr8e0V3yEeTyL6jWcWgYo53D146kt/X9n5B/XQzh+4+1vgSaztMAJbyf9zklWvF8CzFIl5Krt6kjVNF6s9Uln4ZooOo2FocOw9ojgLrRLJT5xqmi6diGJ2qD0rOAILm+BzmtEv5zUA5f+RQhAU/g0+BoMyAfWYld6N5ROJ1r0wwITEbaSNMHJJe70sU0HF3DX8OBp8SY=
Content-Type: text/plain; charset="utf-8"
Content-ID: <53FD8867BECBF74AA9B7165C06199EEA@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99ed0ab8-b89e-494c-265a-08d69c149d58
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Feb 2019 18:02:48.0819
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR05MB2651
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

SGkgU3RldmVuLA0KDQpPbiBUdWUsIEZlYiAyNiwgMjAxOSBhdCA2OjI0IFBNIFN0ZXZlbiBSb3N0
ZWR0IDxyb3N0ZWR0QGdvb2RtaXMub3JnPiB3cm90ZToNCj4NCj4gSGkgQ2VjbywNCj4NCj4gSSB3
YXMgd2Fsa2luZyBZb3JkYW4gZG93biB0aGUgY29kZSBpbiB0aGUga2VybmVsIHRvIHNob3cgaGlt
IHRoZSBpZGVhcw0KPiBJIGhhdmUgYWJvdXQgdXNpbmcga3ZtX2V4aXQgYXMgdGhlIHRyYWNlIGV2
ZW50IG9uIHRoZSBob3N0IHNpZGUsIHdoZW4gSQ0KPiBub3RpY2VkIHRoYXQgaXQncyBjYWxsZWQg
KmFmdGVyKiBpbnRlcnJ1cHRzIGFuZCBwcmVlbXB0aW9uIGFyZSBlbmFibGVkIQ0KPg0KPiBUaGlz
IHRvdGFsbHkgYnJlYWtzIHRoZSBkZXNpZ24sIGFzIGl0IGlzIG5vdCBhIHJlbGlhYmxlIGV2ZW50
LCBiZWNhdXNlDQo+IHRoZSBwcm9jZXNzIHJ1bm5pbmcgdGhlIGd1ZXN0IGlzIGxpa2VseSB0byBn
ZXQgYW4gaW50ZXJydXB0IG9yDQo+IHByZWVtcHRlZCBiZWZvcmUgcmVjb3JkaW5nIHRoYXQgZXZl
bnQsIHdoaWNoIGNhbiBjYXVzZSBhIGh1Z2UNCj4gZGlmZmVyZW5jZS4NCj4NCldlIHBlcmZvcm1l
ZCBhIGxvdCBvZiB0ZXN0cyB3aXRoIHRoZSBjdXJyZW50IGltcGxlbWVudGF0aW9uIChyZWx5aW5n
DQpvbiB0aGUga3ZtX2V4aXQgZXZlbnQpLA0KYW5kIHRoZSByZXN1bHRzIGFyZSB2ZXJ5IGFjY3Vy
YXRlIGFuZCBjb25zaXN0ZW50LiBPZiBjb3Vyc2UsIHRoZXJlIGFyZQ0KcHJvYmVzIHdpdGggaHVn
ZQ0KZGV2aWF0aW9uLCBidXQgdGhlc2UgY2FuIGJlIGVhc2lseSBmaWx0ZXJlZC4NCg0KPiBrdm1f
ZW50ZXIgaXMgZmluZSwgYnV0IHRoZSByZWFzb24gdGhhdCBrdm1fZXhpdCBpcyBub3QsIGlzIGJl
Y2F1c2UsIGluDQo+IG9yZGVyIHRvIHJlY29yZCB0aGUgcmVhc29uIGZvciB0aGUgZXhpdCwgaXQg
bmVlZHMgdG8gY2FsbCBpbnRvIGVpdGhlcg0KPiB0aGUgSW50ZWwgb3IgQU1EIGNvZGUgKGFzIHRo
ZXkgYXJlIGRpZmZlcmVudCksIGFuZCB0aGF0IGlzIGRvbmUgYWZ0ZXINCj4gaW50ZXJydXB0cyBh
bmQgcHJlZW1wdGlvbiBhcmUgZW5hYmxlZC4NCj4NCj4gSW5zdGVhZCwgd2UgY2FuIHRyYWNlIHRo
ZSBmdW5jdGlvbiBrdm1fcmVhZF9sMV90c2MsIHdoaWNoIGhhcHBlbnMgd2hpbGUNCj4gaW50ZXJy
dXB0cyBhcmUgc3RpbGwgZW5hYmxlZC4NCj4NCj4gV291bGQgeW91IGJlIGFibGUgdG8gdGVzdCB3
aXRoIHRoYXQgZnVuY3Rpb24gaW5zdGVhZCBvZiB1c2luZyBrdm1fZXhpdD8NCj4gQWxzbywgaWYg
eW91IHN0aWxsIHNlZSBhIGRyaWZ0LCB0cnkgc2V0dGluZyBib3RoIHRyYWNlIGNsb2NrcyB0bw0K
PiB4ODYtdHNjLCBhbmQgc2VlIGlmIHlvdSBzdGlsbCBnZXQgYSBkcmlmdC4NCg0KWWVzLCBJJ2xs
IHRlc3Qgd2l0aCB0aGUga3ZtX3JlYWRfbDFfdHNjIGZ1bmN0aW9uIHRvbW9ycm93LiAgSXMgaXQN
CnJlbGF0ZWQgdG8geDg2LXRzYw0KY2xvY2sgb25seSwgb3IgaXQgc2hvdWxkIHdvcmsgd2l0aCBh
bnkgY2xvY2sgPyBJIG5vdGljZWQgdGhhdCB0aGUNCmRyaWZ0IGRvZXMgbm90IGRlcGVuZA0Kb24g
dGhlIGNsb2NrLCB4ODYtdHNjIGFsc28gZHJpZnRzLg0KDQo+DQo+IFRoYW5rcyENCj4NCj4gLS0g
U3RldmUNCg0KDQoNCi0tIA0KDQpUenZldG9taXIgKENlY28pIFN0b3lhbm92DQpWTXdhcmUgT3Bl
biBTb3VyY2UgVGVjaG5vbG9neSBDZW50ZXINCg==
