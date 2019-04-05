Return-Path: <SRS0=Gl8V=SH=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BA12C10F0F
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Apr 2019 14:31:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 463542186A
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Apr 2019 14:31:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731251AbfDEObN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Apr 2019 10:31:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:40964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731140AbfDEObN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Apr 2019 10:31:13 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4F63206DD;
        Fri,  5 Apr 2019 14:31:12 +0000 (UTC)
Date:   Fri, 5 Apr 2019 10:31:11 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org, Darren Hart <darren@dvhart.com>
Subject: Re: [PATCH 03/10] tools lib traceevent: Removed unneeded !! and
 return parenthesis
Message-ID: <20190405103111.77593cde@gandalf.local.home>
In-Reply-To: <20190405140332.10949-4-tstoyanov@vmware.com>
References: <20190405140332.10949-1-tstoyanov@vmware.com>
        <20190405140332.10949-4-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri,  5 Apr 2019 17:03:25 +0300
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> From: Steven Rostedt (VMware) <rostedt@goodmis.org>
> 
> As return is not a function we do not need parenthesis around the return
> value. Also, a function returning bool does not need to add !!.
> 
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> Link: https://nam04.safelinks.protection.outlook.com/?url=http%3A%2F%2Flkml.kernel.org%2Fr%2F20190401164343.817886725%40goodmis.org&amp;data=02%7C01%7Ctstoyanov%40vmware.com%7C420f58a3ff864e3d93b408d6b7853daf%7Cb39138ca3cee4b4aa4d6cd83d9dd62f0%7C0%7C0%7C636898180235384820&amp;sdata=PTx4BKspBlUxHIPfzZRf2Rj5J8LmfzXxdCIXKdDUtoA%3D&amp;reserved=0

Hmm, this isn't acceptable for upstream.

-- Steve


> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
