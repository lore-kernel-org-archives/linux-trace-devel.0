Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81F2BC433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 02:37:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbhLBCk3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 1 Dec 2021 21:40:29 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:51165 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351587AbhLBCkV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 1 Dec 2021 21:40:21 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 664845C0109;
        Wed,  1 Dec 2021 21:36:57 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 01 Dec 2021 21:36:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=kg+bBSJXrAJG0Jnlmio2Ypjpo6Q
        j0sf1AcVvaZG+FAA=; b=IaaEAeEiHFLHS6RftAvYgSmdceHsW+zXBHuoe9IPBms
        MGBPWxdc5JR4wS8/adEav2QPQLNFinfbmtUA+TvO/x8nKQwmurBzdd4niz75LN69
        FJriZSkYSgdmvluKuOJ4VhzdIoy4Du9m4b7REUyR3GzluJujUaDVx+285dc85oOn
        LRYA+4C/UhKGX/TZ1JgJ3edJcU6ieFieSNqsW1CaQNQQwp1DbN3DdkU8IiLPC1AJ
        4FI5d1K4KfMiHCefMjeTxNZRYj+dBelsQdT4I3l/GVqwAjUW/HdqzNd8W8JJzJk8
        v328tnaztNwvk9wGwvIkaNjho9ONzSpH0hqQDTliKlA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=kg+bBS
        JXrAJG0Jnlmio2Ypjpo6Qj0sf1AcVvaZG+FAA=; b=X97xKBoF6eQ/mtCUdwVI28
        hOkF8+Pbq8ZruRH3vgq7f+DU3tAQ2hqQK8BCXu43iS0b6Zul2xcHQ/fIBQ+5YquX
        6pifiEmMLVbAcdRnf3GaA/KIfEGtZQZaG2pavwJ3iNwuvjsjzQZKIQEj0s2EAdJv
        adcEwuNjN/Y8PJJSMAep1M9XIYIRk3GO9lUJ8bZyuBFP7OKGwCArfif7VR9HOLV3
        ZktjTrUK9oJQPx594tLE7CMUUQeNemoE+1SuECUV1neguhlsp5Gbol76tJzAO/uB
        ni7NZWA1EAxNrsOZCJKGaS2+d+l04x3FWyyMPvCLI3hXzIoAXvcDwPvN50WqHarg
        ==
X-ME-Sender: <xms:STGoYeFJMsMRqjuzt1g4oUIQTtERSzZUwITrQLnqdyzsXESaJuNJ5w>
    <xme:STGoYfW2K8yA_k4XT6178or095spvzJGS0uF5v630bzHGaIoGZJNPHXrbUkH36vLN
    JrkUL7Z8fv9lEoc5w>
X-ME-Received: <xmr:STGoYYJcOUwkSzpy1m3rVgYCOVua7wMJzipUP8qi_9KIevINVheXUzpXCDMD5TQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrieeggdeglecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepofhitghhrggv
    lhcuufgrrhhtrghinhcuoehmihhkvghsrghrthesfhgrshhtmhgrihhlrdgtohhmqeenuc
    ggtffrrghtthgvrhhnpeffkedvjeduudfhvdevgeevfefghfejveeghfevgefhffekgeeg
    keduvdekfeefgeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfh
    hrohhmpehmihhkvghsrghrthesfhgrshhtmhgrihhlrdgtohhm
X-ME-Proxy: <xmx:STGoYYGbREYBBZP8nyaLD1_hDrO-uba5JOuPGA_Vicb2mrqD-_6aVA>
    <xmx:STGoYUXgGwRVtJjLDw0JS-c5kk0DSU0ThcYjmMgbUfJrfKe58qDVGQ>
    <xmx:STGoYbMX3-FT17gWmc9P5CXKNAb8A31iY3V-TpK-FY4DjBuKwZvPQA>
    <xmx:STGoYdfH8Lg4umuFfFM9w8Ha1XLUrORWqh_UOvcVJR57_ScyDIDknQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 1 Dec 2021 21:36:56 -0500 (EST)
Date:   Wed, 1 Dec 2021 19:36:55 -0700
From:   Michael Sartain <mikesart@fastmail.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd library: Add API to get information from trace
 file
Message-ID: <20211202023655.4nva3roddesa5lfh@mikesart-tr3>
References: <20211201022431.64763-1-mikesart@fastmail.com>
 <20211201103322.24146cd5@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211201103322.24146cd5@gandalf.local.home>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Dec 01, 2021 at 10:33:22AM -0500, Steven Rostedt wrote:
> On Tue, 30 Nov 2021 19:24:31 -0700
> Michael Sartain <mikesart@fastmail.com> wrote:
>
> > New APIs added to get trace cpustats, uname, version strings, and
> > cpu file sizes and offsets.

...

> > +const char *tracecmd_get_cpustats(struct tracecmd_input *handle);
> > +const char *tracecmd_get_uname(struct tracecmd_input *handle);
> > +const char *tracecmd_get_version(struct tracecmd_input *handle);
> > +unsigned long long tracecmd_get_cpu_file_offset(struct tracecmd_input *handle, int cpu);
> > +unsigned long long tracecmd_get_cpu_file_size(struct tracecmd_input *handle, int cpu);
>
> I wonder if we should follow normal standards here and return off64_t type
> instead of unsigned long long? As that is what is returned by lseek64().

Happy to make this change. Just to be clear, several ts and cursor
functions already in trace-cmd-private.h take "long long" parameters for
trace_ids, timestamps, offsets, time, etc. Do you have longer term plans
of migrating other things to off64_t?

> For all APIs, we require a "kernel doc" style comment. That is:
> And the rest of the functions also need a kernel doc.

Sounds good, I'm on it.

> Not to mention, we would need to add a man page to describe these too. See
> the Documentation/libtracecmd directory for examples.

This code is all in include/private/trace-cmd-private.h and it doesn't
look like any of the existing functions (like tracecmd_get_trace_clock)
have man pages.

Seems like the trace-cmd man pages all describe the trace-cmd
executable?

For background, we're wanting to add these functions to this private
header file since we're pulling trace-input.c, trace-hooks.c, and
trace-util.c into our binary (along with libtracevent) to read events
from trace.dat files. Right now tracecmd_input struct members (like
uname) are local to trace-input.c and only externally visible via
tracecmd_print_uname(). Which isn't useful to a gui app, natch.

But yeah, please let me know how you'd like to proceed. Happy to start a
man page for trace-cmd-private.h but pretty sure I'm not the best person
to document *all* the current functions in this file. :)

> > +unsigned long long tracecmd_get_cpu_file_offset(struct tracecmd_input *handle, int cpu)
>
>    Should be "unsigned int cpu"

There are a several existing functions that take an "int cpu" parameter.

Is this something where this new functions should use an unsigned int and
then update the others later, or perhaps add a check in the code for
negative cpu values and keep the "int cpu" parameter to stay consistent
with the others?

> Anyway, welcome to our community Michael!

Thanks for the feedback and warm welcome Steven - much appreciated!
Regards,
 -Mike
