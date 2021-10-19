Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7016EC433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Oct 2021 15:25:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 537426103D
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Oct 2021 15:25:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232601AbhJSP1W (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 19 Oct 2021 11:27:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:45216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232316AbhJSP1W (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 19 Oct 2021 11:27:22 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0898B60FC2;
        Tue, 19 Oct 2021 15:25:07 +0000 (UTC)
Date:   Tue, 19 Oct 2021 11:25:06 -0400
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
Message-ID: <20211019112506.2901184a@gandalf.local.home>
In-Reply-To: <d5dc2a59-c73f-3ff0-aa4e-ed71e713c42b@kernel.org>
References: <cover.1634574261.git.bristot@kernel.org>
        <7e205854656f41afe9a35e6390d3e3cbd724706f.1634574261.git.bristot@kernel.org>
        <877deaut3b.fsf@meer.lwn.net>
        <f0c50222-a9a8-d0e5-d705-d9d670467142@kernel.org>
        <20211019092124.6b403ca4@gandalf.local.home>
        <ecf3bfee-8a7a-e3bf-4fba-af9bc479526e@kernel.org>
        <20211019104516.2df4669f@gandalf.local.home>
        <d5dc2a59-c73f-3ff0-aa4e-ed71e713c42b@kernel.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 19 Oct 2021 17:08:57 +0200
Daniel Bristot de Oliveira <bristot@kernel.org> wrote:

> > Is this really tracing, or is it another domain (analysis)?  
> 
> Hummm... it uses tracing and capture trace... but to do analysis. rtsl (tool
> inside the rtla in the future) will be even more in the analysis side....

Right. It's a user of tracing, but not a tracer itself. Which is why I'm
thinking it deserves its own category.


Jon, do you have thoughts about this?

-- Steve
