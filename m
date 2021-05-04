Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82A9DC433B4
	for <linux-trace-devel@archiver.kernel.org>; Tue,  4 May 2021 20:00:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A8EE613B3
	for <linux-trace-devel@archiver.kernel.org>; Tue,  4 May 2021 20:00:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232615AbhEDUBH convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 4 May 2021 16:01:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:35468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232627AbhEDUBG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 4 May 2021 16:01:06 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D31C613B3;
        Tue,  4 May 2021 20:00:10 +0000 (UTC)
Date:   Tue, 4 May 2021 16:00:08 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/4] libtraceevent: Add logs with severity info
Message-ID: <20210504160008.3f6f2e01@gandalf.local.home>
In-Reply-To: <20210428073001.755905-3-tz.stoyanov@gmail.com>
References: <20210428073001.755905-1-tz.stoyanov@gmail.com>
        <20210428073001.755905-3-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 28 Apr 2021 10:29:59 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Renamed existing pr_stat() internal function to tep_info() and limit it

Unfortunately they are also not internal functions :-(

> to print only when the log level is TEP_LOG_INFO. Removed duplicated and
> unused functions:
>  vpr_stat()
>  __pr_stat()
>  __vpr_stat()

trace-record.c: In function ‘expand_event_files’:
trace-record.c:2971:3: warning: implicit declaration of function ‘pr_stat’; did you mean ‘lstat’? [-Wimplicit-function-declaration]
 2971 |   pr_stat("%s\n", path);
      |   ^~~~~~~
      |   lstat


ctracecmd_wrap.c: In function ‘pr_stat’:
ctracecmd_wrap.c:2779:2: warning: implicit declaration of function ‘__vpr_stat’; did you mean ‘pr_stat’? [-Wimplicit-function-declaration]
 2779 |  __vpr_stat(fmt, ap);
      |  ^~~~~~~~~~
      |  pr_stat


-- Steve
