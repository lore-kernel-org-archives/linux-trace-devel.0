Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7F08C636D7
	for <linux-trace-devel@archiver.kernel.org>; Tue, 21 Feb 2023 17:43:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234572AbjBURnF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 21 Feb 2023 12:43:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234612AbjBURnE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 21 Feb 2023 12:43:04 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 69B6611661;
        Tue, 21 Feb 2023 09:42:59 -0800 (PST)
Received: from kbox (unknown [76.135.27.212])
        by linux.microsoft.com (Postfix) with ESMTPSA id BEF2220B9C3D;
        Tue, 21 Feb 2023 09:42:58 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com BEF2220B9C3D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1677001378;
        bh=UdawTwwO71lxoKFJNQNZK4j5Eqy8pbnSBH6Y6niaA1c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Po8qeuIZc1bvi1kmG/ekijQuO3PX/xc0pM9tkjGorwb/WllqrZJbQTjAQzd/sCdoj
         4XZwKO8iMZlpUddQlXXsYT0WuOIy2ARLbd/Uu0KQ3H+yXE1ozNltKWElVS1W2UNs8V
         NIsy3+UNLkgBUg839YwpG6Ki4HPFbBIszaqbtm3o=
Date:   Tue, 21 Feb 2023 09:42:51 -0800
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
        dcook@linux.microsoft.com, alanau@linux.microsoft.com,
        brauner@kernel.org, akpm@linux-foundation.org,
        linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 00/11] tracing/user_events: Remote write ABI
Message-ID: <20230221174251.GA1786@kbox>
References: <20230120230518.17697-1-beaub@linux.microsoft.com>
 <20230220170135.3c9bea01@rorschach.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230220170135.3c9bea01@rorschach.local.home>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Feb 20, 2023 at 05:01:35PM -0500, Steven Rostedt wrote:
> On Fri, 20 Jan 2023 15:05:07 -0800
> Beau Belgrave <beaub@linux.microsoft.com> wrote:
> 
> 
> >  Documentation/trace/user_events.rst           | 177 ++--
> >  fs/exec.c                                     |   2 +
> >  include/linux/sched.h                         |   5 +
> >  include/linux/user_events.h                   | 101 +-
> >  include/uapi/linux/user_events.h              |  81 ++
> >  kernel/exit.c                                 |   2 +
> >  kernel/fork.c                                 |   2 +
> 
> There's several files that are touched outside of the tracing
> subsystem. You may need to run get_maintainers on this to get their
> input. I started playing a little with this, but it won't mean anything
> if we get push back from these maintainers.
> 
> -- Steve
> 

Would you prefer I start another version and include the key maintainers
from fs/exec.c, kernel/exit.c, and kernel/fork.c?

I've added akpm and brauner in these patches. I've pinged akpm privately
about these, but didn't get any responses.

It seems like Eric Biederman, Kees Cook, and linux-mm would be good
folks to add here from get_maintainers outputs.

Thoughts?

Thanks,
-Beau

> 
> >  kernel/trace/Kconfig                          |   5 +-
> >  kernel/trace/trace_events_user.c              | 863 +++++++++++++++---
> >  samples/user_events/example.c                 |  47 +-
> >  tools/testing/selftests/user_events/Makefile  |   2 +-
> >  .../testing/selftests/user_events/abi_test.c  | 226 +++++
> >  .../testing/selftests/user_events/dyn_test.c  |   2 +-
> >  .../selftests/user_events/ftrace_test.c       | 162 ++--
> >  .../testing/selftests/user_events/perf_test.c |  39 +-
> >  15 files changed, 1317 insertions(+), 399 deletions(-)
> >  create mode 100644 include/uapi/linux/user_events.h
> >  create mode 100644 tools/testing/selftests/user_events/abi_test.c
> > 
> > 
> > base-commit: 5dc4c995db9eb45f6373a956eb1f69460e69e6d4
