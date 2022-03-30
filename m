Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 369FCC433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 30 Mar 2022 19:57:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231420AbiC3T70 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 30 Mar 2022 15:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbiC3T7Z (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 30 Mar 2022 15:59:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB38D2AE32;
        Wed, 30 Mar 2022 12:57:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3EA5F614EE;
        Wed, 30 Mar 2022 19:57:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A339C340F0;
        Wed, 30 Mar 2022 19:57:34 +0000 (UTC)
Date:   Wed, 30 Mar 2022 15:57:33 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Beau Belgrave <beaub@linux.microsoft.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        linux-trace-devel <linux-trace-devel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH] tracing: Set user_events to BROKEN
Message-ID: <20220330155733.012704ee@gandalf.local.home>
In-Reply-To: <20220330153145.2d148b8c@gandalf.local.home>
References: <20220329222514.51af6c07@gandalf.local.home>
        <1546405229.199729.1648659253425.JavaMail.zimbra@efficios.com>
        <CAHk-=wgZ0RccFsUhgKpdh130ydsY57bqaCGRQS7w3-ckgHP=OA@mail.gmail.com>
        <20220330153145.2d148b8c@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 30 Mar 2022 15:31:45 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> > So maybe it should be marked as
> > 
> >         depends on BROKEN || COMPILE_TEST
> > 
> > instead?  
> 
> Agreed. I'll send a v2 of the patch.

Hopefully no distros are idiotic enough to enable COMPILE_TEST to get this
feature. I could add "panic" to each of the API calls ;-)

-- Steve
