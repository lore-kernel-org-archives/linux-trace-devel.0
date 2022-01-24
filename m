Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D38EC433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 24 Jan 2022 21:48:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347194AbiAXVrw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 24 Jan 2022 16:47:52 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40962 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345332AbiAXVYk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 24 Jan 2022 16:24:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82D91B815A3
        for <linux-trace-devel@vger.kernel.org>; Mon, 24 Jan 2022 21:24:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3EE5C340E5;
        Mon, 24 Jan 2022 21:24:36 +0000 (UTC)
Date:   Mon, 24 Jan 2022 16:24:35 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v7 01/20] trace-cmd library: Add support for compression
 algorithms
Message-ID: <20220124162435.63e6a748@gandalf.local.home>
In-Reply-To: <20220124150335.2516da99@gandalf.local.home>
References: <20220119082715.245846-1-tz.stoyanov@gmail.com>
        <20220119082715.245846-2-tz.stoyanov@gmail.com>
        <20220123174851.52f0e2bb@rorschach.local.home>
        <CAPpZLN6BpbaThK66MJaykk7gSPDq2qQHkbmunQeT0NyMNMGnAw@mail.gmail.com>
        <20220124150335.2516da99@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 24 Jan 2022 15:03:35 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> > > > + * tracecmd_compress_copy_from - Copy and compress data from a file
> > > > + * @handle: compression handle
> > > > + * @fd: file descriptor to uncompressed data to copy from
> > > > + * @chunk_size: size of one compression chunk
> > > > + * @read_size: in - max bytes to read from @fd, 0 to read till the EOF
> > > > + *          out - size of the uncompressed data read from @fd    
> > >
> > > Is this an array of two?    
> > 
> > No, it is a pointer to single long long, used as input and output parameter.  
> 
> I'm confused by the comment then. What is does the above "in" and "out"
> mean? 

OK, looking at the code I see what you meant, but it should be written more
like:

 * @read_size: Pointer to max bytes to read from.
              Updates the pointer with the size of compressed data read.

Then in the description explain it more.

 * @read_size should be the address of an unsigned long long value
 * containing the max size to read from, or containing zero to read till
 * EOF. On successful return, @read_size will contain the size of the
 * unpressed data that was read.

-- Steve
