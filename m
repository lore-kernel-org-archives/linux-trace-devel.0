Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECEC0C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Mar 2022 18:05:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233783AbiCKSGD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Mar 2022 13:06:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239458AbiCKSGC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Mar 2022 13:06:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 307E81B0BC0;
        Fri, 11 Mar 2022 10:04:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5128B80EA4;
        Fri, 11 Mar 2022 18:04:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDDDAC340E9;
        Fri, 11 Mar 2022 18:04:54 +0000 (UTC)
Date:   Fri, 11 Mar 2022 13:04:53 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Beau Belgrave <beaub@linux.microsoft.com>
Cc:     Anders Roxell <anders.roxell@linaro.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [next] arm64: allmodconfig: kernel BUG at
 include/linux/page-flags.h:509
Message-ID: <20220311130453.54a4e0b2@gandalf.local.home>
In-Reply-To: <20220311171123.GA1675@kbox>
References: <CADYN=9+xY5Vku3Ws5E9S60SM5dCFfeGeRBkmDFbcxX0ZMoFing@mail.gmail.com>
        <20220311112426.7e3cf434@gandalf.local.home>
        <20220311171123.GA1675@kbox>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 11 Mar 2022 09:11:23 -0800
Beau Belgrave <beaub@linux.microsoft.com> wrote:

> Maybe I am mistaken, but I remember reading in the case of a kernel
> allocated page shared with user space they must be reserved. It was
> stated that the PTE may not know the PFN belongs to user or kernel.
> 
> If this is not the case, I don't see why we couldn't allocate zero'd
> pages as you describe. We just need to make sure we don't crash user
> processes touching the page if it does get paged out (and ideally not
> slow down their execution).

Anything allocated by the kernel via alloc_page() will never be paged out.
As the kernel may use it in any location (including NMIs). The ftrace ring
buffer allocates its pages this way.

Now if you were mapping some file system page, then that would be a
different story.

-- Steve
