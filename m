Return-Path: <SRS0=FNt8=EM=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79DB9C2D0A3
	for <linux-trace-devel@archiver.kernel.org>; Fri,  6 Nov 2020 15:18:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AE78206A4
	for <linux-trace-devel@archiver.kernel.org>; Fri,  6 Nov 2020 15:18:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727182AbgKFPSX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 6 Nov 2020 10:18:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:48598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726708AbgKFPSW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 6 Nov 2020 10:18:22 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 663FA206A4;
        Fri,  6 Nov 2020 15:18:21 +0000 (UTC)
Date:   Fri, 6 Nov 2020 10:18:18 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 10/20] kernel-shark: Start using data streams
Message-ID: <20201106101818.77f94a0d@gandalf.local.home>
In-Reply-To: <d88af9bb-1f15-04cf-230c-ea59b3239931@gmail.com>
References: <20201012133523.469040-1-y.karadz@gmail.com>
        <20201012133523.469040-11-y.karadz@gmail.com>
        <20201014145627.675e3c70@gandalf.local.home>
        <b5569725-239f-3e5b-dfa0-97f7d51b5d01@gmail.com>
        <20201105131735.3d559bce@gandalf.local.home>
        <d88af9bb-1f15-04cf-230c-ea59b3239931@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 6 Nov 2020 16:31:58 +0200
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> Hi Steven,
> 
> I am not sure I understand correctly your pseudo-code, so please correct 
> me if my interpretation is wrong.

Note, it's not really pseudo code. I didn't compile it, but it should work
mostly unmodified.

> 
> In the normal case when a new stream is added the corresponding object 
> will be allocated and added to the array of pointers. Later if a stream 
> is removed, instead of freeing the memory we will just manipulate it 
> pointer so that it point to nowhere and this manipulation can be 
> detected by the kshark_is_valid_stream(). Now if we want to add stream 
> again, we will take the broken pointer, will restore its original value 
> and will reuse the object without a new allocations.
> 
> And at the very end we will have to free all pointers (original or 
> manipulated).
> 
> Is this what you are suggesting?

Hmm, let me explain it slightly different, as nothing is "restored".

We change the value of the array from pointer to an index. For ease of
explanation, let's consider this a 32bit machine and we allow 256 streams
(one byte). That is:


sizeof(long) == sizeof(void *) == 4

#define NR_OF_BITS_FOR_STREAM 8

#define KSHARK_INDEX_MASK 0x000000FF
#define KSHARK_INVALID_STREAM 0xFFFFFF00

Lets say we add 4 stream in a row. Each one will detect that free_stream is
equal to n_streams, and just append them to the end of the array
(reallocating the array if necessary). We end up with:


free_stream = 4
n_streams = 4

streams:

  0: 0x07123010   -> stream 1
  1: 0x07123020   -> stream 2
  2: 0x07123030   -> stream 3
  3: 0x07123040   -> stream 4


Now we free stream 3 (at location 2):

free_streams = 2
n_streams = 4

streams:
  0: 0x07123010   -> stream 1
  1: 0x07123020   -> stream 2
  2: 0xFFFFFF04	== (KSHARK_INVALID_MASK | orig:free_streams)
  3: 0x07123040   -> stream 4


Now we free stream 1 (at location 0):

free_streams = 0
n_streams = 4

streams:
  0: 0xFFFFFF02	== (KSHARK_INVALID_MASK | orig:free_streams)
  1: 0x07123020   -> stream 2
  2: 0xFFFFFF04	== (KSHARK_INVALID_MASK | 4)
  3: 0x07123040   -> stream 4


Now lets add stream 5:

free_streams = 2 == (streams[orig:free_streams] & KSHARK_INDEX_MASK)
n_streams = 4

streams:
  0: 0x07123050   -> stream 5
  1: 0x07123020   -> stream 2
  2: 0xFFFFFF04
  3: 0x07123040   -> stream 4

We are just making a link list of free pointers within the array of
streams. This is basically exactly how memory management systems work. The
free memory list is stored inside the memory itself that is being allocated.

The 0xFFFFFF is so that if we want to loop over streams, we can skip the
free slots, by checking: streams[i] & 0xFFFFFF00 != 0xFFFFFF00

Note, the free slots do not point any memory location. Think of the items
in the stream array as:

union {
	struct kshark_stream 	*stream;
	unsigned long		index;
};

You can differentiate without using typecasts with:

	if (streams[i].index & 0xFFFFFF00 == 0xFFFFFF00)
		index = streams[i].index & 0xFF;
	else
		stream = streams[i].stream;

Does that make more sense?

-- Steve
