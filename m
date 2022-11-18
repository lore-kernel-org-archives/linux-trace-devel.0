Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52DA0C4332F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 18 Nov 2022 15:04:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241993AbiKRPEh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 18 Nov 2022 10:04:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235245AbiKRPDy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 18 Nov 2022 10:03:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5148E8754F;
        Fri, 18 Nov 2022 07:02:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC75C625B8;
        Fri, 18 Nov 2022 15:02:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26359C433C1;
        Fri, 18 Nov 2022 15:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668783761;
        bh=q3AdceVXKG17FUFJhMNAS25TG3DfWOjPsij2iCMaBiA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gDrEnbj2Mo97VZeksz+3qmlZnpoCjUFJoa2ujergiAYVL+IDswDXdUJ4P5ru2aPwZ
         A2/B9gZUVk0GWssEZKm4GwkGtPPnlvKvIUmPbDlspP2O8JVHkcKfVWIkGL6wglVF8j
         JUjBg0GNsfhf3e/LHobPQ7mUpM4jD2ogYjcAN0F6pkr4grraotVpC6hpZ8QZyHWUBy
         i1tBLOmicaMFvnH/texbDaLL5gzekQ9QDcdzRCQbmZ55x8FI8vZCbdtENVx1Xxwr6q
         92Papa2KPTi1O/iyj/J2m4QhVDn9rkPANg9OqNpz2McNivOOHYtRvJ7dwwmHxtdgQB
         6zxZr7iOqra3A==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id D8F784034E; Fri, 18 Nov 2022 12:02:38 -0300 (-03)
Date:   Fri, 18 Nov 2022 12:02:38 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Ian Rogers <irogers@google.com>, Ingo Molnar <mingo@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Steven Rostedt <rostedt@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH v1 1/2] perf build: Require libtraceevent from the system
Message-ID: <Y3eejjLjChlGC96I@kernel.org>
References: <20221117224952.358639-1-irogers@google.com>
 <20221117224952.358639-2-irogers@google.com>
 <Y3dQxVNwGmQMWPP0@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3dQxVNwGmQMWPP0@hirez.programming.kicks-ass.net>
X-Url:  http://acmel.wordpress.com
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Em Fri, Nov 18, 2022 at 10:30:45AM +0100, Peter Zijlstra escreveu:
> On Thu, Nov 17, 2022 at 02:49:51PM -0800, Ian Rogers wrote:
> > Unconditionally require libtraceevent to come from the system. Force
> > the determination of the libtracefs version if it is present.
> 
> -ENOMOTIVATION

Yeah, I was going to ask for that as well :-\

And the motivation was spelled out in the discussion that led to this
patch:

https://lore.kernel.org/lkml/CAP-5=fWxAjEia-Qbm0RVzKOxyiod8rUOBieqaGK=DtQboDe3Qw@mail.gmail.com
 
> also:
> 
> Makefile.config:1196: *** Error: libtraceevent is missing, please install libtraceevent-dev.  Stop.

yeah, this probably should work like with other libraries, don't stop
the build, just don't build features that depend on libtraceevent,
warning the user that features foo, bar and baz won't be available.

For people working with just hardware, software, cache events, no
problem.

- Arnaldo
