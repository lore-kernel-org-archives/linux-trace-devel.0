Return-Path: <SRS0=9eMf=2K=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE948C43603
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Dec 2019 20:52:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C8D7218AC
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Dec 2019 20:52:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727422AbfLTUwY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Dec 2019 15:52:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:45436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727402AbfLTUwY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Dec 2019 15:52:24 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B2E520866;
        Fri, 20 Dec 2019 20:52:23 +0000 (UTC)
Date:   Fri, 20 Dec 2019 15:52:21 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v18 13/18] trace-cmd: Add guest information in host's
 trace.dat file
Message-ID: <20191220155221.6face370@gandalf.local.home>
In-Reply-To: <20191213153029.133570-14-tz.stoyanov@gmail.com>
References: <20191213153029.133570-1-tz.stoyanov@gmail.com>
        <20191213153029.133570-14-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 13 Dec 2019 17:30:24 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> New trace.dat option is introduced: TRACECMD_OPTION_GUEST.
> Written in the host's trace.dat file, it contains information about
> guests, traced at the same time: guest trace ID, number of VCPUs and
> PIDs of the host tasks, running those VCPU. The data is stored in
> the file as NULL terminated string:
> 	"Guest %s %llu %d\n" -> guest name, number of VCPUs
> 	"%d %d\n" -> VCPU, PID of host task
> 	.....
> 	"%d %d\n" -> VCPU, PID of host task

Why is this a string, and not a structure?

-- Steve
