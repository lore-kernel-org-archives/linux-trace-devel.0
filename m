Return-Path: <SRS0=gVBF=RY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 920ABC43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Mar 2019 15:06:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 538A321874
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Mar 2019 15:06:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="k9ipG2Ae"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728221AbfCUPGL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 21 Mar 2019 11:06:11 -0400
Received: from mail-eopbgr720072.outbound.protection.outlook.com ([40.107.72.72]:48177
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727958AbfCUPGK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 21 Mar 2019 11:06:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FgWAyufMvG7g/JRxKC+dLG6SRW3FLwcvZ9ZRb6XjBFE=;
 b=k9ipG2Ae8ZdMG4FzG4G1R3qP0YZ6mlIp9UkEN7LPnLiivAhlr5Yluz58s09BBrjOOkqd+3iI4oq7j5NcJHRAFeEyJmzV6JO1//4hsWbHmXq+FlE7Jz2vRXSVV15w/YZv2ibpqDSJWqChyc4fx4KACvGhjLTtb+binPPpavWYwlI=
Received: from CY1PR05MB2761.namprd05.prod.outlook.com (10.167.18.19) by
 CY1PR05MB2428.namprd05.prod.outlook.com (10.167.10.9) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1750.9; Thu, 21 Mar 2019 15:06:04 +0000
Received: from CY1PR05MB2761.namprd05.prod.outlook.com
 ([fe80::50:9d56:d444:62ec]) by CY1PR05MB2761.namprd05.prod.outlook.com
 ([fe80::50:9d56:d444:62ec%4]) with mapi id 15.20.1730.013; Thu, 21 Mar 2019
 15:06:04 +0000
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     Matt Helsley <mhelsley@vmware.com>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v7 5/9] trace-cmd: Refactored few functions in
 trace-record.c
Thread-Topic: [PATCH v7 5/9] trace-cmd: Refactored few functions in
 trace-record.c
Thread-Index: AQHU3mxTAEBUeJy+d06A42BJvaYIFqYTREwAgAFNHACAAAYYgIABmsQA
Date:   Thu, 21 Mar 2019 15:06:03 +0000
Message-ID: <CACqStoev5pRXxH64auUFkfwJ4sUG0hdQ6Uz8cQ9qphZJQK-qPw@mail.gmail.com>
References: <20190319155536.19381-1-tstoyanov@vmware.com>
 <20190319155536.19381-6-tstoyanov@vmware.com>
 <0FEA60D5-2542-498E-A494-C15B0B2AE0A4@vmware.com>
 <CACqStodWOOPAi0Y36Xp5u=Ny0e+acmys=HUV4qxLB+3sqeAPBw@mail.gmail.com>
 <20190320103513.40d67e38@gandalf.local.home>
