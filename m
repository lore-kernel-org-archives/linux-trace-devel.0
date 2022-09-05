Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1A54ECAAD5
	for <linux-trace-devel@archiver.kernel.org>; Mon,  5 Sep 2022 16:28:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231523AbiIEQ2v (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 5 Sep 2022 12:28:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiIEQ2u (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 5 Sep 2022 12:28:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73265264;
        Mon,  5 Sep 2022 09:28:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0DD7B61344;
        Mon,  5 Sep 2022 16:28:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0316BC433C1;
        Mon,  5 Sep 2022 16:28:46 +0000 (UTC)
Date:   Mon, 5 Sep 2022 12:29:16 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Michael Petlan <mpetlan@redhat.com>
Cc:     "linux-trace-users@vger.kernel.org" 
        <linux-trace-users@vger.kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: libtraceevent -- undefined functions
Message-ID: <20220905122916.76f4abce@gandalf.local.home>
In-Reply-To: <alpine.LRH.2.20.2209051707130.12613@Diego>
References: <alpine.LRH.2.20.2208301214410.12613@Diego>
        <20220901100728.54562054@gandalf.local.home>
        <alpine.LRH.2.20.2209051707130.12613@Diego>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 5 Sep 2022 17:36:28 +0200 (CEST)
Michael Petlan <mpetlan@redhat.com> wrote:
> > 
> > The problem with a lot of the above is that user space does not know how to
> > parse them. "jiffies_to_msecs" depends on knowing the HZ value. Now if the
> > kernel exported this, we could look for it and save this information, and
> > then be able to parse it correctly.  
> 
> Well, under the term "parse" I understand "to verify, whether the tokens
> match the grammar" (i.e. that a function name has to be followed by '(' and
> ')' characters, that there have to be e.g. two args, separated by ',' etc.
> 
> By adding __builtin_expect support, you have added exactly this --> it now
> knows the function, but does nothing around it.

The difference is that one is an optimization for the compiler, where the
output will always be the same. The other changes what the value will be
depending on what the kernel HZ is.

I chose to fail parsing if we cannot prove that the output has integrity.

> 
> Then it comes to interpreting the code, that is also done in libtraceevent,
> isn't it? Does the parser produce some intermediate rep? What code performs
> the interpretation?
> 

> > 
> > Correct. As __builtin_expect() is just a compile time optimization that
> > "likely()" and "unlikely()" are defined to, it has no meaning to the
> > parser. But we still want the contents of the expression.
> > 
> > I had to update libtraceevent to basically ignore the __builtin_expect().
> > 
> > That is, "unlikely(cond)" turns into "!!__builtin_exepect(cond, 0)"
> > 
> > libtraceevent does not care about the "unlikely()" part, only the
> > condition, so the parser basically treats it the same:
> > 
> >   "unlikely(cond)" == "cond"  
> 
> Good, so I understood your approach correctly.
> >   
> > > 
> > > The __builtin_constant_p(arg) should decide whether arg is constant or not and
> > > return 1 or 0 respectively...
> > >   
> > 
> > What is using __builting_constant_p() inside the TP_printk()?  
> 
> There are several events. However, I don't know who takes the tracepoint description
> and generates the terribly complicated expression below.
> 
> >   
> > > My questions are:
> > >    1) Does it matther whether or not the above functions are accepted by the parser
> > >    grammar or not?  
> > 
> > When it can't parse something, it falls back to just printing out the raw
> > fields the best it can.
> >   
> > >    2) Does (1) affect how the code is later executed somewhere?  
> > 
> > It affects how it prints the event. It then ignores the TP_printk() format,
> > and then, as mentioned above, just prints the raw fields.  
> 
> OK, so if parsing does not fail, the code is interpreted by libtraceevent?

Correct.

> 
> In such case, the missing functions should be added or added as bypassed
> the similar way (e.g. __builtin_constant_p could be replaced by 0). Then,
> for example the sizeof should be accepted by the parser, but also interpreted
> correctly...

Now what we could do for undefined functions, is to keep the warning that
it doesn't know how to interpret it, but instead of failing to parse, to
instead show the function in the output:

For the event ata_qc_issue (the first one I found when doing a
"trace-cmd record -e all" that failed to parse):

It has in its TP_printk()

   libata_trace_parse_subcmd(p, REC->cmd, REC->feature, REC->hob_nsect)

We could convert that in the output where it has:

  print fmt: "ata_port=%u ata_dev=%u tag=%d proto=%s cmd=%s%s  tf=(%02x/%02x:%02x:%02x:%02x:%02x/%02x:%02x:%02x:%02x:%02x/%02x)"
                                                            ^
                                                            |
              libata_trace_parse_subcmd(p, REC->cmd, REC->feature, REC->hob_nsect)

