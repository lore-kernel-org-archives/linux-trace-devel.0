Return-Path: <SRS0=hThI=2V=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4A2CC2D0C2
	for <linux-trace-devel@archiver.kernel.org>; Tue, 31 Dec 2019 18:37:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A71D4206D9
	for <linux-trace-devel@archiver.kernel.org>; Tue, 31 Dec 2019 18:37:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="TNUPpfRl";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="dDIbSNmL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbfLaShv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 31 Dec 2019 13:37:51 -0500
Received: from mail-eopbgr40089.outbound.protection.outlook.com ([40.107.4.89]:3456
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726658AbfLaShu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 31 Dec 2019 13:37:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TZre0TfFJ46y+jNUkzXVLl1921xThpiE9MhF10zRcTk=;
 b=TNUPpfRlTvdLFdMuxtzSayGhZWTafw9mGxfeV+2jkCMUtS9LlO6xPIvs9zEOqKEJUT1574n+r9I8udVgoSnqwZiZfLs3x4WqkVkgxEIsXGWvXhPOFXs7KJe+nG+uJSiVfF5Xuq1xWFBatQT6iYY5WkSQLQZAaOKO8HftFYfmecM=
Received: from VI1PR0802CA0027.eurprd08.prod.outlook.com
 (2603:10a6:800:a9::13) by AM6PR08MB4246.eurprd08.prod.outlook.com
 (2603:10a6:20b:bb::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2602.10; Tue, 31 Dec
 2019 18:37:42 +0000
Received: from VE1EUR03FT061.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e09::208) by VI1PR0802CA0027.outlook.office365.com
 (2603:10a6:800:a9::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2581.11 via Frontend
 Transport; Tue, 31 Dec 2019 18:37:41 +0000
Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT061.mail.protection.outlook.com (10.152.19.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2581.11 via Frontend Transport; Tue, 31 Dec 2019 18:37:41 +0000
Received: ("Tessian outbound 4f3bc9719026:v40"); Tue, 31 Dec 2019 18:37:41 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 0ccae834dfb24c1f
X-CR-MTA-TID: 64aa7808
Received: from 772d89a54a52.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 6FE93A6D-4E01-4398-98F6-8386A18175CF.1;
        Tue, 31 Dec 2019 18:37:36 +0000
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 772d89a54a52.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Tue, 31 Dec 2019 18:37:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WrwIjPYAwnhDBKgA+T4wh/Ek5CdpgWWNnEjHICkyWuyxBEMrwaFmq64Z8BUUzxw/AL59NZV/+9s0kz1xmw7oqNszn1lzo2hwHbt+LeUWtF5UhlQBgeeTTiABp8Xl9vKYIjjNLg1kygphn2KFKWMV8+1c/QpxRoiNJiyPmEpPuFF4DytSKsu7yEa/WEQsB52gMyeZ8xNd+EePdqXjYUIQWjk2nH48DIDW5mKKLEU6SbRYCMLVjMfncXZn0q3RmRMCaGqVCmb9EsXwr8EcTGSvK/xOjPst7WEq+VUvNPBv7zb9BOLcSfMr9Z11JE3gR72gp5ZzJmYORONu9hoY46ESsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bpHc2vTQGRUY++LXxkIzORPNnQwN1Ovj151iAp9K0g8=;
 b=kYu9yDe6mya3Poz202eVUQilec4C7p5ohpuS4cGIGZ8htOXczvduU1MZaLpT4jnpzjEgGHEYpGyDdVLZ06qqT8LxpogMG8dv1XGN+FwuE6/dH6+WX0iHihbyh5okZ7SAi8Sf3o+wwZlffnPSZTsEy+5WM0HsY9q2hvMwzTZxjIn7XcH2/MVYsvY2hJi23QgyKa7yxpB+bQE0YmF3eytvDToK0VoM2IVLcF6JMM6QBlGnhvoXOATAwUnlE0bvnuusetdf8uNmEBtIppqLp1D4rLN7junrhXVbr5V/pow9qNdNhMK9+ZXngqxl2KeJ2U/g2BnCKvd6rzHXW/5sssiJgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bpHc2vTQGRUY++LXxkIzORPNnQwN1Ovj151iAp9K0g8=;
 b=dDIbSNmLdFKJF0dbhCY4vOaFAzCKwfWiFS+Ss9aVLMqLEW6Ol6se+VKmD45BOvmkw2R3cNiB0z4/IGGGk3H9BJVXWCwBWmQv43zX0HhYoGZJw8B+pkeYRmsl5QY3blqLOGdVjdTGpxK0gK/Ok3E4vzBsiGxfSqsOQjsDNT+hudg=
Received: from AM7PR08MB5368.eurprd08.prod.outlook.com (10.141.171.81) by
 AM7PR08MB5381.eurprd08.prod.outlook.com (10.141.172.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2581.12; Tue, 31 Dec 2019 18:37:35 +0000
Received: from AM7PR08MB5368.eurprd08.prod.outlook.com
 ([fe80::cdde:d697:f73e:f848]) by AM7PR08MB5368.eurprd08.prod.outlook.com
 ([fe80::cdde:d697:f73e:f848%5]) with mapi id 15.20.2581.007; Tue, 31 Dec 2019
 18:37:35 +0000
From:   Douglas Raillard <Douglas.Raillard@arm.com>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
CC:     "rostedt@goodmis.org" <rostedt@goodmis.org>,
        Valentin Schneider <Valentin.Schneider@arm.com>,
        nd <nd@arm.com>
Subject: Re: [PATCH 0/5] Build trace-cruncher as Python pakage
Thread-Topic: [PATCH 0/5] Build trace-cruncher as Python pakage
Thread-Index: AQHVsMrzt0HrocaeI0usZtY8h3i6J6fUpuNG
Date:   Tue, 31 Dec 2019 18:37:35 +0000
Message-ID: <AM7PR08MB5368B833EEC03246474843E08F260@AM7PR08MB5368.eurprd08.prod.outlook.com>
References: <20191212090232.24236-1-y.karadz@gmail.com>
In-Reply-To: <20191212090232.24236-1-y.karadz@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Douglas.Raillard@arm.com; 
x-originating-ip: [109.212.80.175]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f433ba35-1fc7-4ed2-0f41-08d78e208510
X-MS-TrafficTypeDiagnostic: AM7PR08MB5381:|AM7PR08MB5381:|AM6PR08MB4246:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <AM6PR08MB42467678D293BE9DF131682D8F260@AM6PR08MB4246.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
x-ms-oob-tlc-oobclassifiers: OLM:10000;OLM:10000;
x-forefront-prvs: 0268246AE7
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(39860400002)(346002)(376002)(136003)(189003)(199004)(4326008)(8676002)(2906002)(186003)(45080400002)(478600001)(8936002)(81156014)(6506007)(76116006)(66446008)(53546011)(66946007)(81166006)(33656002)(26005)(64756008)(66556008)(66476007)(55016002)(71200400001)(9686003)(316002)(7696005)(5660300002)(110136005)(52536014)(966005)(54906003)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM7PR08MB5381;H:AM7PR08MB5368.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: +ML+fwoYhEx2gr/IdF3qWKoZ1OX3z6dGkK4O4DjIqfucJ3vpWKqgfBjD5No34xe54+96Bn9ZRMFhEsSF9HZUcI5T1sVIqZp7gAwLLJJ0tYznFoLmDzudI4D2sQqv0T8fJoC56G57SYD7mLhKAq5atQ9u5kcIKM96bmVt2qZXR9JlX80ARu7WkFOCZPNtSWPdhHr1Q1PnfXTHWx75r6ARkG8esob2TV/29lMEZSW2xjAin3TaABN5PgQ6xoM2a6jqIE05pxTLK5mbgjHdoxmYmo76jA5o+TzWCf18CUSxWhHAm8KCcdffoJuaqlvVVRRjex/aaNKKo8J0dgFbf4G6KHc/Abw0FKHmGEbigiQG2i0jjsXxZmZEHy7j11EbuoSLdBaj/CvCKNp/TkjuyeBu7G3Wypz2MrgRLJFXN6sEuNASnS9D9eMf1xZxLTydIouWsLloRFtdJg4kkXjsR6+7sS5V7A+mzfzJ1gcG/dVelmg=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR08MB5381
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Douglas.Raillard@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT061.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;IPV:CAL;SCL:-1;CTRY:IE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(136003)(346002)(376002)(199004)(189003)(40434004)(316002)(8676002)(55016002)(9686003)(81166006)(54906003)(2906002)(110136005)(36906005)(8936002)(33656002)(81156014)(86362001)(26826003)(26005)(966005)(4326008)(76130400001)(356004)(52536014)(186003)(478600001)(45080400002)(336012)(70586007)(70206006)(5660300002)(53546011)(6506007)(7696005);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR08MB4246;H:64aa7808-outbound-1.mta.getcheckrecipient.com;FPR:;SPF:Pass;LANG:en;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;A:1;MX:1;
X-MS-Office365-Filtering-Correlation-Id-Prvs: ba92f4bb-cbdf-42bb-7590-08d78e208109
X-Forefront-PRVS: 0268246AE7
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j3GU8AeQiMTAsm3ardhk00UZ0O2kx5BUAq/8aWha3Vg2yw3DuZ5xgFBZHe07x3JcViY/Xtggd45uE5finKZc+2GGoYupyXikVP+7LsCgHaqRb8VCS0AckVLrDTRFuu3EqRQZkGJho1zAFLOmgHDXvoMzGDkm9X6ORwxyzeMUBTM8QLBgLLQf2dIkvasieWK5cni15s8nKDoRX//gKb+B/8llcsdh7WmQncLZRH7cjXUVhMKigk+8atjPh0GFcoLXXldkkpcUoN0RTjvy4jnF5lalAvLie1ea+tUWr9v6+fUJTotz3SEDhxyMjUsj37CFgNfOKdyl9mJLZvkKJrNf1fbJFl35cDL3QLI4YNuNPJXHyTbuVCeWcc5PGXNFg8zSH1rtoxgDICASlQ6/fX1PH86agTRJoANfFQ4xuhNeLjXnaSStg5KhraJFg3j6sD0ROPEu/NLWll7xIf0F8Ox+v+wM1V/PHrD9+8DK8Jfi8gXkjDLgzPjsojzuY4Y94mXEC3gDooZrP69OaZOyk2SAnkmX8VuEJmj7WVGCrgscvPo=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Dec 2019 18:37:41.7703
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f433ba35-1fc7-4ed2-0f41-08d78e208510
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB4246
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Yordan,

Finally got around to trying trace-cruncher. I've rediscovered how much I h=
ated C build
systems issues in general, so here is the outcome of the first day of battl=
e :-)

kernelshark bits:
* kernelshark build system seems to ignore the standard CMAKE_INSTALL_PREFI=
X
  but uses _INSTALL_PREFIX instead, might be worth aligning with the docume=
nted
  standard stuff of CMake if that makes sense.
* _INSTALL_PREFIX is used for almost everything, except a polkit file that =
is copied
  to /usr/share/polkit-1 regardless of _INSTALL_PREFIX, which makes install=
ing as
  non root fail.

Now trace-cruncher-specific bits:
* Building kernelshark gives shared objects with .so.X.Y.Z file names, but =
GCC
  wants to link against .so
* There are some hardcoded paths to /usr/local/ in setup.py. They don't see=
m
  to break user-given include paths but it would probably be a good idea to
  make that somewhat parametric.
* libkshark-input.h does not seem to exist but is used by ksharkpy.c. I'm n=
ot sure
  if I used the wrong version of something or if that's a genuine issue.

Here is the command I used to try to build trace-cruncher in a venv with
numpy and cython installed:
$ pip install . --global-option=3Dbuild_ext --global-option=3D'-Itrace-cmd/=
install/include' --global-option=3D'-Ltrace-cmd/install/lib/kernelshark:tra=
ce-cmd/install/lib/trace-cmd:trace-cmd/install/lib/traceevent'

I've pushed some WIP commits on top of your series on my fork if you
want to get a look at them:

Branch: refactor
remote: https://github.com/douglas-raillard-arm/trace-cruncher.git
https://github.com/douglas-raillard-arm/trace-cruncher/commits/refactor

For the sake of reproducibility until things become stable, it might be a g=
ood idea
to maintain a WIP branch with submodules/subtrees for trace-cmd in the righ=
t version
in trace-cruncher repo, and the series applied, so we don't have to jugle w=
ith the
ML lore to get mbox plus other patches from the repo itself etc. Once we ha=
ve that,
we can easily include a script that calls all the build systems involved an=
d install all the
required bits in a venv, without polluting system-wide locations, and progr=
essively
turn that into a standalone setup.py (or the nearest approximation of that =
we
manage to make).

PS: apologies for the extra new lines and lack of reply markers,
Office 365 webmail does not seem to play very nicely with plain text ...

Cheers,
Douglas

From: Yordan Karadzhov (VMware) <y.karadz@gmail.com>

Sent: 12 December 2019 09:02

To: linux-trace-devel@vger.kernel.org <linux-trace-devel@vger.kernel.org>

Cc: rostedt@goodmis.org <rostedt@goodmis.org>; Valentin Schneider <Valentin=
.Schneider@arm.com>; Douglas Raillard <Douglas.Raillard@arm.com>; Yordan Ka=
radzhov (VMware) <y.karadz@gmail.com>

Subject: [PATCH 0/5] Build trace-cruncher as Python pakage




This patch-set is an attempt to restructure the project and to make it

build as a native Python package. Although it looks like a complete

rewrite, this is essentially just a switching from using Cython to using

directly the C API of Python. Cython is still being used but only for

the implementation of the NumPy data wrapper. The new package has its

own stand-alone build system (very primitive for the moment) that is

completely decoupled from the existing build system used by tracecruncher.

In order to build and install the new package do:



sudo python setup.py install --record files.txt



The patch-set does not  remove the old implementation yet. This will

happen in another successive patch-set.



Please review as careful as possible!



Yordan Karadzhov (VMware) (5):

  Refactor the part of the interface that relies on libkshark

  Refactor the part of the interface that relies on libtraceevent

  Refactor NumPy based data wrapper

  Add "utils"

  Adapt the sched_wakeup.py example script to use the new tracecruncher

    module



 examples/sched_wakeup.py  |=A0 30 ++---

 setup.py                  |=A0 61 +++++++++

 src/common.h              |=A0 20 +++

 src/datawrapper.pyx       | 201 ++++++++++++++++++++++++++++

 src/ftracepy.c            | 234 +++++++++++++++++++++++++++++++++

 src/ksharkpy.c            | 268 ++++++++++++++++++++++++++++++++++++++

 src/trace2matrix.c        |=A0 29 +++++

 tracecruncher/__init__.py |=A0=A0 0

 tracecruncher/utils.py    |=A0 54 ++++++++

 9 files changed, 882 insertions(+), 15 deletions(-)

 create mode 100644 setup.py

 create mode 100644 src/common.h

 create mode 100644 src/datawrapper.pyx

 create mode 100644 src/ftracepy.c

 create mode 100644 src/ksharkpy.c

 create mode 100644 src/trace2matrix.c

 create mode 100644 tracecruncher/__init__.py

 create mode 100644 tracecruncher/utils.py



--

2.20.1



IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
