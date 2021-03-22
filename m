Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90664C433E1
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Mar 2021 14:57:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 445D26197F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Mar 2021 14:57:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbhCVO4q (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Mar 2021 10:56:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:32806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231251AbhCVO41 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Mar 2021 10:56:27 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E46166192D;
        Mon, 22 Mar 2021 14:56:25 +0000 (UTC)
Date:   Mon, 22 Mar 2021 10:56:24 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Stefano De Venuto <stefano.devenuto99@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Dario Faggioli <dfaggioli@suse.com>
Subject: Re: [PATCH v32 0/5]Timestamp synchronization of host - guest
 tracing session
Message-ID: <20210322105624.40aa27b1@gandalf.local.home>
In-Reply-To: <CAPpZLN7ChRzU1b2t1KSbT+MB0An=CJJxnDizaO41K=XSz8sb6g@mail.gmail.com>
References: <20210315061857.168570-1-tz.stoyanov@gmail.com>
        <6796a75b-6a59-767f-08ec-ee0cbfd8c825@gmail.com>
        <CAPpZLN6LJWV_=BB5FgQOkN+SZt3dOeYjzqZVZ-FC4JTva8zn_Q@mail.gmail.com>
        <80486620-fe8f-49a5-cdac-05bb2b969984@gmail.com>
        <CAPpZLN4yn2qn7uqNLqkxdnHfM_5SdtkjPY41atY5m-FPG3rudA@mail.gmail.com>
        <0f6e158c-43a3-4117-2a17-5a13cd6a7970@gmail.com>
        <CAPpZLN7ChRzU1b2t1KSbT+MB0An=CJJxnDizaO41K=XSz8sb6g@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 22 Mar 2021 12:13:09 +0200
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> Confirmed, the problem is in the trace-cmd logic that works with the
> KVM scaling.  Looks like tsc-scaling-ratio is the default KVM scaling
> on your machine, (1 << 32), and in that case the scaling should be
> ignored in our calculations. I still have no solution, going to
> analyze how the KVM scaling works.

I'm guessing that this was run on a AMD CPU, as the default scaling (the
one to ignore) is 1 << 32 for AMD and for Intel it's 1 << 48.

-- Steve
