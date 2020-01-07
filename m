Return-Path: <SRS0=g3Xf=24=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AB72C32771
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Jan 2020 03:41:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 372AE206F0
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Jan 2020 03:41:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727384AbgAGDl7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 6 Jan 2020 22:41:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:46718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727295AbgAGDl6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 6 Jan 2020 22:41:58 -0500
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E03EB206F0;
        Tue,  7 Jan 2020 03:41:57 +0000 (UTC)
Date:   Mon, 6 Jan 2020 22:41:56 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Naruto Nguyen <narutonguyen2018@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org,
        linux-trace-users@vger.kernel.org
Subject: Re: register_jprobe always fails with -22
Message-ID: <20200106224156.119a2769@rorschach.local.home>
In-Reply-To: <CANpxKHEVmPzxU5SwQV9Ka9z5f-8EYqS=eoD0XEqMkUVQ9tiTbw@mail.gmail.com>
References: <CANpxKHEVmPzxU5SwQV9Ka9z5f-8EYqS=eoD0XEqMkUVQ9tiTbw@mail.gmail.com>
X-Mailer: Claws Mail 3.17.4git76 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
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


Sorry for the really late reply (6 months!), but this email got lost in
my inbox, and I just noticed it. In case that you are still wondering
about jprobes, they have become obsolete. Registering with the function
tracer is now the way to accomplish this.

 See https://www.kernel.org/doc/Documentation/trace/ftrace-uses.rst

-- Steve

