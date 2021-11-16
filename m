Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D2CFC433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Nov 2021 19:50:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7890163219
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Nov 2021 19:50:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235847AbhKPTxV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 16 Nov 2021 14:53:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:35904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240184AbhKPTxT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Nov 2021 14:53:19 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D7FB61A3A;
        Tue, 16 Nov 2021 19:50:21 +0000 (UTC)
Date:   Tue, 16 Nov 2021 14:50:19 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Nicolas Saenz Julienne <nsaenzju@redhat.com>
Cc:     linux-trace-devel@vger.kernel.org, tz.stoyanov@gmail.com
Subject: Re: [PATCH] trace-cmd: Fix trace_tsc2nsec_is_supported() on !x86
Message-ID: <20211116145019.45b2a26a@gandalf.local.home>
In-Reply-To: <20211116192152.1360993-1-nsaenzju@redhat.com>
References: <20211116192152.1360993-1-nsaenzju@redhat.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 16 Nov 2021 20:21:52 +0100
Nicolas Saenz Julienne <nsaenzju@redhat.com> wrote:

> 'trace-cmd list -C' outputs 'tsc2nsec' on my arm64 machine. TSC is an
> x86 specific counter, so it shouldn't be supported. Fix this by making
> sure TSC exists as a trace clock in trace_tsc2nsec_is_supported().

TSC is just an acronym for Time Stamp Counter. Yes, x86 calls it the TSC,
but really it can be any raw clock.

If arm or any other arch has a raw clock that can write directly to the
ring buffer, and perf has a way to convert that to nsecs, we should still
be able to support it. For instance, I believe that powerpc has a ppc-tb
clock that is similar to the tsc of x86. We probably should allow that too.

Hmm, I wonder if the kernel should have a "raw_clock" if the raw time stamp
is used for any arch, and the tsc2nsec can still be used if raw_clock is
supported.

That said, I agree that we should verify that the raw clock that is
converted is available along with the perf info.

-- Steve


> 
> Signed-off-by: Nicolas Saenz Julienne <nsaenzju@redhat.com>
> ---
>  tracecmd/trace-record.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index 1767a6c..78e9566 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -6122,6 +6122,9 @@ static int get_tsc_nsec(int *shift, int *mult)
>  
>  bool trace_tsc2nsec_is_supported(void)
>  {
> +	if (!clock_is_supported(NULL, TSC_CLOCK))
> +		return false;
> +
>  	return get_tsc_nsec(NULL, NULL) == 0;
>  }
>  

