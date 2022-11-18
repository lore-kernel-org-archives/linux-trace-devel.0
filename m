Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9228CC433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 18 Nov 2022 15:33:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235205AbiKRPdM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 18 Nov 2022 10:33:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234124AbiKRPdK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 18 Nov 2022 10:33:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5764113F;
        Fri, 18 Nov 2022 07:33:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62E71B823FB;
        Fri, 18 Nov 2022 15:33:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75B37C433C1;
        Fri, 18 Nov 2022 15:33:05 +0000 (UTC)
Date:   Fri, 18 Nov 2022 10:33:02 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ian Rogers <irogers@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Steven Rostedt <rostedt@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH v1 1/2] perf build: Require libtraceevent from the
 system
Message-ID: <20221118103302.7ea12016@gandalf.local.home>
In-Reply-To: <Y3eejjLjChlGC96I@kernel.org>
References: <20221117224952.358639-1-irogers@google.com>
        <20221117224952.358639-2-irogers@google.com>
        <Y3dQxVNwGmQMWPP0@hirez.programming.kicks-ass.net>
        <Y3eejjLjChlGC96I@kernel.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 18 Nov 2022 12:02:38 -0300
Arnaldo Carvalho de Melo <acme@kernel.org> wrote:

> yeah, this probably should work like with other libraries, don't stop
> the build, just don't build features that depend on libtraceevent,
> warning the user that features foo, bar and baz won't be available.
> 
> For people working with just hardware, software, cache events, no
> problem.

How are software events parsed?

-- Steve
