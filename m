Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE076C001E0
	for <linux-trace-devel@archiver.kernel.org>; Tue,  1 Aug 2023 11:47:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234389AbjHALrS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 1 Aug 2023 07:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234369AbjHALrQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 1 Aug 2023 07:47:16 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F0A71712;
        Tue,  1 Aug 2023 04:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=TdpPIvgN+cdaHFVUOeW5qe3U6jUZBrGZ60UhJBXmvpY=; b=nlMuLsMdUfdbuRxXz8ioQYr9dR
        o686TG0N5P3FFJm71RgPXPuXuyi5MGCmJAwWjvWWD1FGfOVZghopNFrXVMrGwmCltAbzFaEPUjz67
        +bYTPHB8bqmpL17ba+a4/SToPkoEqTYC06G6LWtHg7RqwZbkDfAFypL/pDqf6zpIdc3l997qe2lYk
        F0PcYe0qRh4M0IsAHqoBm0KuTPdMbvaxxlfjXkMhxyizUyV5yVdvP+Rb6keTanahrL+cMkhP9gA+o
        reZfMTOT1G8UYsSshlsOnnC36pK5Q7ZKpVzTiP5oLC2H+MK0ytmlEIBGpfi67VDUB+P3jejVM1fMR
        +ZjaBQoA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qQnpz-00Edek-29;
        Tue, 01 Aug 2023 11:46:51 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 07920300134;
        Tue,  1 Aug 2023 13:46:51 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id ED4EF200C570F; Tue,  1 Aug 2023 13:46:50 +0200 (CEST)
Date:   Tue, 1 Aug 2023 13:46:50 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Ze Gao <zegao2021@gmail.com>
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org,
        linux-trace-devel@vger.kernel.org, Ze Gao <zegao@tencent.com>
Subject: Re: [RFC PATCH v3 4/6] sched, tracing: reorganize fields of switch
 event struct
Message-ID: <20230801114650.GE79828@hirez.programming.kicks-ass.net>
References: <20230801090124.8050-1-zegao@tencent.com>
 <20230801090124.8050-5-zegao@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230801090124.8050-5-zegao@tencent.com>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Aug 01, 2023 at 05:01:22PM +0800, Ze Gao wrote:
> Report priorities in 'short' and prev_state in 'int' to save
> some buffer space. And also reorder the fields so that we take
> struct alignment into consideration to make the record compact.
> 
> Suggested-by: Steven Rostedt (Google) <rostedt@goodmis.org>

I don't see a single line describing the effort you've done to audit
consumers of this tracepoint.

*IF* you're wanting to break this tracepoint ABI, because seriously
that's what it is, then you get to invest the time and effort to audit
the users.
