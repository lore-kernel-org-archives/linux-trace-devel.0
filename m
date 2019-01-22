Return-Path: <SRS0=3hMC=P6=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2DE9C282C3
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Jan 2019 13:36:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2DAE20870
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Jan 2019 13:36:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="TSbNZVT6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728463AbfAVNgt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Jan 2019 08:36:49 -0500
Received: from mail-eopbgr780083.outbound.protection.outlook.com ([40.107.78.83]:64308
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728391AbfAVNgt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Jan 2019 08:36:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LEbotG/BdA9sw/HN/KqUhubu2gGYs5ZG2956f7ok+5I=;
 b=TSbNZVT6dy/DyPmmunyEYRTB1Fe7fLY+IWlqkAhRfM/MznRIDElL9QbLIGHxiZJ+iaSLfGNj2/mSxMNwimoyBrpdKhLmCzlJCtn6Y9kVi/on3EqCVMoOim8ugnEnVGIbRy7uIL4yk+EyDPGk0zWOOmwHYR931pJy6TTtbyaPHo4=
Received: from CY1PR05MB2761.namprd05.prod.outlook.com (10.167.18.19) by
 CY1PR05MB2729.namprd05.prod.outlook.com (10.167.18.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1558.10; Tue, 22 Jan 2019 13:36:46 +0000
Received: from CY1PR05MB2761.namprd05.prod.outlook.com
 ([fe80::a193:f46c:290f:3ca5]) by CY1PR05MB2761.namprd05.prod.outlook.com
 ([fe80::a193:f46c:290f:3ca5%3]) with mapi id 15.20.1558.016; Tue, 22 Jan 2019
 13:36:46 +0000
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 3/7] trace-cmd: Fixed logic in tracecmd_read_page_record()
Thread-Topic: [PATCH 3/7] trace-cmd: Fixed logic in
 tracecmd_read_page_record()
Thread-Index: AQHUrdBPFKAUyhI3EUSX4G3uCzYjGKW5dlcAgAHc/AA=
Date:   Tue, 22 Jan 2019 13:36:46 +0000
Message-ID: <CACqStofG6KQhTE-avnPtHeiG6fE=9-b6V+agNjVdTcRA8SfRiw@mail.gmail.com>
References: <20190116191838.32127-1-tstoyanov@vmware.com>
 <20190116191838.32127-4-tstoyanov@vmware.com>
 <20190121040916.164116aa@vmware.local.home>
In-Reply-To: <20190121040916.164116aa@vmware.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR06CA0034.eurprd06.prod.outlook.com
 (2603:10a6:20b:14::47) To CY1PR05MB2761.namprd05.prod.outlook.com
 (2a01:111:e400:c63a::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tstoyanov@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: AJcUukfFc1/ZQBC/C5Of3z3TSElFXL5OQ8YXIVhr9893pK81eAap+BUO
        xoUkZs89B6cq+3RlgnH0bx+QSs9XMwe4BjvIF2k=
x-google-smtp-source: ALg8bN5Wq13rmJmDak9cLe74NwCMBDuXG5skFTZxgPI7R5/lkDGFGMgEMkpbRSmHd0xhRhfqGResB6OWr4lyHDoU/Hc=
x-received: by 2002:a1c:1d81:: with SMTP id
 d123mr3751101wmd.112.1548164200841; Tue, 22 Jan 2019 05:36:40 -0800 (PST)
x-gmail-original-message-id: <CACqStofG6KQhTE-avnPtHeiG6fE=9-b6V+agNjVdTcRA8SfRiw@mail.gmail.com>
x-originating-ip: [209.85.128.53]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;CY1PR05MB2729;20:pdYwGZb7BObFIjXH7OMo7uRxiO5kLNbUrHH9oCBVv+ovGXl8EP5PpOSemHLQPe3xHKY0o70QKNMCP7gpr7dBkeZKFmjHzoUlzNI/Mios4MvO12mwD/EDucmEStMAX50hTqYhci3BDJ4bQNp4QUdilU1yGYPw/fqPz49TMpKGpFY=
x-ms-office365-filtering-correlation-id: cb1dfd1d-ca2f-4462-a656-08d6806ea762
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(2017052603328)(7153060)(7193020);SRVR:CY1PR05MB2729;
x-ms-traffictypediagnostic: CY1PR05MB2729:
x-microsoft-antispam-prvs: <CY1PR05MB27290BD7A09496EA13D47CBDDC980@CY1PR05MB2729.namprd05.prod.outlook.com>
x-forefront-prvs: 0925081676
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(136003)(346002)(39860400002)(396003)(366004)(189003)(199004)(53936002)(6116002)(6246003)(3846002)(6862004)(9686003)(7736002)(6512007)(305945005)(4326008)(86362001)(99286004)(486006)(8936002)(6486002)(498394004)(6436002)(106356001)(229853002)(105586002)(25786009)(68736007)(95326003)(55446002)(8676002)(256004)(81166006)(81156014)(446003)(102836004)(316002)(2906002)(61266001)(11346002)(476003)(14454004)(26005)(186003)(61726006)(97736004)(66066001)(478600001)(98316002)(386003)(71190400001)(71200400001)(76176011)(6506007)(53546011)(33896004)(52116002);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR05MB2729;H:CY1PR05MB2761.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: IdTLavNIv5dIZaf1uWGus/UHwfuyGM3mNyBHhv+dV7XLyThFEXfpfACbUbGyDnMt5OrS2nuheUfnyFphz2simN8jU74k1temsUf/tGp/63Ef+pQaS0NbXu8SkK/wvQbUz7FerycoDwJtkHREBtFI/edw5I7I/vUx7+feng06pL/2sAktxT3QA0suFbXqRdsbfMx1D0p83QdULJ35DcSHcijBXhPfSQsWS8MOV9dcmbHTvD60rafXY88cYQexxg8gNqHksts85bCLG3baHN2KPtwGbJqjIN691J88Ru/aWpCc9mkCjsDJWIEY3CZTlj3eKbNSGLRPTADZydXnTs3U/y3c8gjp44DpFw1OPDMVkXgFYDBHnr7Fdxb9JuxbjEcQauC3J3JzziE2i24h3fcSOug5TBAG3hd0KNG5WCZ6hm8=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <9CA2442BE92E03439AEDF79264E73FE4@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb1dfd1d-ca2f-4462-a656-08d6806ea762
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2019 13:36:46.2521
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR05MB2729
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gTW9uLCBKYW4gMjEsIDIwMTkgYXQgMTE6MDkgQU0gU3RldmVuIFJvc3RlZHQgPHJvc3RlZHRA
Z29vZG1pcy5vcmc+IHdyb3RlOg0KPg0KPiBPbiBXZWQsIDE2IEphbiAyMDE5IDIxOjE4OjM0ICsw
MjAwDQo+IFR6dmV0b21pciBTdG95YW5vdiA8dHN0b3lhbm92QHZtd2FyZS5jb20+IHdyb3RlOg0K
Pg0KPiA+IEZpeGVkIHRoZSBsb2dpYyBpbiB0cmFjZWNtZF9yZWFkX3BhZ2VfcmVjb3JkKCkgd2hl
bg0KPiA+IHNlYXJjaGluZyBmb3IgdGhlIG5leHQgZXZlbnQgaW4gdGhlIGV2ZW50IGZyb20gdGhl
DQo+ID4gcmluZyBidWZmZXIuDQo+DQo+IFBsZWFzZSBleHBsYWluIHdoYXQgeW91IGFyZSBmaXhp
bmcuIEluIG90aGVyIHdvcmRzLCB3aGF0IHdhcyB3cm9uZyB3aXRoDQo+IHRoZSBjdXJyZW50IGxv
Z2ljPw0KDQpJbiB0aGUgY3VycmVudCBsb2dpYywgaW4gdGhlIGNhc2Ugd2hlbiBsYXN0X3JlY29y
ZCBpcyBub3QgTlVMTCAod2UgYXJlDQpzZWFyY2hpbmcgZm9yIHRoZSBzZWNvbmQgb25lKQ0KdGhl
IGNoZWNrICJpZiAocHRyICE9IGxhc3RfcmVjb3JkLT5kYXRhKSIgYWx3YXlzIGZhaWxzLiBBcyBJ
IGNhbg0KdW5kZXJzdGFuZCwga2J1ZmZlcl9uZXh0X2V2ZW50KCkgcmVhZHMgdGhlIGV2ZW50DQph
ZnRlciB0aGUgb25lIHBvaW50ZWQgYnkgbGFzdF9yZWNvcmQuIEluIG15IHVzZSBjYXNlIEkgc2Vh
cmNoIGZvciBhDQpzZXJpZXMgb2YgZmV3IGV2ZW50cywNCnRyYWNlY21kX3JlYWRfcGFnZV9yZWNv
cmQoKSByZXR1cm5zIHRoZSBmaXJzdCBvbmUgKHdoZW4gSSBwYXNzDQpsYXN0X3JlY29yZD1OVUxM
KSwgYW5kIGFsd2F5cyBmYWlscyBvbg0KdGhlIHNlY29uZCBvbmUgd2l0aCB0aGUgZXJyb3IgInRy
YWNlY21kX3JlYWRfcGFnZV9yZWNvcmQ6IGNvdWxkIG5vdA0KZmluZCBsYXN0X3JlY29yZCIuIEkg
dXNlIGEgZ2RiIHRvIGZpZ3VyZSBvdXQNCndoYXQgaGFwcGVucyB0aGVyZS4NCg0KPg0KPiAtLSBT
dGV2ZQ0KPg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogVHp2ZXRvbWlyIFN0b3lhbm92IDx0c3Rv
eWFub3ZAdm13YXJlLmNvbT4NCj4gPiAtLS0NCg0KDQoNCi0tIA0KDQpUenZldG9taXIgKENlY28p
IFN0b3lhbm92DQpWTXdhcmUgT3BlbiBTb3VyY2UgVGVjaG5vbG9neSBDZW50ZXINCg==
