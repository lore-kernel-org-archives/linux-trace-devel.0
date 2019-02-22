Return-Path: <SRS0=rw6q=Q5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFEDCC43381
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Feb 2019 20:22:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 767B42081B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Feb 2019 20:22:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="SZXvF5N5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725902AbfBVUW6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 22 Feb 2019 15:22:58 -0500
Received: from mail-eopbgr680066.outbound.protection.outlook.com ([40.107.68.66]:48007
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725900AbfBVUW5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 22 Feb 2019 15:22:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bgCTXS6ruZWMcdxqRMFXCdlCl+ulOrmmPw4uvXG9Hk8=;
 b=SZXvF5N5XEvaE+gsBzLBGdmE7BTdnCBd+nJ62KtXRDuzEAXOSJW+PI/nYEylOBzhUFnmaH8lSMtKeSDLUDyJHucv5f0jjssLZVg4Kd1LYy/DdGSFSgcVO3U3Q1tekU1aJdXclVvKurY/HgGGJNka+fg8fuwHg6spxtNk4DMqueg=
Received: from CO2PR05MB2775.namprd05.prod.outlook.com (10.166.200.27) by
 CO2PR05MB732.namprd05.prod.outlook.com (10.141.228.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1665.11; Fri, 22 Feb 2019 20:22:54 +0000
Received: from CO2PR05MB2775.namprd05.prod.outlook.com
 ([fe80::7572:1da7:ce29:f500]) by CO2PR05MB2775.namprd05.prod.outlook.com
 ([fe80::7572:1da7:ce29:f500%10]) with mapi id 15.20.1643.012; Fri, 22 Feb
 2019 20:22:54 +0000
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     Yordan Karadzhov <ykaradzhov@vmware.com>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 3/3] kernel-shark: Fix a bug in
 ksmodel_set_next_bin_edge()
Thread-Topic: [PATCH 3/3] kernel-shark: Fix a bug in
 ksmodel_set_next_bin_edge()
Thread-Index: AQHUyuWMFh7zgF3szkqjy355HcisWqXsQuuA
Date:   Fri, 22 Feb 2019 20:22:54 +0000
Message-ID: <CAE0o1NsjUh6KbBC+q5Pwg+SAV2+Wx8DJfxBPRa6pSRrFxqb81Q@mail.gmail.com>
References: <20190221124205.21115-1-ykaradzhov@vmware.com>
 <20190221124205.21115-4-ykaradzhov@vmware.com> <20190221161530.GA16009@box>
 <20190222143355.2370f919@gandalf.local.home>
In-Reply-To: <20190222143355.2370f919@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: DM5PR21CA0065.namprd21.prod.outlook.com
 (2603:10b6:3:129::27) To CO2PR05MB2775.namprd05.prod.outlook.com
 (2603:10b6:102:11::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: AHQUAuY0HLVjhZ9XKLJ/xVh3Ae2aY3iZNXn2v48RdcqhQ3tdKkOXPULx
        YSTHeS1IfT2FcMWM8wnI394wW7y9GDkK+eOPcA==
x-google-smtp-source: AHgI3IYbAs7cjndnqleMxbkGY95rADANzR3SwX/pvXlOV/TWzl3OCpkmPwEQXJLc/3O2X7jNU30rsKGfC+mGNPKmzBo=
x-received: by 2002:a24:7284:: with SMTP id x126mr3363750itc.15.1550866970323;
 Fri, 22 Feb 2019 12:22:50 -0800 (PST)
x-gmail-original-message-id: <CAE0o1NsjUh6KbBC+q5Pwg+SAV2+Wx8DJfxBPRa6pSRrFxqb81Q@mail.gmail.com>
x-originating-ip: [209.85.166.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 32a0d010-9569-466b-c501-08d699038656
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600110)(711020)(4605104)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:CO2PR05MB732;
x-ms-traffictypediagnostic: CO2PR05MB732:
x-ms-exchange-purlcount: 1
x-microsoft-exchange-diagnostics: 1;CO2PR05MB732;20:Rg1g/dC00m6sR1vaykJq4lFad3FccFcVk2Syh8hfIb9b3K/sycQsqxHx5WWzxufxTuHkZx8eiQ0rfib7neuJaUsJkJ34K4Gsk2BV8bOcwL40thBE8oo5ukFC0jcZ7gdm+JWgcM9qTFqGQO6U4xTsTleiiPb6Scj+VwPuk1b/yyQ=
x-microsoft-antispam-prvs: <CO2PR05MB7322F323C8353E112E628ECDA7F0@CO2PR05MB732.namprd05.prod.outlook.com>
x-forefront-prvs: 09565527D6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(39860400002)(376002)(346002)(136003)(366004)(199004)(189003)(6486002)(6436002)(14454004)(7736002)(6306002)(6116002)(53936002)(55446002)(97736004)(3846002)(305945005)(68736007)(95326003)(54906003)(86362001)(6246003)(316002)(53546011)(6506007)(478600001)(386003)(61726006)(6862004)(93886005)(99286004)(105586002)(11346002)(4326008)(186003)(2906002)(52116002)(102836004)(66066001)(26005)(446003)(476003)(61266001)(6346003)(81156014)(6512007)(9686003)(81166006)(498394004)(229853002)(8676002)(5660300002)(8936002)(71190400001)(71200400001)(25786009)(76176011)(4744005)(106356001)(256004)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:CO2PR05MB732;H:CO2PR05MB2775.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kaslevs@vmware.com; 
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: PbRQyL1eaPXnnmRwPWwIiK0RRwkYNsGMm4TsV7t+mRtSUuoCyTUJphh7NxUizSUkehebIStXPNsmOW5D7vj0pI0oMB6Dv608vUn7NVHGMxhusDvIq3ilAnAE2Wp2lj7JcQ+uUqNZmGKZTASwA3VDaBPrnRnAN+DpEDmU9/j4efwpCz7ugXQkkhFWwGLS2aD/7zn/XvMsMJi3Y9W/dIvjLNHod8nAcwgItvQarrmO3qBusjLr5ZUIGqmw4d/BG4nAtDuW5G36/0EGrNlvcG3/8HFkBOjQCiHwr1ILzeqEpBbVkwNlRr9IOMHEYJVSKJvM2nDNX6a+eLwHzEWuUH5yw6LpiUd6309aLcxORIenG2hVVbaUv1KToMAxLVKHhkzl8Uo3g4ADZXthOC9zz6g/KueL8zjWnKZVB9EsZiUnQTY=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F202257D2F213146B0D589C4FD4B15D9@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32a0d010-9569-466b-c501-08d699038656
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2019 20:22:53.7278
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO2PR05MB732
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gRnJpLCBGZWIgMjIsIDIwMTkgYXQgOTozNCBQTSBTdGV2ZW4gUm9zdGVkdCA8cm9zdGVkdEBn
b29kbWlzLm9yZz4gd3JvdGU6DQo+DQo+IE9uIFRodSwgMjEgRmViIDIwMTkgMTg6MTU6MzIgKzAy
MDANCj4gU2xhdm9taXIgS2FzbGV2IDxrYXNsZXZzQHZtd2FyZS5jb20+IHdyb3RlOg0KPg0KPiA+
IFBhdGNoZXMgMSwgMiBhbmQgMyBsb29rIGdvb2QgdG8gbWUuDQo+ID4NCj4gPiBBY2tlZC1ieTog
U2xhdm9taXIgS2FzbGV2IDxrYXNsZXZzQHZtd2FyZS5jb20+DQo+DQo+IFNsYXZvbWlyLCBpcyBp
dCBPSyB0aGF0IEkgcHV0ICJSZXZpZXdlZC1ieSIgaW5zdGVhZCBvZiAiQWNrZWQtYnkiLiBBDQo+
IHJldmlld2VkLWJ5IGNhcmllcyBhIGJpdCBtb3JlIHdlaWdodCBhbmQgc3RhdGVzIHRoYXQgeW91
IGRpZCBhIHJldmlldy4NCj4gQW4gYWNrIGlzIG1vcmUgb2YgInllYWgsIEkgbG9va2VkIGl0IG92
ZXIgYW5kIEknbSBPSyB3aXRoIHRoZSBpZGVhIiwNCj4gYnV0IGRvZXNuJ3QgYWN0dWFsbHkgbWVh
biB5b3UgcmV2aWV3ZWQgaXQuDQoNClRoYW5rcyBmb3IgcG9pbnRpbmcgaXQgb3V0LiBNeSBiYWQs
IEkgZGlkbid0IHJlYWxpemUgdGhlcmUgd2FzIGEgZGlmZmVyZW5jZVsxXS4NCg0KUmV2aWV3ZWQt
Ynk6IFNsYXZvbWlyIEthc2xldiA8a2FzbGV2c0B2bXdhcmUuY29tPg0KDQpbMV1odHRwczovL3d3
dy5rZXJuZWwub3JnL2RvYy9odG1sL3Y0LjIwL3Byb2Nlc3Mvc3VibWl0dGluZy1wYXRjaGVzLmh0
bWwjcmV2aWV3ZXItcy1zdGF0ZW1lbnQtb2Ytb3ZlcnNpZ2h0DQo=
