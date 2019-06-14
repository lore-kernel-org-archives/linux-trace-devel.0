Return-Path: <SRS0=/4Dl=UN=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D819FC31E4B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 Jun 2019 13:26:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9AA5821473
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 Jun 2019 13:26:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="lWdh2KD4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728176AbfFNN0t (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 14 Jun 2019 09:26:49 -0400
Received: from mail-eopbgr730084.outbound.protection.outlook.com ([40.107.73.84]:25120
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727673AbfFNN0s (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 Jun 2019 09:26:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IT/q0c1S9LKi0i1okIhHvH2WGGTjIMH7lGgyou2Cs9A=;
 b=lWdh2KD4EouKbGlhjgOxVLM22MO31KaCBUNmUE306BOcivo6k5c0f/Nfg3D6OqlqYRiFydm3xf1SofRRvpbD1ejGg6xdbtBkCgcw8/N33TaHJBjLocrB2bJ0OvjR8dTi+ycqDkDQXJtPq6tvejLS76Ik8Da58dajT/Pyv9pveak=
Received: from SN4PR0501MB3903.namprd05.prod.outlook.com (10.167.142.151) by
 SN4PR0501MB3918.namprd05.prod.outlook.com (10.167.142.158) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.9; Fri, 14 Jun 2019 13:26:46 +0000
Received: from SN4PR0501MB3903.namprd05.prod.outlook.com
 ([fe80::d0ff:f109:af39:2c9c]) by SN4PR0501MB3903.namprd05.prod.outlook.com
 ([fe80::d0ff:f109:af39:2c9c%5]) with mapi id 15.20.1987.010; Fri, 14 Jun 2019
 13:26:46 +0000
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     "rostedt@goodmis.org" <rostedt@goodmis.org>
CC:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>,
        "y.karadz@gmail.com" <y.karadz@gmail.com>,
        "troyengel@gmail.com" <troyengel@gmail.com>,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH v2 0/3] KernelShark build fixes for v1.0
Thread-Topic: [PATCH v2 0/3] KernelShark build fixes for v1.0
Thread-Index: AQHVIrTQCxeSM9s1tE+ks4aJyPlkBg==
Date:   Fri, 14 Jun 2019 13:26:46 +0000
Message-ID: <20190614132609.16465-1-ykaradzhov@vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: DB8P191CA0020.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:10:130::30) To SN4PR0501MB3903.namprd05.prod.outlook.com
 (2603:10b6:803:4d::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ykaradzhov@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.20.1
x-originating-ip: [146.247.46.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0b649655-586d-41dc-376b-08d6f0cbf285
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:SN4PR0501MB3918;
x-ms-traffictypediagnostic: SN4PR0501MB3918:
x-microsoft-antispam-prvs: <SN4PR0501MB3918CB4DE0972F9187A0FCBDA0EE0@SN4PR0501MB3918.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0068C7E410
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(376002)(39860400002)(136003)(366004)(199004)(189003)(1076003)(66066001)(486006)(2501003)(4744005)(2616005)(476003)(3846002)(6116002)(68736007)(256004)(99286004)(6916009)(66476007)(86362001)(66556008)(478600001)(64756008)(66446008)(73956011)(26005)(305945005)(66946007)(7736002)(14454004)(5660300002)(102836004)(386003)(6506007)(52116002)(71190400001)(107886003)(36756003)(8936002)(8676002)(4326008)(71200400001)(2906002)(53936002)(25786009)(1730700003)(5640700003)(186003)(316002)(2351001)(50226002)(81166006)(6512007)(6436002)(54906003)(6486002)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:SN4PR0501MB3918;H:SN4PR0501MB3903.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 2uCAiuNgZRiQouFCqiL/5tgbvQBWSJpxQoQm9a5pJ77bxpJssC2MueDaYgBrqkVosjv4g7XA7M1PfNgYvxIluUnceVRVLtflhCeivzfj/doC0fGOxoef4bL+H2GzYC7L6oMAxfqL52Da4o35x40dk7SI1FtSYsyjoLLDYbKteRlCA6mDLh2oZM+c5ig7MUCU3bjTp1IqKWclndk/phPNTNIPEfwP3422xLzr4QRspF2H/6y+dZpZSwfXWUFr2sRJwOGnnQH3mUVMuJaGCQt4ZtVcJHBu8BXeN08p+rmBHErDCfZrYzvEw49UggMMsl9CaB7DGmMt7fMYgNe0GPND+C8GD8ixbGhrFguvv7D58+y+AQ757WlfSqdb3MzID+6m1t/zvbZZUjJkTX14wxmAwPQfODQ1He80K2cIJeZHgMI=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <79CA904EDD63394090BDB7842F1164C9@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b649655-586d-41dc-376b-08d6f0cbf285
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2019 13:26:46.2964
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ykaradzhov@vmware.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0501MB3918
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Patches addressing the problem of having the paths to the build
directory embedded in the final binaries. The problem was reported
by Troy Engel.

Changes in v2:
 - In FindTraceCmd.cmake : discovering the trace-cmd executable is now
 a compulsory requirement.
 - A new buld type called "Package" has been defined.

Yordan Karadzhov (3):
  kernel-shark: Remove the "-g" compiler flag.
  kernel-shark: Avoid TRACECMD_BIN_DIR being set to the build path
  kernel-shark: Define a CMAKE_BUILD_TYPE "Package"

 kernel-shark/CMakeLists.txt           | 45 ++++++++++++++++++---------
 kernel-shark/README                   | 22 +++++++++----
 kernel-shark/build/FindTraceCmd.cmake | 18 ++++++-----
 kernel-shark/build/deff.h.cmake       |  2 +-
 kernel-shark/src/KsCaptureDialog.cpp  |  7 ++---
 5 files changed, 61 insertions(+), 33 deletions(-)

--=20
2.20.1

