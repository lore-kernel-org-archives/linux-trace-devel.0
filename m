Return-Path: <SRS0=BCkm=VO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 708D0C7618F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Jul 2019 00:24:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B9212182B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Jul 2019 00:24:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728699AbfGQAYr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 16 Jul 2019 20:24:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:52284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726954AbfGQAYq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Jul 2019 20:24:46 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D909E20659;
        Wed, 17 Jul 2019 00:24:45 +0000 (UTC)
Date:   Tue, 16 Jul 2019 20:24:44 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Yordan Karadzhov <y.karadz@gmail.com>
Subject: Re: [PATCH 0/4] kernel-shark: The road to 1.0
Message-ID: <20190716202444.413809fa@gandalf.local.home>
In-Reply-To: <20190710134636.116362181@goodmis.org>
References: <20190710134636.116362181@goodmis.org>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 10 Jul 2019 09:46:36 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> Some fixes for getting to 1.0.
> 
> Steven Rostedt (VMware) (3):
>       revert: "kernel-shark: Remove a duplicate error message"
>       kernel-shark: Show the standard error of kshark-record
>       kernel-shark: Use '<br>' for dialog and '\n' for console error messages
> 
> Yordan Karadzhov (VMware) (1):
>       kernel-shark: Remove the "make install" suggestion for capture errors
> 

Hi Yordan,

Can you review these patches?

Thanks!

-- Steve
