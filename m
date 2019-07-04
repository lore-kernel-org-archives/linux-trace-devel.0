Return-Path: <SRS0=uWkg=VB=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B90EC06513
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Jul 2019 12:55:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50109218BE
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Jul 2019 12:55:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbfGDMzh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 4 Jul 2019 08:55:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:58178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726614AbfGDMzh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 4 Jul 2019 08:55:37 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8ED02189E;
        Thu,  4 Jul 2019 12:55:35 +0000 (UTC)
Date:   Thu, 4 Jul 2019 08:55:34 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Naruto Nguyen <narutonguyen2018@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org,
        linux-trace-users@vger.kernel.org
Subject: Re: register_jprobe always fails with -22
Message-ID: <20190704085534.1c9c8a29@gandalf.local.home>
In-Reply-To: <CANpxKHEVmPzxU5SwQV9Ka9z5f-8EYqS=eoD0XEqMkUVQ9tiTbw@mail.gmail.com>
References: <CANpxKHEVmPzxU5SwQV9Ka9z5f-8EYqS=eoD0XEqMkUVQ9tiTbw@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 4 Jul 2019 16:03:42 +0700
Naruto Nguyen <narutonguyen2018@gmail.com> wrote:

> Hi everyone,
> 
> I tried to write a sample jprobe as the link
> https://bugzilla.redhat.com/show_bug.cgi?id=1275809 (the sample is
> attached in the link). However the function register_jprobes always
> return -22 or -2. Could you please let me know what these errors means
> and how to fix it?
> 

Note, jprobes have been removed from the kernel. They have been
obsoleted by registering with the function tracer.

See Documentation/trace/ftrace-uses.rst in the kernel source code.

-- Steve
