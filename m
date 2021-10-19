Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38C53C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Oct 2021 13:21:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E1CE610E7
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Oct 2021 13:21:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235862AbhJSNXl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 19 Oct 2021 09:23:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:60820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235622AbhJSNXk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 19 Oct 2021 09:23:40 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A025961374;
        Tue, 19 Oct 2021 13:21:26 +0000 (UTC)
Date:   Tue, 19 Oct 2021 09:21:24 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Daniel Bristot de Oliveira <bristot@kernel.org>
Cc:     Jonathan Corbet <corbet@lwn.net>, Ingo Molnar <mingo@redhat.com>,
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
Subject: Re: [PATCH V3 13/19] rtla: Add Documentation
Message-ID: <20211019092124.6b403ca4@gandalf.local.home>
In-Reply-To: <f0c50222-a9a8-d0e5-d705-d9d670467142@kernel.org>
References: <cover.1634574261.git.bristot@kernel.org>
        <7e205854656f41afe9a35e6390d3e3cbd724706f.1634574261.git.bristot@kernel.org>
        <877deaut3b.fsf@meer.lwn.net>
        <f0c50222-a9a8-d0e5-d705-d9d670467142@kernel.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 19 Oct 2021 14:56:15 +0200
Daniel Bristot de Oliveira <bristot@kernel.org> wrote:

> I am not a document format specialist, neither have a strong opinion on this, so
> suggestions are welcome. I used this format as a suggestion from steven, it is
> also similar to what we have on perf...

My suggestion came from not knowing that the man pages were going to live
in the kernel Documentation tree ;-)

> 
> The idea here is to create a set of man pages. I saw that it is possible to
> create man pages using Sphinx, but there are so many options that it is hard to
> get started...
> 
> I also noticed that bpftools uses .rst files, but uses rst2man to convert the files.
> 
> Converting the current files to .rst is easy.
> 
> So, could give me some directions on what you think would be the best way to
> create this set of man pages?
> 
> A link to a project that creates a set of man pages using Sphinx using a
> Makefile would be a plus :-).


If everyone is OK with converting to .rst and using rst2man I'm fine with
that.

-- Steve
