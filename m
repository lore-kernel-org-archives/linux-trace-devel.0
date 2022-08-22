Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A5B2C28D13
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Aug 2022 22:21:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238143AbiHVWVE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Aug 2022 18:21:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231466AbiHVWVD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Aug 2022 18:21:03 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02FEE4D26A
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Aug 2022 15:21:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661206863; x=1692742863;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=k2D5LI/VWVto/7oVhVPoloeZ8eKGFdK7cqn7wcQvyWA=;
  b=mG9E+ww5DgGzJ4nkh00HqzH2Nac0DJ9xj4MXnYTm4fYTT+HPr9j6EQ7x
   nMCnjwWmLy1pcRnwqUNG0DKTyR/ICePEMM5J2zGdJCSRBwLcZnoVVcGc/
   bmYrR8skiR2j5CHy4Xa1/qlwy1cnEPlyvSuH20gToCryBoN9KifIPV+2c
   G0rVBMNhgPXbhjt9EqyStGW4kB/YFJogd1hGXxg9WW3yLgCiwGhMpsbJF
   JTE58grZMfJLpZe33FyU40j0z3iZJOcAw89CgxbYeiP1v/mkh/uhRRhAr
   fKGVMpyRqr37po307/X9vi33h5ZxCD6Rzye5M97PNeu4nLjDKyMhaHFH5
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10447"; a="280506594"
X-IronPort-AV: E=Sophos;i="5.93,255,1654585200"; 
   d="scan'208";a="280506594"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2022 15:21:02 -0700
X-IronPort-AV: E=Sophos;i="5.93,255,1654585200"; 
   d="scan'208";a="698447688"
Received: from djiang5-mobl1.amr.corp.intel.com (HELO [10.212.127.248]) ([10.212.127.248])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2022 15:21:02 -0700
Message-ID: <2136c94a-a4ab-599b-a731-609a71c71e37@intel.com>
Date:   Mon, 22 Aug 2022 15:21:01 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.12.0
Subject: Re: retrieving non-numeral fields from an event record
Content-Language: en-US
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>
References: <05cf09cd-65e8-be5d-758a-0164a49d7b0e@intel.com>
 <20220822181810.1f181ff7@gandalf.local.home>
From:   Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20220822181810.1f181ff7@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


On 8/22/2022 3:18 PM, Steven Rostedt wrote:
> On Mon, 22 Aug 2022 14:48:30 -0700
> Dave Jiang <dave.jiang@intel.com> wrote:
>
>> Attempting to use libtraceevent to retrieve fields from events. For example here's the event I'm trying to parse:
>>
>>    check-events.sh-5983    [002] ..... 261848.250238: cxl_dram_event: cxl_mem.7: Fatal time=0 id=b3cb1
>> d60-069c-ab4e-b8af-4e9bfb5c9624 handle=1 related_handle=0 hdr_flags='Performance Degraded': phys_add
>> r=8000 volatile=FALSE desc='Threshold event' type='Invalid Address' trans_type='Internal Media Scrub
>> ' channel=1 rank=0 nibble_mask=0 bank_group=5 bank=2 row=0 column=1024 cor_mask=00 00 00 00 00 00 00
>>    00 00 00 00 00 00 00 00 0000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 valid_flags='CHANNEL|BANK
>>    GROUP|BANK|COLUMN'
>>
>> Here's me iterating through all the fields and using tep_get_field_raw() trying to retrieve the fields. It appears that
>> if the field is a string type I'm not able to retrieve the field and the error written back in the seq file is
>> "CANT FIND FIELD". Am I doing something wrong or using the wrong API to retrieve those type of fields?
>>
> What's the format for this event? That is, what is the output of :
>
>   trace-cmd list -e cxl_dram_event -F
>
> ?

#trace-cmd list -e cxl_dram_event -F
system: cxl_events
name: cxl_dram_event
ID: 2325
format:
         field:unsigned short common_type;       offset:0;       size:2; signed:0;
         field:unsigned char common_flags;       offset:2;       size:1; signed:0;
         field:unsigned char common_preempt_count;       offset:3;       size:1; signed:0;
         field:int common_pid;   offset:4;       size:4; signed:1;

         field:__data_loc char[] dev_name;       offset:8;       size:4; signed:1;
         field:int log;  offset:12;      size:4; signed:1;
         field:u8 id[16];        offset:16;      size:16;        signed:0;
         field:u32 flags;        offset:32;      size:4; signed:0;
         field:u16 handle;       offset:36;      size:2; signed:0;
         field:u16 related_handle;       offset:38;      size:2; signed:0;
         field:u64 timestamp;    offset:40;      size:8; signed:0;
         field:u64 phys_addr;    offset:48;      size:8; signed:0;
         field:u8 descriptor;    offset:56;      size:1; signed:0;
         field:u8 type;  offset:57;      size:1; signed:0;
         field:u8 transaction_type;      offset:58;      size:1; signed:0;
         field:u8 channel;       offset:59;      size:1; signed:0;
         field:u16 validity_flags;       offset:60;      size:2; signed:0;
         field:u16 column;       offset:62;      size:2; signed:0;
         field:u32 nibble_mask;  offset:64;      size:4; signed:0;
         field:u32 row;  offset:68;      size:4; signed:0;
         field:u8 cor_mask[0x20];        offset:72;      size:32;        signed:0;
         field:u8 rank;  offset:104;     size:1; signed:0;
         field:u8 bank_group;    offset:105;     size:1; signed:0;
         field:u8 bank;  offset:106;     size:1; signed:0;



>
> As what gets show in the output may not actually match the fields that are
> saved in the raw event.
>
> -- Steve
