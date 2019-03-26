Return-Path: <SRS0=md0U=R5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81356C43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Mar 2019 14:27:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4CA9F20857
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Mar 2019 14:27:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="QVBWp/QR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731595AbfCZO1c (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 26 Mar 2019 10:27:32 -0400
Received: from mail-eopbgr720063.outbound.protection.outlook.com ([40.107.72.63]:6512
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726111AbfCZO1c (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 26 Mar 2019 10:27:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2DJw9VVwSFRiTeeWjn6R1nQOlaDC2n83g3bbsYWuyaI=;
 b=QVBWp/QRtfE9or1FptNfhEgZW/4v5AE68w+pbEpISjLPiGo9e00tVuka1Mqi+Pob8ZasAXYSULrS8SPxFznR8U5kMCNddBsCwVlni+FXpTtwhdgWU3NxFr7NPOm1uuXStfBx+308Qn6MHdAOD81qzs6t3GU4ZfRJozdC/JAh0xA=
Received: from CY1PR05MB2780.namprd05.prod.outlook.com (10.167.18.26) by
 CY1PR05MB2700.namprd05.prod.outlook.com (10.167.17.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1750.14; Tue, 26 Mar 2019 14:27:30 +0000
Received: from CY1PR05MB2780.namprd05.prod.outlook.com
 ([fe80::4db6:3e20:4b0e:4416]) by CY1PR05MB2780.namprd05.prod.outlook.com
 ([fe80::4db6:3e20:4b0e:4416%10]) with mapi id 15.20.1750.014; Tue, 26 Mar
 2019 14:27:30 +0000
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>
CC:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v9 0/9]  trace-cmd: Timetamps sync between host and guest
 machines, relying on vsock events.
Thread-Topic: [PATCH v9 0/9]  trace-cmd: Timetamps sync between host and guest
 machines, relying on vsock events.
Thread-Index: AQHU4+ALC0EbJVYUuUSiP5mQZNBKOQ==
Date:   Tue, 26 Mar 2019 14:27:30 +0000
Message-ID: <4165dc2fea8a6056e499f3dad92dd761833afb21.camel@vmware.com>
References: <20190325142439.22032-1-tstoyanov@vmware.com>
In-Reply-To: <20190325142439.22032-1-tstoyanov@vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [146.247.46.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 99da28b4-a3ed-49d2-1eaf-08d6b1f72e16
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600127)(711020)(4605104)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:CY1PR05MB2700;
x-ms-traffictypediagnostic: CY1PR05MB2700:
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kaslevs@vmware.com; 
x-microsoft-antispam-prvs: <CY1PR05MB27000B721A5B92FD0243A8E6DA5F0@CY1PR05MB2700.namprd05.prod.outlook.com>
x-forefront-prvs: 09888BC01D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(39860400002)(136003)(346002)(376002)(189003)(199004)(8936002)(81156014)(2906002)(186003)(102836004)(26005)(97736004)(7736002)(68736007)(14454004)(5660300002)(256004)(305945005)(6506007)(14444005)(76176011)(3846002)(6116002)(25786009)(105586002)(6246003)(6436002)(66066001)(36756003)(2501003)(53936002)(2616005)(8676002)(478600001)(99286004)(446003)(11346002)(110136005)(118296001)(86362001)(229853002)(476003)(6512007)(106356001)(6486002)(4326008)(71200400001)(71190400001)(486006)(316002)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR05MB2700;H:CY1PR05MB2780.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: OCEGub3ObjGpu7dPwHBoMTqO7qQEE/KpxCqFRA6USKI6bZVOhzDuFqklxR5tiEANeYC6PGN/zGCfdxeWDVCZ2EBDMHrdZxlPYID4z1fHzebRo6nFq8g4vUqdsfW9w1y4IpAoU8NDxCPkK/TAf0HXOO6YRIcCSN7aXKdvpWRMKpK+9caGy2/gEUjNq1mL81FdNvpYbItsfxwbVduWgxmJM8+bK/zSpiTnARIt2DqReTxSAJxHfm2d4xOu0FgpN1ZBoyOUZZrVDLK9mz/8rlxpQKb2Ldp02xe853PV2L9HtWosKr6KhtsXEILOSa/6DCKEVSLsLp7OGOOwGsxs78NDNa417jMTAKA38VxeL+ufTMTQyIEqLiZdDvFEpCBZaIJiNz/bqu7sgyrT+41WoZd0rMfbfcm9S+fULP1hQS03uls=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DD6B3FF02CBF8948BC491FD821D2F4E9@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99da28b4-a3ed-49d2-1eaf-08d6b1f72e16
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2019 14:27:30.6582
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR05MB2700
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

SSdtIGhhdmluZyBpc3N1ZXMgYnVpbGRpbmcgdGhpcy4gRG9lcyBpdCBkZXBlbmQgb24gc29tZSBv
dGhlciBzZXJpZXMNCnRoYXQgaGF2ZW4ndCBtYWRlIGl0IHRvIG1hc3RlciB5ZXQ/DQoNCkFsc28g
dGhlIHdhcm5pbmdzIG5lZWQgdG8gYmUgZml4ZWQgdG9vLg0KDQp0cmFjZS1pbnB1dC5jOiBJbiBm
dW5jdGlvbiDigJh0aW1lc3RhbXBfY29ycmVjdOKAmToNCnRyYWNlLWlucHV0LmM6MTA5NDo5OiB3
YXJuaW5nOiBpbXBsaWNpdCBkZWNsYXJhdGlvbiBvZiBmdW5jdGlvbiDigJhu4oCZIFstDQpXaW1w
bGljaXQtZnVuY3Rpb24tZGVjbGFyYXRpb25dDQogIHJldHVybiBuKHRzLCAmaGFuZGxlLT50c19z
YW1wbGVzW21pZF0sDQogICAgICAgICBeDQp0cmFjZS1vdXRwdXQuYzogSW4gZnVuY3Rpb24g4oCY
dHJhY2VjbWRfYWRkX29wdGlvbuKAmToNCnRyYWNlLW91dHB1dC5jOjk2MzoxNjogd2FybmluZzog
YXNzaWdubWVudCBkaXNjYXJkcyDigJhjb25zdOKAmSBxdWFsaWZpZXINCmZyb20gcG9pbnRlciB0
YXJnZXQgdHlwZSBbLVdkaXNjYXJkZWQtcXVhbGlmaWVyc10NCiAgdmVjdC5pb3ZfYmFzZSA9IGRh
dGE7DQogICAgICAgICAgICAgICAgXg0KdHJhY2UtdGltZXN5bmMuYzogSW4gZnVuY3Rpb24g4oCY
Z2V0X2V2ZW50c19pbl9wYWdl4oCZOg0KdHJhY2UtdGltZXN5bmMuYzoxODQ6MTE6IHdhcm5pbmc6
IGltcGxpY2l0IGRlY2xhcmF0aW9uIG9mIGZ1bmN0aW9uDQrigJh0ZXBfZGF0YV9ldmVudF9mcm9t
X3R5cGXigJk7IGRpZCB5b3UgbWVhbiDigJh0ZXBfZGF0YV9waWRfZnJvbV9jb21t4oCZPyBbLQ0K
V2ltcGxpY2l0LWZ1bmN0aW9uLWRlY2xhcmF0aW9uXQ0KICAgZXZlbnQgPSB0ZXBfZGF0YV9ldmVu
dF9mcm9tX3R5cGUodGVwLCBpZCk7DQogICAgICAgICAgIF5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+
fg0KICAgICAgICAgICB0ZXBfZGF0YV9waWRfZnJvbV9jb21tDQp0cmFjZS10aW1lc3luYy5jOjE4
NDo5OiB3YXJuaW5nOiBhc3NpZ25tZW50IHRvIOKAmHN0cnVjdCB0ZXBfZXZlbnQgKuKAmQ0KZnJv
bSDigJhpbnTigJkgbWFrZXMgcG9pbnRlciBmcm9tIGludGVnZXIgd2l0aG91dCBhIGNhc3QgWy1X
aW50LWNvbnZlcnNpb25dDQogICBldmVudCA9IHRlcF9kYXRhX2V2ZW50X2Zyb21fdHlwZSh0ZXAs
IGlkKTsNCiAgICAgICAgIF4NCg0KL3Vzci9iaW4vbGQ6IC9ob21lL2thc2xldnMvc3JjL3RjLWdo
L3RyYWNlY21kL3RyYWNlLXRpbWVzeW5jLm86IGluDQpmdW5jdGlvbiBgZ2V0X2V2ZW50c19pbl9w
YWdlJzoNCi9ob21lL2thc2xldnMvc3JjL3RjLWdoL3RyYWNlY21kL3RyYWNlLXRpbWVzeW5jLmM6
MTg0OiB1bmRlZmluZWQNCnJlZmVyZW5jZSB0byBgdGVwX2RhdGFfZXZlbnRfZnJvbV90eXBlJw0K
L3Vzci9iaW4vbGQ6IC9ob21lL2thc2xldnMvc3JjL3RjLWdoL2xpYi90cmFjZS1jbWQvbGlidHJh
Y2VjbWQuYSh0cmFjZS0NCmlucHV0Lm8pOiBpbiBmdW5jdGlvbiBgdGltZXN0YW1wX2NvcnJlY3Qn
Og0KL2hvbWUva2FzbGV2cy9zcmMvdGMtZ2gvbGliL3RyYWNlLWNtZC90cmFjZS1pbnB1dC5jOjEw
OTQ6IHVuZGVmaW5lZA0KcmVmZXJlbmNlIHRvIGBuJw0KY29sbGVjdDI6IGVycm9yOiBsZCByZXR1
cm5lZCAxIGV4aXQgc3RhdHVzDQptYWtlWzFdOiAqKiogW01ha2VmaWxlOjY2OiAvaG9tZS9rYXNs
ZXZzL3NyYy90Yy1naC90cmFjZWNtZC90cmFjZS1jbWRdDQpFcnJvciAxDQoNCkNoZWVycywNCg0K
LS0gU2xhdmkNCg==