In-Reply-To: <20190320103513.40d67e38@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR02CA0012.eurprd02.prod.outlook.com
 (2603:10a6:20b:6e::25) To CY1PR05MB2761.namprd05.prod.outlook.com
 (2a01:111:e400:c63a::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tstoyanov@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: APjAAAUbxrfzLeAofnkqK7WxqMdd3WpYTm9WaOuj/Or+F4xQvvrsZqnw
        lIe7fjrLhFbOp7Nzim3aKxclXqo7xFoWAuB7Vrc=
x-google-smtp-source: APXvYqyrHqqsGPDQ2r6Sud6QmqdYPzW7c6Fh0n+enCoiVRjs09XB1ucV+we/gUO528UEdtrs1lTrLbgBaIWX0DVQKSM=
x-received: by 2002:a1c:cb0f:: with SMTP id b15mr2820074wmg.88.1553180757167;
 Thu, 21 Mar 2019 08:05:57 -0700 (PDT)
x-gmail-original-message-id: <CACqStoev5pRXxH64auUFkfwJ4sUG0hdQ6Uz8cQ9qphZJQK-qPw@mail.gmail.com>
x-originating-ip: [209.85.128.49]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 09c62a59-a7b0-48c3-e7ae-08d6ae0ebc40
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(49563074)(7193020);SRVR:CY1PR05MB2428;
x-ms-traffictypediagnostic: CY1PR05MB2428:
x-microsoft-antispam-prvs: <CY1PR05MB24285BA830A0B690D31AA8A8DC420@CY1PR05MB2428.namprd05.prod.outlook.com>
x-forefront-prvs: 0983EAD6B2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(39860400002)(396003)(376002)(346002)(199004)(189003)(43234003)(3846002)(76176011)(66066001)(186003)(8936002)(6512007)(9686003)(54906003)(6116002)(71190400001)(446003)(71200400001)(95326003)(68736007)(229853002)(316002)(6506007)(386003)(6246003)(99936001)(6436002)(25786009)(26005)(6862004)(486006)(256004)(8676002)(5660300002)(14444005)(5024004)(6486002)(61726006)(4326008)(61266001)(99286004)(53546011)(498394004)(478600001)(53936002)(11346002)(55446002)(476003)(305945005)(86362001)(105586002)(102836004)(97736004)(14454004)(81166006)(7736002)(81156014)(93886005)(106356001)(52116002)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR05MB2428;H:CY1PR05MB2761.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: BRo7wflqVmHBdINqfYLVe0rC2QTmglrVlU7T/+mf3PfJCLzb8bsn3PHHyWLvDj5eAXWVr49rc8PLjLK2o+qgYs+V8kSdBhwDyGekaqzns8Sbvqq1iOoSTZ9L5KWMmXN+DORk4jyT2DQvENQDh46LzsZzeAUGeZkKef/GSEn3dDysqy6BYNJdnwWJJnLwjT6RE2t8R9MKOthOXFWu/Rf/cbzh/vbqwpQK4Kh1+zgWxiWCWvoRl8vMyrqfpA6DBh0/E8gi3cnP7wZA0zDIaL1iQyGUVU6p7k45uMVgcZ6hqpVSopMX+odpzXfmljpeVlzaLn7wgHzWElB0qh+8toYsxFeuHH88nr78JunFhR7/VWaSjiph0ZQcCJc02Fzu2pupw54f3qS6t+R5HT+v4x1LZ5r3d8ZnTiIsLcw4uihL9DY=
Content-Type: multipart/mixed;
        boundary="_002_CACqStoev5pRXxH64auUFkfwJ4sUG0hdQ6Uz8cQ9qphZJQKqPwmailg_"
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09c62a59-a7b0-48c3-e7ae-08d6ae0ebc40
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2019 15:06:03.5833
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR05MB2428
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

--_002_CACqStoev5pRXxH64auUFkfwJ4sUG0hdQ6Uz8cQ9qphZJQKqPwmailg_
Content-Type: text/plain; charset="utf-8"
Content-ID: <6F6C60A1AF202D44BA0B6F1749877E1F@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64

T24gV2VkLCBNYXIgMjAsIDIwMTkgYXQgNDozNSBQTSBTdGV2ZW4gUm9zdGVkdCA8cm9zdGVkdEBn
b29kbWlzLm9yZz4gd3JvdGU6DQo+DQo+IE9uIFdlZCwgMjAgTWFyIDIwMTkgMTQ6MTQ6MDMgKzAw
MDANCj4gVHp2ZXRvbWlyIFN0b3lhbm92IDx0c3RveWFub3ZAdm13YXJlLmNvbT4gd3JvdGU6DQo+
DQo+ID4gPiBCdXQgdGhpcyBybWRpciBpcyBub3QgbW92ZWQgdG8gdHJhY2VjbWRfcmVtb3ZlX2lu
c3RhbmNlKCkg4oCUIGl04oCZcyBsb3N0LiBUaGlzIGxvb2tzIGxpa2UgaXTigJlzIGludHJvZHVj
aW5nIGEgYnVnLg0KPiA+DQo+ID4gVGhhbmtzIE1hdHQsIHRoaXMgb25lIGlzIGZyb20gdjEgb2Yg
dGhlIHBhdGNoc2V0LCBJIGRpZG4ndCBub3RpY2UgaXQuDQo+ID4gSSdsbCBhZGQgdGhlIHJtZGly
KCkgY2FsbCBpbiB0aGUgbmV4dCB2ZXJzaW9uLg0KPiA+IFRoZXJlIGlzIHNvbWUgZ2VuZXJhbCBw
cm9ibGVtIHdpdGggZGVsZXRpbmcgaW5zdGFuY2VzLCBvciAobW9zdA0KPiA+IHByb2JhYmx5KSBJ
IGNhbm5vdCBmaWd1cmUgb3V0IHdoYXQgaXQgdGhlIHByb3BlciB3YXkNCj4gPiB0byBkZWxldGUg
YSBmdHJhY2UgaW5zdGFuY2UgLSBldmVuIGFmdGVyIHRoZSBjYWxsIHRvIHJtZGlyKCkgaW4NCj4g
PiB0cmFjZWNtZF9yZW1vdmVfaW5zdGFuY2UoKSwgdGhlIGluc3RhbmNlIGRpciBpcyBzdGlsbCB0
aGVyZS4NCj4gPiBJIHRyaWVkIHRvIHJ1biAicm0gLXJmIHBhdGhfdG9faW5zdGFuY2VfZGlyIiBm
cm9tIHRoZSBzaGVsbCAoYXQgcm9vdCksDQo+ID4gYWZ0ZXIgdGhlIHRyYWNlLWNtZCBpcyBleGVj
dXRlZCwgZ290IGEgbG90IG9mDQo+ID4gIk9wZXJhdGlvbiBub3QgcGVybWl0dGVkIiBlcnJvcnMg
YW5kIHRoZSBpbnN0YW5jZSBkaXIgaXMgbm90IGRlbGV0ZWQuDQo+DQo+IE1ha2Ugc3VyZSB5b3Ug
cmVzZXQgdGhlIGluc3RhbmNlIGJlZm9yZSB0cnlpbmcgdG8gcmVtb3ZlIGl0LiBUaGVyZSdzDQo+
IHNvbWUgb3BlcmF0aW9ucyB0aGF0IGNhbiBiZSBzdGFydGVkIHRoYXQgd29udCBsZXQgeW91IHJl
bW92ZSB0aGUNCj4gaW5zdGFuY2UgdW50aWwgdGhleSBhcmUgY2xlYW5lZCB1cC4NCj4NCj4gQnV0
IGlmIHlvdSBhcmUgc3RpbGwgaGF2aW5nIGlzc3VlcyB3aXRoIHRoYXQsIGxldCBtZSBrbm93LiBJ
dCBjb3VsZCBiZQ0KPiBhIGJ1ZyBpbiB0aGUgaW5zdGFuY2UgcmVtb3ZhbCBjb2RlIGluIHRoZSBr
ZXJuZWwuDQoNCkkgc3RpbGwgZ2V0IHRoZSBpc3N1ZSwgY2hlY2tlZCB0aGF0IHRoZSBpbnN0YW5j
ZSBpcyBzZXQgd2l0aCBkZWZhdWx0IHZhbHVlcy4NCkF0dGFjaGVkIGlzIGEgc2ltcGxlIHNjcmlw
dCwgd2hpY2ggZG9lcyB0aGUgc2FtZSAtIGp1c3QgcnVuIGl0IGFzIHJvb3QNCg0KPg0KPiAtLSBT
dGV2ZQ0KDQoNCi0tIA0KDQpUenZldG9taXIgKENlY28pIFN0b3lhbm92DQpWTXdhcmUgT3BlbiBT
b3VyY2UgVGVjaG5vbG9neSBDZW50ZXINCg==

--_002_CACqStoev5pRXxH64auUFkfwJ4sUG0hdQ6Uz8cQ9qphZJQKqPwmailg_
Content-Type: application/x-shellscript; name="finstance.sh"
Content-Description: finstance.sh
Content-Disposition: attachment; filename="finstance.sh"; size=961;
	creation-date="Thu, 21 Mar 2019 15:06:03 GMT";
	modification-date="Thu, 21 Mar 2019 15:06:03 GMT"
Content-ID: <f_jtiropfc0>
Content-Transfer-Encoding: base64

IyEvYmluL2Jhc2gKCklOU1RfTkFNRT12dGVzdApUUkFDRV9JTlNUX0RJUj0vc3lzL2tlcm5lbC9k
ZWJ1Zy90cmFjaW5nL2luc3RhbmNlcwoKbWtkaXIgJFRSQUNFX0lOU1RfRElSLyRJTlNUX05BTUUK
CmVjaG8gInZteF9yZWFkX2wxX3RzY19vZmZzZXQiID4gJFRSQUNFX0lOU1RfRElSLyRJTlNUX05B
TUUvc2V0X2Z0cmFjZV9maWx0ZXIKZWNobyAiZnVuY3Rpb24iID4gJFRSQUNFX0lOU1RfRElSLyRJ
TlNUX05BTUUvY3VycmVudF90cmFjZXIKZWNobyAiMSIgPiAkVFJBQ0VfSU5TVF9ESVIvJElOU1Rf
TkFNRS9ldmVudHMvdnNvY2svdmlydGlvX3RyYW5zcG9ydF9yZWN2X3BrdC9lbmFibGUKZWNobyAi
bGVuIT0wIiA+ICRUUkFDRV9JTlNUX0RJUi8kSU5TVF9OQU1FL2V2ZW50cy92c29jay92aXJ0aW9f
dHJhbnNwb3J0X3JlY3ZfcGt0L2ZpbHRlcgplY2hvICJtb25vX3JhdyIgPiAkVFJBQ0VfSU5TVF9E
SVIvJElOU1RfTkFNRS90cmFjZV9jbG9jawplY2hvICIxIiA+ICRUUkFDRV9JTlNUX0RJUi8kSU5T
VF9OQU1FL3RyYWNpbmdfb24KCnNsZWVwIDIKCmVjaG8gIjAiID4gJFRSQUNFX0lOU1RfRElSLyRJ
TlNUX05BTUUvdHJhY2luZ19vbgplY2hvICIiID4gJFRSQUNFX0lOU1RfRElSLyRJTlNUX05BTUUv
c2V0X2Z0cmFjZV9maWx0ZXIKZWNobyAibm9wIiA+ICRUUkFDRV9JTlNUX0RJUi8kSU5TVF9OQU1F
L2N1cnJlbnRfdHJhY2VyCmVjaG8gIjAiID4gJFRSQUNFX0lOU1RfRElSLyRJTlNUX05BTUUvZXZl
bnRzL3Zzb2NrL3ZpcnRpb190cmFuc3BvcnRfcmVjdl9wa3QvZW5hYmxlCmVjaG8gJzAnID4gJFRS
QUNFX0lOU1RfRElSLyRJTlNUX05BTUUvZXZlbnRzL3Zzb2NrL3ZpcnRpb190cmFuc3BvcnRfcmVj
dl9wa3QvZmlsdGVyCmVjaG8gImxvY2FsIiA+ICRUUkFDRV9JTlNUX0RJUi8kSU5TVF9OQU1FL3Ry
YWNlX2Nsb2NrCgpybSAtcmYgJFRSQUNFX0lOU1RfRElSLyRJTlNUX05BTUUKCgoKCg==

--_002_CACqStoev5pRXxH64auUFkfwJ4sUG0hdQ6Uz8cQ9qphZJQKqPwmailg_--
