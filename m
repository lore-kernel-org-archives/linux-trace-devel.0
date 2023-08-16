Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE2F5C04A6A
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Aug 2023 01:05:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240907AbjHPBEn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Aug 2023 21:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240913AbjHPBEb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Aug 2023 21:04:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7F141FFB
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Aug 2023 18:04:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E550628CD
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Aug 2023 01:04:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45C31C433C8;
        Wed, 16 Aug 2023 01:04:29 +0000 (UTC)
Date:   Tue, 15 Aug 2023 21:04:29 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Ross Zwisler <zwisler@google.com>,
        Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [RFC][PATCH] libtraceeval: Add size checks to insert and query
 functions
Message-ID: <20230815210429.704ff5f3@gandalf.local.home>
In-Reply-To: <20230815200234.32fd17dd@gandalf.local.home>
References: <20230815200234.32fd17dd@gandalf.local.home>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 15 Aug 2023 20:02:34 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> --- a/samples/task-eval.c
> +++ b/samples/task-eval.c
> @@ -814,7 +814,7 @@ static void display_processes(struct traceeval *teval,
>  		struct process_data *pdata = NULL;
>  		const char *comm = keys[0].cstring;
>  
> -		ret = traceeval_query(teval_data, keys, &results);
> +		ret = traceeval_query(teval_data, keys, 2, &results);
>  		if (ret < 1)
>  			continue; /* ?? */
>  

That should be:

		traceeval_query_size(...)

I removed it to get the warning to copy into the change log, and ended up
not putting it back :-p

-- Steve
