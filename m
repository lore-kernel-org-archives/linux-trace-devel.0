Return-Path: <SRS0=Eaid=XO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FF94C3A5A6
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Sep 2019 22:52:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DEB6321907
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Sep 2019 22:52:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406103AbfISWwk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Sep 2019 18:52:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:56282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406075AbfISWwk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Sep 2019 18:52:40 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58DD0206C2;
        Thu, 19 Sep 2019 22:52:39 +0000 (UTC)
Date:   Thu, 19 Sep 2019 18:52:37 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Patrick McLean <chutzpah@gentoo.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 4/5] libtraceevent, perf tools: Changes in
 tep_print_event_* APIs
Message-ID: <20190919185237.25476332@gandalf.local.home>
In-Reply-To: <20190918020530.818038260@goodmis.org>
References: <20190918020334.344561631@goodmis.org>
        <20190918020530.818038260@goodmis.org>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 17 Sep 2019 22:03:38 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:


> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: linux-trace-devel@vger.kernel.org
> Cc: Patrick McLean <chutzpah@gentoo.org>

Sorry folks for the spam. This was a backport of the kernel's
libtraceevent into trace-cmd's version. I used quilt send mail to post
the series, and since I had the Cc's on this email, you were spammed
with this version.

Please ignore, as the patch is already in the Linux kernel git repo.

-- Steve


> Link: http://lore.kernel.org/linux-trace-devel/20190801074959.22023-2-tz.stoyanov@gmail.com
> Link: http://lore.kernel.org/lkml/20190805204355.041132030@goodmis.org
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> [ Added support for trace-cmd trace-read.c ]
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>
