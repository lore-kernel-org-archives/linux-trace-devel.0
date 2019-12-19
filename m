Return-Path: <SRS0=Ara6=2J=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6717CC43603
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Dec 2019 23:31:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B3FB2467E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Dec 2019 23:31:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbfLSXby (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Dec 2019 18:31:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:34324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726963AbfLSXbx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Dec 2019 18:31:53 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D166724679;
        Thu, 19 Dec 2019 23:31:52 +0000 (UTC)
Date:   Thu, 19 Dec 2019 18:31:51 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Sven Schnelle <svens@linux.ibm.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Shuah Khan <shuahkhan@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] selftests/ftrace: fix glob selftest
Message-ID: <20191219183151.58d81624@gandalf.local.home>
In-Reply-To: <20191218074427.96184-2-svens@linux.ibm.com>
References: <20191218074427.96184-1-svens@linux.ibm.com>
        <20191218074427.96184-2-svens@linux.ibm.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 18 Dec 2019 08:44:25 +0100
Sven Schnelle <svens@linux.ibm.com> wrote:

> test.d/ftrace/func-filter-glob.tc is failing on s390 because it has
> ARCH_INLINE_SPIN_LOCK and friends set to 'y'. So the usual
> __raw_spin_lock symbol isn't in the ftrace function list. Change
> '*aw*lock' to '*time*ns' which would hopefully match some of the
> ktime_() functions on all platforms.

This requires an ack from Masami, and this patch can go through Shuah's
tree.

Also, any patches for the Linux kernel should be Cc'd to lkml. The
linux-trace-devel is mostly for tracing tools, not kernel patches.

-- Steve

> 
> Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
> ---
>  .../testing/selftests/ftrace/test.d/ftrace/func-filter-glob.tc  | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/ftrace/test.d/ftrace/func-filter-glob.tc b/tools/testing/selftests/ftrace/test.d/ftrace/func-filter-glob.tc
> index 27a54a17da65..a5d61667cd56 100644
> --- a/tools/testing/selftests/ftrace/test.d/ftrace/func-filter-glob.tc
> +++ b/tools/testing/selftests/ftrace/test.d/ftrace/func-filter-glob.tc
> @@ -30,7 +30,7 @@ ftrace_filter_check '*schedule*' '^.*schedule.*$'
>  ftrace_filter_check 'schedule*' '^schedule.*$'
>  
>  # filter by *mid*end
> -ftrace_filter_check '*aw*lock' '.*aw.*lock$'
> +ftrace_filter_check '*time*ns' '.*time.*ns$'
>  
>  # filter by start*mid*
>  ftrace_filter_check 'mutex*try*' '^mutex.*try.*'

