Return-Path: <SRS0=Ozv+=ZZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73FBDC432C0
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Dec 2019 14:53:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A396207DD
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Dec 2019 14:53:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbfLCOxp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 3 Dec 2019 09:53:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:60528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725848AbfLCOxo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 3 Dec 2019 09:53:44 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9A4A20684;
        Tue,  3 Dec 2019 14:53:41 +0000 (UTC)
Date:   Tue, 3 Dec 2019 09:53:38 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Primiano Tucci <primiano@google.com>
Cc:     Joel Fernandes <joel@joelfernandes.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        aneesh.kumar@linux.ibm.com,
        Carmen Jackson <carmenjackson@google.com>,
        dan.j.williams@intel.com, Daniel Colascione <dancol@google.com>,
        jglisse@redhat.com, linux-mm@kvack.org,
        Mayank Gupta <mayankgupta@google.com>, mhocko@suse.com,
        minchan@kernel.org, mm-commits@vger.kernel.org,
        rcampbell@nvidia.com, Tim Murray <timmurray@google.com>,
        torvalds@linux-foundation.org, vbabka@suse.cz, willy@infradead.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [patch 026/158] mm: emit tracepoint when RSS changes
Message-ID: <20191203095338.7974a03c@gandalf.local.home>
In-Reply-To: <CA+yH71er-nUc2NJsVdJjKi5tgE4JvwEEjJrbbhby4zzR05CxHw@mail.gmail.com>
References: <20191201015030.MR-ux4mV1%akpm@linux-foundation.org>
        <20191202121415.1e64a461@gandalf.local.home>
        <20191202211345.GE17234@google.com>
        <20191202165601.42366c21@gandalf.local.home>
        <20191202234514.GR17234@google.com>
        <20191202185324.30b502bb@gandalf.local.home>
        <CA+yH71er-nUc2NJsVdJjKi5tgE4JvwEEjJrbbhby4zzR05CxHw@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 3 Dec 2019 02:48:37 +0000
Primiano Tucci <primiano@google.com> wrote:

> On Mon, Dec 2, 2019 at 11:53 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> On Mon, 2 Dec 2019 18:45:14 -0500
> Joel Fernandes <joel@joelfernandes.org> wrote:
> 
> >
> > I would love for that to happen but I don't develop Perfetto much. If I am
> > writing a tool I will definitely give it a go from my side. CC'ing Perfetto's
> > lead developer Primiano -- I believe you have already met Primiano at a
> > conference before as he mentioned it to me that you guys met. I also believe
> > this topic of using a common library was discussed before, but something
> > about licensing came up.  
> 
> Oh hello again!
> 
> > libtraceevent is under LGPL, is that an issue?  
> 
> Unfortunately yes, it is :/
> Our process for incorporating GPL or LGPL code makes Perfetto [1] (which is
> Apache-2 licensed) problematic for us and recursively for other projects that
> depend on us.

The reason for the LGPL was so that this code could be used by non GPL
code. Too bad the process is what limits this.

> 
> For context, Perfetto is a cross-platform tracing project based on shmem and
> protobuf, shipped on production devices and used by other app-developer-facing
> tools (e.g. [6, 7]). It deals with both:
> (1) pure userspace-to-userspace tracing (on all major OSs).
> (2) kernel tracing via ftrace/tracefs (only on Linux/Android).
> https://docs.perfetto.dev/ explains it a bit more.
> 

> 
> >From my viewpoint, it would be great if Linux treated the individual fields of  
> ftrace events as an ABI, given that ftrace events are exposed in their binary
> form to userspace through tracefs (which is something I'm extremely grateful
> for).

If this were to be the case, trace events would not even exist in the
kernel. The reason new trace events do not appear in the scheduler, and
the VFS layer refuses to add *any* trace events, is because they are
already a partial ABI. Making them an ABI would tightly couple the
implementation of Linux to the exported trace events. The reason I
created libtraceevent was to make it easier to modify trace events
without people worrying too much about the parsing of the events.

Just look at this thread. This started because I wanted to move the
shift operation from the fast path to the slow "print" path, and the
reason for not doing so is because we have a user space dependency on
it.

Really, the kernel developers are fearful about trace events causing
problems with future development. And just saying what you stated
re-enforces their beliefs, and expect to see less trace events being
exposed. This has come up at several kernel/maintainer summits, and
Linus finally has black listed the topic, stating that if it breaks
user space, it gets reverted, PERIOD!

  https://lwn.net/Articles/799262/

