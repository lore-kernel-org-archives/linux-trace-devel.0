Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B97CFC4743C
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Jun 2021 23:23:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CBDC61245
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Jun 2021 23:23:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbhFUXZ1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Jun 2021 19:25:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:35534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230438AbhFUXZ1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Jun 2021 19:25:27 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D652611BD;
        Mon, 21 Jun 2021 23:23:12 +0000 (UTC)
Date:   Mon, 21 Jun 2021 19:23:10 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v6 25/45] trace-cmd: Read compressed trace data
Message-ID: <20210621192310.43e68a92@gandalf.local.home>
In-Reply-To: <20210614075029.598048-26-tz.stoyanov@gmail.com>
References: <20210614075029.598048-1-tz.stoyanov@gmail.com>
        <20210614075029.598048-26-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 14 Jun 2021 10:50:09 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> When reading a trace.dat file of version 7, uncompress the trace data.
> The trace data for each CPU is uncompressed in a temporary file, located
> in /tmp directory with prefix "trace_cpu_data".

With large trace files, this will be an issue. Several systems setup the
/tmp directory as a ramfs file system (that is, it is locate in ram, and
not backed up on disk). If you have very large trace files, which you would
if you are going to bother compressing them, by uncompressing them into
/tmp, it could take up all the memory of the machine, or easily fill the
/tmp limit.

Simply uncompressing the entire trace data is not an option. The best we
can do is to uncompress on a as needed basis. That would require having
meta data that is stored to know what pages are compressed.

-- Steve
