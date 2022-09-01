Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73EFCECAAD3
	for <linux-trace-devel@archiver.kernel.org>; Thu,  1 Sep 2022 14:07:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232830AbiIAOHD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 1 Sep 2022 10:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbiIAOHC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 1 Sep 2022 10:07:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07ED310FE;
        Thu,  1 Sep 2022 07:07:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7860B826DB;
        Thu,  1 Sep 2022 14:06:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4EC8C433D6;
        Thu,  1 Sep 2022 14:06:57 +0000 (UTC)
Date:   Thu, 1 Sep 2022 10:07:28 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Michael Petlan <mpetlan@redhat.com>,
        "linux-trace-users@vger.kernel.org" 
        <linux-trace-users@vger.kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: libtraceevent -- undefined functions
Message-ID: <20220901100728.54562054@gandalf.local.home>
In-Reply-To: <alpine.LRH.2.20.2208301214410.12613@Diego>
References: <alpine.LRH.2.20.2208301214410.12613@Diego>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


[ This is helpful information for trace users and developers so I've
  included the two lists ]

On Tue, 30 Aug 2022 12:59:46 +0200 (CEST)
Michael Petlan <mpetlan@redhat.com> wrote:

> Hello Steve,
> 
> during perf testing, I have found out that the print formats of some tracepoints
> are translated to quite complicated code, that differs per architecture and quite
> often contains various builtins and functions that are not recognized by the parser
> in libtraceevent.
> 
> It looks like this:
> 
> [root@gigabyte-r120-03 base_kmem]# perf kmem --page record -o ./perf.data -- true
> libtraceevent: No such file or directory
>   [kmem:mm_page_alloc] function __builtin_constant_p not defined
>   [kmem:mm_page_free] function __builtin_constant_p not defined
> 
> I have digged down to event-parse.c source and commits like 1b20d9491cf9 ("tools
> lib traceevent: Add handler for __builtin_expect()") that add some missing func
> support.
> 
> I have added __builtin_constant_p, it helped to suppress the warning, but then
> I found out I was missing sizeof()...
> 
> On an x86_64 F35 machine, I have found the following list of missing funcs:
>  __builtin_choose_expr
>  decode_prq_descriptor
>  jiffies_to_msecs
>  libata_trace_parse_eh_action
>  libata_trace_parse_host_stat
>  libata_trace_parse_qc_flags
>  libata_trace_parse_subcmd
>  libata_trace_parse_tf_flags
>  mc_event_error_type
>  pgd_val
>  pmd_val
>  pte_val
>  pud_val
>  scsi_trace_parse_cdb
>  sizeof

The problem with a lot of the above is that user space does not know how to
parse them. "jiffies_to_msecs" depends on knowing the HZ value. Now if the
kernel exported this, we could look for it and save this information, and
then be able to parse it correctly.

>  xen_hypercall_name
>  xhci_decode_ctrl_ctx
>  xhci_decode_doorbell
>  xhci_decode_ep_context
>  xhci_decode_portsc
>  xhci_decode_slot_context
>  xhci_ring_type_string
> 
> There are of course more, since on other platforms, the print format expands to
> different code.
> 
> I wonder, whether it might be useful to add these functions to libtraceevent
> parser. Finally, what is the purpose of the handlers, such as __builtin_expect()
> you have added? It looks like that the parser machine now accepts this token and
> handles that it has to have two parameters, but does nothing more with it. It
> lets the parser to dive deeper and process the first arg and forgets the second,
> just like replacing
>   __builtin_expect( exp, c)
> by
>   exp
> so when something executes the code, it ignores the builtin? Am I right?

Correct. As __builtin_expect() is just a compile time optimization that
"likely()" and "unlikely()" are defined to, it has no meaning to the
parser. But we still want the contents of the expression.

I had to update libtraceevent to basically ignore the __builtin_expect().

That is, "unlikely(cond)" turns into "!!__builtin_exepect(cond, 0)"

libtraceevent does not care about the "unlikely()" part, only the
condition, so the parser basically treats it the same:

  "unlikely(cond)" == "cond"

> 
> The __builtin_constant_p(arg) should decide whether arg is constant or not and
> return 1 or 0 respectively...
> 

What is using __builting_constant_p() inside the TP_printk()?

> My questions are:
>    1) Does it matther whether or not the above functions are accepted by the parser
>    grammar or not?

When it can't parse something, it falls back to just printing out the raw
fields the best it can.

>    2) Does (1) affect how the code is later executed somewhere?

It affects how it prints the event. It then ignores the TP_printk() format,
and then, as mentioned above, just prints the raw fields.

>    3) Would e.g. replacing __builtin_constant_p(arg) by 0 by default help/simplify
>    anything?

I have to see how it's used. What event does that?

-- Steve