> 
> We use ftrace_pipe_raw through Perfetto in Android since 2017 and it has been
> working great with the exception of a few cases, mainly enums (see below).
> I'd love if we could solve the enum problem in a way that didn't involve running
> a C-preprocessor-alike runtime on the format files, regardless of licensing.
> 
> Unfortunately I don't have any docs that describe the Perfetto <> ftrace interop
> in great details. I apologize for that. I'll fix it soon but in the meanwhile
> I'll try to do my best to summarize this part of Perfetto here:
> 
> Our ftrace-interop code read()s the binary per_cpu/*/trace_pipe_raw, very
> similarly in spirit to what trace_cmd does.
> However, unlike trace_cmd, we convert the trace event stream into protobufs
> (e.g., [4]), doing binary-to-binary conversions (ftrace raw pipe -> protobuf) at
> runtime, asynchronously, on the device being traced.
> 
> The way we deal with format files in Perfetto is twofold:
> 1) We have an archive of known format files for the most common kernels we care
>   about. From this archive we generate protobuf schema files like [4]
>   at Perfetto-compile-time (which is != compile time of the target device's
>   kernel).
>   At runtime, on-device, we read the format files from tracefs and we merge
>   the compile-time knowledge (about messages and field names) with the ABI
>   described by tracefs' format files (message IDs, field types and offsets).
>   We make the following assumption about the ABI of raw ftrace events:
>   - We do *not* rely on message IDs being stable.
>   - We do *not* rely on the field offset to be stable.
>   - We do *not* rely on the size and length of int fields to be stable.
>   - We do *not* assume the presence of any field.
>   - We can detect if a field's type doesn't match anymore (e.g. a string became
>     an int) and ignore the field in that case.
>   - We only deal with fields whose name matches what known at compile-time.
>   This allows us to turn the raw ftrace into a binary-stable protobuf (modulo
>   some fields that might be missing) and allows us to play some other tricks
>   to reduce the size of the trace (e.g. intern/dedupe thread names).
> 
> 2) We have a generic schema [5] to transcode ftrace events that we didn't know
>    at Perfetto-compile-time. This allows us to deal with both ftrace events
>    introduced by future kernel versions or as a fallback for events in 1) where
>    we detect ABI mismatches at runtime. The downside of this generic
>    schema is that the cost of each event, in terms of trace-size, is
>    significantly higher.

Thanks for the detailed explanation.

Question, can the tool that reads the tracefs to feed the message ids,
fields, and sizes have LGPL in it? Then that tool itself could have
libtraceveent, and then you could create your own event format to feed
into the other compiled tool. This could solve a lot of issues.

> 
> There is a point where both 1 and 2 become problematic for us, and this is enums
> and, more in general, any ftrace field depends on macro expansions (which turns
> out to be mainly enums, in practice).
> For instance, the gfp_flags of ftrace events directly reflects the internal enum
> values, which are not stable across kenrnel versions. We had to come up
> with an internal map to catch up with the various kernel versions.
> There are few other cases like gfp_flags but they are quite rare and we ended up
> not needing those events, at least until now.

You are probably dealing with older kernels, as a bunch of newer
kernels have in it:

	TRACE_DEFINE_ENUM(<some-enum>);

Which will convert the enums into their actual values before exporting
it to tracefs. And when you have this combined with
CONFIG_TRACE_EVAL_MAP_FILE, you get a file in tracefs called eval_map
that shows the mapping of enums with their values (although, the enums
should have been converted in the tracefs format files).

BTW, the gfp flags look to be defines, and are converted in the format
files.

> 
> Beyond this, ingesting the raw trace events from ftrace raw pipes it has been
> great for all other events without requiring any other parsing library
> Super thanks for all the hard work on developing and maintaining ftrace.
> 
> Happy to discuss more on IRC, email or VC if you want to know more,
> Primiano.

Feel free to join us on #linux-rt on IRC OFTC if you are not already
there.

-- Steve

> 
> [1] https://docs.perfetto.dev
> [2] https://cs.chromium.org/chromium/src/third_party/perfetto/?q=f:perfetto&sq=package:chromium&dr
> [3] https://android.googlesource.com/platform/external/perfetto/
> [4] https://android.googlesource.com/platform/external/perfetto/+/refs/heads/master/protos/perfetto/trace/ftrace/sched.proto
> [5] https://android.googlesource.com/platform/external/perfetto/+/refs/heads/master/protos/perfetto/trace/ftrace/generic.proto
> [6] https://github.com/google/gapid/
> [7] https://developers.google.com/web/tools/chrome-devtools

