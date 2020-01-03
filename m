Return-Path: <SRS0=b4/L=2Y=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05DFAC00523
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 Jan 2020 23:12:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D76AC24649
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 Jan 2020 23:12:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbgACXMp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 3 Jan 2020 18:12:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:56778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726052AbgACXMp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 3 Jan 2020 18:12:45 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06B3C227BF;
        Fri,  3 Jan 2020 23:12:43 +0000 (UTC)
Date:   Fri, 3 Jan 2020 18:12:42 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC] tools lib traceevent: How to do library versioning being
 in the Linux kernel source?
Message-ID: <20200103181242.4802727e@gandalf.local.home>
In-Reply-To: <20200103211743.b474f74d0a039624d37989bc@kernel.org>
References: <20200102122004.216c85da@gandalf.local.home>
        <20200103211743.b474f74d0a039624d37989bc@kernel.org>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 3 Jan 2020 21:17:43 +0900
Masami Hiramatsu <mhiramat@kernel.org> wrote:

> +1. It sounds reasonable to move the main part of libtraceevent out
> of kernel tree. BTW, the plugins seems depending on the kernel. Maybe
> we can provide it under
> /lib/modules/<kversion>/shared/libtraceevent/plugins/ ? :)

They really shouldn't be. They should be able to be used between
different versions of the kernel. Which plugins do you see an issue
with?

-- Steve
