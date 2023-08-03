Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DA3FC41513
	for <linux-trace-devel@archiver.kernel.org>; Thu,  3 Aug 2023 02:38:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232355AbjHCCiT convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 2 Aug 2023 22:38:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233721AbjHCCiE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 2 Aug 2023 22:38:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E794EB2;
        Wed,  2 Aug 2023 19:37:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F5B661BBB;
        Thu,  3 Aug 2023 02:37:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEFFBC433C8;
        Thu,  3 Aug 2023 02:37:20 +0000 (UTC)
Date:   Wed, 2 Aug 2023 22:37:18 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Ze Gao <zegao2021@gmail.com>
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org,
        linux-trace-devel@vger.kernel.org, Ze Gao <zegao@tencent.com>
Subject: Re: [RFC PATCH v4 1/7] libtraceevent: sync state char array with
 the kernel
Message-ID: <20230802223718.6e34d3ff@gandalf.local.home>
In-Reply-To: <CAD8CoPAPjuE5Ni2aTJcS5=M8TNOLqp3t4gfL=iWVrx39a25r2Q@mail.gmail.com>
References: <20230802121116.324604-1-zegao@tencent.com>
        <20230802121116.324604-2-zegao@tencent.com>
        <20230802103630.45d95c06@gandalf.local.home>
        <CAD8CoPAPjuE5Ni2aTJcS5=M8TNOLqp3t4gfL=iWVrx39a25r2Q@mail.gmail.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 3 Aug 2023 10:13:16 +0800
Ze Gao <zegao2021@gmail.com> wrote:

> FYI, I‘ve already cc-ed to it.  Do you mean I need to resend this patch
> to linux-trace-devel@vger.kernel.org solely and exclude this one from
> this series?
> 

I searched the Cc list and missed it. Anyway, you only need to Cc the
patches that touch libtracevent, and not the rest. No biggy, I just have to
mark them as "Handled elsewhere" in patchwork.

-- Steve
