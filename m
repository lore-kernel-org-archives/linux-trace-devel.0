Return-Path: <SRS0=LjSD=RB=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA6DBC43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Feb 2019 19:31:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E4702063F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Feb 2019 19:31:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="auxt9XsO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728367AbfBZTbx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 26 Feb 2019 14:31:53 -0500
Received: from mail-eopbgr700086.outbound.protection.outlook.com ([40.107.70.86]:39631
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727196AbfBZTbw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 26 Feb 2019 14:31:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jVQX0dZb48AmgP19+gY9BYTKrCcxOodT762AlzyMWfw=;
 b=auxt9XsOrH1PVdvg3Q4pBoC8cAai28uLf0eaL27dknNXGa4gAfN6ox/MdIooxEKxCEOsHZpNaT220rWmvv0OOpRHONxxeisMUf2UQGBvKDzCt34DQXgtus/ozIEfzddsetklvbZ1AoWR7BUarXD/Q9ae+vcqU1fl8dvPDS2WYEo=
Received: from CY1PR05MB2761.namprd05.prod.outlook.com (10.167.18.19) by
 CY1PR05MB2684.namprd05.prod.outlook.com (10.167.11.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1665.13; Tue, 26 Feb 2019 19:31:50 +0000
Received: from CY1PR05MB2761.namprd05.prod.outlook.com
 ([fe80::50:9d56:d444:62ec]) by CY1PR05MB2761.namprd05.prod.outlook.com
 ([fe80::50:9d56:d444:62ec%4]) with mapi id 15.20.1665.012; Tue, 26 Feb 2019
 19:31:50 +0000
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>,
        Yordan Karadzhov <ykaradzhov@vmware.com>,
        Slavomir Kaslev <kaslevs@vmware.com>
Subject: Re: Can't use kvm_exit for the host side time stamp
Thread-Topic: Can't use kvm_exit for the host side time stamp
Thread-Index: AQHUze+1TvGa+2SoKkOpwa4eL67JqKXyXwCAgAADwACAABUhAA==
Date:   Tue, 26 Feb 2019 19:31:49 +0000
Message-ID: <CACqStocLVWOvz6hSWk-KLMK66yj1KLD1jsuZZkkT0z-fNwVE3w@mail.gmail.com>
References: <20190226112406.7abab75a@vmware.local.home>
 <CACqStoe6XzreeB=19AmvcwGUmCs351vk+shMAm95PYnj5e8vWA@mail.gmail.com>
 <20190226131554.37e0b7b5@vmware.local.home>
In-Reply-To: <20190226131554.37e0b7b5@vmware.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5PR0402CA0016.eurprd04.prod.outlook.com
 (2603:10a6:203:90::26) To CY1PR05MB2761.namprd05.prod.outlook.com
 (2a01:111:e400:c63a::19)
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: AHQUAuZu2lwoB/qlaWT/A/2DeiUlHFxEwM8Lh+jfupRGWDJdfmr/k8D1
        r6XXS/AFYgYCt1XrTgtwOsb2SkKDVptacNoH1IQ=
x-google-smtp-source: AHgI3IZvRVsYZFdJgiqAxEcBvg2NqxAqWzo2PJMN3gMfmmMej73pq4Fp5hPiJbMDSLOhcQQQu0brUKFNxJLHo67OR+o=
x-received: by 2002:a1c:760f:: with SMTP id r15mr3627283wmc.88.1551209503914;
 Tue, 26 Feb 2019 11:31:43 -0800 (PST)
x-gmail-original-message-id: <CACqStocLVWOvz6hSWk-KLMK66yj1KLD1jsuZZkkT0z-fNwVE3w@mail.gmail.com>
x-originating-ip: [209.85.128.48]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 478ea0a3-d4fb-43da-73e0-08d69c210d80
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:CY1PR05MB2684;
x-ms-traffictypediagnostic: CY1PR05MB2684:
x-microsoft-exchange-diagnostics: 1;CY1PR05MB2684;20:dtWDlQdBBA9sbRC4kAJBU+UbaLkNtkz2F2ufEZ83GMP4kzIthHSiOHsEtu03FgeJOJ6JLb6nwvjjTbdAdU3Ck1Lp+RTN5DQDvs/xDvQDlngBCFMg/kj8tWVz8cFsxfgtuLfEANY+JEEujAqTYXv4Khcn3EWRNpKGTvdJpBN67G0=
x-microsoft-antispam-prvs: <CY1PR05MB26846A4584C8926651D1A4A7DC7B0@CY1PR05MB2684.namprd05.prod.outlook.com>
x-forefront-prvs: 096029FF66
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(376002)(346002)(366004)(39860400002)(396003)(189003)(199004)(3846002)(6246003)(4326008)(99286004)(14444005)(256004)(55446002)(478600001)(71190400001)(71200400001)(61266001)(2906002)(6862004)(68736007)(6116002)(6436002)(76176011)(305945005)(7736002)(52116002)(107886003)(14454004)(6346003)(316002)(25786009)(54906003)(102836004)(53546011)(6506007)(66066001)(8676002)(386003)(9686003)(6512007)(86362001)(8936002)(81156014)(81166006)(105586002)(106356001)(6486002)(486006)(61726006)(95326003)(498394004)(53936002)(11346002)(446003)(97736004)(5660300002)(26005)(476003)(229853002)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR05MB2684;H:CY1PR05MB2761.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tstoyanov@vmware.com; 
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: yi0JymKDwLzyp+1QtFXAn3e/WK0U6y/TFeJsP1IQ2x8DkiX3jjt8K6aCmE3jNv1izFx2tZz8ZzA0EUggQCn/mKlhgPRe+FLHAXNDQvod3l+qLPCiGLfUHSQP7uUeOE0VECS03Y/j+ZqpXB4ujvlfn5Ft46xjLXQi6TgL1sryJRfbBEW5Pf1y6xMJNQlRcusBprg7qkmSH3AMeoQkLMO3nef/H3aT3ZStra949OYY+gpUJyMK45ab14jdktrp3yE31CvV7YqwyblWvFnCkjp4vIQJTYk34x8xfdUbpXLOS01kZnJXVyZpMRPuAM6SnkyT9TChuxcj2Ui0ydHdHaBMbZ79jGTHa4vK3lZvgVuMSXUcrvE+yQ4JAGiGXPLORP55Z9eGbigVtchszzkC7KYoqpPv5vxZj96fYWYUnvyMsqE=
Content-Type: text/plain; charset="utf-8"
Content-ID: <287CA943C885B747B7B86DB591B1C503@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 478ea0a3-d4fb-43da-73e0-08d69c210d80
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Feb 2019 19:31:49.7632
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR05MB2684
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gVHVlLCBGZWIgMjYsIDIwMTkgYXQgODoxNSBQTSBTdGV2ZW4gUm9zdGVkdCA8cm9zdGVkdEBn
b29kbWlzLm9yZz4gd3JvdGU6DQo+DQo+IE9uIFR1ZSwgMjYgRmViIDIwMTkgMTg6MDI6NDggKzAw
MDANCj4gVHp2ZXRvbWlyIFN0b3lhbm92IDx0c3RveWFub3ZAdm13YXJlLmNvbT4gd3JvdGU6DQo+
DQo+ID4gV2UgcGVyZm9ybWVkIGEgbG90IG9mIHRlc3RzIHdpdGggdGhlIGN1cnJlbnQgaW1wbGVt
ZW50YXRpb24gKHJlbHlpbmcNCj4gPiBvbiB0aGUga3ZtX2V4aXQgZXZlbnQpLA0KPiA+IGFuZCB0
aGUgcmVzdWx0cyBhcmUgdmVyeSBhY2N1cmF0ZSBhbmQgY29uc2lzdGVudC4gT2YgY291cnNlLCB0
aGVyZSBhcmUNCj4gPiBwcm9iZXMgd2l0aCBodWdlDQo+ID4gZGV2aWF0aW9uLCBidXQgdGhlc2Ug
Y2FuIGJlIGVhc2lseSBmaWx0ZXJlZC4NCj4NCj4gQXQgbGVhc3Qgd2Ugbm93IGtub3cgd2h5IHRo
ZXJlIHdlcmUgaHVnZSBkZXZpYXRpb25zIDotKQ0KPg0KPiA+DQo+ID4gPiBrdm1fZW50ZXIgaXMg
ZmluZSwgYnV0IHRoZSByZWFzb24gdGhhdCBrdm1fZXhpdCBpcyBub3QsIGlzIGJlY2F1c2UsIGlu
DQo+ID4gPiBvcmRlciB0byByZWNvcmQgdGhlIHJlYXNvbiBmb3IgdGhlIGV4aXQsIGl0IG5lZWRz
IHRvIGNhbGwgaW50byBlaXRoZXINCj4gPiA+IHRoZSBJbnRlbCBvciBBTUQgY29kZSAoYXMgdGhl
eSBhcmUgZGlmZmVyZW50KSwgYW5kIHRoYXQgaXMgZG9uZSBhZnRlcg0KPiA+ID4gaW50ZXJydXB0
cyBhbmQgcHJlZW1wdGlvbiBhcmUgZW5hYmxlZC4NCj4gPiA+DQo+ID4gPiBJbnN0ZWFkLCB3ZSBj
YW4gdHJhY2UgdGhlIGZ1bmN0aW9uIGt2bV9yZWFkX2wxX3RzYywgd2hpY2ggaGFwcGVucyB3aGls
ZQ0KPiA+ID4gaW50ZXJydXB0cyBhcmUgc3RpbGwgZW5hYmxlZC4NCj4gPiA+DQo+ID4gPiBXb3Vs
ZCB5b3UgYmUgYWJsZSB0byB0ZXN0IHdpdGggdGhhdCBmdW5jdGlvbiBpbnN0ZWFkIG9mIHVzaW5n
IGt2bV9leGl0Pw0KPiA+ID4gQWxzbywgaWYgeW91IHN0aWxsIHNlZSBhIGRyaWZ0LCB0cnkgc2V0
dGluZyBib3RoIHRyYWNlIGNsb2NrcyB0bw0KPiA+ID4geDg2LXRzYywgYW5kIHNlZSBpZiB5b3Ug
c3RpbGwgZ2V0IGEgZHJpZnQuDQo+ID4NCj4gPiBZZXMsIEknbGwgdGVzdCB3aXRoIHRoZSBrdm1f
cmVhZF9sMV90c2MgZnVuY3Rpb24gdG9tb3Jyb3cuICBJcyBpdA0KPiA+IHJlbGF0ZWQgdG8geDg2
LXRzYw0KPiA+IGNsb2NrIG9ubHksIG9yIGl0IHNob3VsZCB3b3JrIHdpdGggYW55IGNsb2NrID8g
SSBub3RpY2VkIHRoYXQgdGhlDQo+ID4gZHJpZnQgZG9lcyBub3QgZGVwZW5kDQo+ID4gb24gdGhl
IGNsb2NrLCB4ODYtdHNjIGFsc28gZHJpZnRzLg0KPiA+DQo+DQo+IE5vLCBpdCBzaG91bGRuJ3Qg
YmUgcmVsYXRlZCwgeW91IGNhbiBkbyB0aGVtIGRpZmZlcmVudGx5Lg0KPg0KPiBJcyBpdCBvbmx5
IHlvdXIgbWFjaGluZSB0aGF0IGhhcyBhbiBkcmlmdCwgb3IgZG8geW91IHNlZSBpdCBvbiBvdGhl
cg0KPiBtYWNoaW5lcz8gV2UgbG9va2VkIGF0IFlvcmRhbidzIGxhcHRvcCwgYW5kIGl0IGhhZCBz
aGlmdHMsIGJ1dCBub3QgYQ0KPiBkcmlmdC4gVGhhdCBpcywgaXQgd2FzIG9mZiBmb3IgYSBiaXQg
YnV0IHRoZW4gZ29lcyBiYWNrLiBOb3QgYSBkcmlmdCwNCj4gYnV0IGEgc2hpZnQgYmV0d2VlbiB0
d28gZGVsdGFzLiBOb3Qgc3VyZSB3aHkuDQoNCkkgdGVzdGVkIG9uIG15IG1hY2hpbmUgb25seSAo
SW50ZWwpLCB3aXRoIGRpZmZlcmVudCBjbG9ja3MuIFRoZSBkcmlmdA0KaXMgZWFzaWx5IHZpc2li
bGUNCnVzaW5nIEtlcm5lbFNoYXJrIGNvbWJvIHBsb3RzIC0gYXQgdGhlIHRyYWNlIHN0YXJ0LCBi
b3RoIHRyYWNlcyBhcmUNCnN5bmNlZCB3aXRoIGFjY3VyYWN5DQp1cCB0byAxLTIgdXMuIEF0IHRo
ZSB0cmFjZSBlbmQgdGhlIGRlc3luYyBpcyBiaWdnZXIsIGRlcGVuZGluZyBvbiB0aGUNCnRyYWNl
IGR1cmF0aW9uLg0KDQo+IFRoZSBmYWN0IHRoYXQgaXQgZHJpZnRzIHdpdGggeDg2LXRzYyBjbG9j
ayBib3RoZXJzIG1lLCBiZWNhdXNlIHRoZQ0KPiBndWVzdCBhbmQgdGhlIGhvc3QgYXJlIHVzaW5n
IHRoZSBzYW1lIGNyeXN0YWwuIEZvciB0aGVyZSB0byBiZSBhIGRyaWZ0LA0KPiB0aGUgdHNjIG9m
IHRoZSBndWVzdCBuZWVkcyB0byBiZSB1c2luZyBhIGRpZmZlcmVudCBjcnlzdGFsIHRoYW4gdGhl
DQo+IGhvc3QuIFRoYXQgaXMsIHR3byBkaWZmZXJlbnQgY2xvY2sgc291cmNlcyBmb3IgdGhlIFRT
QyBkZXBlbmRpbmcgb24gaWYNCj4gdGhlIENQVSBpcyBpbiB0aGUgVk0gb3IgaW4gdGhlIGhvc3Qg
Y29udGV4dC4NCj4NCj4gQlRXLCBpcyB5b3VyIGJveCBJbnRlbCBvciBBTUQ/DQo+DQo+IFRoYW5r
cywNCj4NCj4gLS0gU3RldmUNCg0KDQoNCi0tIA0KDQpUenZldG9taXIgKENlY28pIFN0b3lhbm92
DQpWTXdhcmUgT3BlbiBTb3VyY2UgVGVjaG5vbG9neSBDZW50ZXINCg==
