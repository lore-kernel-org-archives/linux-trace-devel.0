Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71F1EC433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 31 Mar 2022 12:13:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232829AbiCaMPb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 31 Mar 2022 08:15:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234316AbiCaMPa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 31 Mar 2022 08:15:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40D3F1A3B6;
        Thu, 31 Mar 2022 05:13:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3CB9B820C2;
        Thu, 31 Mar 2022 12:13:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B8CAC340F3;
        Thu, 31 Mar 2022 12:13:38 +0000 (UTC)
Date:   Thu, 31 Mar 2022 08:13:37 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Beau Belgrave <beaub@linux.microsoft.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        linux-trace-devel <linux-trace-devel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH] tracing: do not export user_events uapi
Message-ID: <20220331081337.07ddf251@gandalf.local.home>
In-Reply-To: <CAK7LNATm5FjZsXL6aKUMhXwQAqTuO9+LmAk3LGjpAib7NZBDmg@mail.gmail.com>
References: <20220330201755.29319-1-mathieu.desnoyers@efficios.com>
        <20220330162152.17b1b660@gandalf.local.home>
        <CAK7LNATm5FjZsXL6aKUMhXwQAqTuO9+LmAk3LGjpAib7NZBDmg@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 31 Mar 2022 16:29:30 +0900
Masahiro Yamada <masahiroy@kernel.org> wrote:

> Well, the intended usage of no-export-headers is to
> cater to the UAPI supported by only some architectures.
> We have kvm(_para).h here because not all architectures
> support kvm.
> 
> If you do not want to export the UAPI,
> you should not put it in include/uapi/.
> 
> After the API is finalized, you can move it to
> include/uapi.

So a little bit of background. I and a few others thought it was done, and
pushed it to Linus. Then when it made it into his tree (and mentioned on
LWN) it got a wider audience that had concerns. After they brought up those
concerns, we agreed that this needs a bit more work. I was hoping not to do
a full revert and simply marked the change for broken so that it can be
worked on upstream with the wider audience. Linus appears to be fine with
this approach, as he helped me with my "mark for BROKEN" patch.

Mathieu's concern is that this header file could be used in older distros
with newer kernels that have it implemented and added this to keep out of
those older distros.

The options to make Mathieu sleep better at night are:

1) this patch

2) move this file out of uapi.

3) revert the entire thing.

I really do not want to do #3 but I am willing to do 1 or 2.

-- Steve
