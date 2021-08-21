Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67E6FC4338F
	for <linux-trace-devel@archiver.kernel.org>; Sat, 21 Aug 2021 02:18:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46637611C8
	for <linux-trace-devel@archiver.kernel.org>; Sat, 21 Aug 2021 02:18:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240330AbhHUCTF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Aug 2021 22:19:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:39408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229610AbhHUCTE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Aug 2021 22:19:04 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1974F6117A;
        Sat, 21 Aug 2021 02:18:25 +0000 (UTC)
Date:   Fri, 20 Aug 2021 22:18:23 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Tzvetomir Stoyanov" <tz.stoyanov@gmail.com>,
        Tom Zanussi <zanussi@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v9 6/6] selftests/ftrace: Add selftest for testing
 duplicate eprobes and kprobes
Message-ID: <20210820221823.3fd68cc5@oasis.local.home>
In-Reply-To: <20210821104152.de68dee1b30a72bf2b0c815f@kernel.org>
References: <20210820204644.546662591@goodmis.org>
        <20210820204742.653288346@goodmis.org>
        <20210821104152.de68dee1b30a72bf2b0c815f@kernel.org>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sat, 21 Aug 2021 10:41:52 +0900
Masami Hiramatsu <mhiramat@kernel.org> wrote:

> OK, this looks good to me.
> 
> Acked-by: Masami Hiramatsu <mhiramat@kernel.org>

Thanks Masami for your acks, and all the time you spent on reviewing
this series. I'll be add this all to my linux-next queue.

Cheers!

-- Steve
