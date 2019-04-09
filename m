Return-Path: <SRS0=eAkL=SL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67950C10F0E
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Apr 2019 15:44:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A1492084C
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Apr 2019 15:44:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="Dv0g+Vi+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbfDIPo5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 9 Apr 2019 11:44:57 -0400
Received: from mail-eopbgr810080.outbound.protection.outlook.com ([40.107.81.80]:53332
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726486AbfDIPo5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Apr 2019 11:44:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o7oiONrvJtw2qh1r7TFeN8jqvpt++PGBSDsSmk237+g=;
 b=Dv0g+Vi+m/BcFINL+iT/tSHLsfQtJ8+GBH7tLIsadJKsGVvkByXbBd3ftUgs1s32jsVyvi7DfxB8Wed5tbZ2TDTo/oU4XoA9D9ieWtrO5HW0pSV+biMBZiDgVt7OC81/ZKFERrDssNi8jeohrLQ/krhA0G0EKMEStkEjRlTroxM=
Received: from MWHPR0501MB3772.namprd05.prod.outlook.com (10.167.163.156) by
 MWHPR0501MB3707.namprd05.prod.outlook.com (10.167.163.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1792.8; Tue, 9 Apr 2019 15:44:53 +0000
Received: from MWHPR0501MB3772.namprd05.prod.outlook.com
 ([fe80::b9a6:ba16:fc53:bb41]) by MWHPR0501MB3772.namprd05.prod.outlook.com
 ([fe80::b9a6:ba16:fc53:bb41%5]) with mapi id 15.20.1792.007; Tue, 9 Apr 2019
 15:44:53 +0000
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        Yordan Karadzhov <ykaradzhov@vmware.com>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 1/4] kernel-shark: Configuration information in
 ${HOME}/.cache/kernelshark
Thread-Topic: [PATCH 1/4] kernel-shark: Configuration information in
 ${HOME}/.cache/kernelshark
Thread-Index: AQHU7h2WcCXQDyjBs0OQUMjYOKqD5aYzwfgAgAAQu4CAABrHgIAAAywAgAAJaAA=
Date:   Tue, 9 Apr 2019 15:44:53 +0000
Message-ID: <CAE0o1Nv_JgHpTHgwpLhw7dkyxqW_u-rRUBMojgzPENCwVUDbmg@mail.gmail.com>
References: <20190404145603.13592-1-ykaradzhov@vmware.com>
 <20190404145603.13592-2-ykaradzhov@vmware.com> <20190408150102.GA6430@box>
 <20190408111308.301f30c1@gandalf.local.home>
 <0808d774-880a-f232-dda3-cd897120d86d@gmail.com>
 <20190409092349.3e7cb6e3@gandalf.local.home>
 <CAE0o1NtOBbVGjHfYyqOhrCrmywSNjYWOprDU66uMTPx4hX4UGA@mail.gmail.com>
 <20190409111100.28297adb@gandalf.local.home>
In-Reply-To: <20190409111100.28297adb@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: DM6PR11CA0010.namprd11.prod.outlook.com
 (2603:10b6:5:190::23) To MWHPR0501MB3772.namprd05.prod.outlook.com
 (2603:10b6:301:7a::28)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kaslevs@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: APjAAAVQK3L77iNYM+F3K4jFqpY9KpgUTk8yx7sjy/A2cjJ+tSKyO7rc
        R9UiLrlAcmNvXTpai3X6pJTnxsYvsvHiWhBP7g==
x-google-smtp-source: APXvYqwlz0TQg29gGce/rUPa4zJfIBnx6mB4yBkwnpGZIldlLGd4S2R/K+k4coBeAz3SU0/gtjAXUS+jzLE3caUN1+I=
x-received: by 2002:a24:d11:: with SMTP id 17mr25412145itx.30.1554824692180;
 Tue, 09 Apr 2019 08:44:52 -0700 (PDT)
x-gmail-original-message-id: <CAE0o1Nv_JgHpTHgwpLhw7dkyxqW_u-rRUBMojgzPENCwVUDbmg@mail.gmail.com>
x-originating-ip: [209.85.166.180]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 05e75ffd-5956-4e8f-07c6-08d6bd024f00
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600139)(711020)(4605104)(2017052603328)(7193020);SRVR:MWHPR0501MB3707;
x-ms-traffictypediagnostic: MWHPR0501MB3707:
x-microsoft-antispam-prvs: <MWHPR0501MB37077B0FCF4BC7F5350E4100DA2D0@MWHPR0501MB3707.namprd05.prod.outlook.com>
x-forefront-prvs: 000227DA0C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(136003)(39860400002)(366004)(346002)(396003)(189003)(199004)(102836004)(6116002)(6506007)(71190400001)(76176011)(386003)(71200400001)(186003)(26005)(61726006)(14444005)(53936002)(256004)(316002)(9686003)(6512007)(86362001)(93886005)(3846002)(2906002)(53546011)(54906003)(498394004)(95326003)(6862004)(478600001)(106356001)(5660300002)(229853002)(8936002)(99286004)(446003)(7736002)(55446002)(52116002)(97736004)(6486002)(68736007)(61266001)(6436002)(105586002)(6246003)(305945005)(81166006)(81156014)(476003)(25786009)(8676002)(11346002)(14454004)(66066001)(486006)(4326008)(228453006);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR0501MB3707;H:MWHPR0501MB3772.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 6Zt+LwoSyqvbwxC1nVyEso942LTwSzfbQaHGLJ/9F7dU33scM67XJjvVa3qE10rTKDDtnDbfdlTCoCfeSJd8g1Fr5TdO9Ir+XLF2GGPIq5c6K6k/eJ1maIQ4Xppyj5yPQRolJlrZ1tDZGNuB2TBAUpmNoVhnS69NWcjxndUkXadRcYSS3nLNEcQzexyAIdVcea0t5ePXUhCxmg3biJ1qY167ZGUdzuCTCF9/S/oH3RjsY70XUJgJcAZJYg4+MrvIVvn/ROb5Cuz7EkqAloY8i7P9QIkeeAYu1p4bYmNSgfwtNCcwqzoK91s++vGSJiDDAXxVE8OrnCCGw1NBO0duOjo14deazWU1YXqYyqg6uzUbtK6YFoacT2QK6VKgSY9r60qGmOvXQwGbsx/10lZl8KYox4BeAWZgo4bQhg4bI3c=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4A3E0F2D15EAD84390E9A1B0830D68FF@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05e75ffd-5956-4e8f-07c6-08d6bd024f00
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2019 15:44:53.6142
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0501MB3707
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gVHVlLCBBcHIgOSwgMjAxOSBhdCA2OjExIFBNIFN0ZXZlbiBSb3N0ZWR0IDxyb3N0ZWR0QGdv
b2RtaXMub3JnPiB3cm90ZToNCj4NCj4gT24gVHVlLCA5IEFwciAyMDE5IDE0OjU5OjU0ICswMDAw
DQo+IFNsYXZvbWlyIEthc2xldiA8a2FzbGV2c0B2bXdhcmUuY29tPiB3cm90ZToNCj4NCj4gPiBX
ZSBhbHNvIGhhdmUgdGhlIHNhbWUgcHJvYmxlbSB3aXRoIEtTX0RJUiBhbmQgVFJBQ0VDTURfQklO
X0RJUiB0aG91Z2guDQo+ID4gVGhleSBib3RoIHBvaW50IGluc2lkZSB0aGUgdHJhY2UtY21kIHNv
dXJjZSBkaXJlY3RvcnkgZm9yIHRoZSB1c2VyIHdobw0KPiA+IGJ1aWx0IGtlcm5lbHNoYXJrIGF0
bS4NCj4NCj4gSG1tLCB0aGVzZSBhcmUgYSBiaXQgZGlmZmVyZW50LiBJJ20gbm90IHN1cmUgSSB3
YW50IHRoZW0gdG8gYmUgdXNlcg0KPiBydW4tdGltZSBjb25maWd1cmFibGUsIGJlY2F1c2UgdGhl
eSBhcmUgZXhlY3V0aW5nIHN5c3RlbSB0b29scy4gVGhhdA0KPiBjb3VsZCBiZSBhIHNlY3VyaXR5
IGNvbmNlcm4uDQo+DQo+IEJ1dCB0aGV5IHNob3VsZCBiZSBjb21waWxlIHRpbWUgY29uZmlndXJh
YmxlLCBzdWNoIHRoYXQgYSBkaXN0cm8gY2FuDQo+IGRlZmluZSB0aGVtLg0KDQpJIGFncmVlLCB0
aGVyZSdzIG5vIG5lZWQgZm9yIHRob3NlIHRvIGhhdmUgZW52aXJvbm1lbnQgdmFyaWFibGUgb3Zl
cnJpZGUuDQoNClRoZSBwcm9ibGVtIGlzIHRoZSB3YXkgdGhleSBhcmUgZGVmaW5lZCBhdG06DQoN
CiMgRmlyc3Qgc2VhcmNoIGluIHRoZSB1c2VyIHByb3ZpZGVkIHBhdGhzLg0KZmluZF9wYXRoKFRS
QUNFQ01EX0JJTl9ESVIgICAgICBOQU1FUyAgdHJhY2UtY21kDQogICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIFBBVEhTICAkRU5We1RSQUNFX0NNRH0vdHJhY2VjbWQvDQogICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAke0NNQUtFX1NPVVJDRV9ESVJ9Ly4uL3RyYWNl
Y21kLw0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBOT19ERUZBVUxUX1BBVEgpDQoN
ClRoaXMgd2lsbCBuZXZlciBldmFsdWF0ZSB0byAvdXNyL2JpbiB3aGljaCBpcyB3aGF0IGl0IHNo
b3VsZCBiZSBmb3INCmRpc3RybyBidWlsZHMuDQoNCktTX0RJUiBpcyB1c2VkIHJ1bnRpbWUgdG8g
bG9hZCBwbHVnaW5zLCBhcyBkZWZhdWx0IHBhdGggZm9yIGZpbGUgb3Blbg0KZGlhbG9ncyAod2hp
Y2ggZG9lc24ndCBtYWtlIG11Y2ggc2Vuc2UgaW1vKSBhbmQgYXQgY29tcGlsZSB0aW1lIHRvDQpj
b25zdHJ1Y3QgcmVsYXRpdmUgcGF0aHMgaW4gdGhlIHNvdXJjZSBkaXJlY3RvcnkuIEl0IGlzIGN1
cnJlbnRseQ0KZGVmaW5lZCBzaW1wbHkgYXMNCg0Kc2V0KEtTX0RJUiAke0NNQUtFX1NPVVJDRV9E
SVJ9KQ0KDQpJIHRoaW5rIHRoZXJlIG5lZWRzIHRvIGJlIGEgc2VwYXJhdGUgY29uc3RhbnQgZm9y
IHBsdWdpbnMgcGF0aCB0aGF0DQpjYW4gYmUgc2V0IGF0IGJ1aWxkIHRpbWUgYW5kIGluIGRpc3Ry
byBidWlsZCBjYW4gcG9pbnQgdG8NCi91c3Ivc2hhcmUva2VybmVsc2hhcmsvcGx1Z2lucyBvciBz
b21ld2hlcmUgd2hlcmUgd2Ugd2FudCBzaGFyZWQNCnBsdWdpbnMgdG8gbGl2ZS4gVGhlIGNvbXBp
bGUgdGltZSB1c2VzIG9mIEtTX0RJUiBhcmUgZmluZSB0aG91Z2gNCiR7Q01BS0VfU09VUkNFX0RJ
Un0gaXMgY2xlYXJlciBmb3IgdGhlIHJlYWRlci4gVGhlIGRlZmF1bHQgZGlyZWN0b3J5DQpmb3Ig
ZmlsZSBvcGVuIGRpYWxvZ3MgY2FuIGJlIHRoZSBjdXJyZW50IGRpcmVjdG9yeSBvciB0aGUgbGFz
dCBvcGVuZWQNCnBhdGggcmF0aGVyIHRoYW4gdGhlIGtlcm5lbHNoYXJrIHNvdXJjZSBkaXJlY3Rv
cnkuDQoNCldoYXQgZG8geW91IHRoaW5rPw0KDQpDaGVlcnMsDQoNCi0tIFNsYXZpDQo=
