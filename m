Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5AFEC433ED
	for <linux-trace-devel@archiver.kernel.org>; Fri, 16 Apr 2021 13:34:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2313611AB
	for <linux-trace-devel@archiver.kernel.org>; Fri, 16 Apr 2021 13:34:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243896AbhDPNea (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 16 Apr 2021 09:34:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:44534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240407AbhDPNea (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 16 Apr 2021 09:34:30 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85BDE61184;
        Fri, 16 Apr 2021 13:34:05 +0000 (UTC)
Date:   Fri, 16 Apr 2021 09:34:03 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Stefano De Venuto <stefano.devenuto99@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Dario Faggioli <dfaggioli@suse.com>
Subject: Re: Combined traces evaluations
Message-ID: <20210416093403.1f58e98c@gandalf.local.home>
In-Reply-To: <a8576de6-5eae-1e27-173e-4d95b645f6a8@gmail.com>
References: <a8576de6-5eae-1e27-173e-4d95b645f6a8@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 16 Apr 2021 12:18:11 +0200
Stefano De Venuto <stefano.devenuto99@gmail.com> wrote:

> Is there something that I'm missing? What can be the cause of this
> mismatch since it only happens at the beginning of the trace?

We tell the guest to start tracing, and then tell the host to start. This
means that there are going to be missing events on the host when the host
starts tracing. That is,

tell guest to start:

guest starts:

   guest has events

guest switches to host:

<kvm_exit, but not traced>

host starts tracing:

Now we have guest events followed by host events but no kvm_exit, because
it was missed. Perhaps for guest tracing it would be wise to start the host
before the guest :-/

-- Steve
