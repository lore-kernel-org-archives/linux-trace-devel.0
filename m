Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0231EC49EA2
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Jun 2021 13:51:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF7106128C
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Jun 2021 13:51:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbhFVNxo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Jun 2021 09:53:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:38342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229907AbhFVNxn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Jun 2021 09:53:43 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E158B6128C;
        Tue, 22 Jun 2021 13:51:27 +0000 (UTC)
Date:   Tue, 22 Jun 2021 09:51:26 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v6 25/45] trace-cmd: Read compressed trace data
Message-ID: <20210622095126.20fa7879@gandalf.local.home>
In-Reply-To: <CAPpZLN4dHKxa2DztSurSow=PbsFSyuLgkifHt8yvJ6kL8pvu8Q@mail.gmail.com>
References: <20210614075029.598048-1-tz.stoyanov@gmail.com>
        <20210614075029.598048-26-tz.stoyanov@gmail.com>
        <20210621192310.43e68a92@gandalf.local.home>
        <CAPpZLN4dHKxa2DztSurSow=PbsFSyuLgkifHt8yvJ6kL8pvu8Q@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 22 Jun 2021 13:50:44 +0300
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> > With large trace files, this will be an issue. Several systems setup the
> > /tmp directory as a ramfs file system (that is, it is locate in ram, and
> > not backed up on disk). If you have very large trace files, which you would
> > if you are going to bother compressing them, by uncompressing them into
> > /tmp, it could take up all the memory of the machine, or easily fill the
> > /tmp limit.  
> 
> There are a few possible approaches for solving that:
>  - use the same directory where the input trace file is located

I thought about that, but then decided against it, because there's a reason
people compress it. If we have to uncompress it to read it, I can see
people saying "why is it compressed in the first place?" When data is
compressed to save disk space (which I consider this a case), then the
reading has to uncompress it on a as-needed basis.

>  - use an environment variable for user specified temp directory for these files
>  - check if there is enough free space on the FS before uncompressing
> 
> >
> > Simply uncompressing the entire trace data is not an option. The best we
> > can do is to uncompress on a as needed basis. That would require having
> > meta data that is stored to know what pages are compressed.
> >  
> I can modify that logic to compress page by page, as the data is
> loaded by pages. Or use some of the above approaches ?

Doing it page by page is probably the most logical solution. It will make
it easier to manage without needing to create separate temporary files.

I'm guessing we need an index of each page and where they start. We need a
way to map the record offset to the page that contains it in such a way
that tracecmd_read_at() still works.

We could keep this in the file, or create it from the data. I'm thinking
saving this as a section in the file would be good as it would be quicker
for loading.

Have a section for each CPU, that maps each page with their compressed
offset in the file, and then just consider the page to be page size.

Oh, which reminds me, we need to make sure that we don't use
"getpagesize()" to determine the size of the page buffers, because I may be
making the buffers more than a single page. It must use the header_page
file in the events directory, because it that might change in the future!

Anyway, we can have this:

	buffer_page_size:	4096

/* lets say the compressed data starts at 10,000 just to make this easier
to explain. */

	u64 cpu_array[0]	10000 <- page 1 (compress to 100 bytes)
				10100 <- page 2 (compressed to 150 bytes)
				10250 <- page 3
				[...]

But the record->offset should contain the offset of the uncompressed data.
That is, if the record is on page 2 at offset 400 (uncompressed) then
offset should be:

	record->offset = 14496 (10000 + 4096 + 400)

Which would be calculated as:

	record->offset = cpu_data_start[cpu] + page * buffer_page_size + offset;

This also means that cpu_array[1] has to save its uncompressed start. That
is, even though it may start at 20,000 in the trace data file (10,000 more
than the cpu_array[0] start). It's uncompressed location needs to account
for all the cpu_array[0] pages, such that no two record's offsets will
overlap if they are on different CPUs.

	cpu_data_start[0] = 10000 (but has 1000 pages, where 1000 * 4096 = 4,096,000)

But even if cpu_array[1] starts at 20000, it has to account for the
uncompressed cpu_array[0] data, thus we have:

	cpu_data_start[1] = 4106000 (4096000 + 10000)

-- Steve
