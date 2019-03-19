Return-Path: <SRS0=vzsu=RW=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B593C43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Mar 2019 18:02:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 510A5206B7
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Mar 2019 18:02:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="Mj89l8P2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727237AbfCSSCv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 19 Mar 2019 14:02:51 -0400
Received: from mail-eopbgr720052.outbound.protection.outlook.com ([40.107.72.52]:54736
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727163AbfCSSCv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 19 Mar 2019 14:02:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=itmeXA2AIraV+KQxOCYNd3/FeI3cnZ7wo4BhqwEAeEA=;
 b=Mj89l8P2UtvaV+9JnZ0QV3yfVfk2ba1I5IB8CISlh8BCDTMlbr84zt/DvGl95Y5ckWzeAoQ0JXsPCN0RPb/Vt7I1VW4TYAL71Ow9+mmWu8yhMu8SNYVXy8dS4yWkI1tywgBo4gT4COIOpuOAeOVaBeGEb7A0yXcl7iiUxPWlVgs=
Received: from CY1PR05MB2780.namprd05.prod.outlook.com (10.167.18.26) by
 CY1PR05MB2747.namprd05.prod.outlook.com (10.167.18.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.16; Tue, 19 Mar 2019 18:02:49 +0000
Received: from CY1PR05MB2780.namprd05.prod.outlook.com
 ([fe80::7cc5:3b5d:2c2c:d84f]) by CY1PR05MB2780.namprd05.prod.outlook.com
 ([fe80::7cc5:3b5d:2c2c:d84f%9]) with mapi id 15.20.1730.003; Tue, 19 Mar 2019
 18:02:48 +0000
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v7 9/9] trace-cmd [POC]: Implemented timestamps synch
 algorithm, using vsock events.
Thread-Topic: [PATCH v7 9/9] trace-cmd [POC]: Implemented timestamps synch
 algorithm, using vsock events.
Thread-Index: AQHU3nctZ6C8Zbk5PUahcL9sj22s0aYTO76AgAADK4A=
Date:   Tue, 19 Mar 2019 18:02:48 +0000
Message-ID: <CAE0o1NtchyejDbn_xCDjDmVLmP8vRF-Gv2SZSoigbxYR1Gc2dw@mail.gmail.com>
References: <20190319155536.19381-1-tstoyanov@vmware.com>
 <20190319155536.19381-10-tstoyanov@vmware.com>
 <CAE0o1NvsHhROnXesVHT08HfPO_FC3EjxXrkfqkPsF6SB=6Z2Lg@mail.gmail.com>
 <20190319135111.0061eddb@gandalf.local.home>
In-Reply-To: <20190319135111.0061eddb@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: YQXPR0101CA0014.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c00:15::27) To CY1PR05MB2780.namprd05.prod.outlook.com
 (2a01:111:e400:c63a::26)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kaslevs@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: APjAAAUnoCwp/B7VBqUmQ3aAZtWoBLBD+zXIzY1obAsZOpyU+VD7lFyB
        4bkT0rO5Y1W1ywCIEBw8kS6kM3twjAlyoJkfJw==
x-google-smtp-source: APXvYqwe8Xbdyfrp18+5RXT+xJegxlw1UcdUI4J/7vOKVoYfNHBIHFmkonwtlRpx37pVKPGXvCdChs2CYHc8BMfQNEQ=
x-received: by 2002:a05:660c:7c1:: with SMTP id
 e1mr2107864itl.73.1553018563656; Tue, 19 Mar 2019 11:02:43 -0700 (PDT)
