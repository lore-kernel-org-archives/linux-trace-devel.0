Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0883BECAAD5
	for <linux-trace-devel@archiver.kernel.org>; Mon,  5 Sep 2022 15:36:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239003AbiIEPgn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 5 Sep 2022 11:36:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239031AbiIEPgj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 5 Sep 2022 11:36:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A615343326
        for <linux-trace-devel@vger.kernel.org>; Mon,  5 Sep 2022 08:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662392195;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+iCnoWjeKzL/rgVQSTV4ZXILgcMftWqwHeVbgEHpb1o=;
        b=K4z2x+YTcavFVm4/OSAiULaaKJkHAScVwwF0zo74OECxfBvFotnM43zyvwgRZ6AU6QVSbm
        4tpHIPna5j0T21V92y7tAU/NHL1l+OA9BSoIhGfghkLinruStkyd55OmaZKcQLLXvgvy2j
        GMArUv+9i5AKvNOadSOIoRg2QUDU0Ec=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-356-v5HObEJUOKWq8CAHb5NlsA-1; Mon, 05 Sep 2022 11:36:32 -0400
X-MC-Unique: v5HObEJUOKWq8CAHb5NlsA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 16E10185A79C;
        Mon,  5 Sep 2022 15:36:32 +0000 (UTC)
Received: from Diego (unknown [10.39.208.38])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CC7821121315;
        Mon,  5 Sep 2022 15:36:30 +0000 (UTC)
Date:   Mon, 5 Sep 2022 17:36:28 +0200 (CEST)
From:   Michael Petlan <mpetlan@redhat.com>
X-X-Sender: Michael@Diego
To:     Steven Rostedt <rostedt@goodmis.org>
cc:     "linux-trace-users@vger.kernel.org" 
        <linux-trace-users@vger.kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: libtraceevent -- undefined functions
In-Reply-To: <20220901100728.54562054@gandalf.local.home>
Message-ID: <alpine.LRH.2.20.2209051707130.12613@Diego>
References: <alpine.LRH.2.20.2208301214410.12613@Diego> <20220901100728.54562054@gandalf.local.home>
User-Agent: Alpine 2.20 (LRH 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 1 Sep 2022, Steven Rostedt wrote:
>

Hello all!

Thanks Steve for information.

> [ This is helpful information for trace users and developers so I've
>   included the two lists ]

Sure.

> On Tue, 30 Aug 2022 12:59:46 +0200 (CEST)
> Michael Petlan <mpetlan@redhat.com> wrote:
> 
> > Hello Steve,
> > 
> > during perf testing, I have found out that the print formats of some tracepoints
> > are translated to quite complicated code, that differs per architecture and quite
> > often contains various builtins and functions that are not recognized by the parser
> > in libtraceevent.
> > 
> > It looks like this:
> > 
> > [root@gigabyte-r120-03 base_kmem]# perf kmem --page record -o ./perf.data -- true
> > libtraceevent: No such file or directory
> >   [kmem:mm_page_alloc] function __builtin_constant_p not defined
> >   [kmem:mm_page_free] function __builtin_constant_p not defined
> > 
> > I have digged down to event-parse.c source and commits like 1b20d9491cf9 ("tools
> > lib traceevent: Add handler for __builtin_expect()") that add some missing func
> > support.
> > 
> > I have added __builtin_constant_p, it helped to suppress the warning, but then
> > I found out I was missing sizeof()...
> > 
> > On an x86_64 F35 machine, I have found the following list of missing funcs:
> >  __builtin_choose_expr
> >  decode_prq_descriptor
> >  jiffies_to_msecs
> >  libata_trace_parse_eh_action
> >  libata_trace_parse_host_stat
> >  libata_trace_parse_qc_flags
> >  libata_trace_parse_subcmd
> >  libata_trace_parse_tf_flags
> >  mc_event_error_type
> >  pgd_val
> >  pmd_val
> >  pte_val
> >  pud_val
> >  scsi_trace_parse_cdb
> >  sizeof
> 
> The problem with a lot of the above is that user space does not know how to
> parse them. "jiffies_to_msecs" depends on knowing the HZ value. Now if the
> kernel exported this, we could look for it and save this information, and
> then be able to parse it correctly.

Well, under the term "parse" I understand "to verify, whether the tokens
match the grammar" (i.e. that a function name has to be followed by '(' and
')' characters, that there have to be e.g. two args, separated by ',' etc.

By adding __builtin_expect support, you have added exactly this --> it now
knows the function, but does nothing around it.

Then it comes to interpreting the code, that is also done in libtraceevent,
isn't it? Does the parser produce some intermediate rep? What code performs
the interpretation?

> >  xen_hypercall_name
> >  xhci_decode_ctrl_ctx
> >  xhci_decode_doorbell
> >  xhci_decode_ep_context
> >  xhci_decode_portsc
> >  xhci_decode_slot_context
> >  xhci_ring_type_string
> > 
> > There are of course more, since on other platforms, the print format expands to
> > different code.
> > 
> > I wonder, whether it might be useful to add these functions to libtraceevent
> > parser. Finally, what is the purpose of the handlers, such as __builtin_expect()
> > you have added? It looks like that the parser machine now accepts this token and
> > handles that it has to have two parameters, but does nothing more with it. It
> > lets the parser to dive deeper and process the first arg and forgets the second,
> > just like replacing
> >   __builtin_expect( exp, c)
> > by
> >   exp
> > so when something executes the code, it ignores the builtin? Am I right?
> 
> Correct. As __builtin_expect() is just a compile time optimization that
> "likely()" and "unlikely()" are defined to, it has no meaning to the
> parser. But we still want the contents of the expression.
> 
> I had to update libtraceevent to basically ignore the __builtin_expect().
> 
> That is, "unlikely(cond)" turns into "!!__builtin_exepect(cond, 0)"
> 
> libtraceevent does not care about the "unlikely()" part, only the
> condition, so the parser basically treats it the same:
> 
>   "unlikely(cond)" == "cond"

Good, so I understood your approach correctly.
> 
> > 
> > The __builtin_constant_p(arg) should decide whether arg is constant or not and
> > return 1 or 0 respectively...
> > 
> 
> What is using __builting_constant_p() inside the TP_printk()?

There are several events. However, I don't know who takes the tracepoint description
and generates the terribly complicated expression below.

> 
> > My questions are:
> >    1) Does it matther whether or not the above functions are accepted by the parser
> >    grammar or not?
> 
> When it can't parse something, it falls back to just printing out the raw
> fields the best it can.
> 
> >    2) Does (1) affect how the code is later executed somewhere?
> 
> It affects how it prints the event. It then ignores the TP_printk() format,
> and then, as mentioned above, just prints the raw fields.

