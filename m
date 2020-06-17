Return-Path: <SRS0=X5V/=76=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C68A2C433E1
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Jun 2020 16:06:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB5C421527
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Jun 2020 16:06:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726815AbgFQQGY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Jun 2020 12:06:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:44746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726594AbgFQQGY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Jun 2020 12:06:24 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8506F2065F;
        Wed, 17 Jun 2020 16:06:23 +0000 (UTC)
Date:   Wed, 17 Jun 2020 12:06:21 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Maximilian Werner <maximilian.werner96@gmail.com>
Cc:     Sascha Ortmann <sascha.ortmann@stud.uni-hannover.de>,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        linux-trace-devel@vger.kernel.org, linux-kernel@i4.cs.fau.de,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: Re: [PATCH] tracing/boottime: Fix kprobe multiple events
Message-ID: <20200617120621.652864d9@oasis.local.home>
In-Reply-To: <3e6495df-065f-34c5-8e21-65764c79d6ca@gmail.com>
References: <20200617140817.17161-1-sascha.ortmann@stud.uni-hannover.de>
        <20200617110521.7ed41fdd@oasis.local.home>
        <20200617110617.2a06c143@oasis.local.home>
        <3e6495df-065f-34c5-8e21-65764c79d6ca@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 17 Jun 2020 17:57:13 +0200
Maximilian Werner <maximilian.werner96@gmail.com> wrote:

> We are a group of students from Leibniz University Hannover and
> this patch is part of a project of ours. That's why both of us
> signed this off.

Usually, if there's two people signed off, there's a comment in the
change log that states the other person worked on the patch as well.

> 
> Should we have added Masami to Cc? He didn't appear in the
> get_maintainer script.
> 

Yeah, we need to update the MAINTAINER's file to fix that. Not your
fault.

-- Steve