x-gmail-original-message-id: <CAE0o1NtchyejDbn_xCDjDmVLmP8vRF-Gv2SZSoigbxYR1Gc2dw@mail.gmail.com>
x-originating-ip: [209.85.166.173]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 461769b8-ea11-4aea-feae-08d6ac951870
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:CY1PR05MB2747;
x-ms-traffictypediagnostic: CY1PR05MB2747:
x-microsoft-antispam-prvs: <CY1PR05MB27478CDE65C47533069F9237DA400@CY1PR05MB2747.namprd05.prod.outlook.com>
x-forefront-prvs: 0981815F2F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(136003)(346002)(376002)(366004)(396003)(199004)(189003)(305945005)(256004)(229853002)(86362001)(71200400001)(6246003)(106356001)(4744005)(68736007)(25786009)(105586002)(6512007)(7736002)(8676002)(498394004)(53936002)(9686003)(81156014)(5660300002)(81166006)(71190400001)(6486002)(6436002)(2906002)(66066001)(3846002)(93886005)(11346002)(54906003)(97736004)(476003)(76176011)(8936002)(61266001)(52116002)(99286004)(486006)(6116002)(386003)(14454004)(53546011)(102836004)(446003)(55446002)(478600001)(6506007)(4326008)(6862004)(95326003)(186003)(61726006)(26005)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR05MB2747;H:CY1PR05MB2780.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: q6gtlZTHaYJeu4+TvEeS2ypWjnvH1tyObYpuH45naq4KgdVuSwg21WGph4kRBpg8msEGOjis/mPDGs8ypQ0qSBLOMqPhRngwolsT1YHsHgDzj6NO1uKpT5adtsX009yivb+S+nxKoAKtWYFN2MIHeHpfEWBK9IaFQv3cV/8fwCY9hAf9uvS8xO8Hb1Fo14l3bMJNmpxbFgLUP+lDnmJNzemQ6tD0CugotSU7KuTwr7wkdbtgCylk01tEr0xn9xnA+oj079YaTz1qFexML5LRDNVkdwbX9BS6uIwnumMwXccHqU1SPyouNwNMpok0diwC3kZE8Uq5ccNUssu1j1k14O6uTEnGN0E1/2CzJn9VtTh7ixyigSKgZYzeC27wptohI2QIQUMcV1WvwT7rUQKCYDKKqGqMZ1djUgpE5mxDay0=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AFF5AE17E80FB446B1F59D5679511762@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 461769b8-ea11-4aea-feae-08d6ac951870
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Mar 2019 18:02:48.7753
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR05MB2747
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gVHVlLCBNYXIgMTksIDIwMTkgYXQgNzo1MiBQTSBTdGV2ZW4gUm9zdGVkdCA8cm9zdGVkdEBn
b29kbWlzLm9yZz4gd3JvdGU6DQo+DQo+IEp1c3QgYW4gRllJLCB3aGVuIHJlcGx5aW5nIHRvIGxh
cmdlIHBhdGNoZXMsIGl0J3MgcmVjb21tZW5kZWQgdG8gY3JvcA0KPiB0aGUgbWVzc2FnZSB0byB0
aGUgc3BlY2lmaWNzLCB0aGF0IHdheSBwZW9wbGUgZG9uJ3QgbmVlZCB0byBzY3JvbGwgZG93bg0K
PiBmb3JldmVyLCBhbmQgbW9zdCBsaWtlbHkgd2lsbCBtaXNzIGEgcmVzcG9uc2UuIFNvbWUga2Vy
bmVsIGRldmVsb3BlcnMgSQ0KPiBrbm93IHdvdWxkIGlnbm9yZSByZXBsaWVzIGlmIHRoZXkgYXJl
IG5vdCBwcm9wZXJseSBjcm9wcGVkLg0KPg0KPiBJbiBzb21lIGNhc2VzLCB0aGF0IGluY2x1ZGVz
IG1lIDstKSAoSWYgSSBzY3JvbGwgbW9yZSB0aGFuIDMgcGFnZXMsIGFuZA0KPiBkb24ndCBzZWUg
YSByZXNwb25zZSwgSSBzb21ldGltZXMgc3RvcCB0aGVyZSkuDQoNCkdvb2QgcG9pbnQsIEknbGwg
c3RhcnQgZG9pbmcgdGhhdC4gVGhhbmtzLg0KDQotLSBTbGF2aQ0K
