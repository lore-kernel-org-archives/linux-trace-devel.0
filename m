Return-Path: <SRS0=3M/k=RA=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20CDAC43381
	for <linux-trace-devel@archiver.kernel.org>; Mon, 25 Feb 2019 15:38:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D16A020663
	for <linux-trace-devel@archiver.kernel.org>; Mon, 25 Feb 2019 15:38:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="on1jXs6H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727629AbfBYPiH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 25 Feb 2019 10:38:07 -0500
Received: from mail-eopbgr690056.outbound.protection.outlook.com ([40.107.69.56]:38240
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727505AbfBYPiH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 25 Feb 2019 10:38:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u8/HpYXKeKMVAylVxAYVJajDsaekxFmtYgULJlZ8U8c=;
 b=on1jXs6Hkhs40QnDC7oAyAgAqmDXAgcPtdR4el13+Cwbr1ev4xheLlGBUSIXZttCwmL0BYVBb2EEUk6tL8mMrFNSxx+OopnKJKljFeH7hiGA3D1/KaL1X16Jc3sHbPLLIY24KqLuVfqyuFs3ZaMgMwJjoSQQSOViEpbH4K9ecjU=
Received: from CY1PR05MB2761.namprd05.prod.outlook.com (10.167.18.19) by
 CY1PR05MB2668.namprd05.prod.outlook.com (10.167.11.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1665.13; Mon, 25 Feb 2019 15:37:58 +0000
Received: from CY1PR05MB2761.namprd05.prod.outlook.com
 ([fe80::50:9d56:d444:62ec]) by CY1PR05MB2761.namprd05.prod.outlook.com
 ([fe80::50:9d56:d444:62ec%4]) with mapi id 15.20.1665.012; Mon, 25 Feb 2019
 15:37:58 +0000
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     Steven Rostedt <rostedt@goodmis.org>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Multiple time offsets in trace.dat file
Thread-Topic: Multiple time offsets in trace.dat file
Thread-Index: AQHUzSAVMMysikmaW0mhm5HAioNw+A==
Date:   Mon, 25 Feb 2019 15:37:58 +0000
Message-ID: <CACqStoeckAbvXp9ZzVBro1zzzQzi6C9ub9Hv_GtCZNmZ3skxTw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR04CA0031.eurprd04.prod.outlook.com
 (2603:10a6:20b:92::44) To CY1PR05MB2761.namprd05.prod.outlook.com
 (2a01:111:e400:c63a::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tstoyanov@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: AHQUAuaiyW8P2H8yzeRXBiDapLAatzQKbxRMSeB/iBGv9SukNXXmb9qU
        cYAqlkxcZyBU0wRFbEaOuvVCQbF9vS533X/zF6U=
x-google-smtp-source: AHgI3IbiPdQ3eUMLUW61gZ3LfOMb0g0gm7m8Xh5V34pBwbk4wcrhW1oz/e9ZKQHme68JwAtV0MxsMN8Hj8YmOM12Xd0=
x-received: by 2002:adf:9d85:: with SMTP id p5mr12906463wre.215.1551109071380;
 Mon, 25 Feb 2019 07:37:51 -0800 (PST)
x-gmail-original-message-id: <CACqStoeckAbvXp9ZzVBro1zzzQzi6C9ub9Hv_GtCZNmZ3skxTw@mail.gmail.com>
x-originating-ip: [209.85.221.51]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0d82e055-4e6e-44cc-9bc4-08d69b3737b8
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600110)(711020)(4605104)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:CY1PR05MB2668;
x-ms-traffictypediagnostic: CY1PR05MB2668:
x-microsoft-exchange-diagnostics: 1;CY1PR05MB2668;20:p9UMaXV+LHcO2tpb/7T623yMJzL3o3LJ4fYYKo+N7pNNn1nMNWxzjmQdVugcObn/Hirw5FRjTxa4V9HQVusQtlLKbXIIo/g/XQ8AVQhQ72ymavl1z1kcg/VyVhl6kTXxuDs5fgiSC+RomRufILJppYWhEMQ87NZNXAEAx5+sME8=
x-microsoft-antispam-prvs: <CY1PR05MB26687D887C31D97E536C52A0DC7A0@CY1PR05MB2668.namprd05.prod.outlook.com>
x-forefront-prvs: 095972DF2F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(376002)(366004)(346002)(39860400002)(396003)(189003)(199004)(8936002)(95326003)(81156014)(81166006)(498394004)(8676002)(14444005)(256004)(26005)(305945005)(476003)(2906002)(99286004)(53936002)(61726006)(6436002)(6486002)(2501003)(316002)(9686003)(6512007)(110136005)(68736007)(71190400001)(386003)(102836004)(71200400001)(52116002)(5660300002)(86362001)(105586002)(106356001)(14454004)(55446002)(486006)(7736002)(25786009)(97736004)(61266001)(6116002)(3846002)(66066001)(478600001)(6506007)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR05MB2668;H:CY1PR05MB2761.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: nKPHgjG1uY6qgSWvw0UbkrGba96OS8pgPDEtCcMYz1AxD6gok2grc2cdtmb32H0kfUlvmhMCplTb9iGBqIiP05+QK0znDUDqClg+QvoS+0TsO9JEsuUWp2Af3uPMAiCznwi++WcbMz6zgMiX7bUodRvCblri3qzYFx72MPYbbm4DfE12LdzcMWEqqBAGDp9/8IR+sSn5J446wvxqoV5nKupqFCW8Do28BIjnvcTltTHI9x5PX+SytYzrhhsbfwK+mcaN7VvbXJSeFC4HSm7JUsMK5sR+EQwqvLDY564FkuLknuJJDe1kNA2nYnYUv8ZspQJB44eWrkgiZxtj4J9KRIXhaPiyBB6rfdcE83LglHDjeL39syQZ4dzUJGs9leNij74YDSAkd9BkdShbqrvy96hlKFEnia9ET4OFVnCn8oM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3D84BA6709657F4C9FFEB7EFE5285A18@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d82e055-4e6e-44cc-9bc4-08d69b3737b8
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2019 15:37:58.3348
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR05MB2668
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

SGkgU3RldmVuLA0KV2hlbiB0cmFjaW5nIGhvc3QgYW5kIGd1ZXN0IG1hY2hpbmVzLCBpbiBvcmRl
ciB0byBvdmVyY29tZSB0aGUgZHJpZnQNCmJldHdlZW4gdGhlIHRpbWVzIGluIGJvdGggY29udGV4
dHMsIHdlIG5lZWQgdG8gdXNlIG11bHRpcGxlIChhdCBsZWFzdA0KMikgdGltZSBvZmZzZXRzLiBJ
biBhZGRpdGlvbiwgd2UgbmVlZCB0aGUgbG9jYWwgdGltZSBzdGFtcCwgcmVsYXRlZCB0bw0KZWFj
aCBvZmZzZXQ6DQogICh0c19vZmZzZXQxLCB0c19sb2NhbDEpLCAodHNfb2Zmc2V0MiwgdHNfbG9j
YWwyKSwgLi4uLg0KIHdoZXJlIHRzX2xvY2FsMSBpcyB0aGUgdGltZSB3aGVuIHRoZSBvZmZzZXQg
dHNfb2Zmc2V0MSB3YXMgbWVhc3VyZWQuDQpUaGlzIGluZm9ybWF0aW9uIHNob3VsZCBiZSBzdG9y
ZWQgc29tZWhvdyBpbiB0cmFjZS5kYXQgZmlsZSwgd2hpY2gNCmN1cnJlbnRseSBzdXBwb3J0cyBv
bmx5IG9uZSBUUkFDRUNNRF9PUFRJT05fT0ZGU0VUIG9wdGlvbi4NClRoZXJlIGFyZSB0d28gcG9z
c2libGUgYXBwcm9hY2hlcyB0byBkbyBpdCwgcGxlYXNlIHN1Z2dlc3Qgd2hpY2ggb25lIHRvIGNo
b29zZToNCg0KIDEuIFVzZSB0aGUgZXhpc3RpbmcgVFJBQ0VDTURfT1BUSU9OX09GRlNFVCwgd3Jp
dHRlbiAyIHRpbWVzIGluIHRoZQ0KdHJhY2UuZGF0IGZpbGUuIEV4dHJhY3QgdGhlIHRzX2xvY2Fs
MSBhbmQgdHNfbG9jYWwyIHRpbWVzIGZyb20gdGhlDQpmaWxlLCBhcyB0c19sb2NhbDEgaXMgdGhl
IHRpbWUgb2YgdGhlIGZpcnN0IGV2ZW50IGFuZCB0c19sb2NhbDIgaXMgdGhlDQp0aW1lIG9mIHRo
ZSBsYXN0IGV2ZW50LiBUaGVyZSBhcmUgZmV3ICBjb25zIG9mIHRoaXMgYXBwcm9hY2g6DQogICAg
ICAgIC0gd2UgY2FuIHVzZSBvbmx5IDIgb2Zmc2V0cywgYmVmb3JlIGFuZCBhZnRlciB0aGUgdHJh
Y2UuDQogICAgICAgIC0gbWFwcGluZyB0c19sb2NhbDEgYW5kIHRzX2xvY2FsMiB0byB0aGUgdGlt
ZXMgb2YgdGhlIGZpcnN0DQphbmQgbGFzdCBldmVudCBpcyBub3QgYWNjdXJhdGUsIGFzIHRoZXNl
IGFyZSBub3QgdGhlIGFjdHVhbCB0aW1lcyB3aGVuDQp0aGUgdGltZSBzdGFtcHMgd2VyZSBjYWxj
dWxhdGVkLg0KICAgICAgICAgLSBGaW5kaW5nIGZpcnN0IGFuZCBsYXN0IGV2ZW50IGZyb20gdGhl
IHRyYWNlLmRhdCBmaWxlIHdpbGwNCnJlcXVpcmUgb25lIGV4dHJhIHBhcnNpbmcgb2YgdGhlIHdo
b2xlIGZpbGUsIGFzIHRoZSBldmVudHMgdGhlcmUgYXJlDQpub3Qgc29ydGVkLg0KDQogMi4gSW50
cm9kdWNlIGEgbmV3IFRSQUNFQ01EX09QVElPTl8gb3B0aW9uLCB3aGljaCB3aWxsIGhvbGQgYWxs
DQp0c19vZmZzZXRzIHRvZ2V0aGVyIHdpdGggdHNfbG9jYWwgdGltZXMuDQoNCi0tIA0KVHp2ZXRv
bWlyIChDZWNvKSBTdG95YW5vdg0KVk13YXJlIE9wZW4gU291cmNlIFRlY2hub2xvZ3kgQ2VudGVy
DQo=
