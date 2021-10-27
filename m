Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11376C433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Oct 2021 16:37:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D72BB60EB4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Oct 2021 16:37:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236750AbhJ0Qjb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 27 Oct 2021 12:39:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:54690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233805AbhJ0Qjb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 27 Oct 2021 12:39:31 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28BEB60232;
        Wed, 27 Oct 2021 16:37:04 +0000 (UTC)
Date:   Wed, 27 Oct 2021 12:37:02 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Daniel Bristot de Oliveira <bristot@kernel.org>
Cc:     Tao Zhou <tao.zhou@linux.dev>, Ingo Molnar <mingo@redhat.com>,
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
Subject: Re: [PATCH V6 08/20] rtla: Helper functions for rtla
Message-ID: <20211027123702.09564df2@gandalf.local.home>
In-Reply-To: <575a2d6b-9e37-5566-9343-e77e4f4e8c1f@kernel.org>
References: <cover.1635284863.git.bristot@kernel.org>
        <183637700a31169e5d6d1c8a827c5365599ec806.1635284863.git.bristot@kernel.org>
        <YXlcBhnqiKVxV4UX@geo.homenetwork>
        <575a2d6b-9e37-5566-9343-e77e4f4e8c1f@kernel.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 27 Oct 2021 18:24:01 +0200
Daniel Bristot de Oliveira <bristot@kernel.org> wrote:

> Steven, I am tempted to start placing fixes patches on top of this series. What
> do you think?

Please don't. But you can also wait a few days before you post another
version. You don't need to post a new version for every comment. Especially
when the reviewers are not done reviewing the patches.

The default is to wait a week, although I would say at least wait 3 days
after the last comment was made.

-- Steve
