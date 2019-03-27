Return-Path: <SRS0=8Y6V=R6=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 720ECC43381
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Mar 2019 08:58:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A13D2075D
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Mar 2019 08:58:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="czFmMhgF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732499AbfC0I6X (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 27 Mar 2019 04:58:23 -0400
Received: from mail-eopbgr780050.outbound.protection.outlook.com ([40.107.78.50]:59349
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726344AbfC0I6X (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 27 Mar 2019 04:58:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dCMClAh6wXFv5NyKNrHb9jLdTjvZwU7zis72+fkVXr4=;
 b=czFmMhgFncP3ku/zJnCAhxbkph9BpaYLDYpbVoo2rXfAMERBHaBpNaCBMxK46Y6EDmybpShjVyUIxkdB4vaaBzZy9dXVHEl/MlQskLqiz74EOqbZheD/O9CMe+cGCMBvh3NrnzSZYYhuUNahpGa66tLISuk7XO2M6Cto/PZp7uA=
Received: from DM5PR0501MB3893.namprd05.prod.outlook.com (10.167.108.32) by
 DM5PR0501MB3880.namprd05.prod.outlook.com (10.167.108.31) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1750.15; Wed, 27 Mar 2019 08:58:20 +0000
Received: from DM5PR0501MB3893.namprd05.prod.outlook.com
 ([fe80::f425:1bb1:b518:a851]) by DM5PR0501MB3893.namprd05.prod.outlook.com
 ([fe80::f425:1bb1:b518:a851%2]) with mapi id 15.20.1750.014; Wed, 27 Mar 2019
 08:58:20 +0000
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] kernel-shark: Configuration information in
 ${HOME}/.cache/kernelshark
Thread-Topic: [PATCH v2 2/3] kernel-shark: Configuration information in
 ${HOME}/.cache/kernelshark
Thread-Index: AQHU2bC4//CfBZ+ds0W+DukXZfdFc6Yed/iAgADLEYA=
Date:   Wed, 27 Mar 2019 08:58:20 +0000
Message-ID: <6424edde-820e-a6a0-ac4e-cacf8c225652@vmware.com>
References: <20190313152220.22026-1-ykaradzhov@vmware.com>
 <20190313152220.22026-3-ykaradzhov@vmware.com>
 <20190326165125.5537384d@gandalf.local.home>
In-Reply-To: <20190326165125.5537384d@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: VI1PR09CA0091.eurprd09.prod.outlook.com
 (2603:10a6:803:78::14) To DM5PR0501MB3893.namprd05.prod.outlook.com
 (2603:10b6:4:7b::32)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [146.247.46.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 48c829ea-edf7-429e-e770-08d6b2925c28
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600127)(711020)(4605104)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:DM5PR0501MB3880;
x-ms-traffictypediagnostic: DM5PR0501MB3880:
x-microsoft-antispam-prvs: <DM5PR0501MB388081D3A10F1B4D2D6A6802A0580@DM5PR0501MB3880.namprd05.prod.outlook.com>
x-forefront-prvs: 0989A7979C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(346002)(396003)(39860400002)(376002)(189003)(199004)(14454004)(486006)(36756003)(5660300002)(476003)(25786009)(71190400001)(53936002)(6916009)(71200400001)(6436002)(99286004)(52116002)(66066001)(97736004)(7736002)(316002)(6486002)(446003)(11346002)(2616005)(305945005)(229853002)(6506007)(386003)(102836004)(478600001)(3846002)(106356001)(4326008)(68736007)(105586002)(26005)(6346003)(81156014)(8676002)(6512007)(256004)(6246003)(76176011)(31696002)(86362001)(6116002)(2906002)(81166006)(8936002)(31686004)(186003)(228453006);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR0501MB3880;H:DM5PR0501MB3893.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ykaradzhov@vmware.com; 
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: /jA4w04SC1O5gWGSlEpbLtuX2v3oCUpFNWLnDP3qnufi5WBNaWbPj4ubQ8iiQ5KeZj1o38R9EKp5C9uvFuPMGp8znzl7VpiP4gj69+lkbAveA55MJ3hptlwAcYSQ84itcuVc09WDOK7uLZ8SLi2rZfZx9Jb1YDpwuxdE5FMla+Tp2kCsWcr01fjA8GonWs6EWh4Y73YZhIyhPEu1FqXfyihCag9dUGbwG3soh/AMK7I2beF5BcxpfCwiERGDdZlHiZzv+Za+glhHRLaHRakrywkYRa5r7eVQArSOGnc/2Kyyvx4rc2LBIfWzcpADpazFDo1b5Ip4p7NMvb4LRFuN3xLA5uLI1y6Q023bLM07nRhlIlIi6/ZsaGtnuhpoZe+cpPQ4NE9n2ag6HZJ4XERWEciDQNePGwP9IVLCgdr9cww=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A794E0766420144791392030E8943D09@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48c829ea-edf7-429e-e770-08d6b2925c28
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Mar 2019 08:58:20.5911
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR0501MB3880
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

DQoNCk9uIDI2LjAzLjE5INCzLiAyMjo1MSDRhy4sIFN0ZXZlbiBSb3N0ZWR0IHdyb3RlOg0KPiBP
biBXZWQsIDEzIE1hciAyMDE5IDE3OjIyOjE5ICswMjAwDQo+IFlvcmRhbiBLYXJhZHpob3YgPHlr
YXJhZHpob3ZAdm13YXJlLmNvbT4gd3JvdGU6DQo+IA0KPj4gQEAgLTEyLDEwICsxMiwxMiBAQCBt
ZXNzYWdlKCJcbiBwcm9qZWN0OiBLZXJuZWwgU2hhcms6ICh2ZXJzaW9uOiAke0tTX1ZFUlNJT05f
U1RSSU5HfSlcbiIpDQo+PiAgIA0KPj4gICBzZXQoS1NfRElSICR7Q01BS0VfU09VUkNFX0RJUn0p
DQo+PiAgIA0KPj4gLSMgTWFrZSBhIGRpcmVjdG9yeSB0byBob2xkIGNvbmZpZ3VyYXRpb24gZmls
ZXMuIFRvIGNoYW5nZSB0aGlzIGRvOg0KPj4gLSMgY21ha2UgLi4gLURLU19DT05GX0RJUj0veW91
ci9wcmVmZXJyZWQvcGF0aA0KPj4gLXNldChLU19DT05GX0RJUiAiJHtLU19ESVJ9Ly5rc2NvbmYi
IENBQ0hFIFNUUklORyAiRGlyZWN0b3J5IGZvciBjb25maWd1cmF0aW9uIGZpbGVzLiIpDQo+PiAt
ZmlsZShNQUtFX0RJUkVDVE9SWSAke0tTX0NPTkZfRElSfSkNCj4+ICsjIE1ha2UgYSBkaXJlY3Rv
cnkgdG8gaG9sZCBjYWNoZWQgY29uZmlndXJhdGlvbiBmaWxlcy4gVG8gY2hhbmdlIHRoaXMgZG86
DQo+PiArIyBjbWFrZSAuLiAtREtTX0NBQ0hFX0RJUj0veW91ci9wcmVmZXJyZWQvcGF0aA0KPj4g
K3NldChLU19DQUNIRV9ESVIgIiRFTlZ7SE9NRX0vLmNhY2hlL2tlcm5lbHNoYXJrIg0KPj4gKyAg
ICBDQUNIRSBTVFJJTkcgIkRpcmVjdG9yeSBmb3IgY2FjaGVkIGNvbmZpZ3VyYXRpb24gZmlsZXMu
IikNCj4+ICsNCj4+ICtmaWxlKE1BS0VfRElSRUNUT1JZICR7S1NfQ0FDSEVfRElSfSkNCj4+ICAg
DQo+IA0KPiBUaGlzIHRpbWUgSSdtIG5vdCBjb25mdXNlZCAoSSB0cmllZCBpdCBvdXQpLg0KPiAN
Cj4gVGhlIGJ1aWxkIHByb2Nlc3Mgc2hvdWxkICpub3QqIG1ha2UgdGhlIC5jYWNoZS9rZXJuZWxz
aGFyayBkaXJlY3RvcnkuDQo+IEl0IHNob3VsZCBiZSBtYWRlIGJ5IHRoZSBhcHBsaWNhdGlvbiwg
anVzdCBsaWtlIGFsbCBvdGhlciBhcHBsaWNhdGlvbnMNCj4gZG8uDQo+IA0KDQpZZXMsIHRoaXMg
bWFrZXMgc2Vuc2UuIEkgd2lsbCBtYWtlIHRoZSBhcHBsaWNhdGlvbiBjcmVhdGluZyB0aGUgDQou
Y2FjaGUva2VybmVsc2hhcmsgZGlyZWN0b3J5IGlmIGl0IGRvZXNuJ3QgZXhpc3QuDQoNCkJ1dCBk
byBJIG5lZWQgdG8gcmVtb3ZlIHRoZSBjcmVhdGlvbiBvZiBkaXJlY3RvcnkgaW4gdGhlIGJ1aWxk
IHByb2Nlc3M/DQoNClRoYW5rcyENCllvcmRhbg0KDQoNCj4gLS0gU3RldmUNCj4gDQo=
