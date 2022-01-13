Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA3C8C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 Jan 2022 08:20:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232927AbiAMIUW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 13 Jan 2022 03:20:22 -0500
Received: from mga06.intel.com ([134.134.136.31]:39963 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231249AbiAMIUV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 13 Jan 2022 03:20:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642062021; x=1673598021;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=mE9NMgrIBSmXjLkQxbmn1Habb+oHMZiFFgv4V+MBuaY=;
  b=JWSMZJcaREli7h0rGHo1g9zjGHaLjsljoQxqmyXfGeFDv1A+6/cn44ne
   0Jvo1SnSOF+QHP4Ma2bnsg+B+4LGKmdBBvFhjY25bbzNUPz0/tLk96rM9
   kFIzTgEr3FGrpP3yktJ38dW1k7j/K/9GLMdZiNZWv1QzN87Aei12JHOAk
   eftoUQQSqRgCyDK4sGn+E+4PRnyGwusrU0HZ7xTaHnYM03RmUspVMsrMD
   rSTEk1u2W0st0X1YOB5eukYXdYOsDpwviozaqgOOZRl6lQwrL2sl0jOXu
   9yT+iPeEDn/Ah3SeF0OVU5tpD6tNYfFjcZnltflQR9ao6QqH0lGmaCz5T
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10225"; a="304694850"
X-IronPort-AV: E=Sophos;i="5.88,284,1635231600"; 
   d="scan'208";a="304694850"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2022 00:20:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,284,1635231600"; 
   d="scan'208";a="529571349"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga008.jf.intel.com with ESMTP; 13 Jan 2022 00:20:20 -0800
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 13 Jan 2022 00:20:20 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Thu, 13 Jan 2022 00:20:20 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.45) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Thu, 13 Jan 2022 00:20:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e3W+JUQ4bUzFh/rVI8gHQBv0mJ4BHAG9rHfsbtBQohAIWYdZBLdmYaEcYxXwjpPoHDSPTI1//1Oub/TzpmMCqSXVupH9wV/O9tGhjhiWkCJV+6JTI8FVA3/htVd7LMgLur43T+4PR2Olnso0zBRZE2dqcgIoFs3N7PX/Ksu2k27LqCYGNZIbpI9F7UeEZn1VOO9uM8ukk4Yfmml16D2IKAu8S/jddbPs6yg6X4/nW4eu7RrWdPN633/8E2UpuY7O10ORAvthp8Gyo9YzBQRG9//coe6QpaQkK+P8jGXfe+icwwebycg0pMnVDu93ErhrWb3EKBOf7/tAM5Xj2rdxtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rEFImDYnfPJ3P2dnAGF8Odhn1MdybwpBbuThXHFoHD0=;
 b=adbmjeDr6vr7QCCqMX7M+RRCu/7X/0woXp2wnu+Cj/Asb4yG0rrymaZx+4EDYUvjHZdFdrzI2sxLwjt8q8iJrrd7VYC+5wHPs9BK4Ggtdm5t9udoxG4eg34FHPIvERXd0j+0pHLHBvX9h1+1BmcMwNWvqWhS4dkexRH2plZ1Vsxq+yNs6tPLBpY5bhOy/k7MGXJ9FGc6KO90RzYWT3UqXPFPfjCH9WTrxxumcUQLH7Av837YPlSWBB7eX07cMjhFZxFmVRbn7Xx7e6KzS5EmVETn5I8GdWEUfTLNYU9ouivbImHb/fSRIcXPq7tsGUSfeoU3S/JhNmwoxHIaOa6sTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB4285.namprd11.prod.outlook.com (2603:10b6:208:191::32)
 by BL0PR11MB2964.namprd11.prod.outlook.com (2603:10b6:208:7c::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Thu, 13 Jan
 2022 08:20:17 +0000
Received: from MN2PR11MB4285.namprd11.prod.outlook.com
 ([fe80::38b5:756e:417:6409]) by MN2PR11MB4285.namprd11.prod.outlook.com
 ([fe80::38b5:756e:417:6409%5]) with mapi id 15.20.4867.011; Thu, 13 Jan 2022
 08:20:17 +0000
From:   "Chen, Hongzhan" <hongzhan.chen@intel.com>
To:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
CC:     "Kiszka, Jan" <jan.kiszka@siemens.com>
Subject: [Questions][trace-cmd/libtraceevent] how to correctly  parse info out
 from specifial format of event?
Thread-Topic: [Questions][trace-cmd/libtraceevent] how to correctly  parse
 info out from specifial format of event?
Thread-Index: AdgIVSD6mVFfD1+OR1i6bZGO+fUq5w==
Date:   Thu, 13 Jan 2022 08:20:16 +0000
Message-ID: <MN2PR11MB428586156443A851B879867BF2539@MN2PR11MB4285.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3ec40453-11ae-4232-438b-08d9d66d87f1
x-ms-traffictypediagnostic: BL0PR11MB2964:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BL0PR11MB29640DCE8F2ECB049A420144F2539@BL0PR11MB2964.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: z4yXQFuoNLJrfiAHcsb7mRaJ1xmp2YLs4te72+9ng6YBqKhCvjw94/Sv/1tGa5291UNkbHfjoKtBAWMB1kb54pRd/4MIW1IzUtB/yIDXdMSc5KdYZekTgU4XIdyqMrx0vprowqouob/xh0TjTgd7skkaf/HsNAN/pa0ZDpz5b7i3Z4eI4XkpWVdr/P1YP6UpCrc+iJ96bx9ihFEvjpjLajTPxNKp0TBORKL2pI0AbO+tAUCcz6WxKIeLijifCxTSKNYB8vaidwIJJ9zlNKM9yA+xinQQ2rNznt+0lEEsD4VuF9fxJd4OIRULGanVUbk68oimPkFNP5KptOhAT3mnlUAJLwtLBCLbbPMsxuQDHTYjAmg0Yz+vmrdwF7WtbMOYDdHaAF0g0pZ9XdSTEqQY29pohzp8r9JMSPTtg8MLy1Daqk+/ZFCmEmqUp+FmN/1bojIgud0ZaA4qTBTIr6XyG1yI1s5sVj1422jPDUsU/qtwoyffoJVVSu1U1eVweAm2ofdGIQknjJC90eR8BRxjksybuGQ7DmN2HlVbjGeJk9X+nthPCBpnLi6IeQvn8oEUM3OvtRbkOdUYBtM3zTZmHtGGEMatCHAMO1hzIOFj8IvTbx2qNuu3YiRKmkkOwP3sZWkdR/ieRzNHa7kdLCh4GVErI+LsSPLfDleghprhpOGB+WSV94bp0sgJvaOGUARLyFI1OCdVsL5n1ZZWaLl5Xw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4285.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(8676002)(82960400001)(316002)(122000001)(38100700002)(26005)(6916009)(7696005)(38070700005)(9686003)(186003)(5660300002)(40140700001)(55016003)(71200400001)(33656002)(83380400001)(508600001)(6506007)(64756008)(66556008)(52536014)(66946007)(4326008)(2906002)(66476007)(76116006)(8936002)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HaRR7SM9mF+Xk8avgZ6MFzrvT01OjfTOEGg79wE+M/QNcuWU45L+okjt9ihK?=
 =?us-ascii?Q?GwcafjrUMxgN8mKGkmRkLE3voUAsmK1S+aL7VO5CACjO2XaTzJAtu9ZUj5J7?=
 =?us-ascii?Q?WQi/DMmWgmqTpgCfDbPLSxXjuExUldm7uekGa11s1orUV0n5CtJW+awQR6QK?=
 =?us-ascii?Q?ykOnXD/AckxWPDvWhuiqmhZ7iGDfXqnO3Wpido4tVFxlLyiwkCXDaCPpA9Sc?=
 =?us-ascii?Q?57zfNdHYpaJlzKT7w/YF5+hmS9AXkPqx6qII/HYl8Ig/EY9292ZQ6g4RCjR+?=
 =?us-ascii?Q?MvMTOUSISvkCitSOmu5zgumy33i9Kn891ewd4FPPPcICnC4R+zU/MzNmYxED?=
 =?us-ascii?Q?RqSVDyv2kq43oHxyPdXjs2ATKTIYyWPVvfz5Y4cqA+c1p7gVJmtegjlM9lUB?=
 =?us-ascii?Q?M5zI+PU0A62NSaUr9GgVRhMTpH/TuGsVpqBzJdqOJ+2IT9rnbbgmXlB+D7J3?=
 =?us-ascii?Q?oKHuA4VyZoatwPoNZi4nh8OAaZYBsmHCnTx10a7EEpJw/dfqUBrKU3WH5eaz?=
 =?us-ascii?Q?E9b+pOpk5C/TLRP/iaRR/LvKoMnTFBklc0vn2GNaHm2ONSKSkL0pSezGbzCS?=
 =?us-ascii?Q?JCsPLQkk4ZLgv6uHtCt1Uog5DnZI11/Dv/f33I68GlhHiJbchSy8Zy7B5Nxv?=
 =?us-ascii?Q?XhFcX36affUausFEDGSdX2XqWZO/hLzbFHtcudtNAwSepN0fQBqflJghX9Vl?=
 =?us-ascii?Q?QQqme6+8CSMd5p6gr20Nuk/cKjqmSMK6/pJwUHgEXmJ6f8TikZYx9jqtqQYK?=
 =?us-ascii?Q?KSIcJvFrugv63SogdwBrT3mTZLV9jd1XiU5C+IQi1cOajxdslrA7vH5LT2Dx?=
 =?us-ascii?Q?6VitsxsBXvwTHuuVy2l+u98jp9/5ZV4l3VU5nFc6+95vPX1kLPSsth7cfXel?=
 =?us-ascii?Q?JlmmT7XrHM83YNQiHEqd6CN+m2N8aqcnbwt8/m/LVYoIkaNw+KI82Zsdx2fJ?=
 =?us-ascii?Q?oOsIejOCkr5Dwj27wQxXtay0G6WEwvaHKOxD1i5y31HxOusgEdXwO9sgQzox?=
 =?us-ascii?Q?OcajiRfTkEWye4/ZbPEF7xWpuLtW7Ri7DbFrbTdaWvjTH8gTuq1o64uTDpbG?=
 =?us-ascii?Q?izKUtsF7esa8iGl7QiYqFr1DKaLwO74NQ3BYfmiBQh7JuvOgvkijtJgYLb48?=
 =?us-ascii?Q?QlQuCNm3gqFqjfOQDvGSDw+UMwtE4ZhntidWt3/xNBG2AL4Q85XS8kByCKXr?=
 =?us-ascii?Q?RTDgmF1tXt2rtMz68GnJJRQ4QEHMeJumZUSMg4s9UUNoMLtlWqRr+nHDeKr9?=
 =?us-ascii?Q?DWEG5ZlyiIeqlLOiWPC8BS6+arB1M4+zVJAkXth/ScAqOG1TZBIC0cJarDH2?=
 =?us-ascii?Q?CbUHFmjv1kOfncz7Gz5qmwiuz2oDq+KyvpY55MLdNS/3EWzG79LVa27W7evc?=
 =?us-ascii?Q?BVQbqT2GHhgH0trAfr1+w01mk1VVCltDi0xrGSeVL0tyn7N28SDrBeVNYykR?=
 =?us-ascii?Q?A3/QgKfGVCGOM+z8ztXbcCTQgSTFDufp0EFpXDrPgioBBrD4iBI3NTZXKp8+?=
 =?us-ascii?Q?pSqkh2kgKo3JgHDn2t+1yf1N4n8fjVzS5NcQ13J0sjXhT+yLQNnAXaC3/TLb?=
 =?us-ascii?Q?rv13bnVYzqOKbqqdvGi42wY685uZqzK6queEe+E47lbG4nQNpGWsNFdaNa6L?=
 =?us-ascii?Q?vJRcxCEWwgwSwswMf+n1m6U=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB4285.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ec40453-11ae-4232-438b-08d9d66d87f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2022 08:20:16.8744
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CgRZa31r5MQag9nXvNWoFG4O4Nn4gH9PFrKFbrGvdVwijiG1Rvvupp1ZroZECNg3isQapRypetf51pWimxqUSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB2964
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


When I tried to analysis trace log that captured from xenomai system with k=
ernelshark, I found
that it report "FAILED TO PARSE" for some events. These events have format =
like [1].
In trace, these events would be printed like [2].=20
At first, I was trying to develop new libtraceevent plugin to parse this ev=
ent correctly.=20
When I refer to code plugins/plugin_mac80211.c of libtraceevent to parse fi=
eld param_ex=20
out for this __data_loc type of data, I always get value 0x380018 and It is=
 supposed to trace_seq_printf=20
0x38 size of string got from offset 0x18 of tep_record->data but it fail. A=
fter debug,  I found
that the data start from offset 0x18 is not what we expect and first few by=
tes of data is like [3].

 It seems  that data stored for field param_ex is quite different from what=
 we expect.
How could I look into trace-cmd related code to fix such issue? Any suggest=
ions?=20

Thanks for your help in advance.

[1]:
root@ecs-xenomai-isar:~# cat /sys/kernel/debug/tracing/events/cobalt_posix/=
cobalt_pthread_create/format
name: cobalt_pthread_create
ID: 628
format:
        field:unsigned short common_type;       offset:0;       size:2; sig=
ned:0;
        field:unsigned char common_flags;       offset:2;       size:1; sig=
ned:0;
        field:unsigned char common_preempt_count;       offset:3;       siz=
e:1; signed:0;
        field:int common_pid;   offset:4;       size:4; signed:1;

        field:unsigned long pth;        offset:8;       size:8; signed:0;
        field:int policy;       offset:16;      size:4; signed:1;
        field:__data_loc char[] param_ex;       offset:20;      size:4; sig=
ned:1;

print fmt: "pth=3D%p policy=3D%s param=3D' %s '", (void *)REC->pth, __print=
_symbolic(REC->policy,=20
{0, "normal"}, {1, "fifo"}, {2, "rr"}, {11, "tp"}, {12, "quota"}, {10, "spo=
radic"}, {42, "cobalt"},=20
{43, "weak"}), cobalt_trace_parse_sched_params(p, REC->policy, (struct sche=
d_param_ex *)(__get_dynamic_array(param_ex)))

[2]:
 smokey-752     [000] d.~2  7970.727466: cobalt_pthread_getschedparam: pth=
=3D000000009bbc7fe0 policy=3Dfifo param=3D{ priority=3D50 }
 smokey-762     [000] ....  7970.727492: cobalt_pthread_create: pth=3D00000=
000983468a5 policy=3Dquota param=3D{ priority=3D1, group=3D0 }

[3]:
0x1 0x0 0x0 0x0 0x0 0x0 0x0 0x0


Regards

Hongzhan Chen

