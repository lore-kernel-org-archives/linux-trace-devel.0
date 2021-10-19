Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 363DDC433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Oct 2021 15:36:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AD03610A1
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Oct 2021 15:36:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232448AbhJSPin (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 19 Oct 2021 11:38:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:52192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234207AbhJSPid (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 19 Oct 2021 11:38:33 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD915610A1;
        Tue, 19 Oct 2021 15:36:19 +0000 (UTC)
Date:   Tue, 19 Oct 2021 11:36:18 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Jonathan Corbet <corbet@lwn.net>
Cc:     Daniel Bristot de Oliveira <bristot@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
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
Message-ID: <20211019113618.02bcdf8b@gandalf.local.home>
In-Reply-To: <8735oxt4ny.fsf@meer.lwn.net>
References: <cover.1634574261.git.bristot@kernel.org>
        <7e205854656f41afe9a35e6390d3e3cbd724706f.1634574261.git.bristot@kernel.org>
        <877deaut3b.fsf@meer.lwn.net>
        <f0c50222-a9a8-d0e5-d705-d9d670467142@kernel.org>
        <20211019092124.6b403ca4@gandalf.local.home>
        <ecf3bfee-8a7a-e3bf-4fba-af9bc479526e@kernel.org>
        <8735oxt4ny.fsf@meer.lwn.net>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 19 Oct 2021 09:28:33 -0600
Jonathan Corbet <corbet@lwn.net> wrote:

> My first reaction would be to make a new directory like
> Documentation/tools and put man pages there.  That can become a new
> "book" within the larger documentation collection.  Make sense?

Sounds good to me. Daniel?

-- Steve
