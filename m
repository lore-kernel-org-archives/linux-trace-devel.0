Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68BC1C04A68
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Jul 2022 16:31:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbiGZQb5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 26 Jul 2022 12:31:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbiGZQb4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 26 Jul 2022 12:31:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9845F765A;
        Tue, 26 Jul 2022 09:31:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F23161513;
        Tue, 26 Jul 2022 16:31:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BD8BC433C1;
        Tue, 26 Jul 2022 16:31:52 +0000 (UTC)
Date:   Tue, 26 Jul 2022 12:31:50 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Daniel Bristot de Oliveira <bristot@kernel.org>
Cc:     Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marco Elver <elver@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Gabriele Paoloni <gpaoloni@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Tao Zhou <tao.zhou@linux.dev>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH V7 11/16] Documentation/rv: Add deterministic automata
 instrumentation documentation
Message-ID: <20220726123150.208e7a17@gandalf.local.home>
In-Reply-To: <9ed16a6d24b9d993e09755d6e18ff5e7d5434636.1658778484.git.bristot@kernel.org>
References: <cover.1658778484.git.bristot@kernel.org>
        <9ed16a6d24b9d993e09755d6e18ff5e7d5434636.1658778484.git.bristot@kernel.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 25 Jul 2022 22:11:23 +0200
Daniel Bristot de Oliveira <bristot@kernel.org> wrote:

> +++ b/Documentation/trace/rv/da_monitor_instrumentation.rst
> @@ -0,0 +1,171 @@


> +Finally, the "handle_sched_waking()" will look like::
> +
> +  void handle_sched_waking(void *data, struct task_struct *task)
> +  {
> +        da_handle_event_wip(sched_waking_wip);
> +  }
> +
> +And the explanation is left for the reader as an exercise.
> +
> +enable and disable functions
> +------------------------

The doc processing requires that the '-' count matches the above string
count. And you may want to capitalize the first letter:

Enable and disable functions
----------------------------

-- Steve

> +
> +dot2k automatically creates two special functions::
> +
> +  enable_$(MONITOR_NAME)()
> +  disable_$(MONITOR_NAME)()
> +
