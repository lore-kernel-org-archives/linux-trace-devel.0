Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40404ECAAA1
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Aug 2022 21:03:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243833AbiHYVDQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Aug 2022 17:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243653AbiHYVDN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Aug 2022 17:03:13 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC0F0A6C35
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Aug 2022 14:03:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661461386; x=1692997386;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=0kFSM/ObsRxI/bUcact1Od1NFHGl1HuB3KhNST+eozY=;
  b=jAlEG6RHiJXflLoqp8AK8wIC6hTNqVgpTlkQVTYDahU4t49GjAVTX6HQ
   U/rnlVIqsF5I47gS9wZ1D7kElOD5kLKKYu5rF50XC6hXlTn068pzpYlO0
   ZlyER6D0ilmMHQIY/Vvm5rJyBEj4oWFbblzRz3k3DNSLSPlSjZ/Dr4KfA
   pcUqA6+5FkG/vb2cwtP4r5ozQNhyzB9J/Y9+umtAueetQJ+Q/SZ5mmfDR
   Hv2NmaeNOV+BUjNLX44CrwAavIUUZ2b8zcJvJvbawKwd1FqriH03yHYrI
   UyfIKL8DedmmUrNabMbg1LUVbmE5anSEY2yydJNjIfXftwxJeDQG0Y0cy
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10450"; a="274750361"
X-IronPort-AV: E=Sophos;i="5.93,264,1654585200"; 
   d="scan'208";a="274750361"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2022 14:03:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,264,1654585200"; 
   d="scan'208";a="678614824"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga004.fm.intel.com with ESMTP; 25 Aug 2022 14:03:06 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 25 Aug 2022 14:03:05 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 25 Aug 2022 14:03:05 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 25 Aug 2022 14:03:05 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 25 Aug 2022 14:03:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g4G0PMHY+UwGVHxhHI1aixiQ5XR2W9Mx0sfK2LrNO1tIEu2XWtseFqibb6GQ5QNzarklCo77VHK9kOWZTrkJmrl+sNV87mdzXh01iGhNEkfMrxJbcgOEPg2S3XhnwqJ9GlAUQQMuO2OcS2rz8EGwEu84Qv3ljbb2xtglGpcy6wOc1e/CYks6KpnnSNgydj2G6QF915yljXlzyVIzHuTWi7JMBPeDDHNEiAxXHhyrjkUzbwi5YbBvnR+Z45fRoQXn3KD2PxQFN/unghEhcq/m1Ce/ZBtW+Q6m+8ZhX8V9vCs1ukZWnNwpFtcrwMERdLe4u8ANu1gVjhENTSkJnXd17Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fx4G1uTcnT7SZ4jlf5U+1Q2MTK5kpvGQ355MQNfsUFE=;
 b=CrvaMDhFRP3V81a4rzjC7AJQGL64djX/CnaBv3+2wQRejPGkQDQHudGkJZIC3icBtTsUI5DGcqQy6ybHmjKRDn34RCe29j3zyKwUK9wElgIVnRneA3/k1jSdO3jaS+gHb/eCFGFtLfxWMlKXaAUKg3q20raCRaUccCoD2WdLS/b+oXFEPjgr8gImQDgiuA3idVPQSuo/tV/a7bspwThnzRUw+LybFimCzdm3D3oyNXKr4Mmqs4vn6dF1PuzMXlXeFdinWr98vf9mtehubaIMWNkUQGU4cF/isUK6bcKMaGQELh9dELLYq5vFvt+U0Lkb3jUpIGvs43dh6mR9eXVNfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by SJ0PR11MB5615.namprd11.prod.outlook.com (2603:10b6:a03:305::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.14; Thu, 25 Aug
 2022 21:03:02 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::2896:319b:82a1:a4d0]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::2896:319b:82a1:a4d0%4]) with mapi id 15.20.5566.015; Thu, 25 Aug 2022
 21:03:02 +0000
Date:   Thu, 25 Aug 2022 14:02:58 -0700
From:   Ira Weiny <ira.weiny@intel.com>
To:     Dave Jiang <dave.jiang@intel.com>
CC:     Steven Rostedt <rostedt@goodmis.org>,
        <linux-trace-devel@vger.kernel.org>
Subject: Re: retrieving non-numeral fields from an event record
Message-ID: <YwfjguS0tXgyDGcB@iweiny-desk3>
References: <05cf09cd-65e8-be5d-758a-0164a49d7b0e@intel.com>
 <20220822181810.1f181ff7@gandalf.local.home>
 <2136c94a-a4ab-599b-a731-609a71c71e37@intel.com>
 <20220822182745.059c3558@gandalf.local.home>
 <353dfc04-63f8-bacb-f4bb-b9ec70083125@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <353dfc04-63f8-bacb-f4bb-b9ec70083125@intel.com>
