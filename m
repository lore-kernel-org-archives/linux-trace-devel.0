Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B301C433ED
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Apr 2021 14:20:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3639261055
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Apr 2021 14:20:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235741AbhDBOU3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 2 Apr 2021 10:20:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:46678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234161AbhDBOU2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 2 Apr 2021 10:20:28 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F47E60201;
        Fri,  2 Apr 2021 14:20:26 +0000 (UTC)
Date:   Fri, 2 Apr 2021 10:20:25 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org, tz.stoyanov@gmail.com
Subject: Re: [PATCH 4/6] libtracefs: Move the "options" code to 
 tracefs-instance.c
Message-ID: <20210402102025.285731cf@gandalf.local.home>
In-Reply-To: <20210402101756.36879d49@gandalf.local.home>
References: <20210402131947.346235-1-y.karadz@gmail.com>
        <20210402131947.346235-5-y.karadz@gmail.com>
        <20210402101756.36879d49@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 2 Apr 2021 10:17:56 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> Do you still feel that the moving of this code is needed?


The rest of the patch series looks fine. Can you send a v2? I'll let you
and Tzvetomir decide if you want the code from this patch moved to the
instance file. But at a minimum, lets rename tracefs_option_set() to
trace_option_set().

Thanks!

-- Steve
