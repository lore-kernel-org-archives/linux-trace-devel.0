Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA0EAC433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 18 Feb 2022 19:22:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234733AbiBRTWk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 18 Feb 2022 14:22:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234688AbiBRTWk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 18 Feb 2022 14:22:40 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFE5E340F0
        for <linux-trace-devel@vger.kernel.org>; Fri, 18 Feb 2022 11:22:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BE6EECE3315
        for <linux-trace-devel@vger.kernel.org>; Fri, 18 Feb 2022 19:22:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4840C340E9;
        Fri, 18 Feb 2022 19:22:17 +0000 (UTC)
Date:   Fri, 18 Feb 2022 14:22:16 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: Rotation of instance traces
Message-ID: <20220218142216.535d56c6@gandalf.local.home>
In-Reply-To: <CAEXW_YT5sCze=m-HubMjNLKmuUMqNQ_VbnT+7mmOULC-rJO8hA@mail.gmail.com>
References: <CAEXW_YT5sCze=m-HubMjNLKmuUMqNQ_VbnT+7mmOULC-rJO8hA@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 18 Feb 2022 13:45:44 -0500
Joel Fernandes <joel@joelfernandes.org> wrote:

> Hello!
> 
> I am seeing something weird with trace instances, that I don't see
> with regular non-instance traces.
> 
> If I enable some sched events and set the buffer size to something
> tiny, like 1KB, I am expecting the buffer to rotate quickly as it
> overflows, but I don't see that:
> 
>   watch "cat trace | head -n 1" and I see the following
> 
> https://paste.googleplex.com/6259651512369152?raw
> 
> and if I do some heavy workloads, I still see that the top rows are
> not moving and are stuck showing the same thing. I am expecting the
> buffer to drop old events as it is being overwritten/rotation.
> 
>  However if I do a tail on the trace, I do see updates. So tracing is
> in progress...
> 
> I did the exact same experiment on non-instance global tracing and it
> works fine. I confirmed that 'overwrite' is set in the trace_options
> of the instance (and non-instance).
> 
> This could be some trace formatting issue or another bug? Note I am
> reading the tracefs trace file directly and not using trace-cmd for
> this.

It's not a bug it's a feature ;-)

The "trace" file is not a consumer file. That is, it does not clear out the
ring buffer when you read it. If you want that, use trace_pipe.

What you are seeing is the effect of the implementation of the ring buffer.
As the ring buffer is broken up into "sub buffers" which are currently a
page in size. Although Tzvetomir has RFC patches to change that:

  https://patchwork.kernel.org/project/linux-trace-devel/list/?series=594661&state=*


If you pause tracing (echo 0 > tracing_on) you can read the trace file over
and over and still get the same result. That is because it uses an iterator
to read over the ring buffer and does not modify it. But if you were to use
trace_pipe, it consumes the tracing data, and it does so by swapping out
the sub buffers from the ring buffer and giving it to the user.

Now to be able to do things like splice, and zero copy from the ring
buffer, when you read the ring buffer it swaps out a sub buffer from the
writable portion of the ring buffer and makes it into the "reader_page".
The reader page is now own by the reader, and will never be written to.
This allows the reader to take its time to read it and not worry about
being overwritten by the writer.

Now what you are seeing, is that a reader page was swapped out of the ring
buffer. This means that it will never be written to again, as it belongs to
the reader (it's the reader page). And since you are using the "trace" file
and not the "trace_pipe" file, it will not even discard this page. But as
you have not turned off tracing, the rest of the ring buffer is still being
updated.

What happens is, the start of the trace file will show you the reader page
(never be updated, and will always stay the same), and then walk into the
writable section of the ring buffer, which will constantly be updated. This
gives you exactly what you are seeing.

Like I said, it's a feature!

Now, why is it not happening in the top level file? It's because if the
reader page has not be read yet, the iterator may go right into the
writable portion and skip over the reader page as it is empty. If you did
something that causes the reader page to be filled, it will give you what
you see. So this isn't a difference between the instances and top level,
it's a difference between what you have have done to the instances before
reading the trace file, which you did not do for the top level buffer.

They both use the same code, so they should be acting identically.

-- Steve
