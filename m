Return-Path: <SRS0=0SC1=RX=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 837AAC43381
	for <linux-trace-devel@archiver.kernel.org>; Wed, 20 Mar 2019 15:53:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E4A52183E
	for <linux-trace-devel@archiver.kernel.org>; Wed, 20 Mar 2019 15:53:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="SrMVKRj+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbfCTPxI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 20 Mar 2019 11:53:08 -0400
Received: from mail-eopbgr730069.outbound.protection.outlook.com ([40.107.73.69]:22464
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726707AbfCTPxH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 20 Mar 2019 11:53:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ajkbkmW2F/hpdMerOvlnAAC+VKC0B7LkhPuyS6SUKno=;
 b=SrMVKRj+t9Vj4wrRjEwGCHLH9+5SMQ5wPxD2wgNPxBYm/q6PxTr+R7j/BCp9XOWN8xHC3Mg1Y9/DTIp67G5kr05cIr55MfLmjsw6RYd6NvcA3ogVR5guJCLyjSOSNA9ZmyVCnYRefS/PRdHP6TXPMAJM5d/ntjeYvuWey8fZ9o8=
Received: from BYAPR05MB5592.namprd05.prod.outlook.com (20.177.186.153) by
 BYAPR05MB5911.namprd05.prod.outlook.com (20.178.50.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.12; Wed, 20 Mar 2019 15:53:04 +0000
Received: from BYAPR05MB5592.namprd05.prod.outlook.com
 ([fe80::c0d4:e960:b51:44cc]) by BYAPR05MB5592.namprd05.prod.outlook.com
 ([fe80::c0d4:e960:b51:44cc%2]) with mapi id 15.20.1730.013; Wed, 20 Mar 2019
 15:53:04 +0000
From:   Matt Helsley <mhelsley@vmware.com>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
CC:     "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 2/3] tools/lib/traceevent: Coding style fixes
Thread-Topic: [PATCH 2/3] tools/lib/traceevent: Coding style fixes
Thread-Index: AQHU3kWhcG3tECTl4kCLPRbOQ9CI5KYUrXMA
Date:   Wed, 20 Mar 2019 15:53:04 +0000
Message-ID: <31B53E00-BD8F-47B2-A2EF-1632AE8002E9@vmware.com>
References: <20190319111924.17443-1-tstoyanov@vmware.com>
 <20190319111924.17443-3-tstoyanov@vmware.com>
In-Reply-To: <20190319111924.17443-3-tstoyanov@vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=mhelsley@vmware.com; 
x-originating-ip: [73.25.163.201]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 480b6e08-8808-4579-9582-08d6ad4c2363
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:BYAPR05MB5911;
x-ms-traffictypediagnostic: BYAPR05MB5911:
x-microsoft-antispam-prvs: <BYAPR05MB5911E804D8FD6AB38B22683FA0410@BYAPR05MB5911.namprd05.prod.outlook.com>
x-forefront-prvs: 098291215C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(39860400002)(366004)(376002)(136003)(396003)(189003)(199004)(71200400001)(53936002)(486006)(2616005)(71190400001)(11346002)(478600001)(6486002)(446003)(3846002)(8936002)(6436002)(229853002)(476003)(6116002)(33656002)(66066001)(25786009)(36756003)(26005)(37006003)(14454004)(99286004)(54906003)(6246003)(102836004)(7736002)(6636002)(81166006)(76176011)(53546011)(4326008)(68736007)(8676002)(305945005)(97736004)(6862004)(4744005)(6512007)(106356001)(83716004)(256004)(6506007)(105586002)(81156014)(316002)(82746002)(86362001)(2906002)(5660300002)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB5911;H:BYAPR05MB5592.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: VXqWk9YyYyNndJf0p2XA63hMTca90sKSiN99sQn94eALlxp7Ezz59UvJf492TdUFku2KNetEquUn2lV2qZzYiHb/u+Y39IBFb1KJA49pPQml0DdHg8dc9urFGxMZSqn8MqDIVl3gWoFlAJumYky7yghSQv4jSTbrGdjhTT2lE9P06CoxyJnB/m8stMBa65xW8dtZGNHT+5aBOw4gTY/SYifAmQ30wdKrmNuzGvMUIIOzlKo+vskUJByg+cNgJkCIrnM9hI4hfY/63FW1gi2Za3IyAQFgXS65eZIj9Im0o6vs7mFulT5OHNoRuD8+1ClQ+1S+zorlY+nHhoJqj9f5zL4pWhISJDV/ZJ6IxmeJome+ib3+cY2bN8bMio/9l5tKhDnu0umWzoZjEsUbRRu9kNbfd20tGEjDa4bXX6CVYKk=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7668B2B5BA2E5F4DB89BBAAB80CD2048@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 480b6e08-8808-4579-9582-08d6ad4c2363
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2019 15:53:04.0741
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB5911
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



> On Mar 19, 2019, at 4:19 AM, Tzvetomir Stoyanov <tstoyanov@vmware.com> wr=
ote:
>=20
> Fixed few coding style problems in event-parse-api.c
>=20
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
> tools/lib/traceevent/event-parse-api.c | 30 +++++++++++++-------------
> 1 file changed, 15 insertions(+), 15 deletions(-)

Reviewed-by: Matt Helsley <mhelsley@vmware.com>=
