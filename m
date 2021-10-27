Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 743E1C433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Oct 2021 22:31:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C758610CB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Oct 2021 22:31:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbhJ0Wdw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 27 Oct 2021 18:33:52 -0400
Received: from out2.migadu.com ([188.165.223.204]:12575 "EHLO out2.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229437AbhJ0Wdw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 27 Oct 2021 18:33:52 -0400
Date:   Thu, 28 Oct 2021 06:32:04 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1635373883;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1YpDIAFQroCs85/1499wmm57xbIl4RrWHQOPQ/kVnTU=;
        b=UqAN9U2I1eMhCNdkuX7HJugkJRrcFTfLLLbYVv8Q6OuxzseZd7U3DSWeqVyMXNHokJGLTZ
        QbL3XOVYQU1UbU3bdXq7t9gNlT9BbLNEtADnvX90XFU7e1OTk6sejwEWkIjp53Uq8cEfsG
        F2cH6Ku/984w0SK1tp/BUpItxE5njIg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Tao Zhou <tao.zhou@linux.dev>
To:     Steven Rostedt <rostedt@goodmis.org>
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
        linux-kernel@vger.kernel.org, Tao Zhou <tao.zhou@linux.dev>
Subject: Re: [PATCH V6 11/20] rtla/osnoise: Add the hist mode
Message-ID: <YXnTZDteOMLomc0L@geo.homenetwork>
References: <cover.1635284863.git.bristot@kernel.org>
 <fede3c3805cb7a70bd7c8d60ba2c5ce290cc6e1e.1635284863.git.bristot@kernel.org>
 <YXmWTOXHYXFduayt@geo.homenetwork>
 <20211027142918.487cd143@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211027142918.487cd143@gandalf.local.home>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: tao.zhou@linux.dev
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Steven,

On Wed, Oct 27, 2021 at 02:29:18PM -0400, Steven Rostedt wrote:

> On Thu, 28 Oct 2021 02:11:24 +0800
> Tao Zhou <tao.zhou@linux.dev> wrote:
> 
> > > +	/* one histogram for IRQ and one for thread, per cpu */
> > > +	for (cpu = 0; cpu < nr_cpus; cpu++) {
> > > +		data->hist[cpu].samples = calloc(1, sizeof(*data->hist) * (entries + 1));  
> > 
> > @samples is a pointer to int and used for int array. The "sizeof(*data->hist)"
> > should be "sizeof(int)" or am I totally wrong.
> 
> Or standard approach is: 
> 
> 		data->hist[cpu].samples = calloc(1, sizeof(*data->hist->samples) * (entries + 1));

Right, thanks. I am not totally waken up now. Ha.


> -- Steve



Thanks,
Tao
