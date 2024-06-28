Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA731C231F
	for <linux-trace-devel@vger.kernel.org>; Fri, 28 Jun 2024 15:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719588938; cv=none; b=FP6XOuFAGN55dvWrjHtSYrhHKTxK2P4vRaL6hRIAX74uHRLT6arfihxjzxzE9mt4w9TdCOUtwAUlKr5g0k5Vvc8A5/D0jFBeKun3x61uxplyDScyy0boGzibkii70WNkiO9AUZZsDQXn+S1+ilCh2Ls2mkQazb9fUlESXz/VnJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719588938; c=relaxed/simple;
	bh=kppHbHt2ho+rfLMn2bxGKoWu86F5srxhgXPNAOjc2dY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KiHMxIcuzTv6RzNii3KjsNyPOctms9H+ZlomaMgDDwAcggSKVxsZnjWGGTjdkT2rWz+7G9izDL+WLmhAszE1XLqnrAVPM6RUiPpKywcl0Cbf/0JWpcLiMl3XkuvJ/2HbJ9pAuuabLQ657Nop+1q0HIG9WFL9WFTJUXXWOks/u50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D72DC32781;
	Fri, 28 Jun 2024 15:35:37 +0000 (UTC)
Date: Fri, 28 Jun 2024 11:35:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Totoro W <tw19881113@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] fix double free issue in event_read_print_args
Message-ID: <20240628113536.0643fcc7@rorschach.local.home>
In-Reply-To: <CAFrM9ztDcGK4aP51uJEsQStyyf1tXebOKXiT-Ota2-gT3wVLyA@mail.gmail.com>
References: <CAFrM9ztDcGK4aP51uJEsQStyyf1tXebOKXiT-Ota2-gT3wVLyA@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 27 Jun 2024 14:51:42 +0800
Totoro W <tw19881113@gmail.com> wrote:

> commit cb227dfc63346a23fd019f2146b4f9f4f5a58b6a (HEAD -> fix_double_free)
> Author: Tw <tw19881113@gmail.com>
> Date:   Thu Jun 27 14:40:09 2024 +0800
> 
>     Fix double free issue in event_read_print_args
> 
>     The corner case is that when we encounter a invalid right argument
> of a condition operation.
>     Currently, we free token immediately, but it will also be freed
> when free `arg->op.op`.
> 
>     BTW, the crash calltrace as follows:
> 
>     Program received signal SIGSEGV, Segmentation fault.
>     get_meta (p=<optimized out>) at
> /home/tw/code/zig/build/stage3/lib/zig/libc/musl/src/malloc/mallocng/meta.h:141
>     141     /home/tw/code/zig/build/stage3/lib/zig/libc/musl/src/malloc/mallocng/meta.h:
> No such file or directory.
>     (gdb) bt
>         at /home/tw/code/zig/build/stage3/lib/zig/libc/musl/src/malloc/mallocng/meta.h:141
>         at /home/tw/code/zig/build/stage3/lib/zig/libc/musl/src/malloc/mallocng/free.c:105
>         at /tmp/.cache/zig/p/12207a2e4477bf4414e7df3eb2172c698ab916695a0d3eefbf16f65b0c969dd81184/src/event-parse.c:1128
>         list@entry=0x7ff7b18768)
>         at /tmp/.cache/zig/p/12207a2e4477bf4414e7df3eb2172c698ab916695a0d3eefbf16f65b0c969dd81184/src/event-parse.c:1417
>         at /tmp/.cache/zig/p/12207a2e4477bf4414e7df3eb2172c698ab916695a0d3eefbf16f65b0c969dd81184/src/event-parse.c:3895
>         sys=<optimized out>)
>         at /tmp/.cache/zig/p/12207a2e4477bf4414e7df3eb2172c698ab916695a0d3eefbf16f65b0c969dd81184/src/event-parse.c:7824
>         size=<optimized out>, sys=sys@entry=0x7ff7ff51c0 "kvm")
>         at /tmp/.cache/zig/p/12207a2e4477bf4414e7df3eb2172c698ab916695a0d3eefbf16f65b0c969dd81184/src/event-parse.c:7882
>         buf=0x7ff7b0c610 "kvm_sys_access", size=549616874800,
> sys=0x7fffffe0b2 "me", sys@entry=0x7ff7ff51c0 "kvm")
>         at /tmp/.cache/zig/p/12207a2e4477bf4414e7df3eb2172c698ab916695a0d3eefbf16f65b0c969dd81184/src/event-parse.c:7945
>         tracing_dir=tracing_dir@entry=0x7ff7ffc660
> "/sys/kernel/tracing", system=system@entry=0x7ff7ff51c0 "kvm",
>         check=false)
>         at /tmp/.cache/zig/p/1220c1c006cbf05434d240b65f343c84f3d7f837fbef31f2cade733ec911cc3ed76b/src/tracefs-events.c:1062
>         system=0x7ff7ff51c0 "kvm")
>         at /tmp/.cache/zig/p/1220c1c006cbf05434d240b65f343c84f3d7f837fbef31f2cade733ec911cc3ed76b/src/tracefs-events.c:1084
>         tep=tep@entry=0x7ff7ffc830, sys_names=sys_names@entry=0x0,
> parsing_failures=0x0,
>         parsing_failures@entry=0x7fffffe7b0)
>         at /tmp/.cache/zig/p/1220c1c006cbf05434d240b65f343c84f3d7f837fbef31f2cade733ec911cc3ed76b/src/tracefs-events.c:1284
>         sys_names@entry=0x7ffffff880)
>         at /tmp/.cache/zig/p/1220c1c006cbf05434d240b65f343c84f3d7f837fbef31f2cade733ec911cc3ed76b/src/tracefs-events.c:1355
>         tracing_dir=0x6500006c6f6f62 <error: Cannot access memory at
> address 0x6500006c6f6f62>)
>         at /tmp/.cache/zig/p/1220c1c006cbf05434d240b65f343c84f3d7f837fbef31f2cade733ec911cc3ed76b/src/tracefs-events.c:1377
> 
>     Signed-off-by: Tw <tw19881113@gmail.com>

It's best to use git sendmail, for sending patches, as it will send them properly.

-- Steve