X-ClientProxiedBy: BYAPR07CA0079.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::20) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a81a84a0-0df6-46e4-0e71-08da86dd32aa
X-MS-TrafficTypeDiagnostic: SJ0PR11MB5615:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QPPA79G8oVuFtoCDWlJvtFWSKw4tWdZGIcooCvB36GKldO4OZjw8rey+dyjJVOlMRYEWwGBpZv3wZxvrvWDo6M9Oc3nNK+wKszqgelUFfXtwPtDUtcWWEnmQP6QxwVZ/779oJOgiq9s+PLAVSs6IR+MdxeXfcgRTSSUyurbo52fHzNQ8xNQ3/49/l1oGuYNmQR8jOZDYMj/FMyDdD1wfBzbTc0MYkNkBvCKu51mRFaBLurx8b2rzgon/TosEgxnjl5gBL7Iw3zkc/YW+xifrrDyihmdR99fLp5HIsdRi//+ALeyKclKm1xsJApM7Dz8JMaaSQ7XKcm9Y+kpvWszm+WSA8cgPapCknCNUXMJYiY6QDzfwQJq/ThelPMK+rjH/tVbwmIms29QnpoABikj7iMEuq/SN12oIPlAmoIGmm6XQDgQayC9qN9f+fHtEuEfBmtLgKm5SaZoX7rmhYeSOlcar2EWHlTTfMbwdlU1XU/oL1LO4SvXcwKqYmbEmUnLnSWZhxYbEscGu0Ur0qT1dYIP7+yixr7srbAI20xqa8WbxiHZM1cX67qeTuvF/C0jv2JbPDqzhf3oU9hhG9EWegLZYdd9LnPJfi5dzJrIBu5OGJKCSpIlRpTBcDSTA0bjkNGgssta1E2dx3mUsAbw3DvDpk7cWujxjIDil4JPUknIQh3SHAoJwuLfxUbWp7ip42i5LGXykaNx3yYUMKYBQYWiQLXtTFYbfLax2hPde4dVH1O/DjKQDKbNqrf38KRtcCYBbYCLv7g6/qnwSOpwPLA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(396003)(366004)(376002)(136003)(39860400002)(346002)(66556008)(8936002)(38100700002)(66476007)(8676002)(66946007)(6862004)(83380400001)(5660300002)(82960400001)(44832011)(41300700001)(4326008)(316002)(478600001)(53546011)(86362001)(6486002)(6636002)(186003)(33716001)(6666004)(2906002)(26005)(6512007)(6506007)(9686003)(505234007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cCWvkwGOkxuxjYZfE+tavYrHUlFX+WNObHM4cQZL6L/QSAP4O0KgI0/+vHrk?=
 =?us-ascii?Q?sSp796hHsijVZ5rh2MYdTbmXEc98JP4j4XwhE/vDs+8UmpLbObnCo2cTnvdv?=
 =?us-ascii?Q?2J9CFgbqLAox6eTfnJWgA2T/4mI0UObNeio5u/sHdWVYtUfMgDBFTuOyBHz9?=
 =?us-ascii?Q?RcX7G3Sq4mXGzyWSX+AZaKtQ1PLSCQOoRIfYmkAc6Dl6Fo1cjjI1ctOMNDGz?=
 =?us-ascii?Q?Uek6IplVf65ouiuTjIh23K6/Z4ve0Qd/D454TijjzrZeaipjemSIYVXA6nt8?=
 =?us-ascii?Q?QL5vVY6Mc6Pwz49hmn3UGSB0bnZ20ATN7iGmIZQsOmnplByst7zlCq4Y3Seh?=
 =?us-ascii?Q?VenCZv6jhdacZf/++v/riBgY3TpyaZopit3srwMQ3/20a58Fq0ntIc3hdP8K?=
 =?us-ascii?Q?mh+dlJ4mt8qstoyE+iKSrr8dp7DUPXEMCDcgKRIWEMZCk+t2aeUG2ev/evvO?=
 =?us-ascii?Q?7FntTT0OJL/WL+89elsDKGXbZAyKxICb0l4KhT3KaEnHpLhRWgXe7k9M2SDG?=
 =?us-ascii?Q?mJvNplPOINq0kygewTfx6ekftO3uNp5KlxlN1dXf96yD8CCLJksj60SoDZEf?=
 =?us-ascii?Q?+ImU0W7uifKlm28k6bFVOlCSJHP+fa2S7IoNRvMFyfZPVM8IWCXwfrAU5dnG?=
 =?us-ascii?Q?2PplZnhhRvmeMQlwTrf4rbMihJ783jALwGfMUXaSY75rAxPyA2wI1Ah0Bxey?=
 =?us-ascii?Q?oWeJs7zQ4sdSvtuZCNdNrCCQkI6WTbp9tmddKoXGwIvwvlJJ8br9ErQPjCHy?=
 =?us-ascii?Q?qUhkZGk97h/UxVmh/C4upSAPnyOCRVFq6dGysJyPh/bM9MOd8oEWi+WUFFrK?=
 =?us-ascii?Q?h/auIFKzpitchZOHmwna70liekTbfZpH7jaiJk3XgsJMhurM7xaQU9CSngYd?=
 =?us-ascii?Q?ttHBpAKr9wV3CS1798Du4Z/gwyZRdW1PBWJ246C4hqMKiOfVrydRCgiZGFNW?=
 =?us-ascii?Q?rIj4m3164WK2ol9AdrQnz9ff2C2LIJzYbxs/YvoVgJEOw1pse7WGMyvdW2nu?=
 =?us-ascii?Q?8mE8Ww8TvuVL1qolgDlAZXFBMdfmOTGRek8+2sfSkmUNS+42+0Ipq+n7VHl/?=
 =?us-ascii?Q?3AxtX/aKMVm1HL4iBq+hgns127GpZUjYnQUbKtO9BohUARku1Mf1LnUxckHY?=
 =?us-ascii?Q?ifJ8+uqK8VkHPKGm2DNk2oc+E40FLzXJL/g14XwCYyJvSToYtV7BMNT15neh?=
 =?us-ascii?Q?JyaMtZkdwbxG6ZQN5gmsK+GtuHoqOwdN5Ch0xWUGoXjgIG3vWuC5Lq31KdJj?=
 =?us-ascii?Q?AhaWPsrkl/idLdJwpzfGOJM+wBxvj13oHyOay1hlpfz++4HfamV3PuJVu4I6?=
 =?us-ascii?Q?WaQdOnvCFagSScXx9K1lsX3jprLR6RxSXMeQ/sF661BuoQ/BIhtWdJ8W08tG?=
 =?us-ascii?Q?fwYuN04Bqhc2Ol0GAu5sLwwq1vbwRvMEwz3LaYiY1gFPMMoNTg5hWbk1+etf?=
 =?us-ascii?Q?Z4BDpGrAepm5M1klp1f5YIOiAuxD1tJQ8mhx/F/XVDwNdMzGalpAR9njxHbJ?=
 =?us-ascii?Q?5CHVLLfBL/PxUI0I1IfhT5rcr/eIajyElpL3lV1B/JeNzzEJTEjEt3aKlKaz?=
 =?us-ascii?Q?OqGVViWdxXdisIihzU+4BDPQHvn0oNh5nY4UcnqQ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a81a84a0-0df6-46e4-0e71-08da86dd32aa
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2022 21:03:02.3829
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lPrrb2irMk12X/hX5lLwp1yWhsJn9IdCAMuP7hdvQzx4KHmrsCK70SVhrlZ8TdJ0Dnyve1VTiXzdTfKdkFWP4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5615
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Aug 22, 2022 at 03:33:26PM -0700, Jiang, Dave wrote:
> 
> On 8/22/2022 3:27 PM, Steven Rostedt wrote:
> > On Mon, 22 Aug 2022 15:21:01 -0700
> > Dave Jiang <dave.jiang@intel.com> wrote:
> > 
> > > On 8/22/2022 3:18 PM, Steven Rostedt wrote:
> > > > On Mon, 22 Aug 2022 14:48:30 -0700
> > > > Dave Jiang <dave.jiang@intel.com> wrote:
> > > > > Attempting to use libtraceevent to retrieve fields from events. For example here's the event I'm trying to parse:
> > > > > 
> > > > >     check-events.sh-5983    [002] ..... 261848.250238: cxl_dram_event: cxl_mem.7: Fatal time=0 id=b3cb1
> > > > > d60-069c-ab4e-b8af-4e9bfb5c9624 handle=1 related_handle=0 hdr_flags='Performance Degraded': phys_add
> > > > > r=8000 volatile=FALSE desc='Threshold event' type='Invalid Address' trans_type='Internal Media Scrub
> > > > > ' channel=1 rank=0 nibble_mask=0 bank_group=5 bank=2 row=0 column=1024 cor_mask=00 00 00 00 00 00 00
> > > > >     00 00 00 00 00 00 00 00 0000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 valid_flags='CHANNEL|BANK
> > > > >     GROUP|BANK|COLUMN'
> > > > > 
> > > > > Here's me iterating through all the fields and using tep_get_field_raw() trying to retrieve the fields. It appears that
> > > > > if the field is a string type I'm not able to retrieve the field and the error written back in the seq file is
> > > > > "CANT FIND FIELD". Am I doing something wrong or using the wrong API to retrieve those type of fields?
> > > > What's the format for this event? That is, what is the output of :
> > > > 
> > > >    trace-cmd list -e cxl_dram_event -F
> > > > 
> > > > ?
> > > #trace-cmd list -e cxl_dram_event -F
> > > system: cxl_events
> > > name: cxl_dram_event
> > > ID: 2325
> > > format:
> > >           field:unsigned short common_type;       offset:0;       size:2; signed:0;
> > >           field:unsigned char common_flags;       offset:2;       size:1; signed:0;
> > >           field:unsigned char common_preempt_count;       offset:3;       size:1; signed:0;
> > >           field:int common_pid;   offset:4;       size:4; signed:1;
> > > 
> > >           field:__data_loc char[] dev_name;       offset:8;       size:4; signed:1;
> > >           field:int log;  offset:12;      size:4; signed:1;
> > >           field:u8 id[16];        offset:16;      size:16;        signed:0;
> > >           field:u32 flags;        offset:32;      size:4; signed:0;
> > >           field:u16 handle;       offset:36;      size:2; signed:0;
> > >           field:u16 related_handle;       offset:38;      size:2; signed:0;
> > >           field:u64 timestamp;    offset:40;      size:8; signed:0;
> > >           field:u64 phys_addr;    offset:48;      size:8; signed:0;
> > >           field:u8 descriptor;    offset:56;      size:1; signed:0;
> > >           field:u8 type;  offset:57;      size:1; signed:0;
> > >           field:u8 transaction_type;      offset:58;      size:1; signed:0;
> > >           field:u8 channel;       offset:59;      size:1; signed:0;
> > >           field:u16 validity_flags;       offset:60;      size:2; signed:0;
> > >           field:u16 column;       offset:62;      size:2; signed:0;
> > >           field:u32 nibble_mask;  offset:64;      size:4; signed:0;
> > >           field:u32 row;  offset:68;      size:4; signed:0;
> > >           field:u8 cor_mask[0x20];        offset:72;      size:32;        signed:0;
> > >           field:u8 rank;  offset:104;     size:1; signed:0;
> > >           field:u8 bank_group;    offset:105;     size:1; signed:0;
> > >           field:u8 bank;  offset:106;     size:1; signed:0;
> > The above are the fields you need. If you want to see how they are
> > formatted in the output, you can add "--full" to the above command and
> > you'll see a "printf" like format.
> > 
> > 
> > Your output you showed in the previous email had:
> > 
> > > failed to get field: time
> > > <CANT FIND FIELD time>
> > There's no field "time" above.
> > 
> > > got field: id, len: 16
> > > got field: handle, len: 2
> > > got field: related_handle, len: 2
> > > failed to get field: hdr_flags
> > > <CANT FIND FIELD hdr_flags>
> > Same for "hdr_flags"
> > 
> > > got field: phys_addr, len: 8
> > > failed to get field: volatile
> > > <CANT FIND FIELD volatile>
> > And "volatile"
> > 
> > > failed to get field: desc
> > > <CANT FIND FIELD desc>
> > etc.
> > 
> > > got field: type, len: 1
> > > failed to get field: trans_type
> > > <CANT FIND FIELD trans_type>
> > etc.
> > 
> > 
> > > got field: channel, len: 1
> > > got field: rank, len: 1
> > > got field: nibble_mask, len: 4
> > > got field: bank_group, len: 1
> > > got field: bank, len: 1
> > > got field: row, len: 4
> > > got field: column, len: 2
> > > got field: cor_mask, len: 32
> > > failed to get field: valid_flags
> > > <CANT FIND FIELD valid_flags>
> > etc.
> > 
> > 
> > The field names are from the above format, not what you see in the output
> > of the event.
> 
> Ok that makes sense. Thanks for the help!

Not sure how I missed this thread.  But sounds like for consistency the printk
format should match these field names.

I'll add that to the list of cleanup.

Ira
