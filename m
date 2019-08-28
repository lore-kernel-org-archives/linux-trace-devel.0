Return-Path: <SRS0=sbuk=WY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FA65C3A5A1
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Aug 2019 20:25:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC3C320856
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Aug 2019 20:25:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbfH1UZ0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Aug 2019 16:25:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:47180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726617AbfH1UZ0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Aug 2019 16:25:26 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA11420856;
        Wed, 28 Aug 2019 20:25:25 +0000 (UTC)
Date:   Wed, 28 Aug 2019 16:25:24 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 0/8] Separate trace-cmd and libtracecmd code
Message-ID: <20190828162524.7b80e44c@gandalf.local.home>
In-Reply-To: <20190814084712.28188-1-tz.stoyanov@gmail.com>
References: <20190814084712.28188-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 14 Aug 2019 11:47:00 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> libtracecmd is a library, containing functions that can be
> used without the trace-cmd application. However, some of the
> functions declared as libtracecmd APIs in trace-cmd.h
> depend on trace-cmd context. That causes a problem when
> other application uses the library. The problem can be
> observed when running kerneshark and there is a python
> module, loaded by the python plugin - there is a bunch
> of warnings.
> To resolve the problem, implementations of all trace-cmd
> independent functions are moved into libtracecmd. All
> libtracecmd functions, that depend on trace-cmd context
> are removed from the library and from trace-cmd.h file.
> 

I pulled in some but not all of these patches (the ones I had comments
on). Feel free to rebase on the git repo and you only need to send the
ones that have not been applied.

-- Steve
