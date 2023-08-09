Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2886FC001E0
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Aug 2023 18:30:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbjHISap convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Aug 2023 14:30:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjHISap (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Aug 2023 14:30:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E5ECA3
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Aug 2023 11:30:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE13F6143D
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Aug 2023 18:30:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D77E3C433C8;
        Wed,  9 Aug 2023 18:30:42 +0000 (UTC)
Date:   Wed, 9 Aug 2023 14:30:41 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Stevie Alvarez <stevie.6strings@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Ross Zwisler <zwisler@google.com>
Subject: Re: [PATCH v4 0/5] histograms: Fix memory leak, logic bugs,
 legibility
Message-ID: <20230809143041.39ad7ae8@gandalf.local.home>
In-Reply-To: <20230809175340.3066-1-stevie.6strings@gmail.com>
References: <20230809175340.3066-1-stevie.6strings@gmail.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed,  9 Aug 2023 13:53:33 -0400
Stevie Alvarez <stevie.6strings@gmail.com> wrote:

> From: Stevie Alvarez (Google) <stevie.6strings@gmail.com>
> 
> Changes in v4:
>  * Reorder enum traceeval_data_type numeric types for algorithmic access.
>  * Reorder union traceeval_data numeric fields for legibility.
>  * Remove parenthesis from function name in kerneldocs.
>  * Optimize logic in type_alloc().
>  * Distinguish internal vs public interfaces within include statements.
>  * Rework copy_traceeval_data() logic for legibility.
>  * Rework comparator return types to fix query and insert bugs.
>  * update_entry() frees the entries old values to avoid a memory leak.
> 
> Steven, I didn't get around to adding in the cstring field to
> traceeval_data, as I wasn't able to completely grasp what you were
> looking for. My apologies.

Thanks Stevie!

I'm going to pull these in as-is and build on top of them for the rest so
that you can work on other things. I'll still do a review of these patches
for your own understanding, but you don't need to send another series.

As for the cstring. Without it, I get these warnings in the task-eval.c program:

libtraceeval.git/samples/task-eval.c: In function ‘update_process’:
libtraceeval.git/samples/task-eval.c:197:35: warning: initialization discards ‘const’ qualifier from pointer target type [-Wdiscarded-qualifiers]
  197 |                         .string = comm,
      |                                   ^~~~
libtraceeval.git/samples/task-eval.c: In function ‘get_process_data’:
libtraceeval.git/samples/task-eval.c:255:35: warning: initialization discards ‘const’ qualifier from pointer target type [-Wdiscarded-qualifiers]
  255 |                         .string = comm,
      |                                   ^~~~
libtraceeval.git/samples/task-eval.c: In function ‘set_process_data’:
libtraceeval.git/samples/task-eval.c:278:35: warning: initialization discards ‘const’ qualifier from pointer target type [-Wdiscarded-qualifiers]
  278 |                         .string = comm,

as in update_process() (and other functions) we have:

static void update_process(struct task_data *tdata, const char *comm,
			   enum sched_state state, enum command cmd,
			   unsigned long long ts)
{
	const union traceeval_data keys[] = {
		{
			.string		= comm,
		},
		{
			.number		= state,
		},
	};


Because these queries are performed on const char *strings. That is, in
order to do a traceeval_query() I need to populate the keys array. And if
I'm using a const char *string to do the search, I need to use a const
pointer to assign with.

So, if we supply a "const char * cstring" to the union, and I use:

	const union traceeval_data keys[] = {
		{
			.cstring	= comm,
		},

It makes the compiler happy!

-- Steve

> 
> ---
> v3 discussion: https://lore.kernel.org/linux-trace-devel/20230808180156.GA1300@3xKetch/T/#t
> 
> Stevie Alvarez (Google) (5):
>   histograms: Initial histograms interface
>   histograms: Add traceeval initialize and release
>   histograms: Add traceeval compare
>   histograms: Add traceeval query
>   histograms: Add traceeval insert
> 
>  Makefile                 |   2 +-
>  include/traceeval-hist.h | 147 +++++++
>  include/traceeval-test.h |  16 +
>  src/Makefile             |   1 +
>  src/histograms.c         | 804 +++++++++++++++++++++++++++++++++++++++
>  5 files changed, 969 insertions(+), 1 deletion(-)
>  create mode 100644 include/traceeval-hist.h
>  create mode 100644 include/traceeval-test.h
>  create mode 100644 src/histograms.c
> 

