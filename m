Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE3B6C04E69
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Aug 2023 16:25:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344664AbjHPQY6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Aug 2023 12:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344672AbjHPQYv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Aug 2023 12:24:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D273810EC
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Aug 2023 09:24:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70A4765D1F
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Aug 2023 16:24:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71418C433C8;
        Wed, 16 Aug 2023 16:24:48 +0000 (UTC)
Date:   Wed, 16 Aug 2023 12:24:50 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Stevie Alvarez <stevie.6strings@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Ross Zwisler <zwisler@google.com>
Subject: Re: [PATCH] libtraceeval histogram: Add type to traceeval_data and
 make it a structure
Message-ID: <20230816122450.53b10856@gandalf.local.home>
In-Reply-To: <20230816154145.GA1462@3xKetch>
References: <20230815193852.3e0a7328@gandalf.local.home>
        <20230816154145.GA1462@3xKetch>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 16 Aug 2023 11:41:45 -0400
Stevie Alvarez <stevie.6strings@gmail.com> wrote:

> >  void set_process_data(struct task_data *tdata, const char *comm, void *data)
> >  {
> > -	union traceeval_data keys[] = {
> > +	struct traceeval_data keys[] = {
> >  		{
> >  			.cstring = comm,
> >  		},  
> 
> Is there a reason you stop using the macros to define your
> traceeval_data array elements? Or a better question: Are these struct
> traceeval_data instances exempt to needing a type field? And if so, why?

No reason, I just missed this. I've updated it in my code and have a v2
ready to post. I just tested by compiling it. When I actually ran the code
(after posting the patches), it didn't give the same output, and found that
this was why :-p

-- Steve
