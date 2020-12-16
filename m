Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8A2EC4361B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 23:01:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1DDF23718
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 23:01:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727881AbgLPXBP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Dec 2020 18:01:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:55780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727873AbgLPXBP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Dec 2020 18:01:15 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FA6523716;
        Wed, 16 Dec 2020 23:00:34 +0000 (UTC)
Date:   Wed, 16 Dec 2020 18:00:33 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2] trace-cmd: Re-enable the build of KernelShark v1
Message-ID: <20201216180033.7592f75a@gandalf.local.home>
In-Reply-To: <20201216171944.230cc08a@gandalf.local.home>
References: <20201216130715.181002-1-y.karadz@gmail.com>
        <20201216152850.7cf69fc8@gandalf.local.home>
        <20201216171944.230cc08a@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 16 Dec 2020 17:19:44 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> Ideally, we don't want to include the libtraceevent or libtracefs system
> includes when building locally. Let me see if I can fix the make file here.

Can you apply this? It should fix the build problem with libtraceevent,
without having to touch any of its files.

  https://patchwork.kernel.org/project/linux-trace-devel/patch/20201216175138.2d1a9b34@gandalf.local.home/

-- Steve