OK, so if parsing does not fail, the code is interpreted by libtraceevent?

In such case, the missing functions should be added or added as bypassed
the similar way (e.g. __builtin_constant_p could be replaced by 0). Then,
for example the sizeof should be accepted by the parser, but also interpreted
correctly...

> >    3) Would e.g. replacing __builtin_constant_p(arg) by 0 by default help/simplify
> >    anything?
> 
> I have to see how it's used. What event does that?

This is aarch64, event mm_page_alloc, kernel is from RHEL-9, so 5.14:

print fmt: "page=%p pfn=0x%lx order=%d migratetype=%d gfp_flags=%s", REC->pfn != -1UL ? (((struct page *)(-((((1UL))) << ((48) - (12 - (( __builtin_constant_p(sizeof(struct page)) ? ( ((sizeof(struct page)) == 0 || (sizeof(struct page)) == 1) ? 0 : ( __builtin_constant_p((sizeof(struct page)) - 1) ? (((sizeof(struct page)) - 1) < 2 ? 0 : 63 - __builtin_clzll((sizeof(struct page)) - 1)) : (sizeof((sizeof(struct page)) - 1) <= 4) ? __ilog2_u32((sizeof(struct page)) - 1) : __ilog2_u64((sizeof(struct page)) - 1) ) + 1) : __order_base_2(sizeof(struct page)) )))))) - (memstart_addr >> 12)) + (REC->pfn)) : ((void *)0), REC->pfn != -1UL ? REC->pfn : 0, REC->order, REC->migratetype, (REC->gfp_flags) ? __print_flags(REC->gfp_flags, "|", {(unsigned long)(((((((( gfp_t)(0x400u|0x800u)) | (( gfp_t)0x40u) | (( gfp_t)0x80u) | (( gfp_t)0x100000u)) | (( gfp_t)0x02u)) | (( gfp_t)0x08u) | (( gfp_t)0x1000000u)) | (( gfp_t)0x40000u) | (( gfp_t)0x80000u) | (( gfp_t)0x2000u)) & ~(( gfp_t)(0x400u|0x800u))) 
 | (( gfp_t)0x400u)), "GFP_TRANSHUGE"}, {(unsigned long)((((((( gfp_t)(0x400u|0x800u)) | (( gfp_t)0x40u) | (( gfp_t)0x80u) | (( gfp_t)0x100000u)) | (( gfp_t)0x02u)) | (( gfp_t)0x08u) | (( gfp_t)0x1000000u)) | (( gfp_t)0x40000u) | (( gfp_t)0x80000u) | (( gfp_t)0x2000u)) & ~(( gfp_t)(0x400u|0x800u))), "GFP_TRANSHUGE_LIGHT"}, {(unsigned long)((((( gfp_t)(0x400u|0x800u)) | (( gfp_t)0x40u) | (( gfp_t)0x80u) | (( gfp_t)0x100000u)) | (( gfp_t)0x02u)) | (( gfp_t)0x08u) | (( gfp_t)0x1000000u)), "GFP_HIGHUSER_MOVABLE"}, {(unsigned long)(((( gfp_t)(0x400u|0x800u)) | (( gfp_t)0x40u) | (( gfp_t)0x80u) | (( gfp_t)0x100000u)) | (( gfp_t)0x02u)), "GFP_HIGHUSER"}, {(unsigned long)((( gfp_t)(0x400u|0x800u)) | (( gfp_t)0x40u) | (( gfp_t)0x80u) | (( gfp_t)0x100000u)), "GFP_USER"}, {(unsigned long)(((( gfp_t)(0x400u|0x800u)) | (( gfp_t)0x40u) | (( gfp_t)0x80u)) | (( gfp_t)0x400000u)), "GFP_KERNEL_ACCOUNT"}, {(unsigned long)((( gfp_t)(0x400u|0x800u)) | (( gfp_t)0x40u) | (( gfp_t)0x80u)), "GFP_KERNEL"}, {(
 unsigned long)((( gfp_t)(0x400u|0x800u)) | (( gfp_t)0x40u)), "GFP_NOFS"}, {(unsigned long)((( gfp_t)0x20u)|(( gfp_t)0x200u)|(( gfp_t)0x800u)), "GFP_ATOMIC"}, {(unsigned long)((( gfp_t)(0x400u|0x800u))), "GFP_NOIO"}, {(unsigned long)((( gfp_t)0x800u)), "GFP_NOWAIT"}, {(unsigned long)(( gfp_t)0x01u), "GFP_DMA"}, {(unsigned long)(( gfp_t)0x02u), "__GFP_HIGHMEM"}, {(unsigned long)(( gfp_t)0x04u), "GFP_DMA32"}, {(unsigned long)(( gfp_t)0x20u), "__GFP_HIGH"}, {(unsigned long)(( gfp_t)0x200u), "__GFP_ATOMIC"}, {(unsigned long)(( gfp_t)0x40u), "__GFP_IO"}, {(unsigned long)(( gfp_t)0x80u), "__GFP_FS"}, {(unsigned long)(( gfp_t)0x2000u), "__GFP_NOWARN"}, {(unsigned long)(( gfp_t)0x4000u), "__GFP_RETRY_MAYFAIL"}, {(unsigned long)(( gfp_t)0x8000u), "__GFP_NOFAIL"}, {(unsigned long)(( gfp_t)0x10000u), "__GFP_NORETRY"}, {(unsigned long)(( gfp_t)0x40000u), "__GFP_COMP"}, {(unsigned long)(( gfp_t)0x100u), "__GFP_ZERO"}, {(unsigned long)(( gfp_t)0x80000u), "__GFP_NOMEMALLOC"}, {(unsigned long)(( gfp
 _t)0x20000u), "__GFP_MEMALLOC"}, {(unsigned long)(( gfp_t)0x100000u), "__GFP_HARDWALL"}, {(unsigned long)(( gfp_t)0x200000u), "__GFP_THISNODE"}, {(unsigned long)(( gfp_t)0x10u), "__GFP_RECLAIMABLE"}, {(unsigned long)(( gfp_t)0x08u), "__GFP_MOVABLE"}, {(unsigned long)(( gfp_t)0x400000u), "__GFP_ACCOUNT"}, {(unsigned long)(( gfp_t)0x1000u), "__GFP_WRITE"}, {(unsigned long)(( gfp_t)(0x400u|0x800u)), "__GFP_RECLAIM"}, {(unsigned long)(( gfp_t)0x400u), "__GFP_DIRECT_RECLAIM"}, {(unsigned long)(( gfp_t)0x800u), "__GFP_KSWAPD_RECLAIM"}, {(unsigned long)(( gfp_t)0x800000u), "__GFP_ZEROTAGS"}, {(unsigned long)(( gfp_t)0x1000000u),"__GFP_SKIP_KASAN_POISON"} ) : "none"

Quite long, but whatever...

> 
> -- Steve
> 
> 

