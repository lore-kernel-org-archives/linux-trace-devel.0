Return-Path: <SRS0=lLCO=RD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 959B1C43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Feb 2019 16:22:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46D2A218B0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Feb 2019 16:22:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="GP5f0dtx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727894AbfB1QWo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Feb 2019 11:22:44 -0500
Received: from mail-eopbgr720070.outbound.protection.outlook.com ([40.107.72.70]:51040
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726269AbfB1QWo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Feb 2019 11:22:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eTH3dNzBefHt7ChGr7JoX6yxoeniqcDKSwfLDuj/JZA=;
 b=GP5f0dtxCwEcHgkvn/iylWQ7TMtw7oU//lImyms6woGFvG4Z2QXtVwdWR+NwNYxpSNgF607q+JHaHiB4bWcNP09hW6alS+s4v0rHpU9+unmqTLD9MPzJlJ7UPmk6JUcumeOc5Yv3hfL4oHz8pwzvKdv/QeKuEEbVavcsAvu6MdA=
Received: from CY1PR05MB2761.namprd05.prod.outlook.com (10.167.18.19) by
 CY1PR05MB2476.namprd05.prod.outlook.com (10.167.10.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1686.9; Thu, 28 Feb 2019 16:22:41 +0000
Received: from CY1PR05MB2761.namprd05.prod.outlook.com
 ([fe80::50:9d56:d444:62ec]) by CY1PR05MB2761.namprd05.prod.outlook.com
 ([fe80::50:9d56:d444:62ec%4]) with mapi id 15.20.1665.012; Thu, 28 Feb 2019
 16:22:41 +0000
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>,
        Yordan Karadzhov <ykaradzhov@vmware.com>,
        Slavomir Kaslev <kaslevs@vmware.com>
Subject: Re: Can't use kvm_exit for the host side time stamp
Thread-Topic: Can't use kvm_exit for the host side time stamp
Thread-Index: AQHUze+1TvGa+2SoKkOpwa4eL67JqKX1Z7MA
Date:   Thu, 28 Feb 2019 16:22:40 +0000
Message-ID: <CACqStocgP+F+Kvr4a3a28V1ACEM=kbKVVSJxGbb0CiN9WdNKaA@mail.gmail.com>
References: <20190226112406.7abab75a@vmware.local.home>
In-Reply-To: <20190226112406.7abab75a@vmware.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR05CA0012.eurprd05.prod.outlook.com
 (2603:10a6:20b:2e::25) To CY1PR05MB2761.namprd05.prod.outlook.com
 (2a01:111:e400:c63a::19)
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: APjAAAWxdf88f0qFVly+oH1JMFXAMzIvX91i0C+NXQQd8jgQtEXbzskx
        m2UA2LaA3exJOSXtGGeOZeB4YruIw6vBSzUFfl8=
x-google-smtp-source: APXvYqxeX8uo2N/XaGo/PrOQc5ti86Cadm9pkTJAGf7VaLovo+X9JVQj+waxCb+1RRumE2b8XgDdorWy5hoNY7c2mM8=
x-received: by 2002:a7b:c08a:: with SMTP id r10mr327654wmh.112.1551370955597;
 Thu, 28 Feb 2019 08:22:35 -0800 (PST)
x-gmail-original-message-id: <CACqStocgP+F+Kvr4a3a28V1ACEM=kbKVVSJxGbb0CiN9WdNKaA@mail.gmail.com>
x-originating-ip: [209.85.128.44]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 49ff4d47-a7ff-4f65-4bf4-08d69d98f5cd
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:CY1PR05MB2476;
x-ms-traffictypediagnostic: CY1PR05MB2476:
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tstoyanov@vmware.com; 
x-microsoft-exchange-diagnostics: 1;CY1PR05MB2476;20:68NukkLfnT0vQhZq+qNyyZTUU7P7Np4My/DSaO6Tzg4tMqN87sbTnZweySiYXAR+EWndgCeRulrJNJFFtYZY0LWdH+R2RuBKAazeigSBrIHvkZCwgZiZpEu2C+1FUl2qru5SDLdk148HIb0qKzQHLWDsT9cHLGxe9cq7wGJD8gM=
x-microsoft-antispam-prvs: <CY1PR05MB2476B8C68E99531BCFAD35C2DC750@CY1PR05MB2476.namprd05.prod.outlook.com>
x-forefront-prvs: 0962D394D2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(376002)(346002)(39860400002)(366004)(136003)(199004)(189003)(256004)(53936002)(68736007)(5660300002)(446003)(11346002)(54906003)(97736004)(476003)(6246003)(86362001)(486006)(316002)(6116002)(3846002)(71190400001)(8936002)(14444005)(6486002)(229853002)(9686003)(106356001)(105586002)(186003)(6512007)(61726006)(71200400001)(2906002)(98316002)(6436002)(55446002)(498394004)(107886003)(386003)(14454004)(25786009)(99286004)(52116002)(61266001)(6506007)(6862004)(66066001)(53546011)(102836004)(478600001)(76176011)(26005)(81156014)(95326003)(8676002)(81166006)(4326008)(305945005)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR05MB2476;H:CY1PR05MB2761.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 8mUDGYINKkmf946Hv9rzdcuOLcrAYBbUQgq3co8K8ySzJ+s3RDZY5watkB9cJI9azV02Gt7Xbdc2oZ3T7SeIScfk59EewAA0Y6/Ns+1VojKZbnmqS8dMkdKPzeLVeuUaBXsWewS4uNNMucRQSA7DKvK3bWNBUtP1plxWjC+zGyrzQ4Si6RRozVUDJnE4fvGUVJCWfdZOWmy1eUhjhmg6v4VWSyGyGe1dG2u0dTmIYyNt/r8WyX4JxrKd9OICGgiWm0Z1+taz5ht7LlUI3BnPx1sBNlMO1+sH5q3wz4fCJn612JkcAgjd7u4M1YvnJ5AC3VRKc3Z5bCXovp4hVOnfXCYXiGYFhHa/kqhOiT0arlcRYFB5PZlMsIe49z9WM9f0efPu+/PbMG8cxm6R5pAHUZl0oiGcdsT1eqT94OhYbFQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EBD42CA929B88645A7B860F150F4A21C@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49ff4d47-a7ff-4f65-4bf4-08d69d98f5cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2019 16:22:41.0741
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR05MB2476
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

SGkgU3RldmVuLA0KT24gVHVlLCBGZWIgMjYsIDIwMTkgYXQgNjoyNCBQTSBTdGV2ZW4gUm9zdGVk
dCA8cm9zdGVkdEBnb29kbWlzLm9yZz4gd3JvdGU6DQo+DQo+IEhpIENlY28sDQo+DQo+IEkgd2Fz
IHdhbGtpbmcgWW9yZGFuIGRvd24gdGhlIGNvZGUgaW4gdGhlIGtlcm5lbCB0byBzaG93IGhpbSB0
aGUgaWRlYXMNCj4gSSBoYXZlIGFib3V0IHVzaW5nIGt2bV9leGl0IGFzIHRoZSB0cmFjZSBldmVu
dCBvbiB0aGUgaG9zdCBzaWRlLCB3aGVuIEkNCj4gbm90aWNlZCB0aGF0IGl0J3MgY2FsbGVkICph
ZnRlciogaW50ZXJydXB0cyBhbmQgcHJlZW1wdGlvbiBhcmUgZW5hYmxlZCENCj4NCj4gVGhpcyB0
b3RhbGx5IGJyZWFrcyB0aGUgZGVzaWduLCBhcyBpdCBpcyBub3QgYSByZWxpYWJsZSBldmVudCwg
YmVjYXVzZQ0KPiB0aGUgcHJvY2VzcyBydW5uaW5nIHRoZSBndWVzdCBpcyBsaWtlbHkgdG8gZ2V0
IGFuIGludGVycnVwdCBvcg0KPiBwcmVlbXB0ZWQgYmVmb3JlIHJlY29yZGluZyB0aGF0IGV2ZW50
LCB3aGljaCBjYW4gY2F1c2UgYSBodWdlDQo+IGRpZmZlcmVuY2UuDQo+DQo+IGt2bV9lbnRlciBp
cyBmaW5lLCBidXQgdGhlIHJlYXNvbiB0aGF0IGt2bV9leGl0IGlzIG5vdCwgaXMgYmVjYXVzZSwg
aW4NCj4gb3JkZXIgdG8gcmVjb3JkIHRoZSByZWFzb24gZm9yIHRoZSBleGl0LCBpdCBuZWVkcyB0
byBjYWxsIGludG8gZWl0aGVyDQo+IHRoZSBJbnRlbCBvciBBTUQgY29kZSAoYXMgdGhleSBhcmUg
ZGlmZmVyZW50KSwgYW5kIHRoYXQgaXMgZG9uZSBhZnRlcg0KPiBpbnRlcnJ1cHRzIGFuZCBwcmVl
bXB0aW9uIGFyZSBlbmFibGVkLg0KPg0KPiBJbnN0ZWFkLCB3ZSBjYW4gdHJhY2UgdGhlIGZ1bmN0
aW9uIGt2bV9yZWFkX2wxX3RzYywgd2hpY2ggaGFwcGVucyB3aGlsZQ0KPiBpbnRlcnJ1cHRzIGFy
ZSBzdGlsbCBlbmFibGVkLg0KDQpJIGNoYW5nZWQgdGhlIGltcGxlbWVudGF0aW9uIHRvIHRyYWNr
IGt2bV9yZWFkX2wxX3RzYygpIGluc3RlYWQgb2YNCmt2bV9leGl0KCkgYW5kIHRlc3RlZCBvbiBt
eSBtYWNoaW5lLiBUaGUgcmVzdWx0cyB3ZXJlIHZlcnkgb2RkLCBJDQpjYW5ub3Qgc2VlIGFueSB0
cmFjZXMgb2Yga3ZtX3JlYWRfbDFfdHNjKCkgY2FsbGVkIGJ5DQp2Y3B1X2VudGVyX2d1ZXN0KCks
IHRoZXJlIGFyZSBvbmx5IGJ1bmNoIG9mIGNhbGxzIGxpa2UgdGhhdDoNCiAgICAgICBDUFUgMS9L
Vk0tNTU1NSAgWzAwNV0gLi4uLiAgNDUzMC4xODAyMzA6IGt2bV9yZWFkX2wxX3RzYw0KPC12bXhf
c2V0X2h2X3RpbWVyDQogICAgICAgQ1BVIDEvS1ZNLTU1NTUgIFswMDVdIGQuLi4gIDQ1MzAuMTgw
MjM4OiBrdm1fcmVhZF9sMV90c2MgPC1zdGFydF9zd190aW1lcg0KICAgICAgIENQVSAwL0tWTS01
NTU0ICBbMDA3XSBkLi4uICA0NTMwLjE4Mzk5MToga3ZtX3JlYWRfbDFfdHNjDQo8LXdhaXRfbGFw
aWNfZXhwaXJlDQpXaXRoIHRoZSBoZWxwIG9mIFNsYXZpLCB3ZSBmb3VuZCB0aGF0IGt2bV9yZWFk
X2wxX3RzYygpIGlzIGNvbXBpbGVkIGFzDQppbmxpbmUgb24gbXkga2VybmVsICg0LjIwLjExLCBz
aGlwcGVkICBieSBGZWRvcmEpLCAgaW4gdGhpcyBzcGVjaWZpYw0KZmxvdy4gTG9va3MgbGlrZSBh
IGdjYyBvcHRpbWl6YXRpb24gPyAgV2UgdGVzdGVkIHdpdGgNCnZteF9yZWFkX2wxX3RzY19vZmZz
ZXQoKSwgaW5zdGVhZCBvZiBrdm1fcmVhZF9sMV90c2MoKSAgLSBpdCBhcHBlYXJzDQphcyBleHBl
Y3RlZCBpbiB0aGUgdHJhY2VzLCBhbmQgdGhlIHJlc3VsdHMgYXJlIG11Y2ggbW9yZSBhY2N1cmF0
ZQ0KdGhhbiB0aGUgY2FzZSB3aGVuICBrdm1fZXhpdCgpIGlzIHVzZWQuIFRoZSBwcm9ibGVtIGlz
IHRoYXQNCnZteF9yZWFkX2wxX3RzY19vZmZzZXQoKSBpcyBJbnRlbCBzcGVjaWZpYywgbW9zdCBw
cm9iYWJseSBpdCBpcyBub3QNCnVzZWQgb24gbm9uLUludGVsIENQVXMuDQoNCj4NCj4gV291bGQg
eW91IGJlIGFibGUgdG8gdGVzdCB3aXRoIHRoYXQgZnVuY3Rpb24gaW5zdGVhZCBvZiB1c2luZyBr
dm1fZXhpdD8NCj4gQWxzbywgaWYgeW91IHN0aWxsIHNlZSBhIGRyaWZ0LCB0cnkgc2V0dGluZyBi
b3RoIHRyYWNlIGNsb2NrcyB0bw0KPiB4ODYtdHNjLCBhbmQgc2VlIGlmIHlvdSBzdGlsbCBnZXQg
YSBkcmlmdC4NCj4NCj4gVGhhbmtzIQ0KPg0KPiAtLSBTdGV2ZQ0KDQoNCg0KLS0gDQoNClR6dmV0
b21pciAoQ2VjbykgU3RveWFub3YNClZNd2FyZSBPcGVuIFNvdXJjZSBUZWNobm9sb2d5IENlbnRl
cg0K