Instead of printing:

sleep-47414 [006] 313119.147175: ata_qc_issue:         [FAILED TO PARSE] ata_port=1 ata_dev=0 tag=22 cmd=96 dev=64 lbal=24 lbam=69 lbah=253 nsect=176 feature=16 hob_lbal=2 hob_lbam=0 hob_lbah=0 hob_nsect=0 hob_feature=0 ctl=120 proto=6 flags=0x726f776b00000000


It could print:


sleep-47414 [006] 313119.147175: ata_qc_issue:         ata_port=1 ata_dev=0 tag=22 [..]libata_trace_parse_subcmd(p, cmd=96, feature=16, nob_nsect=0) [...]

And continue to parse everything else it understands.

> 
> > >    3) Would e.g. replacing __builtin_constant_p(arg) by 0 by default help/simplify
> > >    anything?  
> > 
> > I have to see how it's used. What event does that?  
> 
> This is aarch64, event mm_page_alloc, kernel is from RHEL-9, so 5.14:
> 
> print fmt: "page=%p pfn=0x%lx order=%d migratetype=%d gfp_flags=%s", REC->pfn != -1UL ? (((struct page *)(-((((1UL))) << ((48) - (12 - (( __builtin_constant_p(sizeof(struct page)) ? ( ((sizeof(struct page)) == 0 || (sizeof(struct page)) == 1) ? 0 : ( __builtin_constant_p((sizeof(struct page)) - 1) ? (((sizeof(struct page)) - 1) < 2 ? 0 : 63 - __builtin_clzll((sizeof(struct page)) - 1)) : (sizeof((sizeof(struct page)) - 1) <= 4) ? __ilog2_u32((sizeof(struct page)) - 1) : __ilog2_u64((sizeof(struct page)) - 1) ) + 1) : __order_base_2(sizeof(struct page)) )))))) - (memstart_addr >> 12)) + (REC->pfn)) : ((void *)0), REC->pfn != -1UL ? REC->pfn : 0, REC->order, REC->migratetype, (REC->gfp_flags) ? __print_flags(REC->gfp_flags, "|", {(unsigned long)(((((((( gfp_t)(0x400u|0x800u)) | (( gfp_t)0x40u) | (( gfp_t)0x80u) | (( gfp_t)0x100000u)) | (( gfp_t)0x02u)) | (( gfp_t)0x08u) | (( gfp_t)0x1000000u)) | (( gfp_t)0x40000u) | (( gfp_t)0x80000u) | (( gfp_t)0x2000u)) & ~(( gfp_t)(0x400u|0x800u))
 ) 
>  | (( gfp_t)0x400u)), "GFP_TRANSHUGE"}, {(unsigned long)((((((( gfp_t)(0x400u|0x800u)) | (( gfp_t)0x40u) | (( gfp_t)0x80u) | (( gfp_t)0x100000u)) | (( gfp_t)0x02u)) | (( gfp_t)0x08u) | (( gfp_t)0x1000000u)) | (( gfp_t)0x40000u) | (( gfp_t)0x80000u) | (( gfp_t)0x2000u)) & ~(( gfp_t)(0x400u|0x800u))), "GFP_TRANSHUGE_LIGHT"}, {(unsigned long)((((( gfp_t)(0x400u|0x800u)) | (( gfp_t)0x40u) | (( gfp_t)0x80u) | (( gfp_t)0x100000u)) | (( gfp_t)0x02u)) | (( gfp_t)0x08u) | (( gfp_t)0x1000000u)), "GFP_HIGHUSER_MOVABLE"}, {(unsigned long)(((( gfp_t)(0x400u|0x800u)) | (( gfp_t)0x40u) | (( gfp_t)0x80u) | (( gfp_t)0x100000u)) | (( gfp_t)0x02u)), "GFP_HIGHUSER"}, {(unsigned long)((( gfp_t)(0x400u|0x800u)) | (( gfp_t)0x40u) | (( gfp_t)0x80u) | (( gfp_t)0x100000u)), "GFP_USER"}, {(unsigned long)(((( gfp_t)(0x400u|0x800u)) | (( gfp_t)0x40u) | (( gfp_t)0x80u)) | (( gfp_t)0x400000u)), "GFP_KERNEL_ACCOUNT"}, {(unsigned long)((( gfp_t)(0x400u|0x800u)) | (( gfp_t)0x40u) | (( gfp_t)0x80u)), "GFP_KERNEL"}, 
 {(
>  unsigned long)((( gfp_t)(0x400u|0x800u)) | (( gfp_t)0x40u)), "GFP_NOFS"}, {(unsigned long)((( gfp_t)0x20u)|(( gfp_t)0x200u)|(( gfp_t)0x800u)), "GFP_ATOMIC"}, {(unsigned long)((( gfp_t)(0x400u|0x800u))), "GFP_NOIO"}, {(unsigned long)((( gfp_t)0x800u)), "GFP_NOWAIT"}, {(unsigned long)(( gfp_t)0x01u), "GFP_DMA"}, {(unsigned long)(( gfp_t)0x02u), "__GFP_HIGHMEM"}, {(unsigned long)(( gfp_t)0x04u), "GFP_DMA32"}, {(unsigned long)(( gfp_t)0x20u), "__GFP_HIGH"}, {(unsigned long)(( gfp_t)0x200u), "__GFP_ATOMIC"}, {(unsigned long)(( gfp_t)0x40u), "__GFP_IO"}, {(unsigned long)(( gfp_t)0x80u), "__GFP_FS"}, {(unsigned long)(( gfp_t)0x2000u), "__GFP_NOWARN"}, {(unsigned long)(( gfp_t)0x4000u), "__GFP_RETRY_MAYFAIL"}, {(unsigned long)(( gfp_t)0x8000u), "__GFP_NOFAIL"}, {(unsigned long)(( gfp_t)0x10000u), "__GFP_NORETRY"}, {(unsigned long)(( gfp_t)0x40000u), "__GFP_COMP"}, {(unsigned long)(( gfp_t)0x100u), "__GFP_ZERO"}, {(unsigned long)(( gfp_t)0x80000u), "__GFP_NOMEMALLOC"}, {(unsigned long)(( g
 fp
>  _t)0x20000u), "__GFP_MEMALLOC"}, {(unsigned long)(( gfp_t)0x100000u), "__GFP_HARDWALL"}, {(unsigned long)(( gfp_t)0x200000u), "__GFP_THISNODE"}, {(unsigned long)(( gfp_t)0x10u), "__GFP_RECLAIMABLE"}, {(unsigned long)(( gfp_t)0x08u), "__GFP_MOVABLE"}, {(unsigned long)(( gfp_t)0x400000u), "__GFP_ACCOUNT"}, {(unsigned long)(( gfp_t)0x1000u), "__GFP_WRITE"}, {(unsigned long)(( gfp_t)(0x400u|0x800u)), "__GFP_RECLAIM"}, {(unsigned long)(( gfp_t)0x400u), "__GFP_DIRECT_RECLAIM"}, {(unsigned long)(( gfp_t)0x800u), "__GFP_KSWAPD_RECLAIM"}, {(unsigned long)(( gfp_t)0x800000u), "__GFP_ZEROTAGS"}, {(unsigned long)(( gfp_t)0x1000000u),"__GFP_SKIP_KASAN_POISON"} ) : "none"
> 
> Quite long, but whatever...
> 
> 

