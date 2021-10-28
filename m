Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F13B0C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Oct 2021 02:54:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD66B610FF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Oct 2021 02:54:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbhJ1C5O (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 27 Oct 2021 22:57:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:41744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229534AbhJ1C5O (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 27 Oct 2021 22:57:14 -0400
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E343F60527;
        Thu, 28 Oct 2021 02:54:46 +0000 (UTC)
Date:   Wed, 27 Oct 2021 22:54:45 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Daniel Bristot de Oliveira <bristot@kernel.org>
Cc:     Tao Zhou <tao.zhou@linux.dev>, Ingo Molnar <mingo@redhat.com>,
        Tom Zanussi <zanussi@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Clark Williams <williams@redhat.com>,
        John Kacur <jkacur@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users@vger.kernel.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V6 07/20] rtla: Real-Time Linux Analysis tool
Message-ID: <20211027225445.0325be0f@rorschach.local.home>
In-Reply-To: <60dbd3e36ac9489b6aadbc1c3d095608e6c7e4bb.1635284863.git.bristot@kernel.org>
References: <cover.1635284863.git.bristot@kernel.org>
        <60dbd3e36ac9489b6aadbc1c3d095608e6c7e4bb.1635284863.git.bristot@kernel.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 27 Oct 2021 00:06:18 +0200
Daniel Bristot de Oliveira <bristot@kernel.org> wrote:

> The rtla is a meta-tool that includes a set of commands that aims
> to analyze the real-time properties of Linux. But instead of testing
> Linux as a black box, rtla leverages kernel tracing capabilities to
> provide precise information about the properties and root causes of
> unexpected results.
> 
> rtla --help works and provide information about the available options.
>

BTW,

I would break this up into two separate series.

One for the kernel changes [ patches 1-6 ] and then one for the tooling
[ patches 7 - 20 ].

That will make it better for versioning. And you really shouldn't have
the two mixed together. Just state in the cover letter of the tooling 
[ Depends on the series at: ...] 

And include the lore link.

BTW, you may resend a fixed version of 1-6 ;-)

-- Steve
