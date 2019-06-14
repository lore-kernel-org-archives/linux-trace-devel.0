Return-Path: <SRS0=/4Dl=UN=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23F5DC46477
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 Jun 2019 13:51:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED43D20850
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 Jun 2019 13:51:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="SLhJu9D4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728667AbfFNNvR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 14 Jun 2019 09:51:17 -0400
Received: from mail-eopbgr770045.outbound.protection.outlook.com ([40.107.77.45]:53611
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727922AbfFNNvR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 Jun 2019 09:51:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AJ6Tvpynly1mZBAlk8QP1UNX11JZGJdljNQwoH9IGQA=;
 b=SLhJu9D4OsH0KhaRWqkJhctTy86TAmjAbMpZp6NXgrM5eB339q2kMMXpwtvVJhKECL2NBcYINY/R8rYmKHN2V83jr8wO9KAevQaPsSqK1Af7sIPfRsP8Bn3qDS57Kk7K/fQEQWwrXbqFGEtRsdD58MNMMvvXyksbLA55ayOBVx0=
Received: from SN4PR0501MB3903.namprd05.prod.outlook.com (10.167.142.151) by
 SN4PR0501MB3776.namprd05.prod.outlook.com (10.167.141.148) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.10; Fri, 14 Jun 2019 13:51:15 +0000
Received: from SN4PR0501MB3903.namprd05.prod.outlook.com
 ([fe80::d0ff:f109:af39:2c9c]) by SN4PR0501MB3903.namprd05.prod.outlook.com
 ([fe80::d0ff:f109:af39:2c9c%5]) with mapi id 15.20.1987.010; Fri, 14 Jun 2019
 13:51:15 +0000
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     "rostedt@goodmis.org" <rostedt@goodmis.org>
CC:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH v2 0/3] Fixes needed befor KS 1.0
Thread-Topic: [PATCH v2 0/3] Fixes needed befor KS 1.0
Thread-Index: AQHVIrg71YDb1vbpok6HBhTlxLk1Cg==
Date:   Fri, 14 Jun 2019 13:51:15 +0000
Message-ID: <20190614135045.17223-1-ykaradzhov@vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: DB6P190CA0012.EURP190.PROD.OUTLOOK.COM (2603:10a6:6:2f::25)
 To SN4PR0501MB3903.namprd05.prod.outlook.com (2603:10b6:803:4d::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ykaradzhov@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.20.1
x-originating-ip: [146.247.46.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ac9e107b-f8dd-407e-476b-08d6f0cf5e10
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:SN4PR0501MB3776;
x-ms-traffictypediagnostic: SN4PR0501MB3776:
x-microsoft-antispam-prvs: <SN4PR0501MB37761BDDFBA58124925737E8A0EE0@SN4PR0501MB3776.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0068C7E410
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(346002)(136003)(366004)(396003)(199004)(189003)(26005)(478600001)(186003)(25786009)(386003)(6506007)(305945005)(53936002)(52116002)(102836004)(73956011)(50226002)(66066001)(66946007)(6486002)(6436002)(68736007)(81166006)(107886003)(14454004)(1730700003)(66476007)(66556008)(81156014)(2351001)(8676002)(2906002)(64756008)(6512007)(66446008)(8936002)(36756003)(4326008)(5640700003)(54906003)(2616005)(476003)(486006)(5660300002)(1076003)(71200400001)(7736002)(71190400001)(316002)(6116002)(99286004)(3846002)(86362001)(2501003)(256004)(14444005)(4744005)(6916009);DIR:OUT;SFP:1101;SCL:1;SRVR:SN4PR0501MB3776;H:SN4PR0501MB3903.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: k1M/Uu1uFQmwlX9XD6UkSMCyDB41/auwgCJzFqz9FqQnYHFt8aip+Q1Mq1JPLDJNZ556T4FTRiHUVaE3NTq9c38Ig2p60ZAGPQLVPL8ri8YnKb6D+D7vP40Sq2XnGwRUNp4Jx8YgzuE0pFxdJ8V6TalTCnjN7hwbQL8HJ+BE+mWHdr799Yr9oMkOLMj2CNGIKUiKK3mTOJPzDOZdXWzIjOH5fnBL4Tzxu3pVnzPYbZ7nkAVpiQuu0Ed21ZHmowjJ65wVGlTIf3btb/zRAvSK4erQ+cZwyfUs+bZk9BKZdw9Jc8KH16K/DTDPl/OXZAw+mx0r8t6qslPT/3gEN2CIb/lsw5s6S4yMvecfAbFfFXrbegB9JANzVQl5Lmn0fDeEttSpkopFGAyPfkZg0sIKCjbXyRwMimXpfkr80cgK4WE=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <75EA7A49824FA843A31939A1BEB4BF76@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac9e107b-f8dd-407e-476b-08d6f0cf5e10
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2019 13:51:15.1072
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ykaradzhov@vmware.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0501MB3776
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The important one is the one fixing the visualization model
aborting on 32 bit system [PATCH 2].

Changes in v2:
 - [PATCH 2] includes a fix for void ksmodel_jump_to()
 - [PATCH 3] is new.=20

Yordan Karadzhov (3):
  kernel-shark: Fix a bug when plotting the last trace record
  kernel-shark: Always use 64 bit variables for timestamps.
  kernel-shark: Fix all warnings when building on 32 bit systems

 kernel-shark/examples/datahisto.c  |  4 ++--
 kernel-shark/src/KsTraceGraph.cpp  | 10 +++++-----
 kernel-shark/src/libkshark-model.c | 27 +++++++++++++++++++--------
 kernel-shark/src/libkshark-model.h |  2 +-
 kernel-shark/src/libkshark.c       |  4 ++--
 5 files changed, 29 insertions(+), 18 deletions(-)

--=20
2.20.1

