Return-Path: <SRS0=Ttn5=65=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1238DC433DF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 May 2020 13:11:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0A2D20657
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 May 2020 13:11:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbgEONL3 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 15 May 2020 09:11:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:51298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726141AbgEONL2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 15 May 2020 09:11:28 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7E4220657;
        Fri, 15 May 2020 13:11:27 +0000 (UTC)
Date:   Fri, 15 May 2020 09:11:26 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Li Xinhai" <lixinhai.lxh@gmail.com>
Cc:     linux-trace-devel <linux-trace-devel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Theodore Ts'o <tytso@mit.edu>, Tom Zanussi <zanussi@kernel.org>
Subject: Re: Documentation/trace/events.rst: wrong numbering of sections
Message-ID: <20200515091126.75db6ec9@gandalf.local.home>
In-Reply-To: <2020051515434115672512@gmail.com>
References: <2020051515434115672512@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


It's best to Cc the maintainers of the file. Nobody reads linux-kernel (it
produces 800 emails a day!). Luckily, I happen to monitor the
linux-trace-devel list (which is mostly for userland tools), otherwise this
email would have been lost to the LKML abyss.

On Fri, 15 May 2020 15:43:43 +0800
"Li Xinhai" <lixinhai.lxh@gmail.com> wrote:

> This document has below numbering of its sections:
> 
> 1. Introduction
> 2. Using Event Tracing
> 2.1 Via the 'set_event' interface
> 2.2 Via the 'enable' toggle
> 2.3 Boot option
> 3. Defining an event-enabled tracepoint
> 4. Event formats
> 5. Event filtering
> 5.1 Expression syntax
> 5.2 Setting filters
> 5.3 Clearing filters
> 5.3 Subsystem filters
> 5.4 PID filtering
> 6. Event triggers
> 6.1 Expression syntax
> 6.2 Supported trigger commands
> 6.3 In-kernel trace event API
> 6.3.1 Dyamically creating synthetic event definitions
> 6.3.3 Tracing synthetic events from in-kernel code
> 6.3.3.1 Tracing a synthetic event all at once
> 6.3.3.1 Tracing a synthetic event piecewise
> 6.3.4 Dyamically creating kprobe and kretprobe event definitions
> 6.3.4 The "dynevent_cmd" low-level API
> 
> It seems wrong numbering within 6.3 section. 
> or, would it be better to have separated chapter #7, for 'In-kernel trace
> event API'? it seems not belong to 'Event triggers'.

Yeah, 6.3.4 (both of them) probably should have been under a new top level
section. (#7).

-- Steve
