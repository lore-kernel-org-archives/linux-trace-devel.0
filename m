Return-Path: <SRS0=onCu=SZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D67CC10F03
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Apr 2019 15:08:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B1B0206BA
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Apr 2019 15:08:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="rFGTYKHx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727761AbfDWPI7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 23 Apr 2019 11:08:59 -0400
Received: from mail-eopbgr680087.outbound.protection.outlook.com ([40.107.68.87]:14566
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727745AbfDWPI7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 23 Apr 2019 11:08:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uLiDJvh4Or59k4/qonfdVfD+TYIORwXdGr6phhWk4oM=;
 b=rFGTYKHx1RoTho3xG44ed/xZeiTiZVq3Ta91YfkX70miX8iYENR8dw1k2EDGxGXk7bBV7s6N/651k5L9DV40sduXMTaJu2q6oavoT25hdPkSu2TYYVlTwC/ZlJ6z/XkInCbJZ4aTaTi7qzlYMJSZWYlGBMNFl4zwljRhRIyTOaQ=
Received: from MWHPR0501MB3772.namprd05.prod.outlook.com (10.167.163.156) by
 MWHPR0501MB3707.namprd05.prod.outlook.com (10.167.163.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.9; Tue, 23 Apr 2019 15:08:55 +0000
Received: from MWHPR0501MB3772.namprd05.prod.outlook.com
 ([fe80::3949:85c0:3b7b:136e]) by MWHPR0501MB3772.namprd05.prod.outlook.com
 ([fe80::3949:85c0:3b7b:136e%5]) with mapi id 15.20.1835.010; Tue, 23 Apr 2019
 15:08:54 +0000
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     "rostedt@goodmis.org" <rostedt@goodmis.org>
CC:     Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v3] trace-cmd: Load trace-cmd plugins from build folder,
 if exists
Thread-Topic: [PATCH v3] trace-cmd: Load trace-cmd plugins from build folder,
 if exists
Thread-Index: AQHU+eWOvK5FIqYHDUeqESeioxjhZaZJ2SKA
Date:   Tue, 23 Apr 2019 15:08:54 +0000
Message-ID: <54dda75f1da218e241e46c453504106cee6345e8.camel@vmware.com>
References: <20190423143344.30645-1-tstoyanov@vmware.com>
         <20190423110217.63ff2898@gandalf.local.home>
In-Reply-To: <20190423110217.63ff2898@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kaslevs@vmware.com; 
x-originating-ip: [146.247.46.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2b0f495a-9401-49c5-771b-08d6c7fd9a57
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:MWHPR0501MB3707;
x-ms-traffictypediagnostic: MWHPR0501MB3707:
x-microsoft-antispam-prvs: <MWHPR0501MB37078CBCEBDE2E52A9EBEAEBDA230@MWHPR0501MB3707.namprd05.prod.outlook.com>
x-forefront-prvs: 0016DEFF96
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(376002)(396003)(346002)(366004)(39860400002)(189003)(199004)(36756003)(316002)(6436002)(558084003)(26005)(6116002)(6916009)(5640700003)(3846002)(76176011)(6506007)(25786009)(2501003)(4326008)(2906002)(118296001)(186003)(53936002)(486006)(305945005)(6512007)(6486002)(2351001)(7736002)(14454004)(11346002)(476003)(2616005)(6246003)(446003)(229853002)(66066001)(1730700003)(68736007)(86362001)(102836004)(256004)(81166006)(81156014)(8936002)(71200400001)(99286004)(8676002)(91956017)(71190400001)(97736004)(5660300002)(478600001)(76116006)(73956011)(66946007)(66556008)(64756008)(66446008)(66476007)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR0501MB3707;H:MWHPR0501MB3772.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: IttEIHY+Ser39w3PZRhGfCOU9i2BoaZ1RrEILRDieiYyvMnBcGFTjPgjjxEHaFSFQytw116B7qq+DGfS5yym982p03GBaCIoA8NVwBeuePVB8fEYr56pp32pTqUtt1vViTFiTUM/OEIuIaGxiatsLrUyrq+tSHjf01MCkvTspdHifXahg1zVVAq3R6mjhER71zSDpxeFf3WbYMP7RIPFeABFupduU9Z7xO4g7k2z1PE7eevbln/ekehd/LGXO/Akq+62kve+agVS6iv+AsjePZQR1ij705HLMa5wf/338dzop5/tidoRi3CHWlo0l1+mS/6Jt0EbSqgclznSD4cEuxy17atc1gp+6oz0jtyxBuMRK2dihrHBur0Z0ZL/g+tiNM+xCQauPZUCs5G6tASDdf7m5cgWsFJ/axMlqW06wv8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <09E3437E54C5D8408DA152E14D8CB0B5@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b0f495a-9401-49c5-771b-08d6c7fd9a57
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Apr 2019 15:08:54.7358
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0501MB3707
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gVHVlLCAyMDE5LTA0LTIzIGF0IDExOjAyIC0wNDAwLCBTdGV2ZW4gUm9zdGVkdCB3cm90ZToN
Cj4gU2xhdm9taXIsDQo+IA0KPiBDYW4geW91IHJldmlldyB0aGlzIHBhdGNoLCBhbmQgaWYgaXQg
bG9va3MgZ29vZCB0byB5b3UsIGFkZCB5b3VyDQo+ICJSZXZpZXdlZC1ieSI/DQoNClN1cmUsIHRy
aWVkIGl0IGxvY2FsbHkgYW5kIHNlZW1zIHRvIGJlIHdvcmtpbmcgY29ycmVjdGx5DQoNClJldmll
d2VkLWJ5OiBTbGF2b21pciBLYXNsZXYgPGthc2xldnNAdm13YXJlLmNvbT4NCg0KQ2hlZXJzLA0K
DQotLSBTbGF2aQ0K
