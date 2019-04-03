Return-Path: <SRS0=MeYK=SF=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4009C4360F
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Apr 2019 13:12:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 742992084C
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Apr 2019 13:12:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="S36G5z9h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726074AbfDCNMf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 3 Apr 2019 09:12:35 -0400
Received: from mail-eopbgr790043.outbound.protection.outlook.com ([40.107.79.43]:50485
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725959AbfDCNMe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Apr 2019 09:12:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+TbsnULgaWf6Y29a+rsURmHjZhKAkvHNRScEwGEyRVQ=;
 b=S36G5z9h2Wfh5gYjnu0G5Xoq6JjmraewHmQNYuzVAw8zj51z8fgPxKKNYP7fMoykKX6jW8jT3FIlxSnOEXocrCg3K3H+OgbfxDTPGseL1af9ZrvZUKKB7AHRX9OikznZcxE4xErGiYa/+myjjFVdwzNLi0l8HwoX/3YWzqEe4GQ=
Received: from MWHPR0501MB3772.namprd05.prod.outlook.com (10.167.163.156) by
 MWHPR0501MB3753.namprd05.prod.outlook.com (10.167.163.149) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1771.7; Wed, 3 Apr 2019 13:12:32 +0000
Received: from MWHPR0501MB3772.namprd05.prod.outlook.com
 ([fe80::b9a6:ba16:fc53:bb41]) by MWHPR0501MB3772.namprd05.prod.outlook.com
 ([fe80::b9a6:ba16:fc53:bb41%5]) with mapi id 15.20.1771.007; Wed, 3 Apr 2019
 13:12:32 +0000
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     "rostedt@goodmis.org" <rostedt@goodmis.org>
CC:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [RFC PATCH v9 03/11] trace-cmd: Add tracecmd_create_recorder_virt
 function
Thread-Topic: [RFC PATCH v9 03/11] trace-cmd: Add
 tracecmd_create_recorder_virt function
Thread-Index: AQHU6h1589TOvxDWWU2iUd+75x6f86YqaY6A
Date:   Wed, 3 Apr 2019 13:12:32 +0000
Message-ID: <dd166a8e78586b27498d0cd101f1205ddbd3a92a.camel@vmware.com>
References: <20190402134540.32321-1-kaslevs@vmware.com>
         <20190402134540.32321-4-kaslevs@vmware.com>
         <20190403090213.77fe1728@gandalf.local.home>
In-Reply-To: <20190403090213.77fe1728@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kaslevs@vmware.com; 
x-originating-ip: [146.247.46.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 65cdac7e-24f2-48e5-e540-08d6b836086d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600139)(711020)(4605104)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MWHPR0501MB3753;
x-ms-traffictypediagnostic: MWHPR0501MB3753:
x-microsoft-antispam-prvs: <MWHPR0501MB37534282AC3CA8BFFC6B24E5DA570@MWHPR0501MB3753.namprd05.prod.outlook.com>
x-forefront-prvs: 0996D1900D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(39860400002)(136003)(366004)(346002)(396003)(189003)(199004)(54534003)(97736004)(4744005)(71200400001)(229853002)(53936002)(6436002)(71190400001)(478600001)(68736007)(2351001)(476003)(6246003)(5660300002)(14454004)(6512007)(66066001)(5640700003)(256004)(86362001)(36756003)(7736002)(305945005)(81166006)(8936002)(102836004)(6486002)(25786009)(486006)(6506007)(26005)(1730700003)(8676002)(6916009)(76176011)(105586002)(4326008)(6116002)(81156014)(99286004)(186003)(2906002)(316002)(106356001)(2616005)(118296001)(11346002)(2501003)(446003)(3846002);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR0501MB3753;H:MWHPR0501MB3772.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: viYFjLT8rK/+gTloynOn0Xz+Mag288Y8xpe/kwveltSkH6v+NAcyF+kapbBTyg0PSXbr4JqWsH6/TF6kDGqZyDNQY4mrsS/cM2LZF7ERg2FcrlBt9DBCgw4uCZ0OD9A+wsP55F1Vke6WLD3Wsh4RKiAlmkBnraeBREaT3NhdcATboIapFlacErmEro576UCnAN9AaUu8z+asOPWoGx3WLr5t1Q22VF6Q7ZbBT1sEd1TlUV7S2Sv85KxVTVDHV5Jmjt4hHZR20NTkqBjAFWAKPCFdY7veMHb8ZYESwW4v+9vwGE4sWF6hpLsJgtZIPbUoDGFSzqaTN7QE2HosPi5yG0o42Bv8a/VuV58Gp7wo2UlFAN5HGsJPWuTblYIE65Qp6a2K4SFnmum8i+82QRW94jQ3arayUpJUE1vesU+LUOQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2A53B73CC1671940A40D70D76FA85CE3@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65cdac7e-24f2-48e5-e540-08d6b836086d
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Apr 2019 13:12:32.7177
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0501MB3753
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gV2VkLCAyMDE5LTA0LTAzIGF0IDA5OjAyIC0wNDAwLCBTdGV2ZW4gUm9zdGVkdCB3cm90ZToN
Cj4gT24gVHVlLCAgMiBBcHIgMjAxOSAxNjo0NTozMiArMDMwMA0KPiBTbGF2b21pciBLYXNsZXYg
PGthc2xldnNAdm13YXJlLmNvbT4gd3JvdGU6DQo+IA0KPiA+IEFkZCB0cmFjZWNtZF9jcmVhdGVf
cmVjb3JkZXJfdmlydCBmdW5jdGlvbiB0aGF0IHdpbGwgYmUgdXNlZCBmb3INCj4gPiB0cmFjaW5n
IFZNIGd1ZXN0cy4NCj4gDQo+IEEgbGl0dGxlIHdlZWsgb24gdGhlIGNoYW5nZSBsb2cuIFNob3Vs
ZCBoYXZlIGEgZGVzY3JpcHRpb24gYWJvdXQgd2h5DQo+IHRyYWNlY21kX2NyZWF0ZV9yZWNvcmRl
cl92aXJ0KCkgZG9lcyBub3QgbmVlZCBhIGJ1ZmZlci4NCg0KRmFpciBwb2ludC4gSSdsbCBhZGQg
YmV0dGVyIGRlc2NyaXB0aW9uIGZvciB0aGUgbmV4dCBpdGVyYXRpb24gYW5kIGENCmRvY3N0cmlu
ZyBjb21tZW50IGZvciB0aGlzIGZ1bmN0aW9uLg0K
