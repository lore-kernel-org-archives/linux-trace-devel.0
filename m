Return-Path: <SRS0=0SC1=RX=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1389AC43381
	for <linux-trace-devel@archiver.kernel.org>; Wed, 20 Mar 2019 15:48:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7CC82146E
	for <linux-trace-devel@archiver.kernel.org>; Wed, 20 Mar 2019 15:48:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="pPXQFn4c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726529AbfCTPsX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 20 Mar 2019 11:48:23 -0400
Received: from mail-eopbgr710080.outbound.protection.outlook.com ([40.107.71.80]:40936
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726457AbfCTPsX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 20 Mar 2019 11:48:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=INuqFldvr/gqgjaFVI2NQ4p8Fn8+U7rppD6E/E3DrLk=;
 b=pPXQFn4cb9K479ik6vec9rjyM69JEB/rQ19n7tV1iF56uiSXoFsrEIh2Fn99+/k99AFusFUUdIRpYvm3VuD6iSw3OWF1VLISUyBCPHKaTcvQ50qtPRCU+5guiPqqwCHjGOAiVSxp6HJ2rc3BRMoW1Wut2camQ2S5MzI7dH8VUi8=
Received: from BYAPR05MB5592.namprd05.prod.outlook.com (20.177.186.153) by
 BYAPR05MB6168.namprd05.prod.outlook.com (20.178.55.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.16; Wed, 20 Mar 2019 15:48:19 +0000
Received: from BYAPR05MB5592.namprd05.prod.outlook.com
 ([fe80::c0d4:e960:b51:44cc]) by BYAPR05MB5592.namprd05.prod.outlook.com
 ([fe80::c0d4:e960:b51:44cc%2]) with mapi id 15.20.1730.013; Wed, 20 Mar 2019
 15:48:19 +0000
From:   Matt Helsley <mhelsley@vmware.com>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
CC:     "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 1/3] tools/lib/traceevent: Change description of few APIs
Thread-Topic: [PATCH 1/3] tools/lib/traceevent: Change description of few APIs
Thread-Index: AQHU3kWjH6AUanX5bk2mpOM+tIWW1KYUrCCA
Date:   Wed, 20 Mar 2019 15:48:19 +0000
Message-ID: <451EEE96-8E89-4135-8E04-4BFBFFB60398@vmware.com>
References: <20190319111924.17443-1-tstoyanov@vmware.com>
 <20190319111924.17443-2-tstoyanov@vmware.com>
In-Reply-To: <20190319111924.17443-2-tstoyanov@vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=mhelsley@vmware.com; 
x-originating-ip: [73.25.163.201]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7ac33863-a50f-4ab0-0c67-08d6ad4b79d1
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:BYAPR05MB6168;
x-ms-traffictypediagnostic: BYAPR05MB6168:
x-microsoft-antispam-prvs: <BYAPR05MB6168F994711822FB8AFBE3AFA0410@BYAPR05MB6168.namprd05.prod.outlook.com>
x-forefront-prvs: 098291215C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(366004)(396003)(39860400002)(136003)(346002)(189003)(199004)(478600001)(7736002)(5660300002)(3846002)(81156014)(6116002)(14454004)(66066001)(54906003)(305945005)(99286004)(316002)(36756003)(37006003)(53936002)(97736004)(8676002)(82746002)(4326008)(68736007)(33656002)(81166006)(6636002)(6246003)(71190400001)(2616005)(83716004)(71200400001)(486006)(2906002)(6512007)(8936002)(6486002)(25786009)(6862004)(105586002)(229853002)(53546011)(256004)(11346002)(6506007)(186003)(102836004)(86362001)(4744005)(6436002)(446003)(476003)(26005)(76176011)(106356001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB6168;H:BYAPR05MB5592.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: yUFzkGhbwaOngaC8F31mkwdPAl0VPjDThL5Fzr4LqdiWC5EtkNamTK2PvxgmJUXR3mzc+u7PsnQwac+0xmvhceRVCWhLuji5KpNIqHndU4m00nD90bJz27uvQIbQVTLZBwfHhBxiC8q8pxY7TjeJTDjT+V4kjxn3ExiuawH4E8QAlJfH3ZpKLdZsE30ayaq1l/ZYciEIbYQPORrDAPWRnyUG8AjE9hjW/1yva3889gyPVDgH5DcqsjuSsqMvSqLvn6Y/JMxOsuer7Ol5tKTp68WZhc5gOFTq9oPhQb4MU1vZ6Hyu1AD55f5tuJWEMtUJdRKv3uFVSX3/wuRAZaitD06jxvVB6xeAHD0fXuxpo5kTSGamyl5ng4CXiiPJK1ZuJbK2dFqHQ9JuhbXYVEWLCokD4X3LyNM+z0ezJ8zf+/k=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C4FA23CD4600954FAE9D68368DDF6FDF@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ac33863-a50f-4ab0-0c67-08d6ad4b79d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2019 15:48:19.5778
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB6168
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

> On Mar 19, 2019, at 4:19 AM, Tzvetomir Stoyanov <tstoyanov@vmware.com> wr=
ote:
>=20
> APIs descriptions should describe the purpose of the
> function, its parameters and return value. While working
> on man pages implementation, I noticed mismatches in the
> descriptions of few APIs. This patch changes the description
> of these APIs, making them consistent with the man pages:
> tep_print_num_field(), tep_print_func_field(),
> tep_get_header_page_size(), tep_get_long_size(),
> tep_set_long_size(), tep_get_page_size() and
> tep_set_page_size().
>=20
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
> tools/lib/traceevent/event-parse-api.c | 20 ++++++++++----------
> tools/lib/traceevent/event-parse.c     |  4 ++--
> 2 files changed, 12 insertions(+), 12 deletions(-)

<snip>

Reviewed-by: Matt Helsley <mhelsley@vmware.com>

