Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A3F1C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Oct 2021 14:45:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A7D161212
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Oct 2021 14:45:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbhJSOrc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 19 Oct 2021 10:47:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:42952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229554AbhJSOrb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 19 Oct 2021 10:47:31 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1A6C6115A;
        Tue, 19 Oct 2021 14:45:17 +0000 (UTC)
Date:   Tue, 19 Oct 2021 10:45:16 -0400
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
Message-ID: <20211019104516.2df4669f@gandalf.local.home>
In-Reply-To: <ecf3bfee-8a7a-e3bf-4fba-af9bc479526e@kernel.org>
References: <cover.1634574261.git.bristot@kernel.org>
        <7e205854656f41afe9a35e6390d3e3cbd724706f.1634574261.git.bristot@kernel.org>
        <877deaut3b.fsf@meer.lwn.net>
        <f0c50222-a9a8-d0e5-d705-d9d670467142@kernel.org>
        <20211019092124.6b403ca4@gandalf.local.home>
        <ecf3bfee-8a7a-e3bf-4fba-af9bc479526e@kernel.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 19 Oct 2021 16:07:40 +0200
Daniel Bristot de Oliveira <bristot@kernel.org> wrote:

> > My suggestion came from not knowing that the man pages were going to live
> > in the kernel Documentation tree ;-)  
> 
> That is true!
> 
> Question, should we mode these files to Documentation/trace/ ?

Hmm, maybe a sub directory?

Is this really tracing, or is it another domain (analysis)?

-- Steve
