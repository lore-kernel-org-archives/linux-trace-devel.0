Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 525E6C433ED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 14 Apr 2021 19:07:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2498661166
	for <linux-trace-devel@archiver.kernel.org>; Wed, 14 Apr 2021 19:07:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbhDNTIQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 14 Apr 2021 15:08:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:57962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229899AbhDNTIQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 14 Apr 2021 15:08:16 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CAEF61042;
        Wed, 14 Apr 2021 19:07:54 +0000 (UTC)
Date:   Wed, 14 Apr 2021 15:07:52 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Andrew Cooper <andrew.cooper3@citrix.com>
Cc:     Dario Faggioli <dfaggioli@suse.com>,
        Giuseppe Eletto <giuseppe.eletto@edu.unito.it>,
        <linux-trace-devel@vger.kernel.org>,
        <xen-devel@lists.xenproject.org>,
        Enrico Bini <enrico.bini@unito.it>
Subject: Re: A KernelShark plugin for Xen traces analysis
Message-ID: <20210414150752.34366b99@gandalf.local.home>
In-Reply-To: <7184a7d7-6bca-4106-d70e-8cf9d5b227fb@citrix.com>
References: <CALTQNB5X1+G33Qoh5nNxttQe_GkzKvJFLfEXQszsc6XYr+NgUA@mail.gmail.com>
        <f33b39a5-9bbd-934f-a9cd-c536a0ba7416@citrix.com>
        <eefc512b8c1ac26c4eaae81e79ee0243901a3de2.camel@suse.com>
        <7184a7d7-6bca-4106-d70e-8cf9d5b227fb@citrix.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 14 Apr 2021 19:11:19 +0100
Andrew Cooper <andrew.cooper3@citrix.com> wrote:

> Where the plugin (ought to) live depends heavily on whether we consider
> the trace format a stable ABI or not.

Agreed. Like the VMware plugin to handle ESX traces. It's internal and not
published as the API is not stable.

But if it ever becomes stable, and you would like it to live with
KernelShark, we are looking to have a place to store third party plugins.

We are working to make sure that the API for KernelShark plugins remains
stable, so your plugins should always work too.

-- Steve
