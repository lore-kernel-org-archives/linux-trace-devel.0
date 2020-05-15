Return-Path: <SRS0=Ttn5=65=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61111C433DF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 May 2020 18:22:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D02B20728
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 May 2020 18:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1589566965;
	bh=8Rdr4KgCe61j3i5Gbg/0zblgtQpNudQNhrLSoEf4e9M=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:List-ID:From;
	b=aov6XfWzdQVunE6WCnglg2F8e++/nV7/9NbuNZFymRR+EYwxdCwWxvDy0vRSFaw3+
	 IwVv+oT68HZGwnJi1eH2x3nsq8atSnB4i096P7IxzrxVcZxufd28URtolP9R6Nvul0
	 B3/+7KrYKFHTTILSb3dmDPU2XxFlSGx4Jgy8l7kU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726212AbgEOSWp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 15 May 2020 14:22:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:46512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbgEOSWo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 15 May 2020 14:22:44 -0400
Received: from tzanussi-mobl (c-98-220-238-81.hsd1.il.comcast.net [98.220.238.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D478020727;
        Fri, 15 May 2020 18:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589566964;
        bh=8Rdr4KgCe61j3i5Gbg/0zblgtQpNudQNhrLSoEf4e9M=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=QXuk8PkzHnECJQ8yekOoDSj+Y/YT9AwK93su5BXadrMnGDmV6QG347OVXI5kZmQRA
         8lCWfklXYoF6UO3AwaXWTILlInW3lMPgZwKMh0u5jyr00iZVX30SIjcC3CgiO4Qf1c
         OZfThZ1w95WtD/uQSPHIOj0bSODH63Gx7voR8pXA=
Message-ID: <2449de9a39bd09510f75bd2358cc7ddfd397e93f.camel@kernel.org>
Subject: Re: Documentation/trace/events.rst: wrong numbering of sections
From:   Tom Zanussi <zanussi@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>,
        Li Xinhai <lixinhai.lxh@gmail.com>
Cc:     linux-trace-devel <linux-trace-devel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Theodore Ts'o <tytso@mit.edu>
Date:   Fri, 15 May 2020 13:22:42 -0500
In-Reply-To: <20200515091126.75db6ec9@gandalf.local.home>
References: <2020051515434115672512@gmail.com>
         <20200515091126.75db6ec9@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi,

On Fri, 2020-05-15 at 09:11 -0400, Steven Rostedt wrote:
> It's best to Cc the maintainers of the file. Nobody reads linux-
> kernel (it
> produces 800 emails a day!). Luckily, I happen to monitor the
> linux-trace-devel list (which is mostly for userland tools),
> otherwise this
> email would have been lost to the LKML abyss.
> 
> On Fri, 15 May 2020 15:43:43 +0800
> "Li Xinhai" <lixinhai.lxh@gmail.com> wrote:
> 
> > This document has below numbering of its sections:
> > 
> > 1. Introduction
> > 2. Using Event Tracing
> > 2.1 Via the 'set_event' interface
> > 2.2 Via the 'enable' toggle
> > 2.3 Boot option
> > 3. Defining an event-enabled tracepoint
> > 4. Event formats
> > 5. Event filtering
> > 5.1 Expression syntax
> > 5.2 Setting filters
> > 5.3 Clearing filters
> > 5.3 Subsystem filters
> > 5.4 PID filtering
> > 6. Event triggers
> > 6.1 Expression syntax
> > 6.2 Supported trigger commands
> > 6.3 In-kernel trace event API
> > 6.3.1 Dyamically creating synthetic event definitions
> > 6.3.3 Tracing synthetic events from in-kernel code
> > 6.3.3.1 Tracing a synthetic event all at once
> > 6.3.3.1 Tracing a synthetic event piecewise
> > 6.3.4 Dyamically creating kprobe and kretprobe event definitions
> > 6.3.4 The "dynevent_cmd" low-level API
> > 
> > It seems wrong numbering within 6.3 section. 
> > or, would it be better to have separated chapter #7, for 'In-kernel 
> > trace
> > event API'? it seems not belong to 'Event triggers'.
> 
> Yeah, 6.3.4 (both of them) probably should have been under a new top
> level
> section. (#7).
> 

Yeah, aside from duplicate numbering in a couple of places, it would
make more sense for everything starting from '6.3 In-kernel trace event
API' to be in a section 7.

Would you like to submit a patch for that, Li, or should I?

Thanks,

Tom

> -- Steve

