Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66065C433ED
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Apr 2021 20:51:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29DAD6113B
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Apr 2021 20:51:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236851AbhDVUw0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 22 Apr 2021 16:52:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:40676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239406AbhDVUw0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 22 Apr 2021 16:52:26 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89FEF6141C;
        Thu, 22 Apr 2021 20:51:50 +0000 (UTC)
Date:   Thu, 22 Apr 2021 16:51:48 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Nicolas Sterchele <nicolas@sterchelen.net>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] trace-cmd list: Add --full to show print fmt of an
 event
Message-ID: <20210422165148.6d0ea90e@gandalf.local.home>
In-Reply-To: <YIHfki40RQf+J8/Y@hercule>
References: <20210416141720.57a7963d@gandalf.local.home>
        <YIHfki40RQf+J8/Y@hercule>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 22 Apr 2021 22:41:54 +0200
Nicolas Sterchele <nicolas@sterchelen.net> wrote:

> >@@ -84,7 +85,7 @@ static void process_file_re(process_file_func func,
> > 		strcpy(&str[l-1], "\n*$");
> >
> > 	if (regcomp(&reg, str, REG_ICASE|REG_NOSUB))
> >-		die("invalid function regex '%s'", re);
> >+		die("invalid function regex '%s'", re, flags);  
> 
> Shouldn't we add `flags` inside the fmt string?:
> 		die("invalid function regex '%s' with '%d' as flags", re, flags);

Nice catch, but no, flags just needs to be dropped.

The "flags" was added in a different patch, and as I was writing updates in
individual patches (and not a series), I found that in some places that I
had conflicts. And the patch that added "flags" all over the place I had to
update accordingly.

This is simply a case of me adding ", flags" to the wrong function
(*embarrassed*)!

It doesn't need to be printed, but it shouldn't be passed to die either.

One way I could have caught this was by adding the printf attribute to the
die() header, where things like this will cause warnings.

Thanks for the report. I'll fix it.

-- Steve


> 
> > 	free(str);
