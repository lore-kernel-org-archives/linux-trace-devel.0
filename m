Return-Path: <SRS0=/4Dl=UN=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9FAFC31E4B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 Jun 2019 13:26:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7ECEA21473
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 Jun 2019 13:26:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="KgNGPjoM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728182AbfFNN06 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 14 Jun 2019 09:26:58 -0400
Received: from mail-eopbgr730062.outbound.protection.outlook.com ([40.107.73.62]:38304
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727673AbfFNN06 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 Jun 2019 09:26:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9NKO1M0QfZ6YfBJ06cgZY6k1acSuYqYgGxoH09WqqZk=;
 b=KgNGPjoMQSd8uvdQ1LteaiPZ0TYi52lFsh/XqDlclMQ+pT2pB6FFip05zxHJDKSImbcc8RYHOclwN6GAYI1FBf0cteV9JKBgEOvvgtk6yvRYoVN5m/IZ3D+8CrNWKBha31EkcAe3s4Y2Hz+qWHZ4cCVMQGT6GOGl+iFdGHtyv74=
Received: from SN4PR0501MB3903.namprd05.prod.outlook.com (10.167.142.151) by
 SN4PR0501MB3918.namprd05.prod.outlook.com (10.167.142.158) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.9; Fri, 14 Jun 2019 13:26:55 +0000
Received: from SN4PR0501MB3903.namprd05.prod.outlook.com
 ([fe80::d0ff:f109:af39:2c9c]) by SN4PR0501MB3903.namprd05.prod.outlook.com
 ([fe80::d0ff:f109:af39:2c9c%5]) with mapi id 15.20.1987.010; Fri, 14 Jun 2019
 13:26:55 +0000
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     "rostedt@goodmis.org" <rostedt@goodmis.org>
CC:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>,
        "y.karadz@gmail.com" <y.karadz@gmail.com>,
        "troyengel@gmail.com" <troyengel@gmail.com>,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH v2 1/3] kernel-shark: Remove the "-g" compiler flag.
Thread-Topic: [PATCH v2 1/3] kernel-shark: Remove the "-g" compiler flag.
Thread-Index: AQHVIrTVPxnXfnGmZUiXRXjBOv/GUQ==
Date:   Fri, 14 Jun 2019 13:26:54 +0000
Message-ID: <20190614132609.16465-2-ykaradzhov@vmware.com>
References: <20190614132609.16465-1-ykaradzhov@vmware.com>
In-Reply-To: <20190614132609.16465-1-ykaradzhov@vmware.com>
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
x-ms-office365-filtering-correlation-id: 829a020e-04ad-42cc-afca-08d6f0cbf7b1
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:SN4PR0501MB3918;
x-ms-traffictypediagnostic: SN4PR0501MB3918:
x-microsoft-antispam-prvs: <SN4PR0501MB3918B171A186618CF816F162A0EE0@SN4PR0501MB3918.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0068C7E410
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(376002)(39860400002)(136003)(366004)(199004)(189003)(1076003)(66066001)(486006)(2501003)(4744005)(2616005)(476003)(3846002)(6116002)(68736007)(256004)(99286004)(6916009)(66476007)(86362001)(66556008)(478600001)(64756008)(66446008)(73956011)(26005)(305945005)(66946007)(7736002)(14454004)(5660300002)(76176011)(102836004)(386003)(6506007)(52116002)(71190400001)(107886003)(36756003)(8936002)(8676002)(4326008)(71200400001)(2906002)(53936002)(25786009)(1730700003)(446003)(11346002)(5640700003)(186003)(316002)(2351001)(50226002)(81166006)(6512007)(6436002)(54906003)(6486002)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:SN4PR0501MB3918;H:SN4PR0501MB3903.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: esqxyjevRQ+bjmHBaAYQ2zifHuBvAvYJqoqZUcSLhD1wxNmnWqlvQmciEEK/NaxBIj93vaCBYVQLyiWczI6KdhbZfH/eLYHC9KvMO+OaOYWekzSF+IcJ9DQc7XP2djtLGLnaf2KfgL3GQ5VaZmYJR6aD8z23mndwJtrmekKkdCcfYUuyDGJ2qe2F5iGiAkNkHQ2oy3yhxRNz3ekZ3KysXO8r68gUBfP6sNEzEP0m0oHlvb9CzEsHu4l3VjhNeKlIoPmk1RkTjefrIy6Tc53JkemgZ/frylLrJiZyGtWToBN8tCP2Bp8LOh2QrsmaM8EjEdWK7sbgds/ThPZqWscKFaVK+vTFudYxAcp6wCISNYH3H+Jg7dRErJbXdHPZ9zxNPbSOZE2lDO4DjJQyYyrRm9T3f3pHvVhmTsS8rhKkGKI=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <68E9D53EFA06D740811E588785CAEA52@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 829a020e-04ad-42cc-afca-08d6f0cbf7b1
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2019 13:26:54.8445
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

The debug flags by design embed the build paths, but the distro package
binaries should not have such paths embedded in them.

Suggested-by: Troy Engel <troyengel@gmail.com>
Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/CMakeLists.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel-shark/CMakeLists.txt b/kernel-shark/CMakeLists.txt
index d45be20..87f33d6 100644
--- a/kernel-shark/CMakeLists.txt
+++ b/kernel-shark/CMakeLists.txt
@@ -33,8 +33,8 @@ endif (Qt5Widgets_FOUND)
 set(LIBRARY_OUTPUT_PATH    "${KS_DIR}/lib")
 set(EXECUTABLE_OUTPUT_PATH "${KS_DIR}/bin")
=20
-set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} -Wall -g -pthread -fPIC")
-set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -g -std=3Dc++11 -pthread -fP=
IC")
+set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} -Wall -pthread -fPIC")
+set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -std=3Dc++11 -pthread -fPIC"=
)
=20
 if(NOT _INSTALL_PREFIX)
 	set(_INSTALL_PREFIX "/usr/local")
--=20
2.20.1

