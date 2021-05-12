Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF5D8C433B4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 May 2021 13:55:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 885F5611CC
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 May 2021 13:55:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbhELN4w (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 12 May 2021 09:56:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:55996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230343AbhELN4w (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 12 May 2021 09:56:52 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAFF9611AC;
        Wed, 12 May 2021 13:55:43 +0000 (UTC)
Date:   Wed, 12 May 2021 09:55:41 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Jerome Marchand <jmarchan@redhat.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: Re: trace-cmd profile is not working
Message-ID: <20210512095541.4dcfdb4d@gandalf.local.home>
In-Reply-To: <8c1d353e-05d5-d789-00a2-de94d705950e@redhat.com>
References: <8c1d353e-05d5-d789-00a2-de94d705950e@redhat.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 12 May 2021 15:51:52 +0200
Jerome Marchand <jmarchan@redhat.com> wrote:

> Hi,
> 
> Streams, and thus trace-cmd profile, are not working. A simple
> "trace-cmd profile ls" command exit with the following message
> "Creating stream for 0". I've been looking at it and the issue is that 
> tracecmd_read_headers() tries to read the cmdlines, cpus and options 
> sections that have not been written to the temporary file when called 
> from trace_stream_init().
> 
> AFAICT, it is caused by the two following patches:
> 
> commit 1eea02a4 ("trace-cmd: Write saved cmdlines in the trace file at
> the end of the trace.") which moved the writing of cmdlines from
> create_file_fd() to tracecmd_create_file_latency() and
> tracecmd_append_cpu_data()
> 
> commit 5d4d7ec3 ("trace-cmd: Move reading of trace.dat options to
> tracecmd_read_headers()") which moved the reading of options and cpu
> datas to tracecmd_read_headers().
> 

Thanks for the report. I'm not surprised, profiling and streams have not
been given the love they deserve (been focusing on host/guest tracing
recently).

Can you fill out a bug report on bugzilla?

  https://bugzilla.kernel.org/buglist.cgi?component=Trace-cmd%2FKernelshark&list_id=1090417&product=Tools&resolution=---

Thanks!

-- Steve
