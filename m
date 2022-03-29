Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7423C433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Mar 2022 19:45:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241020AbiC2TrU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 29 Mar 2022 15:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240356AbiC2TrU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 29 Mar 2022 15:47:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7DE3B7C6A;
        Tue, 29 Mar 2022 12:45:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6CC5361698;
        Tue, 29 Mar 2022 19:45:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B267C340F2;
        Tue, 29 Mar 2022 19:45:34 +0000 (UTC)
Date:   Tue, 29 Mar 2022 15:45:32 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Beau Belgrave <beaub@linux.microsoft.com>,
        Beau Belgrave <beaub@microsoft.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-trace-devel <linux-trace-devel@vger.kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>
Subject: Re: Comments on new user events ABI
Message-ID: <20220329154532.4833d16d@gandalf.local.home>
In-Reply-To: <CAADnVQK=GCuhTHz=iwv0r7Y37gYvt_UBzkfFJmNT+uR0z+7Myw@mail.gmail.com>
References: <2059213643.196683.1648499088753.JavaMail.zimbra@efficios.com>
        <20220329002935.2869-1-beaub@linux.microsoft.com>
        <1014535694.197402.1648570634323.JavaMail.zimbra@efficios.com>
        <CAADnVQK=GCuhTHz=iwv0r7Y37gYvt_UBzkfFJmNT+uR0z+7Myw@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 29 Mar 2022 09:25:52 -0700
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> Thanks for flagging.
> 
> Whoever added this user_bpf* stuff please remove it immediately.
> It was never reviewed by bpf maintainers.

Heh, now you know how the x86 maintainers feel ;-)

> 
> It's a hard Nack to add a bpf interface to user_events.

Agreed, I'm thinking of marking the entire thing as broken such that it can
be worked on a bit more without a total revert (but still remove the BPF
portion on your request).

Beau, I agree with Mathieu, I don't think it's a good idea to expose the
"ftrace/perf/etc" users. The only thing that the application needs is a bit
to say "call the write now". And let the work be done within the kernel.
I think a single bit may be better, that way you can have many more events
on a page, and since they do not get modified often, it will be in hot
cache and fast.

-- Steve
