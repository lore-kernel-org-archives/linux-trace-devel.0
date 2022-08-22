Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E731AC28D13
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Aug 2022 22:33:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbiHVWdq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Aug 2022 18:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238413AbiHVWdq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Aug 2022 18:33:46 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC08E09B
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Aug 2022 15:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661207624; x=1692743624;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=tSizHnjhPWmEq2y/7fMRkpdJ9TCVlKtcmQfX69sx3p0=;
  b=dVDs09isTpHxA7A2RBS+iWpVdtlHcmmxCG8fVamASH/olW9CG3+shaFZ
   U7lqhFGefxw5tKNnGsa1agjJ+SjnIwGq8MOyVLsHQiKcvLcMWt2nm13Iu
   L0qVGW8A/PJM/msapNzi0VvDVQbwnOnF7Nj31jdDNX41iDY5EQ4wKb8VM
   io9YHUw3nh1VJUDo8nAMu8T64yQP0BXmL4h6ut83Br6P4KM/5o3S70zdv
   fQyOcusrJ6pF4qlcH/58fNpG2OT9+IhXbK94StBD1FQzLe/1sWPGAHz6B
   q/KqE+r146dmJv4m4lve5HP5k+BzxrAgTvYtZzBIf4C2p5Zmoj8n29LF5
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10447"; a="355266937"
X-IronPort-AV: E=Sophos;i="5.93,255,1654585200"; 
   d="scan'208";a="355266937"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2022 15:33:27 -0700
X-IronPort-AV: E=Sophos;i="5.93,255,1654585200"; 
   d="scan'208";a="698451076"
Received: from djiang5-mobl1.amr.corp.intel.com (HELO [10.212.127.248]) ([10.212.127.248])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2022 15:33:27 -0700
Message-ID: <353dfc04-63f8-bacb-f4bb-b9ec70083125@intel.com>
Date:   Mon, 22 Aug 2022 15:33:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.12.0
Subject: Re: retrieving non-numeral fields from an event record
Content-Language: en-US
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>
References: <05cf09cd-65e8-be5d-758a-0164a49d7b0e@intel.com>
 <20220822181810.1f181ff7@gandalf.local.home>
 <2136c94a-a4ab-599b-a731-609a71c71e37@intel.com>
 <20220822182745.059c3558@gandalf.local.home>
From:   Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20220822182745.059c3558@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


On 8/22/2022 3:27 PM, Steven Rostedt wrote:
> On Mon, 22 Aug 2022 15:21:01 -0700
> Dave Jiang <dave.jiang@intel.com> wrote:
>
>> On 8/22/2022 3:18 PM, Steven Rostedt wrote:
>>> On Mon, 22 Aug 2022 14:48:30 -0700
>>> Dave Jiang <dave.jiang@intel.com> wrote:
>>>   
>>>> Attempting to use libtraceevent to retrieve fields from events. For example here's the event I'm trying to parse:
>>>>
>>>>     check-events.sh-5983    [002] ..... 261848.250238: cxl_dram_event: cxl_mem.7: Fatal time=0 id=b3cb1
>>>> d60-069c-ab4e-b8af-4e9bfb5c9624 handle=1 related_handle=0 hdr_flags='Performance Degraded': phys_add
>>>> r=8000 volatile=FALSE desc='Threshold event' type='Invalid Address' trans_type='Internal Media Scrub
>>>> ' channel=1 rank=0 nibble_mask=0 bank_group=5 bank=2 row=0 column=1024 cor_mask=00 00 00 00 00 00 00
>>>>     00 00 00 00 00 00 00 00 0000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 valid_flags='CHANNEL|BANK
>>>>     GROUP|BANK|COLUMN'
>>>>
>>>> Here's me iterating through all the fields and using tep_get_field_raw() trying to retrieve the fields. It appears that
>>>> if the field is a string type I'm not able to retrieve the field and the error written back in the seq file is
>>>> "CANT FIND FIELD". Am I doing something wrong or using the wrong API to retrieve those type of fields?
>>>>   
>>> What's the format for this event? That is, what is the output of :
>>>
>>>    trace-cmd list -e cxl_dram_event -F
>>>
>>> ?
>> #trace-cmd list -e cxl_dram_event -F
>> system: cxl_events
>> name: cxl_dram_event
>> ID: 2325
>> format:
>>           field:unsigned short common_type;       offset:0;       size:2; signed:0;
>>           field:unsigned char common_flags;       offset:2;       size:1; signed:0;
>>           field:unsigned char common_preempt_count;       offset:3;       size:1; signed:0;
>>           field:int common_pid;   offset:4;       size:4; signed:1;
>>
>>           field:__data_loc char[] dev_name;       offset:8;       size:4; signed:1;
>>           field:int log;  offset:12;      size:4; signed:1;
>>           field:u8 id[16];        offset:16;      size:16;        signed:0;
>>           field:u32 flags;        offset:32;      size:4; signed:0;
>>           field:u16 handle;       offset:36;      size:2; signed:0;
>>           field:u16 related_handle;       offset:38;      size:2; signed:0;
>>           field:u64 timestamp;    offset:40;      size:8; signed:0;
>>           field:u64 phys_addr;    offset:48;      size:8; signed:0;
>>           field:u8 descriptor;    offset:56;      size:1; signed:0;
>>           field:u8 type;  offset:57;      size:1; signed:0;
>>           field:u8 transaction_type;      offset:58;      size:1; signed:0;
>>           field:u8 channel;       offset:59;      size:1; signed:0;
>>           field:u16 validity_flags;       offset:60;      size:2; signed:0;
>>           field:u16 column;       offset:62;      size:2; signed:0;
>>           field:u32 nibble_mask;  offset:64;      size:4; signed:0;
>>           field:u32 row;  offset:68;      size:4; signed:0;
>>           field:u8 cor_mask[0x20];        offset:72;      size:32;        signed:0;
>>           field:u8 rank;  offset:104;     size:1; signed:0;
>>           field:u8 bank_group;    offset:105;     size:1; signed:0;
>>           field:u8 bank;  offset:106;     size:1; signed:0;
> The above are the fields you need. If you want to see how they are
> formatted in the output, you can add "--full" to the above command and
> you'll see a "printf" like format.
>
>
> Your output you showed in the previous email had:
>
>> failed to get field: time
>> <CANT FIND FIELD time>
> There's no field "time" above.
>
>> got field: id, len: 16
>> got field: handle, len: 2
>> got field: related_handle, len: 2
>> failed to get field: hdr_flags
>> <CANT FIND FIELD hdr_flags>
> Same for "hdr_flags"
>
>> got field: phys_addr, len: 8
>> failed to get field: volatile
>> <CANT FIND FIELD volatile>
> And "volatile"
>
>> failed to get field: desc
>> <CANT FIND FIELD desc>
> etc.
>
>> got field: type, len: 1
>> failed to get field: trans_type
>> <CANT FIND FIELD trans_type>
> etc.
>
>
>> got field: channel, len: 1
>> got field: rank, len: 1
>> got field: nibble_mask, len: 4
>> got field: bank_group, len: 1
>> got field: bank, len: 1
>> got field: row, len: 4
>> got field: column, len: 2
>> got field: cor_mask, len: 32
>> failed to get field: valid_flags
>> <CANT FIND FIELD valid_flags>
> etc.
>
>
> The field names are from the above format, not what you see in the output
> of the event.

Ok that makes sense. Thanks for the help!


>
> -- Steve
