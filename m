Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E872C48BC2
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Jun 2021 20:08:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74C61611AC
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Jun 2021 20:08:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbhFWUK2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 23 Jun 2021 16:10:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:60054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229890AbhFWUK2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 23 Jun 2021 16:10:28 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8428561185;
        Wed, 23 Jun 2021 20:08:10 +0000 (UTC)
Date:   Wed, 23 Jun 2021 16:08:08 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [RFC] Man page for trace-cmd-v7.dat
Message-ID: <20210623160808.052715d2@gandalf.local.home>
In-Reply-To: <20210623144049.47c2ca01@gandalf.local.home>
References: <20210623144049.47c2ca01@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 23 Jun 2021 14:40:49 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> CPU DATA
> --------
> 
>   The CPU data is located in the part of the file that is specified
>   in the end of the header. Padding is placed between the header and
>   the CPU data, placing the CPU data at a page aligned (target page) position
>   in the file.
> 
>   This data is copied directly from the Ftrace ring buffer and is of the
>   same format as the ring buffer specified by the event header files
>   loaded in the header format file.
> 
>   The trace-cmd tool will try to \fBmmap(2)\fR the data page by page with the
>   target's page size if possible. If it fails to mmap, it will just read the
>   data instead.

A couple of things for the CPU date.

I think we can update how TRACECMD_OPTION_BUFFER is parsed:

So instead of:

  3     TRACECMD_OPTION_BUFFER

        String containing the name of the buffer instance, "\0" if it is the top level buffer.
        8 bytes that point to where an instance buffer exists

We turn it into:

  3	TRACECMD_OPTION_BUFFER

        String containing the name of the buffer instance, "\0" if it is the top level buffer.
	4 bytes - number of CPUs
	Array of the above number of CPUS
	- 4 bytes - CPU identifier (allow for CPUs to have something other
	            than 0 - nr_cpus), like just (CPU 2 and CPU 5)
	- 8 bytes - offset into the file where the CPU data section exists
	- 8 bytes - size of the CPU data section

Then for the CPU data that is pointed to, they would have the
TRACECMD_OPTION_BUFFER as their "type".

	2 bytes - TRACECMD_OPTION_BUFFER
	2 bytes - flags
	8 bytes - size of section in file
	8 bytes - size of uncompressed data (or size if not compressed)

	Page aligned (if not compressed) raw data.


Now if we want to add a way to have a per page compression, then create a
new option:

	TRACECMD_OPTION_BUFFER_COMPRESSED

	nul terminated string, for the instance name
	4 bytes - number of CPUs
	4 bytes - size of the buffer pages when uncompressed
		(they should all be the same)
	Array of the above number of CPUS
	- 4 bytes - CPU identifier (allow for CPUs to have something other
	            than 0 - nr_cpus), like just (CPU 2 and CPU 5)
	- 8 bytes - offset into the file where the CPU data section exists
	- 8 bytes - size of the CPU data section

The per page compressed buffers would have the
TRACECMD_OPTION_BUFFER_COMPRESSED as their type.

Since I believe all sections should still start with that special header,
the 

    2 bytes - Type of section (this will be the same as the option type)
    2 bytes - Flags - currently bit zero will define if the section is
              compressed or not.
    8 bytes - The size of the section in the file.
    8 bytes - The size of the section when uncompressed.
              If it is not compressed, then it will be equal
              to the size of the section in the file.

There would be no sense in compressing the section if the per pages are
going to be compressed, which would lead to this:

	2 bytes	- TRACECMD_OPTION_BUFFER_COMPRESSED
	2 bytes - zero (no compression of the section itself)
	8 bytes - size of the section in the file
	8 bytes - size of the section in the files
		(uncompressed so the above two numbers are the same)

	4 bytes - size of compressed page in file
	[ compressed page data ]

	4 bytes - size of next compressed page
	[ ... ]

Now to map the above if compressed by tracecmd_read_at(), it would require
two different methods.

For the TRACECMD_OPTION_BUFFER_COMPRESSED, it would be easy. We would need
to create a "uncompressed start" virtual address that we can use for the
record offsets (as they all need to be unique in the file).

	TRACECMD_OPTION_BUFFER_COMPRESSED_MAP

	4 bytes - the size of each uncompressed page.
	4 bytes - the CPU number of the mapping
	8 bytes - The "uncompressed start"
	8 bytes - The "uncompressed end"
	8 bytes - offset into file where the compressed map is

// the below is more pseudo code

tracecmd_read_at(struct tracecmd_input *handle, unsigned long long offset,
		 int *pcpu)
{
	if (handle->compressed)
		return read_at_compressed(handle, offset, pcpu);
	[..]
}

read_at_compressed(struct tracecmd_input *handle, unsigned long long offset,
		   int *pcpu)
{
	for (compressed = handle->compressed; *compressed; compressed = compressed->next) {
		if (offset >= compressed->start &&
		    offset < compressed->end)
			beak;
	}

	if (!compressed)
		return NULL;

	*pcpu = compressed->cpu;

	offset -= compressed->start;
	index = offset / handle->page_size;

	page = uncompress_page(compress->offset, index);

	return read_record(page + (offset - index * handle->page_size), *pcpu);
}

It's important to note that the "uncompressed start" and "uncompressed end"
must not overlap with any other buffer. They just need to be unique.

Now, if we compress the data as one chunk, the above would not work, and we
would need to come up with another plan. For now, we could just avoid
compressing the data as one chunk (not by individual pages).

-- Steve
