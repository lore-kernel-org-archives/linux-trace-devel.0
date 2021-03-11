Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1E2CC433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Mar 2021 14:55:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75CF964FAB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Mar 2021 14:55:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233571AbhCKOyz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Mar 2021 09:54:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:33258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233745AbhCKOyr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Mar 2021 09:54:47 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4503764F93;
        Thu, 11 Mar 2021 14:54:46 +0000 (UTC)
Date:   Thu, 11 Mar 2021 09:54:44 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Michal Sojka <michal.sojka@cvut.cz>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2] kernel-shark: Do not hardcode /usr prefix for polkit
 policies
Message-ID: <20210311095444.0185d807@gandalf.local.home>
In-Reply-To: <20210311145059.27147-1-michal.sojka@cvut.cz>
References: <87mtv97nlj.fsf@steelpick.2x.cz>
        <20210311145059.27147-1-michal.sojka@cvut.cz>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 11 Mar 2021 15:50:59 +0100
Michal Sojka <michal.sojka@cvut.cz> wrote:

> When one wants to install kernel-shark to a non-standard location,
> e.g., by configuring it as follows:
> 
>     cmake -D_INSTALL_PREFIX=$HOME ..
> 
> then "make install" fails, with the following error:
> 
>     CMake Error at src/cmake_install.cmake:225 (file):
>       file INSTALL cannot copy file
>       "/home/user/src/trace-cmd/kernel-shark/org.freedesktop.kshark-record.policy"
>       to "/usr/share/polkit-1/actions/org.freedesktop.kshark-record.policy".
> 
> This commit fixes that by ensuring that even the
> org.freedesktop.kshark-record.policy file is installed to the
> user-specified prefix and not to /usr where the user has no write
> permission.

Thanks for the updated change log Michal!

Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

-- Steve