The TRACE_EVENT() macro that defines that mess is:

TRACE_EVENT(mm_page_alloc,

        TP_PROTO(struct page *page, unsigned int order,
                        gfp_t gfp_flags, int migratetype),

        TP_ARGS(page, order, gfp_flags, migratetype),

        TP_STRUCT__entry(
                __field(        unsigned long,  pfn             )
                __field(        unsigned int,   order           )
                __field(        unsigned long,  gfp_flags       )
                __field(        int,            migratetype     )
        ),

        TP_fast_assign(
                __entry->pfn            = page ? page_to_pfn(page) : -1UL;
                __entry->order          = order;
                __entry->gfp_flags      = (__force unsigned long)gfp_flags;
                __entry->migratetype    = migratetype;
        ),

        TP_printk("page=%p pfn=0x%lx order=%d migratetype=%d gfp_flags=%s",
                __entry->pfn != -1UL ? pfn_to_page(__entry->pfn) : NULL,
                __entry->pfn != -1UL ? __entry->pfn : 0,
                __entry->order,
                __entry->migratetype,
                show_gfp_flags(__entry->gfp_flags))
);


So looking at the first line:

                __entry->pfn != -1UL ? pfn_to_page(__entry->pfn) : NULL,

The pfn_to_page() must be a macro expanded to that huge output. 

The thing is, there's no way that user space can know what the result of
that pfn_to_page is, as that information is hidden inside the kernel.

I do not see that expanding like the above in the latest kernel. I'm
guessing the kernel you have has that crazy expansion of pfn_to_page() though.

Probably the best thing that user space can do is to just do what it does
now and simply output the event fields. We do not want to have the output
showing all that builtin_constant_p() and size_of() callers.

-- Steve

