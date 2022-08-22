Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDBD5C28D13
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Aug 2022 22:17:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238013AbiHVWR7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Aug 2022 18:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238346AbiHVWR5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Aug 2022 18:17:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA9514B4AF
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Aug 2022 15:17:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97862B81982
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Aug 2022 22:17:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F29EBC433D6;
        Mon, 22 Aug 2022 22:17:53 +0000 (UTC)
Date:   Mon, 22 Aug 2022 18:18:10 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Dave Jiang <dave.jiang@intel.com>
Cc:     linux-trace-devel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>
Subject: Re: retrieving non-numeral fields from an event record
Message-ID: <20220822181810.1f181ff7@gandalf.local.home>
In-Reply-To: <05cf09cd-65e8-be5d-758a-0164a49d7b0e@intel.com>
References: <05cf09cd-65e8-be5d-758a-0164a49d7b0e@intel.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 22 Aug 2022 14:48:30 -0700
Dave Jiang <dave.jiang@intel.com> wrote:

> Attempting to use libtraceevent to retrieve fields from events. For example here's the event I'm trying to parse:
> 
>   check-events.sh-5983    [002] ..... 261848.250238: cxl_dram_event: cxl_mem.7: Fatal time=0 id=b3cb1
> d60-069c-ab4e-b8af-4e9bfb5c9624 handle=1 related_handle=0 hdr_flags='Performance Degraded': phys_add
> r=8000 volatile=FALSE desc='Threshold event' type='Invalid Address' trans_type='Internal Media Scrub
> ' channel=1 rank=0 nibble_mask=0 bank_group=5 bank=2 row=0 column=1024 cor_mask=00 00 00 00 00 00 00
>   00 00 00 00 00 00 00 00 0000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 valid_flags='CHANNEL|BANK
>   GROUP|BANK|COLUMN'
> 
> Here's me iterating through all the fields and using tep_get_field_raw() trying to retrieve the fields. It appears that
> if the field is a string type I'm not able to retrieve the field and the error written back in the seq file is
> "CANT FIND FIELD". Am I doing something wrong or using the wrong API to retrieve those type of fields?
> 

What's the format for this event? That is, what is the output of :

 trace-cmd list -e cxl_dram_event -F

?

As what gets show in the output may not actually match the fields that are
saved in the raw event.

-- Steve
