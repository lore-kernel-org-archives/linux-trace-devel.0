Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD926C433DB
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Feb 2021 14:19:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F13564F58
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Feb 2021 14:19:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236485AbhBDOSs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 4 Feb 2021 09:18:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:33210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236686AbhBDOSL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 4 Feb 2021 09:18:11 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4699F64E0A;
        Thu,  4 Feb 2021 14:17:29 +0000 (UTC)
Date:   Thu, 4 Feb 2021 09:17:27 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: Move "load_plugins" out of the opening code
Message-ID: <20210204091727.5ae308dc@gandalf.local.home>
In-Reply-To: <CAPpZLN4D4zDfErUVpXfdaY3iciV0k+nW+uJsBeu79XtaVjxatw@mail.gmail.com>
References: <20210119095939.6f307c4d@gandalf.local.home>
        <CAPpZLN4D4zDfErUVpXfdaY3iciV0k+nW+uJsBeu79XtaVjxatw@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 4 Feb 2021 13:04:01 +0200
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

>  - Moving that logic out of tracecmd_alloc_fd() will break these APIs:
>     tracecmd_open()
>     tracecmd_open_fd()
>     tracecmd_open_head()

Note, because libtracecmd has not been released yet, we still have the
luxury of breaking its APIs ;-)

>  KernelShark relies on them for reading trace.dat files.  We can think of
>  moving plugins loading in a separate API, which must be called at the
>  library initialisation phase, but this will require changes in the current
> library users (KernelShark?).

For libtracecmd, it is still OK to change the APIs even if KernelShark
breaks. As the only KernelShark user is still in the trace-cmd repo, it
should be OK. Once we have v2 out, then we need to have these APIs frozen.
But until then, let's break the API if it makes it a better design.

-- Steve
