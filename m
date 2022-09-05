Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AA47C6FA83
	for <linux-trace-devel@archiver.kernel.org>; Mon,  5 Sep 2022 16:49:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbiIEQtZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 5 Sep 2022 12:49:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230498AbiIEQtY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 5 Sep 2022 12:49:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64D17D6C;
        Mon,  5 Sep 2022 09:49:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0076D6126A;
        Mon,  5 Sep 2022 16:49:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 137C4C433D6;
        Mon,  5 Sep 2022 16:49:20 +0000 (UTC)
Date:   Mon, 5 Sep 2022 12:49:58 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Michael Petlan <mpetlan@redhat.com>
Cc:     "linux-trace-users@vger.kernel.org" 
        <linux-trace-users@vger.kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: libtraceevent -- undefined functions
Message-ID: <20220905124958.683f7bdb@gandalf.local.home>
In-Reply-To: <20220905122916.76f4abce@gandalf.local.home>
References: <alpine.LRH.2.20.2208301214410.12613@Diego>
        <20220901100728.54562054@gandalf.local.home>
        <alpine.LRH.2.20.2209051707130.12613@Diego>
        <20220905122916.76f4abce@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 5 Sep 2022 12:29:16 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> So looking at the first line:
> 
>                 __entry->pfn != -1UL ? pfn_to_page(__entry->pfn) : NULL,
> 
> The pfn_to_page() must be a macro expanded to that huge output. 
> 
> The thing is, there's no way that user space can know what the result of
> that pfn_to_page is, as that information is hidden inside the kernel.
> 
> I do not see that expanding like the above in the latest kernel. I'm
> guessing the kernel you have has that crazy expansion of pfn_to_page() though.
> 
> Probably the best thing that user space can do is to just do what it does
> now and simply output the event fields. We do not want to have the output
> showing all that builtin_constant_p() and size_of() callers.

Yeah, on 5.14 it looks like this:

#define pfn_to_page __pfn_to_page

#define __pfn_to_page(pfn)      (vmemmap + (pfn))

#define vmemmap                 ((struct page *)VMEMMAP_START - (memstart_addr >> PAGE_SHIFT))

#define VMEMMAP_START           (-(UL(1) << (VA_BITS - VMEMMAP_SHIFT)))

#define VA_BITS                 (CONFIG_ARM64_VA_BITS)

#define VMEMMAP_SHIFT   (PAGE_SHIFT - STRUCT_PAGE_MAX_SHIFT)

#define PAGE_SHIFT              CONFIG_ARM64_PAGE_SHIFT

#define STRUCT_PAGE_MAX_SHIFT    (order_base_2(sizeof(struct page)))

#define order_base_2(n)                         \
(                                               \
        __builtin_constant_p(n) ? (             \
                ((n) == 0 || (n) == 1) ? 0 :    \
                ilog2((n) - 1) + 1) :           \
        __order_base_2(n)                       \
)

#define ilog2(n) \
( \
        __builtin_constant_p(n) ?       \
        ((n) < 2 ? 0 :                  \
         63 - __builtin_clzll(n)) :     \
        (sizeof(n) <= 4) ?              \
        __ilog2_u32(n) :                \
        __ilog2_u64(n)                  \
 )

and so on.

Thus, the pfn_to_page() macro gets expanded to some God awful expression.

There's not much we can do about this from the libtraceevent perspective :-/

-- Steve
